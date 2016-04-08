#include "stdafx.h"
#include "iostream"

using namespace std;

template <class Drived>
class Base
{
public:
	void Func()
	{
		static_cast<Drived*>(this)->FuncImpl();
	}
	void FuncImpl()
	{
		cout<<"FuncImpl in Base"<<endl;
	}
};

class Drive: public Base<Drive>
{
public:
	void FuncImpl()
	{
		cout<<"FuncImpl in Drive"<<endl;
	}
};