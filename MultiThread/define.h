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
	template <typename T>
	AtomCout& operator<< (T);

	AtomCout& operator<< (std::ostream& (*op)(std::ostream&));
private:
	static  CSLocker::CriticalSection* m_pcs;
};

extern AtomCout atomcout;

class Helper {
public:
	Helper(const std::string& sOwnerThreadName) :m_ThreadName(sOwnerThreadName) {
		//atomcout << m_ThreadName << " thread begin!" << std::endl;
	}
	~Helper() {
		//atomcout << m_ThreadName << " thread finish!" << std::endl;
	}
private:
	std::string m_ThreadName;
};