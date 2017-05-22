// Template.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"
#include "trait.h"
#include "static_assert.h"
#include <iostream>
//using namespace std;

class Special {
public:
	typedef float AccValueType;
	static AccValueType zero() {
		return 0.0;
	}
};

struct str_a {
	int data;
};

class cls_a {
	int data;
};



int main()
{
	/*
	int iarr[] = { 1,3,5,7,9 };
	float farr[] = { 3.8, 4.4, 5.5, 6.8, 9.9 };

	auto  iret = accum(&iarr[0], &iarr[5]);
	auto  fret = accum(&farr[0], &farr[5]);
	cout << iret <<"   "<< fret<<endl;

	fret = Accum<float>::accum(&farr[0], &farr[5]);
	cout << fret << "    "<<typeid(fret).name()<< endl;

	auto ffret = Accum<float, Special>::accum(&farr[0], &farr[5]);
	cout << ffret << "    " << typeid(ffret).name() << endl;
	 
	cout << IsClassType<str_a>::YES << endl;
	cout << IsClassType<cls_a>::YES << endl;
	cout << IsClassType<int>::YES << endl;
	*/

	/////////////////////////promotion trait////////////////////
	auto AddRetA = Add(123, 333.4);
	std::cout << AddRetA << "    " << typeid(AddRetA).name() << std::endl;
	std::cout << 333.4 << "    " << typeid(333.4).name() << std::endl;

	auto AddRetB = Add(123, 'a');
	std::cout << AddRetB << "    " << typeid(AddRetB).name() << std::endl;

	ASSERT(true, EROROROROROR);
	return 0;
}