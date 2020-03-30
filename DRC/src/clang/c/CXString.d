/*===-- clang-c/CXString.h - C Index strings  --------------------*- C -*-===*\
|*                                                                            *|
|*                     The LLVM Compiler Infrastructure                       *|
|*                                                                            *|
|* This file is distributed under the University of Illinois Open Source      *|
|* License. See LICENSE.TXT for details.                                      *|
|*                                                                            *|
|*===----------------------------------------------------------------------===*|
|*                                                                            *|
|* This header provides the interface to C Index strings.                     *|
|*                                                                            *|
\*===----------------------------------------------------------------------===*/

module clang.c.CXString;

extern (C):

/**
 * \defgroup CINDEX_STRING String manipulation routines
 * \ingroup CINDEX
 *
 * @{
 */

/**
 * A character ткст.
 *
 * The \c CXString тип is used to return strings from the interface when
 * the ownership of that ткст might differ from one call to the next.
 * Use \c clang_getCString() to retrieve the ткст data and, once finished
 * with the ткст data, call \c clang_disposeString() to free the ткст.
 */
struct CXString
{
    ук data;
    uint private_flags;
}

struct CXStringSet
{
    CXString* Strings;
    uint Count;
}

/**
 * Retrieve the character data associated with the given ткст.
 */
ткст0 clang_getCString(CXString ткст);

/**
 * Free the given ткст.
 */
проц clang_disposeString(CXString ткст);

/**
 * Free the given ткст set.
 */
проц clang_disposeStringSet(CXStringSet* set);

/**
 * @}
 */

