// Test.cpp : �������̨Ӧ�ó������ڵ㡣
//

#include "stdafx.h"
#include "Test.h"


int main()
{
	UIBase base;
	const string name  = base.GetObjectID_1();
	cout << name << endl;					     //������������Ч�ʵ͡�m_attrMap["id"]=>name����һ�ο������죬return name->name��һ��
	
	const string& rname = base.GetObjectID_2();  //������������Ч�ʵ�
	//const string* pName = base.GetObjectID_3();//GetObjeID���ص��Ǿֲ������ĵ�ַ
	//cout << *pName << endl;				     //�˴��ڴ�����쳣����ΪpNameָ����ַ����Ѿ���������

	//const string* pName2 = base.GetObjectID_4(); //GetObjeID2���صĲ����Ǿֲ������ĵ�ַ������map�ĳ�Ա�ĵ�ַ
	//cout << *pName2 << endl;				     //����
	//delete pName2;						         //��������������ˣ�������map�ĳ�Ա��

	auto spName = base.GetObjectID_7();
	if(!spName->empty())
		cout << *spName << endl;
	//(*spName)[0] = '4';
	cout << *spName << endl;


    return 0;
}

