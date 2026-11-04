#include <bits/stdc++.h>

using namespace std;

int main() {

	const int N = 7;
	const int K = 3;

	int A[N] = {1, 2, 3, 4, 5, 6, 7};
	int M[K] = {1, 2, 1};

	int B[N] = {0};

	int R = K/2;

	for(int i = 0; i < N; i++) {
		int sum = 0;

		for(int j = -R; j <= R; j++) {

			int idx = i + j;

			if(idx >= 0 && idx < N) {
				sum += A[idx] * M[j + R];
			}
		}

		B[i] = sum;
	}
	cout << "Input: ";

    	for (int i = 0; i < N; i++)
        	cout << A[i] << " ";

    	cout << "\nOutput: ";

    	for (int i = 0; i < N; i++)
        	cout << B[i] << " ";

    	cout << "\n";

    	return 0;
}
