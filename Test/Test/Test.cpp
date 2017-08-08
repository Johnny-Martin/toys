// Test.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"
#include "Test.h"


int main()
{
	UIBase base;
	const string name  = base.GetObjectID_1();
	cout << name << endl;					     //很正常，但是效率低。m_attrMap["id"]=>name经历一次拷贝构造，return name->name又一次
	
	const string& rname = base.GetObjectID_2();  //很正常，但是效率低
	//const string* pName = base.GetObjectID_3();//GetObjeID返回的是局部变量的地址
	//cout << *pName << endl;				     //此处内存访问异常，因为pName指向的字符串已经被销毁了

	//const string* pName2 = base.GetObjectID_4(); //GetObjeID2返回的不再是局部变量的地址，而是map的成员的地址
	//cout << *pName2 << endl;				     //正常
	//delete pName2;						         //这里就又是作死了，销毁了map的成员！

	auto spName = base.GetObjectID_7();
	if(!spName->empty())
		cout << *spName << endl;
	//(*spName)[0] = '4';
	cout << *spName << endl;


    return 0;
}

