// Thunk.cpp : �������̨Ӧ�ó������ڵ㡣
//

#include "stdafx.h"
#include "Thunk.h"


int main()
{
	OldAPI(2, 3, normalCallback);

	ClassA obj;
	OldAPI(3, 4, obj.Scallback);

	//OldAPI(4, 5, obj.Callback);
	OtherAPI(4, 5, obj, &ClassA::Callback);
	return 0;
}

