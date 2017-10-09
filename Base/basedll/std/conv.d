
module std.conv;

import std.x.conv;
import rt.charset;

export extern(D):

///////////////////////////////////////////////////////
ткст0 вВин16н(ткст с, бцел кодСтр = 0)
{
return cast(усим) rt.charset.toMBSz(cast(char[]) с, cast(uint) кодСтр);
}
////////////////////////////////////////////////////////////
ткст изВин16н(ткст0 с, цел кодСтр = 0)
{
return cast(сим[]) rt.charset.fromMBSz(cast(char*) с, cast(int) кодСтр);



    цел вЦел(ткст т){return std.x.conv.toInt(т);}
    бцел вБцел(ткст т){return std.x.conv.toUint(т);}
    дол вДол(ткст т){return std.x.conv.toLong(т);}
    бдол вБдол(ткст т){return std.x.conv.toUlong(т);}
    крат вКрат(ткст т){return std.x.conv.toShort(т);}
    бкрат вБкрат(ткст т){return std.x.conv.toUshort(т);}
    байт вБайт(ткст т){return std.x.conv.toByte(т);}
    ббайт вБбайт(ткст т){return std.x.conv.toUbyte(т);}
    плав вПлав(ткст т){return std.x.conv.toFloat(т);}
    дво вДво(ткст т){return std.x.conv.toDouble(т);}
    реал вРеал(ткст т){return std.x.conv.toReal(т);}