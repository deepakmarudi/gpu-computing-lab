#include <iostream>
#include <cuda_runtime.h>

using namespace std;

int main() {
	int count = 0;

	cudaGetDeviceCount(&count);
	cout << "Number of GPUs: " << count << "\n";

	for(int i = 0; i < count; i++) {
		cudaDeviceProp prop;
		cudaGetDeviceProperties(&prop, i);

		cout << "GPU name: " << prop.name << "\n";
		cout << "Global memory (MB):"
		     << prop.totalGlobalMem / (1024 * 1024) << "\n";
		cout << "Multiprocessors: "
		     << prop.multiProcessorCount << "\n";
	}

	return 0;

}
