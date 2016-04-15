#include "stdafx.h"

#pragma pack (1)
class Interface{
public:
	int data;
	virtual void InterfaceA() = 0;
	virtual void InterfaceB() = 0;
};
class BaseClassA_WithVtb_WithRepeat: public Interface{
private:
	int m_nDataA;     //4
	char m_chDataA;   //1
	static float m_fDataA;//4

public:
	virtual void FunA(){};
};

class BaseClassB_WithVtb_WithRepeat: public Interface{
private:
	int m_nDataB;     //4
	char m_chDataB;   //1
	static float m_fDataB;//4

public:
	virtual void FunB(){};
};

class DriveClass_WithVtb_Multi_WithRepeat:  public BaseClassA_WithVtb_WithRepeat,
										    public BaseClassB_WithVtb_WithRepeat
{
public:
	char* m_pszData; //4
	double m_dData;  //8
	void FunC(){
		InterfaceA();
	};
	virtual void FunD(){};
	void InterfaceA(){};
	void InterfaceB(){};
};

#pragma pack ()