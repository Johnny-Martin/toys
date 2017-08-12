// Test.cpp : �������̨Ӧ�ó������ڵ㡣
//

#include "stdafx.h"
#include "Test.h"
#include <map>
#include<cctype>
#include<iostream>
#include <sstream>
#include<map>
#include<stack>
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

#define SSEXP "[0-9\\+\\-\\*\\(\\)/\\\s*]*"
#define SSCMD "((#mid)*(#height)*(#width)*)*"

//��֧��+-/*()���ֲ�����,sExp�г�������֮��������ֲ������������������ַ�
//��֧�ָ���(������0-��������)����֧��С��(�����÷�����ʾ)��
double TestCalcExp(const string& sExp)
{
	if (sExp.empty()) return 0.0;
	stack<double> outputStack;
	stack<char> operatorStack;
	
	auto IsNumber = [](const char& test) { return test >= '0' && test <= '9'; };

	auto PushToOutputStack = [&IsNumber, &outputStack](const string& originalExp, string::size_type begin) {
		string::size_type end = begin;
		while (end < originalExp.size() && IsNumber(originalExp[end])) { ++end; };
		--end;
		string strOperand = originalExp.substr(begin, end - begin + 1);
		_ASSERT(!strOperand.empty());
		int iOperand = atoi(strOperand.c_str());
		outputStack.push(iOperand);
		//���ص�ǰ��������ĩβ�ڴ��е�λ��
		return end;
	};
	
	auto CalcOutputStack = [&outputStack](const char& op) {
		if (outputStack.size() < 2) {
			//ERR("CalcOutputStack error: outputStack size: error.");
			return false;
		}
		int rightOp = outputStack.top();
		outputStack.pop();
		int leftOp = outputStack.top();
		outputStack.pop();
		switch (op){
			case '+':
				outputStack.push(leftOp + rightOp);
				break;
			case '-':
				outputStack.push(leftOp - rightOp);
				break;
			case '*':
				outputStack.push(leftOp * rightOp);
				break;
			case '/':
				//��0�쳣����㲶��
				outputStack.push(leftOp / rightOp);
				break;
		//default:
			//ERR("CalcOutputStack error: unsupported operator: {}", op);
			//return false;
		}
		return true;
	};

	for (string::size_type i = 0; i < sExp.size(); ++i) {
		//�����������ˣ�ѹ�������ջ
		if (IsNumber(sExp[i])) {
			i = PushToOutputStack(sExp, i);
			continue;
		}
		char curOperator = sExp[i];
		//�����*/�ţ�ֻҪ��һ���ַ������֣��Ϳ��Լ����Լ���������ջ
		if (curOperator == '*' || curOperator == '/') {
			if (IsNumber(sExp[i + 1])) {
				//����һ���������ҳ�����ջ��Ȼ�����
				i = PushToOutputStack(sExp, i + 1);
				CalcOutputStack(curOperator);
				continue;
			}
			operatorStack.push(curOperator);
		}else if (curOperator == '+' || curOperator == '-') {
			//�����+-�ţ�ֻҪջ�����ա�����'(', ���ȼ���ջ�����ţ��ٽ��Լ���ջ
			if (operatorStack.empty() || operatorStack.top() == '(') {
				operatorStack.push(curOperator);
				continue;
			}
			CalcOutputStack(operatorStack.top());
			operatorStack.pop();
			operatorStack.push(curOperator);
		}else if (curOperator == '(') {
			//������,ֱ����ջ
			operatorStack.push(sExp[i]);
		}else if (curOperator == ')') {
			//�ߴ���߼��㣬�����ջ�е�()֮��һ��ֻ��һ��������
			CalcOutputStack(operatorStack.top());
			operatorStack.pop();
			_ASSERT(operatorStack.top() == '(');
			operatorStack.pop();
		}
	}
	if (!operatorStack.empty()) {
		cout << "operatorStack size: " << operatorStack.size() << endl;
		CalcOutputStack(operatorStack.top());
		operatorStack.pop();
	}
	return outputStack.top();
}
int main()
{
	auto retDouble1 = TestCalcExp("19-4*2");
	auto retDouble2 = TestCalcExp("19-4*2+21");
	auto retDouble3 = TestCalcExp("(19-4)*2+21");
	auto retDouble4 = TestCalcExp("100");
	auto retDouble5 = TestCalcExp("");

	auto eraseSpace = [](string& str) {
		for (string::iterator it = str.end(); it != str.begin();) {
			--it;
			if ((*it) == ' ' || (*it) == '\t') {
				str.erase(it);
			}
		}
	};

	auto I2Str = [](auto param)->string {
		stringstream strStream;
		string ret;
		strStream << param;
		strStream >> ret;
		return ret;
	};

	string strParentWidth = I2Str(unsigned int(155));
	string strParentHeight = I2Str(unsigned int(693355));

	//ȥ��·�������������˵Ŀհ׷�
	auto EraseEndsSpace = [](string& str) {
		//ȥ��ͷ���հ׷�
		for (string::iterator it = str.begin(); it != str.end(); ) {
			if ((*it) == ' ' || (*it) == '\t' || (*it) == '\n' || (*it) == '\r') {
				str.erase(it);
				it = str.begin();
				continue;
			}
			break;
		}
		//ȥ��β���հ׷�
		for (string::iterator it = str.end(); it != str.begin();) {
			--it;
			if ((*it) == ' ' || (*it) == '\t' || (*it) == '\n' || (*it) == '\r') {
				str.erase(it);
				it = str.end();
				continue;
			}
			break;
		}
	};
	regex midPattern("#mid");
	string width  = "#width/2";
	string height = "#height/2";
	string midExp = "((#width) - (" + width + "))/2";

	auto  strRet = regex_replace("5-#mid+#mid2", midPattern, "qq");

	regex funcPattern("([^=>]*)(=>)?([^=>\.]*)");
	auto funcRet1 = regex_match(".\\���� File\\test.lua=>OnWindowCreate", funcPattern);
	string file   = regex_replace(".\\Program File\\test.lua=>OnWindowCreate", funcPattern, string("$1"));
	string fname  = regex_replace(".\\Program File\\test.lua=>OnWindowCreate", funcPattern, string("$3"));

	auto funcRet2 = regex_match(" .\\Program File\\test.lua =>	OnWindowCreate", funcPattern);
	file		  = regex_replace("  .\\Program File\\test.lua  =>	OnWindowCreate", funcPattern, string("$1"));
	fname		  = regex_replace("  .\\Program File\\test.lua  =>	OnWindowCreate		", funcPattern, string("$3"));
	EraseEndsSpace(file);
	EraseEndsSpace(fname);

	auto funcRet3 = regex_match("OnWindowCreate", funcPattern);
	file = regex_replace("OnWindowCreate", funcPattern, string("$1"));
	fname = regex_replace("OnWindowCreate", funcPattern, string("$3"));

	file = regex_replace(".\\Program File\\test.lua", funcPattern, string("$1"));
	fname = regex_replace(".\\Program File\\test.lua", funcPattern, string("$3"));

	auto funcRet4 = regex_match("InputBox.bkg", funcPattern);
	auto funcRet5 = regex_match("", funcPattern);

	regex boolPattern("[01]");
	auto boolRet1 = regex_match("0", boolPattern);
	auto boolRet2 = regex_match("1", boolPattern);
	auto boolRet3 = regex_match(" ", boolPattern);
	auto boolRet4 = regex_match("", boolPattern);
	auto boolRet5 = regex_match("01", boolPattern);
	auto boolRet6 = regex_match("5", boolPattern);

	regex intPattern("[0-9]+");
	auto intRet1 = regex_match("0", intPattern);
	auto intRet2 = regex_match("6", intPattern);
	auto intRet3 = regex_match("255", intPattern);
	auto intRet4 = regex_match("0.9", intPattern);
	auto intRet5 = regex_match("", intPattern);
	auto intRet6 = regex_match(" ", intPattern);


	string sPattern = "(([0-9heigtwdm\\+\\-\\*/#\\\s*]*),([0-9heigtwdm\\+\\-\\*/#\\\s*]*),([0-9heigtwdm\\+\\-\\*/#\\\s*]*),([0-9heigtwdm\\+\\-\\*/#\\\s*]*))*";
	regex pattern(sPattern.c_str());
	string pos = "	, #height / 2 - 50, 200,	100		";
	
	//pos = "";
	//eraseSpace(pos);
	if (regex_match(pos, pattern)) {
		cout << "match success" << endl;
		string left	  = regex_replace(pos, pattern, string("$2"));
		string top	  = regex_replace(pos, pattern, string("$3"));
		string width  = regex_replace(pos, pattern, string("$4"));
		string height = regex_replace(pos, pattern, string("$5"));

		cout << "left: " << left<< " top: " << top << " width: " << width << " height: " << height << endl;

	}else {
		cout << "match failed" << endl;
	}

	auto posRet1 = regex_match(",,,", pattern);
	auto posRet2 = regex_match(",2,3,#mid", pattern);
	auto posRet3 = regex_match("1,,3,#mid", pattern);
	auto posRet4 = regex_match("2,3,#mid", pattern);
	auto posRet5 = regex_match("#height/2-50,,,", pattern);
	auto posRet6 = regex_match("#height/2-50,#height/2-50,#height/2-50,#height/2-50", pattern);
	auto posRet7 = regex_match("1,,3,#mkd", pattern);
	auto posRet8 = regex_match("1,,3,#mId", pattern);
	auto posRet9 = regex_match(",,", pattern);
	auto posRet10 = regex_match("", pattern);

	regex pattern2("([0-9heigtwd\\+\\-\\*\\(\\)/#]+).([0-9heigtwd\\+\\-\\*/#]+)");
	string str = "(#height-100)/2.width";
	if (regex_match(str, pattern2)) {
		cout << "match success" << endl;
	}


	string sExp = "[0-9\\+\\-\\*\\(\\)/\\\s*]*";
	string sCmd = "((#mid)*(#height)*(#width)*)*";
	//regex patternAll("(" + sExp + sCmd + sExp + ")*");
	regex patternAll("(" SSEXP SSCMD SSEXP ")*");
	regex pattern3("([0-9\\+\\-\\*\\(\\)/]*((#mid)*(#height)*(#width)*)*)"); //(".*#hello.*");//
	string str3 = "10+#heigh";// (#height - 100) / 2.width";

	auto ret1 = regex_match(" #mid", patternAll);
	auto ret2 = regex_match("#height ", patternAll);
	auto ret3 = regex_match(" #width ", patternAll);
	auto ret4 = regex_match("#width+1", patternAll);
	auto ret5 = regex_match("2-#mid", patternAll);
	auto ret6 = regex_match("10+#height-9", patternAll);
	auto ret7 = regex_match("(#height-#width) / 2", patternAll);
	auto ret8 = regex_match("(#height-#width) / 2 -#mid", patternAll);
	auto ret9 = regex_match("10+ #heght-9", patternAll);
	auto ret10 = regex_match("#mqd", patternAll);
	auto ret11 = regex_match("(#height-#widwth)/2-#mid", patternAll);
	auto ret12 = regex_match("5+(#height-#width)/2-#mid", patternAll);

	if (regex_match(str3, pattern3)) {
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
