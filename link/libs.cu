#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>

__global__ void kernelTest() {
    int i;
    i = 100;
    i = i - i + i;
}

extern "C" void testGpu() {
    printf("start test kernel...\n");

    kernelTest<<<1, 1>>>();

    printf("end of test lernel...\n");
}
