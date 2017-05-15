#pragma once
#include "..\stdafx.h"

//Definition for singly-linked list.
struct ListNode {
    int val;
    ListNode *next;
	ListNode(int x) : val(x), next(NULL) {}
	ListNode(int x, ListNode* pNode) : val(x), next(pNode) {}
};

class AddTwoNumsSolution {
public:
	ListNode* addTwoNumbers(ListNode* listA, ListNode* listB) {
		int carry = 0;
		ListNode* first = listA;
		ListNode* second = listB;
		while (true) {
			int sum = (first ? first->val : 0) + (second ? second->val : 0) + carry;
			carry       = sum / 10;
			
			if (first)
				first->val  = sum % 10;

			if(second)
				second->val = sum % 10;

			if ((first ? first->next : NULL) == NULL && (second ? second->next : NULL) == NULL) {
				ListNode* tmpPoint = first ? first : second;
				tmpPoint->next = (carry > 0) ? (new ListNode(carry)) : NULL;
				return first?listA:listB;
			}
			first  = first ? first->next : NULL;
			second = second ? second->next : NULL;
		}
	}

	void test() {
		ListNode* nodeA = new ListNode(5, new ListNode(6, new ListNode(7)));
		ListNode* nodeB = new ListNode(8, new ListNode(9, new ListNode(9)));

		addTwoNumbers(nodeA, nodeB);
	}
};