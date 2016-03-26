#include <stdio.h>
#include <stdlib.h>
#include <time.h>

//cuda include
#include <cuda.h>
#include <curand.h>
#include <curand_kernel.h>
/*
#define BLOCKNUM 100
#define THREADNUM 150
*/
__global__ void GSrand(curandState *state, unsigned int seed){
  int index = blockIdx.x * blockDim.x * threadIdx.x;

  curand_init(seed, index, 0, &state[index]);
}

__device__ float Grand(curandState *state){
  int index = blockIdx.x * blockDim.x + threadIdx.x;
  curandState local_state = state[index];

  float rand_num = curand_uniform(&local_state);

  state[index] = local_state;

  return rand_num;
}

__global__ void testRand(float *rand_data, curandState *state){
  int index = blockIdx.x * blockDim.x + threadIdx.x;

  rand_data[index] = Grand(state);
}

int main(int argc, char *argv[]){
  int BLOCKNUM = atoi(argv[1]);
  int THREADNUM = atoi(argv[2]);

  //data initialization
  int data_length = BLOCKNUM * THREADNUM;
  curandState *dev_state;
  cudaMalloc((void**) &dev_state, sizeof(curandState) * data_length);

  //random initialization
  GSrand<<<BLOCKNUM, THREADNUM>>>(dev_state, (unsigned int)time(NULL));

  //malloc host & device data
  float *host_rand_data = (float*)malloc(sizeof(float) * data_length);
  float *dev_rand_data;
  cudaMalloc((void**) &dev_rand_data, sizeof(float) * data_length);

  //get rand data
  testRand<<<BLOCKNUM, THREADNUM>>>(dev_rand_data, dev_state);

  //cpy data from dev to host
  cudaMemcpy((void*) host_rand_data, (const void*) dev_rand_data, sizeof(float) * data_length, cudaMemcpyDeviceToHost);

  //output result
  printf("RAND RESULT:~~\n");
  int i;
  for(i=0; i<data_length; ++i){
    printf("%d: %f\n", i, host_rand_data[i]);
  }

  return 0;
}
