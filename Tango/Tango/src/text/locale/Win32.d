/*******************************************************************************

        copyright:      Copyright (c) 2005 John Chapman. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: 2005

        author:         John Chapman

******************************************************************************/

module text.locale.Win32;

version (Windows)
{
alias text.locale.Win32 nativeMethods;

extern (Windows)
private {
  бцел GetUserDefaultLCID();
  бцел GetThreadLocale();
  бул SetThreadLocale(бцел Локаль);
  цел MultiByteToWideChar(бцел КодоваяСтраница, бцел dwFlags, сим* lpMultiByteStr, цел cbMultiByte, шим* lpWопрeCharStr, цел cchWопрeChar);
  цел CompareStringW(бцел Локаль, бцел dwCmpFlags, шим* lpString1, цел cchCount1, шим* lpString2, цел cchCount2);

}

цел дайКультуруПользователя() {
  return GetUserDefaultLCID();
}

проц установиКультуруПользователя(цел lcid) {
  SetThreadLocale(lcid);
}

цел сравниСтроку(цел lcid, ткст stringA, бцел offsetA, бцел lengthA, ткст stringB, бцел offsetB, бцел lengthB, бул ignoreCase) {

  шим[] toUnicode(ткст ткст, бцел смещение, бцел length, out цел translated) {
    сим* симвы = ткст.ptr + смещение;
    цел требуется = MultiByteToWideChar(0, 0, симвы, length, пусто, 0);
    шим[] результат = new шим[требуется];
    translated = MultiByteToWideChar(0, 0, симвы, length, результат.ptr, требуется);
    return результат;
  }

  цел sortId = (lcid >> 16) & 0xF;
  sortId = (sortId == 0) ? lcid : (lcid | (sortId << 16));

  цел len1, len2;
  шим[] string1 = toUnicode(stringA, offsetA, lengthA, len1);
  шим[] string2 = toUnicode(stringB, offsetB, lengthB, len2);

  return CompareStringW(sortId, ignoreCase ? 0x1 : 0x0, string1.ptr, len1, string2.ptr, len2) - 2;
}

}
