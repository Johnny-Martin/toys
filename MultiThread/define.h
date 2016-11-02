#pragma once
#include "windows.h"
#include"string"
#include "ostream"
#include "iostream"

class Locker {
public:
	Locker();
	~Locker();
private:
	Locker(const Locker&) {};
	Locker& operator=(const Locker&) {};
	CRITICAL_SECTION m_CriticalSection;
};

namespace CSLocker{

class CriticalSection {
public:
	CriticalSection();
	~CriticalSection();
	void Lock();
	void UnLock();
private:
	CriticalSection(const CriticalSection&) {};
	CriticalSection& operator=(const CriticalSection&) {};
	CRITICAL_SECTION m_CriticalSection;
};

class Locker {
public:
	Locker(CriticalSection& cs);
	~Locker();
private:
	Locker& operator=(const Locker&) {};
	CriticalSection& m_CriticalSectionObj;
};

}

class AtomCout {
public:
	AtomCout(CSLocker::CriticalSection* pcs): m_pcs(pcs){}
	typedef std::ostream& (*EndlType)(std::ostream&);

	template<typename T, typename... Args>
	void out(T value, Args... args) {
		m_pcs->Lock();
		std::cout << value;
		out(args...);
		m_pcs->UnLock();
	}

	template<typename T>
	void out(T value) {
		m_pcs->Lock();
		std::cout << value;
		m_pcs->UnLock();
	}
private:
	CSLocker::CriticalSection* m_pcs;
};

extern AtomCout atomcout;
class Helper {
public:
	Helper(const std::string& sOwnerThreadName) :m_ThreadName(sOwnerThreadName) 
											//	, m_atomcout(AtomCout())
	{
		atomcout.out(m_ThreadName, " thread begin! ");
	}
	~Helper() {
		atomcout.out(m_ThreadName , " thread finish! \n");
	}
private:
	std::string m_ThreadName;
};