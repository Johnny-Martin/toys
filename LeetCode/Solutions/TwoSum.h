#pragma once

#include "vector"
#include<unordered_map>  

using namespace std;

class TwoSumSolution {
public:
	vector<int> twoSum(vector<int>& nums, int target) {
		unordered_map<int, int> hashMap;
		vector<int> result;
		for (unsigned  int i = 0; i < nums.size(); ++i) {
			if (hashMap.find(target - nums[i]) == hashMap.end()) {
				hashMap[nums[i]] = i;
			}else {
				result.push_back(i);
				result.push_back(hashMap[target - nums[i]]);
				return result;
			}
		}
		return result;
	}

	void test() {
		vector<int> test = { 2, 7, 11, 15 };
		vector<int> ret = twoSum(test, 9);
	}
};