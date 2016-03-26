#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cuda.h>

#define ThreadNum 256

__global__ void printBase(int **base, int length) {
    int t_id = threadIdx.x;
    int b_id = blockIdx.x;

    if (t_id < length) {
        printf("block:%d-%d : %d\n", b_id, t_id, base[b_id][t_id]);
    }
}

int main(int agrc, char *argv[]) {
    int limit = atoi(argv[1]);
    int **base;

    cudaMallocManaged(&base, sizeof(int*) * limit);
    cudaDeviceSynchronize();

    int i, j;
    for (i = 0; i < limit; i ++) {
        cudaMallocManaged(&base[i], sizeof(int) * 256);
        for (j = 0; j < ThreadNum; j ++) {
            base[i][j] = i * 1000 + j;
        }
    }

    int block_num = limit;
    printBase<<<block_num, ThreadNum>>>(base, ThreadNum);
    cudaDeviceSynchronize();

    cudaDeviceReset();
    cudaFree(base);

    return 0;
}
