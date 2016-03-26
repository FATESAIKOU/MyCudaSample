#include <stdio.h>
#include <stdlib.h>

// cuda include
#include <cuda.h>
#include <curand.h>
#include <curand_kernel.h>

__device__ float Grand(curandState *state){
  int index = blockIdx.x * blockDim.x + threadIdx.x;

  curandState local_state = state[index];
  float rand_num = curand_uniform(&local_state);
  state[index] = local_state;

  return rand_num;
}

__device__ int GrandInt(curandState *state, int limit){
  float rand_num = Grand(state) * (limit + 1);

  return (int)rand_num;
}

__global__ void GSrand(curandState *state, unsigned int seed){
  int index = blockIdx.x * blockDim.x + threadIdx.x;

  curand_init(seed, index, 0, &state[index]);
}
