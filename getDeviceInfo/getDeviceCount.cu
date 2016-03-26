#include <stdio.h>
#include <cuda_runtime.h>

int main(void){
    int deviceCount;
    cudaGetDeviceCount(&deviceCount);
    printf("the avalible device count is %d\n", deviceCount);
    return 0;
}
