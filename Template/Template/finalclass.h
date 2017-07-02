#pragma once
#include <iostream>

class FinalClass
{
private:
	FinalClass() {};
public:
	FinalClass* CreateInstance()
	{
		return new FinalClass();
	}
};

//class DriveClass: public FinalClass
//{
//	//ÎÞ·¨¼Ì³ÐFinalBase
//public:
//	DriveClass(){}
//};

template<typename T>
class FinalBase
{
	friend typename T;
private:
	FinalBase(){}
	FinalBase(const FinalBase&){}
};

class TestFinal : public virtual FinalBase<TestFinal>
{
public:
	TestFinal() {
		std::cout << "Init TestFinal" << std::endl;
	}
};

//class Test :public TestFinal
//{
//public:
//	Test()
//	{
//		std::cout << "Init Test" << std::endl;
//	}
//};