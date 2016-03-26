#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <cuda.h>
#include <curand.h>
#include <curand_kernel.h>

#define THREADNUM 4
#define BLOCKNUM 4

__device__ float G_rand(curandState *states, int ind){
    curandState local_state = states[ind];
    float rand_num = curand_uniform(&local_state);
    //states[ind] = local_state;

    return rand_num;
}

__global__ void G_srand(curandState *states, unsigned long seed){
    int ind = threadIdx.x;
    //what is curand_init
    curand_init(seed, ind, 0, &states[ind]);
}

__global__ void G_testRand(double *tmp_space, curandState *states){
  int t_id = threadIdx.x;
  int b_id = blockIdx.x;

  tmp_space[(b_id * THREADNUM) + t_id] = G_rand(states, t_id);

  return;
}

int main(){

    // initialize for parallel computation
    curandState *dev_states;
    cudaMalloc((void**) &dev_states, sizeof(curandState) * THREADNUM);
    G_srand<<<BLOCKNUM, THREADNUM>>>(dev_states, unsigned(time(NULL)));

    // prepering for args space
    double *G_rand, *C_rand;
    cudaMalloc((void**) &G_rand, sizeof(double) * BLOCKNUM * THREADNUM);
    C_rand = (double*)malloc(sizeof(double) * BLOCKNUM * THREADNUM);

    // calculation
    G_testRand<<<BLOCKNUM, THREADNUM>>>(G_rand, dev_states);

    // copy back to MainMemory
    cudaMemcpy(C_rand, G_rand, sizeof(double) * BLOCKNUM * THREADNUM, cudaMemcpyDeviceToHost);

    // output result
    int i, j;
    printf("Result: ----------------\n");
    for (i = 0; i < BLOCKNUM; i++) {
      for (j = 0; j < THREADNUM; j++) {
        printf("%lf\t", C_rand[(i * THREADNUM) + j]);
      }
      printf("\n");
    }

    // delete used memory
    cudaFree(dev_states);
    cudaFree(G_rand);
    free(C_rand);

    return 0;
}
