#pragma once

int DefaultCall(int a, int b) {
	return a + b;
}
int _cdecl CdeclCall(int a, int b) {
	return a + b;
}
int _stdcall StdCall(int a, int b) {
	return a + b;
}
int _fastcall FastCall(int a, int b) {
	return a + b;
}