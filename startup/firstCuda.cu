#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>

#define DATASIZE 1048756

int data[DATASIZE];

void GenerateNumbers(int *numbers, int size){
    for(int i=0; i<size; i++){
        numbers[i] = 1;
    }
}

__global__ static void sumOfSquare(int *num, int *result, int size){
    int i, sum = 0;

    for(i=0; i<size; i++){
        sum += num[i]*num[i];
    }

    *result = sum;
}

int main(int argc, char *argv[]){
    GenerateNumbers(data, DATASIZE);

    int *gpudata, *result;

    cudaMalloc((void**) &gpudata, sizeof(int)*DATASIZE);
    cudaMalloc((void**) &result, sizeof(int));
    cudaMemcpy(gpudata, data, sizeof(int)*DATASIZE, cudaMemcpyHostToDevice);

    sumOfSquare<<<1, atoi(argv[1]), 0>>>(gpudata, result, DATASIZE);

    int sum;
    cudaMemcpy(&sum, result, sizeof(int), cudaMemcpyDeviceToHost);
    cudaFree(gpudata);
    cudaFree(result);

    printf("the answer is %d\n", sum);
}

