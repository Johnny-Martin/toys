#include "stdafx.h"

//Ϊ����鿴�ڴ�ֲ�������ʹ��pragma pack
//αָ�����Ʊ��������Զ�����
#pragma pack (1)
class BaseClass_NoVtb{
private:
	int m_nData;     //4
	char m_chData;   //1
	static float m_fData;//4

public:
	void FunA(){};
};

class DriveClass_NoVtb: public BaseClass_NoVtb{
	char* m_pszData; //4
	double m_dData;  //8
	void FunB(){};
};

#pragma pack ()