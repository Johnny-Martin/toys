#pragma once

#include "vector"
#include<unordered_map>  

using namespace std;

class Solution {
public:
	vector<int> twoSum(vector<int>& nums, int target) {
		unordered_map<int, int> hashMap;
		for (int i = 0; i < nums.size(); ++i) {
			if (hashMap.find(target - nums[i]) != hashMap.end()) {
				hashMap[nums[i]] = i;
			}else {
				vector<int> result;
				result.push_back(i);
				result.push_back(hashMap[target - nums[i]]);
			}
		}
	}
};