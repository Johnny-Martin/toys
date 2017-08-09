// Test.cpp : �������̨Ӧ�ó������ڵ㡣
//

#include "stdafx.h"
#include "Test.h"
#include <map>
#include<cctype>
#include<iostream>
#include<map>
#include<string>
#include <regex> 

using namespace std;
enum Token_value {
	NAME, NUMBER, END, PLUS = '+', MINUS = '-', MUL = '*', DIV = '/', PRINT = ';', ASSIGN = '=', LP = '(', RP = ')'
};
Token_value curr_tok = PRINT;
map<string, double> table;
double number_value;
string string_value;
int no_of_errors;
double expr(bool get);
double term(bool get);
double prim(bool get);
Token_value get_token();
double error(const string& s)
{
	no_of_errors++;
	cerr << "error:" << s << endl;
	return 1;
}
Token_value get_token()
{
	char ch = 0;
	cin >> ch;
	switch (ch) {
	case 0:
		return curr_tok = END;
	case ';':case '*':case '/':case '+':case '-':case '(':case ')':case '=':
		return curr_tok = Token_value(ch);
	case '0':case '1':case '2':case '3':case '4':case '5':case '6':case '7':case '8':case '9':case '.':
		cin.putback(ch);
		cin >> number_value;
		return curr_tok = NUMBER;
	default:
		if (isalpha(ch)) {
			cin.putback(ch);
			cin >> string_value;
			return curr_tok = NAME;
		}
		error("bad token");
		return curr_tok = PRINT;
	}
}
double prim(bool get)
{
	if (get) get_token();
	switch (curr_tok) {
	case NUMBER:
	{   double v = number_value;
	get_token();
	return v;
	}
	case NAME:
	{   double& v = table[string_value];
	if (get_token() == ASSIGN) v = expr(true);
	return v;
	}
	case MINUS:
		return -prim(true);
	case LP:
	{   double e = expr(true);
	if (curr_tok != RP) return error(") expected");
	get_token();
	return e;
	}
	default:
		return error("primary expected");
	}
}
double term(bool get)
{
	double left = prim(get);
	for (;;)
		switch (curr_tok) {
		case MUL:
			left *= prim(true);
			break;
		case DIV:
			if (double d = prim(true)) {
				left /= d;
				break;
			}
			return error("divide by 0");
		default:
			return left;
		}
}
double expr(bool get)
{
	double left = term(get);
	for (;;)
		switch (curr_tok) {
		case PLUS:
			left += term(true);
			break;
		case MINUS:
			left -= term(true);
			break;
		default:
			return left;
		}
}
/*
int main()
{
	table["pi"] = 3.1415926535897932385;
	table["e"] = 2.718284590452354;
	while (cin) {
		get_token();
		if (curr_tok == END) break;
		if (curr_tok == PRINT) continue;
		cout << expr(false) << endl;
	}
	return no_of_errors;
}

*/

int main()
{
	auto eraseSpace = [](string& str) {
		for (string::iterator it = str.end(); it != str.begin();) {
			--it;
			if (iswspace(*it)) {
				str.erase(it);
			}
		}
	};
	regex pattern("([0-9heigtwdm\\+\\-\\*/#]+),([0-9heigtwdm\\+\\-\\*/#]+),([0-9heigtwdm\\+\\-\\*/#]+),([0-9heigtwdm\\+\\-\\*/#]+)");
	string pos = "#mid, #height/2 - 50, 200, 100";
	
	eraseSpace(pos);
	if (regex_match(pos, pattern)) {
		cout << "match success" << endl;
		string left	  = regex_replace(pos, pattern, string("$1"));
		string top	  = regex_replace(pos, pattern, string("$2"));
		string width  = regex_replace(pos, pattern, string("$3"));
		string height = regex_replace(pos, pattern, string("$4"));

		cout << "left: " << left<< " top: " << top << " width: " << width << " height: " << height << endl;

	}else {
		cout << "match failed" << endl;
	}

	regex pattern2("([0-9heigtwd\\+\\-\\*/#]+).([0-9heigtwd\\+\\-\\*/#]+)");
	string str = "height+-*/#.width";
	if (regex_match(str, pattern2)) {
		cout << "match success" << endl;
	}
	UIBase base;
	const string name  = base.GetObjectID_1();
	cout << name << endl;					     //������������Ч�ʵ͡�m_attrMap["id"]=>name����һ�ο������죬return name->name��һ��
	
	const string& rname = base.GetObjectID_2();  //������������Ч�ʵ�
	//const string* pName = base.GetObjectID_3();//GetObjeID���ص��Ǿֲ������ĵ�ַ
	//cout << *pName << endl;				     //�˴��ڴ�����쳣����ΪpNameָ����ַ����Ѿ���������

	//const string* pName2 = base.GetObjectID_4(); //GetObjeID2���صĲ����Ǿֲ������ĵ�ַ������map�ĳ�Ա�ĵ�ַ
	//cout << *pName2 << endl;				     //����
	//delete pName2;						         //��������������ˣ�������map�ĳ�Ա��

	auto spName = base.GetObjectID_7();
	if(!spName->empty())
		cout << *spName << endl;
	//(*spName)[0] = '4';
	cout << *spName << endl;

	int a = 10;
	map<string, string> testMap;
	testMap.insert(pair<string, string>("A", "AAA"));

	string pA = testMap["A"];
	pA = testMap["B"];

	if (testMap.end() != testMap.find("B"))
		cout << "what the fuck";
    return 0;
}
