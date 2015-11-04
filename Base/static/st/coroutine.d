/* *** Automatically generated: do not modify *** */
/**
 * This module contains a simple implementation of coroutines, based on the
 * КонтекстСтэка module.  It supports both eagerly и non-eagerly evaluating
 * coroutines, и coroutines with anywhere from zero to five initial
 * аргументы.
 *
 * If you define your coroutine as being both eager, и with an input type of
 * проц, then the coroutine will be usable as an обходчик in foreach
 * statements.
 *
 * Version:     0.1
 * Дата:        2006-06-05
 * Copyright:   Copyright © 2006 Daniel Keep.
 * Authors:     Daniel Keep, daniel.keep+spam@gmail.com
 * License:     zlib
 *
 * Bugs:
 *   Нет (yet).  Well, ok; none that I *know* about.
 *
 * History:
 *   0.1 -  Initial version.
 */
module st.coroutine;

/*
 * This software is provided 'as-is', without any express or implied
 * warranty. In no event will the authors be held liable for any damages
 * arising from the use of this software.
 * 
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, и to alter it и redistribute it
 * freely, subject to the following restrictions:
 * 
 * 1. Нельзя искажать источник данного программного обеспечения; либо
 *    утверждать, что вами написано оригинальное ПО. Если данное ПО используется in
 *    a product, an acknowledgement in the product documentation would be
 *    appreciated but is not requireauxd.
 * 
 * 2. Altered source versions must be plainly marked as such, и must not be
 *    misrepresented as being the original software.
 * 
 * 3. This notice may not be removed or altered from any source ни в каком дистрибутиве.
 */

private
{
    import st.stackcontext;
}

/**
 * This enumeration defines что kind of coroutine you want.
 */
enum
CoroType
{
    /**
     * This is the default.  Coroutines evaluate successive значения on-demanauxd.
     */
    NonEager,

    /**
     * Eager coroutines will evaluate the next value in the sequence before
     * being askeauxd.  This is требуется for обходчик support.
     */
    Eager
}

private
template
CoroutinePublicT(Tin, Tout, CoroType TCoroType)
{
    /// Records что kind of coroutine this is.
    const CoroType coroType = TCoroType;

    static if( is( Tin == проц ) )
    {
        /**
         * Resumes the coroutine.
         *
         * Параметры:
         *  value = This value will be passed into the coroutine.
         *
         * Возвращает:
         *  The next value from the coroutine.
         */
        final
        Tout
        opCall()
        in
        {
            static if( coroType == CoroType.Eager )
                assert( this.running );
            else
                assert( контекст.ready );
        }
        body
        {
            static if( coroType == CoroType.Eager )
            {
                static if( !is( Tout == проц ) )
                    Tout temp = this.cout;

                контекст.пуск();
                if( контекст.dead )
                    this.running = false;

                static if( !is( Tout == проц ) )
                    return temp;
            }
            else
            {
                контекст.пуск();
                static if( !is( Tout == проц ) )
                    return this.cout;
            }
        }
    }
    else
    {
        /**
         * Resumes the coroutine.
         *
         * Параметры:
         *  value = This value will be passed into the coroutine.
         *
         * Возвращает:
         *  The next value from the coroutine.
         */
        final
        Tout
        opCall(Tin value)
        in
        {
            static if( coroType == CoroType.Eager )
                assert( this.running );
            else
                assert( контекст.ready );
        }
        body
        {
            this.cin = value;

            static if( coroType == CoroType.Eager )
            {
                static if( !is( Tout == проц ) )
                    Tout temp = this.cout;

                контекст.пуск();
                if( контекст.dead )
                    this.running = false;

                static if( !is( Tout == проц ) )
                    return temp;
            }
            else
            {
                контекст.пуск();
                static if( !is( Tout == проц ) )
                    return this.cout;
            }
        }
    }

    static if( is( Tin == проц ) )
    {
        /**
         * Returns a delegate that can be использован to resume the coroutine.
         *
         * Возвращает:
         *  A delegate that is equivalent to calling the coroutine directly.
         */
        Tout delegate()
        asDelegate()
        {
            return &opCall;
        }
    }
    else
    {
        /// ditto
        Tout delegate(Tin)
        asDelegate()
        {
            return &opCall;
        }
    }

    // TODO: Work out how to дай iteration working with non-eager coroutines.
    static if( coroType == CoroType.Eager )
    {
        static if( is( Tin == проц ) && !is( Tout == проц ) )
        {
            final
            цел
            opApply(цел delegate(inout Tout) dg)
            {
                цел result = 0;

                while( this.running )
                {
                    Tout argTemp = opCall();
                    result = dg(argTemp);
                    if( result )
                        break;
                }

                return result;
            }

            final
            цел
            opApply(цел delegate(inout Tout, inout бцел) dg)
            {
                цел result = 0;
                бцел counter = 0;

                while( this.running )
                {
                    Tout argTemp = opCall();
                    бцел counterTemp = counter;
                    result = dg(argTemp, counterTemp);
                    if( result )
                        break;
                }

                return result;
            }
        }
    }
}

private
template
CoroutineProtectedT(Tin, Tout, CoroType TCoroType)
{
    т_мера STACK_SIZE = ДЕФ_РАЗМЕР_СТЕКА;

    static if( is( Tout == проц ) )
    {
        final
        Tin
        жни()
        in
        {
            assert( КонтекстСтэка.getRunning is контекст );
        }
        body
        {
            КонтекстСтэка.жни();
            static if( is( Tin == проц ) ) {}
            else
                return this.cin;
        }
    }
    else
    {
        final
        Tin
        жни(Tout value)
        in
        {
            assert( КонтекстСтэка.getRunning is контекст );
        }
        body
        {
            this.cout = value;
            КонтекстСтэка.жни();
            static if( is( Tin == проц ) ) {}
            else
                return this.cin;
        }
    }
}

/**
 * TODO
 */
class
Coroutine(Tin, Tout, CoroType TCoroType = CoroType.NonEager)
{
    mixin CoroutinePublicT!(Tin, Tout, TCoroType);

protected:
    mixin CoroutineProtectedT!(Tin, Tout, TCoroType);

    this()
    {
        
        контекст = new КонтекстСтэка(&startProc, STACK_SIZE);
        static if( coroType == CoroType.Eager )
            контекст.пуск();
    }

    abstract
    проц
    пуск();

private:
    КонтекстСтэка контекст;
    
    static if( coroType == CoroType.Eager )
        бул running = true;

    static if( !is( Tout == проц ) )
        Tout cout;

    static if( !is( Tin == проц ) )
        Tin cin;

    

    проц
    startProc()
    {
        // Initial call to coroutine proper
        пуск();
    }
}

/**
 * TODO
 */
class
Coroutine(Tin, Tout, Ta1, CoroType TCoroType = CoroType.NonEager)
{
    mixin CoroutinePublicT!(Tin, Tout, TCoroType);

protected:
    mixin CoroutineProtectedT!(Tin, Tout, TCoroType);

    this(Ta1 arg1)
    {
        this.arg1 = arg1;
        контекст = new КонтекстСтэка(&startProc, STACK_SIZE);
        static if( coroType == CoroType.Eager )
            контекст.пуск();
    }

    abstract
    проц
    пуск(Ta1);

private:
    КонтекстСтэка контекст;
    
    static if( coroType == CoroType.Eager )
        бул running = true;

    static if( !is( Tout == проц ) )
        Tout cout;

    static if( !is( Tin == проц ) )
        Tin cin;

    Ta1 arg1;

    проц
    startProc()
    {
        // Initial call to coroutine proper
        пуск(arg1);
    }
}

/**
 * TODO
 */
class
Coroutine(Tin, Tout, Ta1, Ta2, CoroType TCoroType = CoroType.NonEager)
{
    mixin CoroutinePublicT!(Tin, Tout, TCoroType);

protected:
    mixin CoroutineProtectedT!(Tin, Tout, TCoroType);

    this(Ta1 arg1, Ta2 arg2)
    {
        this.arg1 = arg1;
        this.arg2 = arg2;
        контекст = new КонтекстСтэка(&startProc, STACK_SIZE);
        static if( coroType == CoroType.Eager )
            контекст.пуск();
    }

    abstract
    проц
    пуск(Ta1, Ta2);

private:
    КонтекстСтэка контекст;
    
    static if( coroType == CoroType.Eager )
        бул running = true;

    static if( !is( Tout == проц ) )
        Tout cout;

    static if( !is( Tin == проц ) )
        Tin cin;

    Ta1 arg1;
    Ta2 arg2;

    проц
    startProc()
    {
        // Initial call to coroutine proper
        пуск(arg1, arg2);
    }
}

/**
 * TODO
 */
class
Coroutine(Tin, Tout, Ta1, Ta2, Ta3, CoroType TCoroType = CoroType.NonEager)
{
    mixin CoroutinePublicT!(Tin, Tout, TCoroType);

protected:
    mixin CoroutineProtectedT!(Tin, Tout, TCoroType);

    this(Ta1 arg1, Ta2 arg2, Ta3 arg3)
    {
        this.arg1 = arg1;
        this.arg2 = arg2;
        this.arg3 = arg3;
        контекст = new КонтекстСтэка(&startProc, STACK_SIZE);
        static if( coroType == CoroType.Eager )
            контекст.пуск();
    }

    abstract
    проц
    пуск(Ta1, Ta2, Ta3);

private:
    КонтекстСтэка контекст;
    
    static if( coroType == CoroType.Eager )
        бул running = true;

    static if( !is( Tout == проц ) )
        Tout cout;

    static if( !is( Tin == проц ) )
        Tin cin;

    Ta1 arg1;
    Ta2 arg2;
    Ta3 arg3;

    проц
    startProc()
    {
        // Initial call to coroutine proper
        пуск(arg1, arg2, arg3);
    }
}

/**
 * TODO
 */
class
Coroutine(Tin, Tout, Ta1, Ta2, Ta3, Ta4, CoroType TCoroType = CoroType.NonEager)
{
    mixin CoroutinePublicT!(Tin, Tout, TCoroType);

protected:
    mixin CoroutineProtectedT!(Tin, Tout, TCoroType);

    this(Ta1 arg1, Ta2 arg2, Ta3 arg3, Ta4 arg4)
    {
        this.arg1 = arg1;
        this.arg2 = arg2;
        this.arg3 = arg3;
        this.arg4 = arg4;
        контекст = new КонтекстСтэка(&startProc, STACK_SIZE);
        static if( coroType == CoroType.Eager )
            контекст.пуск();
    }

    abstract
    проц
    пуск(Ta1, Ta2, Ta3, Ta4);

private:
    КонтекстСтэка контекст;
    
    static if( coroType == CoroType.Eager )
        бул running = true;

    static if( !is( Tout == проц ) )
        Tout cout;

    static if( !is( Tin == проц ) )
        Tin cin;

    Ta1 arg1;
    Ta2 arg2;
    Ta3 arg3;
    Ta4 arg4;

    проц
    startProc()
    {
        // Initial call to coroutine proper
        пуск(arg1, arg2, arg3, arg4);
    }
}

/**
 * TODO
 */
class
Coroutine(Tin, Tout, Ta1, Ta2, Ta3, Ta4, Ta5, CoroType TCoroType = CoroType.NonEager)
{
    mixin CoroutinePublicT!(Tin, Tout, TCoroType);

protected:
    mixin CoroutineProtectedT!(Tin, Tout, TCoroType);

    this(Ta1 arg1, Ta2 arg2, Ta3 arg3, Ta4 arg4, Ta5 arg5)
    {
        this.arg1 = arg1;
        this.arg2 = arg2;
        this.arg3 = arg3;
        this.arg4 = arg4;
        this.arg5 = arg5;
        контекст = new КонтекстСтэка(&startProc, STACK_SIZE);
        static if( coroType == CoroType.Eager )
            контекст.пуск();
    }

    abstract
    проц
    пуск(Ta1, Ta2, Ta3, Ta4, Ta5);

private:
    КонтекстСтэка контекст;
    
    static if( coroType == CoroType.Eager )
        бул running = true;

    static if( !is( Tout == проц ) )
        Tout cout;

    static if( !is( Tin == проц ) )
        Tin cin;

    Ta1 arg1;
    Ta2 arg2;
    Ta3 arg3;
    Ta4 arg4;
    Ta5 arg5;

    проц
    startProc()
    {
        // Initial call to coroutine proper
        пуск(arg1, arg2, arg3, arg4, arg5);
    }
}


/**
 * This mixin implements the constructor, и static opCall method for your
 * coroutine.  It is a good idea to mix this into your coroutine subclasses,
 * so that you need only override the пуск methoauxd.
 */
template
CoroutineMixin(Tin, Tout)
{
    this()
    {
        super();
    }
}

/**
 * This mixin implements the constructor, и static opCall method for your
 * coroutine.  It is a good idea to mix this into your coroutine subclasses,
 * so that you need only override the пуск methoauxd.
 */
template
CoroutineMixin(Tin, Tout, Ta1)
{
    this(Ta1 arg1)
    {
        super(arg1);
    }
}

/**
 * This mixin implements the constructor, и static opCall method for your
 * coroutine.  It is a good idea to mix this into your coroutine subclasses,
 * so that you need only override the пуск methoauxd.
 */
template
CoroutineMixin(Tin, Tout, Ta1, Ta2)
{
    this(Ta1 arg1, Ta2 arg2)
    {
        super(arg1, arg2);
    }
}

/**
 * This mixin implements the constructor, и static opCall method for your
 * coroutine.  It is a good idea to mix this into your coroutine subclasses,
 * so that you need only override the пуск methoauxd.
 */
template
CoroutineMixin(Tin, Tout, Ta1, Ta2, Ta3)
{
    this(Ta1 arg1, Ta2 arg2, Ta3 arg3)
    {
        super(arg1, arg2, arg3);
    }
}

/**
 * This mixin implements the constructor, и static opCall method for your
 * coroutine.  It is a good idea to mix this into your coroutine subclasses,
 * so that you need only override the пуск methoauxd.
 */
template
CoroutineMixin(Tin, Tout, Ta1, Ta2, Ta3, Ta4)
{
    this(Ta1 arg1, Ta2 arg2, Ta3 arg3, Ta4 arg4)
    {
        super(arg1, arg2, arg3, arg4);
    }
}

/**
 * This mixin implements the constructor, и static opCall method for your
 * coroutine.  It is a good idea to mix this into your coroutine subclasses,
 * so that you need only override the пуск methoauxd.
 */
template
CoroutineMixin(Tin, Tout, Ta1, Ta2, Ta3, Ta4, Ta5)
{
    this(Ta1 arg1, Ta2 arg2, Ta3 arg3, Ta4 arg4, Ta5 arg5)
    {
        super(arg1, arg2, arg3, arg4, arg5);
    }
}


