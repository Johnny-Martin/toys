#pragma once
#include "stdafx.h"
#include <Windows.h>
#include <Map>
#include <Vector>
#include <String>
#include <fstream>
#include <iostream>

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

class KeyLogger {
public:
	static KeyLogger& GetInstance() { 
		static KeyLogger obj{}; 
		return obj;
	}
	~KeyLogger() {
		if (m_logFile) {
			m_logFile << std::endl << "==============================================共按键 "<< m_count<<" 次(不包括快捷键)====================================="<< std::endl;
			m_logFile.close();
		}

		if (m_hotkeyFile){
			m_logFile.close();
		}
	}

	void OnKeyDown(const DWORD& vk) {
		if (IsModifierKey(vk)){
			auto it = std::find(m_modifierStack.begin(), m_modifierStack.end(), vk);
			if (it == m_modifierStack.end()) {
				m_modifierStack.push_back(vk);
			}
		} else {
			if (PrintModifier()) {
				m_hotkeyFile << vkMapToStr[vk] << std::endl;
			} else {
				m_logFile << vkMapToStr[vk] << " ";
				m_count++;
				if (m_count %50 == 0){
					m_logFile << std::endl;
				}
			}
		}
	}

	void OnKeyUp(const DWORD& vk) {
		if (!IsModifierKey(vk))
			return;

		auto itFind = std::find(m_modifierStack.begin(), m_modifierStack.end(), vk);
		if (itFind != m_modifierStack.end()) {
			m_modifierStack.erase(itFind);
			return;
		}
	}

private:
	KeyLogger()
		:m_logFilePath("D:\\KeyboardRecord.txt")
		, m_hotFilePath("D:\\KeyboardRecord_hotkey.txt")
		, m_count(0)
	{
		m_logFile.open(m_logFilePath, std::ios::app);
		if (!m_logFile)
			std::cout << "Open File failed!" << std::endl;

		m_hotkeyFile.open(m_hotFilePath, std::ios::app);
		if (!m_hotkeyFile)
			std::cout << "Open m_hotkeyFile failed!" << std::endl;
	}

	bool IsModifierKey(const DWORD& vk) {
		if (vk != VK_LCONTROL && vk != VK_RCONTROL 
			&& vk != VK_LSHIFT && vk != VK_RSHIFT 
			&& vk != VK_LMENU && vk != VK_RMENU
			&& vk != VK_LWIN && vk != VK_RWIN
			) {

			return false;
		}
		return true;
	}

	bool PrintModifier() {
		if (m_modifierStack.size() == 0) return false;

		for (std::size_t i = 0; i < m_modifierStack.size(); ++i) {
			m_hotkeyFile << vkMapToStr[m_modifierStack[i]] << " + ";
		}
		return true;
	}
private:
	std::string					m_logFilePath;
	std::string					m_hotFilePath;
	std::ofstream				m_logFile;
	std::ofstream				m_hotkeyFile;
	std::vector<DWORD>			m_modifierStack;
	unsigned long long			m_count;
};


