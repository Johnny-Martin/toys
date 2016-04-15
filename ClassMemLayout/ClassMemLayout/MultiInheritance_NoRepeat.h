#include "stdafx.h"

#pragma pack (1)
class BaseClassA_WithVtb{
private:
	int m_nDataA;     //4
	char m_chDataA;   //1
	static float m_fDataA;//4

public:
	virtual void FunA(){};
};

class BaseClassB_WithVtb{
private:
	int m_nDataB;     //4
	char m_chDataB;   //1
	static float m_fDataB;//4

public:
	virtual void FunB(){};
};

class DriveClass_WithVtb_Multi: public BaseClassA_WithVtb,
						  public BaseClassB_WithVtb
{
	char* m_pszData; //4
	double m_dData;  //8
	void FunC(){};
	virtual void FunD(){};
};

#pragma pack ()