/**
 * Compress/decompress data using the $(LINK2 http://www._zlib.net, zlib library).
 *
 * References:
 *	$(LINK2 http://en.wikipedia.org/wiki/Zlib, Wikipedia)
 * License:
 *	Public Domain
 *
 * Macros:
 *	WIKI = Phobos/StdZlib
 */


module std.zlib;

import std.x.zlib;

бцел адлер32(бцел адлер, проц[] буф){return std.x.zlib.adler32(адлер, буф);}
бцел цпи32(бцел кс, проц[] буф){return std.x.zlib.crc32(кс, буф);}

проц[] сожмиЗлиб(проц[] истбуф, цел ур = цел.init)
    {
    if(ур) return std.x.zlib.compress(истбуф, ур);
    else return std.x.zlib.compress(истбуф);
    }

проц[] разожмиЗлиб(проц[] истбуф, бцел итдлин = 0u, цел винбиты = 15){return std.x.zlib.uncompress(истбуф, итдлин, винбиты);}



}

export extern(D) class СжатиеЗлиб
{
private std.x.zlib.Compress zc;

export:
    enum
    {
        БЕЗ_СЛИВА      = 0,
        СИНХ_СЛИВ    = 2,
        ПОЛН_СЛИВ    = 3,
        ФИНИШ       = 4,
    }

    this(цел ур){zc = new std.x.zlib.Compress(ур);}
    this(){zc = new std.x.zlib.Compress();}
    ~this(){delete zc;}
    проц[] сжать(проц[] буф){return  zc.compress(буф);}
    проц[] слей(цел режим = ФИНИШ){return  zc.flush(режим);}
}

export extern(D) class РасжатиеЗлиб
{
private std.x.zlib.UnCompress zc;

export:

    this(бцел размБуфЦели){zc = new std.x.zlib.UnCompress(размБуфЦели);}
    this(){zc = new std.x.zlib.UnCompress;}
    ~this(){delete zc;}
    проц[] расжать(проц[] буф){return  zc.uncompress(буф);}
    проц[] слей(){return  zc.flush();}
}
