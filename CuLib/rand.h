
__device__ float Grand(curandState *state);

__device__ int GrandInt(curandState *state, int limit);

__global__ void GSrand(curandState *state, unsigned int seed);
