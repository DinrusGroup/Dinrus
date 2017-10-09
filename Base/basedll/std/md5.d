md5.d 

/* RSA Data Security, Inc., алгоритм журнала сообщений MD5 
 * Производно от RSA Data Security, Inc. MD5 Message-Digest Algorithm.
 */

/**
 * Вычисляет дайджесты MD5 произвольных данных. Дайджесты MD5
 * это 16-байтные количества, подобные контрольным суммам (checkсуммаМД5)
 * либо crc, но более громоздкие
 *
 * Есть два способа. Первый всё выполяет вызовом одной функции
 * суммаМД5(). Второй используется для буферированных данных.
 *
 * Bugs:
 * Дайджесты MD5 показали свою неуникальность.
 *
 * Author:
 * Процедуры и алгоритмы производны от
 * $(I RSA Data Security, Inc. MD5 Message-Digest Algorithm).
 *
 * References:
 *	$(LINK2 http://en.wikipedia.org/wiki/Md5, Википедия о MD5)
 *
 * Macros:
 *	WIKI = Phobos/StdMd5
 */

/++++++++++++++++++++++++++++++++
 Пример:

--------------------
// This code is derived from the
// RSA Data Security, Inc. MD5 Message-дайджест Algorithm.

import std.md5;

private import std.io;
private import std.string;
private import cidrus;


цел main(ткст[] арги)
{
    foreach (ткст арг; арги)
	 файлМД5(арг);
    return 0;
}

/* дайджестировать файл и вывести результат. */
проц файлМД5(ткст имяф)
{
    фук файл;
    КонтекстМД5 контекст;
    цел длина;
    ббайт[4 * 1024] буфер;
    ббайт дайджест[16];

    if ((файл = откройфл(std.string.вТкст0(имяф), "rb")) == пусто)
	скажифнс("%s не удаётся открыть", имяф);
    else
    {
	контекст.старт();
	while ((длина = читайфл(буфер, 1, буфер.sizeof, файл)) != 0)
	    контекст.обнови(буфер[0 .. длина]);
	контекст.заверши(дайджест);
	закройфл(файл);

	скажифнс("MD5 (%s) = %s", имяф, дайджестМД5вТкст(дайджест));
    }
}
--------------------
 +/

/* Copyright (C) 1991-2, RSA Data Security, Inc. Created 1991. All
rights reserved.

License to copy and use this software is granted provided that it
is identified as the "RSA Data Security, Inc. MD5 Message-дайджест
Algorithm" in all material mentioning or referencing this software
or this function.

License is also granted to make and use derivative works provided
that such works are identified as "derived from the RSA Data
Security, Inc. MD5 Message-дайджест Algorithm" in all material
mentioning or referencing the derived work.

RSA Data Security, Inc. makes no representations concerning either
the merchantability of this software or the suitability of this
software for any particular purpose. It is provided "as is"
without express or implied warranty of any kind.
These notices must be retained in any copies of any part of this
documentation and/or software.
 */

module std.md5;
import std.x.md5;

export:

  проц суммаМД5(ббайт[16] дайджест, проц[] данные){std.x.md5.суммаМД5(дайджест, данные);}
  проц выведиМД5Дайджест(ббайт дайджест[16]){std.x.md5.prцелдайджест(дайджест);}
  ткст дайджестМД5вТкст(ббайт[16] дайджест){return std.x.md5.дайджестToString(дайджест);}
  
struct  КонтекстМД5
{

private MD5_CTX ктс;

export:

    /**
     * MD5 initialization. Begins an MD5 operation, writing a new context.
     */
    проц старт(){ ктс.start();}

    /** MD5 block update operation. Continues an MD5 message-digest
      operation, processing another message block, and updating the
      context.
     */
    проц обнови (проц[] ввод){ ктс.update(ввод);}

    /** MD5 finalization. Ends an MD5 message-digest operation, writing the
     * the message to digest and zeroing the context.
     */
    проц заверши (ббайт[16] дайджест){ктс.finish(дайджест);}

}

unittest
{
    debug(md5) эхо("std.md5.unittest\n");

    ббайт[16] дайджест;

    суммаМД5 (дайджест, "");
    assert(дайджест == cast(ббайт[])x"d41d8cd98f00b204e9800998ecf8427e");

    суммаМД5 (дайджест, "a");
    assert(дайджест == cast(ббайт[])x"0cc175b9c0f1b6a831c399e269772661");

    суммаМД5 (дайджест, "abc");
    assert(дайджест == cast(ббайт[])x"900150983cd24fb0d6963f7d28e17f72");

    суммаМД5 (дайджест, "message дайджест");
    assert(дайджест == cast(ббайт[])x"f96b697d7cb7938d525a2f31aaf161d0");

    суммаМД5 (дайджест, "abcdefghijklmnopqrstuvwxyz");
    assert(дайджест == cast(ббайт[])x"c3fcd3d76192e4007dfb496cca67e13b");

    суммаМД5 (дайджест, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789");
    assert(дайджест == cast(ббайт[])x"d174ab98d277d9f5a5611c2c9f419d9f");

    суммаМД5 (дайджест,
	"1234567890123456789012345678901234567890"
	"1234567890123456789012345678901234567890");
    assert(дайджест == cast(ббайт[])x"57edf4a22be3c955ac49da2e2107b67a");

    assert(дайджестМД5вТкст(cast(ббайт[16])x"c3fcd3d76192e4007dfb496cca67e13b")
        == "C3FCD3D76192E4007DFB496CCA67E13B");
}

