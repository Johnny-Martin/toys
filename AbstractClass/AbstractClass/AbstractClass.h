#pragma once
#include "stdafx.h"

class Animal
{
public:
	int mLegCount;
	virtual void run()
	{
		int i = 1;
		++i;
	}
};

class Cat: public Animal
{
public:
	virtual void run()
	{
		int i=2;
		i += 2;
	}
};

class Dog:public Animal
{
public:
	virtual void run()
	{
		int i=2;
		i += 3;
	}
};

class Bear:public Cat,public Dog
{
public:
	virtual void newRun()
	{
		run();
		int i = 5;
		i += 5;
	}
};