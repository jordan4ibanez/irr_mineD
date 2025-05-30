module include.vector3d;

import include.irr_types;
import IrrMath = include.irr_math;
import std.traits;

// Copyright (C) 2002-2012 Nikolaus Gebhardt
// This file is part of the "Irrlicht Engine".
// For conditions of distribution and use, see copyright notice in irrlicht.h

//! 3d vector template class with lots of operators and methods.
/** The vector3d class is used in Irrlicht for three main purposes:
	1) As a direction vector (most of the methods assume this).
	2) As a position in 3d space (which is synonymous with a direction vector from the origin to this position).
	3) To hold three Euler rotations, where X is pitch, Y is yaw and Z is roll.
*/
// template <class T>
struct vector3d(T) {
    // Basic any typecheck.
    static assert(isNumeric!T);

    //todo: implement opequals, I forgot :D

    //! X coordinate of the vector
    T X = 0;

    //! Y coordinate of the vector
    T Y = 0;

    //! Z coordinate of the vector
    T Z = 0;

    //! Constructor with three different values
    this(T nx, T ny, T nz) {
        X = nx;
        Y = ny;
        Z = nz;
    }
    //! Constructor with the same value for all elements
    this(T n) {
        X = n;
        Y = n;
        Z = n;
    }
    //! Array - vector conversion
    this(const ref T[3] arr) {
        X = arr[0];
        Y = arr[1];
        Z = arr[2];
    }

    // template <class U>
    static vector3d!T from(U)(const ref vector3d!U other) {
        return vector3d!T(cast(T)(other.X), cast(T)(other.Y), cast(T)(other.Z));
    }

    // operators

    // Negate.
    vector3d!T opUnary(string s : "-")() const {
        return vector3d!T(-X, -Y, -Z);
    }

    // Assignment.
    void opAssign(U)(U value) {
        // This is (half) compiler code. 
        // Give vector3d even more assignments than C++.
        static if (__traits(isSame, U, vector3d)) {
            this.X = value.X;
            this.Y = value.Y;
            this.Z = value.Z;
        } else static if (isArray!U) {
            static assert(isNumeric!(typeof(value[0])));
            this.X = value[0];
            this.Y = value[1];
            this.Z = value[2];
        } else {
            static assert(isNumeric!(typeof(value)));
            this.X = value;
            this.Y = value;
            this.Z = value;
        }
    }

    // Operator assignment.
    ref vector3d!T opOpAssign(string op, U)(const U value) {
        // This is compiler code. 
        // Give vector3d even more assignment operator operators than C++.
        static if (__traits(isSame, U, vector3d)) {
            mixin("X " ~ op ~ "= value.X;");
            mixin("Y " ~ op ~ "= value.Y;");
            mixin("Z " ~ op ~ "= value.Z;");
        } else static if (isArray!U) {
            static assert(isNumeric!(typeof(value[0])));
            assert(value.length == 3, "Cannot add array. Length is not 3.");
            mixin("X " ~ op ~ "= value[0];");
            mixin("Y " ~ op ~ "= value[1];");
            mixin("Z " ~ op ~ "= value[2];");
        } else {
            static assert(isNumeric!(typeof(value)));
            mixin("X " ~ op ~ "= value;");
            mixin("Y " ~ op ~ "= value;");
            mixin("Z " ~ op ~ "= value;");
        }

        return this;
    }

    // Operators.
    vector3d!T opBinary(string op, U)(const U value) const {
        // This is compiler code. 
        // Give vector3d even more operators than C++.
        static if (__traits(isSame, U, vector3d)) {
            mixin("return vector3d!T(X " ~ op ~ " value.X, Y " ~ op ~ " value.Y, Z " ~ op ~ " value.Z);");
        } else static if (isArray!U) {
            static assert(isNumeric!(typeof(value[0])));
            assert(value.length == 3, "Cannot add array. Length is not 3.");
            mixin(
                "return vector3d!T(X " ~ op ~ " value[0], Y " ~ op ~ " value[1], Z " ~ op ~ " value[2]);");
        } else {
            static assert(isNumeric!(typeof(value)));
            mixin("return vector3d!T(X " ~ op ~ " value, Y " ~ op ~ " value, Z " ~ op ~ " value);");
        }
    }

    ref T opIndex(u32 index) {
        switch (index) {
        case 0:
            return X;
        case 1:
            return Y;
        case 2:
            return Z;
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
        case 2:
            return Z;
        default:
            IRR_CODE_UNREACHABLE();
        }
        assert(0);
    }

    //! sort in order X, Y, Z.
    int opCmp(const vector3d!T other) const {
        if (X < other.X || (X == other.X && Y < other.Y) ||
            (X == other.X && Y == other.Y && Z < other.Z)) {
            return -1;
        } else if (X > other.X || (X == other.X && Y > other.Y) ||
            (X == other.X && Y == other.Y && Z > other.Z)) {
            return 1;
        }
        return 0;
    }

    // functions

    //! Checks if this vector equals the other one.
    /** Takes floating point rounding errors into account.
	\param other Vector to compare with.
	\return True if the two vector are (almost) equal, else false. */
    bool equals(const ref vector3d!T other) const {
        return IrrMath.equals(X, other.X) && IrrMath.equals(Y, other.Y) && IrrMath.equals(Z, other
                .Z);
    }

    ref vector3d!T set(const T nx, const T ny, const T nz) {
        X = nx;
        Y = ny;
        Z = nz;
        return this;
    }

    ref vector3d!T set(const ref vector3d!T p) {
        X = p.X;
        Y = p.Y;
        Z = p.Z;
        return this;
    }

    T[3] toArray() const {
        return [X, Y, Z];
    }

    //! Get length of the vector.
    T getLength() const {
        return IrrMath.squareroot(X * X + Y * Y + Z * Z);
    }

    //! Get squared length of the vector.
    /** This is useful because it is much faster than getLength().
	\return Squared length of the vector. */
    T getLengthSQ() const {
        return X * X + Y * Y + Z * Z;
    }

    //! Get the dot product with another vector.
    T dotProduct(const ref vector3d!T other) const {
        return X * other.X + Y * other.Y + Z * other.Z;
    }

    //! Get distance from another point.
    /** Here, the vector is interpreted as point in 3 dimensional space. */
    T getDistanceFrom(const ref vector3d!T other) const {
        return vector3d!T(X - other.X, Y - other.Y, Z - other.Z).getLength();
    }

    //! Returns squared distance from another point.
    /** Here, the vector is interpreted as point in 3 dimensional space. */
    T getDistanceFromSQ(const ref vector3d!T other) const {
        return vector3d!T(X - other.X, Y - other.Y, Z - other.Z).getLengthSQ();
    }

    //! Calculates the cross product with another vector.
    /** \param p Vector to multiply with.
	\return Cross product of this vector with p. */
    vector3d!T crossProduct(const vector3d!T p) const {
        return vector3d!T(Y * p.Z - Z * p.Y, Z * p.X - X * p.Z, X * p.Y - Y * p.X);
    }

    //! Returns if this vector interpreted as a point is on a line between two other points.
    /** It is assumed that the point is on the line.
	\param begin Beginning vector to compare between.
	\param end Ending vector to compare between.
	\return True if this vector is between begin and end, false if not. */
    bool isBetweenPoints(const ref vector3d!T begin, const ref vector3d!T end) const {
        const T f = (end - begin).getLengthSQ();
        return getDistanceFromSQ(begin) <= f &&
            getDistanceFromSQ(end) <= f;
    }

    //! Normalizes the vector.
    /** In case of the 0 vector the result is still 0, otherwise
	the length of the vector will be 1.
	\return Reference to this vector after normalization. */
    ref vector3d!T normalize() {
        f64 length = X * X + Y * Y + Z * Z;
        if (length == 0) // this check isn't an optimization but prevents getting NAN in the sqrt.
            return this;
        length = IrrMath.reciprocal_squareroot(length);

        X = cast(T)(X * length);
        Y = cast(T)(Y * length);
        Z = cast(T)(Z * length);
        return this;
    }

    //! Sets the length of the vector to a new value
    ref vector3d!T setLength(T newlength) {
        normalize();
        return (this *= newlength);
    }

    //! Inverts the vector.
    ref vector3d!T invert() {
        X *= -1;
        Y *= -1;
        Z *= -1;
        return this;
    }

    //! Rotates the vector by a specified number of degrees around the Y axis and the specified center.
    /** CAREFUL: For historical reasons rotateXZBy uses a right-handed rotation
	(maybe to make it more similar to the 2D vector rotations which are counterclockwise).
	To have this work the same way as rest of Irrlicht (nodes, matrices, other rotateBy functions) pass -1*degrees in here.
	\param degrees Number of degrees to rotate around the Y axis.
	\param center The center of the rotation. */
    void rotateXZBy(f64 degrees, const inout vector3d!T center = vector3d!T()) {
        degrees *= IrrMath.DEGTORAD64;
        f64 cs = IrrMath.cos(degrees);
        f64 sn = IrrMath.sin(degrees);
        X -= center.X;
        Z -= center.Z;
        set(cast(T)(X * cs - Z * sn), Y, cast(T)(X * sn + Z * cs));
        X += center.X;
        Z += center.Z;
    }

    //! Rotates the vector by a specified number of degrees around the Z axis and the specified center.
    /** \param degrees: Number of degrees to rotate around the Z axis.
	\param center: The center of the rotation. */
    void rotateXYBy(f64 degrees, const inout vector3d!T center = vector3d!T()) {
        degrees *= IrrMath.DEGTORAD64;
        f64 cs = IrrMath.cos(degrees);
        f64 sn = IrrMath.sin(degrees);
        X -= center.X;
        Y -= center.Y;
        set(cast(T)(X * cs - Y * sn), cast(T)(X * sn + Y * cs), Z);
        X += center.X;
        Y += center.Y;
    }

    //! Rotates the vector by a specified number of degrees around the X axis and the specified center.
    /** \param degrees: Number of degrees to rotate around the X axis.
	\param center: The center of the rotation. */
    void rotateYZBy(f64 degrees, const inout vector3d!T center = vector3d!T()) {
        degrees *= IrrMath.DEGTORAD64;
        f64 cs = IrrMath.cos(degrees);
        f64 sn = IrrMath.sin(degrees);
        Z -= center.Z;
        Y -= center.Y;
        set(X, cast(T)(Y * cs - Z * sn), cast(T)(Y * sn + Z * cs));
        Z += center.Z;
        Y += center.Y;
    }

    //! Creates an interpolated vector between this vector and another vector.
    /** \param other The other vector to interpolate with.
	\param d Interpolation value between 0.0f (all the other vector) and 1.0f (all this vector).
	Note that this is the opposite direction of interpolation to getInterpolated_quadratic()
	\return An interpolated vector.  This vector is not modified. */
    vector3d!T getInterpolated(const ref vector3d!T other, f64 d) const {
        const f64 inv = 1.0 - d;
        return vector3d!T(cast(T)(other.X * inv + X * d), cast(T)(other.Y * inv + Y * d), cast(T)(
                other.Z * inv + Z * d));
    }

    //! Creates a quadratically interpolated vector between this and two other vectors.
    /** \param v2 Second vector to interpolate with.
	\param v3 Third vector to interpolate with (maximum at 1.0f)
	\param d Interpolation value between 0.0f (all this vector) and 1.0f (all the 3rd vector).
	Note that this is the opposite direction of interpolation to getInterpolated() and interpolate()
	\return An interpolated vector. This vector is not modified. */
    vector3d!T getInterpolated_quadratic(const ref vector3d!T v2, const ref vector3d!T v3, f64 d) const {
        // this*(1-d)*(1-d) + 2 * v2 * (1-d) + v3 * d * d;
        const f64 inv = cast(T) 1.0 - d;
        const f64 mul0 = inv * inv;
        const f64 mul1 = cast(T) 2.0 * d * inv;
        const f64 mul2 = d * d;

        return vector3d!T(cast(T)(X * mul0 + v2.X * mul1 + v3.X * mul2),
            cast(T)(Y * mul0 + v2.Y * mul1 + v3.Y * mul2),
            cast(T)(Z * mul0 + v2.Z * mul1 + v3.Z * mul2));
    }

    //! Sets this vector to the linearly interpolated vector between a and b.
    /** \param a first vector to interpolate with, maximum at 1.0f
	\param b second vector to interpolate with, maximum at 0.0f
	\param d Interpolation value between 0.0f (all vector b) and 1.0f (all vector a)
	Note that this is the opposite direction of interpolation to getInterpolated_quadratic()
	*/
    ref vector3d!T interpolate(const ref vector3d!T a, const ref vector3d!T b, f64 d) {
        X = cast(T)(cast(f64) b.X + ((a.X - b.X) * d));
        Y = cast(T)(cast(f64) b.Y + ((a.Y - b.Y) * d));
        Z = cast(T)(cast(f64) b.Z + ((a.Z - b.Z) * d));
        return this;
    }

    //! Get the rotations that would make a (0,0,1) direction vector point in the same direction as this direction vector.
    /** Thanks to Arras on the Irrlicht forums for this method.  This utility method is very useful for
	orienting scene nodes towards specific targets.  For example, if this vector represents the difference
	between two scene nodes, then applying the result of getHorizontalAngle() to one scene node will point
	it at the other one.
	Example code:
	// Where target and seeker are of type ISceneNode*
	const vector3df toTarget(target->getAbsolutePosition() - seeker->getAbsolutePosition());
	const vector3df requiredRotation = toTarget.getHorizontalAngle();
	seeker->setRotation(requiredRotation);

	\return A rotation vector containing the X (pitch) and Y (raw) rotations (in degrees) that when applied to a
	+Z (e.g. 0, 0, 1) direction vector would make it point in the same direction as this vector. The Z (roll) rotation
	is always 0, since two Euler rotations are sufficient to point in any given direction. */
    vector3d!T getHorizontalAngle() const {
        vector3d!T angle;

        // tmp avoids some precision troubles on some compilers when working with T=s32
        f64 tmp = (IrrMath.atan2(cast(f64) X, cast(f64) Z) * IrrMath.RADTODEG64);
        angle.Y = cast(T) tmp;

        if (angle.Y < 0)
            angle.Y += 360;
        if (angle.Y >= 360)
            angle.Y -= 360;

        const f64 z1 = IrrMath.squareroot(X * X + Z * Z);

        tmp = (IrrMath.atan2(cast(f64) z1, cast(f64) Y) * IrrMath.RADTODEG64 - 90.0);
        angle.X = cast(T) tmp;

        if (angle.X < 0)
            angle.X += 360;
        if (angle.X >= 360)
            angle.X -= 360;

        return angle;
    }

    //! Get the spherical coordinate angles
    /** This returns Euler degrees for the point represented by
	this vector.  The calculation assumes the pole at (0,1,0) and
	returns the angles in X and Y.
	*/
    vector3d!T getSphericalCoordinateAngles() const {
        vector3d!T angle;
        const f64 length = X * X + Y * Y + Z * Z;

        if (length) {
            if (X != 0) {
                angle.Y = cast(T)(IrrMath.atan2(cast(f64) Z, cast(f64) X) * IrrMath.RADTODEG64);
            } else if (Z < 0)
                angle.Y = 180;

            angle.X = cast(T)(IrrMath.acos(
                    Y * IrrMath.reciprocal_squareroot(length)) * IrrMath.RADTODEG64);
        }
        return angle;
    }

    //! Builds a direction vector from (this) rotation vector.
    /** This vector is assumed to be a rotation vector composed of 3 Euler angle rotations, in degrees.
	The implementation performs the same calculations as using a matrix to do the rotation.

	\param[in] forwards  The direction representing "forwards" which will be rotated by this vector.
	If you do not provide a direction, then the +Z axis (0, 0, 1) will be assumed to be forwards.
	\return A direction vector calculated by rotating the forwards direction by the 3 Euler angles
	(in degrees) represented by this vector. */
    vector3d!T rotationToDirection(const inout vector3d!T forwards = vector3d!T(0, 0, 1)) const {
        const f64 cr = IrrMath.cos(IrrMath.DEGTORAD64 * X);
        const f64 sr = IrrMath.sin(IrrMath.DEGTORAD64 * X);
        const f64 cp = IrrMath.cos(IrrMath.DEGTORAD64 * Y);
        const f64 sp = IrrMath.sin(IrrMath.DEGTORAD64 * Y);
        const f64 cy = IrrMath.cos(IrrMath.DEGTORAD64 * Z);
        const f64 sy = IrrMath.sin(IrrMath.DEGTORAD64 * Z);

        const f64 srsp = sr * sp;
        const f64 crsp = cr * sp;

        const f64[] pseudoMatrix = [
            (cp * cy), (cp * sy), (-sp),
            (srsp * cy - cr * sy), (srsp * sy + cr * cy), (sr * cp),
            (crsp * cy + sr * sy), (crsp * sy - sr * cy), (cr * cp)
        ];

        return vector3d!T(
            cast(T)(
                forwards.X * pseudoMatrix[0] +
                forwards.Y * pseudoMatrix[3] +
                forwards.Z * pseudoMatrix[6]),
            cast(T)(
                forwards.X * pseudoMatrix[1] +
                forwards.Y * pseudoMatrix[4] +
                forwards.Z * pseudoMatrix[7]),
            cast(T)(
                forwards.X * pseudoMatrix[2] +
                forwards.Y * pseudoMatrix[5] +
                forwards.Z * pseudoMatrix[8]));
    }

}

//! Typedef for a f32 3d vector.
alias vector3df = vector3d!f32;

//! Typedef for an integer 3d vector.
alias vector3di = vector3d!s32;
