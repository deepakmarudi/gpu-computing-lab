#include <iostream>
#include <cuda_runtime.h>

#define N 32
using namespace std;

__global__ void warpReduction(int *A, int *result) {

	int tid = threadIdx.x;

	int sum = A[tid];

	for(int offset = 16; offset > 0; offset /= 2) {

		int value = __shfl_down_sync(0xffffffff, sum, offset);

		sum += val;
	}

	if(tid == 0) {
		*result = sum;
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

    	cudaMemcpy(
        	d_A, A, bytes,
        	cudaMemcpyHostToDevice
    	);

    	// Exactly one warp: 32 threads
    	warpReduction<<<1, 32>>>(d_A, d_result);

    	cudaDeviceSynchronize();

    	cudaMemcpy(
        	&result, d_result, sizeof(int),
        	cudaMemcpyDeviceToHost
    	);

    	cout << "Warp reduction sum = "
              << result << "\n";

    	cudaFree(d_A);
    	cudaFree(d_result);

    	return 0;
}
