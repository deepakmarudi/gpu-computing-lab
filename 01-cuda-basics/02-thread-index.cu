#include <cstdio>
#include <cuda_runtime.h>

__global__ void thread_index() {
	printf("thread-idx: %d\n", threadIdx.x);
}

int main() {
	thread_index<<<1, 5>>>();
	cudaDeviceSynchronize();
	return 0;
}
