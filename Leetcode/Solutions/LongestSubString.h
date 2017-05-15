#pragma once
#include "stdafx.h"
#include <vector>
#include <string>    // std::find
using namespace std;


class LongestSubStringSolution {
public:
	int lengthOfLongestSubstring(string s) {
		vector<int> bucket(256, -1);
		int maxLength = 0, startIndex = -1;
		for (int i = 0; i < s.length(); ++i) {
			if (bucket[s[i]] > startIndex)
				startIndex = bucket[s[i]];

			maxLength = ((i - startIndex) > maxLength) ? (i - startIndex) : maxLength;
			bucket[s[i]] = i;
		}

		return maxLength;
	}

	void test() {
		lengthOfLongestSubstring("dvdf");
	}
};