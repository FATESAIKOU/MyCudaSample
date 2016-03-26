#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <unistd.h>
#include <string>

#include <cuda.h>

#define ThreadNum 256
#define BlockNum 16

__global__ void printOut(char *string) {
    printf("%s\n", string);
}

size_t getFileSize(char *filename) {
    struct stat st;
    stat(filename, &st);

    return st.st_size;
}

void parsing(char *aim, long int **offset_table, int *entry) {
    int limit = 1024;
    int i;

    long int *tmp_offset = (long int*) malloc(sizeof(long int) * limit);
    char *token = strtok(aim, "\n");
    for (i = 0; token != NULL; i ++) {
        if (i == limit) {
            limit += 1024;
            tmp_offset = (long int*) realloc(tmp_offset, sizeof(long int) * limit);
        }

        tmp_offset[i] = token - aim;
        token = strtok(NULL, "\n");
    }
    printf("Count %d\n", i);

    // realloc table
    tmp_offset = (long int*) realloc(tmp_offset, sizeof(long int) * i);

    // assign & return
    *offset_table = tmp_offset;
    *entry = i;
}

__device__ int strlen(char *s) {
    int i = 0;
    while (s[i] != '\0') i ++;

    return i;
}

__device__ char *strstrDevice(char *a, char *b) {
    int i, j;
    int a_len = strlen(a);
    int b_len = strlen(b);
    int loop_limit = a_len - b_len + 1;

    for (i = 0; i < loop_limit; i ++) {
        for (j = 0; j < b_len && a[i + j] == b[j]; j ++);

        if (j == b_len) return a + i;
    }

    return NULL;
}

__global__ void matching(char *aim, char *string, long int *offset_table, int entry, int base, int *result) {
    int t_id = threadIdx.x;
    int b_id = blockIdx.x;
    int b_dim = blockDim.x;

    int index = base + b_id * b_dim + t_id;
    //int aim_len = offset_table[index + 1] - offset_table[index];

    //if (index < entry && strstrDevice(string + offset_table[index], aim_len, "apple", 5) != NULL) {
    if (index < entry && strstrDevice(string + offset_table[index], aim) != NULL) {
        result[index] = 1;
    } else {
        result[index] = 0;
    }
}

int myCmp(const void *a, const void *b) {
    return (*(int*) a) - (*(int*) b);
}

int main(int argc, char *argv[]) {
    char *filename = argv[1];
    int fd = open(filename, O_RDONLY, 0644);

    // get mmap data
    size_t file_len = getFileSize(filename) + 1;
    char *filecontent = (char*) mmap(NULL,  file_len, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
    filecontent[file_len - 1] = '\0';

    // parsing
    long int *offset_table;
    int entry;
    parsing(filecontent, &offset_table, &entry);

    // copy data to device
    char *HD_filecontent;
    cudaMalloc(&HD_filecontent, file_len);
    cudaMemcpy(HD_filecontent, filecontent, file_len, cudaMemcpyHostToDevice);

    // copy offset table to device
    long int *D_offset_table;
    cudaMalloc(&D_offset_table, sizeof(long int) * entry);
    cudaMemcpy(D_offset_table, offset_table, sizeof(long int) * entry, cudaMemcpyHostToDevice);

    // matching
    int round_limit = ceil(entry / (float) (ThreadNum * BlockNum));
    int i;
    int *result;
    cudaMallocManaged(&result, sizeof(int) * entry);
    char *aim;
    cudaMallocManaged(&aim, sizeof(char) * 6);
    strcpy(aim, "apple");
    cudaDeviceSynchronize();
    for (i = 0; i < round_limit; i ++) {
        matching<<<BlockNum, ThreadNum>>>(aim, HD_filecontent, D_offset_table, entry, i * ThreadNum * BlockNum, result);
    }
    cudaDeviceSynchronize();

    qsort(result, entry, sizeof(int), myCmp);

    return 0;
}
