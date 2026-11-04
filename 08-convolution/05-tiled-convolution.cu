#include <bits/stdc++.h>
#include <cuda_runtime.h>

using namespace std;
#define TILE 4
#define K 3

__global__ void tiledconvolution(int *A, int *M, int *B, int N, int O) {

	__shared__ int tile[TILE + K - 1][TILE + K - 1];

	int tx = threadIdx.x;
	int ty = threadIdx.y;

	int row = blockIdx.y * TILE + ty;
	int col = blockIdx.x * TILE + tx;

	for(int i = ty; i < TILE + K - 1; i += TILE) {
		for(int j = tx; j < TILE + K - 1; j += TILE) {
			int r = blockIdx.y * TILE + i;
			int c = blockIdx.x * TILE + j;

			if(r < N && c < N) {
				tile[i][j] = A[r * N + c];
			} else {
				tile[i][j] = 0;
			}
		}
	}

	__syncthreads();
	if(row < O && col < O) {
		int sum = 0;

		for(int x = 0; x < K; x++) {
			for(int y = 0; y < K; y++) {
				sum += tile[ty+x][tx+y] * M[x*K + y];
			}
		}
		B[row*O + col] = sum;
	}
}

int main() {
	const int N = 5;
	const int O = N - K + 1;

	int A[N * N] = {
		1, 2, 3, 4, 5, 
		6, 7, 8, 9, 10, 
		11, 12, 13, 14, 15, 
		16, 17, 18, 19, 20, 
		21, 22, 23, 24, 25
	};

	int M[K * K] = {
		1, 0, 1, 
		0, 1, 0,
		1, 0, 1
	};

	int B[O * O] = {};

	int *d_A, *d_M, *d_B;

	cudaMalloc(&d_A, N * N * sizeof(int));
    	cudaMalloc(&d_M, K * K * sizeof(int));
    	cudaMalloc(&d_B, O * O * sizeof(int));

   
    	cudaMemcpy(d_A, A, N * N * sizeof(int),
               	cudaMemcpyHostToDevice);

    	cudaMemcpy(d_M, M, K * K * sizeof(int),
               	cudaMemcpyHostToDevice);

	dim3 threads(TILE, TILE);
	dim3 blocks((O + TILE - 1) / TILE, (O + TILE - 1) / TILE);

	tiledconvolution<<<blocks, threads>>>(d_A, d_M, d_B, N, O);

    	cudaMemcpy(B, d_B, O * O * sizeof(int),
               	cudaMemcpyDeviceToHost);

    	cout << "Tiled 2D Convolution Output:\n";

    	for (int i = 0; i < O; i++) {
        	for (int j = 0; j < O; j++){
			cout << B[i * O + j] << "\t";
        	}
        	cout << "\n";
    	}

   
    	int expected[O * O] = {
        	35, 40, 45,
        	60, 65, 70,
        	85, 90, 95
    	};

    	bool correct = true;

    	for (int i = 0; i < O * O; i++) {
        	if (B[i] != expected[i]){
            		correct = false;
            		break;
        	}
    	}

    	cout << "\nVerification: "
         	<< (correct ? "PASSED" : "FAILED") << "\n";

    	cudaFree(d_A);
    	cudaFree(d_M);
    	cudaFree(d_B);

    	return 0;
}


