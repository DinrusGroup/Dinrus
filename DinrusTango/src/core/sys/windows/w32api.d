/**
 * Windows API header module
 *
 * Translated from MinGW API for MS-Windows 4.0
 *
 * Authors: Stewart Gordon
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source: $(DRUNTIMESRC src/core/sys/windows/_w32api.d)
 */
module core.sys.windows.w32api;
version (Windows):

version (ANSI) {} else version = Unicode;

const __W32API_VERSION = 3.17;
const __W32API_MAJOR_VERSION = 3;
const __W32API_MINOR_VERSION = 17;

/*  These version identifiers are used to specify the minimum version of Windows that an
 *  application will support.
 *
 *  Previously the minimum Windows 9x and Windows NT versions could be specified.  However, since
 *  Windows 9x is no longer supported, either by Microsoft or by DMD, this distinction has been
 *  removed in order to simplify the bindings.
 */
 version (Windows10) {
    const uint _WIN32_WINNT = 0xA00;
} else version (Windows8_1) {    // also Windows2012R2
    const uint _WIN32_WINNT = 0x603;
} else version (Windows8) {      // also Windows2012
    const uint _WIN32_WINNT = 0x602;
} else version (Windows7) {      // also Windows2008R2
    const uint _WIN32_WINNT = 0x601;
} else version (WindowsVista) {  // also Windows2008
    const uint _WIN32_WINNT = 0x600;
} else version (Windows2003) {   // also WindowsHomeServer, WindowsXP64
    const uint _WIN32_WINNT = 0x502;
} else version (WindowsXP) {
    const uint _WIN32_WINNT = 0x501;
} else version (Windows2000) {
    // Current DMD doesn't support any version of Windows older than XP,
    // but third-party compilers could use this
    const uint _WIN32_WINNT = 0x500;
} else {
    const uint _WIN32_WINNT = 0x501;
}

version (IE11) {
    const uint _WIN32_IE = 0xA00;
} else version (IE10) {
    const uint _WIN32_IE = 0xA00;
} else version (IE9) {
    const uint _WIN32_IE = 0x900;
} else version (IE8) {
    const uint _WIN32_IE = 0x800;
} else version (IE7) {
    const uint _WIN32_IE = 0x700;
} else version (IE602) {
    const uint _WIN32_IE = 0x603;
} else version (IE601) {
    const uint _WIN32_IE = 0x601;
} else version (IE6) {
    const uint _WIN32_IE = 0x600;
} else version (IE56) {
    const uint _WIN32_IE = 0x560;
} else version (IE55) {
    const uint _WIN32_IE = 0x550;
} else version (IE501) {
    const uint _WIN32_IE = 0x501;
} else version (IE5) {
    const uint _WIN32_IE = 0x500;
} else version (IE401) {
    const uint _WIN32_IE = 0x401;
} else version (IE4) {
    const uint _WIN32_IE = 0x400;
} else version (IE3) {
    const uint _WIN32_IE = 0x300;
} else static if (_WIN32_WINNT >= 0x500) {
    const uint _WIN32_IE = 0x600;
} else static if (_WIN32_WINNT >= 0x410) {
    const uint _WIN32_IE = 0x400;
} else {
    const uint _WIN32_IE = 0;
}

debug (WindowsUnitTest) {
    unittest {
        printf("Windows NT version: %03x\n", _WIN32_WINNT);
        printf("IE version:         %03x\n", _WIN32_IE);
    }
}

version (Unicode) {
    const bool _WIN32_UNICODE = true;
    package template DECLARE_AW(string name) {
        mixin("alias " ~ name ~ "W " ~ name ~ ";");
    }
} else {
    const bool _WIN32_UNICODE = false;
    package template DECLARE_AW(string name) {
        mixin("alias " ~ name ~ "A " ~ name ~ ";");
    }
}
