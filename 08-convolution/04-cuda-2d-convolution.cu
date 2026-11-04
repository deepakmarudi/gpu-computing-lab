#include <bits/stdc++.h>
#include <cuda_runtime.h>

using namespace std;


__global__ void convolution2D(int *A, int *M, int *B, int N, int K, int O) {

	int row = blockDim.y * blockIdx.y + threadIdx.y;
	int col = blockDim.x * blockIdx.x + threadIdx.x;

	if (row < 0 && col < 0) {

		int sum = 0;

		for(int x = 0; x < K; x++) {
			for(int y = 0; y < K; y++) {
				sum += A[(row + x) * N + (col + y)] * M[x * K + y];
			}
		}

		B[row * O + col] = sum;
	}
}

int main() {
	const int N = 5;
	const int K = 3;
	const int O = N - K + 1;

	int A[N*N] = {
		1, 2, 3, 4, 5, 
		6, 7, 8, 9, 10, 
		11, 12, 13, 14, 15, 
		16, 17, 18, 18, 20, 
		21, 22, 23, 24, 25
	};

	int M[K*K] = {
		1, 0, 1, 
		0, 1, 0,
		1, 0, 1
	};

	int B[O*O] = {};

	int *d_A, *d_B, *d_M;

	int size = sizeof(int);

	cudaMalloc(&d_A, N * N * size);
	cudaMalloc(&d_M, K * K * size);
	cudaMalloc(&d_B, O * O size);

	cudaMemcpy(d_A, A, N * N * size, cudaMemcpyHostToDevice);
	cudaMemcpy(d_M, M, K * K * size, cudaMemcpyHostToDevice);

	dim3 threads(16, 16);
	dim3 blocks((O + threads.x - 1) / threads.x, (O + threads.y - 1) / threads.y);

	convolution2D<<<blocks, threads>>>(d_A, d_M, d_B,
                                       N, K, O);

    	cudaMemcpy(B, d_B, O * O * sizeof(int),
               cudaMemcpyDeviceToHost);

    	cout << "CUDA 2D Convolution Output:\n";

    	for (int i = 0; i < O; i++)	{
        	for (int j = 0; j < O; j++) {
            		cout << B[i * O + j] << "\t";
        	}
        	cout << "\n";
    	}

    	cudaFree(d_A);
    	cudaFree(d_M);
    	cudaFree(d_B);

    	return 0;
}
