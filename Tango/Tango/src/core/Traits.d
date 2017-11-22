/**
 * Модуль traits определяет средства для получения детальной информации
 * времени компиляции о типе. Смешанная схема именований здесь используется
 * намеренно.Шаблоны, оцениваемые в какой-либо тип, следуют конвенции
 * именования, используемой для типов, а шаблоны, оцениваемые в какое-л.
 * значение, - конвенции именований, используемой для функций.
 *
 * Copyright: Copyright (C) 2005-2006 Sean Kelly.  все rights reserved.
 * License:   BSD стиль: $(LICENSE)
 * Authors:   Sean Kelly, Fawzi Mohamed, Abscissa
 */
module core.Traits;

//Модуль необходимо объединить с tpl.traits и перенести его туда,
//оставив здесь ссылку на него!!!)))) TODO

/**
 * Оценивается в да, если T является ткст, шим[] или дим[].
 */
template типТкст_ли( T )
{
    const бул типТкст_ли = is( T : ткст )  ||
                              is( T : шим[] ) ||
                              is( T : дим[] );
}

/**
 * Оценивается в да, если T является сим, шим или дим.
 */
template типСим_ли( T )
{
    const бул типСим_ли = is( T == сим )  ||
                            is( T == шим ) ||
                            is( T == дим );
}


/**
 * Оценивается в да, если T является целым со знаком.
 */
template типЦел_ли( T )
{
    const бул типЦел_ли = is( T == байт )  ||
                                     is( T == крат ) ||
                                     is( T == цел )   ||
                                     is( T == дол )/+||
                                     is( T == cent  )+/;
}


/**
 * Оценивается в да, если T является целым без знака.
 */
template типБЦел_ли( T )
{
    const бул типБЦел_ли = is( T == ббайт )  ||
                                       is( T == бкрат ) ||
                                       is( T == бцел )   ||
                                       is( T == бдол )/+||
                                       is( T == ucent  )+/;
}


/**
 * Оценивается в да, если T является целым со знаком или без знака.
 */
template типЦелЧис_ли( T )
{
    const бул типЦелЧис_ли = типЦел_ли!(T) ||
                               типБЦел_ли!(T);
}


/**
 * Оценивается в да, если T является реальной дробью.
 */
template типРеал_ли( T )
{
    const бул типРеал_ли = is( T == плав )  ||
                            is( T == дво ) ||
                            is( T == реал );
}


/**
 * Оценивается в да, если T является комплексной дробью.
 */
template типКомплекс_ли( T )
{
    const бул типКомплекс_ли = is( T == кплав )  ||
                               is( T == кдво ) ||
                               is( T == креал );
}


/**
 * Оценивается в да, если T является мнимой дробью.
 */
template типМнимое_ли( T )
{
    const бул типМнимое_ли = is( T == вплав )  ||
                                 is( T == вдво ) ||
                                 is( T == вреал );
}


/**
 * Оценивается в да, если T любого дробного типа: реал, комплексное или
 * мнимое.
 */
template типДробь_ли( T )
{
    const бул типДробь_ли = типРеал_ли!(T)    ||
                                     типКомплекс_ли!(T) ||
                                     типМнимое_ли!(T);
}

/// да, если Т - атомного типа
template типАтом_ли(T)
{
    static if( is( T == бул )
            || is( T == сим )
            || is( T == шим )
            || is( T == дим )
            || is( T == байт )
            || is( T == крат )
            || is( T == цел )
            || is( T == дол )
            || is( T == ббайт )
            || is( T == бкрат )
            || is( T == бцел )
            || is( T == бдол )
            || is( T == плав )
            || is( T == дво )
            || is( T == реал )
            || is( T == вплав )
            || is( T == вдво )
            || is( T == вреал ) )
        const типАтом_ли = да;
    else
        const типАтом_ли = нет;
}

/**
 * комплексное тип for the given тип
 */
template КомплексныйТипИз(T){
    static if(is(T==плав)||is(T==вплав)||is(T==кплав)){
        alias кплав КомплексныйТипИз;
    } else static if(is(T==дво)|| is(T==вдво)|| is(T==кдво)){
        alias кдво КомплексныйТипИз;
    } else static if(is(T==реал)|| is(T==вреал)|| is(T==креал)){
        alias креал КомплексныйТипИз;
    } else static assert(0,"неподдерживаемый тип в КомплексныйТипИз "~T.stringof);
}

/**
 * реал тип for the given тип
 */
template РеальныйТипИз(T){
    static if(is(T==плав)|| is(T==вплав)|| is(T==кплав)){
        alias плав РеальныйТипИз;
    } else static if(is(T==дво)|| is(T==вдво)|| is(T==кдво)){
        alias дво РеальныйТипИз;
    } else static if(is(T==реал)|| is(T==вреал)|| is(T==креал)){
        alias реал РеальныйТипИз;
    } else static assert(0,"неподдерживаемый тип в РеальныйТипИз "~T.stringof);
}

/**
 * мнимое тип for the given тип
 */
template МнимыйТипИз(T){
    static if(is(T==плав)|| is(T==вплав)|| is(T==кплав)){
        alias вплав МнимыйТипИз;
    } else static if(is(T==дво)|| is(T==вдво)|| is(T==кдво)){
        alias вдво МнимыйТипИз;
    } else static if(is(T==реал)|| is(T==вреал)|| is(T==креал)){
        alias вреал МнимыйТипИз;
    } else static assert(0,"неподдерживаемый тип в МнимыйТипИз "~T.stringof);
}

/// тип с максимальной точностью
template МаксПрецТипИз(T){
    static if (типКомплекс_ли!(T)){
        alias креал МаксПрецТипИз;
    } else static if (типМнимое_ли!(T)){
        alias вреал МаксПрецТипИз;
    } else {
        alias реал МаксПрецТипИз;
    }
}


/**
 * Оценивается в да, если T является a pointer тип.
 */
template типУк_ли(T)
{
        const типУк_ли = нет;
}

template типУк_ли(T : T*)
{
        const типУк_ли = да;
}

debug( UnitTest )
{
    unittest
    {
        static assert( типУк_ли!(проц*) );
        static assert( !типУк_ли!(ткст) );
        static assert( типУк_ли!(ткст*) );
        static assert( !типУк_ли!(сим*[]) );
        static assert( типУк_ли!(реал*) );
        static assert( !типУк_ли!(бцел) );
        static assert( is(МаксПрецТипИз!(плав)==реал));
        static assert( is(МаксПрецТипИз!(кплав)==креал));
        static assert( is(МаксПрецТипИз!(вплав)==вреал));

        class Ham
        {
            ук  a;
        }

        static assert( !типУк_ли!(Ham) );

        union Eggs
        {
            ук  a;
            бцел  b;
        };

        static assert( !типУк_ли!(Eggs) );
        static assert( типУк_ли!(Eggs*) );

        struct Bacon {};

        static assert( !типУк_ли!(Bacon) );

    }
}

/**
 * Оценивается в да, если T является указателем, классом, интерфейсом или делегатом.
 */
template типСсылка_ли( T )
{

    const бул типСсылка_ли = типУк_ли!(T)  ||
                               is( T == class )     ||
                               is( T == interface ) ||
                               is( T == delegate );
}


/**
 * Оценивается в да, если T является a dynamic Массив тип.
 */
template типДинМас_ли( T )
{
    const бул типДинМас_ли = is( typeof(T.init[0])[] == T );
}

/**
 * Оценивается в да, если T является a static Массив тип.
 */
version( GNU )
{
    // GDC should also be able в_ use the другой version, but it probably
    // relies on a frontend fix in one of the latest DMD versions - will
    // удали this when GDC is ready. For сейчас, this код пароль the unittests.
    private template экзТипаСтатМас( T )
    {
        const T экзТипаСтатМас =void;
    }

    template типСтатМас_ли( T )
    {
        static if( is( typeof(T.length) ) && !is( typeof(T) == typeof(T.init) ) )
        {
            const бул типСтатМас_ли = is( T == typeof(T[0])[экзТипаСтатМас!(T).length] );
        }
        else
        {
            const бул типСтатМас_ли = нет;
        }
    }
}
else
{
    template типСтатМас_ли( T : T[U], т_мера U )
    {
        const бул типСтатМас_ли = да;
    }

    template типСтатМас_ли( T )
    {
        const бул типСтатМас_ли = нет;
    }
}

/// да for Массив типы
template типМассив_ли(T)
{
    static if (is( T U : U[] ))
        const бул типМассив_ли=да;
    else
        const бул типМассив_ли=нет;
}

debug( UnitTest )
{
    unittest
    {
        static assert( типСтатМас_ли!(сим[5][2]) );
        static assert( !типДинМас_ли!(сим[5][2]) );
        static assert( типМассив_ли!(сим[5][2]) );

        static assert( типСтатМас_ли!(сим[15]) );
        static assert( !типСтатМас_ли!(ткст) );

        static assert( типДинМас_ли!(ткст) );
        static assert( !типДинМас_ли!(сим[15]) );

        static assert( типМассив_ли!(сим[15]) );
        static assert( типМассив_ли!(ткст) );
        static assert( !типМассив_ли!(сим) );
    }
}

/**
 * Оценивается в да, если T является an associative Массив тип.
 */
template типАссоцМассив_ли( T )
{
    const бул типАссоцМассив_ли = is( typeof(T.init.values[0])[typeof(T.init.ключи[0])] == T );
}


/**
 * Оценивается в да, если T является a function, function pointer, delegate, or
 * callable объект.
 */
template ВызываемыйТип_ли( T )
{
    const бул ВызываемыйТип_ли = is( T == function )             ||
                                is( typeof(*T) == function )    ||
                                is( T == delegate )             ||
                                is( typeof(T.opCall) == function );
}


/**
 * Evaluates в_ the return тип of Фн.  Фн is required в_ be a callable тип.
 */
template ВозвратныйТипИз( Фн )
{
    static if( is( Фн Возвр == return ) )
        alias Возвр ВозвратныйТипИз;
    else
        static assert( нет, "Аргумент не имеет возвратного типа." );
}

/** 
 * Returns the тип that a T would evaluate в_ in an expression.
 * Выраж is not required в_ be a callable тип
 */ 
template ТипВыражениеИз( Выраж )
{
    static if(ВызываемыйТип_ли!( Выраж ))
        alias ВозвратныйТипИз!( Выраж ) ТипВыражениеИз;
    else
        alias Выраж ТипВыражениеИз;
}


/**
 * Evaluates в_ the return тип of фн.  фн is required в_ be callable.
 */
template ВозвратныйТипИз( alias фн )
{
    static if( is( typeof(фн) База == typedef ) )
        alias ВозвратныйТипИз!(База) ВозвратныйТипИз;
    else
        alias ВозвратныйТипИз!(typeof(фн)) ВозвратныйТипИз;
}


/**
 * Evaluates в_ a tuple representing the параметры of Фн.  Фн is required в_
 * be a callable тип.
 */
template КортежПараметровИз( Фн )
{
    static if( is( Фн Парамы == function ) )
        alias Парамы КортежПараметровИз;
    else static if( is( Фн Парамы == delegate ) )
        alias КортежПараметровИз!(Парамы) КортежПараметровИз;
    else static if( is( Фн Парамы == Парамы* ) )
        alias КортежПараметровИз!(Парамы) КортежПараметровИз;
    else
        static assert( нет, "Аргумент не имеет параметров." );
}


/**
 * Evaluates в_ a tuple representing the параметры of фн.  n is required в_
 * be callable.
 */
template КортежПараметровИз( alias фн )
{
    static if( is( typeof(фн) База == typedef ) )
        alias КортежПараметровИз!(База) КортежПараметровИз;
    else
        alias КортежПараметровИз!(typeof(фн)) КортежПараметровИз;
}


/**
 * Evaluates в_ a tuple representing the ancestors of T.  T is required в_ be
 * a class or interface тип.
 */
template КортежБазовыхТиповИз( T )
{
    static if( is( T База == super ) )
        alias База КортежБазовыхТиповИз;
    else
        static assert( нет, "Аргумент не является классом или интерфейсом." );
}

/**
 * StrИПs the []'s off of a тип.
 */
template БазТипМассивов(T)
{
    static if( is( T S : S[]) ) {
        alias БазТипМассивов!(S)  БазТипМассивов;
    }
    else {
        alias T БазТипМассивов;
    }
}

/**
 * strИПs one [] off a тип
 */
template ЭлементТипаМассив(T:T[])
{
    alias T ЭлементТипаМассив;
}

/**
 * Count the []'s on an Массив тип
 */
template рангМассива(T) {
    static if(is(T S : S[])) {
        const бцел рангМассива = 1 + рангМассива!(S);
    } else {
        const бцел рангМассива = 0;
    }
}

/// тип of the ключи of an AA
template ТипКлючАМ(T){
    alias typeof(T.init.ключи[0]) ТипКлючАМ;
}

/// тип of the values of an AA
template ТипЗначениеАМ(T){
    alias typeof(T.init.values[0]) ТипЗначениеАМ;
}

/// returns the размер of a static Массив
template размерСтатичМассива(T)
{
    static assert(типСтатМас_ли!(T),"размерСтатичМассива требует статический Массив в качестве типа");
    static assert(рангМассива!(T)==1,"реализовано только для массивов 1d...");
    const т_мера размерСтатичМассива=(T).sizeof / typeof(T.init).sizeof;
}

/// is T is static Массив returns a dynamic Массив, otherwise returns T
template ТипДинамичМассив(T)
{
    static if( типСтатМас_ли!(T) )
        alias typeof(T.dup) ТипДинамичМассив;
    else
        alias T ТипДинамичМассив;
}

debug( UnitTest )
{
    static assert( is(БазТипМассивов!(реал[][])==реал) );
    static assert( is(БазТипМассивов!(реал[2][3])==реал) );
    static assert( is(ЭлементТипаМассив!(реал[])==реал) );
    static assert( is(ЭлементТипаМассив!(реал[][])==реал[]) );
    static assert( is(ЭлементТипаМассив!(реал[2][])==реал[2]) );
    static assert( is(ЭлементТипаМассив!(реал[2][2])==реал[2]) );
    static assert( рангМассива!(реал[][])==2 );
    static assert( рангМассива!(реал[2][])==2 );
    static assert( is(ТипЗначениеАМ!(сим[цел])==сим));
    static assert( is(ТипКлючАМ!(сим[цел])==цел));
    static assert( is(ТипЗначениеАМ!(ткст[цел])==ткст));
    static assert( is(ТипКлючАМ!(ткст[цел[]])==цел[]));
    static assert( типАссоцМассив_ли!(ткст[цел[]]));
    static assert( !типАссоцМассив_ли!(ткст));
    static assert( is(ТипДинамичМассив!(сим[2])==ТипДинамичМассив!(ткст)));
    static assert( is(ТипДинамичМассив!(сим[2])==ткст));
    static assert( размерСтатичМассива!(сим[2])==2);
}

// ------- CTFE -------

/// компилируй время целое в_ ткст
сим [] ctfe_i2a(цел i){
    ткст цифра="0123456789";
    ткст рез="";
    if (i==0){
        return "0";
    }
    бул neg=нет;
    if (i<0){
        neg=да;
        i=-i;
    }
    while (i>0) {
        рез=цифра[i%10]~рез;
        i/=10;
    }
    if (neg)
        return '-'~рез;
    else
        return рез;
}
/// ditto
сим [] ctfe_i2a(дол i){
    ткст цифра="0123456789";
    ткст рез="";
    if (i==0){
        return "0";
    }
    бул neg=нет;
    if (i<0){
        neg=да;
        i=-i;
    }
    while (i>0) {
        рез=цифра[cast(т_мера)(i%10)]~рез;
        i/=10;
    }
    if (neg)
        return '-'~рез;
    else
        return рез;
}
/// ditto
сим [] ctfe_i2a(бцел i){
    ткст цифра="0123456789";
    ткст рез="";
    if (i==0){
        return "0";
    }
    бул neg=нет;
    while (i>0) {
        рез=цифра[i%10]~рез;
        i/=10;
    }
    return рез;
}
/// ditto
сим [] ctfe_i2a(бдол i){
    ткст цифра="0123456789";
    ткст рез="";
    if (i==0){
        return "0";
    }
    бул neg=нет;
    while (i>0) {
        рез=цифра[cast(т_мера)(i%10)]~рез;
        i/=10;
    }
    return рез;
}

debug( UnitTest )
{
    unittest {
    static assert( ctfe_i2a(31)=="31" );
    static assert( ctfe_i2a(-31)=="-31" );
    static assert( ctfe_i2a(14u)=="14" );
    static assert( ctfe_i2a(14L)=="14" );
    static assert( ctfe_i2a(14UL)=="14" );
    }
}
