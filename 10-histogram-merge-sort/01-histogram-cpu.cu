#include <bits/stdc++.h>

using namespace std;

#define N 10
#define BINS 5

int main() {
	int arr[N] = {1, 2, 1, 3, 2, 1, 4, 3, 2, 1};

	int histogram[BINS] = {0};

	for(int i = 0; i < N; i++) {
		histogram[arr[i]]++;
	}

	cout << "Histogram:\n";

	for(int i = 0; i < BINS; i++) {
		cout << " : " << histogram[i] << "\n";
	}

	return 0;

}
