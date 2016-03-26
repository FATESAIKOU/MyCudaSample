#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>

#define MATSIZE 10000
#define THREADNUM 256

void matgen(int *mat, int size){
  srand((unsigned)time(NULL));

  int i, j;
  for(i=0; i<size; i++){
    for(j=0; j<size; j++)
      mat[i*size+j] = rand()%10;
  }
}

void printMat(int *mat, int size){
  int i, j;

  for(i=0; i<size; i++){
    printf("%02d>>\t", i);
    for(j=0; j<size; j++)
      printf("%4d\t", mat[i*MATSIZE+j]);
    printf("\n");
  }
  printf("\n");
}

clock_t matmultCPU(int *mat1, int *mat2, int *matR, int size){
  int i, j, k, tmp;
  clock_t start = clock();

  for(i=0; i<MATSIZE; i++)
    for(j=0; j<MATSIZE; j++){
      tmp = 0;
      for(k=0; k<MATSIZE; k++)
        tmp += mat1[i*size+k]*mat2[k*size+j];
      matR[i*size+j] = tmp;
  }

  clock_t end = clock();
  return end-start;
}

 __global__ static void multiGPU(int *mat1, size_t ld1, int *mat2, size_t ld2, int *matR, size_t ldR, int size){
  const int tid     = threadIdx.x;
  const int bid     = blockIdx.x;
  const int idx     = bid*blockDim.x+tid;
  const int row     = idx / size;
  const int column  = idx % size;

  int i = 0;
  if(row < size && column < size){
    int tmp_product = 0;

    for(i=0; i<size; i++){
      tmp_product += mat1[row*ld1 + i]*mat2[i*ld2 + column];
    }

    matR[row*ldR + column] = tmp_product;
  }
}

clock_t matmultGPU(int *mat1, size_t ld1, int *mat2, size_t ld2, int *matR, size_t ldR, int size){
  int *G_mat1, *G_mat2, *G_matR;
  clock_t start, end;

  start = clock();
  cudaMalloc((void**) &G_mat1, sizeof(int)*size*size);
  cudaMalloc((void**) &G_mat2, sizeof(int)*size*size);
  cudaMalloc((void**) &G_matR, sizeof(int)*size*size);

  cudaMemcpy2D(G_mat1, sizeof(int)*size, mat1, sizeof(int)*size, sizeof(int)*size, size, cudaMemcpyHostToDevice);
  cudaMemcpy2D(G_mat2, sizeof(int)*size, mat2, sizeof(int)*size, sizeof(int)*size, size, cudaMemcpyHostToDevice);

  int blocks = (size+THREADNUM-1)/THREADNUM;
  multiGPU<<<blocks*size, THREADNUM>>>(G_mat1, ld1, G_mat2, ld2, G_matR, ldR, size);

  cudaMemcpy2D(matR, sizeof(int)*size, G_matR, sizeof(int)*size, sizeof(int)*size, size, cudaMemcpyDeviceToHost);

  cudaFree(G_mat1);
  cudaFree(G_mat2);
  cudaFree(G_matR);
  end = clock();

  return end-start;
}

int main(int argc, char *argv[]){
  int *mat1, *mat2, *matR, *matRGPU;
  clock_t CPUused, GPUused;

  mat1 = (int*)malloc(sizeof(int)*MATSIZE*MATSIZE);
  mat2 = (int*)malloc(sizeof(int)*MATSIZE*MATSIZE);
  matR = (int*)malloc(sizeof(int)*MATSIZE*MATSIZE);
  matRGPU = (int*)malloc(sizeof(int)*MATSIZE*MATSIZE);

  matgen(mat1, MATSIZE);
  matgen(mat2, MATSIZE);

  if(argc > 1 && argv[1][0] == 'G'){
    GPUused = matmultGPU(mat1, sizeof(int)*MATSIZE, mat2, sizeof(int)*MATSIZE, matRGPU, sizeof(int)*MATSIZE, MATSIZE);
    printf("GPU time used: %ld\n", GPUused);
  }else{
    CPUused = matmultCPU(mat1, mat2, matR, MATSIZE);
    printf("CPU time used: %ld\n", CPUused);
  }

  return 0;
}
