#include <stdio.h>
#include <stdlib.h>

// cuda include
#include <cuda.h>
#include <curand.h>
#include <curand_kernel.h>

typedef struct{
  int *gene;
  int fitness;
}Indiv;

__device__ float Grand(curandState *state){
  //get index
  int index = blockIdx.x * blockDim.x + threadIdx.x;

  //gen local_state
  curandState local_state = state[index];

  //get rand_num
  float rand_num = curand_uniform(&local_state);

  //write back rand status
  state[index] = local_state;

  //return rand_num
  return rand_num;
}

__device__ int randLimit(int limit, curandState *state){
  float f_rand = Grand(state) * (limit + 1);
  return (int)f_rand;
}

__device__ void GSrand(curandState *state, unsigned int seed){
  int index = blockIdx.x * blockDim.x + threadIdx.x;

  curand_init(seed, index, 0, &state[index]);
}

__device__ int getParent(Indiv *source_space, int CCE){
  int ans = 0;

  return ans;
}

__device__ Indiv newIndiv(Indiv *source_space, int CCE, int gene_size){
  Indiv new_indiv;

  // get parents
  int *father = source_space[getParent(source_space, CCE)].gene;
  int *mother = source_space[getParent(source_space, CCE)].gene;

  // get gene space
  new_indiv.gene = (int*)malloc(sizeof(int) * gene_size);

  // gen new gene

  return new_indiv;
}

__global__ void newGeneration(Indiv *pre_generation, Indiv *now_generation){
  ;
}
