#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>

__global__ static void getTime(clock_t *time){
    *time = clock();
}

int main(){
    clock_t *now_time, real_time;

    cudaMalloc((void**) &now_time, sizeof(clock_t));
    getTime<<<1, 1, 0>>>(now_time);
    cudaMemcpy(&real_time, now_time, sizeof(clock_t), cudaMemcpyDeviceToHost);

    printf("clock(): %ld\n getTime(): %ld\n", clock(), real_time);

    return 0;
}
