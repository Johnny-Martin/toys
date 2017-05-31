#pragma once
#include "stdafx.h"

LSTATUS GetRegValue(HKEY rootKey, std::wstring wsSubKey, std::wstring& wsData) {
	HKEY key;
	LSTATUS retValue = RegOpenKeyEx(rootKey, wsSubKey.c_str(), 0, KEY_WRITE | KEY_READ, &key);
	if (retValue != ERROR_SUCCESS) {
		std::cout << "打开注册表失败" << std::endl;
		return retValue;
	}

	wchar_t wszCLSID[MAX_PACKAGE_NAME];
	DWORD cnt = MAX_PACKAGE_NAME;
	retValue = RegGetValue(key, _T(""), _T(""), RRF_RT_REG_SZ, NULL, (void*)wszCLSID, &cnt);
	RegCloseKey(key);

	wsData = wszCLSID;
	return retValue;
}

LSTATUS SetRegValue(HKEY rootKey, std::wstring wsSubKey, std::wstring wsData) {
	HKEY key;
	LSTATUS retValue = RegOpenKeyEx(rootKey, _T(""), 0, KEY_WRITE | KEY_READ, &key);
	if (retValue != ERROR_SUCCESS) {
		std::cout << "打开注册表失败" << std::endl;
		return retValue;
	}

	//依次创建wsSubKey路径中的子键
	std::vector<std::wstring> subKeyVec;
	int newPos = 0;
	int oldPos = 0;
	while (true) {
		newPos = wsSubKey.find(_T("\\"), oldPos);
		if (newPos != std::string::npos) {
			subKeyVec.push_back(wsSubKey.substr(oldPos, newPos - oldPos));
			oldPos = newPos + 1;
		}
		else {
			break;
		}
	}
	if (subKeyVec.size() == 0) {
		return ERROR_INVALID_FUNCTION;
	}

	HKEY fatherKey = key;
	HKEY subKey = 0;
	for (size_t i = 0; i < subKeyVec.size(); ++i) {
		DWORD dw;
		RegCreateKeyEx(fatherKey,
			subKeyVec[i].c_str(),
			NULL,
			NULL,
			REG_OPTION_NON_VOLATILE,
			KEY_WRITE | KEY_READ, NULL,
			&subKey,
			&dw);
		RegCloseKey(fatherKey);
		fatherKey = subKey;
	}

	retValue = RegSetValue(subKey, _T(""), REG_SZ, wsData.c_str(), wsData.length());
	RegCloseKey(subKey);

	return retValue;
}

/*
*StringFromGUID2()可以实现相同的作用，为了避免引入COM相关的头文件
*此处简单实现CLSID2Str——直接返回固定的CLSID
*/
std::wstring& CLSID2Str(const IID clsid) {
	std::wstring ret = _T("{354CD5C5-839B-4A1E-8033-0EBC5246A4EF}");
	return ret;
}

std::wstring& GetDllPathByCLSID(const IID clsid) {
	std::wstring strDllPath;
	std::wstring wsCLSID = CLSID2Str(clsid);
	std::wstring wsInproc = _T("CLSID\\");
	wsInproc.append(wsCLSID);
	wsInproc.append(_T("\\InprocServer32"));
	GetRegValue(HKEY_CLASSES_ROOT, wsInproc.c_str(), strDllPath);
	return strDllPath;
}