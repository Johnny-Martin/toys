#pragma once

class CallType {
public:
	int DefaultCall(int a, int b) {
		this->data = a + b;
		this->data2 = a - b;
		return this->data;
	}

	int DefaultCall_Get() {
		return this->data;
	}
	int _cdecl CdeclCall(int a, int b) {
		this->data = a + b;
		return this->data;
	}
	int _stdcall StdCall(int a, int b) {
		this->data = a + b;
		return this->data;
	}
	int _fastcall FastCall(int a, int b) {
		this->data = a + b;
		return this->data;
	}
	int __thiscall ThisCall(int a, int b) {
		this->data = a + b;
		return this->data;
	}
private:
	int data;
	int data2;
};
