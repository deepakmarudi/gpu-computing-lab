#include <bits/stdc++.h>
using namespace std;

int main() {
	float A[4] = {
		1e20f, 
		3.14f,
		-1.e20f,
		2.0f
	};

	float sequential = 0.0f;

	for(int i = 0; i < 4; i++) {
		sequential += A[i];
	}

	float x = A[0] + A[1];
	float y = A[2] + A[3];

	float parallel = x + y;

	cout << setprecision(20);

	cout << "sequential sum: " << sequential << "\n";
	cout << "pairwisw sum: " << parallel << "\n";

	cout << "Expected sum: 5.14\n";

		
	return 0;
}
