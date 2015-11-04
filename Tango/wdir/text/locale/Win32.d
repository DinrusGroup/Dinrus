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
  бул SetThreadLocale(бцел Locale);
  цел MultiByteToWideChar(бцел CodePage, бцел dwFlags, сим* lpMultiByteStr, цел cbMultiByte, шим* lpWопрeCharStr, цел cchWопрeChar);
  цел CompareStringW(бцел Locale, бцел dwCmpFlags, шим* lpString1, цел cchCount1, шим* lpString2, цел cchCount2);

}

цел getUserCulture() {
  return GetUserDefaultLCID();
}

проц setUserCulture(цел lcid) {
  SetThreadLocale(lcid);
}

цел compareString(цел lcid, ткст stringA, бцел offsetA, бцел lengthA, ткст stringB, бцел offsetB, бцел lengthB, бул ignoreCase) {

  шим[] toUnicode(ткст ткст, бцел смещение, бцел length, out цел translated) {
    сим* chars = ткст.ptr + смещение;
    цел требуется = MultiByteToWideChar(0, 0, chars, length, пусто, 0);
    шим[] результат = new шим[требуется];
    translated = MultiByteToWideChar(0, 0, chars, length, результат.ptr, требуется);
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
