// code.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"
#include "TwoSum.h"
#include "TriSum.h"
#include "AddTwoNumbers.h"
#include "LongestSubString.h"


int main()
{
	vector<int> test = { 0,3,0,1,1,-1,-5,-5,3,-3,-3,0 };
	TriSumSolution sul;

	vector<vector<int>> ret = sul.threeSum(test);

	AddTwoNumsSolution AddTwoNumsSolutionTest;
	AddTwoNumsSolutionTest.test();

	LongestSubStringSolution LongestSubStringSolutionTGest;
	LongestSubStringSolutionTGest.test();
    return 0;
}

