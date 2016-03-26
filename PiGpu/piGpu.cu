#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <cuda.h>
#include <curand.h>
#include <curand_kernel.h>

#define THREADNUM 1024
#define BLOCKNUM 127

__device__ float G_rand(curandState *states, int ind){
    curandState local_state = states[ind];
    float rand_num = curand_uniform(&local_state);
    states[ind] = local_state;

    return rand_num;
}

__global__ void G_srand(curandState *states, unsigned long seed){
    int ind = threadIdx.x;
    //what is curand_init
    curand_init(seed, ind, 0, &states[ind]);
}

__global__ void getPoints(int *correct, int *base, int *block_result, int loop_time, curandState *states){
    int t_id = threadIdx.x;
    int b_id = blockIdx.x;
    int i;

    __shared__ int result[THREADNUM+1];

    if(t_id != 0){
        int current_count = 0;
        double pi_x;
        double pi_y;
        result[t_id] = 0;

        for(i=0; i<loop_time; i++){
            pi_x = G_rand(states, t_id);
            pi_y = G_rand(states, t_id);
            if( (pi_x*pi_x + pi_y*pi_y) < 1 )
                ++current_count;
        }
        result[t_id] = current_count;
    }

    __syncthreads();

    if(t_id == 0){
        int block_correct = 0;
        for(i=1; i<THREADNUM; i++)
            block_correct += result[i];

        block_result[b_id] = block_correct;
    }

    __syncthreads();

    if(!t_id && !b_id){
        *correct = 0;
        *base = loop_time*(THREADNUM-1)*BLOCKNUM;
        for(i=0; i<BLOCKNUM; i++)
            *correct += block_result[i];
    }
}

int main(){
    curandState *dev_states;
    cudaMalloc((void**) &dev_states, sizeof(curandState) * THREADNUM);
    G_srand<<<1/*BLOCKNUM*/, THREADNUM>>>(dev_states, unsigned(time(NULL)));

    int *G_correct, *G_base, *G_block;;
    cudaMalloc((void**) &G_correct, sizeof(int));
    cudaMalloc((void**) &G_base, sizeof(int));
    cudaMalloc((void**) &G_block, sizeof(int)*BLOCKNUM);

    int i;
    long double correct = 0, base = 0;
    for(i=0; i<10000; i++){
        getPoints<<<BLOCKNUM, THREADNUM>>>(G_correct, G_base, G_block, 10000, dev_states);

        int now_correct, now_base;
        cudaMemcpy(&now_correct, G_correct, sizeof(int), cudaMemcpyDeviceToHost);
        cudaMemcpy(&now_base, G_base, sizeof(int), cudaMemcpyDeviceToHost);

        system("clear");
        printf("correct =\t%.0Lf\n", correct);
        printf("base =\t\t%.0Lf\n", base);

        correct += now_correct;
        base += now_base;
        printf("answer = %.15Lf\n", (correct/base) * 4);
    }

    cudaFree(dev_states);
    cudaFree(G_correct);
    cudaFree(G_base);


    return 0;
}
