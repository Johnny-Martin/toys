#include "stdafx.h"
#include "Log.h"
#include <ostream>
#include <Shlwapi.h>

using namespace std;
using namespace spdlog;

#pragma comment(lib,"Shlwapi.lib")

LogRapper::LogRapper()
{
	//init spdlog
	spdlog::set_level(spdlog::level::trace);
	spdlog::set_pattern("[%Y%m%d %H:%M:%S.%e T%t %l] %v");
	string filePath = "D:\\test_spdlog.log";
	if (PathFileExistsA(filePath.c_str())) {
		DeleteFileA(filePath.c_str());
	}
	
	m_spLogger = spdlog::basic_logger_mt("TestLog", filePath);
}
LogRapper& LogRapper::GetInstance()
{
	static LogRapper logger{};
	return logger;
}