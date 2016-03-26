#include <stdio.h>
#include <stdlib.h>

//cuda include
#include <cuda.h>

__device__ void Gswap(void *from, void *to, int length){
  void *tmp = malloc(length);

  memcpy(tmp, to, length);
  memcpy(to, from, length);
  memcpy(from, tmp, length);
}
