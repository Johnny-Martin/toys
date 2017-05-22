#pragma once

class ReverseIntegerSolution {
public:
	int reverse(int x) {
		bool flag = x < 0;
		unsigned int tmp = flag ? (-x) : x;
		unsigned long long result = 0;
		while (tmp > 0) {
			result = result * 10 + (tmp % 10);
			tmp = tmp / 10;

			if (result >  2147483647)
				return 0;
		}

		int ret = (int)result;
		return flag ? (-ret) : ret;
	}

	void test() {
		int ret = reverse(-123445);
		ret = reverse(1534236469);
		ret = reverse(0);
	}
};