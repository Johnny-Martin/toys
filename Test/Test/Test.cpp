// Test.cpp : �������̨Ӧ�ó������ڵ㡣
//

#include "stdafx.h"
#include "Test.h"
#include <map>

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

	int a = 10;
	map<string, string> testMap;
	testMap.insert(pair<string, string>("A", "AAA"));

	string pA = testMap["A"];
	pA = testMap["B"];

	if (testMap.end() != testMap.find("B"))
		cout << "what the fuck";
    return 0;
}

