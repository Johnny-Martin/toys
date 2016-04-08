#include "stdafx.h"
#include "iostream"

using namespace std;
class VtbBase
{
public:
	virtual void Func()
	{
		cout<<"VtbBase Func"<<endl;
	}
};

class VtbDrive:public VtbBase
{
public:
	void Func()
	{
		cout<<"VtbDrive Func"<<endl;
	}
};