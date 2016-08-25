#pragma once
#ifndef TRAIT_H
#define TRAIT_H

template<typename T>
class AccTrait;

template <>
class AccTrait<char> {
public:
	typedef int AccValueType;
	static AccValueType zero() {
		return 0;
	}
};

template <>
class AccTrait<short> {
public:
	typedef int AccValueType;
	static AccValueType zero() {
		return 0;
	}
};

template <>
class AccTrait<int> {
public:
	typedef long AccValueType;
	static AccValueType zero() {
		return 0;
	}
};

template <>
class AccTrait<unsigned int> {
public:
	typedef unsigned long AccValueType;
	static AccValueType zero() {
		return 0;
	}
};

template <>
class AccTrait<float> {
public:
	typedef double AccValueType;
	static AccValueType zero() {
		return 0;
	}
};

template<typename T>
inline
typename AccTrait<T>::AccValueType
accum(T const* beg, T const* end){
	typedef typename AccTrait<T>::AccValueType AccValueType;
	AccValueType total = AccTrait<T>::zero();

	while (beg != end) {
		total += *beg;
		++beg;
	}

	return total;
}

template<typename T, typename AT = AccTrait<T>>
class Accum {
public:
	static typename AT::AccValueType accum(T const* beg, T const* end) {
		typedef typename AT::AccValueType AccValueType;
		AccValueType total = AT::zero();

		while (beg != end) {
			total += *beg;
			++beg;
		}

		return total;
	}
};
#endif