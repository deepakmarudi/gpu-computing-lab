#include <iostream>
#include <cuda_runtime.h>

#define N 32
using namespace std;

__global__ void noDivergence(int *A, int *B) {
	int tid = threadIdx.x;

	if(tid < 32) {
		B[tid] = A[tid] * 2;
	} else {
		B[tid] = A[tid] * 3;
	}
}

__global__ void withDivergence(int *A, int *B) {
	int tid = threadIdx.x;

	if(tid < 16) {
		B[tid] = A[tid] * 2;
	} else {
		B[tid] = A[tid] * 3;
	}
}

int main() {
	int A[N], B[N];

	for(int i = 0; i < N; i++) {
		A[i] = i + 1;
	}

	int *d_A, *d_B;

	size_t bytes = N * sizeof(int);

	cudaMalloc(&d_A, bytes);
	cudaMalloc(&d_B, bytes);

	cudaMemcpy(d_A, A, bytes, cudaMemcpyHostToDevice);
	
	noDivergence<<<1, N>>>(d_A, d_B);
	cudaDeviceSynchronize();

	cudaMemcpy(B, d_B, bytes, cudaMemcpyDeviceToHost);

	cout << "No Divergence:\n";
	for(int i = 0; i < N; i++) {
		cout << B[i] << " "; 
	}

	cout << "\n\n";

        withDivergence<<<1, N>>>(d_A, d_B);
        cudaDeviceSynchronize();

        cudaMemcpy(B, d_B, bytes, cudaMemcpyDeviceToHost);

        cout << "With Divergence:\n";
        for(int i = 0; i < N; i++) {
                cout << B[i] << " ";
        }

        cout << "\n";

	cudaFree(d_A);
	cudaFree(d_B);

	return 0;
}
