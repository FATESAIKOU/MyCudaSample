#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cuda.h>

#define MAX_LENGTH 1000000000

__global__ void print(char ***strs, int record_num, int col_num) {
    int t_id = threadIdx.x;
    int i;

    if (t_id < record_num) {
        printf("---t_id %d---\n", t_id);
        for (i = 0; i < col_num; i ++) {
            printf("\tattr %d: %s\n", i, strs[t_id][i]);
        }
    }
}
int main(int argc, char *argv[]) {
    char ***records;

    int i, j, record_num = 102400, col_num = 12;
    cudaMallocManaged(&records, sizeof(char**) * record_num);

    int str_len;
    for (i = 0; i < record_num; i ++) {
        cudaMallocManaged(&records[i], sizeof(char*) * col_num);

        for (j = 0; j < col_num; j ++) {
            str_len = strlen("Hello world\n");
            cudaMallocManaged(&records[i][j], sizeof(char) * str_len);
            strcpy(records[i][j], "Hello world\n");
        }
    }

    cudaDeviceSynchronize();

    print<<<1, 2>>>(records, record_num, col_num);

    cudaDeviceReset();

    return 0;
}

