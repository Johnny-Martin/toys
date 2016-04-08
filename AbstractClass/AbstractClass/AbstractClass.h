#pragma once
#include "stdafx.h"
#include "iostream"

using namespace std;

class Animal
{
public:
	int mLegCount;
	virtual void run()
	{
		cout<<"Animal run"<<endl;
	}
};

class Cat: public Animal
{
public:
	virtual void run()
	{
		cout<<"Cat run"<<endl;
	}
};

class Dog:public Animal
{
public:
	virtual void run()
	{
		cout<<"Dog run"<<endl;
	}
};

class Bear:public Cat, public Dog
{
public:
	//virtual void run()
	//{
	//	cout<<"Bear run"<<endl;
	//}

 	virtual void newRun()
 	{
 		run();
 		int i = 5;
 		i += 5;
 	}
	
};