module irr_types;

// Copyright (C) 2002-2012 Nikolaus Gebhardt
// This file is part of the "Irrlicht Engine".
// For conditions of distribution and use, see copyright notice in irrlicht.h

import std.format;

/// 8 bit unsigned variable.
alias u8 = ubyte;

/// 8 bit signed variable.
alias s8 = byte;

/** This is a typedef for char, it ensures portability of the engine. */
/// 8 bit character variable.
alias c8 = char;

/// 16 bit unsigned variable.
alias u16 = ushort;

/// 16 bit signed variable.
alias s16 = short;

/// 32 bit unsigned variable.
alias u32 = uint;

/// 32 bit signed variable.
alias s32 = int;

/// 64 bit unsigned variable.
alias u64 = ulong;

/// 64 bit signed variable.
alias s64 = long;

/** This is a typedef for float, it ensures portability of the engine. */
/// 32 bit floating point variable.
alias f32 = float;

/** This is a typedef for double, it ensures portability of the engine. */
/// 64 bit floating point variable.
alias f64 = double;

/// Defines for snprintf_irr because snprintf method does not match the ISO C
/// standard on Windows platforms.
/// We want int snprintf_irr(char *str, size_t size, const char *format, ...);
alias snprintf_irr = format;

///! Note: this was a workaround for an ANCIENT microsoft compiler bug. This should be removed!
/// Type name for character type used by the file system (legacy).
alias fschar_t = char;
string _IRR_TEXT(string X) {
    return X;
}

/// Invokes undefined behavior for unreachable code optimization
/// Note: an assert(false) is included first to catch this in debug builds
void IRR_CODE_UNREACHABLE() {
    assert(false);
}

/** some compilers can create those by directly writing the
code like 'code', but some generate warnings so we use this macro here */
/// creates four CC codes used in Irrlicht for simple ids
u32 MAKE_IRR_ID(A, B, C, D)(A c0, B c1, C c2, D c3) {
    return (
        cast(u32) cast(u8)(c0) | (cast(u32) cast(u8)(c1) << 8) | (
            cast(u32) cast(u8)(c2) << 16) | (cast(u32) cast(u8)(c3) << 24)
    );
}
