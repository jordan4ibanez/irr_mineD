module include.irr_math;

public import std.algorithm.comparison : clamp;
import include.irr_types;
import std.algorithm.comparison;
import std.math.algebraic;
import std.math.constants;
import std.math.rounding;

// Copyright (C) 2002-2012 Nikolaus Gebhardt
// This file is part of the "Irrlicht Engine".
// For conditions of distribution and use, see copyright notice in irrlicht.h

// #pragma once

// #include "irrTypes.h"
// #include <cmath>
// #include <cfloat>
// #include <cstdlib> // for abs() etc.
// #include <climits> // For INT_MAX / UINT_MAX
// #include <type_traits>

// namespace irr
// {
// namespace core
// {

//! Rounding error constant often used when comparing f32 values.

static immutable f32 ROUNDING_ERROR_f32 = 0.000001f;
static immutable f64 ROUNDING_ERROR_f64 = 0.00000001;

// #ifdef PI // make sure we don't collide with a define
// #undef PI
// #endif

//! Constant for PI.
// static immutable f32 PI = PI;

// #ifdef PI64 // make sure we don't collide with a define
// #undef PI64
// #endif
//! Constant for 64bit PI.
static immutable f64 PI64 = PI;

//! 32bit Constant for converting from degrees to radians
static immutable f32 DEGTORAD = PI / 180.0f;

//! 32bit constant for converting from radians to degrees (formally known as GRAD_PI)
static immutable f32 RADTODEG = 180.0f / PI;

//! 64bit constant for converting from degrees to radians (formally known as GRAD_PI2)
static immutable f64 DEGTORAD64 = PI64 / 180.0;

//! 64bit constant for converting from radians to degrees
static immutable f64 RADTODEG64 = 180.0 / PI64;

//! Utility function to convert a radian value to degrees
/** Provided as it can be clearer to write radToDeg(X) than RADTODEG * X
\param radians The radians value to convert to degrees.
*/
pragma(inline, true) f32 radToDeg(f32 radians) {
    return RADTODEG * radians;
}

//! Utility function to convert a radian value to degrees
/** Provided as it can be clearer to write radToDeg(X) than RADTODEG * X
\param radians The radians value to convert to degrees.
*/
pragma(inline, true) f64 radToDeg(f64 radians) {
    return RADTODEG64 * radians;
}

//! Utility function to convert a degrees value to radians
/** Provided as it can be clearer to write degToRad(X) than DEGTORAD * X
\param degrees The degrees value to convert to radians.
*/
pragma(inline, true) f32 degToRad(f32 degrees) {
    return DEGTORAD * degrees;
}

//! Utility function to convert a degrees value to radians
/** Provided as it can be clearer to write degToRad(X) than DEGTORAD * X
\param degrees The degrees value to convert to radians.
*/
pragma(inline, true) f64 degToRad(f64 degrees) {
    return DEGTORAD64 * degrees;
}

//! returns minimum of two values.
alias min_ = min;

//! returns maximum of any values.
alias max_ = max;

//! returns abs of two values.
alias abs_ = abs;

//! returns linear interpolation of a and b with ratio t
//! \return: a if t==0, b if t==1, and the linear interpolation else
// template <class T>
pragma(inline, true) T lerp(T)(const ref T a, const ref T b, const f32 t) {
    return (T)(a * (1.f - t)) + (b * t);
}

// template <class T>
//  T roundingError();

// template <>
pragma(inline, true) f32 roundingError(T = f32)() {
    return ROUNDING_ERROR_f32;
}

// template <>
pragma(inline, true) f64 roundingError(T = f64)() {
    return ROUNDING_ERROR_f64;
}

// template <class T>
pragma(inline, true) T relativeErrorFactor(T)() {
    return 1;
}

// template <>
pragma(inline, true) f32 relativeErrorFactor(T = f32)() {
    return 4;
}

// template <>
pragma(inline, true) f64 relativeErrorFactor(T = f64)() {
    return 8;
}

//! returns if a equals b, for types without rounding errors
// template <class T, std::enable_if_t<std::is_integral<T>::value, bool> = true>
pragma(inline, true) bool equals(T)(const T a, const T b) {
    return a == b;
}

//! returns if a equals b, taking possible rounding errors into account
// template <class T, std::enable_if_t<std::is_floating_point<T>::value, bool> = true>
pragma(inline, true) bool equals(T)(const T a, const T b, const T tolerance = roundingError()) {
    return abs(a - b) <= tolerance;
}

//! returns if a equals b, taking relative error in form of factor
//! this particular function does not involve any division.
// template <class T>
pragma(inline, true) bool equalsRelative(T)(const T a, const T b, const T factor = relativeErrorFactor()) {
    // https://eagergames.wordpress.com/2017/04/01/fast-parallel-lines-and-vectors-test/

    const T maxi = max_(a, b);
    const T mini = min_(a, b);
    const T maxMagnitude = max_(maxi, -mini);

    return (maxMagnitude * factor + maxi) == (maxMagnitude * factor + mini); // MAD Wise
}

union FloatIntUnion32 {
    this(float f1) {
        f = f1;
    }

    // Portable sign-extraction
    bool sign() const {
        return (i >> 31) != 0;
    }

    s32 i;
    f32 f;
}

//! We compare the difference in ULP's (spacing between floating-point numbers, aka ULP=1 means there exists no float between).
//\result true when numbers have a ULP <= maxUlpDiff AND have the same sign.
pragma(inline, true) bool equalsByUlp(f32 a, f32 b, int maxUlpDiff) {
    // Based on the ideas and code from Bruce Dawson on
    // http://www.altdevblogaday.com/2012/02/22/comparing-floating-point-numbers-2012-edition/
    // When floats are interpreted as integers the two nearest possible float numbers differ just
    // by one integer number. Also works the other way round, an integer of 1 interpreted as float
    // is for example the smallest possible float number.

    const FloatIntUnion32 fa = a;
    const FloatIntUnion32 fb = b;

    // Different signs, we could maybe get difference to 0, but so close to 0 using epsilons is better.
    if (fa.sign() != fb.sign()) {
        // Check for equality to make sure +0==-0
        if (fa.i == fb.i)
            return true;
        return false;
    }

    // Find the difference in ULPs.
    const int ulpsDiff = abs_(fa.i - fb.i);
    if (ulpsDiff <= maxUlpDiff)
        return true;

    return false;
}

//! returns if a equals zero, taking rounding errors into account
pragma(inline, true) bool iszero(const f64 a, const f64 tolerance = ROUNDING_ERROR_f64) {
    return fabs(a) <= tolerance;
}

//! returns if a equals zero, taking rounding errors into account
pragma(inline, true) bool iszero(const f32 a, const f32 tolerance = ROUNDING_ERROR_f32) {
    return fabs(a) <= tolerance;
}

//! returns if a equals not zero, taking rounding errors into account
pragma(inline, true) bool isnotzero(const f32 a, const f32 tolerance = ROUNDING_ERROR_f32) {
    return fabs(a) > tolerance;
}

//! returns if a equals zero, taking rounding errors into account
pragma(inline, true) bool iszero(const s32 a, const s32 tolerance = 0) {
    return (a & 0x7ffffff) <= tolerance;
}

//! returns if a equals zero, taking rounding errors into account
pragma(inline, true) bool iszero(const u32 a, const u32 tolerance = 0) {
    return a <= tolerance;
}

//! returns if a equals zero, taking rounding errors into account
pragma(inline, true) bool iszero(const s64 a, const s64 tolerance = 0) {
    return abs_(a) <= tolerance;
}

pragma(inline, true) s32 s32_min(s32 a, s32 b) {
    return min_(a, b);
}

pragma(inline, true) s32 s32_max(s32 a, s32 b) {
    return max_(a, b);
}

pragma(inline, true) s32 s32_clamp(s32 value, s32 low, s32 high) {
    return clamp(value, low, high);
}

// integer log2 of an integer. returning 0 if denormal
pragma(inline, true) s32 u32_log2(u32 input) {
    s32 ret = 0;
    while (input > 1) {
        input >>= 1;
        ret++;
    }
    return ret;
}

/*
	float IEEE-754 bit representation

	0      0x00000000
	1.0    0x3f800000
	0.5    0x3f000000
	3      0x40400000
	+inf   0x7f800000
	-inf   0xff800000
	+NaN   0x7fc00000 or 0x7ff00000
	in general: number = (sign ? -1:1) * 2^(exponent) * 1.(mantissa bits)
*/

union inttofloat {
    u32 u;
    s32 s;
    f32 f;
}

pragma(inline, true) s32 F32_AS_S32(f32 f) {
    return (*(cast(s32*)&(f)));
}

pragma(inline, true) u32 F32_AS_U32(f32 f) {
    return (*(cast(u32*)&(f)));
}

u32* F32_AS_U32_POINTER(ref f32 f) {
    return (cast(u32*)&(f));
}

static immutable F32_VALUE_0 = 0x00000000;
static immutable F32_VALUE_1 = 0x3f800000;

//! code is taken from IceFPU
//! Integer representation of a floating-point value.
pragma(inline, true) u32 IR(f32 x) {
    inttofloat tmp;
    tmp.f = x;
    return tmp.u;
}

//! Floating-point representation of an integer value.
pragma(inline, true) f32 FR(u32 x) {
    inttofloat tmp;
    tmp.u = x;
    return tmp.f;
}

pragma(inline, true) f32 FR(s32 x) {
    inttofloat tmp;
    tmp.s = x;
    return tmp.f;
}

pragma(inline, true) bool F32_LOWER_0(f32 n) {
    return ((n) < 0.0f);
}

pragma(inline, true) bool F32_LOWER_EQUAL_0(f32 n) {
    return ((n) <= 0.0f);
}

pragma(inline, true) bool F32_GREATER_0(f32 n) {
    return ((n) > 0.0f);
}

pragma(inline, true) bool F32_GREATER_EQUAL_0(f32 n) {
    return ((n) >= 0.0f);
}

pragma(inline, true) bool F32_EQUAL_1(f32 n) {
    return ((n) == 1.0f);
}

pragma(inline, true) bool F32_EQUAL_0(f32 n) {
    return ((n) == 0.0f);
}

pragma(inline, true) bool F32_A_GREATER_B(f32 a, f32 b) {
    return ((a) > (b));
}

// #ifndef REALINLINE
// #ifdef _MSC_VER
// #define REALINLINE __forceinline
// #else
// #define REALINLINE inline
// #endif
// #endif

// NOTE: This is not as exact as the c99/c++11 round function, especially at high numbers starting with 8388609
//       (only low number which seems to go wrong is 0.49999997 which is rounded to 1)
//      Also negative 0.5 is rounded up not down unlike with the standard function (p.E. input -0.5 will be 0 and not -1)
pragma(inline, true) f32 round_(f32 x) {
    return floor(x + 0.5f);
}

// calculate: sqrt ( x )
pragma(inline, true) f32 squareroot(const f32 f) {
    return sqrt(f);
}

// calculate: sqrt ( x )
pragma(inline, true) f64 squareroot(const f64 f) {
    return sqrt(f);
}

// calculate: sqrt ( x )
pragma(inline, true) s32 squareroot(const s32 f) {
    return cast(s32)(squareroot(cast(f32)(f)));
}

// calculate: sqrt ( x )
pragma(inline, true) s64 squareroot(const s64 f) {
    return cast(s64)(squareroot(cast(f64)(f)));
}

// calculate: 1 / sqrt ( x )
pragma(inline, true) f64 reciprocal_squareroot(const f64 x) {
    return 1.0 / sqrt(x);
}

// calculate: 1 / sqrtf ( x )
pragma(inline, true) f32 reciprocal_squareroot(const f32 f) {
    return 1.0f / sqrt(f);
}

// calculate: 1 / sqrtf( x )
pragma(inline, true) s32 reciprocal_squareroot(const s32 x) {
    return cast(s32)(reciprocal_squareroot(cast(f32)(x)));
}

// calculate: 1 / x
pragma(inline, true) f32 reciprocal(const f32 f) {
    return 1.0f / f;
}

// calculate: 1 / x
pragma(inline, true) f64 reciprocal(const f64 f) {
    return 1.0 / f;
}

// calculate: 1 / x, low precision allowed
pragma(inline, true) f32 reciprocal_approxim(const f32 f) {
    return 1.0f / f;
}

pragma(inline, true) s32 floor32(f32 x) {
    return cast(s32) floor(x);
}

pragma(inline, true) s32 ceil32(f32 x) {
    return cast(s32) ceil(x);
}

// NOTE: Please check round_ documentation about some inaccuracies in this compared to standard library round function.
pragma(inline, true) s32 round32(f32 x) {
    return cast(s32) round_(x);
}

pragma(inline, true) f32 f32_max3(const f32 a, const f32 b, const f32 c) {
    return a > b ? (a > c ? a : c) : (b > c ? b : c);
}

pragma(inline, true) f32 f32_min3(const f32 a, const f32 b, const f32 c) {
    return a < b ? (a < c ? a : c) : (b < c ? b : c);
}

pragma(inline, true) f32 fract(f32 x) {
    return x - floor(x);
}

// } // end namespace core
// } // end namespace irr

// using irr::core::FR;
// using irr::core::IR;
