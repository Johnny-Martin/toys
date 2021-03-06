#include "stdafx.h"
#include "KeyLogger.h"

KeyLogger* KeyLogger::GetInstance()
{
	KeyLogger* obj = new KeyLogger();
	return obj;
}
KeyLogger::~KeyLogger()
{
	if (m_logFile) {
		PrintReport();
		m_logFile.close();
	}

	if (m_hotkeyFile) {
		PrintReportH();
		m_logFile.close();
	}
}

void KeyLogger::OnKeyDown(const DWORD& vk)
{
	if (IsModifierKey(vk)) {
		auto it = std::find(m_modifierStack.begin(), m_modifierStack.end(), vk);
		if (it == m_modifierStack.end()) {
			m_modifierStack.push_back(vk);
		}
	} else {
		if (m_modifierStack.size() > 0) {
			std::string strHotkey = GetHotkeyStr(vk);
			m_statistics_H[strHotkey]++;

			m_hotkeyFile << strHotkey << std::endl;
		} else {
			m_logFile << vkMapToStr[vk] << " ";
			m_count++;
			if (m_count % 50 == 0) {
				m_logFile << std::endl;
			}
			m_statistics[vk]++;
		}
	}
}

void KeyLogger::OnKeyUp(const DWORD& vk)
{
	if (!IsModifierKey(vk))
		return;

	//不同于ctrl与alt,shift与win键单独按下是有意义的(输入法、大小写、开始菜单)，需要打印shift与win键
	if (m_modifierStack.size() == 1) {
		if (m_modifierStack[0] == VK_LSHIFT || m_modifierStack[0] == VK_RSHIFT || m_modifierStack[0] == VK_LWIN || m_modifierStack[0] == VK_RWIN)
		{//假如按了诸如ctrl + shift + g这样的快捷键，先松开ctrl 跟 g,最后松开shift,也会进到这里，考虑到这样复杂的快捷键频率较小，不做处理了。
			m_hotkeyFile << vkMapToStr[m_modifierStack[0]] << std::endl;
		}
	}
	auto itFind = std::find(m_modifierStack.begin(), m_modifierStack.end(), vk);
	if (itFind != m_modifierStack.end()) {
		m_modifierStack.erase(itFind);
		return;
	}
}

KeyLogger::KeyLogger()
	:m_logFilePath("D:\\KeyboardRecord.txt")
	, m_hotFilePath("D:\\KeyboardRecord_hotkey.txt")
	, m_count(0)
	, m_statistics()
{
	m_logFile.open(m_logFilePath, std::ios::app);
	if (!m_logFile)
		std::cout << "Open File failed!" << std::endl;

	m_hotkeyFile.open(m_hotFilePath, std::ios::app);
	if (!m_hotkeyFile)
		std::cout << "Open m_hotkeyFile failed!" << std::endl;
}

bool KeyLogger::IsModifierKey(const DWORD& vk)
{
	if (vk != VK_LCONTROL && vk != VK_RCONTROL
		&& vk != VK_LSHIFT && vk != VK_RSHIFT
		&& vk != VK_LMENU && vk != VK_RMENU
		&& vk != VK_LWIN && vk != VK_RWIN
		) {

		return false;
	}
	return true;
}

void KeyLogger::PrintReport()
{
	//std::sort(m_statistics.begin(), m_statistics.end(), );
	std::vector<PAIR> temp(m_statistics.begin(), m_statistics.end());
	std::sort(temp.begin(), temp.end(), CmpByCount());

	m_logFile << std::endl << "===============================================按键统计===============================================" << std::endl;
	m_logFile << "共按键 " << m_count << " 次(不包括快捷键)" << std::endl;
	for (auto it = temp.begin(); it != temp.end(); ++it)
	{
		if (it->second > 0)
		{
			m_logFile << vkMapToStr[it->first] << " : " << it->second << " 次" << std::endl;
		}
	}
	m_logFile << "====================================================================================================" << std::endl;
}

void KeyLogger::PrintReportH()
{
	//std::sort(m_statistics.begin(), m_statistics.end(), );
	std::vector<PAIR_H> temp(m_statistics_H.begin(), m_statistics_H.end());
	std::sort(temp.begin(), temp.end(), CmpByCount_H());

	m_hotkeyFile << std::endl << "===============================================快捷键统计===============================================" << std::endl;
	for (auto it = temp.begin(); it != temp.end(); ++it)
	{
		if (it->second > 0)
		{
			m_hotkeyFile << it->first << " : " << it->second << " 次" << std::endl;
		}
	}
	m_hotkeyFile << "======================================================================================================" << std::endl;
}

std::string KeyLogger::GetHotkeyStr(const DWORD& vk)
{
	std::stringstream ss;

	for (std::size_t i = 0; i < m_modifierStack.size(); ++i) {
		ss << vkMapToStr[m_modifierStack[i]] << " + ";
	}
	ss << vkMapToStr[vk];
	return ss.str();
}

std::map<DWORD, const char*> vkMapToStr = {
	{ VK_LSHIFT ,		"LShift" },
	{ VK_RSHIFT ,		"RShift" },
	{ VK_LCONTROL ,		"LCtrl" },
	{ VK_RCONTROL ,		"RCtrl" },
	{ VK_LMENU ,		"LAlt" },
	{ VK_RMENU ,		"LAlt" },
	{ VK_LWIN ,			"LWin" },
	{ VK_RWIN ,			"RWin" },
	{ VK_APPS ,			"Menu" },
	{ VK_ESCAPE ,		"Esc" },
	{ VK_TAB ,			"Tab" },
	{ VK_SPACE ,		"Space" },
	{ VK_RETURN ,		"Enter" },
	{ VK_BACK ,			"Back" },

	{ VK_END ,			"End" },
	{ VK_HOME ,			"Home" },
	{ VK_PRIOR ,		"PageUp" },
	{ VK_NEXT ,			"PageDown" },
	{ VK_INSERT ,		"Insert" },
	{ VK_DELETE ,		"Del" },

	{ VK_LEFT ,			"Left" },
	{ VK_UP ,			"Up" },
	{ VK_RIGHT ,		"Right" },
	{ VK_DOWN ,			"Down" },

	{ VK_PRINT ,		"Print" },
	{ VK_SLEEP ,		"Sleep" },
	{ VK_SNAPSHOT ,		"PrtSC" },
	{ VK_PAUSE ,		"Pause" },

	{ VK_NUMLOCK ,		"NumLock" },
	{ VK_SCROLL ,		"ScrollLock" },
	{ VK_CAPITAL ,		"CapsLock" },

	//数字小键盘区
	{ VK_NUMPAD0 ,		"Num0" },
	{ VK_NUMPAD1 ,		"Num1" },
	{ VK_NUMPAD2 ,		"Num2" },
	{ VK_NUMPAD3 ,		"Num3" },
	{ VK_NUMPAD4 ,		"Num4" },
	{ VK_NUMPAD5 ,		"Num5" },
	{ VK_NUMPAD6 ,		"Num6" },
	{ VK_NUMPAD7 ,		"Num7" },
	{ VK_NUMPAD8 ,		"Num8" },
	{ VK_NUMPAD9 ,		"Num9" },
	{ VK_MULTIPLY ,		"Num*" },
	{ VK_ADD ,			"Num+" },
	{ VK_SEPARATOR ,	"NumEnter" },
	{ VK_SUBTRACT ,		"Num-" },
	{ VK_DECIMAL ,		"Num." },
	{ VK_DIVIDE ,		"Num/" },
	{ VK_OEM_NEC_EQUAL ,"Num=" },
	{ VK_CLEAR ,		"Clear"},//数字小键盘不打开numlock时，5键是clear键
	//F区
	{ VK_F1 ,			"F1" },
	{ VK_F2 ,			"F2" },
	{ VK_F3 ,			"F3" },
	{ VK_F4 ,			"F4" },
	{ VK_F5 ,			"F5" },
	{ VK_F6 ,			"F6" },
	{ VK_F7 ,			"F7" },
	{ VK_F8 ,			"F8" },
	{ VK_F9 ,			"F9" },
	{ VK_F10 ,			"F10" },
	{ VK_F11 ,			"F11" },
	{ VK_F12 ,			"F12" },

	{ VK_OEM_1 ,		";:" },
	{ VK_OEM_PLUS ,		"+" },
	{ VK_OEM_COMMA ,	"," },
	{ VK_OEM_MINUS ,	"-" },
	{ VK_OEM_PERIOD ,	"." },
	{ VK_OEM_2 ,		"/?" },
	{ VK_OEM_3 ,		"`~" },
	{ VK_OEM_4 ,		"[{" },
	{ VK_OEM_5 ,		"\\|" },
	{ VK_OEM_6 ,		"]}" },
	{ VK_OEM_7 ,		"'\"" },

	//数字及字母
	{ '0' , "0" },
	{ '1' , "1" },
	{ '2' , "2" },
	{ '3' , "3" },
	{ '4' , "4" },
	{ '5' , "5" },
	{ '6' , "6" },
	{ '7' , "7" },
	{ '8' , "8" },
	{ '9' , "9" },
	{ 'A' , "A" },
	{ 'B' , "B" },
	{ 'C' , "C" },
	{ 'D' , "D" },
	{ 'E' , "E" },
	{ 'F' , "F" },
	{ 'G' , "G" },
	{ 'H' , "H" },
	{ 'I' , "I" },
	{ 'J' , "J" },
	{ 'K' , "K" },
	{ 'L' , "L" },
	{ 'M' , "M" },
	{ 'N' , "N" },
	{ 'O' , "O" },
	{ 'P' , "P" },
	{ 'Q' , "Q" },
	{ 'R' , "R" },
	{ 'S' , "S" },
	{ 'T' , "T" },
	{ 'U' , "U" },
	{ 'V' , "V" },
	{ 'W' , "W" },
	{ 'X' , "X" },
	{ 'Y' , "Y" },
	{ 'Z' , "Z" }
};