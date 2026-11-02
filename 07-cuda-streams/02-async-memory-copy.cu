#include <bits/stdc++.h>
#include <cuda_runtime.h>

using namespace std;

int main() {
	const int N = 5;
	const int size = N * sizeof(int);

	int *A;
	int *d_A;

	cudaMallocHost(&A, size);

	cudaMalloc(&d_A, size);

	for(int i = 0; i < N; i++) {
		A[i] = (i + 1) * 10;
	}

	cudaStream_t stream;
	cudaStreamCreate(&stream);

	cudaMemcpyAsync(d_A, A, size, cudaMemcpyHostToDevice, stream);

	cudaStreamSynchronize(stream);

	cout << "Data copied to gpu successfully\n";

	cudaStreamDestroy(stream);
	cudaFree(d_A);
	cudaFreeHost(A);

	return 0;

}
