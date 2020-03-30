/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/dclass.d, _dclass.d)
 * Documentation:  https://dlang.org/phobos/dmd_dclass.html
 * Coverage:    https://codecov.io/gh/dlang/dmd/src/master/src/dmd/dclass.d
 */

module dmd.dclass;

import cidrus;

import dmd.aggregate;
import dmd.arraytypes;
import dmd.gluelayer;
import dmd.declaration;
import dmd.dscope;
import dmd.дсимвол;
import dmd.dsymbolsem;
import dmd.func;
import dmd.globals;
import drc.lexer.Id;
import drc.lexer.Identifier;
import dmd.mtype;
import dmd.objc;
import util.rmem;
import dmd.target;
import drc.ast.Visitor;
import dmd.access : symbolIsVisible;

enum Abstract : цел
{
    fwdref = 0,      // whether an abstract class is not yet computed
    yes,             // is abstract class
    no,              // is not abstract class
}

/***********************************************************
 */
 struct КлассОснова2
{
    Тип тип;          // (before semantic processing)

    ClassDeclaration sym;
    бцел смещение;        // 'this' pointer смещение

    // for interfaces: МассивДРК of FuncDeclaration's making up the vtbl[]
    FuncDeclarations vtbl;

    // if КлассОснова2 is an interface, these
    // are a копируй of the InterfaceDeclaration.interfaces
    КлассОснова2[] baseInterfaces;

    this(Тип тип)
    {
        //printf("КлассОснова2(this = %p, '%s')\n", this, тип.вТкст0());
        this.тип = тип;
    }

    /****************************************
     * Fill in vtbl[] for base class based on member functions of class cd.
     * Input:
     *      vtbl            if !=NULL, fill it in
     *      newinstance     !=0 means all entries must be filled in by члены
     *                      of cd, not члены of any base classes of cd.
     * Возвращает:
     *      да if any entries were filled in by члены of cd (not exclusively
     *      by base classes)
     */
     бул fillVtbl(ClassDeclaration cd, FuncDeclarations* vtbl, цел newinstance)
    {
        бул результат = нет;

        //printf("КлассОснова2.fillVtbl(this='%s', cd='%s')\n", sym.вТкст0(), cd.вТкст0());
        if (vtbl)
            vtbl.устДим(sym.vtbl.dim);

        // first entry is ClassInfo reference
        for (т_мера j = sym.vtblOffset(); j < sym.vtbl.dim; j++)
        {
            FuncDeclaration ifd = sym.vtbl[j].isFuncDeclaration();
            FuncDeclaration fd;
            TypeFunction tf;

            //printf("        vtbl[%d] is '%s'\n", j, ifd ? ifd.вТкст0() : "null");
            assert(ifd);

            // Find corresponding function in this class
            tf = ifd.тип.toTypeFunction();
            fd = cd.findFunc(ifd.идент, tf);
            if (fd && !fd.isAbstract())
            {
                //printf("            found\n");
                // Check that calling conventions match
                if (fd.компонаж != ifd.компонаж)
                    fd.выведиОшибку("компонаж doesn't match interface function");

                // Check that it is current
                //printf("newinstance = %d fd.toParent() = %s ifd.toParent() = %s\n",
                    //newinstance, fd.toParent().вТкст0(), ifd.toParent().вТкст0());
                if (newinstance && fd.toParent() != cd && ifd.toParent() == sym)
                    cd.выведиОшибку("interface function `%s` is not implemented", ifd.toFullSignature());

                if (fd.toParent() == cd)
                    результат = да;
            }
            else
            {
                //printf("            not found %p\n", fd);
                // BUG: should mark this class as abstract?
                if (!cd.isAbstract())
                    cd.выведиОшибку("interface function `%s` is not implemented", ifd.toFullSignature());

                fd = null;
            }
            if (vtbl)
                (*vtbl)[j] = fd;
        }
        return результат;
    }

    extern (D) проц copyBaseInterfaces(КлассыОсновы* vtblInterfaces)
    {
        //printf("+copyBaseInterfaces(), %s\n", sym.вТкст0());
        //    if (baseInterfaces.length)
        //      return;
        auto bc = cast(КлассОснова2*)mem.xcalloc(sym.interfaces.length, КлассОснова2.sizeof);
        baseInterfaces = bc[0 .. sym.interfaces.length];
        //printf("%s.copyBaseInterfaces()\n", sym.вТкст0());
        for (т_мера i = 0; i < baseInterfaces.length; i++)
        {
            КлассОснова2* b = &baseInterfaces[i];
            КлассОснова2* b2 = sym.interfaces[i];

            assert(b2.vtbl.dim == 0); // should not be filled yet
            memcpy(b, b2, КлассОснова2.sizeof);

            if (i) // single inheritance is i==0
                vtblInterfaces.сунь(b); // only need for M.I.
            b.copyBaseInterfaces(vtblInterfaces);
        }
        //printf("-copyBaseInterfaces\n");
    }
}

enum ClassFlags : цел
{
    none          = 0x0,
    isCOMclass    = 0x1,
    noPointers    = 0x2,
    hasOffTi      = 0x4,
    hasCtor       = 0x8,
    hasGetMembers = 0x10,
    hasTypeInfo   = 0x20,
    isAbstract    = 0x40,
    isCPPclass    = 0x80,
    hasDtor       = 0x100,
}

/***********************************************************
 */
 class ClassDeclaration : AggregateDeclaration
{
     
          // Names found by reading объект.d in druntime
        ClassDeclaration объект;
        ClassDeclaration throwable;
        ClassDeclaration exception;
        ClassDeclaration errorException;
        ClassDeclaration cpp_type_info_ptr;   // Object.__cpp_type_info_ptr
   

    ClassDeclaration baseClass; // NULL only if this is Object
    FuncDeclaration staticCtor;
    FuncDeclaration staticDtor;
    Дсимволы vtbl;              // МассивДРК of FuncDeclaration's making up the vtbl[]
    Дсимволы vtblFinal;         // More FuncDeclaration's that aren't in vtbl[]

    // МассивДРК of КлассОснова2's; first is super, rest are Interface's
    КлассыОсновы* baseclasses;

    /* Slice of baseclasses[] that does not include baseClass
     */
    КлассОснова2*[] interfaces;

    // массив of base interfaces that have their own vtbl[]
    КлассыОсновы* vtblInterfaces;

    // the ClassInfo объект for this ClassDeclaration
    TypeInfoClassDeclaration vclassinfo;

    // да if this is a COM class
    бул com;

    /// да if this is a scope class
    бул stack;

    /// if this is a C++ class, this is the slot reserved for the virtual destructor
    цел cppDtorVtblIndex = -1;

    /// to prevent recursive attempts
    private бул inuse;

    /// да if this class has an идентификатор, but was originally declared анонимный
    /// используется in support of https://issues.dlang.org/show_bug.cgi?ид=17371
    private бул isActuallyAnonymous;

    Abstract isabstract;

    /// set the progress of base classes resolving
    Baseok baseok;

    /**
     * Data for a class declaration that is needed for the Objective-C
     * integration.
     */
    ObjcClassDeclaration objc;

    Symbol* cpp_type_info_ptr_sym;      // cached instance of class Id.cpp_type_info_ptr

    final this(ref Место место, Идентификатор2 ид, КлассыОсновы* baseclasses, Дсимволы* члены, бул inObject)
    {
        objc = ObjcClassDeclaration(this);

        if (!ид)
        {
            isActuallyAnonymous = да;
        }

        super(место, ид ? ид : Идентификатор2.генерируйИд("__anonclass"));

         ткст0 msg = "only объект.d can define this reserved class имя";

        if (baseclasses)
        {
            // Actually, this is a transfer
            this.baseclasses = baseclasses;
        }
        else
            this.baseclasses = new КлассыОсновы();

        this.члены = члены;

        //printf("ClassDeclaration(%s), dim = %d\n", идент.вТкст0(), this.baseclasses.dim);

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

    static ClassDeclaration создай(Место место, Идентификатор2 ид, КлассыОсновы* baseclasses, Дсимволы* члены, бул inObject)
    {
        return new ClassDeclaration(место, ид, baseclasses, члены, inObject);
    }

    override ДСимвол syntaxCopy(ДСимвол s)
    {
        //printf("ClassDeclaration.syntaxCopy('%s')\n", вТкст0());
        ClassDeclaration cd =
            s ? cast(ClassDeclaration)s
              : new ClassDeclaration(место, идент, null, null, нет);

        cd.класс_хранения |= класс_хранения;

        cd.baseclasses.устДим(this.baseclasses.dim);
        for (т_мера i = 0; i < cd.baseclasses.dim; i++)
        {
            КлассОснова2* b = (*this.baseclasses)[i];
            auto b2 = new КлассОснова2(b.тип.syntaxCopy());
            (*cd.baseclasses)[i] = b2;
        }

        return ScopeDsymbol.syntaxCopy(cd);
    }

    override Scope* newScope(Scope* sc)
    {
        auto sc2 = super.newScope(sc);
        if (isCOMclass())
        {
            /* This enables us to use COM objects under Linux and
             * work with things like XPCOM
             */
            sc2.компонаж = target.systemLinkage();
        }
        return sc2;
    }

    /*********************************************
     * Determine if 'this' is a base class of cd.
     * This is используется to detect circular inheritance only.
     */
    final бул isBaseOf2(ClassDeclaration cd)
    {
        if (!cd)
            return нет;
        //printf("ClassDeclaration.isBaseOf2(this = '%s', cd = '%s')\n", вТкст0(), cd.вТкст0());
        for (т_мера i = 0; i < cd.baseclasses.dim; i++)
        {
            КлассОснова2* b = (*cd.baseclasses)[i];
            if (b.sym == this || isBaseOf2(b.sym))
                return да;
        }
        return нет;
    }

    const OFFSET_RUNTIME = 0x76543210;
    const OFFSET_FWDREF = 0x76543211;

    /*******************************************
     * Determine if 'this' is a base class of cd.
     */
    бул isBaseOf(ClassDeclaration cd, цел* poffset)
    {
        //printf("ClassDeclaration.isBaseOf(this = '%s', cd = '%s')\n", вТкст0(), cd.вТкст0());
        if (poffset)
            *poffset = 0;
        while (cd)
        {
            /* cd.baseClass might not be set if cd is forward referenced.
             */
            if (!cd.baseClass && cd.semanticRun < PASS.semanticdone && !cd.isInterfaceDeclaration())
            {
                cd.dsymbolSemantic(null);
                if (!cd.baseClass && cd.semanticRun < PASS.semanticdone)
                    cd.выведиОшибку("base class is forward referenced by `%s`", вТкст0());
            }

            if (this == cd.baseClass)
                return да;

            cd = cd.baseClass;
        }
        return нет;
    }

    /*********************************************
     * Determine if 'this' has complete base class information.
     * This is используется to detect forward references in covariant overloads.
     */
    final бул isBaseInfoComplete()
    {
        return baseok >= Baseok.done;
    }

    override final ДСимвол search(ref Место место, Идентификатор2 идент, цел flags = SearchLocalsOnly)
    {
        //printf("%s.ClassDeclaration.search('%s', flags=x%x)\n", вТкст0(), идент.вТкст0(), flags);
        //if (_scope) printf("%s baseok = %d\n", вТкст0(), baseok);
        if (_scope && baseok < Baseok.done)
        {
            if (!inuse)
            {
                // must semantic on base class/interfaces
                inuse = да;
                dsymbolSemantic(this, null);
                inuse = нет;
            }
        }

        if (!члены || !symtab) // opaque or addMember is not yet done
        {
            // .stringof is always defined (but may be hidden by some other symbol)
            if (идент != Id.stringof)
                выведиОшибку("is forward referenced when looking for `%s`", идент.вТкст0());
            //*(сим*)0=0;
            return null;
        }

        auto s = ScopeDsymbol.search(место, идент, flags);

        // don't search imports of base classes
        if (flags & SearchImportsOnly)
            return s;

        if (!s)
        {
            // Search bases classes in depth-first, left to right order
            for (т_мера i = 0; i < baseclasses.dim; i++)
            {
                КлассОснова2* b = (*baseclasses)[i];
                if (b.sym)
                {
                    if (!b.sym.symtab)
                        выведиОшибку("base `%s` is forward referenced", b.sym.идент.вТкст0());
                    else
                    {
                        s = b.sym.search(место, идент, flags);
                        if (!s)
                            continue;
                        else if (s == this) // happens if s is nested in this and derives from this
                            s = null;
                        else if (!(flags & IgnoreSymbolVisibility) && !(s.prot().вид == Prot.Kind.protected_) && !symbolIsVisible(this, s))
                            s = null;
                        else
                            break;
                    }
                }
            }
        }
        return s;
    }

    /************************************
     * Search base classes in depth-first, left-to-right order for
     * a class or interface named 'идент'.
     * Stops at first found. Does not look for additional matches.
     * Параметры:
     *  идент = идентификатор to search for
     * Возвращает:
     *  ClassDeclaration if found, null if not
     */
    final ClassDeclaration searchBase(Идентификатор2 идент)
    {
        foreach (b; *baseclasses)
        {
            auto cdb = b.тип.isClassHandle();
            if (!cdb) // https://issues.dlang.org/show_bug.cgi?ид=10616
                return null;
            if (cdb.идент.равен(идент))
                return cdb;
            auto результат = cdb.searchBase(идент);
            if (результат)
                return результат;
        }
        return null;
    }

    final override проц finalizeSize()
    {
        assert(sizeok != Sizeok.done);

        // Set the offsets of the fields and determine the size of the class
        if (baseClass)
        {
            assert(baseClass.sizeok == Sizeok.done);

            alignsize = baseClass.alignsize;
            structsize = baseClass.structsize;
            if (classKind == ClassKind.cpp && глоб2.парамы.isWindows)
                structsize = (structsize + alignsize - 1) & ~(alignsize - 1);
        }
        else if (isInterfaceDeclaration())
        {
            if (interfaces.length == 0)
            {
                alignsize = target.ptrsize;
                structsize = target.ptrsize;      // allow room for __vptr
            }
        }
        else
        {
            alignsize = target.ptrsize;
            structsize = target.ptrsize;      // allow room for __vptr
            if (hasMonitor())
                structsize += target.ptrsize; // allow room for __monitor
        }

        //printf("finalizeSize() %s, sizeok = %d\n", вТкст0(), sizeok);
        т_мера bi = 0;                  // index into vtblInterfaces[]

        /****
         * Runs through the inheritance graph to set the КлассОснова2.смещение fields.
         * Recursive in order to account for the size of the interface classes, if they are
         * more than just interfaces.
         * Параметры:
         *      cd = interface to look at
         *      baseOffset = смещение of where cd will be placed
         * Возвращает:
         *      subset of instantiated size используется by cd for interfaces
         */
        бцел membersPlace(ClassDeclaration cd, бцел baseOffset)
        {
            //printf("    membersPlace(%s, %d)\n", cd.вТкст0(), baseOffset);
            бцел смещение = baseOffset;

            foreach (КлассОснова2* b; cd.interfaces)
            {
                if (b.sym.sizeok != Sizeok.done)
                    b.sym.finalizeSize();
                assert(b.sym.sizeok == Sizeok.done);

                if (!b.sym.alignsize)
                    b.sym.alignsize = target.ptrsize;
                alignmember(b.sym.alignsize, b.sym.alignsize, &смещение);
                assert(bi < vtblInterfaces.dim);

                КлассОснова2* bv = (*vtblInterfaces)[bi];
                if (b.sym.interfaces.length == 0)
                {
                    //printf("\tvtblInterfaces[%d] b=%p b.sym = %s, смещение = %d\n", bi, bv, bv.sym.вТкст0(), смещение);
                    bv.смещение = смещение;
                    ++bi;
                    // All the base interfaces down the left side share the same смещение
                    for (КлассОснова2* b2 = bv; b2.baseInterfaces.length; )
                    {
                        b2 = &b2.baseInterfaces[0];
                        b2.смещение = смещение;
                        //printf("\tvtblInterfaces[%d] b=%p   sym = %s, смещение = %d\n", bi, b2, b2.sym.вТкст0(), b2.смещение);
                    }
                }
                membersPlace(b.sym, смещение);
                //printf(" %s size = %d\n", b.sym.вТкст0(), b.sym.structsize);
                смещение += b.sym.structsize;
                if (alignsize < b.sym.alignsize)
                    alignsize = b.sym.alignsize;
            }
            return смещение - baseOffset;
        }

        structsize += membersPlace(this, structsize);

        if (isInterfaceDeclaration())
        {
            sizeok = Sizeok.done;
            return;
        }

        // FIXME: Currently setFieldOffset functions need to increase fields
        // to calculate each variable offsets. It can be improved later.
        fields.устДим(0);

        бцел смещение = structsize;
        foreach (s; *члены)
        {
            s.setFieldOffset(this, &смещение, нет);
        }

        sizeok = Sizeok.done;

        // Calculate fields[i].overlapped
        checkOverlappedFields();
    }

    /**************
     * Возвращает: да if there's a __monitor field
     */
    final бул hasMonitor()
    {
        return classKind == ClassKind.d;
    }

    override бул isAnonymous()
    {
        return isActuallyAnonymous;
    }

    final бул isFuncHidden(FuncDeclaration fd)
    {
        //printf("ClassDeclaration.isFuncHidden(class = %s, fd = %s)\n", вТкст0(), fd.toPrettyChars());
        ДСимвол s = search(Место.initial, fd.идент, IgnoreAmbiguous | IgnoreErrors);
        if (!s)
        {
            //printf("not found\n");
            /* Because, due to a hack, if there are multiple definitions
             * of fd.идент, NULL is returned.
             */
            return нет;
        }
        s = s.toAlias();
        if (auto ос = s.isOverloadSet())
        {
            foreach (sm; ос.a)
            {
                auto fm = sm.isFuncDeclaration();
                if (overloadApply(fm,/* s => */fd == s.isFuncDeclaration()))
                    return нет;
            }
            return да;
        }
        else
        {
            auto f = s.isFuncDeclaration();
            //printf("%s fdstart = %p\n", s.вид(), fdstart);
            if (overloadApply(f,/* s => */fd == s.isFuncDeclaration()))
                return нет;
            return !fd.родитель.isTemplateMixin();
        }
    }

    /****************
     * Find virtual function matching идентификатор and тип.
     * Used to build virtual function tables for interface implementations.
     * Параметры:
     *  идент = function's идентификатор
     *  tf = function's тип
     * Возвращает:
     *  function symbol if found, null if not
     * Errors:
     *  prints error message if more than one match
     */
    final FuncDeclaration findFunc(Идентификатор2 идент, TypeFunction tf)
    {
        //printf("ClassDeclaration.findFunc(%s, %s) %s\n", идент.вТкст0(), tf.вТкст0(), вТкст0());
        FuncDeclaration fdmatch = null;
        FuncDeclaration fdambig = null;

        проц updateBestMatch(FuncDeclaration fd)
        {
            fdmatch = fd;
            fdambig = null;
            //printf("Lfd fdmatch = %s %s [%s]\n", fdmatch.вТкст0(), fdmatch.тип.вТкст0(), fdmatch.место.вТкст0());
        }

        проц searchVtbl(ref Дсимволы vtbl)
        {
            foreach (s; vtbl)
            {
                auto fd = s.isFuncDeclaration();
                if (!fd)
                    continue;

                // the first entry might be a ClassInfo
                //printf("\t[%d] = %s\n", i, fd.вТкст0());
                if (идент == fd.идент && fd.тип.covariant(tf) == 1)
                {
                    //printf("fd.родитель.isClassDeclaration() = %p\n", fd.родитель.isClassDeclaration());
                    if (!fdmatch)
                    {
                        updateBestMatch(fd);
                        continue;
                    }
                    if (fd == fdmatch)
                        continue;

                    {
                    // Function тип matching: exact > covariant
                    MATCH m1 = tf.равен(fd.тип) ? MATCH.exact : MATCH.nomatch;
                    MATCH m2 = tf.равен(fdmatch.тип) ? MATCH.exact : MATCH.nomatch;
                    if (m1 > m2)
                    {
                        updateBestMatch(fd);
                        continue;
                    }
                    else if (m1 < m2)
                        continue;
                    }
                    {
                    MATCH m1 = (tf.mod == fd.тип.mod) ? MATCH.exact : MATCH.nomatch;
                    MATCH m2 = (tf.mod == fdmatch.тип.mod) ? MATCH.exact : MATCH.nomatch;
                    if (m1 > m2)
                    {
                        updateBestMatch(fd);
                        continue;
                    }
                    else if (m1 < m2)
                        continue;
                    }
                    {
                    // The way of definition: non-mixin > mixin
                    MATCH m1 = fd.родитель.isClassDeclaration() ? MATCH.exact : MATCH.nomatch;
                    MATCH m2 = fdmatch.родитель.isClassDeclaration() ? MATCH.exact : MATCH.nomatch;
                    if (m1 > m2)
                    {
                        updateBestMatch(fd);
                        continue;
                    }
                    else if (m1 < m2)
                        continue;
                    }

                    fdambig = fd;
                    //printf("Lambig fdambig = %s %s [%s]\n", fdambig.вТкст0(), fdambig.тип.вТкст0(), fdambig.место.вТкст0());
                }
                //else printf("\t\t%d\n", fd.тип.covariant(tf));
            }
        }

        searchVtbl(vtbl);
        for (auto cd = this; cd; cd = cd.baseClass)
        {
            searchVtbl(cd.vtblFinal);
        }

        if (fdambig)
            выведиОшибку("ambiguous virtual function `%s`", fdambig.вТкст0());

        return fdmatch;
    }

    /****************************************
     */
    final бул isCOMclass() 
    {
        return com;
    }

    бул isCOMinterface()
    {
        return нет;
    }

    final бул isCPPclass()
    {
        return classKind == ClassKind.cpp;
    }

    бул isCPPinterface()
    {
        return нет;
    }

    /****************************************
     */
    final бул isAbstract()
    {
        const log = нет;
        if (isabstract != Abstract.fwdref)
            return isabstract == Abstract.yes;

        if (log) printf("isAbstract(%s)\n", вТкст0());

        бул no()  { if (log) printf("no\n");  isabstract = Abstract.no;  return нет; }
        бул yes() { if (log) printf("yes\n"); isabstract = Abstract.yes; return да;  }

        if (класс_хранения & STC.abstract_ || _scope && _scope.stc & STC.abstract_)
            return yes();

        if (errors)
            return no();

        /* https://issues.dlang.org/show_bug.cgi?ид=11169
         * Resolve forward references to all class member functions,
         * and determine whether this class is abstract.
         */
         static цел func(ДСимвол s, ук param)
        {
            auto fd = s.isFuncDeclaration();
            if (!fd)
                return 0;
            if (fd.класс_хранения & STC.static_)
                return 0;

            if (fd.isAbstract())
                return 1;
            return 0;
        }

        for (т_мера i = 0; i < члены.dim; i++)
        {
            auto s = (*члены)[i];
            if (s.apply(&func, cast(ук)this))
            {
                return yes();
            }
        }

        /* If the base class is not abstract, then this class cannot
         * be abstract.
         */
        if (!isInterfaceDeclaration() && (!baseClass || !baseClass.isAbstract()))
            return no();

        /* If any abstract functions are inherited, but not overridden,
         * then the class is abstract. Do this by checking the vtbl[].
         * Need to do semantic() on class to fill the vtbl[].
         */
        this.dsymbolSemantic(null);

        /* The следщ line should work, but does not because when ClassDeclaration.dsymbolSemantic()
         * is called recursively it can set PASS.semanticdone without finishing it.
         */
        //if (semanticRun < PASS.semanticdone)
        {
            /* Could not complete semantic(). Try running semantic() on
             * each of the virtual functions,
             * which will fill in the vtbl[] overrides.
             */
             static цел virtualSemantic(ДСимвол s, ук param)
            {
                auto fd = s.isFuncDeclaration();
                if (fd && !(fd.класс_хранения & STC.static_) && !fd.isUnitTestDeclaration())
                    fd.dsymbolSemantic(null);
                return 0;
            }

            for (т_мера i = 0; i < члены.dim; i++)
            {
                auto s = (*члены)[i];
                s.apply(&virtualSemantic, cast(ук)this);
            }
        }

        /* Finally, check the vtbl[]
         */
        foreach (i; new бцел[1 .. vtbl.dim])
        {
            auto fd = vtbl[i].isFuncDeclaration();
            //if (fd) printf("\tvtbl[%d] = [%s] %s\n", i, fd.место.вТкст0(), fd.toPrettyChars());
            if (!fd || fd.isAbstract())
            {
                return yes();
            }
        }

        return no();
    }

    /****************************************
     * Determine if slot 0 of the vtbl[] is reserved for something else.
     * For class objects, yes, this is where the classinfo ptr goes.
     * For COM interfaces, no.
     * For non-COM interfaces, yes, this is where the Interface ptr goes.
     * Возвращает:
     *      0       vtbl[0] is first virtual function pointer
     *      1       vtbl[0] is classinfo/interfaceinfo pointer
     */
    цел vtblOffset()
    {
        return classKind == ClassKind.cpp ? 0 : 1;
    }

    /****************************************
     */
    override ткст0 вид()
    {
        return "class";
    }

    /****************************************
     */
    override final проц addLocalClass(ClassDeclarations* aclasses)
    {
        if (classKind != ClassKind.objc)
            aclasses.сунь(this);
    }

    override final проц addObjcSymbols(ClassDeclarations* classes, ClassDeclarations* categories)
    {
        .objc.addSymbols(this, classes, categories);
    }

    // Back end
    ДСимвол vtblsym;

    final ДСимвол vtblSymbol()
    {
        if (!vtblsym)
        {
            auto vtype = Тип.tvoidptr.immutableOf().sarrayOf(vtbl.dim);
            auto var = new VarDeclaration(место, vtype, Идентификатор2.idPool("__vtbl"), null, STC.immutable_ | STC.static_);
            var.addMember(null, this);
            var.isdataseg = 1;
            var.компонаж = LINK.d;
            var.semanticRun = PASS.semanticdone; // no more semantic wanted
            vtblsym = var;
        }
        return vtblsym;
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

/***********************************************************
 */
 final class InterfaceDeclaration : ClassDeclaration
{
    this(ref Место место, Идентификатор2 ид, КлассыОсновы* baseclasses)
    {
        super(место, ид, baseclasses, null, нет);
        if (ид == Id.IUnknown) // IUnknown is the root of all COM interfaces
        {
            com = да;
            classKind = ClassKind.cpp; // IUnknown is also a C++ interface
        }
    }

    override ДСимвол syntaxCopy(ДСимвол s)
    {
        InterfaceDeclaration ид =
            s ? cast(InterfaceDeclaration)s
              : new InterfaceDeclaration(место, идент, null);
        return ClassDeclaration.syntaxCopy(ид);
    }


    override Scope* newScope(Scope* sc)
    {
        auto sc2 = super.newScope(sc);
        if (com)
            sc2.компонаж = LINK.windows;
        else if (classKind == ClassKind.cpp)
            sc2.компонаж = LINK.cpp;
        else if (classKind == ClassKind.objc)
            sc2.компонаж = LINK.objc;
        return sc2;
    }

    /*******************************************
     * Determine if 'this' is a base class of cd.
     * (Actually, if it is an interface supported by cd)
     * Output:
     *      *poffset        смещение to start of class
     *                      OFFSET_RUNTIME  must determine смещение at runtime
     * Возвращает:
     *      нет   not a base
     *      да    is a base
     */
    override бул isBaseOf(ClassDeclaration cd, цел* poffset)
    {
        //printf("%s.InterfaceDeclaration.isBaseOf(cd = '%s')\n", вТкст0(), cd.вТкст0());
        assert(!baseClass);
        foreach (b; cd.interfaces)
        {
            //printf("\tX base %s\n", b.sym.вТкст0());
            if (this == b.sym)
            {
                //printf("\tfound at смещение %d\n", b.смещение);
                if (poffset)
                {
                    // don't return incorrect offsets
                    // https://issues.dlang.org/show_bug.cgi?ид=16980
                    *poffset = cd.sizeok == Sizeok.done ? b.смещение : OFFSET_FWDREF;
                }
                // printf("\tfound at смещение %d\n", b.смещение);
                return да;
            }
            if (isBaseOf(b, poffset))
                return да;
        }
        if (cd.baseClass && isBaseOf(cd.baseClass, poffset))
            return да;

        if (poffset)
            *poffset = 0;
        return нет;
    }

    бул isBaseOf(КлассОснова2* bc, цел* poffset)
    {
        //printf("%s.InterfaceDeclaration.isBaseOf(bc = '%s')\n", вТкст0(), bc.sym.вТкст0());
        for (т_мера j = 0; j < bc.baseInterfaces.length; j++)
        {
            КлассОснова2* b = &bc.baseInterfaces[j];
            //printf("\tY base %s\n", b.sym.вТкст0());
            if (this == b.sym)
            {
                //printf("\tfound at смещение %d\n", b.смещение);
                if (poffset)
                {
                    *poffset = b.смещение;
                }
                return да;
            }
            if (isBaseOf(b, poffset))
            {
                return да;
            }
        }

        if (poffset)
            *poffset = 0;
        return нет;
    }

    /*******************************************
     */
    override ткст0 вид()
    {
        return "interface";
    }

    /****************************************
     * Determine if slot 0 of the vtbl[] is reserved for something else.
     * For class objects, yes, this is where the ClassInfo ptr goes.
     * For COM interfaces, no.
     * For non-COM interfaces, yes, this is where the Interface ptr goes.
     */
    override цел vtblOffset()
    {
        if (isCOMinterface() || isCPPinterface())
            return 0;
        return 1;
    }

    override бул isCPPinterface()
    {
        return classKind == ClassKind.cpp;
    }

    override бул isCOMinterface()
    {
        return com;
    }

    override InterfaceDeclaration isInterfaceDeclaration()
    {
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}
