#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <curand.h>
#include <curand_kernel.h>

#define THREADNUM 512

__device__ float randGpu(curandState *global_state, int ind){
  //int ind = threadIdx.x;
  curandState local_state = global_state[ind];
  float rand_num = curand_uniform(&local_state);
  global_state[ind] = local_state;

  return rand_num;
}

__global__ void setupKernel(curandState *states, unsigned long seed){
  int ind = threadIdx.x;
  curand_init(seed, ind, 0, &states[ind]);
}

__global__ void genRandom(float *data, curandState *global_state){
  int ind = threadIdx.x;
  data[ind] = randGpu(global_state, ind);
}

int main(){
  float *data, *G_data;
  data = (float*)malloc(sizeof(float) * THREADNUM);
  cudaMalloc((void**) &G_data, sizeof(float) * THREADNUM);

  curandState *dev_states;
  cudaMalloc((void**) &dev_states, sizeof(curandState) * THREADNUM);

  setupKernel<<<1, THREADNUM>>>(dev_states, unsigned(time(NULL)));
  genRandom<<<1, THREADNUM>>>(G_data, dev_states);

  cudaMemcpy(data, G_data, sizeof(float) * THREADNUM, cudaMemcpyDeviceToHost);

  int i;
  for(i=0; i<THREADNUM; i++){
    printf("%f\n", data[i]);
  }

  return 0;
}
