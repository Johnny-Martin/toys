#include "stdafx.h"

#pragma pack (1)
class BaseClass_WithVtb{
private:
	int m_nData;     //4
	char m_chData;   //1
	static float m_fData;//4

public:
	virtual void FunA(){};
};

class DriveClass_WithVtb: public BaseClass_WithVtb{
	char* m_pszData; //4
	double m_dData;  //8
	void FunB(){};
};

#pragma pack ()