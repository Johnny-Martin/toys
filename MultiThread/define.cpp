#include "stdafx.h"
#include"define.h"

//Ð§ÂÊµÍÏÂ
Locker::Locker(){
	::InitializeCriticalSection(&m_CriticalSection);
	::EnterCriticalSection(&m_CriticalSection);
}

Locker::~Locker() {
	::LeaveCriticalSection(&m_CriticalSection);
	::DeleteCriticalSection(&m_CriticalSection);
}

CSLocker::CriticalSection::CriticalSection() {
	::InitializeCriticalSection(&m_CriticalSection);
}

CSLocker::CriticalSection::~CriticalSection() {
	::DeleteCriticalSection(&m_CriticalSection);
}

void  CSLocker::CriticalSection::Lock() {
	::EnterCriticalSection(&m_CriticalSection);
}

void  CSLocker::CriticalSection::UnLock() {
	::LeaveCriticalSection(&m_CriticalSection);
}

CSLocker::Locker::Locker(CriticalSection& cs) : m_CriticalSectionObj(cs) {
	m_CriticalSectionObj.Lock();
}

CSLocker::Locker::~Locker() {
	m_CriticalSectionObj.UnLock();
}

CSLocker::CriticalSection* AtomCout::m_pcs = new CSLocker::CriticalSection();

AtomCout atomcout = AtomCout();

template <typename T>
AtomCout& AtomCout::operator<< (T param) {
	m_pcs->Lock();
	std::cout << param;
	m_pcs->UnLock();

	return *this;
}

AtomCout& AtomCout::operator<< (std::ostream& (*param)(std::ostream&)) {
	m_pcs->Lock();
	std::cout << param;
	m_pcs->UnLock();

	return *this;
}