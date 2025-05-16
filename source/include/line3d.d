module include.line3d;

import include.irr_types;
import include.vector3d;

// Copyright (C) 2002-2012 Nikolaus Gebhardt
// This file is part of the "Irrlicht Engine".
// For conditions of distribution and use, see copyright notice in irrlicht.h

// #pragma once

// #include "irrTypes.h"
// #include "vector3d.h"

// namespace irr
// {
// namespace core
// {

//! 3D line between two points with intersection methods.
// template <class T>
class line3d(T)
{
    // Basic any typecheck.
    static assert(isNumeric!T);

	//! Start point of line
	vector3d!T start = vector3d!T(0,0,0);
	//! End point of line
	vector3d!T end = vector3d!T(1,1,1);

	

	//! Constructor with two points
	this(T xa, T ya, T za, T xb, T yb, T zb) {
			start = vector3d!(xa, ya, za); end = vector3d! (xb, yb, zb) ;
            }
	//! Constructor with two points as vectors
	this(const ref vector3d!T start, const ref vector3d!T end) {
			start = start; end = end;
            }

	// operators

    // Negate.
    line3d!T opUnary(string s : "-")() const {
        return line3d!T(-Start, - End);
    }

        // Assignment.
    void opAssign(U)(U value) {
        // This is (half) compiler code. 
        // Give line3d even more assignments than C++.
        static if (__traits(isSame, U, line3d)) {
            this.start = value.start;
            this.end = value.end;
        } else static if (isInstanceOf!(vector3d, U)) {
            this.start = value;
            this.end = value;
        } else static if (isArray!U) {
            static assert(isNumeric!(typeof(value[0])));
            assert(value.length == 3, "Cannot add array. Length is not 3.");
            this.start = value;
            this.end = value;
        } else {
            static assert(isNumeric!(typeof(value)));
            this.start = value;
            this.end = value;
        }
    }

        // Operator assignment.
    ref line3d!T opOpAssign(string op, U)(const U value) {
        // This is compiler code. 
        // Give line3d even more assignment operator operators than C++.
        static if (__traits(isSame, U, line3d)) {
            mixin("start " ~ op ~ "= value.start;");
            mixin("end " ~ op ~ "= value.end;");
            } else static if (isInstanceOf!(vector3d, U)) {
                mixin("start " ~ op ~ "= value;");
            mixin("end " ~ op ~ "= value;");
        } else static if (isArray!U) {
            static assert(isNumeric!(typeof(value[0])));
            assert(value.length == 3, "Cannot add array. Length is not 3.");
            mixin("start " ~ op ~ "= value;");
            mixin("end " ~ op ~ "= value;");
        } else {
            static assert(isNumeric!(typeof(value)));
            mixin("start " ~ op ~ "= value;");
            mixin("end " ~ op ~ "= value;");
        }

        return this;
    }

    // Operators.
    line3d!T opBinary(string op, U)(const U value) const {
        // This is compiler code. 
        // Give line3d even more operators than C++.
        static if (__traits(isSame, U, line3d)) {
            mixin("return line3d!T(start " ~ op ~ " value.start, end " ~ op ~ " value.end);");
            } else static if (isInstanceOf!(vector3d, U)) {
                mixin("return line3d!T(start " ~ op ~ " value, end " ~ op ~ " value);");
        } else static if (isArray!U) {
            static assert(isNumeric!(typeof(value[0])));
            assert(value.length == 3, "Cannot add array. Length is not 3.");
            mixin(
                "return line3d!T(start " ~ op ~ " value, end " ~ op ~ " value);");
        } else {
            static assert(isNumeric!(typeof(value)));
            mixin(
                "return line3d!T(start " ~ op ~ " value, end " ~ op ~ " value);");
        }
    }



	line3d<T> operator+(const vector3d<T> &point) const { return line3d<T>(start + point, end + point); }
	line3d<T> &operator+=(const vector3d<T> &point)
	{
		start += point;
		end += point;
		return *this;
	}

	line3d<T> operator-(const vector3d<T> &point) const { return line3d<T>(start - point, end - point); }
	line3d<T> &operator-=(const vector3d<T> &point)
	{
		start -= point;
		end -= point;
		return *this;
	}

	constexpr bool operator==(const line3d<T> &other) const
	{
		return (start == other.start && end == other.end) || (end == other.start && start == other.end);
	}
	constexpr bool operator!=(const line3d<T> &other) const
	{
		return !(start == other.start && end == other.end) || (end == other.start && start == other.end);
	}

	// functions
	//! Set this line to a new line going through the two points.
	void setLine(const T &xa, const T &ya, const T &za, const T &xb, const T &yb, const T &zb)
	{
		start.set(xa, ya, za);
		end.set(xb, yb, zb);
	}
	//! Set this line to a new line going through the two points.
	void setLine(const vector3d<T> &nstart, const vector3d<T> &nend)
	{
		start.set(nstart);
		end.set(nend);
	}
	//! Set this line to new line given as parameter.
	void setLine(const line3d<T> &line)
	{
		start.set(line.start);
		end.set(line.end);
	}

	//! Get length of line
	/** \return Length of line. */
	T getLength() const { return start.getDistanceFrom(end); }

	//! Get squared length of line
	/** \return Squared length of line. */
	T getLengthSQ() const { return start.getDistanceFromSQ(end); }

	//! Get middle of line
	/** \return Center of line. */
	vector3d<T> getMiddle() const
	{
		return (start + end) / (T)2;
	}

	//! Get vector of line
	/** \return vector of line. */
	vector3d<T> getVector() const
	{
		return end - start;
	}

	//! Check if the given point is between start and end of the line.
	/** Assumes that the point is already somewhere on the line.
	\param point The point to test.
	\return True if point is on the line between start and end, else false.
	*/
	bool isPointBetweenStartAndEnd(const vector3d<T> &point) const
	{
		return point.isBetweenPoints(start, end);
	}

	//! Get the closest point on this line to a point
	/** \param point The point to compare to.
	\return The nearest point which is part of the line. */
	vector3d<T> getClosestPoint(const vector3d<T> &point) const
	{
		vector3d<T> c = point - start;
		vector3d<T> v = end - start;
		T d = (T)v.getLength();
		v /= d;
		T t = v.dotProduct(c);

		if (t < (T)0.0)
			return start;
		if (t > d)
			return end;

		v *= t;
		return start + v;
	}

	//! Check if the line intersects with a sphere
	/** \param sorigin: Origin of the sphere.
	\param sradius: Radius of the sphere.
	\param outdistance: The distance to the first intersection point.
	\return True if there is an intersection.
	If there is one, the distance to the first intersection point
	is stored in outdistance. */
	bool getIntersectionWithSphere(const vector3d<T> &sorigin, T sradius, f64 &outdistance) const
	{
		const vector3d<T> q = sorigin - start;
		T c = q.getLength();
		T v = q.dotProduct(getVector().normalize());
		T d = sradius * sradius - (c * c - v * v);

		if (d < 0.0)
			return false;

		outdistance = v - core::squareroot(d);
		return true;
	}

	
};

//! Typedef for an f32 line.
typedef line3d<f32> line3df;
//! Typedef for an integer line.
typedef line3d<s32> line3di;

// } // end namespace core
// } // end namespace irr
