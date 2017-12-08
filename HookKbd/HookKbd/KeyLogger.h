#pragma once
#include "stdafx.h"
#include <Windows.h>
#include <Map>
#include <Vector>
#include <String>
#include <fstream>
#include <iostream>
#include <algorithm>

extern std::map<DWORD, const char*> vkMapToStr;

using  PAIR = std::pair<DWORD, unsigned long long>;
class CmpByCount {
public:
	inline bool operator()(const PAIR& k1, const PAIR& k2) {
		return k1.second > k2.second;
	}
};

class KeyLogger {
public:
	static KeyLogger* GetInstance();
	~KeyLogger();

	void OnKeyDown(const DWORD& vk);

	void OnKeyUp(const DWORD& vk);

private:
	KeyLogger();

	bool IsModifierKey(const DWORD& vk);

	bool PrintModifier();

	void PrintReport();
private:
	std::string							m_logFilePath;
	std::string							m_hotFilePath;
	std::ofstream						m_logFile;
	std::ofstream						m_hotkeyFile;
	std::vector<DWORD>					m_modifierStack;
	std::map<DWORD, unsigned long long>	m_statistics;
	unsigned long long					m_count;
};
