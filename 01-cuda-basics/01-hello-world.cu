#include <cstdio>
#include <cuda_runtime.h>

__global__ void hello() {
	printf("Thread ID: %d\n", threadIdx.x);
	printf("Hello form GPU!\n");
}


int main() {
	hello<<<1, 5>>>();
	cudaDeviceSynchronize();
	return 0;
}
