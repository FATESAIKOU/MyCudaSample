#include <stdio.h>
#include <cuda_runtime.h>

int main(void){
    cudaDeviceProp prop;

    if(cudaGetDeviceProperties(&prop, 0) != cudaSuccess){
        fprintf(stderr, "no device avalible, go a hell, man\n");
    }

    fprintf(stdout, "get prop success\n");
    fprintf(stdout, "   name: %s\n", prop.name);
    fprintf(stdout, "   totalGlobalMem: %lu\n", prop.totalGlobalMem);
    fprintf(stdout, "   sharedMemPerBlock: %lu\n", prop.sharedMemPerBlock);
    fprintf(stdout, "   regsPerBlock: %d\n", prop.regsPerBlock);
    fprintf(stdout, "   warpSize: %d\n", prop.warpSize);
    fprintf(stdout, "   memPitch: %lu\n", prop.memPitch);
    fprintf(stdout, "   maxThreadsPerBlock: %d\n", prop.maxThreadsPerBlock);
    fprintf(stdout, "   maxThreadsDim:\n");
    fprintf(stdout, "       maxThreadsDim[0]: %d\n", prop.maxThreadsDim[0]);
    fprintf(stdout, "       maxThreadsDim[1]: %d\n", prop.maxThreadsDim[1]);
    fprintf(stdout, "       maxThreadsDim[2]: %d\n", prop.maxThreadsDim[2]);
    fprintf(stdout, "   maxThreadsGridSize:\n");
    fprintf(stdout, "       maxGridSize[0]: %d\n", prop.maxGridSize[0]);
    fprintf(stdout, "       maxGridSize[1]: %d\n", prop.maxGridSize[1]);
    fprintf(stdout, "       maxGridSize[2]: %d\n", prop.maxGridSize[2]);
    fprintf(stdout, "   clockRate: %d\n", prop.clockRate);
    fprintf(stdout, "   totalConstMem: %lu\n", prop.totalConstMem);
    fprintf(stdout, "   major.minor: %d.%d\n", prop.major, prop.minor);
    fprintf(stdout, "   textureAlignment: %lu\n", prop.textureAlignment);
    fprintf(stdout, "   texturePitchAlignment: %lu\n", prop.texturePitchAlignment);
    fprintf(stdout, "   deviceOverlap: %d\n", prop.deviceOverlap);
    fprintf(stdout, "   multiProcessorCount: %d\n", prop.multiProcessorCount);
    fprintf(stdout, "   kernelExecTimeoutEnabled: %d\n", prop.kernelExecTimeoutEnabled);
    fprintf(stdout, "   integrated: %d\n", prop.integrated);
    fprintf(stdout, "   canMapHostMemory: %d\n", prop.canMapHostMemory);
    fprintf(stdout, "   computeMode: %d\n", prop.computeMode);
    fprintf(stdout, "   maxTexture1D: %d\n", prop.maxTexture1D);
    fprintf(stdout, "   maxTexture1DLinear: %d\n", prop.maxTexture1DLinear);
    fprintf(stdout, "   maxTexture2D\n");
    fprintf(stdout, "       maxTexture2D[0]: %d\n", prop.maxTexture2D[0]);
    fprintf(stdout, "       maxTexture2D[1]: %d\n", prop.maxTexture2D[1]);
    fprintf(stdout, "   maxTexture2DLinear\n");
    fprintf(stdout, "       maxTexture2DLinear[0]: %d\n", prop.maxTexture2DLinear[0]);
    fprintf(stdout, "       maxTexture2DLinear[1]: %d\n", prop.maxTexture2DLinear[1]);
    fprintf(stdout, "       maxTexture2DLinear[2]: %d\n", prop.maxTexture2DLinear[2]);
    fprintf(stdout, "   maxTexture2DGather\n");
    fprintf(stdout, "       maxTexture2DGather[0]: %d\n", prop.maxTexture2DGather[0]);
    fprintf(stdout, "       maxTexture2DGather[1]: %d\n", prop.maxTexture2DGather[1]);
    fprintf(stdout, "   maxTexture3D\n");
    fprintf(stdout, "       maxTexture3D[0]: %d\n", prop.maxTexture3D[0]);
    fprintf(stdout, "       maxTexture3D[1]: %d\n", prop.maxTexture3D[1]);
    fprintf(stdout, "       maxTexture3D[2]: %d\n", prop.maxTexture3D[2]);
    fprintf(stdout, "   maxSurface1D: %d\n", prop.maxSurface1D);
    fprintf(stdout, "   maxSurface2D\n");
    fprintf(stdout, "       maxSurface2D[0]: %d\n",  prop.maxSurface2D[0]);
    fprintf(stdout, "       maxSurface2D[1]: %d\n",  prop.maxSurface2D[1]);
    fprintf(stdout, "   maxSurface3D\n");
    fprintf(stdout, "       maxSueface3D[0]: %d\n", prop.maxSurface3D[0]);
    fprintf(stdout, "       maxSueface3D[1]: %d\n", prop.maxSurface3D[1]);
    fprintf(stdout, "       maxSueface3D[2]: %d\n", prop.maxSurface3D[2]);
    fprintf(stdout, "   maxSurface1DLayered\n");
    fprintf(stdout, "       maxSurface1DLayered[0]: %d\n", prop.maxSurface1DLayered[0]);
    fprintf(stdout, "       maxSurface1DLayered[1]: %d\n", prop.maxSurface1DLayered[1]);
    fprintf(stdout, "   maxSurface2DLayered\n");
    fprintf(stdout, "       maxSurface2DLayered[0]: %d\n", prop.maxSurface2DLayered[0]);
    fprintf(stdout, "       maxSurface2DLayered[1]: %d\n", prop.maxSurface2DLayered[1]);
    fprintf(stdout, "       maxSurface2DLayered[2]: %d\n", prop.maxSurface2DLayered[2]);
    fprintf(stdout, "   maxSurfaceCubemap: %d\n", prop.maxSurfaceCubemap);
    fprintf(stdout, "   maxSurfaceCubemapLayered\n");
    fprintf(stdout, "       maxSurfaceCubemapLayered[0]: %d\n", prop.maxSurfaceCubemapLayered[0]);
    fprintf(stdout, "       maxSurfaceCubemapLayered[1]: %d\n", prop.maxSurfaceCubemapLayered[1]);
    fprintf(stdout, "   surfaceAlignment: %ld\n", prop.surfaceAlignment);
    fprintf(stdout, "   concurrentKernels: %d\n", prop.concurrentKernels);
    fprintf(stdout, "   ECCEnabled: %d\n", prop.ECCEnabled);
    fprintf(stdout, "   pciBusID: %d\n", prop.pciBusID);
    fprintf(stdout, "   pciDeviceID: %d\n", prop.pciDeviceID);
    fprintf(stdout, "   pciDomainID: %d\n", prop.pciDomainID);
    fprintf(stdout, "   tccDriver: %d\n", prop.tccDriver);
    fprintf(stdout, "   asyncEngineCount: %d\n", prop.asyncEngineCount);
    fprintf(stdout, "   unifiedAddressing: %d\n", prop.unifiedAddressing);
    fprintf(stdout, "   memoryClockRate: %d\n", prop.memoryClockRate);
    fprintf(stdout, "   l2CacheSize: %d\n", prop.l2CacheSize);
    fprintf(stdout, "   maxThreadsPerMultiProcessor: %d\n", prop.maxThreadsPerMultiProcessor);
    return 0;
}
