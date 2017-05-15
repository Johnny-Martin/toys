// LeetCode.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"
#include "Solutions\TwoSum.h"
#include "Solutions\TriSum.h"
#include "Solutions\AddTwoNumbers.h"
#include "Solutions\LongestSubString.h"
#include "Solutions\LongestPalindrome.h"

int main()
{
	TwoSumSolution TwoSumSolutionTest;
	TwoSumSolutionTest.test();

	TriSumSolution TriSumSolutionTest;
	TriSumSolutionTest.test();

	AddTwoNumsSolution AddTwoNumsSolutionTest;
	AddTwoNumsSolutionTest.test();

	LongestSubStringSolution LongestSubStringSolutionTGest;
	LongestSubStringSolutionTGest.test();

	LongestPalindromeSolution LongestPalindromeSolutionTest;
	LongestPalindromeSolutionTest.test();
    return 0;
}

