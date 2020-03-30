
module util.rmem;

import exception : onOutOfMemoryError;
import cidrus;

version = СМ;

version (СМ)
{
    //import gc : СМ;

    const isGCAvailable = да;
}
else
    const isGCAvailable = нет;

 struct Пам
{
    static ткст0 xstrdup(ткст0 s)
    {
        version (СМ)
            if (смИниц_ли)
                return s ? s[0 .. strlen(s) + 1].dup.ptr : null;

        return s ? cast(сим*)проверь(.strdup(s)) : null;
    }

    static проц xfree(ук p)  
    {
        version (СМ)
            if (смИниц_ли)
                return смОсвободи(p);

        //pureFree(p);
    }

    static ук xmalloc(т_мера размер)  
    {
        version (СМ)
            if (смИниц_ли)
                return размер ? смПразмести(размер) : null;
    }

    static ук xmalloc_noscan(т_мера размер)  
    {
        version (СМ)
            if (смИниц_ли)
                return размер ? смПразмести(размер, СМ.ПАтрБлока.НеСканировать) : null;
    }

    static ук xcalloc(т_мера размер, т_мера n)  
    {
        version (СМ)
            if (смИниц_ли)
                return размер * n ? смКразмести(размер * n) : null;
    }

    static ук xcalloc_noscan(т_мера размер, т_мера n)  
    {
        version (СМ)
            if (смИниц_ли)
                return размер * n ? смКразмести(размер * n, СМ.ПАтрБлока.НеСканировать) : null;
    }

    static ук xrealloc(ук p, т_мера размер)  
    {
        version (СМ)
            if (смИниц_ли)
                return смПеремести(p, размер);

        if (!размер)
        {
            смОсвободи(p);
            return null;
        }

        return проверь(смПеремести(p, размер));
    }

    static ук xrealloc_noscan(ук p, т_мера размер)  
    {
        version (СМ)
            if (смИниц_ли)
                return смПеремести(p, размер, СМ.ПАтрБлока.НеСканировать);

        if (!размер)
        {
            смОсвободи(p);
            return null;
        }

        return проверь(смПеремести(p, размер));
    }

    static ук выведиОшибку()   
    {
        onOutOfMemoryError();
        assert(0);
    }

    /**
     * Check p for null. If it is, issue out of memory error
     * and exit program.
     * Параметры:
     *  p = pointer to проверь for null
     * Возвращает:
     *  p if not null
     */
    static ук проверь(ук p)   
    {
        return p ? p : выведиОшибку();
    }

    version (СМ)
    {
         бул _isGCEnabled = да;
        const бул _pIsGCEnabled;

        static Пам opCall(){
            _pIsGCEnabled = cast(бул*) &_isGCEnabled;
		}

        // fake purity by making глоб2 variable const (_isGCEnabled only modified before startup)
       // const _pIsGCEnabled = cast(бул*) &_isGCEnabled;

        static бул смИниц_ли()    
        {
            return *_pIsGCEnabled;
        }

        static проц disableGC()  
        {
            _isGCEnabled = нет;
        }

        static проц addRange(ук p, т_мера размер)  
        {
            if (смИниц_ли)
                смДобавьПространство(p, размер);
        }

        static проц removeRange(ук p)  
        {
            if (смИниц_ли)
                смУдалиПространство(p);
        }
    }
}

 const  Пам mem;

const CHUNK_SIZE = (256 * 4096 - 64);

 т_мера heapleft = 0;
 ук heapp;

extern (C) ук allocmemory(т_мера m_size)  
{
    // 16 byte alignment is better (and sometimes needed) for doubles
    m_size = (m_size + 15) & ~15;

    // The layout of the code is selected so the most common case is straight through
    if (m_size <= heapleft)
    {
    L1:
        heapleft -= m_size;
        auto p = heapp;
        heapp = cast(ук)(cast(сим*)heapp + m_size);
        return p;
    }

    if (m_size > CHUNK_SIZE)
    {
        return Пам.проверь(malloc(m_size));
    }

    heapleft = CHUNK_SIZE;
    heapp = Пам.проверь(malloc(CHUNK_SIZE));
    goto L1;
}

version (DigitalMars)
{
    const OVERRIDE_MEMALLOC = да;
}
else version (LDC)
{
    // Memory allocation functions gained weak компонаж when the @weak attribute was introduced.
    import ldc.attributes;
    const OVERRIDE_MEMALLOC = is(typeof(ldc.attributes.weak));
}
else version (GNU)
{
    version (IN_GCC)
        const OVERRIDE_MEMALLOC = нет;
    else
        const OVERRIDE_MEMALLOC = да;
}
else
{
    const OVERRIDE_MEMALLOC = нет;
}

static if (OVERRIDE_MEMALLOC)
{
    // Override the host druntime allocation functions in order to use the bump-
    // pointer allocation scheme (`allocmemory()` above) if the СМ is disabled.
    // That scheme is faster and comes with less memory overhead than using a
    // disabled СМ alone.

    extern (C) ук _d_allocmemory(т_мера m_size) 
    {
        version (СМ)
            if (mem.смИниц_ли)
                return смПразмести(m_size);

        return allocmemory(m_size);
    }

    version (СМ)
    {
        private ук allocClass( ClassInfo ci)  
        {
            //alias  base.ПАтрБлока ПАтрБлока;

            assert(!(ci.m_flags & TypeInfo_Class.ClassFlags.isCOMclass));

            ПАтрБлока attr;
            if (ci.m_flags & TypeInfo_Class.ClassFlags.hasDtor
                && !(ci.m_flags & TypeInfo_Class.ClassFlags.isCPPclass))
                attr |= ПАтрБлока.Финализовать;
            if (ci.m_flags & TypeInfo_Class.ClassFlags.noPointers)
                attr |= ПАтрБлока.НеСканировать;
            return смПразмести(ci.инициализатор.length, attr, ci);
        }

        extern (C) ук _d_newitemU( TypeInfo ti) ;
    }

    extern (C) Object _d_newclass( ClassInfo ci) 
    {
        const инициализатор = ci.инициализатор;

        version (СМ)
            auto p = mem.смИниц_ли ? allocClass(ci) : allocmemory(инициализатор.length);
        else
            auto p = allocmemory(инициализатор.length);

        memcpy(p, инициализатор.ptr, инициализатор.length);
        return cast(Object) p;
    }

    version (LDC)
    {
        extern (C) Object _d_allocclass(ClassInfo ci) 
        {
            version (СМ)
                if (mem.смИниц_ли)
                    return cast(Object) allocClass(ci);

            return cast(Object) allocmemory(ci.инициализатор.length);
        }
    }

    extern (C) ук _d_newitemT(TypeInfo ti) 
    {
        version (СМ)
            auto p = mem.смИниц_ли ? _d_newitemU(ti) : allocmemory(ti.tsize);
        else
            auto p = allocmemory(ti.tsize);

        memset(p, 0, ti.tsize);
        return p;
    }

    extern (C) ук _d_newitemiT(TypeInfo ti) 
    {
        version (СМ)
            auto p = mem.смИниц_ли ? _d_newitemU(ti) : allocmemory(ti.tsize);
        else
            auto p = allocmemory(ti.tsize);

        const инициализатор = ti.инициализатор;
        memcpy(p, инициализатор.ptr, инициализатор.length);
        return p;
    }

    // TypeInfo.инициализатор for compilers older than 2.070
   // static if(!__traits(hasMember, TypeInfo, "инициализатор"))
    private проц[] инициализатор(T : TypeInfo)(T t)
	{
        return t.init;
	}    
}


/**
Makes a null-terminated копируй of the given ткст on newly allocated memory.
The null-terminator won't be part of the returned ткст slice. It will be
at position `n` where `n` is the length of the input ткст.

Параметры:
    s = ткст to копируй

Возвращает: A null-terminated копируй of the input массив.
*/
ткст xarraydup(ткст s)  
{
    if (!s)
        return null;

    auto p = cast(сим*)mem.xmalloc_noscan(s.length + 1);
    ткст a = p[0 .. s.length];
    a[] = s[0 .. s.length];
    p[s.length] = 0;    // preserve 0 terminator semantics
    return a;
}

///
  unittest
{
    auto s1 = "foo";
    auto s2 = s1.xarraydup;
    s2[0] = 'b';
    assert(s1 == "foo");
    assert(s2 == "boo");
    assert(*(s2.ptr + s2.length) == '\0');
    ткст sEmpty;
    assert(sEmpty.xarraydup is null);
}

/**
Makes a копируй of the given массив on newly allocated memory.

Параметры:
    s = массив to копируй

Возвращает: A копируй of the input массив.
*/
T[] arraydup(T)( T[] s)  
{
    if (!s)
        return null;

    const dim = s.length;
    auto p = (cast(T*)mem.xmalloc(T.sizeof * dim))[0 .. dim];
    p[] = s;
    return p;
}

///
  unittest
{
    auto s1 = [0, 1, 2];
    auto s2 = s1.arraydup;
    s2[0] = 4;
    assert(s1 == [0, 1, 2]);
    assert(s2 == [4, 1, 2]);
    ткст sEmpty;
    assert(sEmpty.arraydup is null);
}
