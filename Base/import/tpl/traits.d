
// Написано на языке программирования Динрус.

/**
 * Шаблоны для извлечения информации о типах во время
 * компиляции.
 *
 * Macros:
 *	WIKI = Phobos/StdTraits
 * Copyright:
 *	Public Domain
 */

/*
 * Authors:
 *	Walter Bright, Digital Mars, www.digitalmars.com
 *	Tomasz Stachowiak (статМас_ли, кортежВыражений_ли)
 */

module tpl.traits;

/***
 * Получить тип возвратного значения функции,
 * указатель на функуцию или делегат.
 * Пример:
 * ---
 * import tpl.traits;
 * цел foo();
 * ВозврТип!(foo) x;   // x объявлен как цел
 * ---
 */
template ВозврТип(alias дг)
{
    alias ВозврТип!(typeof(дг)) ВозврТип;
}

/** описано ранее */
template ВозврТип(дг)
{
    static if (is(дг R == return))
	alias R ВозврТип;
    else
	static assert(0, cast(ткст) "у аргумента отсутствует тип возврата");
}

/***
 * Получить типы заданных функции  параметров,
 * указатель на функцию или на делегат в виде кортежа.
 * Пример:
 * ---
 * import tpl.traits;
 * цел foo(цел, дол);
 * проц bar(КортежТипаПараметр!(foo));      // объявляет проц bar(цел, дол);
 * проц abc(КортежТипаПараметр!(foo)[1]);   // объявляет проц abc(дол);
 * ---
 */
template КортежТипаПараметр(alias дг)
{
    alias КортежТипаПараметр!(typeof(дг)) КортежТипаПараметр;
}

/** описано ранее */
template КортежТипаПараметр(дг)
{
    static if (is(дг P == function))
	alias P КортежТипаПараметр;
    else static if (is(дг P == delegate))
	alias КортежТипаПараметр!(P) КортежТипаПараметр;
    else static if (is(дг P == P*))
	alias КортежТипаПараметр!(P) КортежТипаПараметр;
    else
	static assert(0, cast(ткст) "у аргумента отсутствуют параметры");
}


/***
 * Получить типы полей структуры или класса.
 * Состоят из полей, занимающих пространство памяти,
 * за исключением скрытых полей типа указателя на
 * таблицу виртуальных функций.
 */

template КортежТипаПоле(S)
{
    static if (is(S == struct) || is(S == class))
	alias typeof(S.tupleof) КортежТипаПоле;
    else
	static assert(0, cast(ткст)"аргумент не является структурой или классом");
}

/***
 * Получить $(D_PARAM КортежТипов) базового класса и базовые интерфейсы
 * этого класса или интерфейса. $(D_PARAM КортежТипаОснова!(Объект)) возвращает
 * пустой кортеж типов.
 * 
 * Пример:
 * ---
 * import tpl.traits, tpl.typetuple, stdrus;
 * interface I { }
 * class A { }
 * class B : A, I { }
 *
 * проц main()
 * {
 *     alias КортежТипаОснова!(B) TL;
 *     пишинс(typeid(TL));  // выводит: (A,I)
 * }
 * ---
 */

template КортежТипаОснова(A)
{
    static if (is(A P == super))
    alias P КортежТипаОснова;
    else
    static assert(0, "аргумент не является классом или интерфейсом");
}

unittest
{
    interface I1 { }
    interface I2 { }
    class A { }
    class C : A, I1, I2 { }

    alias КортежТипаОснова!(C) TL;
    assert(TL.length == 3);
    assert(is (TL[0] == A));
    assert(is (TL[1] == I1));
    assert(is (TL[2] == I2));

    assert(КортежТипаОснова!(Объект).length == 0);
}

/* *******************************************
 */
private template isStaticArray_impl(Т)
{
    const Т inst = void;
    
    static if (is(typeof(Т.length)))
    {
	static if (!is(Т == typeof(Т.init)))
	{			// abuses the fact that цел[5].init == цел
	    static if (is(Т == typeof(Т[0])[inst.length]))
	    {	// sanity check. this check alone isn't enough because dmd complains about dynamic arrays
		const бул рез =да;
	    }
	    else
		const бул рез = нет;
	}
	else
	    const бул рез = нет;
    }
    else
    {
	    const бул рез = нет;
    }
}
/**
 * Detect whether тип Т is a static массив.
 */
template статМас_ли(Т)
{
    const бул статМас_ли = isStaticArray_impl!(Т).рез;
}


static assert (статМас_ли!(цел[51]));
static assert (статМас_ли!(цел[][2]));
static assert (статМас_ли!(сим[][цел][11]));
static assert (!статМас_ли!(цел[]));
static assert (!статМас_ли!(цел[сим]));
static assert (!статМас_ли!(цел[1][]));

/**
 * Tells whether the кортеж Т is an expression кортеж.
 */
template кортежВыражений_ли(Т ...)
{
    static if (is(проц function(Т)))
	const бул кортежВыражений_ли = нет;
    else
	const бул кортежВыражений_ли = да;
}

//std2.traits

/***
 * Получить тип возврата функции,
 * указатель на функцию, структуру с opCall
 * или класс с opCall.
 * Пример:
 * ---
 * import tpl.traits;
 * цел foo();
 * ТипВозврата2!(foo) x;   // x объявлен как цел
 * ---
 */
template ТипВозврата2(alias дг)
{
    alias ТипВозврата2!(typeof(дг), проц) ТипВозврата2;
}

template ТипВозврата2(дг, dummy = void)
{
    static if (is(дг R == return))
	alias R ТипВозврата2;
    else static if (is(дг Т : Т*))
	alias ТипВозврата2!(Т, проц) ТипВозврата2;
    else static if (is(дг S == struct))
	alias ТипВозврата2!(typeof(&дг.opCall), проц) ТипВозврата2;
    else static if (is(дг C == class))
	alias ТипВозврата2!(typeof(&дг.opCall), проц) ТипВозврата2;
    else
	static assert(0, "у аргумента нет возвратного типа");
}

unittest
{
    struct G
    {
	цел opCall (цел i) { return 1;}
    }

    //alias ТипВозврата2!(G) ShouldBeInt;
   // static assert(is(ShouldBeInt == цел));

    G g;
    static assert(is(ТипВозврата2!(g) == цел));

    G* p;
    alias ТипВозврата2!(p) pg;
    static assert(is(pg == цел));

    class C
    {
	цел opCall (цел i) { return 1;}
    }

   // static assert(is(ТипВозврата2!(C) == цел));

    C c;
    static assert(is(ТипВозврата2!(c) == цел));
}

/***
 * Получить  типы параметров функции,
 * указатель на функцию или делегата в качестве кортежа.
 * Пример:
 * ---
 * import std.traits;
 * цел foo(цел, дол);
 * проц bar(КортежТипаПараметров!(foo));      // declares проц bar(цел, дол);
 * проц abc(КортежТипаПараметров!(foo)[1]);   // declares проц abc(дол);
 * ---
 */
template КортежТипаПараметров(alias дг)
{
    alias КортежТипаПараметров!(typeof(дг)) КортежТипаПараметров;
}

/** описано ранее */
template КортежТипаПараметров(дг)
{
    static if (is(дг P == function))
	alias P КортежТипаПараметров;
    else static if (is(дг P == delegate))
	alias КортежТипаПараметров!(P) КортежТипаПараметров;
    else static if (is(дг P == P*))
	alias КортежТипаПараметров!(P) КортежТипаПараметров;
    else
	static assert(0, "у аргумента параметры отсутствуют");
}


/***
 * Получить типы полей структуры или класса.
 * Состоит из полей, которые захватывают пространство памяти,
 * исключая скрытые поля, как указатель на таблицу виртуальных
 * функций.
 */

template КортежТиповПолей(S)
{
    static if (is(S == struct) || is(S == class) || is(S == union))
	alias typeof(S.tupleof) КортежТиповПолей;
    else
        alias S КортежТиповПолей;
	//static assert(0, "аргумент не является структурой или классом");
}

// // КортежСмещенийПолей
// protected template КортежСмещенийПолей_реализ(т_мера n, Т...)
// {
//     static if (Т.length == 0)
//     {
//         alias КортежТипов!() Результат;
//     }
//     else
//     {
//         //protected alias КортежТиповПолей!(Т[0]) Типы;
//         protected const т_мера мСмещение =
//             ((n + Т[0].alignof - 1) / Т[0].alignof) * Т[0].alignof;
//         static if (is(Т[0] == struct))
//         {
//             alias КортежТиповПолей!(Т[0]) MyRep;
//             alias КортежСмещенийПолей_реализ!(мСмещение, MyRep, Т[1 .. $]).Результат
//                 Результат;
//         }
//         else
//         {
//             protected enum т_мера mySize = Т[0].sizeof;
//             alias КортежТипов!(мСмещение) Голова;
//             static if (is(Т == union))
//             {
//                 alias КортежСмещенийПолей_реализ!(мСмещение, Т[1 .. $]).Результат
//                     Tail;
//             }
//             else
//             {
//                 alias КортежСмещенийПолей_реализ!(мСмещение + mySize,
//                                              Т[1 .. $]).Результат
//                     Tail;
//             }
//             alias КортежТипов!(Голова, Tail) Результат;
//         }
//     }
// }

// template КортежСмещенийПолей(Т...)
// {
//     alias КортежСмещенийПолей_реализ!(0, Т).Результат КортежСмещенийПолей;
// }

// unittest
// {
//     alias КортежСмещенийПолей!(цел) T1;
//     assert(T1.length == 1 && T1[0] == 0);
//     //
//     struct S2 { сим a; цел b; сим c; дво d; сим e, f; }
//     alias КортежСмещенийПолей!(S2) T2;
//     //pragma(msg, T2);
//     static assert(T2.length == 6
//            && T2[0] == 0 && T2[1] == 4 && T2[2] == 8 && T2[3] == 16
//                   && T2[4] == 24&& T2[5] == 25);
//     //
//     class C { цел a, b, c, d; }
//     struct S3 { сим a; C b; сим c; }
//     alias КортежСмещенийПолей!(S3) T3;
//     //pragma(msg, T2);
//     static assert(T3.length == 3
//            && T3[0] == 0 && T3[1] == 4 && T3[2] == 8);
//     //
//     struct S4 { сим a; union { цел b; сим c; } цел d; }
//     alias КортежСмещенийПолей!(S4) T4;
//     //pragma(msg, КортежТиповПолей!(S4));
//     static assert(T4.length == 4
//            && T4[0] == 0 && T4[1] == 4 && T4[2] == 8);
// }

// /***
// Поучить смещение полея структуры или класса.
// */

// template КортежСмещенийПолей(S)
// {
//     static if (is(S == struct) || is(S == class))
// 	alias typeof(S.tupleof) КортежТиповПолей;
//     else
// 	static assert(0, "аргумент не является структурой или классом");
// }

/***
Получить примитивные типы полей структуры или класса, в
топологическом порядке.

Пример:
----
struct S1 { цел a; плав b; }
struct S2 { ткст a; union { S1 b; S1 * c; } }
alias КортежТиповПредставления!(S2) R;
assert(R.length == 4
    && is(R[0] == сим[]) && is(R[1] == цел)
    && is(R[2] == плав) && is(R[3] == S1*));
----
*/

template КортежТиповПредставления(Т...)
{
    static if (Т.length == 0)
    {
        alias КортежТипов!() КортежТиповПредставления;
    }
    else
    {
        static if (is(Т[0] == struct) || is(Т[0] == union))
// @@@BUG@@@ this should work
//             alias .ТипыПредставления!(Т[0].tupleof)
//                 ТипыПредставления;
            alias .КортежТиповПредставления!(КортежТиповПолей!(Т[0]),
                                            Т[1 .. $])
                КортежТиповПредставления;
        else static if (is(Т[0] U == typedef))
        {
            alias .КортежТиповПредставления!(КортежТиповПолей!(U),
                                            Т[1 .. $])
                КортежТиповПредставления;
        }
        else
        {
            alias КортежТипов!(Т[0], КортежТиповПредставления!(Т[1 .. $]))
                КортежТиповПредставления;
        }
    }
}

unittest
{
    alias КортежТиповПредставления!(цел) S1;
    static assert(is(S1 == КортежТипов!(цел)));
    struct S2 { цел a; }
    static assert(is(КортежТиповПредставления!(S2) == КортежТипов!(цел)));
    struct S3 { цел a; сим b; }
    static assert(is(КортежТиповПредставления!(S3) == КортежТипов!(цел, сим)));
    struct S4 { S1 a; цел b; S3 c; }
    static assert(is(КортежТиповПредставления!(S4) ==
                     КортежТипов!(цел, цел, цел, сим)));

    struct S11 { цел a; плав b; }
    struct S21 { ткст a; union { S11 b; S11 * c; } }
    alias КортежТиповПредставления!(S21) R;
    assert(R.length == 4
           && is(R[0] == сим[]) && is(R[1] == цел)
           && is(R[2] == плав) && is(R[3] == S11*));
}

/*
СмещенияПредставления
*/

// protected template Повторить(т_мера n, Т...)
// {
//     static if (n == 0) alias КортежТипов!() Повторить;
//     else alias КортежТипов!(Т, Повторить!(n - 1, Т)) Повторить;
// }

// template СмещенияПредставления_реализ(т_мера n, Т...)
// {
//     static if (Т.length == 0)
//     {
//         alias КортежТипов!() Результат;
//     }
//     else
//     {
//         protected enum т_мера мСмещение =
//             ((n + Т[0].alignof - 1) / Т[0].alignof) * Т[0].alignof;
//         static if (!is(Т[0] == union))
//         {
//             alias Повторить!(n, КортежТиповПолей!(Т[0])).Результат
//                 Голова;
//         }
//         static if (is(Т[0] == struct))
//         {
//             alias .СмещенияПредставления_реализ!(n, КортежТиповПолей!(Т[0])).Результат
//                 Голова;
//         }
//         else
//         {
//             alias КортежТипов!(мСмещение) Голова;
//         }
//         alias КортежТипов!(Голова,
//                          СмещенияПредставления_реализ!(
//                              мСмещение + Т[0].sizeof, Т[1 .. $]).Результат)
//             Результат;
//     }
// }

// template СмещенияПредставления(Т)
// {
//     alias СмещенияПредставления_реализ!(0, Т).Результат
//         СмещенияПредставления;
// }

// unittest
// {
//     struct S1 { сим c; цел i; }
//     alias СмещенияПредставления!(S1) Смещения;
//     static assert(Смещения[0] == 0);
//     //pragma(msg, Смещения[1]);
//     static assert(Смещения[1] == 4);
// }

// естьСырАлиасинг

protected template ЕстьЛиСыройУк_реализ(Т...)
{
    static if (Т.length == 0)
    {
        const результат = нет;
    }
    else
    {
        static if (is(Т[0] U : U*))
            const естьСырАлиасинг = да;
        else static if (is(Т[0] U : U[]))
            const естьСырАлиасинг = да;
        else
            const естьСырАлиасинг = нет;
        const результат = естьСырАлиасинг || ЕстьЛиСыройУк_реализ!(Т[1 .. $]).результат;
    }
}

/*
Статически оценивается в $(D да), тогда и только тогда, когда представление $(D Т)
содержит как минимум одно поле типа указатель или массив.
Члены типов класс не считаются сырыми указателями. Указатели на инвариантные объекты
не рассматриваются в сыром алиасинге.

Пример:
---
// простые типы
static assert(!естьСырАлиасинг!(цел));
static assert(естьСырАлиасинг!(сим*));
// ссылки не являются сырыми указателями
static assert(!естьСырАлиасинг!(Объект));
// встроенные массивы содержат сырые указатели
static assert(естьСырАлиасинг!(цел[]));
// агрегат простых типов
struct S1 { цел a; дво b; }
static assert(!естьСырАлиасинг!(S1));
// indirect aggregation
struct S2 { S1 a; дво b; }
static assert(!естьСырАлиасинг!(S2));
// struct with a pointer member
struct S3 { цел a; дво * b; }
static assert(естьСырАлиасинг!(S3));
// struct with an indirect pointer member
struct S4 { S3 a; дво b; }
static assert(естьСырАлиасинг!(S4));
----
*/
protected template естьСырАлиасинг(Т...)
{
    const естьСырАлиасинг
        = ЕстьЛиСыройУк_реализ!(КортежТиповПредставления!(Т)).результат;
}

unittest
{
// simple типы
    static assert(!естьСырАлиасинг!(цел));
    static assert(естьСырАлиасинг!(сим*));
// ссылки не являются сырыми указателями
    static assert(!естьСырАлиасинг!(Объект));
    static assert(!естьСырАлиасинг!(цел));
    struct S1 { цел z; }
    static assert(!естьСырАлиасинг!(S1));
    struct S2 { цел* z; }
    static assert(естьСырАлиасинг!(S2));
    struct S3 { цел a; цел* z; цел c; }
    static assert(естьСырАлиасинг!(S3));
    struct S4 { цел a; цел z; цел c; }
    static assert(!естьСырАлиасинг!(S4));
    struct S5 { цел a; Объект z; цел c; }
    static assert(!естьСырАлиасинг!(S5));
    union S6 { цел a; цел b; }
    static assert(!естьСырАлиасинг!(S6));
    union S7 { цел a; цел * b; }
    static assert(естьСырАлиасинг!(S7));
    typedef цел* S8;
    static assert(естьСырАлиасинг!(S8));
    enum S9 { a };
    static assert(!естьСырАлиасинг!(S9));
    // indirect members
    struct S10 { S7 a; цел b; }
    static assert(естьСырАлиасинг!(S10));
    struct S11 { S6 a; цел b; }
    static assert(!естьСырАлиасинг!(S11));
}

/*
Статически оценивается в $(D да), тогда и только тогда, когда в 
представление $(D Т) входит хотя бы одна инвариантная ссылка на объект.
*/

protected template имеетОбъекты(Т...)
{
    static if (Т.length == 0)
    {
        const имеетОбъекты = нет;
    }
    else static if (is(Т[0] U == typedef))
    {
        const имеетОбъекты = имеетОбъекты!(U, Т[1 .. $]);
    }
    else static if (is(Т[0] == struct))
    {
        const имеетОбъекты = имеетОбъекты!(
            КортежТиповПредставления!(Т[0]), Т[1 .. $]);
    }
    else
    {
        const имеетОбъекты = is(Т[0] == class) || имеетОбъекты!(Т[1 .. $]);
    }
}

/**
* Возвращает $(D да), тогда и только тогда, если представление $(D Т)
* включает в себя хотябы одно из следующего:
*  $(OL $(LI сырой указатель $(D U*) и $(D U)не инвариант;)
*  $(LI  массив $(D U[]) и $(D U) iне инвариант;) 
* $(LI ссылка на тип класса $(D C) и $(D C) не инвариант.))
*/

template имеетАлиасинг(Т...)
{
    const имеетАлиасинг = естьСырАлиасинг!(Т) || имеетОбъекты!(Т);
}

unittest
{
    struct S1 { цел a; Объект b; }
    static assert(имеетАлиасинг!(S1));
    struct S2 { string a; }
    static assert(!имеетАлиасинг!(S2));
}

/**
 * Получить $(D_PARAM КортежТипов) базовых классов $(I all) данного класса,
 * в уменьшающемся порядке. Не включая интерфесы. $(D_PARAM
 * КортежБазовыхКлассов!(Объект)) получает пустой кортеж типов.
 *
 * Пример:
 * ---
 * import tpl.traits, tpl.typetuple, stdrus;
 * interface I { }
 * class A { }
 * class B : A, I { }
 * class C : B { }
 *
 * проц main()
 * {
 *     alias КортежБазовыхКлассов!(C) TL;
 *     пишинс(typeid(TL));	// выводит: (B,A,Объект)
 * }
 * ---
 */

template КортежБазовыхКлассов(Т)
{
    static if (is(Т == Объект))
    {
        alias КортежТипов!() КортежБазовыхКлассов;
    }
    static if (is(КортежТипаОснова!(Т)[0] == Объект))
    {
        alias КортежТипов!(Объект) КортежБазовыхКлассов;
    }
    else
    {
        alias КортежТипов!(КортежТипаОснова!(Т)[0],
                         КортежБазовыхКлассов!(КортежТипаОснова!(Т)[0]))
            КортежБазовыхКлассов;
    }
}

/**
 * Получить $(D_PARAM КортежТипов) из $(I всех) интерфейсов, прямо или
 * косвенно унаследованных данным классом или интерфейсом. Если реализовано умножение,
 * интерфейсы не повторяются. $(D_PARAM КортежИнтерфейсов!(Объект))
 * получает пустой кортеж типов.
 *
 * Пример:
 * ---
 * import tpl.traits, tpl.typetuple, stdrus;
 * interface I1 { }
 * interface I2 { }
 * class A : I1, I2 { }
 * class B : A, I1 { }
 * class C : B { }
 *
 * проц main()
 * {
 *     alias КортежИнтерфейсов!(C) TL;
 *     пишинс(typeid(TL));	// выводит: (I1, I2)
 * }
 * ---
 */

template КортежИнтерфейсов(Т)
{
    static if (is(Т == Объект))
    {
        alias КортежТипов!() КортежИнтерфейсов;
    }
    static if (is(КортежТипаОснова!(Т)[0] == Объект))
    {
        alias КортежТипов!(КортежТипаОснова!(Т)[1 .. $]) КортежИнтерфейсов;
    }
    else
    {
        alias БезДубликатов!(
            КортежТипов!(КортежТипаОснова!(Т)[1 .. $], // прямые интерфейсы
                       КортежИнтерфейсов!(КортежТипаОснова!(Т)[0])))
            КортежИнтерфейсов;
    }
}

unittest
{
    interface I1 {}
    interface I2 {}
    {
        // doc example
        class A : I1, I2 { }
        class B : A, I1 { }
        class C : B { }
        alias КортежИнтерфейсов!(C) TL;
        assert(is(TL[0] == I1) && is(TL[1] == I2));
    }
    class B1 : I1, I2 {}
    class B2 : B1, I1 {}
    class B3 : B2, I2 {}
    alias КортежИнтерфейсов!(B3) TL;
    //
    assert(TL.length == 2);
    assert(is (TL[0] == I2));
    assert(is (TL[1] == I1));
}

/**
 * Получить $(D_PARAM КортежТипов) из  $(I всех) базовых классов для $(D_PARAM
 * Т), в нисходящем порядке, за которым следуют интерфесы $(D_PARAM Т).
 * $(D_PARAM ТранзитивныйКортежБазовыхТипов!(Объект)) получает
 * пустой кортеж типов.
 *
 * Пример:
 * ---
 * import tpl.traits, tpl.typetuple, stdrus;
 * interface I { }
 * class A { }
 * class B : A, I { }
 * class C : B { }
 *
 * проц main()
 * {
 *     alias ТранзитивныйКортежБазовыхТипов!(C) TL;
 *     пишинс(typeid(TL));	// выводит: (B,A,Объект,I)
 * }
 * ---
 */

template ТранзитивныйКортежБазовыхТипов(Т)
{
    static if (is(Т == Объект))
        alias КортежТипов!() ТранзитивныйКортежБазовыхТипов;
    else
        alias КортежТипов!(КортежБазовыхКлассов!(Т),
            КортежИнтерфейсов!(Т))
            ТранзитивныйКортежБазовыхТипов;
}

unittest
{
    interface I1 {}
    interface I2 {}
    class B1 {}
    class B2 : B1, I1, I2 {}
    class B3 : B2, I1 {}
    alias ТранзитивныйКортежБазовыхТипов!(B3) TL;
    assert(TL.length == 5);
    assert(is (TL[0] == B2));
    assert(is (TL[1] == B1));
    assert(is (TL[2] == Объект));
    assert(is (TL[3] == I1));
    assert(is (TL[4] == I2));
    
    assert(ТранзитивныйКортежБазовыхТипов!(Объект).length == 0);
}

/**
* Получить тип, в который неявно преобразуются все типы. Полезно,
* напр., для выявления типа массива из связки инициализованных
* значений. Возвращаает $(D_PARAM проц), если передан пустой список
* или эти типы не имеют общего типа.
*
* Пример:
*
*----
* alias ОбщийТип!(цел, дол, крат) X;
* assert(is(X == дол));
* alias ОбщийТип!(цел, сим[], крат) Y;
* assert(is(Y == void));
* ----
*/
template ОбщийТип(Т...)
{
    static if (!Т.length)
        alias проц ОбщийТип;
    else static if (Т.length == 1)
        alias Т[0] ОбщийТип;
    else static if (is(typeof(да ? Т[0] : Т[1]) U))
        alias ОбщийТип!(U, Т[2 .. $]) ОбщийТип;
    else
        alias проц ОбщийТип;
}

unittest
{
    alias ОбщийТип!(цел, дол, крат) X;
    assert(is(X == дол));
    alias ОбщийТип!(сим[], цел, дол, крат) Y;
    assert(is(Y == void), Y.stringof);
}

/**
 * Возвращает кортеж со всеми возможными целевыми типами неявного
 * преобразования значения типа $(D_PARAM Т).
 *
 * Важное примечание:
 *
 * The possible targets are computed more conservatively than the D
 * 2.005 compiler does, eliminating all dangerous conversions. For
 * example, $(D_PARAM ЦелиНеявногоПреобразования!(дво)) does not
 * include $(D_PARAM плав).
 */

template ЦелиНеявногоПреобразования(Т)
{
    static if (is(Т == бул))
        alias КортежТипов!(байт, ббайт, крат, бкрат, цел, бцел, дол, бдол,
            плав, дво, реал, сим, шим, дим)
            ЦелиНеявногоПреобразования;
    else static if (is(Т == байт))
        alias КортежТипов!(крат, бкрат, цел, бцел, дол, бдол,
            плав, дво, реал, сим, шим, дим)
            ЦелиНеявногоПреобразования;
    else static if (is(Т == ббайт))
        alias КортежТипов!(крат, бкрат, цел, бцел, дол, бдол,
            плав, дво, реал, сим, шим, дим)
            ЦелиНеявногоПреобразования;
    else static if (is(Т == крат))
        alias КортежТипов!(бкрат, цел, бцел, дол, бдол,
            плав, дво, реал)
            ЦелиНеявногоПреобразования;
    else static if (is(Т == бкрат))
        alias КортежТипов!(цел, бцел, дол, бдол, плав, дво, реал)
            ЦелиНеявногоПреобразования;
    else static if (is(Т == цел))
        alias КортежТипов!(дол, бдол, плав, дво, реал)
            ЦелиНеявногоПреобразования;
    else static if (is(Т == бцел))
        alias КортежТипов!(дол, бдол, плав, дво, реал)
            ЦелиНеявногоПреобразования;
    else static if (is(Т == дол))
        alias КортежТипов!(плав, дво, реал)
            ЦелиНеявногоПреобразования;
    else static if (is(Т == бдол))
        alias КортежТипов!(плав, дво, реал)
            ЦелиНеявногоПреобразования;
    else static if (is(Т == плав))
        alias КортежТипов!(дво, реал)
            ЦелиНеявногоПреобразования;
    else static if (is(Т == дво))
        alias КортежТипов!(реал)
            ЦелиНеявногоПреобразования;
    else static if (is(Т == сим))
        alias КортежТипов!(шим, дим, байт, ббайт, крат, бкрат,
            цел, бцел, дол, бдол, плав, дво, реал)
            ЦелиНеявногоПреобразования;
    else static if (is(Т == шим))
        alias КортежТипов!(шим, дим, крат, бкрат, цел, бцел, дол, бдол,
            плав, дво, реал)
            ЦелиНеявногоПреобразования;
    else static if (is(Т == дим))
        alias КортежТипов!(шим, дим, цел, бцел, дол, бдол,
            плав, дво, реал)
            ЦелиНеявногоПреобразования;
    else static if(is(Т : Объект))
        alias ТранзитивныйКортежБазовыхТипов!(Т) ЦелиНеявногоПреобразования;
    else static if (is(Т : ук))
        alias КортежТипов!(ук) ЦелиНеявногоПреобразования;
    else
        alias КортежТипов!() ЦелиНеявногоПреобразования;
}

unittest
{
    assert(is(ЦелиНеявногоПреобразования!(дво)[0] == реал));
}

/**
 * Detect whether Т is a built-in integral type
 */

template isIntegral(Т)
{
    static const isIntegral = is(Т == байт) || is(Т == ббайт) || is(Т == крат)
        || is(Т == бкрат) || is(Т == цел) || is(Т == бцел)
        || is(Т == дол) || is(Т == бдол);
}

/**
 * Detect whether Т is a built-in floating point type
 */

template isFloatingPoint(Т)
{
    static const isFloatingPoint = is(Т == плав)
        || is(Т == дво) || is(Т == реал);
}

/**
 * Detect whether Т is a built-in numeric type
 */

template isNumeric(Т)
{
    static const isNumeric = isIntegral!(Т) || isFloatingPoint!(Т);
}

/**
 * Detect whether Т is one of the built-in string типы
 */

template isSomeString(Т)
{
    static const isSomeString = is(Т : сим[])
        || is(Т : шим[]) || is(Т : дим[]);
}

static assert(!isSomeString!(цел));
static assert(!isSomeString!(цел[]));
static assert(!isSomeString!(байт[]));
static assert(isSomeString!(сим[]));
static assert(isSomeString!(дим[]));
static assert(isSomeString!(string));
static assert(isSomeString!(wstring));
static assert(isSomeString!(dstring));
static assert(isSomeString!(сим[4]));

/**
 * Detect whether Т is an associative массив type
 */

template isAssociativeArray(Т)
{
    static const бул isAssociativeArray =
        is(typeof(Т.keys)) && is(typeof(Т.values));
}

static assert(!isAssociativeArray!(цел));
static assert(!isAssociativeArray!(цел[]));
static assert(isAssociativeArray!(цел[цел]));
static assert(isAssociativeArray!(цел[string]));
static assert(isAssociativeArray!(сим[5][цел]));

/**
 * Detect whether type Т is a static массив.
 */
template isStaticArray(Т : U[N], U, т_мера N)
{
    const бул isStaticArray = да;
}

template isStaticArray(Т)
{
    const бул isStaticArray = нет;
}

static assert (isStaticArray!(цел[51]));
static assert (isStaticArray!(цел[][2]));
static assert (isStaticArray!(сим[][цел][11]));
static assert (!isStaticArray!(цел[]));
static assert (!isStaticArray!(цел[сим]));
static assert (!isStaticArray!(цел[1][]));
static assert(isStaticArray!(сим[13u]));
static assert (isStaticArray!(typeof("string literal")));
static assert (isStaticArray!(проц[0]));
static assert (!isStaticArray!(цел[цел]));
static assert (!isStaticArray!(цел));

/**
 * Detect whether type Т is a dynamic массив.
 */
template isDynamicArray(Т, U = void)
{
    static const isDynamicArray = нет;
}

template isDynamicArray(Т : U[], U)
{
  static const isDynamicArray = !isStaticArray!(Т);
}

static assert(isDynamicArray!(цел[]));
static assert(!isDynamicArray!(цел[5]));

/**
 * Detect whether type Т is an массив.
 */
template isArray(Т)
{
    static const isArray = isStaticArray!(Т) || isDynamicArray!(Т);
}

static assert(isArray!(цел[]));
static assert(isArray!(цел[5]));
static assert(!isArray!(бцел));
static assert(!isArray!(бцел[бцел]));
static assert(isArray!(проц[]));


/**
 * Tells whether the tuple Т is an expression tuple.
 */
template isExpressionTuple(Т ...)
{
    static if (is(проц function(Т)))
	const бул isExpressionTuple = нет;
    else
	const бул isExpressionTuple = да;
}

/**
 * Returns the corresponding unsigned type for Т. Т must be a numeric
 * integral type, otherwise a compile-time error occurs.
 */

template unsigned(Т) {
    static if (is(Т == байт)) alias ббайт unsigned;
    else static if (is(Т == крат)) alias бкрат unsigned;
    else static if (is(Т == цел)) alias бцел unsigned;
    else static if (is(Т == дол)) alias бдол unsigned;
    else static if (is(Т == ббайт)) alias ббайт unsigned;
    else static if (is(Т == бкрат)) alias бкрат unsigned;
    else static if (is(Т == бцел)) alias бцел unsigned;
    else static if (is(Т == бдол)) alias бдол unsigned;
    else static if (is(Т == сим)) alias сим unsigned;
    else static if (is(Т == шим)) alias шим unsigned;
    else static if (is(Т == дим)) alias дим unsigned;
    else static if(is(Т == enum)) {
        static if (Т.sizeof == 1) alias ббайт unsigned;
        else static if (Т.sizeof == 2) alias бкрат unsigned;
        else static if (Т.sizeof == 4) alias бцел unsigned;
        else static if (Т.sizeof == 8) alias бдол unsigned;
        else static assert(нет, "Type " ~ Т.stringof
                           ~ " does not have an unsigned counterpart");
    }
    else static assert(нет, "Type " ~ Т.stringof
                       ~ " does not have an unsigned counterpart");
}

unittest
{
    alias unsigned!(цел) U;
    assert(is(U == бцел));
}
/+
/******
 * Returns the mutable version of the type Т.
 */

template Mutable(Т)
{

    static if (is(Т U == (const U)))
	alias U Mutable;
    else static if (is(Т U == invariant(U)))
	alias U Mutable;
    else

	alias Т Mutable;
}
+/
/**
* Возвращает самое отрицательное значение числового типа Т.
*/

template mostNegative(Т)
{
    static if (Т.min == 0) const байт mostNegative = 0;
    else static if (Т.min > 0) const mostNegative = -Т.max;
    else const mostNegative = Т.min;
}

unittest
{
    static assert(mostNegative!(плав) == -плав.max);
    static assert(mostNegative!(бцел) == 0);
    static assert(mostNegative!(дол) == дол.min);
}

/**
 * Оценивается как да, если Т является сим[], wchar[] или дим[].
 */
template текстТип_ли( Т )
{
    const bool текстТип_ли = is( Т : сим[] )  ||
                              is( Т : wchar[] ) ||
                              is( Т : дим[] ) ||
							  is( Т : сим[] )  ||
                              is( Т : шим[] ) ||
                              is( Т : дим[] );
}

/**
 * Evaluates to да if Т is сим, wchar, or дим.
 */
template симТип_ли( Т )
{
    const bool симТип_ли = is( Т == сим )  ||
                            is( Т == wchar ) ||
                            is( Т == дим ) ||
							is( Т == сим )  ||
                            is( Т == шим ) ||
                            is( Т == дим );
}


/**
 * Evaluates to да if Т is a signed integer type.
 */
template целСоЗнакомТип_ли( Т )
{
    const bool целСоЗнакомТип_ли = is( Т == байт )  ||
                                     is( Т == short ) ||
                                     is( Т == int )   ||
                                     is( Т == long ) ||
									 is( Т == байт )  ||
                                     is( Т == крат ) ||
                                     is( Т == цел )   ||
                                     is( Т == дол ) 
									 /+||
                                     is( Т == cent  )+/;
}


/**
 * Evaluates to да if Т is an unsigned integer type.
 */
template целБезЗнакаТип_ли( Т )
{
    const bool целБезЗнакаТип_ли = is( Т == ubyte )  ||
                                       is( Т == бкрат ) ||
                                       is( Т == uint )   ||
                                       is( Т == бдол ) ||
									   is( Т == ббайт )  ||
                                       is( Т == бкрат ) ||
                                       is( Т == бцел )   ||
                                       is( Т == бдол ) 
									   /+||
                                       is( Т == ucent  )+/;
}


/**
 * Evaluates to да if Т is a signed or unsigned integer type.
 */
template целТип_ли( Т )
{
    const bool целТип_ли = целСоЗнакомТип_ли!(Т) ||
                               целБезЗнакаТип_ли!(Т);
}


/**
 * Evaluates to да if Т is a реал floating-point type.
 */
template реалТип_ли( Т )
{
    const bool реалТип_ли = is( Т == плав )  ||
                            is( Т == дво ) ||
                            is( Т == реал ) ||
							is( Т == плав )  ||
                            is( Т == дво ) ||
                            is( Т == реал );
}


/**
 * Evaluates to да if Т is a complex floating-point type.
 */
template комплексТип_ли( Т )
{
    const bool комплексТип_ли = is( Т == cfloat ) ||
                               is( Т == cdouble ) ||
                               is( Т == creal )||
							   is( Т == кплав ) ||
                               is( Т == кдво ) ||
                               is( Т == креал );
}


/**
 * Evaluates to да if Т is an imaginary floating-point type.
 */
template мнимыйТип_ли( Т )
{
    const bool мнимыйТип_ли = is( Т == ifloat )  ||
                                 is( Т == idouble ) ||
                                 is( Т == ireal )||
								 is( Т == вплав )  ||
                                 is( Т == вдво ) ||
                                 is( Т == вреал )	;
}


/**
 * Evaluates to да if Т is any floating-point type: реал, complex, or
 * imaginary.
 */
template плавзапТип_ли( Т )
{
    const bool плавзапТип_ли = реалТип_ли!(Т)    ||
                                     комплексТип_ли!(Т) ||
                                     мнимыйТип_ли!(Т);
}

/// да if Т is an atomic type
template атомТип_ли(Т)
{
    static if( is( Т == bool )
            || is( Т == сим )
            || is( Т == wchar )
            || is( Т == дим )
            || is( Т == байт )
            || is( Т == short )
            || is( Т == int )
            || is( Т == long )
            || is( Т == ubyte )
            || is( Т == бкрат )
            || is( Т == uint )
            || is( Т == бдол )
            || is( Т == плав )
            || is( Т == дво )
            || is( Т == реал )
            || is( Т == ifloat )
            || is( Т == idouble )
            || is( Т == ireal )
			||is( Т == бул )
            || is( Т == сим )
            || is( Т == шим )
            || is( Т == дим )
            || is( Т == байт )
            || is( Т == крат )
            || is( Т == цел )
            || is( Т == дол )
            || is( Т == ббайт )
            || is( Т == бкрат )
            || is( Т == бцел )
            || is( Т == бдол )
            || is( Т == плав )
            || is( Т == дво )
            || is( Т == реал )
            || is( Т == вплав )
            || is( Т == вдво )
            || is( Т == вреал ))
        const атомТип_ли = да;
    else
        const атомТип_ли = нет;
}

/**
 * complex type for the given type
 */
template ComplexTypeOf(Т){
    static if(is(Т==плав)||is(Т==ifloat)||is(Т==cfloat)){
        alias cfloat ComplexTypeOf;
    } else static if(is(Т==дво)|| is(Т==idouble)|| is(Т==cdouble)){
        alias cdouble ComplexTypeOf;
    } else static if(is(Т==реал)|| is(Т==ireal)|| is(Т==creal)){
        alias creal ComplexTypeOf;
    } else static assert(0,"unsupported type in ComplexTypeOf "~Т.stringof);
}

/**
 * реал type for the given type
 */
template RealTypeOf(Т){
    static if(is(Т==плав)|| is(Т==ifloat)|| is(Т==cfloat)){
        alias плав RealTypeOf;
    } else static if(is(Т==дво)|| is(Т==idouble)|| is(Т==cdouble)){
        alias дво RealTypeOf;
    } else static if(is(Т==реал)|| is(Т==ireal)|| is(Т==creal)){
        alias реал RealTypeOf;
    } else static assert(0,"unsupported type in RealTypeOf "~Т.stringof);
}

/**
 * imaginary type for the given type
 */
template ImaginaryTypeOf(Т){
    static if(is(Т==плав)|| is(Т==ifloat)|| is(Т==cfloat)){
        alias ifloat ImaginaryTypeOf;
    } else static if(is(Т==дво)|| is(Т==idouble)|| is(Т==cdouble)){
        alias idouble ImaginaryTypeOf;
    } else static if(is(Т==реал)|| is(Т==ireal)|| is(Т==creal)){
        alias ireal ImaginaryTypeOf;
    } else static assert(0,"unsupported type in ImaginaryTypeOf "~Т.stringof);
}

/// type with maximum precision
template MaxPrecTypeOf(Т){
    static if (комплексТип_ли!(Т)){
        alias creal MaxPrecTypeOf;
    } else static if (мнимыйТип_ли!(Т)){
        alias ireal MaxPrecTypeOf;
    } else {
        alias реал MaxPrecTypeOf;
    }
}


/**
 * Evaluates to да if Т is a pointer type.
 */
template типУказатель_ли(Т)
{
        const типУказатель_ли = нет;
}

template типУказатель_ли(Т : Т*)
{
        const типУказатель_ли = да;
}

debug( UnitTest )
{
    unittest
    {
        static assert( типУказатель_ли!(void*) );
        static assert( !типУказатель_ли!(сим[]) );
        static assert( типУказатель_ли!(сим[]*) );
        static assert( !типУказатель_ли!(сим*[]) );
        static assert( типУказатель_ли!(реал*) );
        static assert( !типУказатель_ли!(uint) );
        static assert( is(MaxPrecTypeOf!(плав)==реал));
        static assert( is(MaxPrecTypeOf!(cfloat)==creal));
        static assert( is(MaxPrecTypeOf!(ifloat)==ireal));

        class Ham
        {
            void* a;
        }

        static assert( !типУказатель_ли!(Ham) );

        union Eggs
        {
            void* a;
            uint  b;
        };

        static assert( !типУказатель_ли!(Eggs) );
        static assert( типУказатель_ли!(Eggs*) );

        struct Bacon {};

        static assert( !типУказатель_ли!(Bacon) );

    }
}

/**
 * Evaluates to да if Т is a a pointer, class, interface, or delegate.
 */
template типСсылка_ли( Т )
{

    const bool типСсылка_ли = типУказатель_ли!(Т)  ||
                               is( Т == class )     ||
                               is( Т == interface ) ||
                               is( Т == delegate );
}


/**
 * Evaulates to да if Т is a dynamic array type.
 */
template типДинМасс_ли( Т )
{
    const bool типДинМасс_ли = is( typeof(Т.init[0])[] == Т );
}

/**
 * Evaluates to да if Т is a static array type.
 */
version( GNU )
{
    // GDC should also be able to use the other version, but it probably
    // relies on a frontend fix in one of the latest DMD versions - will
    // remove this when GDC is готов. For now, this code pass the unittests.
    private template isStaticArrayTypeInst( Т )
    {
        const Т isStaticArrayTypeInst = void;
    }

    template типСтатМасс_ли( Т )
    {
        static if( is( typeof(Т.length) ) && !is( typeof(Т) == typeof(Т.init) ) )
        {
            const bool типСтатМасс_ли = is( Т == typeof(Т[0])[isStaticArrayTypeInst!(Т).length] );
        }
        else
        {
            const bool типСтатМасс_ли = нет;
        }
    }
}
else
{
    template типСтатМасс_ли( Т : Т[U], size_t U )
    {
        const bool типСтатМасс_ли = да;
    }

    template типСтатМасс_ли( Т )
    {
        const bool типСтатМасс_ли = нет;
    }
}

/// да for array types
template типМассив_ли(Т)
{
    static if (is( Т U : U[] ))
        const bool типМассив_ли=да;
    else
        const bool типМассив_ли=нет;
}

debug( UnitTest )
{
    unittest
    {
        static assert( типСтатМасс_ли!(сим[5][2]) );
        static assert( !типДинМасс_ли!(сим[5][2]) );
        static assert( типМассив_ли!(сим[5][2]) );

        static assert( типСтатМасс_ли!(сим[15]) );
        static assert( !типСтатМасс_ли!(сим[]) );

        static assert( типДинМасс_ли!(сим[]) );
        static assert( !типДинМасс_ли!(сим[15]) );

        static assert( типМассив_ли!(сим[15]) );
        static assert( типМассив_ли!(сим[]) );
        static assert( !типМассив_ли!(сим) );
    }
}

/**
 * Evaluates to да if Т is an associative array type.
 */
template типАссоцМасс_ли( Т )
{
    const bool типАссоцМасс_ли = is( typeof(Т.init.values[0])[typeof(Т.init.keys[0])] == Т );
}


/**
 * Evaluates to да if Т is a function, function pointer, delegate, or
 * callable object.
 */
template isCallableType( Т )
{
    const bool isCallableType = is( Т == function )             ||
                                is( typeof(*Т) == function )    ||
                                is( Т == delegate )             ||
                                is( typeof(Т.opCall) == function );
}


/**
 * Evaluates to the return type of Fn.  Fn is required to be a callable type.
 */
template ТипВозвратаУ( Fn )
{
    static if( is( Fn Ret == return ) )
        alias Ret ТипВозвратаУ;
    else
        static assert( нет, "Аргумент не имеет типа возврата." );
}

/** 
 * Returns the type that a Т would evaluate to in an expression.
 * Expr is not required to be a callable type
 */ 
template ExprTypeOf( Expr )
{
    static if(isCallableType!( Expr ))
        alias ТипВозвратаУ!( Expr ) ExprTypeOf;
    else
        alias Expr ExprTypeOf;
}


/**
 * Evaluates to the return type of fn.  fn is required to be callable.
 */
template ТипВозвратаУ( alias fn )
{
    static if( is( typeof(fn) Основа == typedef ) )
        alias ТипВозвратаУ!(Основа) ТипВозвратаУ;
    else
        alias ТипВозвратаУ!(typeof(fn)) ТипВозвратаУ;
}


/**
 * Evaluates to a tuple representing the parameters of Fn.  Fn is required to
 * be a callable type.
 */
template КортежПараметровУ( Fn )
{
    static if( is( Fn Params == function ) )
        alias Params КортежПараметровУ;
    else static if( is( Fn Params == delegate ) )
        alias КортежПараметровУ!(Params) КортежПараметровУ;
    else static if( is( Fn Params == Params* ) )
        alias КортежПараметровУ!(Params) КортежПараметровУ;
    else
        static assert( нет, "У аргумента отсутствуют параметры." );
}


/**
 * Evaluates to a tuple representing the parameters of fn.  n is required to
 * be callable.
 */
template КортежПараметровУ( alias fn )
{
    static if( is( typeof(fn) Основа == typedef ) )
        alias КортежПараметровУ!(Основа) КортежПараметровУ;
    else
        alias КортежПараметровУ!(typeof(fn)) КортежПараметровУ;
}


/**
 * Evaluates to a tuple representing the ancestors of Т.  Т is required to be
 * a class or interface type.
 */
template КортежТиповОсновУ( Т )
{
    static if( is( Т Основа == super ) )
        alias Основа КортежТиповОсновУ;
    else
        static assert( нет, "Аргумент не является ни классом, ни интерфейсом." );
}

/**
 * Strips the []'s off of a type.
 */
template ТипОсноваМассивов(Т)
{
    static if( is( Т S : S[]) ) {
        alias ТипОсноваМассивов!(S)  ТипОсноваМассивов;
    }
    else {
        alias Т ТипОсноваМассивов;
    }
}

/**
 * strips one [] off a type
 */
template ТипЭлементовМассива(Т:Т[])
{
    alias Т ТипЭлементовМассива;
}

/**
 * Count the []'s on an array type
 */
template рангМассива(Т) {
    static if(is(Т S : S[])) {
        const uint рангМассива = 1 + рангМассива!(S);
    } else {
        const uint рангМассива = 0;
    }
}

/// type of the keys of an AA
template ТипКлючаАМ(Т){
    alias typeof(Т.init.keys[0]) ТипКлючаАМ;
}

/// type of the values of an AA
template ТипЗначенияАМ(Т){
    alias typeof(Т.init.values[0]) ТипЗначенияАМ;
}

/// returns the size of a static array
template размерСтатМассива(Т)
{
    static assert(типСтатМасс_ли!(Т),"размерСтатМассива требует указать статический массив в качестве типа");
    static assert(рангМассива!(Т)==1,"реализовано только для массивов 1d...");
    const size_t размерСтатМассива=(Т).sizeof / typeof(Т.init).sizeof;
}

/// is Т is static array returns a dynamic array, otherwise returns Т
template ТипДинМас(Т)
{
    static if( типСтатМасс_ли!(Т) )
        alias typeof(Т.dup) ТипДинМас;
    else
        alias Т ТипДинМас;
}

debug( UnitTest )
{
    static assert( is(ТипОсноваМассивов!(реал[][])==реал) );
    static assert( is(ТипОсноваМассивов!(реал[2][3])==реал) );
    static assert( is(ТипЭлементовМассива!(реал[])==реал) );
    static assert( is(ТипЭлементовМассива!(реал[][])==реал[]) );
    static assert( is(ТипЭлементовМассива!(реал[2][])==реал[2]) );
    static assert( is(ТипЭлементовМассива!(реал[2][2])==реал[2]) );
    static assert( рангМассива!(реал[][])==2 );
    static assert( рангМассива!(реал[2][])==2 );
    static assert( is(ТипЗначенияАМ!(сим[int])==сим));
    static assert( is(ТипКлючаАМ!(сим[int])==int));
    static assert( is(ТипЗначенияАМ!(сим[][int])==сим[]));
    static assert( is(ТипКлючаАМ!(сим[][int[]])==int[]));
    static assert( типАссоцМасс_ли!(сим[][int[]]));
    static assert( !типАссоцМасс_ли!(сим[]));
    static assert( is(ТипДинМас!(сим[2])==ТипДинМас!(сим[])));
    static assert( is(ТипДинМас!(сим[2])==сим[]));
    static assert( размерСтатМассива!(сим[2])==2);
}


