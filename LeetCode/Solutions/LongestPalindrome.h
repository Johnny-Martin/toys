#pragma once
#include "..\stdafx.h"
#include <vector>
#include <string>
#include <iostream>
using namespace std;

#define MAX(a, b) (((a) > (b)) ? (a) : (b))

class LongestPalindromeSolution {
	int IsPalindrome(string s, unsigned  int iBegin, unsigned  int iEnd) {
		int sum = iBegin + iEnd;
		for (unsigned  int i = iBegin; i <= (iEnd + iBegin)/2; ++i) {
			if (s[i] != s[sum - i])
				return 0;
		}
		return iEnd - iBegin + 1;
	}
public:
	string longestPalindrome(string s) {
		unsigned int length = 0;
		unsigned  int iBegin = 0;
		unsigned  int iEnd = 0;

		for(unsigned  int i=0; i<s.length(); ++i){
			for (unsigned  int j = s.length() - 1; j >= MAX(i, iEnd); --j) {
				unsigned  int tmp = IsPalindrome(s, i, j);
				if (tmp > length) {
					length = tmp;
					iBegin = i;
					iEnd = j;
					break;
				}else if (tmp > 0) {
					break;
				}
			}
		}
		return s.substr(iBegin, iEnd - iBegin + 1);
	}

	void test() {
		string ret = longestPalindrome("bacbbcad");
		ret = longestPalindrome("bb");
		ret = longestPalindrome("babad");
		ret = longestPalindrome("a");
		ret = longestPalindrome("babadada");
		
		//longestPalindrome();
		cout << ret << endl;
	}
};