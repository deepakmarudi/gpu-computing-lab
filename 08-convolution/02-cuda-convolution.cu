#include <bits/stdc++.h>
#include <bits/stdc++.h>

using namespace std;


__global__ void convolution(int *A, int *M, int *B, int N, int K) {
	int tid = blockDim.x * blockIdx.x + threadIdx.x;

	int R = K / 2;

	if(tid < N) {
		int sum = 0;

		for(int j = -R; j <= R; j++) {
			int idx = j + tid;

			if(idx >= 0 && idx < N) {
				sum += A[idx] * M[j + R];
			}
		}

		B[tid] = sum;

	}

}

int main() {
	const int N = 7;
	const int K = 3;

	int A[N] = {1, 2, 3, 4, 5, 6, 7};
	int M[K] = {1, 2, 1};
	int B[N] = {0};

	int *d_A, *d_B, *d_M;

	cudaMalloc(&d_A, N * sizeof(int));
    	cudaMalloc(&d_M, K * sizeof(int));
    	cudaMalloc(&d_B, N * sizeof(int));

    	cudaMemcpy(d_A, A, N * sizeof(int),
               	cudaMemcpyHostToDevice);

    	cudaMemcpy(d_M, M, K * sizeof(int),
               	cudaMemcpyHostToDevice);

   
    	int threads = 256;
    	int blocks = (N + threads - 1) / threads;

    	convolution<<<blocks, threads>>>(d_A, d_M, d_B, N, K);

  
    	cudaMemcpy(B, d_B, N * sizeof(int),
               	cudaMemcpyDeviceToHost);


    	cout << "CUDA Convolution Output: ";

    	for (int i = 0; i < N; i++){
        	cout << B[i] << " ";
    	}

    	cout << "\n";

    
    	cudaFree(d_A);
    	cudaFree(d_M);
    	cudaFree(d_B);

    	return 0;
}
