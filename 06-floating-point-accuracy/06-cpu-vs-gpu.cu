#include <cuda_runtime.h>
#include <bits/stdc++.h>

using namespace std;

#define N 1000000
#define BLOCK_SIZE 256

__global__ void reducesum(float *input, float *output, int n) {

	__shared__ float cache[BLOCK_SIZE];

	int tid = threadIdx.x;
	int idx = blockIdx.x * blockDim.x + threadIdx.x;

	cache[tid] = (idx < n) ? input[idx] : 0.0f;

	__syncthreads();

	for(int stride = BLOCK_SIZE / 2; stride > 0; stride /= 2) {

		if(tid < stride) {
			cache[tid] += cache[tid + stride];
		}

		__syncthreads();
	}

	if(tid == 0) {
		atomicAdd(output, cache[0]);
	}
}


int main() {

	float A[N];

	for(int i = 0; i < N; i++) {
		A[i] = 0.0001f;
	}
	
	float cpuSum;

	for(int i = 0; i < N; i++) {
		cpuSum += A[i];
	}

	float *d_A, *d_sum;

	cudaMalloc(&d_A, N * sizeof(float));
	cudaMalloc(&d_sum, sizeof(float));

	cudaMemcpy(d_A, A, N * sizeof(float),
               cudaMemcpyHostToDevice);
	cudaMemset(d_sum, 0, sizeof(float));

	int blocks = (N + BLOCK_SIZE - 1) / BLOCK_SIZE;

	reducesum<<<blocks, BLOCK_SIZE>>>(d_A, d_sum, N);

	cudaDeviceSynchronize();

	float gpuSum;

    	cudaMemcpy(&gpuSum, d_sum, sizeof(float),
               cudaMemcpyDeviceToHost);

    	cout << "CPU Sum:      " << cpuSum << '\n';
    	cout << "GPU Sum:      " << gpuSum << '\n';

    	cout << "Difference:   "
              << abs(cpuSum - gpuSum) << '\n';

    	cout << "Expected Sum: "
              << N * 0.0001f << '\n';

    
    	cudaFree(d_A);
    	cudaFree(d_sum);

    	return 0;
}
