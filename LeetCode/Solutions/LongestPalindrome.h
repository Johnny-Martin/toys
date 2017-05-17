#pragma once
#include "..\stdafx.h"
#include <vector>
#include <string>
#include <iostream>
using namespace std;

class LongestPalindromeSolution {

public:
	string longestPalindrome(string s) {
		unsigned int maxLength = 0;
		unsigned  int iLeft = 0;

		for(int i=0; i<s.length(); ++i){
			int iBegin = i;
			int iEnd = i;
			int length = 0;
			while (s[iEnd] == s[iEnd + 1]) ++iEnd;
			length = iEnd - iBegin + 1;
			if (length > maxLength) {
				maxLength = length;
				iLeft = iBegin;
			}

			while (--iBegin >= 0 && ++iEnd < s.length()) {
				if (s[iBegin] == s[iEnd]) {
					length = iEnd - iBegin + 1;
					if (length > maxLength) {
						maxLength = length;
						iLeft = iBegin;
					}
				}else {
					break;
				}
			}
			
		}
		return s.substr(iLeft, maxLength);
	}

	void test() {
		string ret = longestPalindrome("zbbb");
		ret = longestPalindrome("bacbbcad");
		ret = longestPalindrome("bb");
		ret = longestPalindrome("babad");
		ret = longestPalindrome("a");
		ret = longestPalindrome("babadada");
		
		//longestPalindrome();
		cout << ret << endl;
	}
};