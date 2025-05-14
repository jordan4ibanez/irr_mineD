module irr_string;

/* HACK: import these string methods from MT's util/string.h */
extern wstring utf8_to_wide(const string input);
extern string wide_to_utf8(const wstring input);
/* */


//! Very simple string class with some useful features.
/** string<c8> and string<wchar_t> both accept Unicode AND ASCII/Latin-1,
so you can assign Unicode to string<c8> and ASCII/Latin-1 to string<wchar_t>
(and the other way round) if you want to.

However, note that the conversation between both is not done using any encoding.
This means that c8 strings are treated as ASCII/Latin-1, not UTF-8, and
are simply expanded to the equivalent wchar_t, while Unicode/wchar_t
characters are truncated to 8-bit ASCII/Latin-1 characters, discarding all
other information in the wchar_t.

Helper functions for converting between UTF-8 and wchar_t are provided
outside the string class for explicit use.
*/


