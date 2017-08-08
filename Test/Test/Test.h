#pragma once
#include "stdafx.h"


using namespace std;

#define ADD_ATTR(attrName, defaultValue)	\
		m_attrMap.insert(pair<string, string>(attrName, defaultValue));

class UIBase
{
public:
	UIBase() {
			ADD_ATTR("id", "")
			ADD_ATTR("name", "123")
			ADD_ATTR("pos", "")
	}

	const string GetObjectID_1() {
		if (m_attrMap.empty()) {
			return ""; //����ֱ�ӷ���nullptr,������쳣
		}
		string name = m_attrMap["id"];
		if (name.empty())
			name = m_attrMap["name"];

		return name;
	}

	const string& GetObjectID_2() {
		if (m_attrMap.empty()) {
			return ""; //����ֱ�ӷ���nullptr,������쳣
		}
		string name = m_attrMap["id"];
		if (name.empty())
			name = m_attrMap["name"];

		return name;
	}
	
	const string* GetObjectID_3() {
		if (m_attrMap.empty()) {
			return nullptr; //����ֱ�ӷ���nullptr
		}
		string name = m_attrMap["id"];
		if (name.empty())
			name = m_attrMap["name"];

		return &name; //�ܿ�
	}

	const string* GetObjectID_4() {
		if (m_attrMap.empty()) {
			return nullptr; //����ֱ�ӷ���nullptr
		}
		string name = m_attrMap["id"];
		if (name.empty())
			return &m_attrMap["name"];

		return &m_attrMap["id"];//ͬ���ܿ�
	}

	shared_ptr<string> GetObjectID_5() {
		if (m_attrMap.empty()) {
			return make_shared<string>(nullptr); //����ֱ�ӷ���nullptr
		}
		string name = m_attrMap["id"];
		if (name.empty())
			return make_shared<string>(m_attrMap["name"]);

		return make_shared<string>(m_attrMap["id"]);
	}
	const shared_ptr<string> GetObjectID_6() {
		if (m_attrMap.empty()) {
			return make_shared<string>(nullptr); //����ֱ�ӷ���nullptr
		}
		string name = m_attrMap["id"];
		if (name.empty())
			return make_shared<string>(m_attrMap["name"]);

		return make_shared<string>(m_attrMap["id"]);
	}
	
	shared_ptr<const string> GetObjectID_7() {
		if (m_attrMap.empty()) {
			return nullptr; //����ֱ�ӷ���nullptr
		}

		string name = m_attrMap["id"];
		if (name.empty())
			return make_shared<const string>(m_attrMap["name"]);

		return make_shared<const string>(m_attrMap["id"]);
	}

protected:
	map<string, string>						m_attrMap;
};