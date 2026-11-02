#include <iostream>
#include <cuda_runtime.h>
using namespace std;

int main()
{
    	cudaDeviceProp prop;

    	cudaGetDeviceProperties(&prop, 0);

    	cout << "GPU: " << prop.name << "\n";

    	cout << "Async Engine Count: "
              << prop.asyncEngineCount << "\n";

    	cout << "Concurrent Kernels: "
              << prop.concurrentKernels << "\n";

    	cout << "Compute Capability: "
              << prop.major << "." << prop.minor << "\n";

    	return 0;
}

