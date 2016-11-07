#pragma once
#include <sstream>
#include <iostream>

class AtomicWrite : public std::ostream
{
public:
	AtomicWrite();
	~AtomicWrite();
private:
	std::ostringstream _os;
};

AtomicWrite::AtomicWrite()
	: std::ostream(0)
	, _os()
{
	this->init(_os.rdbuf());
}

AtomicWrite::~AtomicWrite()
{
	std::cout << _os.str();
}

#define AtomCoutEx AtomicWrite()