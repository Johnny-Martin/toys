// AbstractClass.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"
#include "AbstractClass.h"


int _tmain(int argc, _TCHAR* argv[])
{
	Cat cat;
	cat.run();

	Dog dog;
	dog.run();

	Bear bear;
	bear.run();
	return 0;
}

