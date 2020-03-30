module drc.ast.AstBase;

/**
 * Documentation:  https://dlang.org/phobos/dmd_astbase.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/astbase.d
 */

import drc.ast.ParsetimeVisitor, drc.ast.Node;
import util.file, util.filename, util.array;
import util.outbuffer, util.ctfloat, util.rmem, util.string : вТкстД;
import util.stringtable;
import drc.lexer.Tokens;    
import drc.lexer.Identifier, drc.lexer.Id, drc.lexer.Lexer2;
    
    import dmd.globals;
    import dmd.errors;    

    import cidrus;


/** Семейство ОсноваАСД  определяет семейство узлов AST, пригодных для парсинга без
  * семантической информации. Оно определяет все узлы AST, необходимые парсеру,
  * а также все методы для их обработки и переменные. Результирующее AST может
  * посещаться строгим, пермиссивным и транзитивным визитёрами.
  * Это семейство ОсноваАСД используется для создания экземпляра парсера в данной
  * библиотеке парсера.
  */
struct ОсноваАСД
{

    alias       МассивДРК!(ДСимвол) Дсимволы;
    alias       МассивДРК!(КорневойОбъект) Объекты;
    alias       МассивДРК!(Выражение) Выражения;
    alias       МассивДРК!(ПараметрШаблона2) ПараметрыШаблона;
    alias       МассивДРК!(КлассОснова2*) КлассыОсновы;
    alias       МассивДРК!(Параметр2) Параметры;
    alias       МассивДРК!(Инструкция2) Инструкции;
    alias       МассивДРК!(Уловитель) Уловители;
    alias       МассивДРК!(Идентификатор2) Идентификаторы;
    alias       МассивДРК!(Инициализатор) Инициализаторы;
    alias       МассивДРК!(Гарант) Гаранты;

    enum Sizeok : цел
    {
        none,               // size of aggregate is not yet able to compute
        fwd,                // size of aggregate is ready to compute
        done,               // size of aggregate is set correctly
    }

    enum Baseok : цел
    {
        none,               // base classes not computed yet
        start,              // in process of resolving base classes
        done,               // all base classes are resolved
        semanticdone,       // all base classes semantic done
    }

    enum MODFlags : цел
    {
        const_       = 1,    // тип is const
        immutable_   = 4,    // тип is const
        shared_      = 2,    // тип is shared
        wild         = 8,    // тип is wild
        wildconst    = (MODFlags.wild | MODFlags.const_), // тип is wild const
        mutable      = 0x10, // тип is mutable (only используется in wildcard matching)
    }

    alias ббайт MOD;

    enum STC : long
    {
        undefined_          = 0L,
        static_             = (1L << 0),
        extern_             = (1L << 1),
        const_              = (1L << 2),
        final_              = (1L << 3),
        abstract_           = (1L << 4),
        параметр           = (1L << 5),
        field               = (1L << 6),
        override_           = (1L << 7),
        auto_               = (1L << 8),
        synchronized_       = (1L << 9),
        deprecated_         = (1L << 10),
        in_                 = (1L << 11),   // in параметр
        out_                = (1L << 12),   // out параметр
        lazy_               = (1L << 13),   // lazy параметр
        foreach_            = (1L << 14),   // variable for foreach loop
                              //(1L << 15)
        variadic            = (1L << 16),   // the 'variadic' параметр in: T foo(T a, U b, V variadic...)
        ctorinit            = (1L << 17),   // can only be set inside constructor
        шаблонпараметр   = (1L << 18),   // template параметр
        scope_              = (1L << 19),
        immutable_          = (1L << 20),
        ref_                = (1L << 21),
        init                = (1L << 22),   // has explicit инициализатор
        manifest            = (1L << 23),   // manifest constant
        nodtor              = (1L << 24),   // don't run destructor
        nothrow_            = (1L << 25),   // never throws exceptions
        pure_               = (1L << 26),   //  function
        tls                 = (1L << 27),   // thread local
        alias_              = (1L << 28),   // alias параметр
        shared_             = (1L << 29),   // accessible from multiple threads
        gshared             = (1L << 30),   // accessible from multiple threads, but not typed as "shared"
        wild                = (1L << 31),   // for "wild" тип constructor
        property            = (1L << 32),
        safe                = (1L << 33),
        trusted             = (1L << 34),
        system              = (1L << 35),
        ctfe                = (1L << 36),   // can be используется in CTFE, even if it is static
        disable             = (1L << 37),   // for functions that are not callable
        результат              = (1L << 38),   // for результат variables passed to out contracts
        nodefaultctor       = (1L << 39),   // must be set inside constructor
        temp                = (1L << 40),   // temporary variable
        rvalue              = (1L << 41),   // force rvalue for variables
        nogc                = (1L << 42),   // 
        volatile_           = (1L << 43),   // destined for volatile in the back end
        return_             = (1L << 44),   // 'return ref' or 'return scope' for function parameters
        autoref             = (1L << 45),   // Mark for the already deduced 'auto ref' параметр
        inference           = (1L << 46),   // do attribute inference
        exptemp             = (1L << 47),   // temporary variable that has lifetime restricted to an Выражение
        maybescope          = (1L << 48),   // параметр might be 'scope'
        scopeinferred       = (1L << 49),   // 'scope' has been inferred and should not be part of mangling
        future              = (1L << 50),   // introducing new base class function
        local               = (1L << 51),   // do not forward (see dmd.дсимвол.ForwardingScopeDsymbol).
        returninferred      = (1L << 52),   // 'return' has been inferred and should not be part of mangling
        live                = (1L << 53),   // function @live attribute

        safeGroup = STC.safe | STC.trusted | STC.system,
        TYPECTOR = (STC.const_ | STC.immutable_ | STC.shared_ | STC.wild),
        FUNCATTR = (STC.ref_ | STC.nothrow_ | STC.nogc | STC.pure_ | STC.property | STC.live |
                    safeGroup),
    }

      КлассХранения STCStorageClass =
        (STC.auto_ | STC.scope_ | STC.static_ | STC.extern_ | STC.const_ | STC.final_ |
         STC.abstract_ | STC.synchronized_ | STC.deprecated_ | STC.override_ | STC.lazy_ |
         STC.alias_ | STC.out_ | STC.in_ | STC.manifest | STC.immutable_ | STC.shared_ |
         STC.wild | STC.nothrow_ | STC.nogc | STC.pure_ | STC.ref_ | STC.return_ | STC.tls |
         STC.gshared | STC.property | STC.live |
         STC.safeGroup | STC.disable);

    enum ENUMTY : цел
    {
        Tarray,     // slice массив, aka T[]
        Tsarray,    // static массив, aka T[dimension]
        Taarray,    // associative массив, aka T[тип]
        Tpointer,
        Treference,
        Tfunction,
        Tident,
        Tclass,
        Tstruct,
        Tenum,

        Tdelegate,
        Tnone,
        Tvoid,
        Tint8,
        Tuns8,
        Tint16,
        Tuns16,
        Tint32,
        Tuns32,
        Tint64,

        Tuns64,
        Tfloat32,
        Tfloat64,
        Tfloat80,
        Timaginary32,
        Timaginary64,
        Timaginary80,
        Tcomplex32,
        Tcomplex64,
        Tcomplex80,

        Tbool,
        Tchar,
        Twchar,
        Tdchar,
        Terror,
        Tinstance,
        Ttypeof,
        Ttuple,
        Tslice,
        Treturn,

        Tnull,
        Tvector,
        Tint128,
        Tuns128,
        Tmixin,
        TMAX
    }

    typedef  ENUMTY.Tarray Tarray;
    typedef  ENUMTY.Tsarray Tsarray;
    typedef  ENUMTY.Taarray Taarray;
    typedef  ENUMTY.Tpointer Tpointer;
    typedef  ENUMTY.Treference Treference;
    typedef  ENUMTY.Tfunction Tfunction;
    typedef  ENUMTY.Tident Tident;
    typedef  ENUMTY.Tclass Tclass;
    typedef  ENUMTY.Tstruct Tstruct;
    typedef  ENUMTY.Tenum Tenum;
    typedef  ENUMTY.Tdelegate Tdelegate;
    typedef  ENUMTY.Tnone Tnone;
    typedef  ENUMTY.Tvoid Tvoid;
    typedef  ENUMTY.Tint8 Tint8;
    typedef  ENUMTY.Tuns8 Tuns8;
    typedef  ENUMTY.Tint16 Tint16;
    typedef  ENUMTY.Tuns16 Tuns16;
    typedef  ENUMTY.Tint32 Tint32;
    typedef  ENUMTY.Tuns32 Tuns32;
    typedef  ENUMTY.Tint64 Tint64;
    typedef  ENUMTY.Tuns64 Tuns64;
    typedef  ENUMTY.Tfloat32 Tfloat32;
    typedef  ENUMTY.Tfloat64 Tfloat64;
    typedef  ENUMTY.Tfloat80 Tfloat80;
    typedef  ENUMTY.Timaginary32 Timaginary32;
    typedef  ENUMTY.Timaginary64 Timaginary64;
    typedef  ENUMTY.Timaginary80 Timaginary80;
    typedef  ENUMTY.Tcomplex32 Tcomplex32;
    typedef  ENUMTY.Tcomplex64 Tcomplex64;
    typedef  ENUMTY.Tcomplex80 Tcomplex80;
    typedef  ENUMTY.Tbool Tbool;
    typedef  ENUMTY.Tchar Tchar;
    typedef  ENUMTY.Twchar Twchar;
    typedef  ENUMTY.Tdchar Tdchar;
    typedef  ENUMTY.Terror Terror;
    typedef  ENUMTY.Tinstance Tinstance;
    typedef  ENUMTY.Ttypeof Ttypeof;
    typedef  ENUMTY.Ttuple Ttuple;
    typedef  ENUMTY.Tslice Tslice;
    typedef  ENUMTY.Treturn Treturn;
    typedef  ENUMTY.Tnull Tnull;
    typedef  ENUMTY.Tvector Tvector;
    typedef  ENUMTY.Tint128 Tint128;
    typedef  ENUMTY.Tuns128 Tuns128;
    typedef  ENUMTY.Tmixin Tmixin;
    typedef  ENUMTY.TMAX TMAX;

    alias  ббайт TY;

    enum TFlags
    {
        integral     = 1,
        floating     = 2,
        unsigned     = 4,
        real_        = 8,
        imaginary    = 0x10,
        complex      = 0x20,
        char_        = 0x40,
    }

    enum PKG : цел
    {
        unknown,     // not yet determined whether it's a package.d or not
        module_,      // already determined that's an actual package.d
        package_,     // already determined that's an actual package
    }

    enum StructPOD : цел
    {
        no,    // struct is not POD
        yes,   // struct is POD
        fwd,   // POD not yet computed
    }

    enum TRUST : цел
    {
        default_   = 0,
        system     = 1,    // @system (same as TRUST.default)
        trusted    = 2,    //
        safe       = 3,    // 
        live       = 4,    // @live
    }

    enum PURE : цел
    {
        impure      = 0,    // not  at all
        fwdref      = 1,    // it's , but not known which уровень yet
        weak        = 2,    // no mutable globals are читай or written
        const_      = 3,    // parameters are values or const
        strong      = 4,    // parameters are values or const
    }

    enum AliasThisRec : цел
    {
        no           = 0,    // no alias this recursion
        yes          = 1,    // alias this has recursive dependency
        fwdref       = 2,    // not yet known
        typeMask     = 3,    // mask to читай no/yes/fwdref
        tracing      = 0x4,  // mark in progress of implicitConvTo/deduceWild
        tracingDT    = 0x8,  // mark in progress of deduceType
    }

    enum ВарАрг
    {
        none     = 0,  /// fixed number of arguments
        variadic = 1,  /// T t, ...)  can be C-style (core.stdc.stdarg) or D-style (core.vararg)
        typesafe = 2,  /// T t ...) typesafe https://dlang.org/spec/function.html#typesafe_variadic_functions
                       ///   or https://dlang.org/spec/function.html#typesafe_variadic_functions
    }

    alias  ВизиторВремениРазбора!(ОсноваАСД) Визитор2;

     abstract class УзелАСД : КорневойОбъект
    {
        abstract проц прими(Визитор2 v);
    }

     class ДСимвол : УзелАСД
    {
        Место место;
        Идентификатор2 идент;
        UnitTestDeclaration ddocUnittest;
        UserAttributeDeclaration userAttribDecl;
        ДСимвол родитель;

        ткст0 коммент;

        final this() {}
        final this(Идентификатор2 идент)
        {
            this.идент = идент;
        }

        проц добавьКоммент(ткст0 коммент)
        {
            if (!this.коммент)
                this.коммент = коммент;
            else if (коммент && strcmp(cast(сим*)коммент, cast(сим*)this.коммент) != 0)
                this.коммент = Lexer.combineComments(this.коммент.вТкстД(), коммент.вТкстД(), да);
        }

        override ткст0 вТкст0()
        {
            return идент ? идент.вТкст0() : "__anonymous";
        }

        бул oneMember(ДСимвол *ps, Идентификатор2 идент)
        {
            *ps = this;
            return да;
        }

        extern (D) static бул oneMembers(ref Дсимволы члены, ДСимвол* ps, Идентификатор2 идент)
        {
            ДСимвол s = null;
            for (т_мера i = 0; i < члены.dim; i++)
            {
                ДСимвол sx = члены[i];
                бул x = sx.oneMember(ps, идент);
                if (!x)
                {
                    assert(*ps is null);
                    return нет;
                }
                if (*ps)
                {
                    assert(идент);
                    if (!(*ps).идент || !(*ps).идент.равен(идент))
                        continue;
                    if (!s)
                        s = *ps;
                    else if (s.перегружаем_ли() && (*ps).перегружаем_ли())
                    {
                        // keep head of overload set
                        FuncDeclaration f1 = s.isFuncDeclaration();
                        FuncDeclaration f2 = (*ps).isFuncDeclaration();
                        if (f1 && f2)
                        {
                            for (; f1 != f2; f1 = f1.overnext0)
                            {
                                if (f1.overnext0 is null)
                                {
                                    f1.overnext0 = f2;
                                    break;
                                }
                            }
                        }
                    }
                    else // more than one symbol
                    {
                        *ps = null;
                        //printf("\tfalse 2\n");
                        return нет;
                    }
                }
            }
            *ps = s;
            return да;
        }

        бул перегружаем_ли()
        {
            return нет;
        }

        ткст0 вид()
        {
            return "symbol";
        }

        final проц выведиОшибку(ткст0 format, ...)
        {
            va_list ap;
            va_start(ap, format);
            // last параметр : toPrettyChars
            verror(место, format, ap, вид(), "");
            va_end(ap);
        }

        AttribDeclaration isAttribDeclaration() 
        {
            return null;
        }

        TemplateDeclaration isTemplateDeclaration() 
        {
            return null;
        }

        FuncLiteralDeclaration isFuncLiteralDeclaration() 
        {
            return null;
        }

        FuncDeclaration isFuncDeclaration() 
        {
            return null;
        }

        VarDeclaration isVarDeclaration() 
        {
            return null;
        }

        TemplateInstance isTemplateInstance() 
        {
            return null;
        }

        Declaration isDeclaration() 
        {
            return null;
        }

        ClassDeclaration isClassDeclaration() 
        {
            return null;
        }

        AggregateDeclaration isAggregateDeclaration()
        {
            return null;
        }

        ДСимвол syntaxCopy(ДСимвол s)
        {
            return null;
        }

        override final ДИНКАСТ динкаст()
        {
            return ДИНКАСТ.дсимвол;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     class AliasThis : ДСимвол
    {
        Идентификатор2 идент;

        this(ref Место место, Идентификатор2 идент)
        {
            super(null);
            this.место = место;
            this.идент = идент;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     abstract class Declaration : ДСимвол
    {
        КлассХранения класс_хранения;
        Prot защита;
        LINK компонаж;
        Тип тип;

        final this(Идентификатор2 ид)
        {
            super(ид);
            класс_хранения = STC.undefined_;
            защита = Prot(Prot.Kind.undefined);
            компонаж = LINK.default_;
        }

        override final Declaration isDeclaration() 
        {
            return this;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     class ScopeDsymbol : ДСимвол
    {
        Дсимволы* члены;
        final this() {}
        final this(Идентификатор2 ид)
        {
            super(ид);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     class Импорт : ДСимвол
    {
        Идентификаторы* пакеты;
        Идентификатор2 ид;
        Идентификатор2 идНик;
        цел статичен_ли;
        Prot защита;

        Идентификаторы имена;
        Идентификаторы ники;

        this(ref Место место, Идентификаторы* пакеты, Идентификатор2 ид, Идентификатор2 идНик, цел статичен_ли)
        {
            super(null);
            this.место = место;
            this.пакеты = пакеты;
            this.ид = ид;
            this.идНик = идНик;
            this.статичен_ли = статичен_ли;
            this.защита = Prot(Prot.Kind.private_);

            if (идНик)
            {
                // import [cstdio] = std.stdio;
                this.идент = идНик;
            }
            else if (пакеты && пакеты.dim)
            {
                // import [std].stdio;
                this.идент = (*пакеты)[0];
            }
            else
            {
                // import [foo];
                this.идент = ид;
            }
        }
        проц добавьНик(Идентификатор2 имя, Идентификатор2 _alias)
        {
            if (статичен_ли)
                выведиОшибку("cannot have an import bind list");
            if (!идНик)
                this.идент = null;

            имена.сунь(имя);
            ники.сунь(_alias);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     abstract class AttribDeclaration : ДСимвол
    {
        Дсимволы* decl;

        final this(Дсимволы *decl)
        {
            this.decl = decl;
        }

        override final AttribDeclaration isAttribDeclaration()
        {
            return this;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class StaticAssert : ДСимвол
    {
        Выражение exp;
        Выражение msg;

        this(ref Место место, Выражение exp, Выражение msg)
        {
            super(Id.empty);
            this.место = место;
            this.exp = exp;
            this.msg = msg;
        }
    }

     final class DebugSymbol : ДСимвол
    {
        бцел уровень;

        this(ref Место место, Идентификатор2 идент)
        {
            super(идент);
            this.место = место;
        }
        this(ref Место место, бцел уровень)
        {
            this.уровень = уровень;
            this.место = место;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class VersionSymbol : ДСимвол
    {
        бцел уровень;

        this(ref Место место, Идентификатор2 идент)
        {
            super(идент);
            this.место = место;
        }
        this(ref Место место, бцел уровень)
        {
            this.уровень = уровень;
            this.место = место;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     class VarDeclaration : Declaration
    {
        Тип тип;
        Инициализатор _иниц;
        КлассХранения класс_хранения;
        const AdrOnStackNone = ~0u;
        бцел ctfeAdrOnStack;
        бцел sequenceNumber;
         бцел nextSequenceNumber;

        final this(ref Место место, Тип тип, Идентификатор2 ид, Инициализатор _иниц, КлассХранения st = STC.undefined_)
        {
            super(ид);
            this.тип = тип;
            this._иниц = _иниц;
            this.место = место;
            this.класс_хранения = st;
            sequenceNumber = ++nextSequenceNumber;
            ctfeAdrOnStack = AdrOnStackNone;
        }

        override final VarDeclaration isVarDeclaration() 
        {
            return this;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     struct Гарант
    {
        Идентификатор2 ид;
        Инструкция2 ensure;
    }

     class FuncDeclaration : Declaration
    {
        Инструкция2 fbody;
        Инструкции* frequires;
        Гаранты* fensures;
        Место endloc;
        КлассХранения класс_хранения;
        Тип тип;
        бул inferRetType;
        ForeachStatement fes;
        FuncDeclaration overnext0;

        final this(ref Место место, Место endloc, Идентификатор2 ид, КлассХранения класс_хранения, Тип тип)
        {
            super(ид);
            this.класс_хранения = класс_хранения;
            this.тип = тип;
            if (тип)
            {
                // Normalize класс_хранения, because function-тип related attributes
                // are already set in the 'тип' in parsing phase.
                this.класс_хранения &= ~(STC.TYPECTOR | STC.FUNCATTR);
            }
            this.место = место;
            this.endloc = endloc;
            inferRetType = (тип && тип.nextOf() is null);
        }

        FuncLiteralDeclaration isFuncLiteralDeclaration()
        {
            return null;
        }

        override бул перегружаем_ли() 
        {
            return да;
        }

        override final FuncDeclaration isFuncDeclaration() 
        {
            return this;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class AliasDeclaration : Declaration
    {
        ДСимвол aliassym;

        this(ref Место место, Идентификатор2 ид, ДСимвол s)
        {
            super(ид);
            this.место = место;
            this.aliassym = s;
        }

        this(ref Место место, Идентификатор2 ид, Тип тип)
        {
            super(ид);
            this.место = место;
            this.тип = тип;
        }

        override бул перегружаем_ли()
        {
            //assume overloadable until alias is resolved;
            // should be modified when semantic analysis is added
            return да;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class TupleDeclaration : Declaration
    {
        Объекты* objects;

        this(ref Место место, Идентификатор2 ид, Объекты* objects)
        {
            super(ид);
            this.место = место;
            this.objects = objects;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class FuncLiteralDeclaration : FuncDeclaration
    {
        ТОК2 tok;

        this(ref Место место, Место endloc, Тип тип, ТОК2 tok, ForeachStatement fes, Идентификатор2 ид = null)
        {
            super(место, endloc, null, STC.undefined_, тип);
            this.идент = ид ? ид : Id.empty;
            this.tok = tok;
            this.fes = fes;
        }

        override FuncLiteralDeclaration isFuncLiteralDeclaration() 
        {
            return this;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class PostBlitDeclaration : FuncDeclaration
    {
        this(ref Место место, Место endloc, КлассХранения stc, Идентификатор2 ид)
        {
            super(место, endloc, ид, stc, null);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class CtorDeclaration : FuncDeclaration
    {
        this(ref Место место, Место endloc, КлассХранения stc, Тип тип, бул isCopyCtor = нет)
        {
            super(место, endloc, Id.ctor, stc, тип);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class DtorDeclaration : FuncDeclaration
    {
        this(ref Место место, Место endloc)
        {
            super(место, endloc, Id.dtor, STC.undefined_, null);
        }
        this(ref Место место, Место endloc, КлассХранения stc, Идентификатор2 ид)
        {
            super(место, endloc, ид, stc, null);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class InvariantDeclaration : FuncDeclaration
    {
        this(ref Место место, Место endloc, КлассХранения stc, Идентификатор2 ид, Инструкция2 fbody)
        {
            super(место, endloc, ид ? ид : Идентификатор2.генерируйИд("__invariant"), stc, null);
            this.fbody = fbody;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class UnitTestDeclaration : FuncDeclaration
    {
        ткст0 codedoc;

        this(ref Место место, Место endloc, КлассХранения stc, ткст0 codedoc)
        {
            super(место, endloc, Идентификатор2.generateIdWithLoc("__unittest", место), stc, null);
            this.codedoc = codedoc;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class NewDeclaration : FuncDeclaration
    {
        Параметры* parameters;
        ВарАрг varargs;

        this(ref Место место, Место endloc, КлассХранения stc, Параметры* fparams, ВарАрг varargs)
        {
            super(место, endloc, Id.classNew, STC.static_ | stc, null);
            this.parameters = fparams;
            this.varargs = varargs;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     class StaticCtorDeclaration : FuncDeclaration
    {
        final this(ref Место место, Место endloc, КлассХранения stc)
        {
            super(место, endloc, Идентификатор2.generateIdWithLoc("_staticCtor", место), STC.static_ | stc, null);
        }
        final this(ref Место место, Место endloc, ткст имя, КлассХранения stc)
        {
            super(место, endloc, Идентификатор2.generateIdWithLoc(имя, место), STC.static_ | stc, null);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     class StaticDtorDeclaration : FuncDeclaration
    {
        final this(Место место, Место endloc, КлассХранения stc)
        {
            super(место, endloc, Идентификатор2.generateIdWithLoc("__staticDtor", место), STC.static_ | stc, null);
        }
        final this(ref Место место, Место endloc, ткст имя, КлассХранения stc)
        {
            super(место, endloc, Идентификатор2.generateIdWithLoc(имя, место), STC.static_ | stc, null);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class SharedStaticCtorDeclaration : StaticCtorDeclaration
    {
        this(ref Место место, Место endloc, КлассХранения stc)
        {
            super(место, endloc, "_sharedStaticCtor", stc);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class SharedStaticDtorDeclaration : StaticDtorDeclaration
    {
        this(ref Место место, Место endloc, КлассХранения stc)
        {
            super(место, endloc, "_sharedStaticDtor", stc);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     class Package : ScopeDsymbol
    {
        PKG isPkgMod;
        бцел tag;

        final this(Идентификатор2 идент)
        {
            super(идент);
            this.isPkgMod = PKG.unknown;
             бцел packageTag;
            this.tag = packageTag++;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class EnumDeclaration : ScopeDsymbol
    {
        Тип тип;
        Тип memtype;
        Prot защита;

        this(ref Место место, Идентификатор2 ид, Тип memtype)
        {
            super(ид);
            this.место = место;
            тип = new TypeEnum(this);
            this.memtype = memtype;
            защита = Prot(Prot.Kind.undefined);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     abstract class AggregateDeclaration : ScopeDsymbol
    {
        Prot защита;
        Sizeok sizeok;
        Тип тип;

        final this(ref Место место, Идентификатор2 ид)
        {
            super(ид);
            this.место = место;
            защита = Prot(Prot.Kind.public_);
            sizeok = Sizeok.none;
        }

        override final AggregateDeclaration isAggregateDeclaration()
        {
            return this;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class TemplateDeclaration : ScopeDsymbol
    {
        ПараметрыШаблона* parameters;
        ПараметрыШаблона* origParameters;
        Выражение constraint;
        бул literal;
        бул ismixin;
        бул статичен_ли;
        Prot защита;
        ДСимвол onemember;

        this(ref Место место, Идентификатор2 ид, ПараметрыШаблона* parameters, Выражение constraint, Дсимволы* decldefs, бул ismixin = нет, бул literal = нет)
        {
            super(ид);
            this.место = место;
            this.parameters = parameters;
            this.origParameters = parameters;
            this.члены = decldefs;
            this.literal = literal;
            this.ismixin = ismixin;
            this.статичен_ли = да;
            this.защита = Prot(Prot.Kind.undefined);

            if (члены && идент)
            {
                ДСимвол s;
                if (ДСимвол.oneMembers(*члены, &s, идент) && s)
                {
                    onemember = s;
                    s.родитель = this;
                }
            }
        }

        override бул перегружаем_ли() 
        {
            return да;
        }

        override TemplateDeclaration isTemplateDeclaration () 
        {
            return this;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     class TemplateInstance : ScopeDsymbol
    {
        Идентификатор2 имя;
        Объекты* tiargs;
        ДСимвол tempdecl;
        бул semantictiargsdone;
        бул havetempdecl;
        TemplateInstance inst;

        final this(ref Место место, Идентификатор2 идент, Объекты* tiargs)
        {
            super(null);
            this.место = место;
            this.имя = идент;
            this.tiargs = tiargs;
        }

        final this(ref Место место, TemplateDeclaration td, Объекты* tiargs)
        {
            super(null);
            this.место = место;
            this.имя = td.идент;
            this.tempdecl = td;
            this.semantictiargsdone = да;
            this.havetempdecl = да;
        }

        override final TemplateInstance isTemplateInstance() 
        {
            return this;
        }

        Объекты* arraySyntaxCopy(Объекты* objs)
        {
            Объекты* a = null;
            if (objs)
            {
                a = new Объекты();
                a.устДим(objs.dim);
                for (т_мера i = 0; i < objs.dim; i++)
                    (*a)[i] = objectSyntaxCopy((*objs)[i]);
            }
            return a;
        }

        КорневойОбъект objectSyntaxCopy(КорневойОбъект o)
        {
            if (!o)
                return null;
            if (Тип t = тип_ли(o))
                return t.syntaxCopy();
            if (Выражение e = выражение_ли(o))
                return e.syntaxCopy();
            return o;
        }

        override ДСимвол syntaxCopy(ДСимвол s)
        {
            TemplateInstance ti = s ? cast(TemplateInstance)s : new TemplateInstance(место, имя, null);
            ti.tiargs = arraySyntaxCopy(tiargs);
            TemplateDeclaration td;
            if (inst && tempdecl && (td = tempdecl.isTemplateDeclaration()) !is null)
                td.ScopeDsymbol.syntaxCopy(ti);
            else
                ScopeDsymbol.syntaxCopy(ti);
            return ti;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class Nspace : ScopeDsymbol
    {
        /**
         * Namespace идентификатор resolved during semantic.
         */
        Выражение identExp;

        this(ref Место место, Идентификатор2 идент, Выражение identExp, Дсимволы* члены)
        {
            super(идент);
            this.место = место;
            this.члены = члены;
            this.identExp = identExp;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class CompileDeclaration : AttribDeclaration
    {
        Выражения* exps;

        this(ref Место место, Выражения* exps)
        {
            super(null);
            this.место = место;
            this.exps = exps;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class UserAttributeDeclaration : AttribDeclaration
    {
        Выражения* atts;

        this(Выражения* atts, Дсимволы* decl)
        {
            super(decl);
            this.atts = atts;
        }

        static Выражения* concat(Выражения* udas1, Выражения* udas2)
        {
            Выражения* udas;
            if (!udas1 || udas1.dim == 0)
                udas = udas2;
            else if (!udas2 || udas2.dim == 0)
                udas = udas1;
            else
            {
                udas = new Выражения(2);
                (*udas)[0] = new TupleExp(Место.initial, udas1);
                (*udas)[1] = new TupleExp(Место.initial, udas2);
            }
            return udas;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class LinkDeclaration : AttribDeclaration
    {
        LINK компонаж;

        this(LINK p, Дсимволы* decl)
        {
            super(decl);
            компонаж = p;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class AnonDeclaration : AttribDeclaration
    {
        бул isunion;

        this(ref Место место, бул isunion, Дсимволы* decl)
        {
            super(decl);
            this.место = место;
            this.isunion = isunion;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class AlignDeclaration : AttribDeclaration
    {
        Выражение ealign;

        this(ref Место место, Выражение ealign, Дсимволы* decl)
        {
            super(decl);
            this.место = место;
            this.ealign = ealign;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class CPPMangleDeclaration : AttribDeclaration
    {
        CPPMANGLE cppmangle;

        this(CPPMANGLE p, Дсимволы* decl)
        {
            super(decl);
            cppmangle = p;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class CPPNamespaceDeclaration : AttribDeclaration
    {
        Выражение exp;

        this(Идентификатор2 идент, Дсимволы* decl)
        {
            super(decl);
            this.идент = идент;
        }

        this(Выражение exp, Дсимволы* decl)
        {
            super(decl);
            this.exp = exp;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class ProtDeclaration : AttribDeclaration
    {
        Prot защита;
        Идентификаторы* pkg_identifiers;

        this(ref Место место, Prot p, Дсимволы* decl)
        {
            super(decl);
            this.место = место;
            this.защита = p;
        }
        this(ref Место место, Идентификаторы* pkg_identifiers, Дсимволы* decl)
        {
            super(decl);
            this.место = место;
            this.защита.вид = Prot.Kind.package_;
            this.защита.pkg = null;
            this.pkg_identifiers = pkg_identifiers;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class PragmaDeclaration : AttribDeclaration
    {
        Выражения* args;

        this(ref Место место, Идентификатор2 идент, Выражения* args, Дсимволы* decl)
        {
            super(decl);
            this.место = место;
            this.идент = идент;
            this.args = args;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     class StorageClassDeclaration : AttribDeclaration
    {
        КлассХранения stc;

        final this(КлассХранения stc, Дсимволы* decl)
        {
            super(decl);
            this.stc = stc;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     class ConditionalDeclaration : AttribDeclaration
    {
        Condition условие;
        Дсимволы* elsedecl;

        final this(Condition условие, Дсимволы* decl, Дсимволы* elsedecl)
        {
            super(decl);
            this.условие = условие;
            this.elsedecl = elsedecl;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class DeprecatedDeclaration : StorageClassDeclaration
    {
        Выражение msg;

        this(Выражение msg, Дсимволы* decl)
        {
            super(STC.deprecated_, decl);
            this.msg = msg;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class StaticIfDeclaration : ConditionalDeclaration
    {
        this(Condition условие, Дсимволы* decl, Дсимволы* elsedecl)
        {
            super(условие, decl, elsedecl);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class StaticForeachDeclaration : AttribDeclaration
    {
        StaticForeach sfe;

        this(StaticForeach sfe, Дсимволы* decl)
        {
            super(decl);
            this.sfe = sfe;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class EnumMember : VarDeclaration
    {
        Выражение origValue;
        Тип origType;

         T значение() { return (cast(ExpInitializer)_иниц).exp; }

        this(ref Место место, Идентификатор2 ид, Выражение значение, Тип origType)
        {
            super(место, null, ид ? ид : Id.empty, new ExpInitializer(место, значение));
            this.origValue = значение;
            this.origType = origType;
        }

        this(ref Место место, Идентификатор2 ид, Выражение значение, Тип memtype,
            КлассХранения stc, UserAttributeDeclaration uad, DeprecatedDeclaration dd)
        {
            this(место, ид, значение, memtype);
            класс_хранения = stc;
            userAttribDecl = uad;
            // just ignore `dd`
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class Module : Package
    {
          AggregateDeclaration moduleinfo;

        const ИмяФайла srcfile;
        ткст0 arg;

        this(ткст0 имяф, Идентификатор2 идент, цел doDocComment, цел doHdrGen)
        {
            super(идент);
            this.arg = имяф;
            srcfile = ИмяФайла(ИмяФайла.defaultExt(имяф.вТкстД, глоб2.mars_ext));
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     class StructDeclaration : AggregateDeclaration
    {
        цел zeroInit;
        StructPOD ispod;

        final this(ref Место место, Идентификатор2 ид, бул inObject)
        {
            super(место, ид);
            zeroInit = 0;
            ispod = StructPOD.fwd;
            тип = new TypeStruct(this);
            if (inObject)
            {
                if (ид == Id.ModuleInfo && !Module.moduleinfo)
                    Module.moduleinfo = this;
            }
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class UnionDeclaration : StructDeclaration
    {
        this(ref Место место, Идентификатор2 ид)
        {
            super(место, ид, нет);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     class ClassDeclaration : AggregateDeclaration
    {
                  // Names found by reading объект.d in druntime
            ClassDeclaration объект;
            ClassDeclaration throwable;
            ClassDeclaration exception;
            ClassDeclaration errorException;
            ClassDeclaration cpp_type_info_ptr;   // Object.__cpp_type_info_ptr
        

        КлассыОсновы* baseclasses;
        Baseok baseok;

        final this(ref Место место, Идентификатор2 ид, КлассыОсновы* baseclasses, Дсимволы* члены, бул inObject)
        {
            if(!ид)
                ид = Идентификатор2.генерируйИд("__anonclass");
            assert(ид);

            super(место, ид);

             ткст0 msg = "only объект.d can define this reserved class имя";

            if (baseclasses)
            {
                // Actually, this is a transfer
                this.baseclasses = baseclasses;
            }
            else
                this.baseclasses = new КлассыОсновы();

            this.члены = члены;

            //printf("ClassDeclaration(%s), dim = %d\n", ид.вТкст0(), this.baseclasses.dim);

            // For forward references
            тип = new TypeClass(this);

            if (ид)
            {
                // Look for special class имена
                if (ид == Id.__sizeof || ид == Id.__xalignof || ид == Id._mangleof)
                    выведиОшибку("illegal class имя");

                // BUG: What if this is the wrong TypeInfo, i.e. it is nested?
                if (ид.вТкст0()[0] == 'T')
                {
                    if (ид == Id.TypeInfo)
                    {
                        if (!inObject)
                            выведиОшибку("%s", msg);
                        Тип.dtypeinfo = this;
                    }
                    if (ид == Id.TypeInfo_Class)
                    {
                        if (!inObject)
                            выведиОшибку("%s", msg);
                        Тип.typeinfoclass = this;
                    }
                    if (ид == Id.TypeInfo_Interface)
                    {
                        if (!inObject)
                            выведиОшибку("%s", msg);
                        Тип.typeinfointerface = this;
                    }
                    if (ид == Id.TypeInfo_Struct)
                    {
                        if (!inObject)
                            выведиОшибку("%s", msg);
                        Тип.typeinfostruct = this;
                    }
                    if (ид == Id.TypeInfo_Pointer)
                    {
                        if (!inObject)
                            выведиОшибку("%s", msg);
                        Тип.typeinfopointer = this;
                    }
                    if (ид == Id.TypeInfo_Массив)
                    {
                        if (!inObject)
                            выведиОшибку("%s", msg);
                        Тип.typeinfoarray = this;
                    }
                    if (ид == Id.TypeInfo_StaticArray)
                    {
                        //if (!inObject)
                        //    Тип.typeinfostaticarray.выведиОшибку("%s", msg);
                        Тип.typeinfostaticarray = this;
                    }
                    if (ид == Id.TypeInfo_AssociativeArray)
                    {
                        if (!inObject)
                            выведиОшибку("%s", msg);
                        Тип.typeinfoassociativearray = this;
                    }
                    if (ид == Id.TypeInfo_Enum)
                    {
                        if (!inObject)
                            выведиОшибку("%s", msg);
                        Тип.typeinfoenum = this;
                    }
                    if (ид == Id.TypeInfo_Function)
                    {
                        if (!inObject)
                            выведиОшибку("%s", msg);
                        Тип.typeinfofunction = this;
                    }
                    if (ид == Id.TypeInfo_Delegate)
                    {
                        if (!inObject)
                            выведиОшибку("%s", msg);
                        Тип.typeinfodelegate = this;
                    }
                    if (ид == Id.TypeInfo_Tuple)
                    {
                        if (!inObject)
                            выведиОшибку("%s", msg);
                        Тип.typeinfotypelist = this;
                    }
                    if (ид == Id.TypeInfo_Const)
                    {
                        if (!inObject)
                            выведиОшибку("%s", msg);
                        Тип.typeinfoconst = this;
                    }
                    if (ид == Id.TypeInfo_Invariant)
                    {
                        if (!inObject)
                            выведиОшибку("%s", msg);
                        Тип.typeinfoinvariant = this;
                    }
                    if (ид == Id.TypeInfo_Shared)
                    {
                        if (!inObject)
                            выведиОшибку("%s", msg);
                        Тип.typeinfoshared = this;
                    }
                    if (ид == Id.TypeInfo_Wild)
                    {
                        if (!inObject)
                            выведиОшибку("%s", msg);
                        Тип.typeinfowild = this;
                    }
                    if (ид == Id.TypeInfo_Vector)
                    {
                        if (!inObject)
                            выведиОшибку("%s", msg);
                        Тип.typeinfovector = this;
                    }
                }

                if (ид == Id.Object)
                {
                    if (!inObject)
                        выведиОшибку("%s", msg);
                    объект = this;
                }

                if (ид == Id.Throwable)
                {
                    if (!inObject)
                        выведиОшибку("%s", msg);
                    throwable = this;
                }
                if (ид == Id.Exception)
                {
                    if (!inObject)
                        выведиОшибку("%s", msg);
                    exception = this;
                }
                if (ид == Id.Error)
                {
                    if (!inObject)
                        выведиОшибку("%s", msg);
                    errorException = this;
                }
                if (ид == Id.cpp_type_info_ptr)
                {
                    if (!inObject)
                        выведиОшибку("%s", msg);
                    cpp_type_info_ptr = this;
                }
            }
            baseok = Baseok.none;
        }

        override final ClassDeclaration isClassDeclaration() 
        {
            return this;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     class InterfaceDeclaration : ClassDeclaration
    {
        final  this(ref Место место, Идентификатор2 ид, КлассыОсновы* baseclasses)
        {
            super(место, ид, baseclasses, null, нет);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     class TemplateMixin : TemplateInstance
    {
        TypeQualified tqual;

        this(ref Место место, Идентификатор2 идент, TypeQualified tqual, Объекты *tiargs)
        {
            super(место,
                  tqual.idents.dim ? cast(Идентификатор2)tqual.idents[tqual.idents.dim - 1] : (cast(TypeIdentifier)tqual).идент,
                  tiargs ? tiargs : new Объекты());
            this.идент = идент;
            this.tqual = tqual;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     struct СписокПараметров
    {
        Параметры* parameters;
        ВарАрг varargs = ВарАрг.none;
    }

     final class Параметр2 : УзелАСД
    {
        КлассХранения классХранения;
        Тип тип;
        Идентификатор2 идент;
        Выражение defaultArg;
        UserAttributeDeclaration userAttribDecl; // user defined attributes

        alias цел delegate(т_мера idx, Параметр2 param) ForeachDg;

        final this(КлассХранения классХранения, Тип тип, Идентификатор2 идент, Выражение defaultArg, UserAttributeDeclaration userAttribDecl)
        {
            this.классХранения = классХранения;
            this.тип = тип;
            this.идент = идент;
            this.defaultArg = defaultArg;
            this.userAttribDecl = userAttribDecl;
        }

        static т_мера dim(Параметры* parameters)
        {
           т_мера nargs = 0;

            цел dimDg(т_мера n, Параметр2 p)
            {
                ++nargs;
                return 0;
            }

            _foreach(parameters, &dimDg);
            return nargs;
        }

        static Параметр2 getNth(Параметры* parameters, т_мера nth, т_мера* pn = null)
        {
            Параметр2 param;

            цел getNthParamDg(т_мера n, Параметр2 p)
            {
                if (n == nth)
                {
                    param = p;
                    return 1;
                }
                return 0;
            }

            цел res = _foreach(parameters, &getNthParamDg);
            return res ? param : null;
        }

        static цел _foreach(Параметры* parameters, ForeachDg dg, т_мера* pn = null)
        {
            assert(dg);
            if (!parameters)
                return 0;

            т_мера n = pn ? *pn : 0; // take over index
            цел результат = 0;
            foreach (i; new бцел[0 .. parameters.dim])
            {
                Параметр2 p = (*parameters)[i];
                Тип t = p.тип.toBasetype();

                if (t.ty == Ttuple)
                {
                    КортежТипов tu = cast(КортежТипов)t;
                    результат = _foreach(tu.arguments, dg, &n);
                }
                else
                    результат = dg(n++, p);

                if (результат)
                    break;
            }

            if (pn)
                *pn = n; // update index
            return результат;
        }

        Параметр2 syntaxCopy()
        {
            return new Параметр2(классХранения, тип ? тип.syntaxCopy() : null, идент, defaultArg ? defaultArg.syntaxCopy() : null, userAttribDecl ? cast(UserAttributeDeclaration) userAttribDecl.syntaxCopy(null) : null);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }

        static Параметры* arraySyntaxCopy(Параметры* parameters)
        {
            Параметры* парамы = null;
            if (parameters)
            {
                парамы = new Параметры();
                парамы.устДим(parameters.dim);
                for (т_мера i = 0; i < парамы.dim; i++)
                    (*парамы)[i] = (*parameters)[i].syntaxCopy();
            }
            return парамы;
        }

    }

    enum STMT : ббайт
    {
        Error,
        Peel,
        Exp, DtorExp,
        Compile,
        Compound, CompoundDeclaration, CompoundAsm,
        UnrolledLoop,
        Scope,
        Forwarding,
        While,
        Do,
        For,
        Foreach,
        ForeachRange,
        If,
        Conditional,
        StaticForeach,
        Pragma,
        StaticAssert,
        Switch,
        Case,
        CaseRange,
        Default,
        GotoDefault,
        GotoCase,
        SwitchError,
        Return,
        Break,
        Continue,
        Synchronized,
        With,
        TryCatch,
        TryFinally,
        ScopeGuard,
        Throw,
        Debug,
        Goto,
        Label,
        Asm, InlineAsm, GccAsm,
        Импорт,
    }

     abstract class Инструкция2 : УзелАСД
    {
        Место место;
        STMT stmt;

        final this(ref Место место, STMT stmt)
        {
            this.место = место;
            this.stmt = stmt;
        }

         
     //   ExpStatement isExpStatement() { return stmt == STMT.Exp ? cast(typeof(return))this : null; }

     
    //    CompoundStatement isCompoundStatement(){ return stmt == STMT.Compound ? cast(typeof(return))this : null; }

          
     //   ReturnStatement isReturnStatement(){ return stmt == STMT.Return ? cast(typeof(return))this : null; }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class ImportStatement : Инструкция2
    {
        Дсимволы* imports;

        this(ref Место место, Дсимволы* imports)
        {
            super(место, STMT.Импорт);
            this.imports = imports;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class ScopeStatement : Инструкция2
    {
        Инструкция2 инструкция;
        Место endloc;

        this(ref Место место, Инструкция2 s, Место endloc)
        {
            super(место, STMT.Scope);
            this.инструкция = s;
            this.endloc = endloc;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class ReturnStatement : Инструкция2
    {
        Выражение exp;

        this(ref Место место, Выражение exp)
        {
            super(место, STMT.Return);
            this.exp = exp;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class LabelStatement : Инструкция2
    {
        Идентификатор2 идент;
        Инструкция2 инструкция;

        final this(ref Место место, Идентификатор2 идент, Инструкция2 инструкция)
        {
            super(место, STMT.Label);
            this.идент = идент;
            this.инструкция = инструкция;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class StaticAssertStatement : Инструкция2
    {
        StaticAssert sa;

        final this(StaticAssert sa)
        {
            super(sa.место, STMT.StaticAssert);
            this.sa = sa;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class CompileStatement : Инструкция2
    {
        Выражения* exps;

        final this(ref Место место, Выражения* exps)
        {
            super(место, STMT.Compile);
            this.exps = exps;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class WhileStatement : Инструкция2
    {
        Выражение условие;
        Инструкция2 _body;
        Место endloc;

        this(ref Место место, Выражение c, Инструкция2 b, Место endloc)
        {
            super(место, STMT.While);
            условие = c;
            _body = b;
            this.endloc = endloc;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class ForStatement : Инструкция2
    {
        Инструкция2 _иниц;
        Выражение условие;
        Выражение increment;
        Инструкция2 _body;
        Место endloc;

        this(ref Место место, Инструкция2 _иниц, Выражение условие, Выражение increment, Инструкция2 _body, Место endloc)
        {
            super(место, STMT.For);
            this._иниц = _иниц;
            this.условие = условие;
            this.increment = increment;
            this._body = _body;
            this.endloc = endloc;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class DoStatement : Инструкция2
    {
        Инструкция2 _body;
        Выражение условие;
        Место endloc;

        this(ref Место место, Инструкция2 b, Выражение c, Место endloc)
        {
            super(место, STMT.Do);
            _body = b;
            условие = c;
            this.endloc = endloc;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class ForeachRangeStatement : Инструкция2
    {
        ТОК2 op;                 // ТОК2.foreach_ or ТОК2.foreach_reverse_
        Параметр2 prm;          // loop index variable
        Выражение lwr;
        Выражение upr;
        Инструкция2 _body;
        Место endloc;             // location of closing curly bracket


        this(ref Место место, ТОК2 op, Параметр2 prm, Выражение lwr, Выражение upr, Инструкция2 _body, Место endloc)
        {
            super(место, STMT.ForeachRange);
            this.op = op;
            this.prm = prm;
            this.lwr = lwr;
            this.upr = upr;
            this._body = _body;
            this.endloc = endloc;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class ForeachStatement : Инструкция2
    {
        ТОК2 op;                     // ТОК2.foreach_ or ТОК2.foreach_reverse_
        Параметры* parameters;     // массив of Параметр2*'s
        Выражение aggr;
        Инструкция2 _body;
        Место endloc;                 // location of closing curly bracket

        this(ref Место место, ТОК2 op, Параметры* parameters, Выражение aggr, Инструкция2 _body, Место endloc)
        {
            super(место, STMT.Foreach);
            this.op = op;
            this.parameters = parameters;
            this.aggr = aggr;
            this._body = _body;
            this.endloc = endloc;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class IfStatement : Инструкция2
    {
        Параметр2 prm;
        Выражение условие;
        Инструкция2 ifbody;
        Инструкция2 elsebody;
        VarDeclaration match;   // for MatchВыражение результатs
        Место endloc;                 // location of closing curly bracket

        this(ref Место место, Параметр2 prm, Выражение условие, Инструкция2 ifbody, Инструкция2 elsebody, Место endloc)
        {
            super(место, STMT.If);
            this.prm = prm;
            this.условие = условие;
            this.ifbody = ifbody;
            this.elsebody = elsebody;
            this.endloc = endloc;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class ScopeGuardStatement : Инструкция2
    {
        ТОК2 tok;
        Инструкция2 инструкция;

        this(ref Место место, ТОК2 tok, Инструкция2 инструкция)
        {
            super(место, STMT.ScopeGuard);
            this.tok = tok;
            this.инструкция = инструкция;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class ConditionalStatement : Инструкция2
    {
        Condition условие;
        Инструкция2 ifbody;
        Инструкция2 elsebody;

        this(ref Место место, Condition условие, Инструкция2 ifbody, Инструкция2 elsebody)
        {
            super(место, STMT.Conditional);
            this.условие = условие;
            this.ifbody = ifbody;
            this.elsebody = elsebody;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class StaticForeachStatement : Инструкция2
    {
        StaticForeach sfe;

        this(ref Место место, StaticForeach sfe)
        {
            super(место, STMT.StaticForeach);
            this.sfe = sfe;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class PragmaStatement : Инструкция2
    {
        Идентификатор2 идент;
        Выражения* args;      // массив of Выражение's
        Инструкция2 _body;

        this(ref Место место, Идентификатор2 идент, Выражения* args, Инструкция2 _body)
        {
            super(место, STMT.Pragma);
            this.идент = идент;
            this.args = args;
            this._body = _body;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class SwitchStatement : Инструкция2
    {
        Выражение условие;
        Инструкция2 _body;
        бул isFinal;

        this(ref Место место, Выражение c, Инструкция2 b, бул isFinal)
        {
            super(место, STMT.Switch);
            this.условие = c;
            this._body = b;
            this.isFinal = isFinal;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class CaseRangeStatement : Инструкция2
    {
        Выражение first;
        Выражение last;
        Инструкция2 инструкция;

        this(ref Место место, Выражение first, Выражение last, Инструкция2 s)
        {
            super(место, STMT.CaseRange);
            this.first = first;
            this.last = last;
            this.инструкция = s;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class CaseStatement : Инструкция2
    {
        Выражение exp;
        Инструкция2 инструкция;

        this(ref Место место, Выражение exp, Инструкция2 s)
        {
            super(место, STMT.Case);
            this.exp = exp;
            this.инструкция = s;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class DefaultStatement : Инструкция2
    {
        Инструкция2 инструкция;

        this(ref Место место, Инструкция2 s)
        {
            super(место, STMT.Default);
            this.инструкция = s;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class BreakStatement : Инструкция2
    {
        Идентификатор2 идент;

        this(ref Место место, Идентификатор2 идент)
        {
            super(место, STMT.Break);
            this.идент = идент;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class ContinueStatement : Инструкция2
    {
        Идентификатор2 идент;

        this(ref Место место, Идентификатор2 идент)
        {
            super(место, STMT.Continue);
            this.идент = идент;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class GotoDefaultStatement : Инструкция2
    {
        this(ref Место место)
        {
            super(место, STMT.GotoDefault);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class GotoCaseStatement : Инструкция2
    {
        Выражение exp;

        this(ref Место место, Выражение exp)
        {
            super(место, STMT.GotoCase);
            this.exp = exp;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class GotoStatement : Инструкция2
    {
        Идентификатор2 идент;

        this(ref Место место, Идентификатор2 идент)
        {
            super(место, STMT.Goto);
            this.идент = идент;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class SynchronizedStatement : Инструкция2
    {
        Выражение exp;
        Инструкция2 _body;

        this(ref Место место, Выражение exp, Инструкция2 _body)
        {
            super(место, STMT.Synchronized);
            this.exp = exp;
            this._body = _body;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class WithStatement : Инструкция2
    {
        Выражение exp;
        Инструкция2 _body;
        Место endloc;

        this(ref Место место, Выражение exp, Инструкция2 _body, Место endloc)
        {
            super(место, STMT.With);
            this.exp = exp;
            this._body = _body;
            this.endloc = endloc;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class TryCatchStatement : Инструкция2
    {
        Инструкция2 _body;
        Уловители* catches;

        this(ref Место место, Инструкция2 _body, Уловители* catches)
        {
            super(место, STMT.TryCatch);
            this._body = _body;
            this.catches = catches;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class TryFinallyStatement : Инструкция2
    {
        Инструкция2 _body;
        Инструкция2 finalbody;

        this(ref Место место, Инструкция2 _body, Инструкция2 finalbody)
        {
            super(место, STMT.TryFinally);
            this._body = _body;
            this.finalbody = finalbody;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class ThrowStatement : Инструкция2
    {
        Выражение exp;

        this(ref Место место, Выражение exp)
        {
            super(место, STMT.Throw);
            this.exp = exp;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     class AsmStatement : Инструкция2
    {
        Сема2* tokens;

        this(ref Место место, Сема2* tokens)
        {
            super(место, STMT.Asm);
            this.tokens = tokens;
        }

        this(ref Место место, Сема2* tokens, STMT stmt)
        {
            super(место, stmt);
            this.tokens = tokens;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class InlineAsmStatement : AsmStatement
    {
        this(ref Место место, Сема2* tokens)
        {
            super(место, tokens, STMT.InlineAsm);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class GccAsmStatement : AsmStatement
    {
        this(ref Место место, Сема2* tokens)
        {
            super(место, tokens, STMT.GccAsm);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     class ExpStatement : Инструкция2
    {
        Выражение exp;

        final this(ref Место место, Выражение exp)
        {
            super(место, STMT.Exp);
            this.exp = exp;
        }
        final this(ref Место место, ДСимвол declaration)
        {
            super(место, STMT.Exp);
            this.exp = new DeclarationExp(место, declaration);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     class CompoundStatement : Инструкция2
    {
        Инструкции* statements;

        final this(ref Место место, Инструкции* statements)
        {
            super(место, STMT.Compound);
            this.statements = statements;
        }

        final this(ref Место место, Инструкции* statements, STMT stmt)
        {
            super(место, stmt);
            this.statements = statements;
        }

        final this(ref Место место, Инструкция2[] sts...)
        {
            super(место, STMT.Compound);
            statements = new Инструкции();
            statements.резервируй(sts.length);
            foreach (s; sts)
                statements.сунь(s);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class CompoundDeclarationStatement : CompoundStatement
    {
        final this(ref Место место, Инструкции* statements)
        {
            super(место, statements, STMT.CompoundDeclaration);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class CompoundAsmStatement : CompoundStatement
    {
        КлассХранения stc;

        final this(ref Место место, Инструкции* s, КлассХранения stc)
        {
            super(место, s, STMT.CompoundAsm);
            this.stc = stc;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class Уловитель : КорневойОбъект
    {
        Место место;
        Тип тип;
        Идентификатор2 идент;
        Инструкция2 handler;

        this(ref Место место, Тип t, Идентификатор2 ид, Инструкция2 handler)
        {
            this.место = место;
            this.тип = t;
            this.идент = ид;
            this.handler = handler;
        }
    }

     abstract class Тип : УзелАСД
    {
        TY ty;
        MOD mod;
        ткст0 deco;

          Тип tvoid;
          Тип tint8;
          Тип tuns8;
          Тип tint16;
          Тип tuns16;
          Тип tint32;
          Тип tuns32;
          Тип tint64;
          Тип tuns64;
          Тип tint128;
          Тип tuns128;
          Тип tfloat32;
          Тип tfloat64;
          Тип tfloat80;
          Тип timaginary32;
          Тип timaginary64;
          Тип timaginary80;
          Тип tcomplex32;
          Тип tcomplex64;
          Тип tcomplex80;
          Тип tбул;
          Тип tchar;
          Тип twchar;
          Тип tdchar;

          Тип[TMAX] basic;

          Тип tshiftcnt;
          Тип tvoidptr;    // ук
          Тип tstring;     // const(сим)[]
          Тип twstring;    // const(wchar)[]
          Тип tdstring;    // const(dchar)[]
          Тип tvalist;     // va_list alias
          Тип terror;      // for error recovery
          Тип tnull;       // for null тип

          Тип tт_мера;     // matches т_мера alias
          Тип tptrdiff_t;  // matches ptrdiff_t alias
          Тип thash_t;     // matches hash_t alias



          ClassDeclaration dtypeinfo;
          ClassDeclaration typeinfoclass;
          ClassDeclaration typeinfointerface;
          ClassDeclaration typeinfostruct;
          ClassDeclaration typeinfopointer;
          ClassDeclaration typeinfoarray;
          ClassDeclaration typeinfostaticarray;
          ClassDeclaration typeinfoassociativearray;
          ClassDeclaration typeinfovector;
          ClassDeclaration typeinfoenum;
          ClassDeclaration typeinfofunction;
          ClassDeclaration typeinfodelegate;
          ClassDeclaration typeinfotypelist;
          ClassDeclaration typeinfoconst;
          ClassDeclaration typeinfoinvariant;
          ClassDeclaration typeinfoshared;
          ClassDeclaration typeinfowild;
          ТаблицаСтрок!(Тип) stringtable;
          ббайт[TMAX] sizeTy = ()
            {
                ббайт[TMAX] sizeTy = __traits(classInstanceSize, TypeBasic);
                sizeTy[Tsarray] = __traits(classInstanceSize, TypeSArray);
                sizeTy[Tarray] = __traits(classInstanceSize, TypeDArray);
                sizeTy[Taarray] = __traits(classInstanceSize, TypeAArray);
                sizeTy[Tpointer] = __traits(classInstanceSize, TypePointer);
                sizeTy[Treference] = __traits(classInstanceSize, TypeReference);
                sizeTy[Tfunction] = __traits(classInstanceSize, TypeFunction);
                sizeTy[Tdelegate] = __traits(classInstanceSize, TypeDelegate);
                sizeTy[Tident] = __traits(classInstanceSize, TypeIdentifier);
                sizeTy[Tinstance] = __traits(classInstanceSize, TypeInstance);
                sizeTy[Ttypeof] = __traits(classInstanceSize, TypeTypeof);
                sizeTy[Tenum] = __traits(classInstanceSize, TypeEnum);
                sizeTy[Tstruct] = __traits(classInstanceSize, TypeStruct);
                sizeTy[Tclass] = __traits(classInstanceSize, TypeClass);
                sizeTy[Ttuple] = __traits(classInstanceSize, КортежТипов);
                sizeTy[Tslice] = __traits(classInstanceSize, TypeSlice);
                sizeTy[Treturn] = __traits(classInstanceSize, TypeReturn);
                sizeTy[Terror] = __traits(classInstanceSize, TypeError);
                sizeTy[Tnull] = __traits(classInstanceSize, TypeNull);
                sizeTy[Tvector] = __traits(classInstanceSize, TypeVector);
                sizeTy[Tmixin] = __traits(classInstanceSize, TypeMixin);
                return sizeTy;
            }();

        Тип cto;
        Тип ito;
        Тип sto;
        Тип scto;
        Тип wto;
        Тип wcto;
        Тип swto;
        Тип swcto;

        Тип pto;
        Тип rto;
        Тип arrayof;

        // These члены are probably используется in semnatic analysis
        //TypeInfoDeclaration vtinfo;
        //тип* ctype;

        final this(TY ty)
        {
            this.ty = ty;
        }

        override ткст0 вТкст0()
        {
            return "тип";
        }

        static проц _иниц()
        {
            stringtable._иниц(14000);

            // Set basic types
             TY* basetab =
            [
                Tvoid,
                Tint8,
                Tuns8,
                Tint16,
                Tuns16,
                Tint32,
                Tuns32,
                Tint64,
                Tuns64,
                Tint128,
                Tuns128,
                Tfloat32,
                Tfloat64,
                Tfloat80,
                Timaginary32,
                Timaginary64,
                Timaginary80,
                Tcomplex32,
                Tcomplex64,
                Tcomplex80,
                Tbool,
                Tchar,
                Twchar,
                Tdchar,
                Terror
            ];

            for (т_мера i = 0; basetab[i] != Terror; i++)
            {
                Тип t = new TypeBasic(basetab[i]);
                t = t.merge();
                basic[basetab[i]] = t;
            }
            basic[Terror] = new TypeError();

            tvoid = basic[Tvoid];
            tint8 = basic[Tint8];
            tuns8 = basic[Tuns8];
            tint16 = basic[Tint16];
            tuns16 = basic[Tuns16];
            tint32 = basic[Tint32];
            tuns32 = basic[Tuns32];
            tint64 = basic[Tint64];
            tuns64 = basic[Tuns64];
            tint128 = basic[Tint128];
            tuns128 = basic[Tuns128];
            tfloat32 = basic[Tfloat32];
            tfloat64 = basic[Tfloat64];
            tfloat80 = basic[Tfloat80];

            timaginary32 = basic[Timaginary32];
            timaginary64 = basic[Timaginary64];
            timaginary80 = basic[Timaginary80];

            tcomplex32 = basic[Tcomplex32];
            tcomplex64 = basic[Tcomplex64];
            tcomplex80 = basic[Tcomplex80];

            tбул = basic[Tbool];
            tchar = basic[Tchar];
            twchar = basic[Twchar];
            tdchar = basic[Tdchar];

            tshiftcnt = tint32;
            terror = basic[Terror];
            tnull = basic[Tnull];
            tnull = new TypeNull();
            tnull.deco = tnull.merge().deco;

            tvoidptr = tvoid.pointerTo();
            tstring = tchar.immutableOf().arrayOf();
            twstring = twchar.immutableOf().arrayOf();
            tdstring = tdchar.immutableOf().arrayOf();
            tvalist = Target.va_listType();

            const isLP64 = глоб2.парамы.isLP64;

            tт_мера    = basic[isLP64 ? Tuns64 : Tuns32];
            tptrdiff_t = basic[isLP64 ? Tint64 : Tint32];
            thash_t = tт_мера;
        }

        final Тип pointerTo()
        {
            if (ty == Terror)
                return this;
            if (!pto)
            {
                Тип t = new TypePointer(this);
                if (ty == Tfunction)
                {
                    t.deco = t.merge().deco;
                    pto = t;
                }
                else
                    pto = t.merge();
            }
            return pto;
        }

        final Тип arrayOf()
        {
            if (ty == Terror)
                return this;
            if (!arrayof)
            {
                Тип t = new TypeDArray(this);
                arrayof = t.merge();
            }
            return arrayof;
        }

        final бул isImmutable()
        {
            return (mod & MODFlags.immutable_) != 0;
        }

        final Тип nullAttributes()
        {
            бцел sz = sizeTy[ty];
            Тип t = cast(Тип)mem.xmalloc(sz);
            memcpy(cast(ук)t, cast(ук)this, sz);
            // t.mod = NULL;  // leave mod unchanged
            t.deco = null;
            t.arrayof = null;
            t.pto = null;
            t.rto = null;
            t.cto = null;
            t.ito = null;
            t.sto = null;
            t.scto = null;
            t.wto = null;
            t.wcto = null;
            t.swto = null;
            t.swcto = null;
            //t.vtinfo = null; these aren't используется in parsing
            //t.ctype = null;
            if (t.ty == Tstruct)
                (cast(TypeStruct)t).att = AliasThisRec.fwdref;
            if (t.ty == Tclass)
                (cast(TypeClass)t).att = AliasThisRec.fwdref;
            return t;
        }

        Тип makeConst()
        {
            if (cto)
                return cto;
            Тип t = this.nullAttributes();
            t.mod = MODFlags.const_;
            return t;
        }

        Тип makeWildConst()
        {
            if (wcto)
                return wcto;
            Тип t = this.nullAttributes();
            t.mod = MODFlags.wildconst;
            return t;
        }

        Тип makeShared()
        {
            if (sto)
                return sto;
            Тип t = this.nullAttributes();
            t.mod = MODFlags.shared_;
            return t;
        }

        Тип makeSharedConst()
        {
            if (scto)
                return scto;
            Тип t = this.nullAttributes();
            t.mod = MODFlags.shared_ | MODFlags.const_;
            return t;
        }

        Тип makeImmutable()
        {
            if (ito)
                return ito;
            Тип t = this.nullAttributes();
            t.mod = MODFlags.immutable_;
            return t;
        }

        Тип makeWild()
        {
            if (wto)
                return wto;
            Тип t = this.nullAttributes();
            t.mod = MODFlags.wild;
            return t;
        }

        Тип makeSharedWildConst()
        {
            if (swcto)
                return swcto;
            Тип t = this.nullAttributes();
            t.mod = MODFlags.shared_ | MODFlags.wildconst;
            return t;
        }

        Тип makeSharedWild()
        {
            if (swto)
                return swto;
            Тип t = this.nullAttributes();
            t.mod = MODFlags.shared_ | MODFlags.wild;
            return t;
        }

        // Truncated
        final Тип merge()
        {
            if (ty == Terror)
                return this;
            if (ty == Ttypeof)
                return this;
            if (ty == Tident)
                return this;
            if (ty == Tinstance)
                return this;
            if (ty == Taarray && !(cast(TypeAArray)this).index.merge().deco)
                return this;
            if (ty != Tenum && nextOf() && !nextOf().deco)
                return this;

            // if (!deco) - code missing

            Тип t = this;
            assert(t);
            return t;
        }

        final Тип addSTC(КлассХранения stc)
        {
            Тип t = this;
            if (t.isImmutable())
            {
            }
            else if (stc & STC.immutable_)
            {
                t = t.makeImmutable();
            }
            else
            {
                if ((stc & STC.shared_) && !t.isShared())
                {
                    if (t.isWild())
                    {
                        if (t.isConst())
                            t = t.makeSharedWildConst();
                        else
                            t = t.makeSharedWild();
                    }
                    else
                    {
                        if (t.isConst())
                            t = t.makeSharedConst();
                        else
                            t = t.makeShared();
                    }
                }
                if ((stc & STC.const_) && !t.isConst())
                {
                    if (t.isShared())
                    {
                        if (t.isWild())
                            t = t.makeSharedWildConst();
                        else
                            t = t.makeSharedConst();
                    }
                    else
                    {
                        if (t.isWild())
                            t = t.makeWildConst();
                        else
                            t = t.makeConst();
                    }
                }
                if ((stc & STC.wild) && !t.isWild())
                {
                    if (t.isShared())
                    {
                        if (t.isConst())
                            t = t.makeSharedWildConst();
                        else
                            t = t.makeSharedWild();
                    }
                    else
                    {
                        if (t.isConst())
                            t = t.makeWildConst();
                        else
                            t = t.makeWild();
                    }
                }
            }
            return t;
        }

        Выражение toВыражение()
        {
            return null;
        }

        Тип syntaxCopy()
        {
            return null;
        }

        final Тип sharedWildConstOf()
        {
            if (mod == (MODFlags.shared_ | MODFlags.wildconst))
                return this;
            if (swcto)
            {
                assert(swcto.mod == (MODFlags.shared_ | MODFlags.wildconst));
                return swcto;
            }
            Тип t = makeSharedWildConst();
            t = t.merge();
            t.fixTo(this);
            return t;
        }

        final Тип sharedConstOf()
        {
            if (mod == (MODFlags.shared_ | MODFlags.const_))
                return this;
            if (scto)
            {
                assert(scto.mod == (MODFlags.shared_ | MODFlags.const_));
                return scto;
            }
            Тип t = makeSharedConst();
            t = t.merge();
            t.fixTo(this);
            return t;
        }

        final Тип wildConstOf()
        {
            if (mod == MODFlags.wildconst)
                return this;
            if (wcto)
            {
                assert(wcto.mod == MODFlags.wildconst);
                return wcto;
            }
            Тип t = makeWildConst();
            t = t.merge();
            t.fixTo(this);
            return t;
        }

        final Тип constOf()
        {
            if (mod == MODFlags.const_)
                return this;
            if (cto)
            {
                assert(cto.mod == MODFlags.const_);
                return cto;
            }
            Тип t = makeConst();
            t = t.merge();
            t.fixTo(this);
            return t;
        }

        final Тип sharedWildOf()
        {
            if (mod == (MODFlags.shared_ | MODFlags.wild))
                return this;
            if (swto)
            {
                assert(swto.mod == (MODFlags.shared_ | MODFlags.wild));
                return swto;
            }
            Тип t = makeSharedWild();
            t = t.merge();
            t.fixTo(this);
            return t;
        }

        final Тип wildOf()
        {
            if (mod == MODFlags.wild)
                return this;
            if (wto)
            {
                assert(wto.mod == MODFlags.wild);
                return wto;
            }
            Тип t = makeWild();
            t = t.merge();
            t.fixTo(this);
            return t;
        }

        final Тип sharedOf()
        {
            if (mod == MODFlags.shared_)
                return this;
            if (sto)
            {
                assert(sto.mod == MODFlags.shared_);
                return sto;
            }
            Тип t = makeShared();
            t = t.merge();
            t.fixTo(this);
            return t;
        }

        final Тип immutableOf()
        {
            if (isImmutable())
                return this;
            if (ito)
            {
                assert(ito.isImmutable());
                return ito;
            }
            Тип t = makeImmutable();
            t = t.merge();
            t.fixTo(this);
            return t;
        }

        final проц fixTo(Тип t)
        {
            Тип mto = null;
            Тип tn = nextOf();
            if (!tn || ty != Tsarray && tn.mod == t.nextOf().mod)
            {
                switch (t.mod)
                {
                case 0:
                    mto = t;
                    break;

                case MODFlags.const_:
                    cto = t;
                    break;

                case MODFlags.wild:
                    wto = t;
                    break;

                case MODFlags.wildconst:
                    wcto = t;
                    break;

                case MODFlags.shared_:
                    sto = t;
                    break;

                case MODFlags.shared_ | MODFlags.const_:
                    scto = t;
                    break;

                case MODFlags.shared_ | MODFlags.wild:
                    swto = t;
                    break;

                case MODFlags.shared_ | MODFlags.wildconst:
                    swcto = t;
                    break;

                case MODFlags.immutable_:
                    ito = t;
                    break;

                default:
                    break;
                }
            }
            assert(mod != t.mod);

            T X(T, U)(T m, U n)
            {
                return ((m << 4) | n);
            }

            switch (mod)
            {
            case 0:
                break;

            case MODFlags.const_:
                cto = mto;
                t.cto = this;
                break;

            case MODFlags.wild:
                wto = mto;
                t.wto = this;
                break;

            case MODFlags.wildconst:
                wcto = mto;
                t.wcto = this;
                break;

            case MODFlags.shared_:
                sto = mto;
                t.sto = this;
                break;

            case MODFlags.shared_ | MODFlags.const_:
                scto = mto;
                t.scto = this;
                break;

            case MODFlags.shared_ | MODFlags.wild:
                swto = mto;
                t.swto = this;
                break;

            case MODFlags.shared_ | MODFlags.wildconst:
                swcto = mto;
                t.swcto = this;
                break;

            case MODFlags.immutable_:
                t.ito = this;
                if (t.cto)
                    t.cto.ito = this;
                if (t.sto)
                    t.sto.ito = this;
                if (t.scto)
                    t.scto.ito = this;
                if (t.wto)
                    t.wto.ito = this;
                if (t.wcto)
                    t.wcto.ito = this;
                if (t.swto)
                    t.swto.ito = this;
                if (t.swcto)
                    t.swcto.ito = this;
                break;

            default:
                assert(0);
            }
        }

        final Тип addMod(MOD mod)
        {
            Тип t = this;
            if (!t.isImmutable())
            {
                switch (mod)
                {
                case 0:
                    break;

                case MODFlags.const_:
                    if (isShared())
                    {
                        if (isWild())
                            t = sharedWildConstOf();
                        else
                            t = sharedConstOf();
                    }
                    else
                    {
                        if (isWild())
                            t = wildConstOf();
                        else
                            t = constOf();
                    }
                    break;

                case MODFlags.wild:
                    if (isShared())
                    {
                        if (isConst())
                            t = sharedWildConstOf();
                        else
                            t = sharedWildOf();
                    }
                    else
                    {
                        if (isConst())
                            t = wildConstOf();
                        else
                            t = wildOf();
                    }
                    break;

                case MODFlags.wildconst:
                    if (isShared())
                        t = sharedWildConstOf();
                    else
                        t = wildConstOf();
                    break;

                case MODFlags.shared_:
                    if (isWild())
                    {
                        if (isConst())
                            t = sharedWildConstOf();
                        else
                            t = sharedWildOf();
                    }
                    else
                    {
                        if (isConst())
                            t = sharedConstOf();
                        else
                            t = sharedOf();
                    }
                    break;

                case MODFlags.shared_ | MODFlags.const_:
                    if (isWild())
                        t = sharedWildConstOf();
                    else
                        t = sharedConstOf();
                    break;

                case MODFlags.shared_ | MODFlags.wild:
                    if (isConst())
                        t = sharedWildConstOf();
                    else
                        t = sharedWildOf();
                    break;

                case MODFlags.shared_ | MODFlags.wildconst:
                    t = sharedWildConstOf();
                    break;

                case MODFlags.immutable_:
                    t = immutableOf();
                    break;

                default:
                    assert(0);
                }
            }
            return t;
        }

        // TypeEnum overrides this method
        Тип nextOf()
        {
            return null;
        }

        // TypeBasic, TypeVector, TypePointer, TypeEnum override this method
        бул isscalar()
        {
            return нет;
        }

        final бул isConst() 
        {
            return (mod & MODFlags.const_) != 0;
        }

        final бул isWild() 
        {
            return (mod & MODFlags.wild) != 0;
        }

        final бул isShared()
        {
            return (mod & MODFlags.shared_) != 0;
        }

        Тип toBasetype()
        {
            return this;
        }

        // TypeIdentifier, TypeInstance, TypeTypeOf, TypeReturn, TypeStruct, TypeEnum, TypeClass override this method
        ДСимвол toDsymbol(Scope* sc)
        {
            return null;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

    // missing functionality in constructor, but that's ok
    // since the class is needed only for its size; need to add all method definitions
     final class TypeBasic : Тип
    {
        ткст0 dstring;
        бцел flags;

        this(TY ty)
        {
            super(ty);
            ткст0 d;
            бцел flags = 0;
            switch (ty)
            {
            case Tvoid:
                d = Сема2.вТкст0(ТОК2.void_);
                break;

            case Tint8:
                d = Сема2.вТкст0(ТОК2.int8);
                flags |= TFlags.integral;
                break;

            case Tuns8:
                d = Сема2.вТкст0(ТОК2.uns8);
                flags |= TFlags.integral | TFlags.unsigned;
                break;

            case Tint16:
                d = Сема2.вТкст0(ТОК2.int16);
                flags |= TFlags.integral;
                break;

            case Tuns16:
                d = Сема2.вТкст0(ТОК2.uns16);
                flags |= TFlags.integral | TFlags.unsigned;
                break;

            case Tint32:
                d = Сема2.вТкст0(ТОК2.int32);
                flags |= TFlags.integral;
                break;

            case Tuns32:
                d = Сема2.вТкст0(ТОК2.uns32);
                flags |= TFlags.integral | TFlags.unsigned;
                break;

            case Tfloat32:
                d = Сема2.вТкст0(ТОК2.float32);
                flags |= TFlags.floating | TFlags.real_;
                break;

            case Tint64:
                d = Сема2.вТкст0(ТОК2.int64);
                flags |= TFlags.integral;
                break;

            case Tuns64:
                d = Сема2.вТкст0(ТОК2.uns64);
                flags |= TFlags.integral | TFlags.unsigned;
                break;

            case Tint128:
                d = Сема2.вТкст0(ТОК2.int128);
                flags |= TFlags.integral;
                break;

            case Tuns128:
                d = Сема2.вТкст0(ТОК2.uns128);
                flags |= TFlags.integral | TFlags.unsigned;
                break;

            case Tfloat64:
                d = Сема2.вТкст0(ТОК2.float64);
                flags |= TFlags.floating | TFlags.real_;
                break;

            case Tfloat80:
                d = Сема2.вТкст0(ТОК2.float80);
                flags |= TFlags.floating | TFlags.real_;
                break;

            case Timaginary32:
                d = Сема2.вТкст0(ТОК2.imaginary32);
                flags |= TFlags.floating | TFlags.imaginary;
                break;

            case Timaginary64:
                d = Сема2.вТкст0(ТОК2.imaginary64);
                flags |= TFlags.floating | TFlags.imaginary;
                break;

            case Timaginary80:
                d = Сема2.вТкст0(ТОК2.imaginary80);
                flags |= TFlags.floating | TFlags.imaginary;
                break;

            case Tcomplex32:
                d = Сема2.вТкст0(ТОК2.complex32);
                flags |= TFlags.floating | TFlags.complex;
                break;

            case Tcomplex64:
                d = Сема2.вТкст0(ТОК2.complex64);
                flags |= TFlags.floating | TFlags.complex;
                break;

            case Tcomplex80:
                d = Сема2.вТкст0(ТОК2.complex80);
                flags |= TFlags.floating | TFlags.complex;
                break;

            case Tbool:
                d = "бул";
                flags |= TFlags.integral | TFlags.unsigned;
                break;

            case Tchar:
                d = Сема2.вТкст0(ТОК2.char_);
                flags |= TFlags.integral | TFlags.unsigned | TFlags.char_;
                break;

            case Twchar:
                d = Сема2.вТкст0(ТОК2.wchar_);
                flags |= TFlags.integral | TFlags.unsigned | TFlags.char_;
                break;

            case Tdchar:
                d = Сема2.вТкст0(ТОК2.dchar_);
                flags |= TFlags.integral | TFlags.unsigned | TFlags.char_;
                break;

            default:
                assert(0);
            }
            this.dstring = d;
            this.flags = flags;
            merge();
        }

        override бул isscalar()
        {
            return (flags & (TFlags.integral | TFlags.floating)) != 0;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class TypeError : Тип
    {
        this()
        {
            super(Terror);
        }

        override Тип syntaxCopy()
        {
            return this;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class TypeNull : Тип
    {
        this()
        {
            super(Tnull);
        }

        override Тип syntaxCopy()
        {
            // No semantic analysis done, no need to копируй
            return this;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     class TypeVector : Тип
    {
        Тип basetype;

        this(Тип baseType)
        {
            super(Tvector);
            this.basetype = basetype;
        }

        override Тип syntaxCopy()
        {
            return new TypeVector(basetype.syntaxCopy());
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class TypeEnum : Тип
    {
        EnumDeclaration sym;

        this(EnumDeclaration sym)
        {
            super(Tenum);
            this.sym = sym;
        }

        override Тип syntaxCopy()
        {
            return this;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class КортежТипов : Тип
    {
        Параметры* arguments;

        this(Параметры* arguments)
        {
            super(Ttuple);
            this.arguments = arguments;
        }

        this(Выражения* exps)
        {
            super(Ttuple);
            auto arguments = new Параметры();
            if (exps)
            {
                arguments.устДим(exps.dim);
                for (т_мера i = 0; i < exps.dim; i++)
                {
                    Выражение e = (*exps)[i];
                    if (e.тип.ty == Ttuple)
                        e.выведиОшибку("cannot form кортеж of tuples");
                    auto arg = new Параметр2(STC.undefined_, e.тип, null, null, null);
                    (*arguments)[i] = arg;
                }
            }
            this.arguments = arguments;
        }

        override Тип syntaxCopy()
        {
            Параметры* args = Параметр2.arraySyntaxCopy(arguments);
            Тип t = new КортежТипов(args);
            t.mod = mod;
            return t;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class TypeClass : Тип
    {
        ClassDeclaration sym;
        AliasThisRec att = AliasThisRec.fwdref;

        this (ClassDeclaration sym)
        {
            super(Tclass);
            this.sym = sym;
        }

        override Тип syntaxCopy()
        {
            return this;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class TypeStruct : Тип
    {
        StructDeclaration sym;
        AliasThisRec att = AliasThisRec.fwdref;

        this(StructDeclaration sym)
        {
            super(Tstruct);
            this.sym = sym;
        }

        override Тип syntaxCopy()
        {
            return this;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class TypeReference : TypeNext
    {
        this(Тип t)
        {
            super(Treference, t);
            // BUG: what about references to static arrays?
        }

        override Тип syntaxCopy()
        {
            Тип t = следщ.syntaxCopy();
            if (t == следщ)
                t = this;
            else
            {
                t = new TypeReference(t);
                t.mod = mod;
            }
            return t;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     abstract class TypeNext : Тип
    {
        Тип следщ;

        final this(TY ty, Тип следщ)
        {
            super(ty);
            this.следщ = следщ;
        }

        override final Тип nextOf()
        {
            return следщ;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class TypeSlice : TypeNext
    {
        Выражение lwr;
        Выражение upr;

        this(Тип следщ, Выражение lwr, Выражение upr)
        {
            super(Tslice, следщ);
            this.lwr = lwr;
            this.upr = upr;
        }

        override Тип syntaxCopy()
        {
            Тип t = new TypeSlice(следщ.syntaxCopy(), lwr.syntaxCopy(), upr.syntaxCopy());
            t.mod = mod;
            return t;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     class TypeDelegate : TypeNext
    {
        this(Тип t)
        {
            super(Tfunction, t);
            ty = Tdelegate;
        }

        override Тип syntaxCopy()
        {
            Тип t = следщ.syntaxCopy();
            if (t == следщ)
                t = this;
            else
            {
                t = new TypeDelegate(t);
                t.mod = mod;
            }
            return t;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class TypePointer : TypeNext
    {
        this(Тип t)
        {
            super(Tpointer, t);
        }

        override Тип syntaxCopy()
        {
            Тип t = следщ.syntaxCopy();
            if (t == следщ)
                t = this;
            else
            {
                t = new TypePointer(t);
                t.mod = mod;
            }
            return t;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     class TypeFunction : TypeNext
    {
        СписокПараметров parameterList;  // function parameters

        бул isnothrow;             // да: 
        бул isnogc;                // да: is 
        бул isproperty;            // can be called without parentheses
        бул isref;                 // да: returns a reference
        бул isreturn;              // да: 'this' is returned by ref
        бул isscope;               // да: 'this' is scope
        бул islive;                // да: function is @live
        LINK компонаж;               // calling convention
        TRUST trust;                // уровень of trust
        PURE purity = PURE.impure;

        ббайт iswild;
        Выражения* fargs;

        this(СписокПараметров pl, Тип treturn, LINK компонаж, КлассХранения stc = 0)
        {
            super(Tfunction, treturn);
            assert(ВарАрг.none <= pl.varargs && pl.varargs <= ВарАрг.typesafe);
            this.parameterList = pl;
            this.компонаж = компонаж;

            if (stc & STC.pure_)
                this.purity = PURE.fwdref;
            if (stc & STC.nothrow_)
                this.isnothrow = да;
            if (stc & STC.nogc)
                this.isnogc = да;
            if (stc & STC.property)
                this.isproperty = да;
            if (stc & STC.live)
                this.islive = да;

            if (stc & STC.ref_)
                this.isref = да;
            if (stc & STC.return_)
                this.isreturn = да;
            if (stc & STC.scope_)
                this.isscope = да;

            this.trust = TRUST.default_;
            if (stc & STC.safe)
                this.trust = TRUST.safe;
            if (stc & STC.system)
                this.trust = TRUST.system;
            if (stc & STC.trusted)
                this.trust = TRUST.trusted;
        }

        override Тип syntaxCopy()
        {
            Тип treturn = следщ ? следщ.syntaxCopy() : null;
            Параметры* парамы = Параметр2.arraySyntaxCopy(parameterList.parameters);
            auto t = new TypeFunction(СписокПараметров(парамы, parameterList.varargs), treturn, компонаж);
            t.mod = mod;
            t.isnothrow = isnothrow;
            t.isnogc = isnogc;
            t.purity = purity;
            t.isproperty = isproperty;
            t.isref = isref;
            t.isreturn = isreturn;
            t.isscope = isscope;
            t.iswild = iswild;
            t.trust = trust;
            t.fargs = fargs;
            return t;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     class TypeArray : TypeNext
    {
        final this(TY ty, Тип следщ)
        {
            super(ty, следщ);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class TypeDArray : TypeArray
    {
        this(Тип t)
        {
            super(Tarray, t);
        }

        override Тип syntaxCopy()
        {
            Тип t = следщ.syntaxCopy();
            if (t == следщ)
                t = this;
            else
            {
                t = new TypeDArray(t);
                t.mod = mod;
            }
            return t;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class TypeAArray : TypeArray
    {
        Тип index;
        Место место;

        this(Тип t, Тип index)
        {
            super(Taarray, t);
            this.index = index;
        }

        override Тип syntaxCopy()
        {
            Тип t = следщ.syntaxCopy();
            Тип ti = index.syntaxCopy();
            if (t == следщ && ti == index)
                t = this;
            else
            {
                t = new TypeAArray(t, ti);
                t.mod = mod;
            }
            return t;
        }

        override Выражение toВыражение()
        {
            Выражение e = следщ.toВыражение();
            if (e)
            {
                Выражение ei = index.toВыражение();
                if (ei)
                    return new ArrayExp(место, e, ei);
            }
            return null;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class TypeSArray : TypeArray
    {
        Выражение dim;

        final this(Тип t, Выражение dim)
        {
            super(Tsarray, t);
            this.dim = dim;
        }

        override Тип syntaxCopy()
        {
            Тип t = следщ.syntaxCopy();
            Выражение e = dim.syntaxCopy();
            t = new TypeSArray(t, e);
            t.mod = mod;
            return t;
        }

        override Выражение toВыражение()
        {
            Выражение e = следщ.toВыражение();
            if (e)
                e = new ArrayExp(dim.место, e, dim);
            return e;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     abstract class TypeQualified : Тип
    {
        Объекты idents;
        Место место;

        final this(TY ty, Место место)
        {
            super(ty);
            this.место = место;
        }

        final проц addIdent(Идентификатор2 ид)
        {
            idents.сунь(ид);
        }

        final проц addInst(TemplateInstance ti)
        {
            idents.сунь(ti);
        }

        final проц addIndex(КорневойОбъект e)
        {
            idents.сунь(e);
        }

        final проц syntaxCopyHelper(TypeQualified t)
        {
            idents.устДим(t.idents.dim);
            for (т_мера i = 0; i < idents.dim; i++)
            {
                КорневойОбъект ид = t.idents[i];
                if (ид.динкаст() == ДИНКАСТ.дсимвол)
                {
                    TemplateInstance ti = cast(TemplateInstance)ид;
                    ti = cast(TemplateInstance)ti.syntaxCopy(null);
                    ид = ti;
                }
                else if (ид.динкаст() == ДИНКАСТ.Выражение)
                {
                    Выражение e = cast(Выражение)ид;
                    e = e.syntaxCopy();
                    ид = e;
                }
                else if (ид.динкаст() == ДИНКАСТ.тип)
                {
                    Тип tx = cast(Тип)ид;
                    tx = tx.syntaxCopy();
                    ид = tx;
                }
                idents[i] = ид;
            }
        }

        final Выражение toВыражениеHelper(Выражение e, т_мера i = 0)
        {
            for (; i < idents.dim; i++)
            {
                КорневойОбъект ид = idents[i];

                switch (ид.динкаст())
                {
                    case ДИНКАСТ.идентификатор:
                        e = new DotIdExp(e.место, e, cast(Идентификатор2)ид);
                        break;

                    case ДИНКАСТ.дсимвол:
                        auto ti = (cast(ДСимвол)ид).isTemplateInstance();
                        assert(ti);
                        e = new DotTemplateInstanceExp(e.место, e, ti.имя, ti.tiargs);
                        break;

                    case ДИНКАСТ.тип:          // Bugzilla 1215
                        e = new ArrayExp(место, e, new TypeExp(место, cast(Тип)ид));
                        break;

                    case ДИНКАСТ.Выражение:    // Bugzilla 1215
                        e = new ArrayExp(место, e, cast(Выражение)ид);
                        break;

                    default:
                        assert(0);
                }
            }
            return e;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     class TypeTraits : Тип
    {
        TraitsExp exp;
        Место место;

        this(ref Место место, TraitsExp exp)
        {
            super(Tident);
            this.место = место;
            this.exp = exp;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }

        override Тип syntaxCopy()
        {
            TraitsExp te = cast(TraitsExp) exp.syntaxCopy();
            TypeTraits tt = new TypeTraits(место, te);
            tt.mod = mod;
            return tt;
        }
    }

     final class TypeMixin : Тип
    {
        Место место;
        Выражения* exps;

        this(ref Место место, Выражения* exps)
        {
            super(Tmixin);
            this.место = место;
            this.exps = exps;
        }

        override Тип syntaxCopy()
        {
            static Выражения* arraySyntaxCopy(Выражения* exps)
            {
                Выражения* a = null;
                if (exps)
                {
                    a = new Выражения(exps.dim);
                    foreach (i, e; *exps)
                    {
                        (*a)[i] = e ? e.syntaxCopy() : null;
                    }
                }
                return a;
            }

            return new TypeMixin(место, arraySyntaxCopy(exps));
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class TypeIdentifier : TypeQualified
    {
        Идентификатор2 идент;

        this(ref Место место, Идентификатор2 идент)
        {
            super(Tident, место);
            this.идент = идент;
        }

        override Тип syntaxCopy()
        {
            auto t = new TypeIdentifier(место, идент);
            t.syntaxCopyHelper(this);
            t.mod = mod;
            return t;
        }

        override Выражение toВыражение()
        {
            return toВыражениеHelper(new IdentifierExp(место, идент));
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class TypeReturn : TypeQualified
    {
        this(ref Место место)
        {
            super(Treturn, место);
        }

        override Тип syntaxCopy()
        {
            auto t = new TypeReturn(место);
            t.syntaxCopyHelper(this);
            t.mod = mod;
            return t;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class TypeTypeof : TypeQualified
    {
        Выражение exp;

        this(ref Место место, Выражение exp)
        {
            super(Ttypeof, место);
            this.exp = exp;
        }

        override Тип syntaxCopy()
        {
            auto t = new TypeTypeof(место, exp.syntaxCopy());
            t.syntaxCopyHelper(this);
            t.mod = mod;
            return t;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class TypeInstance : TypeQualified
    {
        TemplateInstance tempinst;

        final this(ref Место место, TemplateInstance tempinst)
        {
            super(Tinstance, место);
            this.tempinst = tempinst;
        }

        override Тип syntaxCopy()
        {
            auto t = new TypeInstance(место, cast(TemplateInstance)tempinst.syntaxCopy(null));
            t.syntaxCopyHelper(this);
            t.mod = mod;
            return t;
        }

        override Выражение toВыражение()
        {
            return toВыражениеHelper(new ScopeExp(место, tempinst));
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     abstract class Выражение : УзелАСД
    {
        ТОК2 op;
        ббайт size;
        ббайт parens;
        Тип тип;
        Место место;

        final this(ref Место место, ТОК2 op, цел size)
        {
            this.место = место;
            this.op = op;
            this.size = cast(ббайт)size;
        }

        Выражение syntaxCopy()
        {
            return копируй();
        }

        final проц выведиОшибку(ткст0 format, ...) 
        {
            if (тип != Тип.terror)
            {
                va_list ap;
                va_start(ap, format);
                verror(место, format, ap);
                va_end(ap);
            }
        }

        final Выражение копируй()
        {
            Выражение e;
            if (!size)
            {
                assert(0);
            }
            e = cast(Выражение)mem.xmalloc(size);
            return cast(Выражение)memcpy(cast(ук)e, cast(ук)this, size);
        }

        override final ДИНКАСТ динкаст()
        {
            return ДИНКАСТ.Выражение;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class DeclarationExp : Выражение
    {
        ДСимвол declaration;

        this(ref Место место, ДСимвол declaration)
        {
            super(место, ТОК2.declaration, __traits(classInstanceSize, DeclarationExp));
            this.declaration = declaration;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class IntegerExp : Выражение
    {
        dinteger_t значение;

        this(ref Место место, dinteger_t значение, Тип тип)
        {
            super(место, ТОК2.int64, __traits(classInstanceSize, IntegerExp));
            assert(тип);
            if (!тип.isscalar())
            {
                if (тип.ty != Terror)
                    выведиОшибку("integral constant must be scalar тип, not %s", тип.вТкст0());
                тип = Тип.terror;
            }
            this.тип = тип;
            setInteger(значение);
        }

        проц setInteger(dinteger_t значение)
        {
            this.значение = значение;
            normalize();
        }

        проц normalize()
        {
            /* 'Normalize' the значение of the integer to be in range of the тип
             */
            switch (тип.toBasetype().ty)
            {
            case Tbool:
                значение = (значение != 0);
                break;

            case Tint8:
                значение = cast(d_int8)значение;
                break;

            case Tchar:
            case Tuns8:
                значение = cast(d_uns8)значение;
                break;

            case Tint16:
                значение = cast(d_int16)значение;
                break;

            case Twchar:
            case Tuns16:
                значение = cast(d_uns16)значение;
                break;

            case Tint32:
                значение = cast(d_int32)значение;
                break;

            case Tdchar:
            case Tuns32:
                значение = cast(d_uns32)значение;
                break;

            case Tint64:
                значение = cast(d_int64)значение;
                break;

            case Tuns64:
                значение = cast(d_uns64)значение;
                break;

            case Tpointer:
                if (Target.ptrsize == 8)
                    goto case Tuns64;
                if (Target.ptrsize == 4)
                    goto case Tuns32;
                if (Target.ptrsize == 2)
                    goto case Tuns16;
                assert(0);

            default:
                break;
            }
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class NewAnonClassExp : Выражение
    {
        Выражение thisexp;     // if !=null, 'this' for class being allocated
        Выражения* newargs;   // МассивДРК of Выражение's to call new operator
        ClassDeclaration cd;    // class being instantiated
        Выражения* arguments; // МассивДРК of Выражение's to call class constructor

        this(ref Место место, Выражение thisexp, Выражения* newargs, ClassDeclaration cd, Выражения* arguments)
        {
            super(место, ТОК2.newAnonymousClass, __traits(classInstanceSize, NewAnonClassExp));
            this.thisexp = thisexp;
            this.newargs = newargs;
            this.cd = cd;
            this.arguments = arguments;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class IsExp : Выражение
    {
        Тип targ;
        Идентификатор2 ид;      // can be null
        Тип tspec;         // can be null
        ПараметрыШаблона* parameters;
        ТОК2 tok;            // ':' or '=='
        ТОК2 tok2;           // 'struct', 'union', etc.

        this(ref Место место, Тип targ, Идентификатор2 ид, ТОК2 tok, Тип tspec, ТОК2 tok2, ПараметрыШаблона* parameters)
        {
            super(место, ТОК2.is_, __traits(classInstanceSize, IsExp));
            this.targ = targ;
            this.ид = ид;
            this.tok = tok;
            this.tspec = tspec;
            this.tok2 = tok2;
            this.parameters = parameters;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class RealExp : Выражение
    {
        real_t значение;

        this(ref Место место, real_t значение, Тип тип)
        {
            super(место, ТОК2.float64, __traits(classInstanceSize, RealExp));
            this.значение = значение;
            this.тип = тип;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class NullExp : Выражение
    {
        this(ref Место место, Тип тип = null)
        {
            super(место, ТОК2.null_, __traits(classInstanceSize, NullExp));
            this.тип = тип;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class TypeidExp : Выражение
    {
        КорневойОбъект obj;

        this(ref Место место, КорневойОбъект o)
        {
            super(место, ТОК2.typeid_, __traits(classInstanceSize, TypeidExp));
            this.obj = o;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class TraitsExp : Выражение
    {
        Идентификатор2 идент;
        Объекты* args;

        this(ref Место место, Идентификатор2 идент, Объекты* args)
        {
            super(место, ТОК2.traits, __traits(classInstanceSize, TraitsExp));
            this.идент = идент;
            this.args = args;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class StringExp : Выражение
    {
        union
        {
            ткст0 ткст;   // if sz == 1
            wchar* wstring; // if sz == 2
            dchar* dstring; // if sz == 4
        }                   // (const if ownedByCtfe == OwnedBy.code)
        т_мера len;         // number of code units
        ббайт sz = 1;       // 1: сим, 2: wchar, 4: dchar
        сим postfix = 0;   // 'c', 'w', 'd'

        this(ref Место место, проц[] ткст)
        {
            super(место, ТОК2.string_, __traits(classInstanceSize, StringExp));
            this.ткст = cast(сим*)ткст.ptr;
            this.len = ткст.length;
            this.sz = 1;                    // work around LDC bug #1286
        }

        this(ref Место место, проц[] ткст, т_мера len, ббайт sz, сим postfix = 0)
        {
            super(место, ТОК2.string_, __traits(classInstanceSize, StringExp));
            this.ткст = cast(сим*)ткст;
            this.len = len;
            this.postfix = postfix;
            this.sz = 1;                    // work around LDC bug #1286
        }

        /**********************************************
        * Write the contents of the ткст to dest.
        * Use numberOfCodeUnits() to determine size of результат.
        * Параметры:
        *  dest = destination
        *  tyto = encoding тип of the результат
        *  нуль = add terminating 0
        */
        проц writeTo(ук dest, бул нуль, цел tyto = 0)
        {
            цел encSize;
            switch (tyto)
            {
                case 0:      encSize = sz; break;
                case Tchar:  encSize = 1; break;
                case Twchar: encSize = 2; break;
                case Tdchar: encSize = 4; break;
                default:
                    assert(0);
            }
            if (sz == encSize)
            {
                memcpy(dest, ткст, len * sz);
                if (нуль)
                    memset(dest + len * sz, 0, sz);
            }
            else
                assert(0);
        }

        extern (D) ткст вТкст0()
        {
            auto члобайт = len * sz;
            ткст0 s = cast(сим*)mem.xmalloc_noscan(члобайт + sz);
            writeTo(s, да);
            return s[0 .. члобайт];
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     class NewExp : Выражение
    {
        Выражение thisexp;         // if !=null, 'this' for class being allocated
        Выражения* newargs;       // МассивДРК of Выражение's to call new operator
        Тип newtype;
        Выражения* arguments;     // МассивДРК of Выражение's

        this(ref Место место, Выражение thisexp, Выражения* newargs, Тип newtype, Выражения* arguments)
        {
            super(место, ТОК2.new_, __traits(classInstanceSize, NewExp));
            this.thisexp = thisexp;
            this.newargs = newargs;
            this.newtype = newtype;
            this.arguments = arguments;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class AssocArrayLiteralExp : Выражение
    {
        Выражения* keys;
        Выражения* values;

        this(ref Место место, Выражения* keys, Выражения* values)
        {
            super(место, ТОК2.assocArrayLiteral, __traits(classInstanceSize, AssocArrayLiteralExp));
            assert(keys.dim == values.dim);
            this.keys = keys;
            this.values = values;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class ArrayLiteralExp : Выражение
    {
        Выражение basis;
        Выражения* elements;

        this(ref Место место, Выражения* elements)
        {
            super(место, ТОК2.arrayLiteral, __traits(classInstanceSize, ArrayLiteralExp));
            this.elements = elements;
        }

        this(ref Место место, Выражение e)
        {
            super(место, ТОК2.arrayLiteral, __traits(classInstanceSize, ArrayLiteralExp));
            elements = new Выражения();
            elements.сунь(e);
        }

        this(ref Место место, Выражение basis, Выражения* elements)
        {
            super(место, ТОК2.arrayLiteral, __traits(classInstanceSize, ArrayLiteralExp));
            this.basis = basis;
            this.elements = elements;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class FuncExp : Выражение
    {
        FuncLiteralDeclaration fd;
        TemplateDeclaration td;
        ТОК2 tok;

        this(ref Место место, ДСимвол s)
        {
            super(место, ТОК2.function_, __traits(classInstanceSize, FuncExp));
            this.td = s.isTemplateDeclaration();
            this.fd = s.isFuncLiteralDeclaration();
            if (td)
            {
                assert(td.literal);
                assert(td.члены && td.члены.dim == 1);
                fd = (*td.члены)[0].isFuncLiteralDeclaration();
            }
            tok = fd.tok; // save original вид of function/delegate/(infer)
            assert(fd.fbody);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class IntervalExp : Выражение
    {
        Выражение lwr;
        Выражение upr;

        this(ref Место место, Выражение lwr, Выражение upr)
        {
            super(место, ТОК2.interval, __traits(classInstanceSize, IntervalExp));
            this.lwr = lwr;
            this.upr = upr;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class TypeExp : Выражение
    {
        this(ref Место место, Тип тип)
        {
            super(место, ТОК2.тип, __traits(classInstanceSize, TypeExp));
            this.тип = тип;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class ScopeExp : Выражение
    {
        ScopeDsymbol sds;

        this(ref Место место, ScopeDsymbol sds)
        {
            super(место, ТОК2.scope_, __traits(classInstanceSize, ScopeExp));
            this.sds = sds;
            assert(!sds.isTemplateDeclaration());
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     class IdentifierExp : Выражение
    {
        Идентификатор2 идент;

        final this(ref Место место, Идентификатор2 идент)
        {
            super(место, ТОК2.идентификатор, __traits(classInstanceSize, IdentifierExp));
            this.идент = идент;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     class UnaExp : Выражение
    {
        Выражение e1;

        final this(ref Место место, ТОК2 op, цел size, Выражение e1)
        {
            super(место, op, size);
            this.e1 = e1;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     class DefaultInitExp : Выражение
    {
        ТОК2 subop;      // which of the derived classes this is

        final this(ref Место место, ТОК2 subop, цел size)
        {
            super(место, ТОК2.default_, size);
            this.subop = subop;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     abstract class BinExp : Выражение
    {
        Выражение e1;
        Выражение e2;

        final this(ref Место место, ТОК2 op, цел size, Выражение e1, Выражение e2)
        {
            super(место, op, size);
            this.e1 = e1;
            this.e2 = e2;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class DsymbolExp : Выражение
    {
        ДСимвол s;
        бул hasOverloads;

        this(ref Место место, ДСимвол s, бул hasOverloads = да)
        {
            super(место, ТОК2.dSymbol, __traits(classInstanceSize, DsymbolExp));
            this.s = s;
            this.hasOverloads = hasOverloads;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class TemplateExp : Выражение
    {
        TemplateDeclaration td;
        FuncDeclaration fd;

        this(ref Место место, TemplateDeclaration td, FuncDeclaration fd = null)
        {
            super(место, ТОК2.template_, __traits(classInstanceSize, TemplateExp));
            //printf("TemplateExp(): %s\n", td.вТкст0());
            this.td = td;
            this.fd = fd;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     class SymbolExp : Выражение
    {
        Declaration var;
        бул hasOverloads;

        final this(ref Место место, ТОК2 op, цел size, Declaration var, бул hasOverloads)
        {
            super(место, op, size);
            assert(var);
            this.var = var;
            this.hasOverloads = hasOverloads;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class VarExp : SymbolExp
    {
        this(ref Место место, Declaration var, бул hasOverloads = да)
        {
            if (var.isVarDeclaration())
                hasOverloads = нет;

            super(место, ТОК2.variable, __traits(classInstanceSize, VarExp), var, hasOverloads);
            this.тип = var.тип;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class TupleExp : Выражение
    {
        Выражение e0;
        Выражения* exps;

        this(ref Место место, Выражение e0, Выражения* exps)
        {
            super(место, ТОК2.кортеж, __traits(classInstanceSize, TupleExp));
            //printf("TupleExp(this = %p)\n", this);
            this.e0 = e0;
            this.exps = exps;
        }

        this(ref Место место, Выражения* exps)
        {
            super(место, ТОК2.кортеж, __traits(classInstanceSize, TupleExp));
            //printf("TupleExp(this = %p)\n", this);
            this.exps = exps;
        }

        this(ref Место место, TupleDeclaration tup)
        {
            super(место, ТОК2.кортеж, __traits(classInstanceSize, TupleExp));
            this.exps = new Выражения();

            this.exps.резервируй(tup.objects.dim);
            for (т_мера i = 0; i < tup.objects.dim; i++)
            {
                КорневойОбъект o = (*tup.objects)[i];
                if (ДСимвол s = getDsymbol(o))
                {
                    Выражение e = new DsymbolExp(место, s);
                    this.exps.сунь(e);
                }
                else if (o.динкаст() == ДИНКАСТ.Выражение)
                {
                    auto e = (cast(Выражение)o).копируй();
                    e.место = место;    // Bugzilla 15669
                    this.exps.сунь(e);
                }
                else if (o.динкаст() == ДИНКАСТ.тип)
                {
                    Тип t = cast(Тип)o;
                    Выражение e = new TypeExp(место, t);
                    this.exps.сунь(e);
                }
                else
                {
                    выведиОшибку("%s is not an Выражение", o.вТкст0());
                }
            }
        }

         ДСимвол isDsymbol(КорневойОбъект o)
        {
            if (!o || o.динкаст || ДИНКАСТ.дсимвол)
                return null;
            return cast(ДСимвол)o;
        }

         ДСимвол getDsymbol(КорневойОбъект oarg)
        {
            ДСимвол sa;
            Выражение ea = выражение_ли(oarg);
            if (ea)
            {
                // Try to convert Выражение to symbol
                if (ea.op == ТОК2.variable)
                    sa = (cast(VarExp)ea).var;
                else if (ea.op == ТОК2.function_)
                {
                    if ((cast(FuncExp)ea).td)
                        sa = (cast(FuncExp)ea).td;
                    else
                        sa = (cast(FuncExp)ea).fd;
                }
                else if (ea.op == ТОК2.template_)
                    sa = (cast(TemplateExp)ea).td;
                else
                    sa = null;
            }
            else
            {
                // Try to convert Тип to symbol
                Тип ta = тип_ли(oarg);
                if (ta)
                    sa = ta.toDsymbol(null);
                else
                    sa = isDsymbol(oarg); // if already a symbol
            }
            return sa;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class DollarExp : IdentifierExp
    {
        this(ref Место место)
        {
            super(место, Id.dollar);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     class ThisExp : Выражение
    {
        final this(ref Место место)
        {
            super(место, ТОК2.this_, __traits(classInstanceSize, ThisExp));
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class SuperExp : ThisExp
    {
        this(ref Место место)
        {
            super(место);
            op = ТОК2.super_;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class AddrExp : UnaExp
    {
        this(ref Место место, Выражение e)
        {
            super(место, ТОК2.address, __traits(classInstanceSize, AddrExp), e);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class PreExp : UnaExp
    {
        this(ТОК2 op, Место место, Выражение e)
        {
            super(место, op, __traits(classInstanceSize, PreExp), e);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class PtrExp : UnaExp
    {
        this(ref Место место, Выражение e)
        {
            super(место, ТОК2.star, __traits(classInstanceSize, PtrExp), e);
        }
        this(ref Место место, Выражение e, Тип t)
        {
            super(место, ТОК2.star, __traits(classInstanceSize, PtrExp), e);
            тип = t;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class NegExp : UnaExp
    {
        this(ref Место место, Выражение e)
        {
            super(место, ТОК2.negate, __traits(classInstanceSize, NegExp), e);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class UAddExp : UnaExp
    {
        this(ref Место место, Выражение e)
        {
            super(место, ТОК2.uadd, __traits(classInstanceSize, UAddExp), e);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class NotExp : UnaExp
    {
        this(ref Место место, Выражение e)
        {
            super(место, ТОК2.not, __traits(classInstanceSize, NotExp), e);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class ComExp : UnaExp
    {
        this(ref Место место, Выражение e)
        {
            super(место, ТОК2.tilde, __traits(classInstanceSize, ComExp), e);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class DeleteExp : UnaExp
    {
        бул isRAII;

        this(ref Место место, Выражение e, бул isRAII)
        {
            super(место, ТОК2.delete_, __traits(classInstanceSize, DeleteExp), e);
            this.isRAII = isRAII;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class CastExp : UnaExp
    {
        Тип to;
        ббайт mod = cast(ббайт)~0;

        this(ref Место место, Выражение e, Тип t)
        {
            super(место, ТОК2.cast_, __traits(classInstanceSize, CastExp), e);
            this.to = t;
        }
        this(ref Место место, Выражение e, ббайт mod)
        {
            super(место, ТОК2.cast_, __traits(classInstanceSize, CastExp), e);
            this.mod = mod;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class CallExp : UnaExp
    {
        Выражения* arguments;

        this(ref Место место, Выражение e, Выражения* exps)
        {
            super(место, ТОК2.call, __traits(classInstanceSize, CallExp), e);
            this.arguments = exps;
        }

        this(ref Место место, Выражение e)
        {
            super(место, ТОК2.call, __traits(classInstanceSize, CallExp), e);
        }

        this(ref Место место, Выражение e, Выражение earg1)
        {
            super(место, ТОК2.call, __traits(classInstanceSize, CallExp), e);
            auto arguments = new Выражения();
            if (earg1)
            {
                arguments.устДим(1);
                (*arguments)[0] = earg1;
            }
            this.arguments = arguments;
        }

        this(ref Место место, Выражение e, Выражение earg1, Выражение earg2)
        {
            super(место, ТОК2.call, __traits(classInstanceSize, CallExp), e);
            auto arguments = new Выражения();
            arguments.устДим(2);
            (*arguments)[0] = earg1;
            (*arguments)[1] = earg2;
            this.arguments = arguments;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class DotIdExp : UnaExp
    {
        Идентификатор2 идент;

        this(ref Место место, Выражение e, Идентификатор2 идент)
        {
            super(место, ТОК2.dotIdentifier, __traits(classInstanceSize, DotIdExp), e);
            this.идент = идент;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class AssertExp : UnaExp
    {
        Выражение msg;

        this(ref Место место, Выражение e, Выражение msg = null)
        {
            super(место, ТОК2.assert_, __traits(classInstanceSize, AssertExp), e);
            this.msg = msg;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class CompileExp : Выражение
    {
        Выражения* exps;

        this(ref Место место, Выражения* exps)
        {
            super(место, ТОК2.mixin_, __traits(classInstanceSize, CompileExp));
            this.exps = exps;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class ImportExp : UnaExp
    {
        this(ref Место место, Выражение e)
        {
            super(место, ТОК2.import_, __traits(classInstanceSize, ImportExp), e);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class DotTemplateInstanceExp : UnaExp
    {
        TemplateInstance ti;

        this(ref Место место, Выражение e, Идентификатор2 имя, Объекты* tiargs)
        {
            super(место, ТОК2.dotTemplateInstance, __traits(classInstanceSize, DotTemplateInstanceExp), e);
            this.ti = new TemplateInstance(место, имя, tiargs);
        }
        this(ref Место место, Выражение e, TemplateInstance ti)
        {
            super(место, ТОК2.dotTemplateInstance, __traits(classInstanceSize, DotTemplateInstanceExp), e);
            this.ti = ti;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class ArrayExp : UnaExp
    {
        Выражения* arguments;

        this(ref Место место, Выражение e1, Выражение index = null)
        {
            super(место, ТОК2.массив, __traits(classInstanceSize, ArrayExp), e1);
            arguments = new Выражения();
            if (index)
                arguments.сунь(index);
        }

        this(ref Место место, Выражение e1, Выражения* args)
        {
            super(место, ТОК2.массив, __traits(classInstanceSize, ArrayExp), e1);
            arguments = args;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class FuncInitExp : DefaultInitExp
    {
        this(ref Место место)
        {
            super(место, ТОК2.functionString, __traits(classInstanceSize, FuncInitExp));
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class PrettyFuncInitExp : DefaultInitExp
    {
        this(ref Место место)
        {
            super(место, ТОК2.prettyFunction, __traits(classInstanceSize, PrettyFuncInitExp));
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class FileInitExp : DefaultInitExp
    {
        this(ref Место место, ТОК2 tok)
        {
            super(место, tok, __traits(classInstanceSize, FileInitExp));
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class LineInitExp : DefaultInitExp
    {
        this(ref Место место)
        {
            super(место, ТОК2.line, __traits(classInstanceSize, LineInitExp));
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class ModuleInitExp : DefaultInitExp
    {
        this(ref Место место)
        {
            super(место, ТОК2.moduleString, __traits(classInstanceSize, ModuleInitExp));
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class CommaExp : BinExp
    {
        const бул isGenerated;
        бул allowCommaExp;

        this(ref Место место, Выражение e1, Выражение e2, бул generated = да)
        {
            super(место, ТОК2.comma, __traits(classInstanceSize, CommaExp), e1, e2);
            allowCommaExp = isGenerated = generated;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class PostExp : BinExp
    {
        this(ТОК2 op, Место место, Выражение e)
        {
            super(место, op, __traits(classInstanceSize, PostExp), e, new IntegerExp(место, 1, Тип.tint32));
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class PowExp : BinExp
    {
        this(ref Место место, Выражение e1, Выражение e2)
        {
            super(место, ТОК2.pow, __traits(classInstanceSize, PowExp), e1, e2);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class MulExp : BinExp
    {
        this(ref Место место, Выражение e1, Выражение e2)
        {
            super(место, ТОК2.mul, __traits(classInstanceSize, MulExp), e1, e2);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class DivExp : BinExp
    {
        this(ref Место место, Выражение e1, Выражение e2)
        {
            super(место, ТОК2.div, __traits(classInstanceSize, DivExp), e1, e2);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class ModExp : BinExp
    {
        this(ref Место место, Выражение e1, Выражение e2)
        {
            super(место, ТОК2.mod, __traits(classInstanceSize, ModExp), e1, e2);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class AddExp : BinExp
    {
        this(ref Место место, Выражение e1, Выражение e2)
        {
            super(место, ТОК2.add, __traits(classInstanceSize, AddExp), e1, e2);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class MinExp : BinExp
    {
        this(ref Место место, Выражение e1, Выражение e2)
        {
            super(место, ТОК2.min, __traits(classInstanceSize, MinExp), e1, e2);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class CatExp : BinExp
    {
        this(ref Место место, Выражение e1, Выражение e2)
        {
            super(место, ТОК2.concatenate, __traits(classInstanceSize, CatExp), e1, e2);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class ShlExp : BinExp
    {
        this(ref Место место, Выражение e1, Выражение e2)
        {
            super(место, ТОК2.leftShift, __traits(classInstanceSize, ShlExp), e1, e2);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class ShrExp : BinExp
    {
        this(ref Место место, Выражение e1, Выражение e2)
        {
            super(место, ТОК2.rightShift, __traits(classInstanceSize, ShrExp), e1, e2);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class UshrExp : BinExp
    {
        this(ref Место место, Выражение e1, Выражение e2)
        {
            super(место, ТОК2.unsignedRightShift, __traits(classInstanceSize, UshrExp), e1, e2);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class EqualExp : BinExp
    {
        this(ТОК2 op, Место место, Выражение e1, Выражение e2)
        {
            super(место, op, __traits(classInstanceSize, EqualExp), e1, e2);
            assert(op == ТОК2.equal || op == ТОК2.notEqual);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class InExp : BinExp
    {
        this(ref Место место, Выражение e1, Выражение e2)
        {
            super(место, ТОК2.in_, __traits(classInstanceSize, InExp), e1, e2);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class IdentityExp : BinExp
    {
        this(ТОК2 op, Место место, Выражение e1, Выражение e2)
        {
            super(место, op, __traits(classInstanceSize, IdentityExp), e1, e2);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class CmpExp : BinExp
    {
        this(ТОК2 op, Место место, Выражение e1, Выражение e2)
        {
            super(место, op, __traits(classInstanceSize, CmpExp), e1, e2);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class AndExp : BinExp
    {
        this(ref Место место, Выражение e1, Выражение e2)
        {
            super(место, ТОК2.and, __traits(classInstanceSize, AndExp), e1, e2);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class XorExp : BinExp
    {
        this(ref Место место, Выражение e1, Выражение e2)
        {
            super(место, ТОК2.xor, __traits(classInstanceSize, XorExp), e1, e2);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class OrExp : BinExp
    {
        this(ref Место место, Выражение e1, Выражение e2)
        {
            super(место, ТОК2.or, __traits(classInstanceSize, OrExp), e1, e2);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class LogicalExp : BinExp
    {
        this(ref Место место, ТОК2 op, Выражение e1, Выражение e2)
        {
            super(место, op, __traits(classInstanceSize, LogicalExp), e1, e2);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class CondExp : BinExp
    {
        Выражение econd;

        this(ref Место место, Выражение econd, Выражение e1, Выражение e2)
        {
            super(место, ТОК2.question, __traits(classInstanceSize, CondExp), e1, e2);
            this.econd = econd;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class AssignExp : BinExp
    {
        this(ref Место место, Выражение e1, Выражение e2)
        {
            super(место, ТОК2.assign, __traits(classInstanceSize, AssignExp), e1, e2);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     class BinAssignExp : BinExp
    {
        final this(ref Место место, ТОК2 op, цел size, Выражение e1, Выражение e2)
        {
            super(место, op, size, e1, e2);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class AddAssignExp : BinAssignExp
    {
        this(ref Место место, Выражение e1, Выражение e2)
        {
            super(место, ТОК2.addAssign, __traits(classInstanceSize, AddAssignExp), e1, e2);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class MinAssignExp : BinAssignExp
    {
        this(ref Место место, Выражение e1, Выражение e2)
        {
            super(место, ТОК2.minAssign, __traits(classInstanceSize, MinAssignExp), e1, e2);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class MulAssignExp : BinAssignExp
    {
        this(ref Место место, Выражение e1, Выражение e2)
        {
            super(место, ТОК2.mulAssign, __traits(classInstanceSize, MulAssignExp), e1, e2);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class DivAssignExp : BinAssignExp
    {
        this(ref Место место, Выражение e1, Выражение e2)
        {
            super(место, ТОК2.divAssign, __traits(classInstanceSize, DivAssignExp), e1, e2);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class ModAssignExp : BinAssignExp
    {
        this(ref Место место, Выражение e1, Выражение e2)
        {
            super(место, ТОК2.modAssign, __traits(classInstanceSize, ModAssignExp), e1, e2);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class PowAssignExp : BinAssignExp
    {
        this(ref Место место, Выражение e1, Выражение e2)
        {
            super(место, ТОК2.powAssign, __traits(classInstanceSize, PowAssignExp), e1, e2);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class AndAssignExp : BinAssignExp
    {
        this(ref Место место, Выражение e1, Выражение e2)
        {
            super(место, ТОК2.andAssign, __traits(classInstanceSize, AndAssignExp), e1, e2);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class OrAssignExp : BinAssignExp
    {
        this(ref Место место, Выражение e1, Выражение e2)
        {
            super(место, ТОК2.orAssign, __traits(classInstanceSize, OrAssignExp), e1, e2);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class XorAssignExp : BinAssignExp
    {
        this(ref Место место, Выражение e1, Выражение e2)
        {
            super(место, ТОК2.xorAssign, __traits(classInstanceSize, XorAssignExp), e1, e2);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class ShlAssignExp : BinAssignExp
    {
        this(ref Место место, Выражение e1, Выражение e2)
        {
            super(место, ТОК2.leftShiftAssign, __traits(classInstanceSize, ShlAssignExp), e1, e2);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class ShrAssignExp : BinAssignExp
    {
        this(ref Место место, Выражение e1, Выражение e2)
        {
            super(место, ТОК2.rightShiftAssign, __traits(classInstanceSize, ShrAssignExp), e1, e2);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class UshrAssignExp : BinAssignExp
    {
        this(ref Место место, Выражение e1, Выражение e2)
        {
            super(место, ТОК2.unsignedRightShiftAssign, __traits(classInstanceSize, UshrAssignExp), e1, e2);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class CatAssignExp : BinAssignExp
    {
        this(ref Место место, Выражение e1, Выражение e2)
        {
            super(место, ТОК2.concatenateAssign, __traits(classInstanceSize, CatAssignExp), e1, e2);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     class ПараметрШаблона2 : УзелАСД
    {
        Место место;
        Идентификатор2 идент;

        final this(ref Место место, Идентификатор2 идент)
        {
            this.место = место;
            this.идент = идент;
        }

        ПараметрШаблона2 syntaxCopy(){ return null;}

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class TemplateAliasParameter : ПараметрШаблона2
    {
        Тип specType;
        КорневойОбъект specAlias;
        КорневойОбъект defaultAlias;

        this(ref Место место, Идентификатор2 идент, Тип specType, КорневойОбъект specAlias, КорневойОбъект defaultAlias)
        {
            super(место, идент);
            this.идент = идент;
            this.specType = specType;
            this.specAlias = specAlias;
            this.defaultAlias = defaultAlias;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     class TemplateTypeParameter : ПараметрШаблона2
    {
        Тип specType;
        Тип defaultType;

        final this(ref Место место, Идентификатор2 идент, Тип specType, Тип defaultType)
        {
            super(место, идент);
            this.идент = идент;
            this.specType = specType;
            this.defaultType = defaultType;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class TemplateTupleParameter : ПараметрШаблона2
    {
        this(ref Место место, Идентификатор2 идент)
        {
            super(место, идент);
            this.идент = идент;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class TemplateValueParameter : ПараметрШаблона2
    {
        Тип valType;
        Выражение specValue;
        Выражение defaultValue;

        this(ref Место место, Идентификатор2 идент, Тип valType,
            Выражение specValue, Выражение defaultValue)
        {
            super(место, идент);
            this.идент = идент;
            this.valType = valType;
            this.specValue = specValue;
            this.defaultValue = defaultValue;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class TemplateThisParameter : TemplateTypeParameter
    {
        this(ref Место место, Идентификатор2 идент, Тип specType, Тип defaultType)
        {
            super(место, идент, specType, defaultType);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     abstract class Condition : УзелАСД
    {
        Место место;

        final this(ref Место место)
        {
            this.место = место;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class StaticForeach : КорневойОбъект
    {
        Место место;

        ForeachStatement aggrfe;
        ForeachRangeStatement rangefe;

        final this(ref Место место, ForeachStatement aggrfe, ForeachRangeStatement rangefe)
        in
        {
            assert(!!aggrfe ^ !!rangefe);
        }
        body
        {
            this.место = место;
            this.aggrfe = aggrfe;
            this.rangefe = rangefe;
        }
    }

     final class StaticIfCondition : Condition
    {
        Выражение exp;

        final this(ref Место место, Выражение exp)
        {
            super(место);
            this.exp = exp;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     class DVCondition : Condition
    {
        бцел уровень;
        Идентификатор2 идент;
        Module mod;

        final this(Module mod, бцел уровень, Идентификатор2 идент)
        {
            super(Место.initial);
            this.mod = mod;
            this.идент = идент;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class DebugCondition : DVCondition
    {
        this(Module mod, бцел уровень, Идентификатор2 идент)
        {
            super(mod, уровень, идент);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class VersionCondition : DVCondition
    {
        this(Module mod, бцел уровень, Идентификатор2 идент)
        {
            super(mod, уровень, идент);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

    enum InitKind : ббайт
    {
        void_,
        error,
        struct_,
        массив,
        exp,
    }

     class Инициализатор : УзелАСД
    {
        Место место;
        InitKind вид;

        final this(ref Место место, InitKind вид)
        {
            this.место = место;
            this.вид = вид;
        }

        // this should be abstract and implemented in child classes
        Выражение toВыражение(Тип t = null)
        {
            return null;
        }

        final ExpInitializer isExpInitializer()
        {
            return вид == InitKind.exp ? cast(ExpInitializer)cast(ук)this : null;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class ExpInitializer : Инициализатор
    {
        Выражение exp;

        this(ref Место место, Выражение exp)
        {
            super(место, InitKind.exp);
            this.exp = exp;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class StructInitializer : Инициализатор
    {
        Идентификаторы field;
        Инициализаторы значение;

        this(ref Место место)
        {
            super(место, InitKind.struct_);
        }

        проц addInit(Идентификатор2 field, Инициализатор значение)
        {
            this.field.сунь(field);
            this.значение.сунь(значение);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class ArrayInitializer : Инициализатор
    {
        Выражения index;
        Инициализаторы значение;
        бцел dim;
        Тип тип;

        this(ref Место место)
        {
            super(место, InitKind.массив);
        }

        проц addInit(Выражение index, Инициализатор значение)
        {
            this.index.сунь(index);
            this.значение.сунь(значение);
            dim = 0;
            тип = null;
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class VoidInitializer : Инициализатор
    {
        this(ref Место место)
        {
            super(место, InitKind.void_);
        }

        override проц прими(Визитор2 v)
        {
            v.посети(this);
        }
    }

     final class Tuple : КорневойОбъект
    {
        Объекты objects;

        // kludge for template.тип_ли()
        override ДИНКАСТ динкаст() 
        {
            return ДИНКАСТ.кортеж;
        }

        override ткст0 вТкст0()
        {
            return objects.вТкст0();
        }
    }

    struct КлассОснова2
    {
        Тип тип;
    }

    struct ModuleDeclaration
    {
        Место место;
        Идентификатор2 ид;
        Идентификаторы *пакеты;
        бул isdeprecated;
        Выражение msg;

        this(ref Место место, Идентификаторы* пакеты, Идентификатор2 ид, Выражение msg, бул isdeprecated)
        {
            this.место = место;
            this.пакеты = пакеты;
            this.ид = ид;
            this.msg = msg;
            this.isdeprecated = isdeprecated;
        }

         ткст0 вТкст0()
        {
            БуфВыв буф;
            if (пакеты && пакеты.dim)
            {
                for (т_мера i = 0; i < пакеты.dim; i++)
                {
                    const Идентификатор2 pid = (*пакеты)[i];
                    буф.пишиСтр(pid.вТкст());
                    буф.пишиБайт('.');
                }
            }
            буф.пишиСтр(ид.вТкст());
            return буф.extractChars();
        }
    }

    struct Prot
    {
        enum Kind : цел
        {
            undefined,
            none,
            private_,
            package_,
            protected_,
            public_,
            export_,
        }
        Kind вид;
        Package pkg;
    }

    struct Scope
    {

    }

    static  Tuple кортеж_ли(КорневойОбъект o)
    {
        //return dynamic_cast<Tuple *>(o);
        if (!o || o.динкаст() != ДИНКАСТ.кортеж)
            return null;
        return cast(Tuple)o;
    }

    static  Тип тип_ли(КорневойОбъект o)
    {
        if (!o || o.динкаст() != ДИНКАСТ.тип)
            return null;
        return cast(Тип)o;
    }

    static  Выражение выражение_ли(КорневойОбъект o)
    {
        if (!o || o.динкаст() != ДИНКАСТ.Выражение)
            return null;
        return cast(Выражение)o;
    }

    static  ПараметрШаблона2 isTemplateParameter(КорневойОбъект o)
    {
        if (!o || o.динкаст() != ДИНКАСТ.шаблонпараметр)
            return null;
        return cast(ПараметрШаблона2)o;
    }


    static ткст0 защитуВТкст0(Prot.Kind вид)
    {
        switch (вид)
        {
        case Prot.Kind.undefined:
            return null;
        case Prot.Kind.none:
            return "none";
        case Prot.Kind.private_:
            return "private";
        case Prot.Kind.package_:
            return "package";
        case Prot.Kind.protected_:
            return "protected";
        case Prot.Kind.public_:
            return "public";
        case Prot.Kind.export_:
            return "export";
        }
    }

    static бул stcToBuffer(БуфВыв* буф, КлассХранения stc)
    {
        бул результат = нет;
        if ((stc & (STC.return_ | STC.scope_)) == (STC.return_ | STC.scope_))
            stc &= ~STC.scope_;
        while (stc)
        {
            ткст0 p = stcToChars(stc);
            if (!p) // there's no visible storage classes
                break;
            if (!результат)
                результат = да;
            else
                буф.пишиБайт(' ');
            буф.пишиСтр(p);
        }
        return результат;
    }

    static  Выражение типВВыражение(Тип t)
    {
        return t.toВыражение;
    }

    static ткст0 stcToChars(ref КлассХранения stc)
    {
        struct SCstring
        {
            КлассХранения stc;
            ТОК2 tok;
            ткст0 ид;
        }

         SCstring* table =
        [
            SCstring(STC.auto_, ТОК2.auto_),
            SCstring(STC.scope_, ТОК2.scope_),
            SCstring(STC.static_, ТОК2.static_),
            SCstring(STC.extern_, ТОК2.extern_),
            SCstring(STC.const_, ТОК2.const_),
            SCstring(STC.final_, ТОК2.final_),
            SCstring(STC.abstract_, ТОК2.abstract_),
            SCstring(STC.synchronized_, ТОК2.synchronized_),
            SCstring(STC.deprecated_, ТОК2.deprecated_),
            SCstring(STC.override_, ТОК2.override_),
            SCstring(STC.lazy_, ТОК2.lazy_),
            SCstring(STC.alias_, ТОК2.alias_),
            SCstring(STC.out_, ТОК2.out_),
            SCstring(STC.in_, ТОК2.in_),
            SCstring(STC.manifest, ТОК2.enum_),
            SCstring(STC.immutable_, ТОК2.immutable_),
            SCstring(STC.shared_, ТОК2.shared_),
            SCstring(STC.nothrow_, ТОК2.nothrow_),
            SCstring(STC.wild, ТОК2.inout_),
            SCstring(STC.pure_, ТОК2.pure_),
            SCstring(STC.ref_, ТОК2.ref_),
            SCstring(STC.tls),
            SCstring(STC.gshared, ТОК2.gshared),
            SCstring(STC.nogc, ТОК2.at, ""),
            SCstring(STC.property, ТОК2.at, ""),
            SCstring(STC.safe, ТОК2.at, ""),
            SCstring(STC.trusted, ТОК2.at, "@trusted"),
            SCstring(STC.system, ТОК2.at, "@system"),
            SCstring(STC.live, ТОК2.at, "@live"),
            SCstring(STC.disable, ТОК2.at, "@disable"),
            SCstring(STC.future, ТОК2.at, "@__future"),
            SCstring(0, ТОК2.reserved)
        ];
        for (цел i = 0; table[i].stc; i++)
        {
            КлассХранения tbl = table[i].stc;
            assert(tbl & STCStorageClass);
            if (stc & tbl)
            {
                stc &= ~tbl;
                if (tbl == STC.tls) // TOKtls was removed
                    return "__thread";
                ТОК2 tok = table[i].tok;
                if (tok == ТОК2.at)
                    return table[i].ид;
                else
                    return Сема2.вТкст0(tok);
            }
        }
        //printf("stc = %llx\n", stc);
        return null;
    }

    static ткст0 компонажВТкст0(LINK компонаж)
    {
        switch (компонаж)
        {
        case LINK.default_:
        case LINK.system:
            return null;
        case LINK.d:
            return "D";
        case LINK.c:
            return "C";
        case LINK.cpp:
            return "C++";
        case LINK.windows:
            return "Windows";
        case LINK.pascal:
            return "Pascal";
        case LINK.objc:
            return "Objective-C";
        }
    }

    struct Target
    {
          цел ptrsize;

         static Тип va_listType()
        {
            if (глоб2.парамы.isWindows)
            {
                return Тип.tchar.pointerTo();
            }
            else if (глоб2.парамы.isLinux || глоб2.парамы.isFreeBSD || глоб2.парамы.isOpenBSD  || глоб2.парамы.isDragonFlyBSD ||
                глоб2.парамы.isSolaris || глоб2.парамы.isOSX)
            {
                if (глоб2.парамы.is64bit)
                {
                    return (new TypeIdentifier(Место.initial, Идентификатор2.idPool("__va_list_tag"))).pointerTo();
                }
                else
                {
                    return Тип.tchar.pointerTo();
                }
            }
            else
            {
                assert(0);
            }
        }
    }
}
