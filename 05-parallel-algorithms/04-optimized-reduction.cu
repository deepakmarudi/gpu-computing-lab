#include <iostream>
#include <cuda_runtime.h>

#define N 256
#define BLOCK_SIZE 128
using namespace std;

__global__ void optimizedReduction(int* A, int *result) {

	__shared__ int sdata[BLOCK_SIZE];

	int tid = threadIdx.x;

	int sum = A[tid] + A[tid + BLOCK_SIZE];

	sdata[tid] = sum;

	__syncthreads();

	for(int stride = BLOCK_SIZE / 2; stride > 0; stride /= 2) {
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

    	int A[N];
    	int result = 0;

    	for (int i = 0; i < N; i++) {
        	A[i] = i + 1;
    	}

    	int *d_A, *d_result;

    	size_t bytes = N * sizeof(int);

    	cudaMalloc(&d_A, bytes);
    	cudaMalloc(&d_result, sizeof(int));

    	cudaMemcpy(d_A, A, bytes, cudaMemcpyHostToDevice);

    	// 1 block containing 128 threads
    	optimizedReduction<<<1, BLOCK_SIZE>>>(d_A, d_result);

    	cudaDeviceSynchronize();

    	cudaMemcpy(&result, d_result, sizeof(int),
               cudaMemcpyDeviceToHost);

    	cout << "Optimized reduction sum = "
              << result << "\n";

    	cudaFree(d_A);
    	cudaFree(d_result);

    	return 0;
}
