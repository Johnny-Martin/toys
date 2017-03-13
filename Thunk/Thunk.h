#pragma once
#include<iostream>

class ClassA{
public:
	ClassA() {};
	void static Scallback(int A, int B) {
		std::cout << "static member function A: " << A << " B: " << B << std::endl;
	}
	void Callback(int A, int B) {
		std::cout << "non-static member function A: " << A << " B: " << B << std::endl;
	}
};

void normalCallback(int A, int B) {
	std::cout << "normal callback A: " << A << " B: " << B << std::endl;
}

void OldAPI(int argA, int argB, void(*func)(int A, int B)){
	func(argA, argB);
}

void OtherAPI(int argA, int argB, ClassA &obj, void(ClassA::*func)(int, int)) {
	(obj.*func)(argA, argB);
}

