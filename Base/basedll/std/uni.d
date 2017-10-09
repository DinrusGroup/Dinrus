
// Написано на языке программирования Динрус. Разработчик Виталий Кулич.

/*
 * Placed into the Public Domain.
 * Digital Mars, www.digitalmars.com
 * Written by Walter Bright
 */

/**
 * Simple Unicode character classification functions.
 * For ASCII classification, see $(LINK2 std_ctype.html, std.ctype).
 * Macros:
 *	WIKI=Phobos/StdUni
 * References:
 *	$(LINK2 http://www.digitalmars.com/d/ascii-table.html, ASCII Table),
 *	$(LINK2 http://en.wikipedia.org/wiki/Unicode, Wikipedia),
 *	$(LINK2 http://www.unicode.org, The Unicode Consortium)
 * Trademarks:
 *	Unicode(tm) is a trademark of Unicode, Inc.
 */


module std.uni;

import std.x.uni;

бул юпроп_ли(дим с){return cast(бул) std.x.uni.isUniLower(с);}
бул юзаг_ли(дим с){return cast(бул) std.x.uni.isUniUpper(с);}
дим в_юпроп(дим с){return std.x.uni.toUniLower(с);}
дим в_юзаг(дим с){return std.x.uni.toUniUpper(с);}
бул юцб_ли(дим с){return cast(бул) std.x.uni.isUniAlpha(с);}