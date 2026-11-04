#include <bits/stdc++.h>
using namespace std;

int main() {

	const int N = 5;
	const int K = 3;
	const int O = N - K + 1;

	int A[N][N] = {
		{1, 2, 3, 4, 5}, 
		{6, 7, 8, 9, 10},
		{11, 12, 13, 14, 15},
		{16, 17, 18, 19, 20},
		{21, 22, 23, 24, 25}
	};

	int M[K][K] = {
		{1, 0, 1},
		{0, 1, 0},
		{1, 0, 1}
	};

	int B[O][O] = {};


	for(int i = 0; i < O; i++) {
		for(int j = 0; j < O; j++) {
			int sum = 0;
			for(int x = 0; x < K; x++) {
				for(int y = 0; y < K; y++) {
					sum += A[i + x][j + y] * M[x][y];
				}
			}
			B[i][j] = sum;
		}
	}

	cout << "Output:\n";

    	for (int i = 0; i < O; i++) {
        	for (int j = 0; j < O; j++) {
            		cout << B[i][j] << "\t";
        	}
        	cout << "\n";
    	}

    	return 0;
}
