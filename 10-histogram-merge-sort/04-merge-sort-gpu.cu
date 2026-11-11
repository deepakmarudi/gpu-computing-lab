#include <bits/stdc++.h>
#include <cuda_runtime.h>

using namespace std;

#define N 8

__global__ void merge(int *arr, int *temp, int width, int n) {

	int idx = blockIdx.x * blockDim.x + thread.x;

	int start = idx * 2 * width;

	if (start >= n) {
		return;
	}

	int mid = min(start + width, n);
	int end = min(start + 2*width, n);

	int i = start;
	int j = mid;
	int k = start;

	while(i < mid && j < end) {
		if(arr[i] <= arr[j]) {
			temp[k++] = arr[i++];
		}else {
			temp[k++] = arr[j++];
		}
	}

	while(i < mid) {
		temp[k++] = arr[i++];
	}

	while(j < end) {
		temp[k++] = arr[j++];
	}
}

int main() {

	int arr[N] = {8, 3, 5, 1, 7, 2, 6, 4};

	int *d_arr, *d_temp;

	cudaMalloc(&d_arr, N * sizeof(int));
	cudaMalloc(&d_temp, N * sizeof(int));

	cudaMemcpy(d_arr, arr, N * sizeof(int), cudaMemcpyHostToDevice);

	int threads = 4;

	for(int width = 1; width < N; width *= 2) {

		int pairs = (N + 2*width - 1) / (2*width);
		int blocks = (pairs + threads - 1) / threads;

		merge<<<blocks, threads>>>(d_arr, d_temp, width, N);

		cudaDeviceSynchronize();

		cudaMemcpy(d_arr, d_temp, N * sizeof(int), cudaMemcpyDeviceToDevice);
	}

	cudaMemcpy(arr, d_arr, N * sizeof(int), cudaMemcpyDeviceToHost);
}
