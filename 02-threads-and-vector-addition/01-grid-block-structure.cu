
#include <cstdio>
#include <cuda_runtime.h>

__global__ void display() {
	    int i = blockIdx.x * blockDim.x + threadIdx.x;

    printf("Block: %d, Thread: %d, Global Index: %d\n",
           blockIdx.x, threadIdx.x, i);
}

int main() {
    display<<<3, 4>>>();
    cudaDeviceSynchronize();

    return 0;
}
	
