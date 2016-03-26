#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>

void printMat(int *mat, int row, int column){
  int i, j;

  printf("\t");
  for(j=0; j<column; j++)
    printf("<%02d>\t", j);
  printf("\n");

  for(i=0; i<row; i++){
    printf("<%02d>\t", i);
    for(j=0; j<column; j++)
      printf("%2d\t", mat[i*column+j]);

    printf("\n");
  }
}

int main(){
  int *a, *b, *c, *ac;
  int i, j;
  size_t ac_pitch;
  a = (int*)malloc(sizeof(int)*10*10);
  b = (int*)malloc(sizeof(int)*10*10);
  c = (int*)malloc(sizeof(int)*10*10);

  for(i=0; i<10; i++)
    for(j=0; j<10; j++){
      a[i*10+j] = i*10+j;
      b[i*10+j] = -1;
    }

  cudaMallocPitch((void**) &ac, &ac_pitch, sizeof(int)*10, 10);
  printf("ac_pitch: %d\nsizeof(int)*10: %ld\n", ac_pitch, sizeof(int)*10);

  printf("\nOri data>>\n");
  printMat((int*)a, 10, 10);
  //partial copy to device
  cudaMemcpy2D(ac, ac_pitch, a, sizeof(int)*10, sizeof(int)*10, 10, cudaMemcpyHostToDevice);

  //fully copy to host
  cudaMemcpy2D(b, sizeof(int)*10, ac, ac_pitch, sizeof(int)*10, 10, cudaMemcpyDeviceToHost);
  printf("\nDevice data>>\n");
  printMat((int*)b, 10, 10);

  //partial copy to host
  cudaMemcpy2D(c, sizeof(int)*10, ac, 36, sizeof(int)*10, 10, cudaMemcpyDeviceToHost);
  printf("\npartial Copy>>\n");
  printMat((int*)c, 10, 10);

  return 0;
}
