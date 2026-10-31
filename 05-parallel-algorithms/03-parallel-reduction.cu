#include <iostream>
#include <cuda_runtime.h>

using namespace std;
#define N 8

__global__ void parallelReduction(int *A, int *result) {

	__shared__ int sdata[N];

	int tid = threadIdx.x;

	sdata[tid] = A[tid];

	__syncthreads();

	for(int stride = N/2; stride > 0; stride /= 2) {
		if(tid < stride) {
			sdata[tid] += sdata[tid + stride];
		}

		__syncthreads();
	}

	if(tid == 0) {
		*result = sdata[0];
	}
}

int main() {

    	int A[N] = {10, 20, 30, 40, 50, 60, 70, 80};
    	int result = 0;

    	int *d_A, *d_result;

    	size_t bytes = N * sizeof(int);

    	// Allocate GPU memory
    	cudaMalloc(&d_A, bytes);
    	cudaMalloc(&d_result, sizeof(int));

    	// Copy input to GPU
    	cudaMemcpy(d_A, A, bytes, cudaMemcpyHostToDevice);

    	// Launch one block containing 8 threads
    	parallelReduction<<<1, N>>>(d_A, d_result);

    	cudaDeviceSynchronize();

    	// Copy final sum back to CPU
    	cudaMemcpy(&result, d_result, sizeof(int),
               cudaMemcpyDeviceToHost);

    	cout << "Parallel reduction sum = " << result << "\n";

    	cudaFree(d_A);
    	cudaFree(d_result);

    	return 0;
}
