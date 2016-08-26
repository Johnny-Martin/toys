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

template<typename T>
class IsClassType {
private:
	typedef char one;
	typedef struct { char a[2]; } two;

	template<typename C>static one test(int C::*);
	template<typename C>static two test(...);

public:
	enum{YES = 1 == sizeof(test<T>(0))};
	enum{NO = !YES};
};

/////////////////////////promotion trait////////////////////
template<bool B, typename T1, typename T2>
class IfThenElse;

template<typename T1, typename T2>
class IfThenElse<true, T1, T2> {
public:
	typedef T1 ResultType;

};

template<typename T1, typename T2>
class IfThenElse<false, T1, T2> {
public:
	typedef T2 ResultType;

};

template<typename T1, typename T2>
class Promotion {
public:
	typedef typename
		IfThenElse<(sizeof(T1)>sizeof(T2)), 
		           T1,
		           typename IfThenElse<(sizeof(T1)<sizeof(T2)),
									   T2, 
									   void>::ResultType
				   >::ResultType ResultType;
};

template<typename T>
class Promotion<T, T> {
public:
	typedef T ResultType;
};

#define MK_PROMOTION(T1, T2, Tr)        \
	template<> class Promotion<T1, T2> {\
	    public:                         \
		typedef Tr ResultType;          \
	};                                  \
										\
	template<> class Promotion<T2, T1> {\
		public:                         \
		typedef Tr ResultType;          \
	};                                  


#endif