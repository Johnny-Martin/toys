// DLL.cpp : ���� DLL Ӧ�ó���ĵ���������
//

#include "stdafx.h"
#include <DbgHelp.h>  
#pragma comment(lib, "dbghelp.lib") 

extern "C" __declspec(dllexport) LONG __stdcall HSTUnhandledExceptionFilter(PEXCEPTION_POINTERS pExceptionInfo)
{
	auto CreateMiniDump = [](PEXCEPTION_POINTERS pep, LPCTSTR strFileName)->void
	{
		HANDLE hFile = CreateFile(strFileName, GENERIC_READ | GENERIC_WRITE,
			FILE_SHARE_WRITE, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);

		if ((hFile != NULL) && (hFile != INVALID_HANDLE_VALUE))
		{
			MINIDUMP_EXCEPTION_INFORMATION mdei;
			mdei.ThreadId = GetCurrentThreadId();
			mdei.ExceptionPointers = pep;
			mdei.ClientPointers = TRUE;

			MINIDUMP_CALLBACK_INFORMATION mci;
			mci.CallbackRoutine = (MINIDUMP_CALLBACK_ROUTINE)NULL;
			mci.CallbackParam = 0;

			::MiniDumpWriteDump(::GetCurrentProcess(), ::GetCurrentProcessId(), hFile, MiniDumpNormal, (pep != 0) ? &mdei : 0, NULL, NULL);

			CloseHandle(hFile);
		}
	};

	CreateMiniDump(pExceptionInfo, L"D:\\HSTDump.dmp");

	//��������ϱ�exe����չʾ��ʾ����
	MessageBox(NULL, L"��Ǹ�����������������Ӧ�ó��򡣡���", NULL, MB_OK);
	return EXCEPTION_EXECUTE_HANDLER;
}

