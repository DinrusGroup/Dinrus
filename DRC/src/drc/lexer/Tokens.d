/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/tokens.d, _tokens.d)
 * Documentation:  https://dlang.org/phobos/dmd_tokens.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/tokens.d
 */

module drc.lexer.Tokens;

import cidrus;
import dmd.globals;
import drc.lexer.Identifier;
import util.ctfloat;
import util.outbuffer;
import util.rmem;
import util.utf;

enum ТОК2 : ббайт
{
    reserved,

    // Другое
    leftParentheses,
    rightParentheses,
    leftBracket,
    rightBracket,
    leftCurly,
    rightCurly,
    colon,
    negate,
    semicolon,
    dotDotDot,
    endOfFile,
    cast_,
    null_,
    assert_,
    true_,
    false_,
    массив,
    call,
    address,
    тип,
    throw_,
    new_,
    delete_,
    star,
    symbolOffset,
    variable,
    dotVariable,
    dotIdentifier,
    dotTemplateInstance,
    dotType,
    slice,
    arrayLength,
    version_,
    module_,
    dollar,
    template_,
    dotTemplateDeclaration,
    declaration,
    typeof_,
    pragma_,
    dSymbol,
    typeid_,
    uadd,
    удали,
    newAnonymousClass,
    коммент,
    arrayLiteral,
    assocArrayLiteral,
    structLiteral,
    classReference,
    thrownException,
    delegatePointer,
    delegateFunctionPointer,

    // Операторы
    lessThan = 54,
    greaterThan,
    lessOrEqual,
    greaterOrEqual,
    equal,
    notEqual,
    identity,
    notIdentity,
    index,
    is_,

    leftShift = 64,
    rightShift,
    leftShiftAssign,
    rightShiftAssign,
    unsignedRightShift,
    unsignedRightShiftAssign,
    concatenate,
    concatenateAssign, // ~=
    concatenateElemAssign,
    concatenateDcharAssign,
    add,
    min,
    addAssign,
    minAssign,
    mul,
    div,
    mod,
    mulAssign,
    divAssign,
    modAssign,
    and,
    or,
    xor,
    andAssign,
    orAssign,
    xorAssign,
    assign,
    not,
    tilde,
    plusPlus,
    minusMinus,
    construct,
    blit,
    dot,
    arrow,
    comma,
    question,
    andAnd,
    orOr,
    prePlusPlus,
    preMinusMinus,

    // Числовые литералы
    int32Literal = 105,
    uns32Literal,
    int64Literal,
    uns64Literal,
    int128Literal,
    uns128Literal,
    float32Literal,
    float64Literal,
    float80Literal,
    imaginary32Literal,
    imaginary64Literal,
    imaginary80Literal,

    // Символьные константы
    charLiteral = 117,
    wcharLiteral,
    dcharLiteral,

    // Leaf операторы
    идентификатор = 120,
    string_,
    hexadecimalString,
    this_,
    super_,
    halt,
    кортеж,
    error,

    // Базовые типы
    void_ = 128,
    int8,
    uns8,
    int16,
    uns16,
    int32,
    uns32,
    int64,
    uns64,
    int128,
    uns128,
    float32,
    float64,
    float80,
    imaginary32,
    imaginary64,
    imaginary80,
    complex32,
    complex64,
    complex80,
    char_,
    wchar_,
    dchar_,
    бул_,

    // Агрегаты
    struct_ = 152,
    class_,
    interface_,
    union_,
    enum_,
    import_,
    alias_,
    override_,
    delegate_,
    function_,
    mixin_,
    align_,
    extern_,
    private_,
    protected_,
    public_,
    export_,
    static_,
    final_,
    const_,
    abstract_,
    debug_,
    deprecated_,
    in_,
    out_,
    inout_,
    lazy_,
    auto_,
    package_,
    immutable_,

    // Инструкции
    if_ = 182,
    else_,
    while_,
    for_,
    do_,
    switch_,
    case_,
    default_,
    break_,
    continue_,
    with_,
    synchronized_,
    return_,
    goto_,
    try_,
    catch_,
    finally_,
    asm_,
    foreach_,
    foreach_reverse_,
    scope_,
    onScopeExit,
    onScopeFailure,
    onScopeSuccess,

    // Конкракты
    invariant_ = 206,

    // Тестирование
    unittest_,

    // Добавлено после 1.0
    argumentTypes,
    ref_,
    macro_,

    parameters = 211,
    traits,
    overloadSet,
    pure_,
    nothrow_,
    gshared,
    line,
    файл,
    fileFullPath,
    moduleString,
    functionString,
    prettyFunction,
    shared_,
    at,
    pow,
    powAssign,
    goesTo,
    vector,
    pound,

    interval = 230,
    voidВыражение,
    cantВыражение,
    showCtfeContext,

    objcClassReference,
    vectorArray,

    max_,
}
/+
// Удостовериться в том, чтобы все члены перечня сем имели последовательные значения
// и ни один из них не имел накладки

static assert(() {
    foreach (idx, enumName; __traits(allMembers, ТОК2)) {
       static if (idx != __traits(getMember, ТОК2, enumName)) {
           pragma(msg, "Ошибка: Ожидался ТОК2.", enumName, " равный ", idx, " но он равен ", __traits(getMember, ТОК2, enumName));
           static assert(0);
       }
    }
    return да;
}());

//Витас: ПОКА НЕЛЬЗЯ ИСПОЛЬЗОВАТЬ ИЗ-ЗА НАЛИЧИЯ __traits
+/

/****************************************
 */

private const ТОК2[] keywords =
[
    ТОК2.this_,
    ТОК2.super_,
    ТОК2.assert_,
    ТОК2.null_,
    ТОК2.true_,
    ТОК2.false_,
    ТОК2.cast_,
    ТОК2.new_,
    ТОК2.delete_,
    ТОК2.throw_,
    ТОК2.module_,
    ТОК2.pragma_,
    ТОК2.typeof_,
    ТОК2.typeid_,
    ТОК2.template_,
    ТОК2.void_,
    ТОК2.int8,
    ТОК2.uns8,
    ТОК2.int16,
    ТОК2.uns16,
    ТОК2.int32,
    ТОК2.uns32,
    ТОК2.int64,
    ТОК2.uns64,
    ТОК2.int128,
    ТОК2.uns128,
    ТОК2.float32,
    ТОК2.float64,
    ТОК2.float80,
    ТОК2.бул_,
    ТОК2.char_,
    ТОК2.wchar_,
    ТОК2.dchar_,
    ТОК2.imaginary32,
    ТОК2.imaginary64,
    ТОК2.imaginary80,
    ТОК2.complex32,
    ТОК2.complex64,
    ТОК2.complex80,
    ТОК2.delegate_,
    ТОК2.function_,
    ТОК2.is_,
    ТОК2.if_,
    ТОК2.else_,
    ТОК2.while_,
    ТОК2.for_,
    ТОК2.do_,
    ТОК2.switch_,
    ТОК2.case_,
    ТОК2.default_,
    ТОК2.break_,
    ТОК2.continue_,
    ТОК2.synchronized_,
    ТОК2.return_,
    ТОК2.goto_,
    ТОК2.try_,
    ТОК2.catch_,
    ТОК2.finally_,
    ТОК2.with_,
    ТОК2.asm_,
    ТОК2.foreach_,
    ТОК2.foreach_reverse_,
    ТОК2.scope_,
    ТОК2.struct_,
    ТОК2.class_,
    ТОК2.interface_,
    ТОК2.union_,
    ТОК2.enum_,
    ТОК2.import_,
    ТОК2.mixin_,
    ТОК2.static_,
    ТОК2.final_,
    ТОК2.const_,
    ТОК2.alias_,
    ТОК2.override_,
    ТОК2.abstract_,
    ТОК2.debug_,
    ТОК2.deprecated_,
    ТОК2.in_,
    ТОК2.out_,
    ТОК2.inout_,
    ТОК2.lazy_,
    ТОК2.auto_,
    ТОК2.align_,
    ТОК2.extern_,
    ТОК2.private_,
    ТОК2.package_,
    ТОК2.protected_,
    ТОК2.public_,
    ТОК2.export_,
    ТОК2.invariant_,
    ТОК2.unittest_,
    ТОК2.version_,
    ТОК2.argumentTypes,
    ТОК2.parameters,
    ТОК2.ref_,
    ТОК2.macro_,
    ТОК2.pure_,
    ТОК2.nothrow_,
    ТОК2.gshared,
    ТОК2.traits,
    ТОК2.vector,
    ТОК2.overloadSet,
    ТОК2.файл,
    ТОК2.fileFullPath,
    ТОК2.line,
    ТОК2.moduleString,
    ТОК2.functionString,
    ТОК2.prettyFunction,
    ТОК2.shared_,
    ТОК2.immutable_,
];

/***********************************************************
 */
 struct Сема2
{
    Сема2* следщ;
    Место место;
    ткст0 ptr; // pointer to first character of this token within буфер
    ТОК2 значение;
    ткст blockComment; // doc коммент ткст prior to this token
    ткст lineComment; // doc коммент for previous token

    union
    {
        // Целочисленные
        sinteger_t intvalue;
        uinteger_t unsvalue;
        // Плавающие
        real_t floatvalue;

        struct
        {
            ткст0 ustring; // UTF8 ткст
            бцел len;
            ббайт postfix; // 'c', 'w', 'd'
        }

        Идентификатор2 идент;
    }

    extern (D) private static const ткст[ТОК2.max_] tochars =
    [
        // Keywords
        ТОК2.this_: "this",
        ТОК2.super_: "super",
        ТОК2.assert_: "assert",
        ТОК2.null_: "null",
        ТОК2.true_: "true",
        ТОК2.false_: "false",
        ТОК2.cast_: "cast",
        ТОК2.new_: "new",
        ТОК2.delete_: "delete",
        ТОК2.throw_: "throw",
        ТОК2.module_: "module",
        ТОК2.pragma_: "pragma",
        ТОК2.typeof_: "typeof",
        ТОК2.typeid_: "typeid",
        ТОК2.template_: "template",
        ТОК2.void_: "void",
        ТОК2.int8: "byte",
        ТОК2.uns8: "ббайт",
        ТОК2.int16: "short",
        ТОК2.uns16: "ushort",
        ТОК2.int32: "цел",
        ТОК2.uns32: "бцел",
        ТОК2.int64: "long",
        ТОК2.uns64: "бдол",
        ТОК2.int128: "cent",
        ТОК2.uns128: "ucent",
        ТОК2.float32: "float",
        ТОК2.float64: "double",
        ТОК2.float80: "real",
        ТОК2.бул_: "бул",
        ТОК2.char_: "сим",
        ТОК2.wchar_: "wchar",
        ТОК2.dchar_: "dchar",
        ТОК2.imaginary32: "ifloat",
        ТОК2.imaginary64: "idouble",
        ТОК2.imaginary80: "ireal",
        ТОК2.complex32: "cfloat",
        ТОК2.complex64: "cdouble",
        ТОК2.complex80: "creal",
        ТОК2.delegate_: "delegate",
        ТОК2.function_: "function",
        ТОК2.is_: "is",
        ТОК2.if_: "if",
        ТОК2.else_: "else",
        ТОК2.while_: "while",
        ТОК2.for_: "for",
        ТОК2.do_: "do",
        ТОК2.switch_: "switch",
        ТОК2.case_: "case",
        ТОК2.default_: "default",
        ТОК2.break_: "break",
        ТОК2.continue_: "continue",
        ТОК2.synchronized_: "synchronized",
        ТОК2.return_: "return",
        ТОК2.goto_: "goto",
        ТОК2.try_: "try",
        ТОК2.catch_: "catch",
        ТОК2.finally_: "finally",
        ТОК2.with_: "with",
        ТОК2.asm_: "asm",
        ТОК2.foreach_: "foreach",
        ТОК2.foreach_reverse_: "foreach_reverse",
        ТОК2.scope_: "scope",
        ТОК2.struct_: "struct",
        ТОК2.class_: "class",
        ТОК2.interface_: "interface",
        ТОК2.union_: "union",
        ТОК2.enum_: "enum",
        ТОК2.import_: "import",
        ТОК2.mixin_: "mixin",
        ТОК2.static_: "static",
        ТОК2.final_: "final",
        ТОК2.const_: "const",
        ТОК2.alias_: "alias",
        ТОК2.override_: "override",
        ТОК2.abstract_: "abstract",
        ТОК2.debug_: "debug",
        ТОК2.deprecated_: "deprecated",
        ТОК2.in_: "in",
        ТОК2.out_: "out",
        ТОК2.inout_: "inout",
        ТОК2.lazy_: "lazy",
        ТОК2.auto_: "auto",
        ТОК2.align_: "align",
        ТОК2.extern_: "extern",
        ТОК2.private_: "private",
        ТОК2.package_: "package",
        ТОК2.protected_: "protected",
        ТОК2.public_: "public",
        ТОК2.export_: "export",
        ТОК2.invariant_: "invariant",
        ТОК2.unittest_: "unittest",
        ТОК2.version_: "version",
        ТОК2.argumentTypes: "__argTypes",
        ТОК2.parameters: "__parameters",
        ТОК2.ref_: "ref",
        ТОК2.macro_: "macro",
        ТОК2.pure_: "",
        ТОК2.nothrow_: "",
        ТОК2.gshared: "",
        ТОК2.traits: "__traits",
        ТОК2.vector: "__vector",
        ТОК2.overloadSet: "__overloadset",
        ТОК2.файл: "__FILE__",
        ТОК2.fileFullPath: "__FILE_FULL_PATH__",
        ТОК2.line: "__LINE__",
        ТОК2.moduleString: "__MODULE__",
        ТОК2.functionString: "__FUNCTION__",
        ТОК2.prettyFunction: "__PRETTY_FUNCTION__",
        ТОК2.shared_: "shared",
        ТОК2.immutable_: "const",

        ТОК2.endOfFile: "End of Файл",
        ТОК2.leftCurly: "{",
        ТОК2.rightCurly: "}",
        ТОК2.leftParentheses: "(",
        ТОК2.rightParentheses: ")",
        ТОК2.leftBracket: "[",
        ТОК2.rightBracket: "]",
        ТОК2.semicolon: ";",
        ТОК2.colon: ":",
        ТОК2.comma: ",",
        ТОК2.dot: ".",
        ТОК2.xor: "^",
        ТОК2.xorAssign: "^=",
        ТОК2.assign: "=",
        ТОК2.construct: "=",
        ТОК2.blit: "=",
        ТОК2.lessThan: "<",
        ТОК2.greaterThan: ">",
        ТОК2.lessOrEqual: "<=",
        ТОК2.greaterOrEqual: ">=",
        ТОК2.equal: "==",
        ТОК2.notEqual: "!=",
        ТОК2.not: "!",
        ТОК2.leftShift: "<<",
        ТОК2.rightShift: ">>",
        ТОК2.unsignedRightShift: ">>>",
        ТОК2.add: "+",
        ТОК2.min: "-",
        ТОК2.mul: "*",
        ТОК2.div: "/",
        ТОК2.mod: "%",
        ТОК2.slice: "..",
        ТОК2.dotDotDot: "...",
        ТОК2.and: "&",
        ТОК2.andAnd: "&&",
        ТОК2.or: "|",
        ТОК2.orOr: "||",
        ТОК2.массив: "[]",
        ТОК2.index: "[i]",
        ТОК2.address: "&",
        ТОК2.star: "*",
        ТОК2.tilde: "~",
        ТОК2.dollar: "$",
        ТОК2.plusPlus: "++",
        ТОК2.minusMinus: "--",
        ТОК2.prePlusPlus: "++",
        ТОК2.preMinusMinus: "--",
        ТОК2.тип: "тип",
        ТОК2.question: "?",
        ТОК2.negate: "-",
        ТОК2.uadd: "+",
        ТОК2.variable: "var",
        ТОК2.addAssign: "+=",
        ТОК2.minAssign: "-=",
        ТОК2.mulAssign: "*=",
        ТОК2.divAssign: "/=",
        ТОК2.modAssign: "%=",
        ТОК2.leftShiftAssign: "<<=",
        ТОК2.rightShiftAssign: ">>=",
        ТОК2.unsignedRightShiftAssign: ">>>=",
        ТОК2.andAssign: "&=",
        ТОК2.orAssign: "|=",
        ТОК2.concatenateAssign: "~=",
        ТОК2.concatenateElemAssign: "~=",
        ТОК2.concatenateDcharAssign: "~=",
        ТОК2.concatenate: "~",
        ТОК2.call: "call",
        ТОК2.identity: "is",
        ТОК2.notIdentity: "!is",
        ТОК2.идентификатор: "идентификатор",
        ТОК2.at: "@",
        ТОК2.pow: "^^",
        ТОК2.powAssign: "^^=",
        ТОК2.goesTo: "=>",
        ТОК2.pound: "#",

        // For debugging
        ТОК2.error: "error",
        ТОК2.dotIdentifier: "dotid",
        ТОК2.dotTemplateDeclaration: "dottd",
        ТОК2.dotTemplateInstance: "dotti",
        ТОК2.dotVariable: "dotvar",
        ТОК2.dotType: "dottype",
        ТОК2.symbolOffset: "symoff",
        ТОК2.arrayLength: "arraylength",
        ТОК2.arrayLiteral: "arrayliteral",
        ТОК2.assocArrayLiteral: "assocarrayliteral",
        ТОК2.structLiteral: "structliteral",
        ТОК2.string_: "ткст",
        ТОК2.dSymbol: "symbol",
        ТОК2.кортеж: "кортеж",
        ТОК2.declaration: "declaration",
        ТОК2.onScopeExit: "scope(exit)",
        ТОК2.onScopeSuccess: "scope(успех)",
        ТОК2.onScopeFailure: "scope(failure)",
        ТОК2.delegatePointer: "delegateptr",

        // Finish up
        ТОК2.reserved: "reserved",
        ТОК2.удали: "удали",
        ТОК2.newAnonymousClass: "newanonclass",
        ТОК2.коммент: "коммент",
        ТОК2.classReference: "classreference",
        ТОК2.thrownException: "thrownexception",
        ТОК2.delegateFunctionPointer: "delegatefuncptr",
        ТОК2.arrow: "arrow",
        ТОК2.int32Literal: "int32v",
        ТОК2.uns32Literal: "uns32v",
        ТОК2.int64Literal: "int64v",
        ТОК2.uns64Literal: "uns64v",
        ТОК2.int128Literal: "int128v",
        ТОК2.uns128Literal: "uns128v",
        ТОК2.float32Literal: "float32v",
        ТОК2.float64Literal: "float64v",
        ТОК2.float80Literal: "float80v",
        ТОК2.imaginary32Literal: "imaginary32v",
        ТОК2.imaginary64Literal: "imaginary64v",
        ТОК2.imaginary80Literal: "imaginary80v",
        ТОК2.charLiteral: "charv",
        ТОК2.wcharLiteral: "wcharv",
        ТОК2.dcharLiteral: "dcharv",

        ТОК2.halt: "halt",
        ТОК2.hexadecimalString: "xstring",

        ТОК2.interval: "interval",
        ТОК2.voidВыражение: "voidexp",
        ТОК2.cantВыражение: "cantexp",
        ТОК2.showCtfeContext : "showCtfeContext",

        ТОК2.objcClassReference: "class",
        ТОК2.vectorArray: "vectorarray",
    ];

    static assert(() {
        foreach (s; tochars)
            assert(s.length);
        return да;
    }());



    static this()
    {
        Идентификатор2.initTable();
        foreach (kw; keywords)
        {
            //printf("keyword[%d] = '%s'\n",kw, tochars[kw].ptr);
            Идентификатор2.idPool(tochars[kw].ptr, tochars[kw].length, cast(бцел)kw);
        }
    }

    цел isKeyword() 
    {
        foreach (kw; keywords)
        {
            if (kw == значение)
                return 1;
        }
        return 0;
    }

    /****
     * Set to contents of ptr[0..length]
     * Параметры:
     *  ptr = pointer to ткст
     *  length = length of ткст
     */
    проц setString(ткст0 ptr, т_мера length)
    {
        auto s = cast(сим*)mem.xmalloc_noscan(length + 1);
        memcpy(s, ptr, length);
        s[length] = 0;
        ustring = s;
        len = cast(бцел)length;
        postfix = 0;
    }

    /****
     * Set to contents of буф
     * Параметры:
     *  буф = ткст (not нуль terminated)
     */
    проц setString(ref БуфВыв буф)
    {
        setString(cast(сим*)буф[].ptr, буф.length);
    }

    /****
     * Set to empty ткст
     */
    проц setString()
    {
        ustring = "";
        len = 0;
        postfix = 0;
    }

     ткст0 вТкст0() 
    {
         сим[3 + 3 * floatvalue.sizeof + 1] буфер;
        ткст0 p = &буфер[0];
        switch (значение)
        {
        case ТОК2.int32Literal:
            sprintf(&буфер[0], "%d", cast(d_int32)intvalue);
            break;
        case ТОК2.uns32Literal:
        case ТОК2.charLiteral:
        case ТОК2.wcharLiteral:
        case ТОК2.dcharLiteral:
            sprintf(&буфер[0], "%uU", cast(d_uns32)unsvalue);
            break;
        case ТОК2.int64Literal:
            sprintf(&буфер[0], "%lldL", cast(long)intvalue);
            break;
        case ТОК2.uns64Literal:
            sprintf(&буфер[0], "%lluUL", cast(бдол)unsvalue);
            break;
        case ТОК2.float32Literal:
            CTFloat.sprint(&буфер[0], 'g', floatvalue);
            strcat(&буфер[0], "f");
            break;
        case ТОК2.float64Literal:
            CTFloat.sprint(&буфер[0], 'g', floatvalue);
            break;
        case ТОК2.float80Literal:
            CTFloat.sprint(&буфер[0], 'g', floatvalue);
            strcat(&буфер[0], "L");
            break;
        case ТОК2.imaginary32Literal:
            CTFloat.sprint(&буфер[0], 'g', floatvalue);
            strcat(&буфер[0], "fi");
            break;
        case ТОК2.imaginary64Literal:
            CTFloat.sprint(&буфер[0], 'g', floatvalue);
            strcat(&буфер[0], "i");
            break;
        case ТОК2.imaginary80Literal:
            CTFloat.sprint(&буфер[0], 'g', floatvalue);
            strcat(&буфер[0], "Li");
            break;
        case ТОК2.string_:
            {
                БуфВыв буф;
                буф.пишиБайт('"');
                for (т_мера i = 0; i < len;)
                {
                    dchar c;
                    utf_decodeChar(ustring[0 .. len], i, c);
                    switch (c)
                    {
                    case 0:
                        break;
                    case '"':
                    case '\\':
                        буф.пишиБайт('\\');
                        goto default;
                    default:
                        if (c <= 0x7F)
                        {
                            if (isprint(c))
                                буф.пишиБайт(c);
                            else
                                буф.printf("\\x%02x", c);
                        }
                        else if (c <= 0xFFFF)
                            буф.printf("\\u%04x", c);
                        else
                            буф.printf("\\U%08x", c);
                        continue;
                    }
                    break;
                }
                буф.пишиБайт('"');
                if (postfix)
                    буф.пишиБайт(postfix);
                буф.пишиБайт(0);
                p = буф.извлекиСрез().ptr;
            }
            break;
        case ТОК2.hexadecimalString:
            {
                БуфВыв буф;
                буф.пишиБайт('x');
                буф.пишиБайт('"');
                foreach (т_мера i; new бцел[0 .. len])
                {
                    if (i)
                        буф.пишиБайт(' ');
                    буф.printf("%02x", ustring[i]);
                }
                буф.пишиБайт('"');
                if (postfix)
                    буф.пишиБайт(postfix);
                буф.пишиБайт(0);
                p = буф.извлекиСрез().ptr;
                break;
            }
        case ТОК2.идентификатор:
        case ТОК2.enum_:
        case ТОК2.struct_:
        case ТОК2.import_:
        case ТОК2.wchar_:
        case ТОК2.dchar_:
        case ТОК2.бул_:
        case ТОК2.char_:
        case ТОК2.int8:
        case ТОК2.uns8:
        case ТОК2.int16:
        case ТОК2.uns16:
        case ТОК2.int32:
        case ТОК2.uns32:
        case ТОК2.int64:
        case ТОК2.uns64:
        case ТОК2.int128:
        case ТОК2.uns128:
        case ТОК2.float32:
        case ТОК2.float64:
        case ТОК2.float80:
        case ТОК2.imaginary32:
        case ТОК2.imaginary64:
        case ТОК2.imaginary80:
        case ТОК2.complex32:
        case ТОК2.complex64:
        case ТОК2.complex80:
        case ТОК2.void_:
            p = идент.вТкст0();
            break;
        default:
            p = вТкст0(значение);
            break;
        }
        return p;
    }

    static ткст0 вТкст0(ббайт значение)
    {
        return вТкст(значение).ptr;
    }

    extern (D) static ткст вТкст(ббайт значение)    
    {
        return tochars[значение];
    }
}
