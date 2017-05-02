#pragma once

#include <vector>
#include <algorithm>    // std::find
using namespace std;

class TriSumSolution {
public:
	bool Judgement(vector<vector<int>> src, vector<int> tar) {
		int count = 0;
		for (unsigned int i = 0; i < src.size(); ++i) {
			vector<int> srcTmp = src[i];
			vector<int> tarTmp = tar;
			for (unsigned int iSrc = srcTmp.size(); iSrc > 0; ++iSrc) {
				for (unsigned int iTar = tarTmp.size(); iTar > 0; ++iTar) {

				}
			}
			if (count == src[i].size()) {
				return false;
			}
		}

		return true;
	}
	vector<vector<int>> threeSum(vector<int>& nums) {
		vector<vector<int>> result;

		for (unsigned int i = 0; i < nums.size(); ++i) {
			for (unsigned int j = i + 1; j < nums.size(); ++j) {
				for (unsigned int k = j + 1; k < nums.size(); ++k) {
					if (nums[i] + nums[j] + nums[k] == 0) {
						vector<int> item;
						item.push_back(nums[i]);
						item.push_back(nums[j]);
						item.push_back(nums[k]);

						if(Judgement(result, item))
							result.push_back(item);
					}
				}
			}
		}

		return result;
	}
};