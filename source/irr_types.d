module irr_types;

import core.stdc.inttypes;

//! 8 bit unsigned variable.
alias u8 = uint8_t;

//! 8 bit signed variable.
alias s8 = int8_t;

//! 8 bit character variable.
/** This is a typedef for char, it ensures portability of the engine. */
alias c8 = char;

//! 16 bit unsigned variable.
alias u16 = uint16_t;

//! 16 bit signed variable.
alias s16 = int16_t;

//! 32 bit unsigned variable.
alias u32 = uint32_t;

//! 32 bit signed variable.
alias s32 = int32_t;

//! 64 bit unsigned variable.
alias u64 = uint64_t;

//! 64 bit signed variable.
alias s64 = int64_t;

//! 32 bit floating point variable.
/** This is a typedef for float, it ensures portability of the engine. */
alias f32 = float;

//! 64 bit floating point variable.
/** This is a typedef for double, it ensures portability of the engine. */
alias f64 = double;
