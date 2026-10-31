#include <iostream>
using namespace std;

#define N 8
int main() {

	int A[N] = {10, 20, 30, 40, 50, 60, 70, 80};

	int sum = 0;


	//sequential reduction

	for(int i = 0; i < N; i++) {
		sum += A[i];
	}

	cout << "Array elements: ";

	for (int i = 0; i < N; i++) {
        	cout << A[i] << " ";
    	}

    	cout << "\nSequential sum = " << sum << endl;

    	return 0;
}
