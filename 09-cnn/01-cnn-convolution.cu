#include <bits/stdc++.h>
#include <cuda_runtime.h>

using namespace std;

const int H = 4;
const int W = 4;
const int C = 3;

const int F = 2;
const int K = 2;

const int OH = H - K + 1;
const int OW = W - K + 1;

const int OUTPUT_SIZE = F * OH * OW;

void cpuConvolution(const float *input, float *filters, float * output) {
	for(int f = 0; f < F; f++) {
		for(int i = 0; i < OH; i++) {
			for(int j = 0; j < OW; j++) {

				float sum = 0.0f;

				for(int c = 0; c < C; c++) {
					for(int ki = 0; ki < K; ki++) {
						for(int kj = 0; kj < K; kj++) {
							int inputIdx = c * H * W + (i + ki) * W + (j + kj);
							int filterIdx = f * C * K * K + c * K * K + ki * K + kj;

							sum += input[inputIdx] * filters[filterIdx];
						}
					}
				}

				int outputIdx = f * OH * OW + i * OW + j;

				output[outputIdx] = sum;
			}
		}
	}
}

__global__ void cnnConvolution(const float *input, const float *filters, float *output) {

	int idx = blockIdx.x * blockDim.x + threadIdx.x;

	if(idx >= OUTPUT_SIZE) {
		return;
	}

	int f = idx / (OH * OW);

	int rem = idx % (OH * OW);

	int i = rem / OW;
	int j = rem % OW;

	float sum = 0;

	for(int c = 0; c < C; c++) {
		for(int ki = 0; ki < K; ki++) {
			for(int kj = 0; kj < K; kj++) {

				int inputIdx = c * W * H + (i + ki) * W + (j + kj);

				int filterIdx = f * C * K * K + c * K * K + ki * K + kj;

				sum += input[inputIdx] * filters[filterIdx];
			}
		}
	}

	output[idx] = sum;
}

int main() {

	vector<float> input(C * H * W);

	for(int i = 0; i < C * H * W; i++) {
		input[i] = i + 1;
	}

	vector<float> filters(F * C * K * K);

	for(int i = 0; i < F * C * K * K; i++) {
		filters[i] = 1.0f;
	}

	vector<float> cpuOutput(OUTPUT_SIZE);
	vector<float> gpuOutput(OUTPUT_SIZE);

	cpuConvolution(input.data(), filters.data(), cpuOutput.data());

	float *d_input, *d_filters, *d_output;

	cudaMalloc(&d_input, input.size() * sizeof(float));
	cudaMalloc(&d_filters, filters.size() * sizeof(float));
	cudaMalloc(&d_output, OUTPUT_SIZE * sizeof(float));

    	cudaMemcpy(d_input, input.data(), input.size() * sizeof(float), cudaMemcpyHostToDevice);

    	cudaMemcpy(d_filters, filters.data(), filters.size() * sizeof(float), cudaMemcpyHostToDevice);

	int threads = 128;

	int blocks = (OUTPUT_SIZE + threads - 1) / threads;

	cnnConvolution<<<blocks, threads>>>(d_input, d_filters, d_output);

	cudaDeviceSynchronize();

	cudaMemcpy(gpuOutput.data(), d_output, OUTPUT_SIZE * sizeof(float), cudaMemcpyDeviceToHost);

	cout << "CPU VS GPU Output\n\n";

	bool correct = true;

	for(int i = 0; i < OUTPUT_SIZE; i++) {

		cout << "Element " << i << " : CPU = " << cpuOutput[i] << ", GPU = " << gpuOutput[i] << "\n";

		if(fabs(cpuOutput[i] - gpuOutput[i]) > 1e-5) {
			correct = false;
		}
	}

	cout << "\nResult: " << (correct ? "MATCH" : "MISMATCH") << "\n";

	cudaFree(d_input);
	cudaFree(d_filters);
	cudaFree(d_output);

	return 0;
}
