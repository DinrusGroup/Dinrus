/*
 *  Copyright (C) 2004-2006 by Digital Mars, www.digitalmars.com
 *  Written by Walter Bright
 *
 *  This software is provided 'as-is', without any express or implied
 *  warranty. In no событие will the authors be held liable for any damages
 *  arising from the use of this software.
 *
 *  Permission is granted to anyone to use this software for any purpose,
 *  including commercial applications, and to alter it and redistribute it
 *  freely, in both source and binary form, subject to the following
 *  restrictions:
 *
 *  o  The origin of this software must not be misrepresented; you must not
 *     claim that you wrote the original software. If you use this software
 *     in a product, an acknowledgment in the product documentation would be
 *     appreciated but is not required.
 *  o  Altered source versions must be plainly marked as such, and must not
 *     be misrepresented as being the original software.
 *  o  This notice may not be removed or altered from any source
 *     distribution.
 */

/*************************
 * Encode and decode Uniform Resource Identifiers (URIs).
 * URIs are used in internet transfer protocols.
 * Valid URI characters consist of letters, digits,
 * and the characters $(B ;/?:@&amp;=+$,-_.!~*'())
 * Reserved URI characters are $(B ;/?:@&amp;=+$,)
 * Escape sequences consist of $(B %) followed by two hex digits.
 *
 * See_Also:
 *	$(LINK2 http://www.ietf.org/rfc/rfc3986.txt, RFC 3986)<br>
 *	$(LINK2 http://en.wikipedia.org/wiki/Uniform_resource_identifier, Wikipedia)
 * Macros:
 *	WIKI = Phobos/StdUri
 */

module std.uri;

import std.x.uri;

export extern(D):

бцел аски8гекс(дим с)
{
	return std.x.uri.ascii2hex(с);
}

ткст раскодируйУИР(ткст кодирУИР)
{
	return std.x.uri.decode(кодирУИР);
}
ткст раскодируйКомпонентУИР(ткст кодирКомпонУИР)
{
	return std.x.uri.decodeComponent(кодирКомпонУИР);
}
ткст кодируйУИР(ткст уир)
{
	return std.x.uri.encode(уир);
}
ткст кодируйКомпонентУИР(ткст уирКомпон)
{
	return std.x.uri.encodeComponent(уирКомпон);
}