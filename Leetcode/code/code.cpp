// code.cpp : �������̨Ӧ�ó������ڵ㡣
//

#include "stdafx.h"
#include "TwoSum.h"
#include "TriSum.h"


int main()
{
	vector<int> test = { 0,3,0,1,1,-1,-5,-5,3,-3,-3,0 };
	TriSumSolution sul;

	vector<vector<int>> ret = sul.threeSum(test);

    return 0;
}

