#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>

#define DATASIZE 1048756
#define THREADNUM 128

int data[DATASIZE];

void GenerateNumbers(int *numbers, int size){
    for(int i=0; i<size; i++){
        numbers[i] = 1;
    }
}

__global__ static void sumOfSquare(int *num, int *result){
    const int t_id = threadIdx.x;
    float tmp_size = DATASIZE/(float)THREADNUM;
    const int size = tmp_size==(int)tmp_size? (int)tmp_size:(int)tmp_size+1;

    int i, sum = 0;

    for(i=t_id*size; i<(t_id+1)*size; i++){
        sum += num[i]*num[i];
    }
    result[t_id] = sum;
}

int main(){
    GenerateNumbers(data, DATASIZE);

    int *gpudata, *result;
    clock_t start;

    cudaMalloc((void**) &gpudata, sizeof(int)*DATASIZE);
    cudaMalloc((void**) &result, sizeof(int)*THREADNUM);
    cudaMemcpy(gpudata, data, sizeof(int)*DATASIZE, cudaMemcpyHostToDevice);

    start = clock();

    sumOfSquare<<<1, THREADNUM, 0>>>(gpudata, result);

    int sum[THREADNUM];
    cudaMemcpy(&sum, result, sizeof(int)*THREADNUM, cudaMemcpyDeviceToHost);

    int final_sum = 0, i;
    for(i=0; i<THREADNUM; i++){
        final_sum += sum[i];
    }
    printf("GPU: the answer is %d(time: %ld)\n", final_sum, clock()-start);

    cudaFree(gpudata);
    cudaFree(result);

    start = clock();
    for(final_sum=0, i=0; i<DATASIZE; i++){
        final_sum += data[i]*data[i];
    }
    printf("CPU: the answer is %d(time: %ld)\n", final_sum, clock()-start);

    return 0;
}
