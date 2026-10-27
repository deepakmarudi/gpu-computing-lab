#include <cuda_runtime.h>
#include <iostream>
using namespace std;

__global__ void vec_add(int* A, int* B, int* C, int N) {
	int i = threadIdx.x + blockIdx.x*blockDim.x;

	if(i < N) {
		C[i] = A[i] + B[i];
	}
}

int main(){
	const int N = 5;
	int A[N] = {1, 2, 3, 4, 5};
	int B[N] = {10, 20, 30, 40, 50};
	int C[N];
	int *d_A, *d_B, *d_C;
	size_t bytes = N * sizeof(int);

	cudaMalloc(&d_A, bytes);
	cudaMalloc(&d_B, bytes);
	cudaMalloc(&d_C, bytes);

	cudaMemcpy(d_A, A, bytes, cudaMemcpyHostToDevice);
	cudaMemcpy(d_B, B, bytes, cudaMemcpyHostToDevice);

	int threadsperBlock = 256;
	int blocksperGrid = (N + threadsperBlock - 1) / threadsperBlock;
	vec_add<<<blocksperGrid, threadsperBlock>>>(d_A, d_B, d_C, N);

	cudaMemcpy(C, d_C, bytes, cudaMemcpyDeviceToHost);

	for(int i = 0; i < N; i++) {
		cout << A[i] << "+" << B[i] << "=" << C[i] << "\n";
	}
}
