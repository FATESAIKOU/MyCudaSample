#include <stdio.h>
#include <stdlib.h>

//cuda include
#include <cuda.h>
#include <curand.h>
#include <curand_kernel.h>

#include "common.h"
#include "rand.h"

__device__ void *arrayShuffle(void *array, int ele_size, int length, curandState *state){
  int i, rand_num;

  for(i=0; i<length; ++i){
    rand_num = GrandInt(state, length);
    Gswap((char*) array + i, (char*) array + rand_num, ele_size);
  }

  return array;
}
