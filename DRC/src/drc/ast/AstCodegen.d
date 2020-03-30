module drc.ast.AstCodegen;

/**
 * Documentation:  https://dlang.org/phobos/dmd_astcodegen.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/astcodegen.d
 */

    public import dmd.aggregate;
    public import dmd.aliasthis;
    public import dmd.arraytypes;
    public import dmd.attrib;
    public import dmd.cond;
    public import dmd.dclass;
    public import dmd.declaration;
    public import dmd.denum;
    public import dmd.dimport;
    public import dmd.dmodule;
    public import dmd.dstruct;
    public import dmd.дсимвол;
    public import dmd.dtemplate;
    public import dmd.dversion;
    public import drc.ast.Expression;
    public import dmd.func;
    public import dmd.hdrgen;
    public import dmd.init;
    public import dmd.initsem;
    public import dmd.mtype;
    public import dmd.nspace;
    public import dmd.инструкция;
    public import dmd.staticassert;
    public import dmd.typesem;
    public import dmd.ctfeexpr;

struct ASTCodegen
{

    alias           dmd.initsem.инициализаторВВыражение инициализаторВВыражение;
    alias           dmd.typesem.типВВыражение типВВыражение;
    alias           dmd.attrib.UserAttributeDeclaration UserAttributeDeclaration;
    alias           dmd.func.Гарант Гарант; // workaround for bug in older DMD frontends

    alias           dmd.mtype.MODFlags MODFlags;
    alias           dmd.mtype.Тип Тип;
    alias           dmd.mtype.Параметр2 Параметр2;
    alias           dmd.mtype.Taarray Taarray;
    alias           dmd.mtype.Tbool Tbool;
    alias           dmd.mtype.Tchar Tchar;
    alias           dmd.mtype.Tdchar Tdchar;
    alias           dmd.mtype.Tdelegate Tdelegate;
    alias           dmd.mtype.Tenum Tenum;
    alias           dmd.mtype.Terror Terror;
    alias           dmd.mtype.Tfloat32 Tfloat32;
    alias           dmd.mtype.Tfloat64 Tfloat64;
    alias           dmd.mtype.Tfloat80 Tfloat80;
    alias           dmd.mtype.Tfunction Tfunction;
    alias           dmd.mtype.Tident Tident;
    alias           dmd.mtype.Tint8 Tint8;
    alias           dmd.mtype.Tint16 Tint16;
    alias           dmd.mtype.Tint32 Tint32;
    alias           dmd.mtype.Tint64 Tint64;
    alias           dmd.mtype.Tsarray Tsarray;
    alias           dmd.mtype.Tstruct Tstruct;
    alias           dmd.mtype.Tuns8 Tuns8;
    alias           dmd.mtype.Tuns16 Tuns16;
    alias           dmd.mtype.Tuns32 Tuns32;
    alias           dmd.mtype.Tuns64 Tuns64;
    alias           dmd.mtype.Tvoid Tvoid;
    alias           dmd.mtype.Twchar Twchar;

    alias           dmd.mtype.СписокПараметров СписокПараметров;
    alias           dmd.mtype.ВарАрг ВарАрг;
    alias           dmd.declaration.STC STC;
    alias           dmd.дсимвол.ДСимвол ДСимвол;
    alias           dmd.дсимвол.Дсимволы Дсимволы;
    alias           dmd.дсимвол.Prot Prot;

    alias          dmd.hdrgen.stcToBuffer stcToBuffer;
    alias          dmd.hdrgen.компонажВТкст0 компонажВТкст0;
    alias          dmd.hdrgen.защитуВТкст0 защитуВТкст0;

    alias               dmd.dtemplate.тип_ли тип_ли;
    alias               dmd.dtemplate.выражение_ли выражение_ли;
    alias               dmd.dtemplate.кортеж_ли кортеж_ли;

}
