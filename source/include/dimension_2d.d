module include.dimension_2d;

import include.irr_types;
import include.vector2d;
import IrrMath = include.irr_math;
import std.traits;

// Copyright (C) 2002-2012 Nikolaus Gebhardt
// This file is part of the "Irrlicht Engine".
// For conditions of distribution and use, see copyright notice in irrlicht.h

//! Specifies a 2 dimensional size.
// template <class T>
struct dimension2d(T) {
    // Basic any typecheck.
    static assert(isNumeric!T);

    //! Width of the dimension.
    T Width = 0;
    //! Height of the dimension.
    T Height = 0;

    //! Constructor with width and height
    this(const T width, const T height) {
        Width = width;
        Height = height;
    }

    //! Constructor from a vector2d.
    this(const ref vector2d!T other) {
        Width = other.X;
        Height = other.Y;
    }

    //! Use this constructor only where you are sure that the conversion is valid.
    // template <class U>
    this(U)(const ref dimension2d!U other) {
        Width = cast(T) other.Width;
        Height = cast(T) other.Height;

    }

    // template <class U>
    ref dimension2d!T opAssign(U)(const ref dimension2d!U other) {
        Width = cast(T) other.Width;
        Height = cast(T) other.Height;
        return this;
    }

    // ! Set to new values
    ref dimension2d!T set(const ref T width, const ref T height) {
        Width = width;
        Height = height;
        return this;
    }

    //! Equality operator
    bool opEquals(U)(const ref U other) const {
        static if (__traits(isSame, U, dimension2d)) {
            return IrrMath.equals(Width, other.Width) &&
                IrrMath.equals(Height, other.Height);
        } else static if (isInstanceOf!(vector2d, U)) {
            return IrrMath.equals(Width, other.X) &&
                IrrMath.equals(Height, other.Y);
        } else
            static assert(0, "Must be of vector2d or dimension2d");
    }

    // Assignment.
    void opAssign(U)(U value) {
        // This is (half) compiler code. 
        // Give dimension2d even more assignments than C++.
        static if (__traits(isSame, U, dimension2d)) {
            this.Width = value.Width;
            this.Height = value.Height;
        } else static if (isInstanceOf!(vector2d, U)) {
            this.Width = value.X;
            this.Height = value.Y;
        } else static if (isArray!U) {
            static assert(isNumeric!(typeof(value[0])));
            assert(value.length == 2, "Cannot add array. Length is not 2.");
            this.Width = value[0];
            this.Height = value[1];
        } else {
            static assert(isNumeric!(typeof(value)));
            this.Width = value;
            this.Height = value;
        }
    }

    // Operator assignment.
    ref dimension2d!T opOpAssign(string op, U)(const U value) {
        // This is compiler code. 
        // Give dimension2d even more assignment operator operators than C++.
        static if (__traits(isSame, U, dimension2d)) {
            mixin("Width " ~ op ~ "= value.Width;");
            mixin("Height " ~ op ~ "= value.Height;");
        } else static if (isInstanceOf!(vector2d, U)) {
            mixin("Width " ~ op ~ "= value.X;");
            mixin("Height " ~ op ~ "= value.Y;");
        } else static if (isArray!U) {
            static assert(isNumeric!(typeof(value[0])));
            assert(value.length == 2, "Cannot add array. Length is not 2.");
            mixin("Width " ~ op ~ "= value[0];");
            mixin("Height " ~ op ~ "= value[1];");
        } else {
            static assert(isNumeric!(typeof(value)));
            mixin("Width " ~ op ~ "= value;");
            mixin("Height " ~ op ~ "= value;");
        }

        return this;
    }

    // Operators.
    dimension2d!T opBinary(string op, U)(const U value) const {
        // This is compiler code. 
        // Give dimension2d even more operators than C++.
        static if (__traits(isSame, U, dimension2d)) {
            mixin("return dimension2d!T(Width " ~ op ~ " value.Width, Height " ~ op ~ " value.Height);");
        } else static if (isInstanceOf!(vector2d, U)) {
            mixin("return dimension2d!T(Width " ~ op ~ " value.X, Height " ~ op ~ " value.Y);");
        } else static if (isArray!U) {
            static assert(isNumeric!(typeof(value[0])));
            assert(value.length == 2, "Cannot add array. Length is not 2.");
            mixin(
                "return dimension2d!T(Width " ~ op ~ " value[0], Height " ~ op ~ " value[1]);");
        } else {
            static assert(isNumeric!(typeof(value)));
            mixin("return dimension2d!T(Width " ~ op ~ " value, Height " ~ op ~ " value);");
        }
    }

    ref T opIndex(u32 index) {
        switch (index) {
        case 0:
            return Width;
        case 1:
            return Height;
        default:
            IRR_CODE_UNREACHABLE();
        }
        assert(0);
    }

    ref const(T) opIndex(u32 index) const {
        switch (index) {
        case 0:
            return Width;
        case 1:
            return Height;
        default:
            IRR_CODE_UNREACHABLE();
        }
        assert(0);
    }

    //! sort in order Width, Height.
    int opCmp(U)(const U other) const {
        static if (__traits(isSame, U, dimension2d)) {
            if (Width < other.Width || (Width == other.Width && Height < other.Height)) {
                return -1;
            } else if (Width > other.Width || (Width == other.Width && Height > other.Height)) {
                return 1;
            }
            return 0;
        } else static if (isInstanceOf!(vector2d, U)) {
            if (Width < other.X || (Width == other.X && Height < other.Y)) {
                return -1;
            } else if (Width > other.X || (Width == other.X && Height > other.Y)) {
                return 1;
            }
            return 0;
        }
    }

    //! Get area
    T getArea() const {
        return Width * Height;
    }

    //! Get the optimal size according to some properties
    /** This is a function often used for texture dimension
	calculations. The function returns the next larger or
	smaller dimension which is a power-of-two dimension
	(2^n,2^m) and/or square (Width=Height).
	\param requirePowerOfTwo Forces the result to use only
	powers of two as values.
	\param requireSquare Makes width==height in the result
	\param larger Choose whether the result is larger or
	smaller than the current dimension. If one dimension
	need not be changed it is kept with any value of larger.
	\param maxValue Maximum texturesize. if value > 0 size is
	clamped to maxValue
	\return The optimal dimension under the given
	constraints. */
    dimension2d!T getOptimalSize(
        bool requirePowerOfTwo = true,
        bool requireSquare = false,
        bool larger = true,
        u32 maxValue = 0) const {
        u32 i = 1;
        u32 j = 1;
        if (requirePowerOfTwo) {
            while (i < cast(u32) Width)
                i <<= 1;
            if (!larger && i != 1 && i != cast(u32) Width)
                i >>= 1;
            while (j < cast(u32) Height)
                j <<= 1;
            if (!larger && j != 1 && j != cast(u32) Height)
                j >>= 1;
        } else {
            i = cast(u32) Width;
            j = cast(u32) Height;
        }

        if (requireSquare) {
            if ((larger && (i > j)) || (!larger && (i < j)))
                j = i;
            else
                i = j;
        }

        if (maxValue > 0 && i > maxValue)
            i = maxValue;

        if (maxValue > 0 && j > maxValue)
            j = maxValue;

        return dimension2d!T(cast(T) i, cast(T) j);
    }

    //! Get the interpolated dimension
    /** \param other Other dimension to interpolate with.
	\param d Value between 0.0f and 1.0f. d=0 returns other, d=1 returns this, values between interpolate.
	\return Interpolated dimension. */
    dimension2d!T getInterpolated(const ref dimension2d!T other, f32 d) const {
        f32 inv = (1.0f - d);
        return dimension2d!T(cast(T)(other.Width * inv + Width * d), cast(T)(
                other.Height * inv + Height * d));
    }

}

//! Typedef for an f32 dimension.
alias dimension2df = dimension2d!f32;
//! Typedef for an unsigned integer dimension.
alias dimension2du = dimension2d!u32;

//! Typedef for an integer dimension.
/** There are few cases where negative dimensions make sense. Please consider using
	dimension2du instead. */
alias dimension2di = dimension2d!s32;
