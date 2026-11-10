
#include <iostream>
#include <cuda_runtime.h>
#include <cmath>
#include <cstdlib>

using namespace std;

int main(int argc, char **argv) {

    cout << argv[0] << " Starting..." << endl;

    int deviceCount = 0;
    cudaGetDeviceCount(&deviceCount);

    if (deviceCount == 0) {
        cout << "There are no available devices that support CUDA" << endl;
        return 0;
    }
    else {
        cout << "Detected " << deviceCount
             << " CUDA Capable device(s)" << endl;
    }

    int dev = 0;
    int driverVersion = 0;
    int runtimeVersion = 0;

    cudaSetDevice(dev);

    cudaDeviceProp deviceProp;
    cudaGetDeviceProperties(&deviceProp, dev);

    cout << "\nDevice " << dev << ": " << deviceProp.name << endl;

    cudaDriverGetVersion(&driverVersion);
    cudaRuntimeGetVersion(&runtimeVersion);

    cout << "CUDA Driver Version / Runtime Version: "
         << driverVersion / 1000 << "."
         << (driverVersion % 100) / 10 << " / "
         << runtimeVersion / 1000 << "."
         << (runtimeVersion % 100) / 10 << endl;

    cout << "CUDA Capability Major/Minor: "
         << deviceProp.major << "."
         << deviceProp.minor << endl;

    cout << "Total Global Memory: "
         << (double)deviceProp.totalGlobalMem / pow(1024.0, 3)
         << " GB (" << deviceProp.totalGlobalMem << " bytes)" << endl;

    //cout << "GPU Clock Rate: "
      //   << deviceProp.clockRate * 1e-3
        // << " MHz (" << deviceProp.clockRate * 1e-6
         //<< " GHz)" << endl;

//    cout << "Memory Clock Rate: "
  //       << deviceProp.memoryClockRate * 1e-3
    //     << " MHz" << endl;

    cout << "Memory Bus Width: "
         << deviceProp.memoryBusWidth << "-bit" << endl;

    if (deviceProp.l2CacheSize) {
        cout << "L2 Cache Size: "
             << deviceProp.l2CacheSize << " bytes" << endl;
    }

    cout << "Max Texture Dimensions:" << endl;

    cout << "1D: " << deviceProp.maxTexture1D << endl;

    cout << "2D: "
         << deviceProp.maxTexture2D[0] << " x "
         << deviceProp.maxTexture2D[1] << endl;

    cout << "3D: "
         << deviceProp.maxTexture3D[0] << " x "
         << deviceProp.maxTexture3D[1] << " x "
         << deviceProp.maxTexture3D[2] << endl;

    cout << "Max Layered Texture Dimensions:" << endl;

    cout << "1D: "
         << deviceProp.maxTexture1DLayered[0]
         << " x " << deviceProp.maxTexture1DLayered[1] << endl;

    cout << "2D: "
         << deviceProp.maxTexture2DLayered[0]
         << " x " << deviceProp.maxTexture2DLayered[1]
         << " x " << deviceProp.maxTexture2DLayered[2] << endl;

    cout << "Total Constant Memory: "
         << deviceProp.totalConstMem << " bytes" << endl;

    cout << "Shared Memory Per Block: "
         << deviceProp.sharedMemPerBlock << " bytes" << endl;

    cout << "Registers Per Block: "
         << deviceProp.regsPerBlock << endl;

    return 0;
}

