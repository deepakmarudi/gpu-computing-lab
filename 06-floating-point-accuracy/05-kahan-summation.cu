#include <bits/stdc++.h>
using namespace std;


int main() {

	const int N = 1000000;

	float normal = 0.0f;
	float sum = 0.0f;
	float c = 0.0f;

	for(int i = 0; i < N; i++) {

		float value = 0.0001f;

		normal += value;

		float y = value - c;
		float t = sum + y;

		c = (t - sum) - y;
		sum = t;
	}

	cout << setprecision(15);

	cout << "Normal sum: " << normal << "\n";
	cout << "Kahan sum: " << sum << "\n";

	cout << "Expected: " << N * 0.0001 << "\n";

	return 0;

}

