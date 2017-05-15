#pragma once
#include "..\stdafx.h"
#include <vector>
#include <string>
#include <iostream>
using namespace std;

class LongestPalindromeSolution {
	int IsPalindrome(string s, unsigned  int iBegin, unsigned  int iEnd) {
		int sum = iBegin + iEnd;
		for (unsigned  int i = iBegin; i <= (iEnd + iBegin)/2; ++i) {
			if (s[i] != s[sum - i])
				return 0;
		}
		return iEnd - iBegin;
	}
public:
	string longestPalindrome(string s) {
		unsigned int length = 0;
		unsigned  int iBegin = 0;
		unsigned  int iEnd = 0;
		for(unsigned  int i=0; i<s.length(); ++i)
			for (unsigned  int j = i + 1; j < s.length(); ++j) {
				unsigned  int tmp = IsPalindrome(s, i, j);
				if (tmp > length) {
					length = tmp;
					iBegin = i;
					iEnd = j;
				}
			}

		return s.substr(iBegin, iEnd - iBegin + 1);
	}

	void test() {
		string ret = longestPalindrome("bacbbcad");
		ret = longestPalindrome("cbbd");
		ret = longestPalindrome("babad");
		
		cout << ret << endl;
	}
};