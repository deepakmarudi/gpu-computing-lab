#include <iostream>
#include <cuda_runtime.h>

#define N 4
#define TILE 4
using namespace std;

__global__ void tile_mat_mul(int *A, int *B, int *C, int n) {
	__shared__ int tileA[TILE][TILE];
	__shared__ int tileB[TILE][TILE];

	int ty = threadIdx.y;
	int tx = threadIdx.x;

	int row = blockIdx.y * TILE + ty;
	int col = blockIdx.x * TILE + tx;

	int sum = 0;

	for(int t = 0; t < (n + TILE - 1) / TILE; t++) {
		if(row < n && t * TILE + tx < n) {
			tileA[ty][tx] = A[row * n + t * TILE + tx];
		}else {
			tileA[ty][tx] = 0;
		}

		if(col < n && t * TILE + ty < n) {
			tileB[ty][tx] = B[(t * TILE + ty) * n + col];
		}else {
			tileB[ty][tx] = 0;
		}

		__syncthreads();

		for(int k = 0; k < TILE; k++) {
			sum += tileA[ty][k] * tileB[k][tx];
		}

		__syncthreads();
	}

	if(row < n && col < n) {
		C[row * n + col] = sum;
	}
}

int main() {
	int A[N * N] = {
		1, 2, 3, 4,
		5, 6, 7, 8, 
		9, 10, 11, 12, 
		13, 14, 15, 16
	};

	int B[N * N] = {
		1, 0, 0, 0,
		0, 1, 0, 0, 
		0, 0, 1, 0, 
		0, 0, 0, 1
	};

	int C[N * N];

	int *d_A, *d_B, *d_C;
	size_t bytes = N * N * sizeof(int);

	cudaMalloc(&d_A, bytes);
	cudaMalloc(&d_B, bytes);
	cudaMalloc(&d_C, bytes);

	cudaMemcpy(d_A, A, bytes, cudaMemcpyHostToDevice);
    	cudaMemcpy(d_B, B, bytes, cudaMemcpyHostToDevice);

	dim3 threads(TILE, TILE);
	dim3 blocks((N + TILE - 1) / TILE,
		    (N + TILE - 1) / TILE);

	tile_mat_mul<<<blocks, threads>>>(d_A, d_B, d_C, N);

    	cudaDeviceSynchronize();
    	cudaMemcpy(C, d_C, bytes, cudaMemcpyDeviceToHost);

    	cout << "Result matrix:\n";
    	for (int i = 0; i < N; i++) {
        	for (int j = 0; j < N; j++)
            		cout << C[i * N + j] << "\t";
        	cout << "\n";
    	}

    	cudaFree(d_A);
    	cudaFree(d_B);
    	cudaFree(d_C);

    	return 0;
}
