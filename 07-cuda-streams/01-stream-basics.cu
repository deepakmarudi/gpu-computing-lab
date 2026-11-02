#include <bits/stdc++.h>
#include <cuda_runtime.h>

using namespace std;

__global__ void printThread() {

	int tid = threadIdx.x;
	printf("Hello from GPU thread %d\n", tid);

}

int main() {

	cudaStream_t stream;
	

	cudaStreamCreate(&stream);

	printThread<<<1, 8, 0, stream>>>();

	cudaStreamSynchronize(stream);

	cudaStreamDestroy(stream);

	cout << "CPU: GPU execution completed\n";

	return 0;

}
