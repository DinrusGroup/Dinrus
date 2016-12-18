/*******************************************************************************

        copyright:      Copyright (c) 2010 Ulrik Mikaelsson. все rights reserved

        license:        BSD стиль: $(LICENSE)

        author:         Ulrik Mikaelsson

        standards:      rfc3548, rfc4648

*******************************************************************************/

/*******************************************************************************

    This module is использован в_ раскодируй и кодируй base32 ткст массивы.

    Example:
    ---
    ткст blah = "Hello there, my имя is Jeff.";

    scope encodebuf = new сим[вычислиРазмерКодир(cast(ббайт[])blah)];
    ткст кодирован = кодируй(cast(ббайт[])blah, encodebuf);

    scope decodebuf = new ббайт[кодирован.length];
    if (cast(ткст)раскодируй(кодирован, decodebuf) == "Hello there, my имя is Jeff.")
        Стдвыв("yay").нс;
    ---

    Since v1.0

*******************************************************************************/

module util.encode.Base32;

/*******************************************************************************

    calculates и returns the размер needed в_ кодируй the length of the
    Массив passed.

    Параметры:
    данные = An Массив that will be кодирован

*******************************************************************************/


бцел вычислиРазмерКодир(ббайт[] данные)
{
    return вычислиРазмерКодир(данные.length);
}

/*******************************************************************************

    calculates и returns the размер needed в_ кодируй the length passed.

    Параметры:
    length = Число of байты в_ be кодирован

*******************************************************************************/

бцел вычислиРазмерКодир(бцел length)
{
    auto inputbits = length * 8;
    auto inputquantas = (inputbits + 39) / 40; // Round upwards
    return inputquantas * 8;
}


/*******************************************************************************

    encodes данные и returns as an ASCII base32 ткст.

    Параметры:
    данные = что is в_ be кодирован
    buff = буфер large enough в_ hold кодирован данные
    pad  = Whether в_ pad аски вывод with '='-симвы

    Example:
    ---
    сим[512] encodebuf;
    ткст myEncodedString = кодируй(cast(ббайт[])"Hello, как are you today?", encodebuf);
    Стдвыв(myEncodedString).нс; // JBSWY3DPFQQGQ33XEBQXEZJAPFXXKIDUN5SGC6J7
    ---


*******************************************************************************/

ткст кодируй(ббайт[] данные, ткст buff, бул pad=да)
in
{
    assert(данные);
    assert(buff.length >= вычислиРазмерКодир(данные));
}
body
{
    бцел i = 0;
    бкрат remainder; // Carries перебор биты в_ следщ сим
    байт remainlen;  // Tracks биты in remainder
    foreach (ббайт j; данные)
    {
        remainder = (remainder<<8) | j;
        remainlen += 8;
        do {
            remainlen -= 5;
            buff[i++] = _encodeTable[(remainder>>remainlen)&0b11111];
        } while (remainlen > 5)
    }
    if (remainlen)
        buff[i++] = _encodeTable[(remainder<<(5-remainlen))&0b11111];
    if (pad) {
        for (ббайт padCount=(-i%8);padCount > 0; padCount--)
            buff[i++] = base32_PAD;
    }

    return buff[0..i];
}

/*******************************************************************************

    encodes данные и returns as an ASCII base32 ткст.

    Параметры:
    данные = что is в_ be кодирован
    pad = whether в_ pad вывод with '='-симвы

    Example:
    ---
    ткст myEncodedString = кодируй(cast(ббайт[])"Hello, как are you today?");
    Стдвыв(myEncodedString).нс; // JBSWY3DPFQQGQ33XEBQXEZJAPFXXKIDUN5SGC6J7
    ---


*******************************************************************************/


ткст кодируй(ббайт[] данные, бул pad=да)
in
{
    assert(данные);
}
body
{
    auto rtn = new сим[вычислиРазмерКодир(данные)];
    return кодируй(данные, rtn, pad);
}

/*******************************************************************************

    decodes an ASCII base32 ткст и returns it as ббайт[] данные. Pre-allocates
    the размер of the Массив.

    This decoder will ignore non-base32 characters. So:
    SGVsbG8sIGhvd
    yBhcmUgeW91IH
    RvZGF5Pw==

    Is действителен.

    Параметры:
    данные = что is в_ be decoded

    Example:
    ---
    ткст myDecodedString = cast(ткст)раскодируй("JBSWY3DPFQQGQ33XEBQXEZJAPFXXKIDUN5SGC6J7");
    Стдвыв(myDecodeString).нс; // Hello, как are you today?
    ---

*******************************************************************************/

ббайт[] раскодируй(ткст данные)
in
{
    assert(данные);
}
body
{
    auto rtn = new ббайт[данные.length];
    return раскодируй(данные, rtn);
}

/*******************************************************************************

    decodes an ASCII base32 ткст и returns it as ббайт[] данные.

    This decoder will ignore non-base32 characters. So:
    SGVsbG8sIGhvd
    yBhcmUgeW91IH
    RvZGF5Pw==

    Is действителен.

    Параметры:
    данные = что is в_ be decoded
    buff = a big enough Массив в_ hold the decoded данные

    Example:
    ---
    ббайт[512] decodebuf;
    ткст myDecodedString = cast(ткст)раскодируй("JBSWY3DPFQQGQ33XEBQXEZJAPFXXKIDUN5SGC6J7", decodebuf);
    Стдвыв(myDecodeString).нс; // Hello, как are you today?
    ---

*******************************************************************************/
ббайт[] раскодируй(ткст данные, ббайт[] buff)
in
{
    assert(данные);
}
body
{
    бкрат remainder;
    байт remainlen;
    т_мера oIndex;
    foreach (c; данные)
    {
        auto dec = _decodeTable[c];
        if (dec & 0b1000_0000)
            continue;
        remainder = (remainder<<5) | dec;
        for (remainlen += 5; remainlen >= 8; remainlen -= 8)
            buff[oIndex++] = remainder >> (remainlen-8);
    }

    return buff[0..oIndex];
}

debug (UnitTest)
{
    unittest
    {
        static ткст[] testBytes = [
            "",
            "foo",
            "fСПД",
            "fСПДa",
            "fСПДar",
            "Hello, как are you today?",
        ];
        static ткст[] testChars = [
            "",
            "MZXW6===",
            "MZXW6YQ=",
            "MZXW6YTB",
            "MZXW6YTBOI======",
            "JBSWY3DPFQQGQ33XEBQXEZJAPFXXKIDUN5SGC6J7",
        ];

        for (бцел i; i < testBytes.length; i++) {
            auto resultChars = кодируй(cast(ббайт[])testBytes[i]);
            assert(resultChars == testChars[i],
                    testBytes[i]~": ("~resultChars~") != ("~testChars[i]~")");

            auto resultBytes = раскодируй(testChars[i]);
            assert(resultBytes == cast(ббайт[])testBytes[i],
                    testChars[i]~": ("~cast(ткст)resultBytes~") != ("~testBytes[i]~")");
        }
    }
}



private:

/*
    Static immutable tables использован for fast lookups в_
    кодируй и раскодируй данные.
*/
static const ббайт base32_PAD = '=';
static const ткст _encodeTable = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";

static const ббайт[] _decodeTable = [
    0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF,
    0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF,
    0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF,
    0xFF,0xFF,0x1A,0x1B, 0x1C,0x1D,0x1E,0x1F, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF,
    0xFF,0x00,0x01,0x02, 0x03,0x04,0x05,0x06, 0x07,0x08,0x09,0x0A, 0x0B,0x0C,0x0D,0x0E,
    0x0F,0x10,0x11,0x12, 0x13,0x14,0x15,0x16, 0x17,0x18,0x19,0xFF, 0xFF,0xFF,0xFF,0xFF,
    0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF,
    0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF,
    0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF,
    0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF,
    0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF,
    0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF,
    0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF,
    0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF,
    0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF,
    0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF, 0xFF,0xFF,0xFF,0xFF,
];
