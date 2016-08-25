// Template.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"
#include "trait.h"
#include <iostream>
using namespace std;

class Special {
public:
	typedef float AccValueType;
	static AccValueType zero() {
		return 0.0;
	}
};
int main()
{
	int iarr[] = { 1,3,5,7,9 };
	float farr[] = { 3.8, 4.4, 5.5, 6.8, 9.9 };

	auto  iret = accum(&iarr[0], &iarr[5]);
	auto  fret = accum(&farr[0], &farr[5]);
	cout << iret <<"   "<< fret<<endl;

	fret = Accum<float>::accum(&farr[0], &farr[5]);
	cout << fret << "    "<<typeid(fret).name()<< endl;

	auto ffret = Accum<float, Special>::accum(&farr[0], &farr[5]);
	cout << ffret << "    " << typeid(ffret).name() << endl;

	return 0;
}

