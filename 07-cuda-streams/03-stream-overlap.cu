#include <bits/stdc++.h>
#include <cuda_runtime.h>

using namespace std;

__global__ void multiplyByTwo(int *A, int N) {

	int tid = blockDim.x*blockIdx.x + threadIdx.x;

	if(tid < N) {
		A[tid] *= 2;
	}
}

int main() {
	const int N = 1024;
	const int CHUNK = N/2;
	const int SIZE = N * sizeof(int);
	const int CHUNK_SIZE = CHUNK * sizeof(int);

	int *A, *d_A;

	cudaMallocHost(&A, SIZE);

	cudaMalloc(&d_A, SIZE);

	for(int i = 0; i < N; i++) {
		A[i] = i + 1;
	}

	cudaStream_t stream1, stream2;

	cudaStreamCreate(&stream1);
	cudaStreamCreate(&stream2);

	cudaMemcpyAsync(d_A, A, CHUNK_SIZE, cudaMemcpyHostToDevice, stream1);
	
	multiplyByTwo<<<2, 256, 0, stream1>>>(d_A, CHUNK);

	cudaMemcpyAsync(A, d_A, CHUNK_SIZE, cudaMemcpyDeviceToHost, stream1);

	cudaMemcpyAsync(d_A + CHUNK, A + CHUNK,
                    CHUNK_SIZE, cudaMemcpyHostToDevice, stream2);

	multiplyByTwo<<<2, 256, 0, stream2>>>(d_A + CHUNK, CHUNK);

    	cudaMemcpyAsync(A + CHUNK, d_A + CHUNK,
                    CHUNK_SIZE, cudaMemcpyDeviceToHost, stream2);

    	cudaStreamSynchronize(stream1);
    	cudaStreamSynchronize(stream2);

    
    	bool correct = true;

    	for (int i = 0; i < N; i++){

        	if (A[i] != 2 * (i + 1)){
            		correct = false;
            		break;
        	}
    	}

    	cout << (correct ? "All results correct\n"
                          : "Incorrect results\n");

    	cudaStreamDestroy(stream1);
    	cudaStreamDestroy(stream2);

    	cudaFree(d_A);
    	cudaFreeHost(A);

    	return 0;
}
