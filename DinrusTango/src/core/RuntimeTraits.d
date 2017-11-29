/** 
 * Provопрes рантайм traits, which provопрe much of the functionality of Traits and
 * is-expressions, as well as some functionality that is only available at рантайм, using 
 * рантайм тип information. 
 * 
 * Authors: Chris Wright (dhasenan) <dhasenan@gmail.com>
 * License: DinrusTango.lib license, apache 2.0
 * Copyright (c) 2009, CHRISTOPHER WRIGHT
 */
module core.RuntimeTraits;

/// If the given тип represents a typedef, return the actual тип.
ИнфОТипе реальныйТип (ИнфОТипе тип)
{
    // TypeInfo_Typedef.следщ() doesn't return the actual тип.
    // I think it returns TypeInfo_Typedef.основа.следщ().
    // So, a slightly different метод.
    auto def = cast(ТипТипдеф) тип;
    if (def !is пусто)
    {
        return def.основа;
    }
    return тип;
}

/// If the given тип represents a class, return its ИнфОКлассе; else return пусто;
ИнфОКлассе какКласс (ИнфОТипе тип)
{
    if (интерфейс_ли (тип))
    {
        auto klass = cast(ТипИнтерфейс) тип;
        return klass.инфо;
    }
    if (класс_ли (тип))
    {
        auto klass = cast(ТипКласс) тип;
        return klass.инфо;
    }
    return пусто;
}

/** Returns да iff one тип is an ancestor of the другой, or if the типы are the same.
 * If either is пусто, returns нет. */
бул производный_ли (ИнфОКлассе производный, ИнфОКлассе основа)
{
    if (производный is пусто || основа is пусто)
        return нет;
    do
        if (производный is основа)
            return да;
    while ((производный = производный.основа) !is пусто)
    return нет;
}

/** Returns да iff implementor реализует the interface described
 * by iface. This is an expensive operation (linear in the число of
 * interfaces and основа classes).
 */
бул реализует (ИнфОКлассе implementor, ИнфОКлассе iface)
{
    foreach (инфо; примениИнтерфейсы (implementor))
    {
        if (iface is инфо)
            return да;
    }
    return нет;
}

/** Returns да iff an экземпляр of class тест is implicitly castable в_ мишень. 
 * This is an expensive operation (производный_ли + реализует). */
бул непосредственно_ли (ИнфОКлассе тест, ИнфОКлассе мишень)
{
    // Keep производный_ли first.
    // производный_ли will be much faster than реализует.
    return (производный_ли (тест, мишень) || реализует (тест, мишень));
}

/** Returns да iff an экземпляр of тип тест is implicitly castable в_ мишень. 
 * If the типы describe classes or interfaces, this is an expensive operation. */
бул непосредственно_ли (ИнфОТипе тест, ИнфОТипе мишень)
{
    // A lot of special cases. This is ugly.
    if (тест is мишень)
        return да;
    if (статМасс_ли (тест) && динМасс_ли (мишень) && типЗначение (тест) is типЗначение (мишень))
    {
        // you can implicitly cast static в_ dynamic (currently) if they 
        // have the same значение тип. Other casts should be forbопрden.
        return да;
    }
    auto klass1 = какКласс (тест);
    auto klass2 = какКласс (мишень);
    if (класс_ли (тест) && класс_ли (мишень))
    {
        return производный_ли (klass1, klass2);
    }
    if (интерфейс_ли (тест) && интерфейс_ли (мишень))
    {
        return производный_ли (klass1, klass2);
    }
    if (klass1 && klass2)
    {
        return непосредственно_ли (klass1, klass2);
    }
    if (klass1 || klass2)
    {
        // no casts из_ class в_ non-class
        return нет;
    }
    if ((значЦел_ли (тест) && значЦел_ли (мишень)) || (беззначЦел_ли (тест) && беззначЦел_ли (мишень)) || (плав_ли (
            тест) && плав_ли (мишень)) || (символ_ли (тест) && символ_ли (мишень)))
    {
        return тест.tsize () <= мишень.tsize ();
    }
    if (значЦел_ли (тест) && беззначЦел_ли (мишень))
    {
        // potential loss of данные
        return нет;
    }
    if (беззначЦел_ли (тест) && значЦел_ли (мишень))
    {
        // if the sizes are the same, you could be losing данные
        // the upper half of the range wraps around в_ negatives
        // if the мишень тип is larger, you can safely hold it
        return тест.tsize () < мишень.tsize ();
    }
    // delegates and functions: no can do
    // pointers: no
    // structs: no
    return нет;
}

///
ИнфОКлассе[] классыОсновы (ИнфОКлассе тип)
{
    if (тип is пусто)
        return пусто;
    ИнфОКлассе[] типы;
    while ((тип = тип.основа) !is пусто)
        типы ~= тип;
    return типы;
}

/** Returns a список of все interfaces that this тип реализует, directly
 * or indirectly. This включает основа interfaces of типы the class реализует,
 * and interfaces that основа classes implement, and основа interfaces of interfaces
 * that основа classes implement. This is an expensive operation. */
ИнфОКлассе[] интерфейсыОсновы (ИнфОКлассе тип)
{
    if (тип is пусто)
        return пусто;
    ИнфОКлассе[] типы = прямыеИнтерфейсы (тип);
    while ((тип = тип.основа) !is пусто)
    {
        типы ~= графИнтерфейсов (тип);
    }
    return типы;
}

/** Returns все the interfaces that this тип directly реализует, включая
 * inherited interfaces. This is an expensive operation.
 * 
 * Examples:
 * ---
 * interface I1 {}
 * interface I2 : I1 {}
 * class A : I2 {}
 * 
 * auto interfaces = графИнтерфейсов (A.classinfo);
 * // interfaces = [I1.classinfo, I2.classinfo]
 * --- 
 * 
 * ---
 * interface I1 {}
 * interface I2 {}
 * class A : I1 {}
 * class B : A, I2 {}
 * 
 * auto interfaces = графИнтерфейсов (B.classinfo);
 * // interfaces = [I2.classinfo]
 * ---
 */
ИнфОКлассе[] графИнтерфейсов (ИнфОКлассе тип)
{
    ИнфОКлассе[] инфо;
    foreach (iface; тип.interfaces)
    {
        инфо ~= iface.classinfo;
        инфо ~= графИнтерфейсов (iface.classinfo);
    }
    return инфо;
}

/** Iterate through все interfaces that тип реализует, directly or indirectly, включая основа interfaces. */
struct примениИнтерфейсы
{
    ///
    static примениИнтерфейсы opCall (ИнфОКлассе тип)
    {
        примениИнтерфейсы apply;
        apply.тип = тип;
        return apply;
    }

    ///
    цел opApply (цел delegate (ref ИнфОКлассе) дг)
    {
        цел результат = 0;
        for (; тип; тип = тип.основа)
        {
            foreach (iface; тип.interfaces)
            {
                результат = дг (iface.classinfo);
                if (результат)
                    return результат;
                результат = примениИнтерфейсы (iface.classinfo).opApply (дг);
                if (результат)
                    return результат;
            }
        }
        return результат;
    }

    ИнфОКлассе тип;
}

///
ИнфОКлассе[] типыОсновы (ИнфОКлассе тип)
{
    if (тип is пусто)
        return пусто;
    return классыОсновы (тип) ~ интерфейсыОсновы (тип);
}

///
ИнфОМодуле модульИз (ИнфОКлассе тип)
{
    foreach (modula; ИнфОМодуле)
        foreach (klass; modula.localClasses)
            if (klass is тип)
                return modula;
    return пусто;
}

/// Returns a список of interfaces that this class directly реализует.
ИнфОКлассе[] прямыеИнтерфейсы (ИнфОКлассе тип)
{
    ИнфОКлассе[] типы;
    foreach (iface; тип.interfaces)
        типы ~= iface.classinfo;
    return типы;
}

/** Returns a список of все типы that are производный из_ the given тип. This does not 
 * счёт interfaces; that is, if тип is an interface, you will only получи производный 
 * interfaces back. It is an expensive operations. */
ИнфОКлассе[] производныеТипы (ИнфОКлассе тип)
{
    ИнфОКлассе[] типы;
    foreach (modula; ИнфОМодуле)
        foreach (klass; modula.localClasses)
            if (производный_ли (klass, тип) && (klass !is тип))
                типы ~= klass;
    return типы;
}

///
бул динМасс_ли (ИнфОТипе тип)
{
    // This implementation is evil.
    // Массив typeinfos are named TypeInfo_A?, and defined indivопрually for each
    // possible тип asопрe из_ structs. For example, typeinfo for цел[] is
    // TypeInfo_Ai; for бцел[], TypeInfo_Ak.
    // So any ИнфОТипе with length 11 and starting with TypeInfo_A is an Массив
    // тип.
    // Also, TypeInfo_Array is an Массив тип.
    тип = реальныйТип (тип);
    return ((тип.classinfo.имя[9] == 'A') && (тип.classinfo.имя.length == 11)) || ((cast(TypeInfo_Array) тип) !is пусто);
}

///
бул статМасс_ли (ИнфОТипе тип)
{
    тип = реальныйТип (тип);
    return (cast(TypeInfo_StaticArray) тип) !is пусто;
}

/** Returns да iff the given тип is a dynamic or static Массив (нет for associative
 * массивы and non-массивы). */
бул массив_ли (ИнфОТипе тип)
{
    тип = реальныйТип (тип);
    return динМасс_ли (тип) || статМасс_ли (тип);
}

///
бул ассоцМасс_ли (ИнфОТипе тип)
{
    тип = реальныйТип (тип);
    return (cast(TypeInfo_AssociativeArray) тип) !is пусто;
}

///
бул символ_ли (ИнфОТипе тип)
{
    тип = реальныйТип (тип);
    return (тип is typeid(сим) || тип is typeid(шим) || тип is typeid(дим));
}

///
бул ткст_ли (ИнфОТипе тип)
{
    тип = реальныйТип (тип);
    return массив_ли (тип) && символ_ли (типЗначение (тип));
}

///
бул беззначЦел_ли (ИнфОТипе тип)
{
    тип = реальныйТип (тип);
    return (тип is typeid(бцел) || тип is typeid(бдол) || тип is typeid(бкрат) || тип is typeid(ббайт));
}

///
бул значЦел_ли (ИнфОТипе тип)
{
    тип = реальныйТип (тип);
    return (тип is typeid(цел) || тип is typeid(дол) || тип is typeid(крат) || тип is typeid(байт));
}

///
бул цел_ли (ИнфОТипе тип)
{
    тип = реальныйТип (тип);
    return значЦел_ли (тип) || беззначЦел_ли (тип);
}

///
бул бул_ли (ИнфОТипе тип)
{
    тип = реальныйТип (тип);
    return (тип is typeid(бул));
}

///
бул плав_ли (ИнфОТипе тип)
{
    тип = реальныйТип (тип);
    return (тип is typeid(плав) || тип is typeid(дво) || тип is typeid(реал));
}

///
бул примитив_ли (ИнфОТипе тип)
{
    тип = реальныйТип (тип);
    return (массив_ли (тип) || ассоцМасс_ли (тип) || символ_ли (тип) || плав_ли (тип) || цел_ли (тип));
}

/// Returns да iff the given тип represents an interface.
бул интерфейс_ли (ИнфОТипе тип)
{
    return (cast(ТипИнтерфейс) тип) !is пусто;
}

///
бул указатель_ли (ИнфОТипе тип)
{
    тип = реальныйТип (тип);
    return (cast(TypeInfo_Pointer) тип) !is пусто;
}

/// Returns да iff the тип represents a class (нет for interfaces).
бул класс_ли (ИнфОТипе тип)
{
    тип = реальныйТип (тип);
    return (cast(ТипКласс) тип) !is пусто;
}

///
бул структ_ли (ИнфОТипе тип)
{
    тип = реальныйТип (тип);
    return (cast(TypeInfo_Struct) тип) !is пусто;
}

///
бул функция_ли (ИнфОТипе тип)
{
    тип = реальныйТип (тип);
    return ((cast(TypeInfo_Function) тип) !is пусто) || ((cast(TypeInfo_Delegate) тип) !is пусто);
}

/** Returns да iff the given тип is a reference тип. */
бул типСсылка_ли (ИнфОТипе тип)
{
    return класс_ли (тип) || указатель_ли (тип) || динМасс_ли (тип);
}

/** Returns да iff the given тип represents a пользовательский тип. 
 * This does not include functions, delegates, aliases, or typedefs. */
бул пользовательскТип_ли (ИнфОТипе тип)
{
    return класс_ли (тип) || структ_ли (тип);
}

/** Returns да for все значение типы, нет for все reference типы.
 * For functions and delegates, returns нет (is this the way it should be?). */
бул типЗначение_ли (ИнфОТипе тип)
{
    return !(динМасс_ли (тип) || ассоцМасс_ли (тип) || указатель_ли (тип) || класс_ли (тип) || функция_ли (
            тип));
}

/** The ключ тип of the given тип. For an Массив, т_мера; for an associative
 * Массив T[U], U. */
ИнфОТипе типКлюч (ИнфОТипе тип)
{
    тип = реальныйТип (тип);
    auto assocArray = cast(TypeInfo_AssociativeArray) тип;
    if (assocArray)
        return assocArray.ключ;
    if (массив_ли (тип))
        return typeid(т_мера);
    return пусто;
}

/** The значение тип of the given тип -- given T[] or T[n], T; given T[U],
 * T; given T*, T; anything else, пусто. */
ИнфОТипе типЗначение (ИнфОТипе тип)
{
    тип = реальныйТип (тип);
    if (массив_ли (тип))
        return тип.следщ;
    auto assocArray = cast(TypeInfo_AssociativeArray) тип;
    if (assocArray)
        return assocArray.значение;
    auto pointer = cast(TypeInfo_Pointer) тип;
    if (pointer)
        return pointer.m_next;
    return пусто;
}

/** If the given тип represents a delegate or function, the return тип
 * of that function. Otherwise, пусто. */
ИнфОТипе типВозврат (ИнфОТипе тип)
{
    тип = реальныйТип (тип);
    auto delegat = cast(TypeInfo_Delegate) тип;
    if (delegat)
        return delegat.следщ;
    auto func = cast(TypeInfo_Function) тип;
    if (func)
        return func.следщ;
    return пусто;
}

debug (UnitTest)
{

    interface I1
    {
    }

    interface I2
    {
    }

    interface I3
    {
    }

    interface I4
    {
    }

    class A
    {
    }

    class B : A, I1
    {
    }

    class C : B, I2, I3
    {
    }

    class D : A, I1
    {
        цел foo (цел i)
        {
            return i;
        }
    }

    struct S1
    {
    }

    unittest {
        // Struct-related stuff.
        auto тип = typeid(S1);
        assert (структ_ли (тип));
        assert (типЗначение_ли (тип));
        assert (пользовательскТип_ли (тип));
        assert (!класс_ли (тип));
        assert (!указатель_ли (тип));
        assert (пусто is типВозврат (тип));
        assert (!примитив_ли (тип));
        assert (типЗначение (тип) is пусто);
    }

    unittest {
        auto тип = A.classinfo;
        assert (типыОсновы (тип) == [Объект.classinfo]);
        assert (классыОсновы (тип) == [Объект.classinfo]);
        assert (интерфейсыОсновы (тип).length == 0);
        тип = C.classinfo;
        assert (классыОсновы (тип) == [B.classinfo, A.classinfo, Объект.classinfo]);
        assert (интерфейсыОсновы (тип) == [I2.classinfo, I3.classinfo, I1.classinfo]);
        assert (типыОсновы (тип) == [B.classinfo, A.classinfo, Объект.classinfo, I2.classinfo, I3.classinfo,
                I1.classinfo]);
    }

    unittest {
        assert (указатель_ли (typeid(S1*)));
        assert (массив_ли (typeid(S1[])));
        assert (типЗначение (typeid(S1*)) is typeid(S1));
        auto d = new D;
        assert (типВозврат (typeid(typeof(&d.foo))) is typeid(цел));
        assert (плав_ли (typeid(реал)));
        assert (плав_ли (typeid(дво)));
        assert (плав_ли (typeid(плав)));
        assert (!плав_ли (typeid(креал)));
        assert (!плав_ли (typeid(кдво)));
        assert (!цел_ли (typeid(плав)));
        assert (!цел_ли (typeid(креал)));
        assert (цел_ли (typeid(бдол)));
        assert (цел_ли (typeid(ббайт)));
        assert (символ_ли (typeid(сим)));
        assert (символ_ли (typeid(шим)));
        assert (символ_ли (typeid(дим)));
        assert (!символ_ли (typeid(ббайт)));
        assert (массив_ли (typeid(typeof("hello"))));
        assert (символ_ли (typeid(typeof("hello"[0]))));
        assert (типЗначение (typeid(typeof("hello"))) is typeid(typeof('h')));
        assert (ткст_ли (typeid(typeof("hello"))), typeof("hello").stringof);
        auto staticString = typeid(typeof("hello"d));
        auto dynamicString = typeid(typeof("hello"d[0 .. $]));
        assert (ткст_ли (staticString));
        assert (статМасс_ли (staticString));
        assert (динМасс_ли (dynamicString), dynamicString.вТкст () ~ dynamicString.classinfo.имя);
        assert (ткст_ли (dynamicString));

        auto тип = typeid(цел[ткст]);
        assert (типЗначение (тип) is typeid(цел), типЗначение (тип).вТкст ());
        assert (типКлюч (тип) is typeid(ткст), типКлюч (тип).вТкст ());
        проц delegate (цел) дг = (цел i)
        {
        };
        assert (типВозврат (typeid(typeof(дг))) is typeid(проц));
        assert (типВозврат (typeid(цел delegate (цел))) is typeid(цел));

        assert (!динМасс_ли (typeid(цел[4])));
        assert (статМасс_ли (typeid(цел[4])));
    }

    unittest {
        typedef цел myint;
        assert (typeid(myint) !is пусто, "пусто typeid(myint)");
        assert (цел_ли (typeid(myint)));
    }

}
