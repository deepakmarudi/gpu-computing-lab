#include <bits/stdc++.h>
using namespace std;

int main() {
	float a = 1.2345f;
	float b = 2.3456f;
	float c = 3.4567f;

	volatile float product = a * b;
	float normal = product + c;

	float fused = fma(a, b, c);
	cout << setprecision(20);

	cout << "Normal result: " << normal << "\n";
	cout << "FMA result: " << fused << "\n";

	cout << "Difference: " << abs(normal - fused) << "\n";

	return 0;
}
