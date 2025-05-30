module include.vector2d;

import include.dimension_2d;
import include.irr_types;
import IrrMath = include.irr_math;
import std.traits;

// Copyright (C) 2002-2012 Nikolaus Gebhardt
// This file is part of the "Irrlicht Engine".
// For conditions of distribution and use, see copyright notice in irrlicht.h

// #pragma once

// #include "irrMath.h"
// #include "dimension2d.h"

// #include <functional>
// #include <array>
// #include <cassert>

// namespace irr
// {
// namespace core
// {

//! 2d vector template class with lots of operators and methods.
/** As of Irrlicht 1.6, this class supersedes position2d, which should
	be considered deprecated. */
// template <class T>
struct vector2d(T) {
    // Basic any typecheck.
    static assert(isNumeric!T);

    //! X coordinate of vector.
    T X = 0;

    //! Y coordinate of vector.
    T Y = 0;

    //! Constructor with two different values
    this(T nx, T ny) {
        X = nx;
        Y = ny;
    }
    //! Constructor with the same value for both members
    this(T n) {
        X = n;
        Y = n;
    }

    //! Construct from a dimension2d.
    this(const ref dimension2d!T other) {
        X = other.Width;
        Y = other.Height;
    }

    this(const ref T[2] arr) {
        X = arr[0];
        Y = arr[1];
    }

    // template <class U>
    static vector2d!T from(U)(const ref vector2d!U other) {
        return vector2d(cast(T)(other.X), cast(T)(other.Y));
    }

    // operators

    // Negate.
    vector2d!T opUnary(string s : "-")() const {
        return vector2d!T(-X, -Y);
    }

    //! Equality operator
    bool opEquals(U)(const ref U other) const {
        static if (__traits(isSame, U, vector2d)) {
            return IrrMath.equals(X, other.X) &&
                IrrMath.equals(Y, other.Y);
        } else static if (isInstanceOf!(dimension2d, U)) {
            return IrrMath.equals(X, other.Width) &&
                IrrMath.equals(Y, other.Height);
        } else
            static assert(0, "Must be of vector2d or dimension2d");
    }

    // Assignment.
    void opAssign(U)(U value) {
        // This is (half) compiler code. 
        // Give vector2d even more assignments than C++.
        static if (__traits(isSame, U, vector2d)) {
            this.X = value.X;
            this.Y = value.Y;
        } else static if (isInstanceOf!(dimension2d, U)) {
            this.X = value.Width;
            this.Y = value.Height;
        } else static if (isArray!U) {
            static assert(isNumeric!(typeof(value[0])));
            assert(value.length == 2, "Cannot add array. Length is not 2.");
            this.X = value[0];
            this.Y = value[1];
        } else {
            static assert(isNumeric!(typeof(value)));
            this.X = value;
            this.Y = value;
        }
    }

    // Operator assignment.
    ref vector2d!T opOpAssign(string op, U)(const U value) {
        // This is compiler code. 
        // Give vector2d even more assignment operator operators than C++.
        static if (__traits(isSame, U, vector2d)) {
            mixin("X " ~ op ~ "= value.X;");
            mixin("Y " ~ op ~ "= value.Y;");
        } else static if (isInstanceOf!(dimension2d, U)) {
            mixin("X " ~ op ~ "= value.Width;");
            mixin("Y " ~ op ~ "= value.Height;");
        } else static if (isArray!U) {
            static assert(isNumeric!(typeof(value[0])));
            assert(value.length == 2, "Cannot add array. Length is not 2.");
            mixin("X " ~ op ~ "= value[0];");
            mixin("Y " ~ op ~ "= value[1];");
        } else {
            static assert(isNumeric!(typeof(value)));
            mixin("X " ~ op ~ "= value;");
            mixin("Y " ~ op ~ "= value;");
        }

        return this;
    }

    // Operators.
    vector2d!T opBinary(string op, U)(const U value) const {
        // This is compiler code. 
        // Give vector2d even more operators than C++.
        static if (__traits(isSame, U, vector2d)) {
            mixin("return vector2d!T(X " ~ op ~ " value.X, Y " ~ op ~ " value.Y);");
        } else static if (isInstanceOf!(dimension2d, U)) {
            mixin("return vector2d!T(X " ~ op ~ " value.Width, Y " ~ op ~ " value.Height);");
        } else static if (isArray!U) {
            static assert(isNumeric!(typeof(value[0])));
            assert(value.length == 2, "Cannot add array. Length is not 2.");
            mixin(
                "return vector2d!T(X " ~ op ~ " value[0], Y " ~ op ~ " value[1]);");
        } else {
            static assert(isNumeric!(typeof(value)));
            mixin("return vector2d!T(X " ~ op ~ " value, Y " ~ op ~ " value);");
        }
    }

    ref T opIndex(u32 index) {
        switch (index) {
        case 0:
            return X;
        case 1:
            return Y;
        default:
            IRR_CODE_UNREACHABLE();
        }
        assert(0);
    }

    ref const(T) opIndex(u32 index) const {
        switch (index) {
        case 0:
            return X;
        case 1:
            return Y;
        default:
            IRR_CODE_UNREACHABLE();
        }
        assert(0);
    }

    //! sort in order X, Y.
    int opCmp(U)(const U other) const {
        static if (__traits(isSame, U, vector2d)) {
            if (X < other.X || (X == other.X && Y < other.Y)) {
                return -1;
            } else if (X > other.X || (X == other.X && Y > other.Y)) {
                return 1;
            }
            return 0;
        } else static if (isInstanceOf!(dimension2d, U)) {
            if (X < other.Width || (X == other.Width && Y < other.Height)) {
                return -1;
            } else if (X > other.Width || (X == other.Width && Y > other.Height)) {
                return 1;
            }
            return 0;
        }
    }

    // functions

    //! Checks if this vector equals the other one.
    /** Takes floating point rounding errors into account.
	\param other Vector to compare with.
	\return True if the two vector are (almost) equal, else false. */
    bool equals(const ref vector2d!T other) const {
        return IrrMath.equals(X, other.X) && IrrMath.equals(Y, other.Y);
    }

    ref vector2d!T set(T nx, T ny) {
        X = nx;
        Y = ny;
        return this;
    }

    ref vector2d!T set(const ref vector2d!T p) {
        X = p.X;
        Y = p.Y;
        return this;
    }

    //! Gets the length of the vector.
    /** \return The length of the vector. */
    T getLength() const {
        return IrrMath.squareroot(X * X + Y * Y);
    }

    //! Get the squared length of this vector
    /** This is useful because it is much faster than getLength().
	\return The squared length of the vector. */
    T getLengthSQ() const {
        return X * X + Y * Y;
    }

    //! Get the dot product of this vector with another.
    /** \param other Other vector to take dot product with.
	\return The dot product of the two vectors. */
    T dotProduct(const ref vector2d!T other) const {
        return X * other.X + Y * other.Y;
    }

    //! check if this vector is parallel to another vector
    bool nearlyParallel(const ref vector2d!T other, const T factor = IrrMath.relativeErrorFactor!T()) const {
        // https://eagergames.wordpress.com/2017/04/01/fast-parallel-lines-and-vectors-test/
        // if a || b then  a.x/a.y = b.x/b.y (similar triangles)
        // if a || b then either both x are 0 or both y are 0.

        return IrrMath.equalsRelative(X * other.Y, other.X * Y, factor) &&  // a bit counterintuitive, but makes sure  that
            // only y or only x are 0, and at same time deals
            // with the case where one vector is zero vector.
            (X * other.X + Y * other.Y) != 0;
    }

    //! Gets distance from another point.
    /** Here, the vector is interpreted as a point in 2-dimensional space.
	\param other Other vector to measure from.
	\return Distance from other point. */
    T getDistanceFrom(const ref vector2d!T other) const {
        return vector2d!T(X - other.X, Y - other.Y).getLength();
    }

    //! Returns squared distance from another point.
    /** Here, the vector is interpreted as a point in 2-dimensional space.
	\param other Other vector to measure from.
	\return Squared distance from other point. */
    T getDistanceFromSQ(const ref vector2d!T other) const {
        return vector2d!T(X - other.X, Y - other.Y).getLengthSQ();
    }

    //! rotates the point anticlockwise around a center by an amount of degrees.
    /** \param degrees Amount of degrees to rotate by, anticlockwise.
	\param center Rotation center.
	\return This vector after transformation. */
    ref vector2d!T rotateBy(f64 degrees, const vector2d!T center = vector2d!T()) {
        degrees *= IrrMath.DEGTORAD64;
        const f64 cs = IrrMath.cos(degrees);
        const f64 sn = IrrMath.sin(degrees);

        X -= center.X;
        Y -= center.Y;

        set(cast(T)(X * cs - Y * sn), cast(T)(X * sn + Y * cs));

        X += center.X;
        Y += center.Y;
        return this;
    }

    //! Normalize the vector.
    /** The null vector is left untouched.
	\return Reference to this vector, after normalization. */
    ref vector2d!T normalize() {
        f32 length = (f32)(X * X + Y * Y);
        if (length == 0)
            return this;
        length = IrrMath.reciprocal_squareroot(length);
        X = cast(T)(X * length);
        Y = cast(T)(Y * length);
        return this;
    }

    //! Calculates the angle of this vector in degrees in the trigonometric sense.
    /** 0 is to the right (3 o'clock), values increase counter-clockwise.
	This method has been suggested by Pr3t3nd3r.
	\return Returns a value between 0 and 360. */
    f64 getAngleTrig() const {
        if (Y == 0)
            return X < 0 ? 180 : 0;
        else if (X == 0)
            return Y < 0 ? 270 : 90;

        if (Y > 0) {
            if (X > 0) {
                return IrrMath.atan(cast(f64) Y / cast(f64) X) * IrrMath.RADTODEG64;
            } else {
                return 180.0 - IrrMath.atan(cast(f64) Y / -cast(f64) X) * IrrMath.RADTODEG64;
            }
        } else if (X > 0) {
            return 360.0 - IrrMath.atan(-cast(f64) Y / cast(f64) X) * IrrMath.RADTODEG64;
        } else {
            return 180.0 + IrrMath.atan(-cast(f64) Y / -cast(f64) X) * IrrMath.RADTODEG64;
        }
    }

    //! Calculates the angle of this vector in degrees in the counter trigonometric sense.
    /** 0 is to the right (3 o'clock), values increase clockwise.
	\return Returns a value between 0 and 360. */
    pragma(inline, true) f64 getAngle() const {
        if (Y == 0) // corrected thanks to a suggestion by Jox
            return X < 0 ? 180 : 0;
        else if (X == 0)
            return Y < 0 ? 90 : 270;

        // don't use getLength here to avoid precision loss with s32 vectors
        // avoid floating-point trouble as sqrt(y*y) is occasionally larger than y, so clamp
        const f64 tmp = IrrMath.clamp(Y / IrrMath.sqrt(cast(f64)(X * X + Y * Y)), -1.0, 1.0);
        const f64 angle = IrrMath.atan(IrrMath.squareroot(1 - tmp * tmp) / tmp) * IrrMath
            .RADTODEG64;

        if (X > 0 && Y > 0)
            return angle + 270;
        else if (X > 0 && Y < 0)
            return angle + 90;
        else if (X < 0 && Y < 0)
            return 90 - angle;
        else if (X < 0 && Y > 0)
            return 270 - angle;

        return angle;
    }

    //! Calculates the angle between this vector and another one in degree.
    /** \param b Other vector to test with.
	\return Returns a value between 0 and 90. */
    pragma(inline, true) f64 getAngleWith(const ref vector2d!T b) const {
        f64 tmp = (f64)(X * b.X + Y * b.Y);

        if (tmp == 0.0)
            return 90.0;

        tmp = tmp / IrrMath.squareroot((f64)((X * X + Y * Y) * (b.X * b.X + b.Y * b.Y)));
        if (tmp < 0.0)
            tmp = -tmp;
        if (tmp > 1.0) //   avoid floating-point trouble
            tmp = 1.0;

        return IrrMath.atan(IrrMath.sqrt(1 - tmp * tmp) / tmp) * IrrMath.RADTODEG64;
    }

    //! Returns if this vector interpreted as a point is on a line between two other points.
    /** It is assumed that the point is on the line.
	\param begin Beginning vector to compare between.
	\param end Ending vector to compare between.
	\return True if this vector is between begin and end, false if not. */
    bool isBetweenPoints(const ref vector2d!T begin, const ref vector2d!T end) const {
        //             .  end
        //            /
        //           /
        //          /
        //         . begin
        //        -
        //       -
        //      . this point (am I inside or outside)? <- You're not not inside the outside of the line
        //
        if (begin.X != end.X) {
            return ((begin.X <= X && X <= end.X) ||
                    (begin.X >= X && X >= end.X));
        } else {
            return ((begin.Y <= Y && Y <= end.Y) ||
                    (begin.Y >= Y && Y >= end.Y));
        }
    }

    //! Creates an interpolated vector between this vector and another vector.
    /** \param other The other vector to interpolate with.
	\param d Interpolation value between 0.0f (all the other vector) and 1.0f (all this vector).
	Note that this is the opposite direction of interpolation to getInterpolated_quadratic()
	\return An interpolated vector.  This vector is not modified. */
    vector2d!T getInterpolated(const ref vector2d!T other, f64 d) const {
        const f64 inv = 1.0f - d;
        return vector2d!T(cast(T)(other.X * inv + X * d), cast(T)(other.Y * inv + Y * d));
    }

    //! Creates a quadratically interpolated vector between this and two other vectors.
    /** \param v2 Second vector to interpolate with.
	\param v3 Third vector to interpolate with (maximum at 1.0f)
	\param d Interpolation value between 0.0f (all this vector) and 1.0f (all the 3rd vector).
	Note that this is the opposite direction of interpolation to getInterpolated() and interpolate()
	\return An interpolated vector. This vector is not modified. */
    vector2d!T getInterpolated_quadratic(const ref vector2d!T v2, const ref vector2d!T v3, f64 d) const {
        // this*(1-d)*(1-d) + 2 * v2 * (1-d) + v3 * d * d;
        const f64 inv = 1.0f - d;
        const f64 mul0 = inv * inv;
        const f64 mul1 = 2.0f * d * inv;
        const f64 mul2 = d * d;

        return vector2d!T(cast(T)(X * mul0 + v2.X * mul1 + v3.X * mul2),
            cast(T)(Y * mul0 + v2.Y * mul1 + v3.Y * mul2));
    }

    /*! Test if this point and another 2 points taken as triplet
		are colinear, clockwise, anticlockwise. This can be used also
		to check winding order in triangles for 2D meshes.
		\return 0 if points are colinear, 1 if clockwise, 2 if anticlockwise
	*/
    s32 checkOrientation(const ref vector2d!T b, const ref vector2d!T c) const {
        // Example of clockwise points
        //
        //   ^ Y     *
        //   |       A
        //   |      ...
        //   |     . . .
        //   |    C.....B
        //   |      | |     I made it into a christmas tree.
        //   +---------------> X

        T val = (b.Y - Y) * (c.X - b.X) -
            (b.X - X) * (c.Y - b.Y);

        if (val == 0)
            return 0; // colinear

        return (val > 0) ? 1 : 2; // clock or counterclock wise
    }

    /*! Returns true if points (a,b,c) are clockwise on the X,Y plane*/
    pragma(inline, true) bool areClockwise(const ref vector2d!T b, const ref vector2d!T c) const {
        T val = (b.Y - Y) * (c.X - b.X) -
            (b.X - X) * (c.Y - b.Y);

        return val > 0;
    }

    /*! Returns true if points (a,b,c) are counterclockwise on the X,Y plane*/
    pragma(inline, true) bool areCounterClockwise(const ref vector2d!T b, const ref vector2d!T c) const {
        T val = (b.Y - Y) * (c.X - b.X) -
            (b.X - X) * (c.Y - b.Y);

        return val < 0;
    }

    //! Sets this vector to the linearly interpolated vector between a and b.
    /** \param a first vector to interpolate with, maximum at 1.0f
	\param b second vector to interpolate with, maximum at 0.0f
	\param d Interpolation value between 0.0f (all vector b) and 1.0f (all vector a)
	Note that this is the opposite direction of interpolation to getInterpolated_quadratic()
	*/
    ref vector2d!T interpolate(const ref vector2d!T a, const ref vector2d!T b, f64 d) {
        X = cast(T)(cast(f64) b.X + ((a.X - b.X) * d));
        Y = cast(T)(cast(f64) b.Y + ((a.Y - b.Y) * d));
        return this;
    }

}

//! Typedef for f32 2d vector.
alias vector2df = vector2d!f32;

//! Typedef for integer 2d vector.
alias vector2di = vector2d!s32;
