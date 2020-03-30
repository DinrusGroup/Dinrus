/**
 * Compiler implementation of the $(LINK2 http://www.dlang.org, D programming language)
 *
 * Do mangling for C++ компонаж.
 * This is the POSIX side of the implementation.
 * It exports two functions to C++, `toCppMangleItanium` and `cppTypeInfoMangleItanium`.
 *
 * Copyright: Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors: Walter Bright, http://www.digitalmars.com
 * License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:    $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/cppmangle.d, _cppmangle.d)
 * Documentation:  https://dlang.org/phobos/dmd_cppmangle.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/cppmangle.d
 *
 * References:
 *  Follows Itanium C++ ABI 1.86 section 5.1
 *  http://refspecs.linux-foundation.org/cxxabi-1.86.html#mangling
 *  which is where the grammar comments come from.
 *
 * Bugs:
 *  https://issues.dlang.org/query.cgi
 *  enter `C++, mangling` as the keywords.
 */

module dmd.cppmangle;

import cidrus;

import dmd.arraytypes;
import dmd.attrib;
import dmd.declaration;
import dmd.дсимвол;
import dmd.dtemplate;
import dmd.errors;
import drc.ast.Expression;
import dmd.func;
import dmd.globals;
import drc.lexer.Id;
import drc.lexer.Identifier;
import dmd.mtype;
import dmd.nspace;
import util.outbuffer;
import drc.ast.Node;
import dmd.target;
import drc.lexer.Tokens;
import dmd.typesem;
import drc.ast.Visitor;


// helper to check if an идентификатор is a C++ operator
enum CppOperator { Cast, Assign, Eq, Index, Call, Unary, Binary, OpAssign, Unknown }
package CppOperator isCppOperator(Идентификатор2 ид)
{
     Идентификатор2[] operators = null;
    if (!operators)
        operators = [Id._cast, Id.assign, Id.eq, Id.index, Id.call, Id.opUnary, Id.opBinary, Id.opOpAssign];
    foreach (i, op; operators)
    {
        if (op == ид)
            return cast(CppOperator)i;
    }
    return CppOperator.Unknown;
}

///
/*extern(C++)*/ ткст0 toCppMangleItanium(ДСимвол s)
{
    //printf("toCppMangleItanium(%s)\n", s.вТкст0());
    БуфВыв буф;
    scope CppMangleVisitor v = new CppMangleVisitor(&буф, s.место);
    v.mangleOf(s);
    return буф.extractChars();
}

///
/*extern(C++)*/ ткст0 cppTypeInfoMangleItanium(ДСимвол s)
{
    //printf("cppTypeInfoMangle(%s)\n", s.вТкст0());
    БуфВыв буф;
    буф.пишиСтр("_ZTI");    // "TI" means typeinfo structure
    scope CppMangleVisitor v = new CppMangleVisitor(&буф, s.место);
    v.cpp_mangle_name(s, нет);
    return буф.extractChars();
}

/******************************
 * Determine if sym is the 'primary' destructor, that is,
 * the most-aggregate destructor (the one that is defined as __xdtor)
 * Параметры:
 *      sym = ДСимвол
 * Возвращает:
 *      да if sym is the primary destructor for an aggregate
 */
бул isPrimaryDtor(ДСимвол sym)
{
    const dtor = sym.isDtorDeclaration();
    if (!dtor)
        return нет;
    const ad = dtor.isMember();
    assert(ad);
    return dtor == ad.primaryDtor;
}

/// Context используется when processing pre-semantic AST
private struct Context
{
    /// Template instance of the function being mangled
    TemplateInstance ti;
    /// Function declaration we're mangling
    FuncDeclaration fd;
    /// Current тип / Выражение being processed (semantically analyzed)
    КорневойОбъект res;

   // @disable ref Context opAssign(ref Context other);
   // @disable ref Context opAssign(Context other);

    /**
     * Helper function to track `res`
     *
     * Параметры:
     *   следщ = Значение to set `this.res` to.
     *          If `this.res` is `null`, the Выражение is not evalutated.
     *          This allow this code to be используется even when no context is needed.
     *
     * Возвращает:
     *   The previous state of this `Context` объект
     */
    private Context сунь(lazy КорневойОбъект следщ)
    {
        auto r = this.res;
        if (r !is null)
            this.res = следщ;
        return Context(this.ti, this.fd, r);
    }

    /**
     * Reset the context to a previous one, making any adjustment necessary
     */
    private проц вынь(ref Context prev)
    {
        this.res = prev.res;
    }
}

private final class CppMangleVisitor : Визитор2
{
    /// Context используется when processing pre-semantic AST
    private Context context;

    Объекты components;         // массив of components доступно for substitution
    БуфВыв* буф;             // приставь the mangling to буф[]
    Место место;                    // location for use in error messages

    /**
     * Constructor
     *
     * Параметры:
     *   буф = `БуфВыв` to пиши the mangling to
     *   место = `Место` of the symbol being mangled
     */
    this(БуфВыв* буф, Место место)
    {
        this.буф = буф;
        this.место = место;
    }

    /*****
     * Entry point. Append mangling to буф[]
     * Параметры:
     *  s = symbol to mangle
     */
    проц mangleOf(ДСимвол s)
    {
        if (VarDeclaration vd = s.isVarDeclaration())
        {
            mangle_variable(vd, vd.cppnamespace !is null);
        }
        else if (FuncDeclaration fd = s.isFuncDeclaration())
        {
            mangle_function(fd);
        }
        else
        {
            assert(0);
        }
    }

    /**
     * Mangle the return тип of a function
     *
     * This is called on a templated function тип.
     * Context is set to the `FuncDeclaration`.
     *
     * Параметры:
     *   preSemantic = the `FuncDeclaration`'s `originalType`
     */
    проц mangleReturnType(TypeFunction preSemantic)
    {
        auto tf = cast(TypeFunction)this.context.res.asFuncDecl().тип;
        Тип rt = preSemantic.nextOf();
        if (tf.isref)
            rt = rt.referenceTo();
        auto prev = this.context.сунь(tf.nextOf());
        scope (exit) this.context.вынь(prev);
        this.headOfType(rt);
    }

    /**
     * Write a seq-ид from an index number, excluding the terminating '_'
     *
     * Параметры:
     *   idx = the index in a substitution list.
     *         Note that index 0 has no значение, and `S0_` would be the
     *         substitution at index 1 in the list.
     *
     * See-Also:
     *  https://itanium-cxx-abi.github.io/cxx-abi/abi.html#mangle.seq-ид
     */
    private проц writeSequenceFromIndex(т_мера idx)
    {
        if (idx)
        {
            проц write_seq_id(т_мера i)
            {
                if (i >= 36)
                {
                    write_seq_id(i / 36);
                    i %= 36;
                }
                i += (i < 10) ? '0' : 'A' - 10;
                буф.пишиБайт(cast(сим)i);
            }

            write_seq_id(idx - 1);
        }
    }

    /**
     * Attempt to perform substitution on `p`
     *
     * If `p` already appeared in the mangling, it is stored as
     * a 'part', and short references in the form of `SX_` can be используется.
     * Note that `p` can be anything: template declaration, struct declaration,
     * class declaration, namespace...
     *
     * Параметры:
     *   p = The объект to attempt to substitute
     *   nested = Whether or not `p` is to be considered nested.
     *            When `да`, `N` will be prepended before the substitution.
     *
     * Возвращает:
     *   Whether `p` already appeared in the mangling,
     *   and substitution has been written to `this.буф`.
     */
    бул substitute(КорневойОбъект p, бул nested = нет)
    {
        //printf("substitute %s\n", p ? p.вТкст0() : null);
        auto i = найди(p);
        if (i >= 0)
        {
            //printf("\tmatch\n");
            /* Sequence is S_, S0_, .., S9_, SA_, ..., SZ_, S10_, ...
             */
            if (nested)
                буф.пишиБайт('N');
            буф.пишиБайт('S');
            writeSequenceFromIndex(i);
            буф.пишиБайт('_');
            return да;
        }
        return нет;
    }

    /******
     * See if `p` exists in components[]
     *
     * Note that components can contain `null` entries,
     * as the index используется in mangling is based on the index in the массив.
     *
     * If called with an объект whose dynamic тип is `Nspace`,
     * calls the `найди(Nspace)` overload.
     *
     * Возвращает:
     *  index if found, -1 if not
     */
    цел найди(КорневойОбъект p)
    {
        //printf("найди %p %d %s\n", p, p.динкаст(), p ? p.вТкст0() : null);
        scope v = new ComponentVisitor(p);
        foreach (i, component; components)
        {
            if (component)
                component.visitObject(v);
            if (v.результат)
                return cast(цел)i;
        }
        return -1;
    }

    /*********************
     * Append p to components[]
     */
    проц приставь(КорневойОбъект p)
    {
        //printf("приставь %p %d %s\n", p, p.динкаст(), p ? p.вТкст0() : "null");
        components.сунь(p);
    }

    /**
     * Write an идентификатор preceded by its length
     *
     * Параметры:
     *   идент = `Идентификатор2` to пиши to `this.буф`
     */
    проц writeIdentifier(ref Идентификатор2 идент)
    {
        const имя = идент.вТкст();
        this.буф.print(имя.length);
        this.буф.пишиСтр(имя);
    }

    /************************
     * Determine if symbol is indeed the глоб2 ::std namespace.
     * Параметры:
     *  s = symbol to check
     * Возвращает:
     *  да if it is ::std
     */
    static бул isStd(ДСимвол s)
    {
        if (!s)
            return нет;

        if (auto cnd = s.isCPPNamespaceDeclaration())
            return isStd(cnd);

        return (s.идент == Id.std &&    // the right имя
                s.isNspace() &&         // g++ disallows глоб2 "std" for other than a namespace
                !getQualifier(s));      // at глоб2 уровень
    }

    /// Ditto
    static бул isStd(CPPNamespaceDeclaration s)
    {
        return s && s.cppnamespace is null && s.идент == Id.std;
    }

    /************************
     * Determine if тип is a C++ fundamental тип.
     * Параметры:
     *  t = тип to check
     * Возвращает:
     *  да if it is a fundamental тип
     */
    static бул isFundamentalType(Тип t)
    {
        // First check the target whether some specific ABI is being followed.
        бул isFundamental = проц;
        if (target.cpp.fundamentalType(t, isFundamental))
            return isFundamental;

        if (auto te = t.isTypeEnum())
        {
            // Peel off enum тип from special types.
            if (te.sym.isSpecial())
                t = te.memType();
        }

        // Fundamental arithmetic types:
        // 1. integral types: бул, сим, цел, ...
        // 2. floating point types: float, double, real
        // 3. проц
        // 4. null pointer: std::nullptr_t (since C++11)
        if (t.ty == Tvoid || t.ty == Tbool)
            return да;
        else if (t.ty == Tnull && глоб2.парамы.cplusplus >= CppStdRevision.cpp11)
            return да;
        else
            return t.isTypeBasic() && (t.isintegral() || t.isreal());
    }

    /******************************
     * Write the mangled representation of a template argument.
     * Параметры:
     *  ti  = the template instance
     *  arg = the template argument index
     */
    проц template_arg(TemplateInstance ti, т_мера arg)
    {
        TemplateDeclaration td = ti.tempdecl.isTemplateDeclaration();
        assert(td);
        ПараметрШаблона2 tp = (*td.parameters)[arg];
        КорневойОбъект o = (*ti.tiargs)[arg];

        auto prev = this.context.сунь({
                TemplateInstance parentti;
                if (this.context.res.динкаст() == ДИНКАСТ.дсимвол)
                    parentti = this.context.res.asFuncDecl().родитель.isTemplateInstance();
                else
                    parentti = this.context.res.asType().toDsymbol(null).родитель.isTemplateInstance();
                return (*parentti.tiargs)[arg];
            }());
        scope (exit) this.context.вынь(prev);

        if (tp.isTemplateTypeParameter())
        {
            Тип t = тип_ли(o);
            assert(t);
            t.прими(this);
        }
        else if (TemplateValueParameter tv = tp.isTemplateValueParameter())
        {
            // <expr-primary> ::= L <тип> <значение number> E  # integer literal
            if (tv.valType.isintegral())
            {
                Выражение e = выражение_ли(o);
                assert(e);
                буф.пишиБайт('L');
                tv.valType.прими(this);
                auto val = e.toUInteger();
                if (!tv.valType.isunsigned() && cast(sinteger_t)val < 0)
                {
                    val = -val;
                    буф.пишиБайт('n');
                }
                буф.print(val);
                буф.пишиБайт('E');
            }
            else
            {
                ti.выведиОшибку("Internal Compiler Error: C++ `%s` template значение параметр is not supported", tv.valType.вТкст0());
                fatal();
            }
        }
        else if (tp.isTemplateAliasParameter())
        {
            // Passing a function as alias параметр is the same as passing
            // `&function`
            ДСимвол d = isDsymbol(o);
            Выражение e = выражение_ли(o);
            if (d && d.isFuncDeclaration())
            {
                // X .. E => template параметр is an Выражение
                // 'ad'   => unary operator ('&')
                // L .. E => is a <expr-primary>
                буф.пишиСтр("XadL");
                mangle_function(d.isFuncDeclaration());
                буф.пишиСтр("EE");
            }
            else if (e && e.op == ТОК2.variable && (cast(VarExp)e).var.isVarDeclaration())
            {
                VarDeclaration vd = (cast(VarExp)e).var.isVarDeclaration();
                буф.пишиБайт('L');
                mangle_variable(vd, да);
                буф.пишиБайт('E');
            }
            else if (d && d.isTemplateDeclaration() && d.isTemplateDeclaration().onemember)
            {
                if (!substitute(d))
                {
                    cpp_mangle_name(d, нет);
                }
            }
            else
            {
                ti.выведиОшибку("Internal Compiler Error: C++ `%s` template alias параметр is not supported", o.вТкст0());
                fatal();
            }
        }
        else if (tp.isTemplateThisParameter())
        {
            ti.выведиОшибку("Internal Compiler Error: C++ `%s` template this параметр is not supported", o.вТкст0());
            fatal();
        }
        else
        {
            assert(0);
        }
    }

    /******************************
     * Write the mangled representation of the template arguments.
     * Параметры:
     *  ti = the template instance
     *  firstArg = index of the first template argument to mangle
     *             (используется for operator overloading)
     * Возвращает:
     *  да if any arguments were written
     */
    бул template_args(TemplateInstance ti, цел firstArg = 0)
    {
        /* <template-args> ::= I <template-arg>+ E
         */
        if (!ti || ti.tiargs.dim <= firstArg)   // could happen if std::basic_string is not a template
            return нет;
        буф.пишиБайт('I');
        foreach (i; new бцел[firstArg .. ti.tiargs.dim])
        {
            TemplateDeclaration td = ti.tempdecl.isTemplateDeclaration();
            assert(td);
            ПараметрШаблона2 tp = (*td.parameters)[i];

            /*
             * <template-arg> ::= <тип>               # тип or template
             *                ::= X <Выражение> E     # Выражение
             *                ::= <expr-primary>       # simple Выражения
             *                ::= J <template-arg>* E  # argument pack
             *
             * Reference: https://itanium-cxx-abi.github.io/cxx-abi/abi.html#mangle.template-arg
             */
            if (TemplateTupleParameter tt = tp.isTemplateTupleParameter())
            {
                буф.пишиБайт('J');     // argument pack

                // mangle the rest of the arguments as types
                foreach (j; new бцел[i .. (*ti.tiargs).dim])
                {
                    Тип t = тип_ли((*ti.tiargs)[j]);
                    assert(t);
                    t.прими(this);
                }

                буф.пишиБайт('E');
                break;
            }

            template_arg(ti, i);
        }
        буф.пишиБайт('E');
        return да;
    }

    /**
     * Write the symbol `p` if not null, then execute the delegate
     *
     * Параметры:
     *   p = Symbol to пиши
     *   dg = Delegate to execute
     */
    проц writeChained(ДСимвол p, проц delegate() dg)
    {
        if (p && !p.isModule())
        {
            буф.пишиСтр("N");
            source_name(p, да);
            dg();
            буф.пишиСтр("E");
        }
        else
            dg();
    }

    /**
     * Write the имя of `s` to the буфер
     *
     * Параметры:
     *   s = Symbol to пиши the имя of
     *   haveNE = Whether `N..E` is already part of the mangling
     *            Because `Nspace` and `CPPNamespaceAttribute` can be
     *            mixed, this is a mandatory hack.
     */
    проц source_name(ДСимвол s, бул haveNE = нет)
    {
        version (none)
        {
            printf("source_name(%s)\n", s.вТкст0());
            auto sl = this.буф.peekSlice();
            assert(sl.length == 0 || haveNE || s.cppnamespace is null || sl != "_ZN");
        }
        if (TemplateInstance ti = s.isTemplateInstance())
        {
            бул needsTa = нет;

            // https://issues.dlang.org/show_bug.cgi?ид=20413
            // N..E is not needed when substituting члены of the std namespace.
            // This is observed in the GCC and Clang implementations.
            // The Itanium specification is not clear enough on this specific case.
            // References:
            //   https://itanium-cxx-abi.github.io/cxx-abi/abi.html#mangle.имя
            //   https://itanium-cxx-abi.github.io/cxx-abi/abi.html#mangling-compression
            ДСимвол q = getQualifier(ti.tempdecl);
            ДСимвол ns = ti.tempdecl.cppnamespace;
            const inStd = ns && isStd(ns) || q && isStd(q);
            const isNested = !inStd && (ns || q);

            if (substitute(ti.tempdecl, !haveNE && isNested))
            {
                template_args(ti);
                if (!haveNE && isNested)
                    буф.пишиБайт('E');
            }
            else if (this.writeStdSubstitution(ti, needsTa))
            {
                if (needsTa)
                    template_args(ti);
            }
            else
            {
                this.writeNamespace(
                    s.cppnamespace, () {
                        this.writeIdentifier(ti.tempdecl.toAlias().идент);
                        приставь(ti.tempdecl);
                        template_args(ti);
                    }, haveNE);
            }
        }
     /+   else
            this.writeNamespace(s.cppnamespace, () => this.writeIdentifier(s.идент),
                                haveNE); +/
    }

    /********
     * See if s is actually an instance of a template
     * Параметры:
     *  s = symbol
     * Возвращает:
     *  if s is instance of a template, return the instance, otherwise return s
     */
    static ДСимвол getInstance(ДСимвол s)
    {
        ДСимвол p = s.toParent();
        if (p)
        {
            if (TemplateInstance ti = p.isTemplateInstance())
                return ti;
        }
        return s;
    }

    /// Get the namespace of a template instance
    CPPNamespaceDeclaration getTiNamespace(TemplateInstance ti)
    {
        // If we receive a pre-semantic `TemplateInstance`,
        // `cppnamespace` is always `null`
        return ti.tempdecl ? ti.cppnamespace
            : this.context.res.asType().toDsymbol(null).cppnamespace;
    }

    /********
     * Get qualifier for `s`, meaning the symbol
     * that s is in the symbol table of.
     * The module does not count as a qualifier, because C++
     * does not have modules.
     * Параметры:
     *  s = symbol that may have a qualifier
     *      s is rewritten to be TemplateInstance if s is one
     * Возвращает:
     *  qualifier, null if none
     */
    static ДСимвол getQualifier(ДСимвол s)
    {
        ДСимвол p = s.toParent();
        return (p && !p.isModule()) ? p : null;
    }

    // Detect тип сим
    static бул isChar(КорневойОбъект o)
    {
        Тип t = тип_ли(o);
        return (t && t.равен(Тип.tchar));
    }

    // Detect тип ::std::char_traits<сим>
    бул isChar_traits_char(КорневойОбъект o)
    {
        return isIdent_char(Id.char_traits, o);
    }

    // Detect тип ::std::allocator<сим>
    бул isAllocator_char(КорневойОбъект o)
    {
        return isIdent_char(Id.allocator, o);
    }

    // Detect тип ::std::идент<сим>
    бул isIdent_char(Идентификатор2 идент, КорневойОбъект o)
    {
        Тип t = тип_ли(o);
        if (!t || t.ty != Tstruct)
            return нет;
        ДСимвол s = (cast(TypeStruct)t).toDsymbol(null);
        if (s.идент != идент)
            return нет;
        ДСимвол p = s.toParent();
        if (!p)
            return нет;
        TemplateInstance ti = p.isTemplateInstance();
        if (!ti)
            return нет;
        ДСимвол q = getQualifier(ti);
        const бул inStd = isStd(q) || isStd(this.getTiNamespace(ti));
        return inStd && ti.tiargs.dim == 1 && isChar((*ti.tiargs)[0]);
    }

    /***
     * Detect template args <сим, ::std::char_traits<сим>>
     * and пиши st if found.
     * Возвращает:
     *  да if found
     */
    бул char_std_char_traits_char(TemplateInstance ti, ткст st)
    {
        if (ti.tiargs.dim == 2 &&
            isChar((*ti.tiargs)[0]) &&
            isChar_traits_char((*ti.tiargs)[1]))
        {
            буф.пишиСтр(st.ptr);
            return да;
        }
        return нет;
    }


    проц prefix_name(ДСимвол s)
    {
        //printf("prefix_name(%s)\n", s.вТкст0());
        if (substitute(s))
            return;
        if (isStd(s))
            return буф.пишиСтр("St");

        auto si = getInstance(s);
        ДСимвол p = getQualifier(si);
        if (p)
        {
            if (isStd(p))
            {
                бул needsTa;
                auto ti = si.isTemplateInstance();
                if (this.writeStdSubstitution(ti, needsTa))
                {
                    if (needsTa)
                    {
                        template_args(ti);
                        приставь(ti);
                    }
                    return;
                }
                буф.пишиСтр("St");
            }
            else
                prefix_name(p);
        }
        source_name(si, да);
        if (!isStd(si))
            /* Do this after the source_name() call to keep components[]
             * in the right order.
             * https://issues.dlang.org/show_bug.cgi?ид=17947
             */
            приставь(si);
    }

    /**
     * Write common substitution for standard types, such as std::allocator
     *
     * This function assumes that the symbol `ti` is in the namespace `std`.
     *
     * Параметры:
     *   ti = Template instance to consider
     *   needsTa = If this function returns `да`, this значение indicates
     *             if additional template argument mangling is needed
     *
     * Возвращает:
     *   `да` if a special std symbol was found
     */
    бул writeStdSubstitution(TemplateInstance ti, out бул needsTa)
    {
        if (!ti)
            return нет;
        if (!isStd(this.getTiNamespace(ti)) && !isStd(getQualifier(ti)))
            return нет;

        if (ti.имя == Id.allocator)
        {
            буф.пишиСтр("Sa");
            needsTa = да;
            return да;
        }
        if (ti.имя == Id.basic_string)
        {
            // ::std::basic_string<сим, ::std::char_traits<сим>, ::std::allocator<сим>>
            if (ti.tiargs.dim == 3 &&
                isChar((*ti.tiargs)[0]) &&
                isChar_traits_char((*ti.tiargs)[1]) &&
                isAllocator_char((*ti.tiargs)[2]))

            {
                буф.пишиСтр("Ss");
                return да;
            }
            буф.пишиСтр("Sb");      // ::std::basic_string
            needsTa = да;
            return да;
        }

        // ::std::basic_istream<сим, ::std::char_traits<сим>>
        if (ti.имя == Id.basic_istream &&
            char_std_char_traits_char(ti, "Si"))
            return да;

        // ::std::basic_ostream<сим, ::std::char_traits<сим>>
        if (ti.имя == Id.basic_ostream &&
            char_std_char_traits_char(ti, "So"))
            return да;

        // ::std::basic_iostream<сим, ::std::char_traits<сим>>
        if (ti.имя == Id.basic_iostream &&
            char_std_char_traits_char(ti, "Sd"))
            return да;

        return нет;
    }


    проц cpp_mangle_name(ДСимвол s, бул qualified)
    {
        //printf("cpp_mangle_name(%s, %d)\n", s.вТкст0(), qualified);
        ДСимвол p = s.toParent();
        ДСимвол se = s;
        бул write_prefix = да;
        if (p && p.isTemplateInstance())
        {
            se = p;
            if (найди(p.isTemplateInstance().tempdecl) >= 0)
                write_prefix = нет;
            p = p.toParent();
        }
        if (p && !p.isModule())
        {
            /* The N..E is not required if:
             * 1. the родитель is 'std'
             * 2. 'std' is the initial qualifier
             * 3. there is no CV-qualifier or a ref-qualifier for a member function
             * ABI 5.1.8
             */
            if (isStd(p) && !qualified)
            {
                TemplateInstance ti = se.isTemplateInstance();
                if (s.идент == Id.allocator)
                {
                    буф.пишиСтр("Sa"); // "Sa" is short for ::std::allocator
                    template_args(ti);
                }
                else if (s.идент == Id.basic_string)
                {
                    // ::std::basic_string<сим, ::std::char_traits<сим>, ::std::allocator<сим>>
                    if (ti.tiargs.dim == 3 &&
                        isChar((*ti.tiargs)[0]) &&
                        isChar_traits_char((*ti.tiargs)[1]) &&
                        isAllocator_char((*ti.tiargs)[2]))
                    {
                        буф.пишиСтр("Ss");
                        return;
                    }
                    буф.пишиСтр("Sb");      // ::std::basic_string
                    template_args(ti);
                }
                else
                {
                    // ::std::basic_istream<сим, ::std::char_traits<сим>>
                    if (s.идент == Id.basic_istream)
                    {
                        if (char_std_char_traits_char(ti, "Si"))
                            return;
                    }
                    else if (s.идент == Id.basic_ostream)
                    {
                        if (char_std_char_traits_char(ti, "So"))
                            return;
                    }
                    else if (s.идент == Id.basic_iostream)
                    {
                        if (char_std_char_traits_char(ti, "Sd"))
                            return;
                    }
                    буф.пишиСтр("St");
                    source_name(se, да);
                }
            }
            else
            {
                буф.пишиБайт('N');
                if (write_prefix)
                {
                    if (isStd(p))
                        буф.пишиСтр("St");
                    else
                        prefix_name(p);
                }
                source_name(se, да);
                буф.пишиБайт('E');
            }
        }
        else
            source_name(se);
        приставь(s);
    }

    /**
     * Write CV-qualifiers to the буфер
     *
     * CV-qualifiers are 'r': restrict (unused in D), 'V': volatile, 'K': const
     *
     * See_Also:
     *   https://itanium-cxx-abi.github.io/cxx-abi/abi.html#mangle.CV-qualifiers
     */
    проц CV_qualifiers(Тип t)
    {
        if (t.isConst())
            буф.пишиБайт('K');
    }

    /**
     * Mangles a variable
     *
     * Параметры:
     *   d = Variable declaration to mangle
     *   isNested = Whether this variable is nested, e.g. a template параметр
     *              or within a namespace
     */
    проц mangle_variable(VarDeclaration d, бул isNested)
    {
        // fake mangling for fields to fix https://issues.dlang.org/show_bug.cgi?ид=16525
        if (!(d.класс_хранения & (STC.extern_ | STC.field | STC.gshared)))
        {
            d.выведиОшибку("Internal Compiler Error: C++ static non-`` non-`extern` variables not supported");
            fatal();
        }
        ДСимвол p = d.toParent();
        if (p && !p.isModule()) //for example: сим Namespace1::beta[6] should be mangled as "_ZN10Namespace14betaE"
        {
            буф.пишиСтр("_ZN");
            prefix_name(p);
            source_name(d, да);
            буф.пишиБайт('E');
        }
        //сим beta[6] should mangle as "beta"
        else
        {
            if (!isNested)
                буф.пишиСтр(d.идент.вТкст());
            else
            {
                буф.пишиСтр("_Z");
                source_name(d);
            }
        }
    }

    проц mangle_function(FuncDeclaration d)
    {
        //printf("mangle_function(%s)\n", d.вТкст0());
        /*
         * <mangled-имя> ::= _Z <encoding>
         * <encoding> ::= <function имя> <bare-function-тип>
         *            ::= <данные имя>
         *            ::= <special-имя>
         */
        TypeFunction tf = cast(TypeFunction)d.тип;
        буф.пишиСтр("_Z");

        if (TemplateDeclaration ftd = getFuncTemplateDecl(d))
        {
            /* It's an instance of a function template
             */
            TemplateInstance ti = d.родитель.isTemplateInstance();
            assert(ti);
            this.mangleTemplatedFunction(d, tf, ftd, ti);
        }
        else
        {
            ДСимвол p = d.toParent();
            if (p && !p.isModule() && tf.компонаж == LINK.cpp)
            {
                this.mangleNestedFuncPrefix(tf, p);

                if (auto ctor = d.isCtorDeclaration())
                    буф.пишиСтр(ctor.isCpCtor ? "C2" : "C1");
                else if (d.isPrimaryDtor())
                    буф.пишиСтр("D1");
                else if (d.идент && d.идент == Id.assign)
                    буф.пишиСтр("aS");
                else if (d.идент && d.идент == Id.eq)
                    буф.пишиСтр("eq");
                else if (d.идент && d.идент == Id.index)
                    буф.пишиСтр("ix");
                else if (d.идент && d.идент == Id.call)
                    буф.пишиСтр("cl");
                else
                    source_name(d, да);
                буф.пишиБайт('E');
            }
            else
            {
                source_name(d);
            }
            // Template args прими extern "C" symbols with special mangling
            if (tf.компонаж == LINK.cpp)
                mangleFunctionParameters(tf.parameterList.parameters, tf.parameterList.varargs);
        }
    }

    /**
     * Recursively mangles a non-scoped namespace
     *
     * Параметры:
     *   ns = Namespace to mangle
     *   dg = A delegate to пиши the идентификатор in this namespace
     *   haveNE = When `нет` (the default), surround the namespace / dg
     *            call with nested имя qualifier (`N..E`).
     *            Otherwise, they are already present (e.g. `Nspace` was используется).
     */
    проц writeNamespace(CPPNamespaceDeclaration ns, проц delegate() dg, бул haveNE = нет)
    {
        проц runDg () { if (dg !is null) dg(); }

        if (ns is null)
            return runDg();

        if (isStd(ns))
        {
            if (!substitute(ns))
                буф.пишиСтр("St");
            runDg();
        }
        else if (dg !is null)
        {
            if (!haveNE)
                буф.пишиСтр("N");
            if (!substitute(ns))
            {
                this.writeNamespace(ns.cppnamespace, null);
                this.writeIdentifier(ns.идент);
                приставь(ns);
            }
            dg();
            if (!haveNE)
                буф.пишиСтр("E");
        }
        else if (!substitute(ns))
        {
            this.writeNamespace(ns.cppnamespace, null);
            this.writeIdentifier(ns.идент);
            приставь(ns);
        }
    }

    /**
     * Mangles a function template to C++
     *
     * Параметры:
     *   d = Function declaration
     *   tf = Function тип (casted d.тип)
     *   ftd = Template declaration (ti.templdecl)
     *   ti = Template instance (d.родитель)
     */
    проц mangleTemplatedFunction(FuncDeclaration d, TypeFunction tf,
                                 TemplateDeclaration ftd, TemplateInstance ti)
    {
        ДСимвол p = ti.toParent();
        // Check if this function is *not* nested
        if (!p || p.isModule() || tf.компонаж != LINK.cpp)
        {
            this.context.ti = ti;
            this.context.fd = d;
            this.context.res = d;
            TypeFunction preSemantic = cast(TypeFunction)d.originalType;
            auto nspace = ti.toParent();
            if (nspace && nspace.isNspace()){}
/+                this.writeChained(ti.toParent(), () => source_name(ti, да));+/
            else
                source_name(ti);
            this.mangleReturnType(preSemantic);
            this.mangleFunctionParameters(preSemantic.parameterList.parameters, tf.parameterList.varargs);
            return;
        }

        // It's a nested function (e.g. a member of an aggregate)
        this.mangleNestedFuncPrefix(tf, p);

        if (d.isCtorDeclaration())
        {
            буф.пишиСтр("C1");
        }
        else if (d.isPrimaryDtor())
        {
            буф.пишиСтр("D1");
        }
        else
        {
            цел firstTemplateArg = 0;
            бул appendReturnType = да;
            бул isConvertFunc = нет;
            ткст symName;

            // test for special symbols
            CppOperator whichOp = isCppOperator(ti.имя);
            switch (whichOp)
            {
            case CppOperator.Unknown:
                break;
            case CppOperator.Cast:
                symName = "cv";
                firstTemplateArg = 1;
                isConvertFunc = да;
                appendReturnType = нет;
                break;
            case CppOperator.Assign:
                symName = "aS";
                break;
            case CppOperator.Eq:
                symName = "eq";
                break;
            case CppOperator.Index:
                symName = "ix";
                break;
            case CppOperator.Call:
                symName = "cl";
                break;
            case CppOperator.Unary:
            case CppOperator.Binary:
            case CppOperator.OpAssign:
                TemplateDeclaration td = ti.tempdecl.isTemplateDeclaration();
                assert(td);
                assert(ti.tiargs.dim >= 1);
                ПараметрШаблона2 tp = (*td.parameters)[0];
                TemplateValueParameter tv = tp.isTemplateValueParameter();
                if (!tv || !tv.valType.isString())
                    break; // expecting a ткст argument to operators!
                Выражение exp = (*ti.tiargs)[0].выражение_ли();
                StringExp str = exp.вТкстExp();
                switch (whichOp)
                {
                case CppOperator.Unary:
                    switch (str.peekString())
                    {
                    case "*":   symName = "de"; goto continue_template;
                    case "++":  symName = "pp"; goto continue_template;
                    case "--":  symName = "mm"; goto continue_template;
                    case "-":   symName = "ng"; goto continue_template;
                    case "+":   symName = "ps"; goto continue_template;
                    case "~":   symName = "co"; goto continue_template;
                    default:    break;
                    }
                    break;
                case CppOperator.Binary:
                    switch (str.peekString())
                    {
                    case ">>":  symName = "rs"; goto continue_template;
                    case "<<":  symName = "ls"; goto continue_template;
                    case "*":   symName = "ml"; goto continue_template;
                    case "-":   symName = "mi"; goto continue_template;
                    case "+":   symName = "pl"; goto continue_template;
                    case "&":   symName = "an"; goto continue_template;
                    case "/":   symName = "dv"; goto continue_template;
                    case "%":   symName = "rm"; goto continue_template;
                    case "^":   symName = "eo"; goto continue_template;
                    case "|":   symName = "or"; goto continue_template;
                    default:    break;
                    }
                    break;
                case CppOperator.OpAssign:
                    switch (str.peekString())
                    {
                    case "*":   symName = "mL"; goto continue_template;
                    case "+":   symName = "pL"; goto continue_template;
                    case "-":   symName = "mI"; goto continue_template;
                    case "/":   symName = "dV"; goto continue_template;
                    case "%":   symName = "rM"; goto continue_template;
                    case ">>":  symName = "rS"; goto continue_template;
                    case "<<":  symName = "lS"; goto continue_template;
                    case "&":   symName = "aN"; goto continue_template;
                    case "|":   symName = "oR"; goto continue_template;
                    case "^":   symName = "eO"; goto continue_template;
                    default:    break;
                    }
                    break;
                default:
                    assert(0);
                continue_template:
                    firstTemplateArg = 1;
                    break;
                }
                break;
            }
            if (symName.length == 0)
                source_name(ti, да);
            else
            {
                буф.пишиСтр(symName);
                if (isConvertFunc)
                    template_arg(ti, 0);
                appendReturnType = template_args(ti, firstTemplateArg) && appendReturnType;
            }
            буф.пишиБайт('E');
            if (appendReturnType)
                headOfType(tf.nextOf());  // mangle return тип
        }
        mangleFunctionParameters(tf.parameterList.parameters, tf.parameterList.varargs);
    }

    /**
     * Mangle the parameters of a function
     *
     * For templated functions, `context.res` is set to the `FuncDeclaration`
     *
     * Параметры:
     *   parameters = МассивДРК of `Параметр2` to mangle
     *   varargs = if != 0, this function has varargs parameters
     */
    проц mangleFunctionParameters(Параметры* parameters, ВарАрг varargs)
    {
        цел numparams = 0;

        цел paramsCppMangleDg(т_мера n, Параметр2 fparam)
        {
            Тип t = target.cpp.parameterType(fparam);
            if (t.ty == Tsarray)
            {
                // Static arrays in D are passed by значение; no counterpart in C++
                .выведиОшибку(место, "Internal Compiler Error: unable to pass static массив `%s` to /*extern(C++)*/ function, use pointer instead",
                    t.вТкст0());
                fatal();
            }
            auto prev = this.context.сунь({
                    TypeFunction tf;
                    if (isDsymbol(this.context.res))
                        tf = cast(TypeFunction)this.context.res.asFuncDecl().тип;
                    else
                        tf = this.context.res.asType().isTypeFunction();
                    assert(tf);
                    return (*tf.parameterList.parameters)[n].тип;
                }());
            scope (exit) this.context.вынь(prev);
            headOfType(t);
            ++numparams;
            return 0;
        }

        if (parameters)
            Параметр2._foreach(parameters, &paramsCppMangleDg);
        if (varargs == ВарАрг.variadic)
            буф.пишиБайт('z');
        else if (!numparams)
            буф.пишиБайт('v'); // encode (проц) parameters
    }

    /****** The rest is тип mangling ************/

    проц выведиОшибку(Тип t)
    {
        ткст0 p;
        if (t.isImmutable())
            p = "`const` ";
        else if (t.isShared())
            p = "`shared` ";
        else
            p = "";
        .выведиОшибку(место, "Internal Compiler Error: %stype `%s` cannot be mapped to C++\n", p, t.вТкст0());
        fatal(); //Fatal, because this error should be handled in frontend
    }

    /****************************
     * Mangle a тип,
     * treating it as a Head followed by a Tail.
     * Параметры:
     *  t = Head of a тип
     */
    проц headOfType(Тип t)
    {
        if (t.ty == Tclass)
        {
            mangleTypeClass(cast(TypeClass)t, да);
        }
        else
        {
            // For значение types, strip const/const/shared from the head of the тип
            auto prev = this.context.сунь(this.context.res.asType().mutableOf().unSharedOf());
            scope (exit) this.context.вынь(prev);
            t.mutableOf().unSharedOf().прими(this);
        }
    }

    /******
     * Write out 1 or 2 character basic тип mangling.
     * Handle const and substitutions.
     * Параметры:
     *  t = тип to mangle
     *  p = if not 0, then character префикс
     *  c = mangling character
     */
    проц writeBasicType(Тип t, сим p, сим c)
    {
        // Only do substitutions for non-fundamental types.
        if (!isFundamentalType(t) || t.isConst())
        {
            if (substitute(t))
                return;
            else
                приставь(t);
        }
        CV_qualifiers(t);
        if (p)
            буф.пишиБайт(p);
        буф.пишиБайт(c);
    }


    /****************
     * Write structs and enums.
     * Параметры:
     *  t = TypeStruct or TypeEnum
     */
    проц doSymbol(Тип t)
    {
        if (substitute(t))
            return;
        CV_qualifiers(t);

        // Handle any target-specific struct types.
        if (auto tm = target.cpp.typeMangle(t))
        {
            буф.пишиСтр(tm);
        }
        else
        {
            ДСимвол s = t.toDsymbol(null);
            ДСимвол p = s.toParent();
            if (p && p.isTemplateInstance())
            {
                 /* https://issues.dlang.org/show_bug.cgi?ид=17947
                  * Substitute the template instance symbol, not the struct/enum symbol
                  */
                if (substitute(p))
                    return;
            }
            if (!substitute(s))
                cpp_mangle_name(s, нет);
        }
        if (t.isConst())
            приставь(t);
    }



    /************************
     * Mangle a class тип.
     * If it's the head, treat the initial pointer as a значение тип.
     * Параметры:
     *  t = class тип
     *  head = да for head of a тип
     */
    проц mangleTypeClass(TypeClass t, бул head)
    {
        if (t.isImmutable() || t.isShared())
            return выведиОшибку(t);

        /* Mangle as a <pointer to><struct>
         */
        if (substitute(t))
            return;
        if (!head)
            CV_qualifiers(t);
        буф.пишиБайт('P');

        CV_qualifiers(t);

        {
            ДСимвол s = t.toDsymbol(null);
            ДСимвол p = s.toParent();
            if (p && p.isTemplateInstance())
            {
                 /* https://issues.dlang.org/show_bug.cgi?ид=17947
                  * Substitute the template instance symbol, not the class symbol
                  */
                if (substitute(p))
                    return;
            }
        }

        if (!substitute(t.sym))
        {
            cpp_mangle_name(t.sym, нет);
        }
        if (t.isConst())
            приставь(null);  // C++ would have an extra тип here
        приставь(t);
    }

    /**
     * Mangle the префикс of a nested (e.g. member) function
     *
     * Параметры:
     *   tf = Тип of the nested function
     *   родитель = Parent in which the function is nested
     */
    проц mangleNestedFuncPrefix(TypeFunction tf, ДСимвол родитель)
    {
        /* <nested-имя> ::= N [<CV-qualifiers>] <префикс> <unqualified-имя> E
         *               ::= N [<CV-qualifiers>] <template-префикс> <template-args> E
         */
        буф.пишиБайт('N');
        CV_qualifiers(tf);

        /* <префикс> ::= <префикс> <unqualified-имя>
         *          ::= <template-префикс> <template-args>
         *          ::= <template-param>
         *          ::= # empty
         *          ::= <substitution>
         *          ::= <префикс> <данные-member-префикс>
         */
        prefix_name(родитель);
    }

    /**
     * Helper function to пиши a `T..._` template index.
     *
     * Параметры:
     *   idx   = Index of `param` in the template argument list
     *   param = Template параметр to mangle
     */
    private проц writeTemplateArgIndex(т_мера idx, ПараметрШаблона2 param)
    {
        // Выражения are mangled in <X..E>
        if (param.isTemplateValueParameter())
            буф.пишиБайт('X');
        буф.пишиБайт('T');
        writeSequenceFromIndex(idx);
        буф.пишиБайт('_');
        if (param.isTemplateValueParameter())
            буф.пишиБайт('E');
    }

    /**
     * Given an массив of template parameters and an идентификатор,
     * returns the index of the идентификатор in that массив.
     *
     * Параметры:
     *   идент = Идентификатор2 for which substitution is attempted
     *           (e.g. `проц func(T)(T param)` => `T` from `T param`)
     *   парамы = `ПараметрыШаблона` of the enclosing symbol
     *           (in the previous example, `func`'s template parameters)
     *
     * Возвращает:
     *   The index of the идентификатор match in `парамы`,
     *   or `парамы.length` if there wasn't any match.
     */
    private static т_мера templateParamIndex(
        ref Идентификатор2 идент, ПараметрыШаблона* парамы)
    {
        foreach (idx, param; *парамы)
            if (param.идент == идент)
                return idx;
        return парамы.length;
    }

    /**
     * Given a template instance `t`, пиши its qualified имя
     * without the template параметр list
     *
     * Параметры:
     *   t = Post-parsing `TemplateInstance` pointing to the symbol
     *       to mangle (one уровень deep)
     *   dg = Delegate to execute after writing the qualified symbol
     *
     */
    private проц writeQualified(TemplateInstance t, проц delegate() dg)
    {
        auto тип = тип_ли(this.context.res);
        if (!тип)
        {
            this.writeIdentifier(t.имя);
            return dg();
        }
        auto sym1 = тип.toDsymbol(null);
        if (!sym1)
        {
            this.writeIdentifier(t.имя);
            return dg();
        }
        // Get the template instance
        auto sym = getQualifier(sym1);
        auto sym2 = getQualifier(sym);
        if (sym2 && isStd(sym2)) // Nspace path
        {
            бул unused;
            assert(sym.isTemplateInstance());
            if (this.writeStdSubstitution(sym.isTemplateInstance(), unused))
                return dg();
            // std имена don't require `N..E`
            буф.пишиСтр("St");
            this.writeIdentifier(t.имя);
            this.приставь(t);
            return dg();
        }
        else if (sym2)
        {
            буф.пишиСтр("N");
            if (!this.substitute(sym2))
                sym2.прими(this);
        }
        this.writeNamespace(
            sym1.cppnamespace, () {
                this.writeIdentifier(t.имя);
                this.приставь(t);
                dg();
            });
        if (sym2)
            буф.пишиСтр("E");
    }

/*extern(C++):*/

    alias  Визитор2.посети посети;

    override проц посети(TypeNull t)
    {
        if (t.isImmutable() || t.isShared())
            return выведиОшибку(t);

        writeBasicType(t, 'D', 'n');
    }

    override проц посети(TypeBasic t)
    {
        if (t.isImmutable() || t.isShared())
            return выведиОшибку(t);

        // Handle any target-specific basic types.
        if (auto tm = target.cpp.typeMangle(t))
        {
            // Only do substitutions for non-fundamental types.
            if (!isFundamentalType(t) || t.isConst())
            {
                if (substitute(t))
                    return;
                else
                    приставь(t);
            }
            CV_qualifiers(t);
            буф.пишиСтр(tm);
            return;
        }

        /* <builtin-тип>:
         * v        проц
         * w        wchar_t
         * b        бул
         * c        сим
         * a        signed сим
         * h        unsigned сим
         * s        short
         * t        unsigned short
         * i        цел
         * j        unsigned цел
         * l        long
         * m        unsigned long
         * x        long long, __int64
         * y        unsigned long long, __int64
         * n        __int128
         * o        unsigned __int128
         * f        float
         * d        double
         * e        long double, __float80
         * g        __float128
         * z        ellipsis
         * Dd       64 bit IEEE 754r decimal floating point
         * De       128 bit IEEE 754r decimal floating point
         * Df       32 bit IEEE 754r decimal floating point
         * Dh       16 bit IEEE 754r half-precision floating point
         * Di       char32_t
         * Ds       char16_t
         * u <source-имя>  # vendor extended тип
         */
        сим c;
        сим p = 0;
        switch (t.ty)
        {
            case Tvoid:                 c = 'v';        break;
            case Tint8:                 c = 'a';        break;
            case Tuns8:                 c = 'h';        break;
            case Tint16:                c = 's';        break;
            case Tuns16:                c = 't';        break;
            case Tint32:                c = 'i';        break;
            case Tuns32:                c = 'j';        break;
            case Tfloat32:              c = 'f';        break;
            case Tint64:
                c = target.c.longsize == 8 ? 'l' : 'x';
                break;
            case Tuns64:
                c = target.c.longsize == 8 ? 'm' : 'y';
                break;
            case Tint128:                c = 'n';       break;
            case Tuns128:                c = 'o';       break;
            case Tfloat64:               c = 'd';       break;
            case Tfloat80:               c = 'e';       break;
            case Tbool:                  c = 'b';       break;
            case Tchar:                  c = 'c';       break;
            case Twchar:        p = 'D'; c = 's';       break;  // since C++11
            case Tdchar:        p = 'D'; c = 'i';       break;  // since C++11
            case Timaginary32:  p = 'G'; c = 'f';       break;  // 'G' means imaginary
            case Timaginary64:  p = 'G'; c = 'd';       break;
            case Timaginary80:  p = 'G'; c = 'e';       break;
            case Tcomplex32:    p = 'C'; c = 'f';       break;  // 'C' means complex
            case Tcomplex64:    p = 'C'; c = 'd';       break;
            case Tcomplex80:    p = 'C'; c = 'e';       break;

            default:
                return выведиОшибку(t);
        }
        writeBasicType(t, p, c);
    }

    override проц посети(TypeVector t)
    {
        if (t.isImmutable() || t.isShared())
            return выведиОшибку(t);

        if (substitute(t))
            return;
        приставь(t);
        CV_qualifiers(t);

        // Handle any target-specific vector types.
        if (auto tm = target.cpp.typeMangle(t))
        {
            буф.пишиСтр(tm);
        }
        else
        {
            assert(t.basetype && t.basetype.ty == Tsarray);
            assert((cast(TypeSArray)t.basetype).dim);
            version (none)
            {
                буф.пишиСтр("Dv");
                буф.print((cast(TypeSArray *)t.basetype).dim.toInteger()); // -- Gnu ABI v.4
                буф.пишиБайт('_');
            }
            else
                буф.пишиСтр("U8__vector"); //-- Gnu ABI v.3
            t.basetype.nextOf().прими(this);
        }
    }

    override проц посети(TypeSArray t)
    {
        if (t.isImmutable() || t.isShared())
            return выведиОшибку(t);

        if (!substitute(t))
            приставь(t);
        CV_qualifiers(t);
        буф.пишиБайт('A');
        буф.print(t.dim ? t.dim.toInteger() : 0);
        буф.пишиБайт('_');
        t.следщ.прими(this);
    }

    override проц посети(TypePointer t)
    {
        if (t.isImmutable() || t.isShared())
            return выведиОшибку(t);

        // Check for const - Since we cannot represent C++'s `ткст0 const`,
        // and `const ткст0 const` (a.k.a `сим*` in D) is mangled
        // the same as `const сим*` (`сим*` in D), we need to add
        // an extra `K` if `nextOf()` is `const`, before substitution
        CV_qualifiers(t);
        if (substitute(t))
            return;
        буф.пишиБайт('P');
        auto prev = this.context.сунь(this.context.res.asType().nextOf());
        scope (exit) this.context.вынь(prev);
        t.следщ.прими(this);
        приставь(t);
    }

    override проц посети(TypeReference t)
    {
        if (substitute(t))
            return;
        буф.пишиБайт('R');
        CV_qualifiers(t.nextOf());
        headOfType(t.nextOf());
        if (t.nextOf().isConst())
            приставь(t.nextOf());
        приставь(t);
    }

    override проц посети(TypeFunction t)
    {
        /*
         *  <function-тип> ::= F [Y] <bare-function-тип> E
         *  <bare-function-тип> ::= <signature тип>+
         *  # types are possible return тип, then параметр types
         */
        /* ABI says:
            "The тип of a non-static member function is considered to be different,
            for the purposes of substitution, from the тип of a namespace-scope or
            static member function whose тип appears similar. The types of two
            non-static member functions are considered to be different, for the
            purposes of substitution, if the functions are члены of different
            classes. In other words, for the purposes of substitution, the class of
            which the function is a member is considered part of the тип of
            function."

            BUG: Right now, types of functions are never merged, so our simplistic
            component matcher always finds them to be different.
            We should use Тип.равен on these, and use different
            TypeFunctions for non-static member functions, and non-static
            member functions of different classes.
         */
        if (substitute(t))
            return;
        буф.пишиБайт('F');
        if (t.компонаж == LINK.c)
            буф.пишиБайт('Y');
        Тип tn = t.следщ;
        if (t.isref)
            tn = tn.referenceTo();
        tn.прими(this);
        mangleFunctionParameters(t.parameterList.parameters, t.parameterList.varargs);
        буф.пишиБайт('E');
        приставь(t);
    }

    override проц посети(TypeStruct t)
    {
        if (t.isImmutable() || t.isShared())
            return выведиОшибку(t);
        //printf("TypeStruct %s\n", t.вТкст0());
        doSymbol(t);
    }

    override проц посети(TypeEnum t)
    {
        if (t.isImmutable() || t.isShared())
            return выведиОшибку(t);

        /* __c_(u)long(long) get special mangling
         */
        const ид = t.sym.идент;
        //printf("enum ид = '%s'\n", ид.вТкст0());
        if (ид == Id.__c_long)
            return writeBasicType(t, 0, 'l');
        else if (ид == Id.__c_ulong)
            return writeBasicType(t, 0, 'm');
        else if (ид == Id.__c_wchar_t)
            return writeBasicType(t, 0, 'w');
        else if (ид == Id.__c_longlong)
            return writeBasicType(t, 0, 'x');
        else if (ид == Id.__c_ulonglong)
            return writeBasicType(t, 0, 'y');

        doSymbol(t);
    }

    override проц посети(TypeClass t)
    {
        mangleTypeClass(t, нет);
    }

    /**
     * Performs template параметр substitution
     *
     * Mangling is performed on a копируй of the post-parsing AST before
     * any semantic pass is run.
     * There is no easy way to link a тип to the template parameters
     * once semantic has run, because:
     * - the `TemplateInstance` installs ники in its scope to its парамы
     * - `AliasDeclaration`s are resolved in many places
     * - semantic passes are destructive, so the `TypeIdentifier` gets lost
     *
     * As a результат, the best approach with the current architecture is to:
     * - Run the visitor on the `originalType` of the function,
     *   looking up any `TypeIdentifier` at the template scope when found.
     * - Fallback to the post-semantic `TypeFunction` when the идентификатор is
     *   not a template параметр.
     */
    override проц посети(TypeIdentifier t)
    {
        auto decl = cast(TemplateDeclaration)this.context.ti.tempdecl;
        assert(decl.parameters !is null);
        auto idx = templateParamIndex(t.идент, decl.parameters);
        // If not found, default to the post-semantic тип
        if (idx >= decl.parameters.length)
            return this.context.res.visitObject(this);

        auto param = (*decl.parameters)[idx];
        if (auto тип = this.context.res.тип_ли())
            CV_qualifiers(тип);
        // Otherwise, attempt substitution (`S_` takes precedence on `T_`)
        if (this.substitute(param))
            return;

        // If substitution failed, пиши `TX_` where `X` is the index
        this.writeTemplateArgIndex(idx, param);
        this.приставь(param);
    }

    /// Ditto
    override проц посети(TypeInstance t)
    {
        assert(t.tempinst !is null);
        t.tempinst.прими(this);
    }

    /**
     * Mangles a `TemplateInstance`
     *
     * A `TemplateInstance` can be found either in the параметр,
     * or the return значение.
     * Arguments to the template instance needs to be mangled but the template
     * can be partially substituted, so for example the following:
     * `Container!(T, Val) func16479_12 (alias Container, T, цел Val) ()`
     * will mangle the return значение part to "T_IT0_XT1_EE"
     */
    override проц посети(TemplateInstance t)
    {
        // Template имена are substituted, but args still need to be written
        проц writeArgs ()
        {
            буф.пишиБайт('I');
            // When visiting the arguments, the context will be set to the
            // resolved тип
            auto analyzed_ti = this.context.res.asType().toDsymbol(null).isInstantiated();
            auto prev = this.context;
            scope (exit) this.context.вынь(prev);
            foreach (idx, КорневойОбъект o; *t.tiargs)
            {
                this.context.res = (*analyzed_ti.tiargs)[idx];
                o.visitObject(this);
            }
            if (analyzed_ti.tiargs.dim > t.tiargs.dim)
            {
                // If the resolved AST has more args than the parse one,
                // we have default arguments
                auto oparams = (cast(TemplateDeclaration)analyzed_ti.tempdecl).origParameters;
                foreach (idx, arg; (*oparams)[t.tiargs.dim .. $])
                {
                    this.context.res = (*analyzed_ti.tiargs)[idx + t.tiargs.dim];

                    if (auto ttp = arg.isTemplateTypeParameter())
                        ttp.defaultType.прими(this);
                    else if (auto tvp = arg.isTemplateValueParameter())
                        tvp.defaultValue.прими(this);
                    else if (auto tvp = arg.isTemplateThisParameter())
                        tvp.defaultType.прими(this);
                    else if (auto tvp = arg.isTemplateAliasParameter())
                        tvp.defaultAlias.visitObject(this);
                    else
                        assert(0, arg.вТкст());
                }
            }
            буф.пишиБайт('E');
        }

        // `имя` is используется, not `идент`
        assert(t.имя !is null);
        assert(t.tiargs !is null);

        бул needsTa;
        auto decl = cast(TemplateDeclaration)this.context.ti.tempdecl;
        // Attempt to substitute the template itself
        auto idx = templateParamIndex(t.имя, decl.parameters);
        if (idx < decl.parameters.length)
        {
            auto param = (*decl.parameters)[idx];
            if (auto тип = t.getType())
                CV_qualifiers(тип);
            if (this.substitute(param))
                return;
            this.writeTemplateArgIndex(idx, param);
            this.приставь(param);
            writeArgs();
        }
        else if (this.writeStdSubstitution(t, needsTa))
        {
            if (needsTa)
                writeArgs();
        }
        else if (!this.substitute(t))
            this.writeQualified(t, &writeArgs);
    }

    /// Ditto
    override проц посети(IntegerExp t)
    {
        this.буф.пишиБайт('L');
        t.тип.прими(this);
        this.буф.print(t.getInteger());
        this.буф.пишиБайт('E');
    }

    override проц посети(Nspace t)
    {
        if (auto p = getQualifier(t))
            p.прими(this);

        if (isStd(t))
            буф.пишиСтр("St");
        else
        {
            this.writeIdentifier(t.идент);
            this.приставь(t);
        }
    }

    override проц посети(Тип t)
    {
        выведиОшибку(t);
    }

    проц посети(Tuple t)
    {
        assert(0);
    }
}

/// Helper code to посети `КорневойОбъект`, as it doesn't define `прими`,
/// only its direct subtypes do.
private проц visitObject(V : Визитор2)(КорневойОбъект o, V this_)
{
    assert(o !is null);
    if (Тип ta = тип_ли(o))
        ta.прими(this_);
    else if (Выражение ea = выражение_ли(o))
        ea.прими(this_);
    else if (ДСимвол sa = isDsymbol(o))
        sa.прими(this_);
    else if (ПараметрШаблона2 t = isTemplateParameter(o))
        t.прими(this_);
    else if (Tuple t = кортеж_ли(o))
        // `Tuple` inherits `КорневойОбъект` and does not define прими
        // For this reason, this uses static dispatch on the visitor
        this_.посети(t);
    else
        assert(0, o.вТкст());
}

/// Helper function to safely get a тип out of a `КорневойОбъект`
private Тип asType(КорневойОбъект o)
{
    Тип ta = тип_ли(o);
    assert(ta !is null, o.вТкст());
    return ta;
}

/// Helper function to safely get a `FuncDeclaration` out of a `КорневойОбъект`
private FuncDeclaration asFuncDecl(КорневойОбъект o)
{
    ДСимвол d = isDsymbol(o);
    assert(d !is null);
    auto fd = d.isFuncDeclaration();
    assert(fd !is null);
    return fd;
}

/// Helper class to compare entries in components
private /*extern(C++)*/ final class ComponentVisitor : Визитор2
{
    /// Only one of the following is not `null`, it's always
    /// the most specialized тип, set from the ctor
    private Nspace namespace;

    /// Ditto
    private CPPNamespaceDeclaration namespace2;

    /// Ditto
    private TypePointer tpointer;

    /// Ditto
    private TypeReference tref;

    /// Ditto
    private TypeIdentifier tident;

    /// Least specialized тип
    private КорневойОбъект объект;

    /// Set to the результат of the comparison
    private бул результат;

    public this(КорневойОбъект base)
    {
        switch (base.динкаст())
        {
        case ДИНКАСТ.дсимвол:
            if (auto ns = (cast(ДСимвол)base).isNspace())
                this.namespace = ns;
            else if (auto ns = (cast(ДСимвол)base).isCPPNamespaceDeclaration())
                this.namespace2 = ns;
            else
                goto default;
            break;

        case ДИНКАСТ.тип:
            auto t = cast(Тип)base;
            if (t.ty == Tpointer)
                this.tpointer = cast(TypePointer)t;
            else if (t.ty == Treference)
                this.tref = cast(TypeReference)t;
            else if (t.ty == Tident)
                this.tident = cast(TypeIdentifier)t;
            else
                goto default;
            break;

        default:
            this.объект = base;
        }
    }

    /// Introduce base class overloads
    alias  Визитор2.посети посети;

    /// Least specialized overload of each direct child of `КорневойОбъект`
    public override проц посети(ДСимвол o)
    {
        this.результат = this.объект && this.объект == o;
    }

    /// Ditto
    public override проц посети(Выражение o)
    {
        this.результат = this.объект && this.объект == o;
    }

    /// Ditto
    public проц посети(Tuple o)
    {
        this.результат = this.объект && this.объект == o;
    }

    /// Ditto
    public override проц посети(Тип o)
    {
        this.результат = this.объект && this.объект == o;
    }

    /// Ditto
    public override проц посети(ПараметрШаблона2 o)
    {
        this.результат = this.объект && this.объект == o;
    }

    /**
     * This overload handles composed types including template parameters
     *
     * Components for substitutions include "следщ" тип.
     * For example, if `ref T` is present, `ref T` and `T` will be present
     * in the substitution массив.
     * But since we don't have the final/merged тип, we cannot rely on
     * объект comparison, and need to recurse instead.
     */
    public override проц посети(TypeReference o)
    {
        if (!this.tref)
            return;
        if (this.tref == o)
            this.результат = да;
        else
        {
            // It might be a reference to a template параметр that we already
            // saw, so we need to recurse
            scope v = new ComponentVisitor(this.tref.следщ);
            o.следщ.visitObject(v);
            this.результат = v.результат;
        }
    }

    /// Ditto
    public override проц посети(TypePointer o)
    {
        if (!this.tpointer)
            return;
        if (this.tpointer == o)
            this.результат = да;
        else
        {
            // It might be a pointer to a template параметр that we already
            // saw, so we need to recurse
            scope v = new ComponentVisitor(this.tpointer.следщ);
            o.следщ.visitObject(v);
            this.результат = v.результат;
        }
    }

    /// Ditto
    public override проц посети(TypeIdentifier o)
    {
        /// Since we know they are at the same уровень, scope resolution will
        /// give us the same symbol, thus we can just compare идент.
        this.результат = (this.tident && (this.tident.идент == o.идент));
    }

    /**
     * Overload which accepts a Namespace
     *
     * It is very common for large C++ projects to have multiple files sharing
     * the same `namespace`. If any D project adopts the same approach
     * (e.g. separating данные structures from functions), it will lead to two
     * `Nspace` objects being instantiated, with different addresses.
     * At the same time, we cannot compare just any ДСимвол via идентификатор,
     * because it messes with templates.
     *
     * See_Also:
     *  https://issues.dlang.org/show_bug.cgi?ид=18922
     *
     * Параметры:
     *   ns = C++ namespace to do substitution for
     */
    public override проц посети(Nspace ns)
    {
        this.результат = isNamespaceEqual(this.namespace, ns)
            || isNamespaceEqual(this.namespace2, ns);
    }

    /// Ditto
    public override проц посети(CPPNamespaceDeclaration ns)
    {
        this.результат = isNamespaceEqual(this.namespace, ns)
            || isNamespaceEqual(this.namespace2, ns);
    }
}

/// Transitional functions for `CPPNamespaceDeclaration` / `Nspace`
/// Remove when `Nspace` is removed.
private бул isNamespaceEqual (Nspace a, Nspace b)
{
    if (a is null || b is null)
        return нет;
    return a.равен(b);
}

/// Ditto
private бул isNamespaceEqual (Nspace a, CPPNamespaceDeclaration b)
{
    return isNamespaceEqual(b, a);
}

/// Ditto
private бул isNamespaceEqual (CPPNamespaceDeclaration a, Nspace b, т_мера idx = 0)
{
    if ((a is null) != (b is null))
        return нет;
    if (!a.идент.равен(b.идент))
        return нет;

    // We need to see if there's more идент enclosing
    if (auto pb = b.toParent().isNspace())
        return isNamespaceEqual(a.cppnamespace, pb);
    else
        return a.cppnamespace is null;
}

/// Возвращает:
///   Whether  two `CPPNamespaceDeclaration` are равен
private бул isNamespaceEqual (CPPNamespaceDeclaration a, CPPNamespaceDeclaration b)
{
    if (a is null || b is null)
        return нет;

    if ((a.cppnamespace is null) != (b.cppnamespace is null))
        return нет;
    if (a.идент != b.идент)
        return нет;
    return a.cppnamespace is null ? да : isNamespaceEqual(a.cppnamespace, b.cppnamespace);
}
