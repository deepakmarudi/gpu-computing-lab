
#include <bits/stdc++.h>
#include <cuda_runtime.h>
using namespace std;

#define N 10
#define BINS 5

__global__ void hist(int *arr, int *histogram) {

	int idx = blockIdx.x * blockDim.x + threadIdx.x;

	if(idx < N) {
		atomicAdd(&histogram[arr[idx]], 1);
	}
}

int main() {
	
	int arr[N] = {1, 2, 1, 3, 2, 1, 4, 3, 2 ,1};

	int histogram[BINS] = {0};

	int d_arr, *d_histogram;

	cudaMalloc(&d_arr, N * sizeof(int));
	cudaMalloc(&d_histogram, BINS * sizeof(int));

	cudaMemcpy(d_histogram, histogram, BINS * sizeof(int), cudaMemcpyHostToDevice);
	cudeMemcpy(d_arr, arr, N * sizeof(int), cudaMemcpyHostToDevice);

	int threads = 4;

	int blocks = (N + threads - 1) / threads;

	hist<<<blocks, threads>>>(d_arr, d_histogram);

	cudaDeviceSynchronize();

	cudaMemcpy(histogram, d_histogram, BINS * sizeof(int), cudaMemcpyDeviceToHost);
}
