#include <bits/stdc++.h>
using namespace std;


void merge(int arr[], int l, int mid, int r) {
	int n1 = mid - l + 1;
	int n2 = r - mid;

	int L[n1], R[n2];

	for(int i = 0; i < n1; i++) L[i] = arr[l + i];
	for(int j = 0; j < n2; j++) R[i] = arr[mid + 1 + i];

	int i = 0, j = 0, k = l;

	while(i < n1 && j < n2) {
		if(L[i] <= R[j]) {
			arr[k++] = L[i++];
		}else {
			arr[k++] = R[j++];
		}
	}

	while(i < n1) {
		arr[k++] = L[i++];
	}

	while(j < n2) {
		arr[k++] = R[j++];
	}

}

void mergesort(int arr[], int l, int r) {
	if(l >= r) return;

	int mid = l + (r - l) /2;

	mergesort(arr, l , mid);
	mergesort(arr, mid+1, r);

	merge(arr, l, mid, r);
}
