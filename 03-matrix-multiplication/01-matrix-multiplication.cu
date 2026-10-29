#include <iostream>
#include <cuda_runtime.h>

#define N 3
using namespace std;


__global__ void mat_mul(int *A, int *B, int *C, int n) {
	int row = blockDim.y*blockIdx.y + threadIdx.y;
	int col = blockDim.x*blockIdx.x + threadIdx.x;

	if(row < n && col < n) {
		int sum = 0;
		for(int k = 0; k < n; k++) {
			sum += A[row*n + k] * B[k*n + col];
		}

		C[row*n + col] = sum;
	}
}

int main() {
	int A[N*N] = {
		1, 2, 3, 
		4, 5, 6, 
		7, 8, 9
	};

	int B[N*N] = {
		9, 8, 7,
		6, 5, 4, 
		3, 2, 1
	};

	int C[N*N];

	int *d_A, *d_B, *d_C;
	size_t size = N*N*sizeof(int);

	cudaMalloc(&d_A, size);
	cudaMalloc(&d_B, size);
	cudaMalloc(&d_C, size);

	cudaMemcpy(d_A, A, size, cudaMemcpyHostToDevice);
	cudaMemcpy(d_B, B, size, cudaMemcpyDeviceToHost);

	dim3 threadsPerBlock(16, 16);
	dim3 numBlocks(
			(N + threadsPerBlock.x - 1) / threadsPerBlock.x,
			(N + threadsPerBlock.y - 1) / threadsPerBlock.y
		      );
	mat_mul<<<numBlocks, threadsPerBlock>>>(d_A, d_B, d_C, N);

	cudaDeviceSynchronize();

	cudaMemcpy(C, d_C, size, cudaMemcpyDeviceToHost);

	cout << "Matrix A * Matrix B = C\n";

	for(int i = 0; i < N; i++) {
		for(int j = 0; j < N; j++) {
			cout << C[i*N + j] << "\t";
		}
		cout << "\n";
	}

	cudaFree(d_A);
	cudaFree(d_B);
	cudaFree(d_C);

	return 0;
}
