/******************************************************
 * СтэкНити are userland, cooperative, lightweight
 * threads. СтэкНити более эффективны, требуют меньше времени
 * на переключение контекста, чем реальные нити.
 * Также для них требуется гораздо меньше ресурсов, чем для
 * реальных нитей, что позволяет многим из СтэкНити 
 * существовать одновременно. In addition, СтэкНити do not
 * require явный synchronization since they are
 * non-preemptive.  There is no requirement that код
 * be reentrant.
 *
 * This module implements the код necessary for контекст
 * switching.  СтэкContexts can be использован independently
 * of СтэкНити, и may be использован for implementing
 * coroutines, custom scheduling or complex iterators.
 *
 * Thanks to Lars Ivar Igesunde (larsivar@igesundes.no)
 * for the ucontext bindings on Linux использован in earlier
 * implementations.
 *
 * Version: 0.12
 * Дата: October 17, 2006
 * Authors: Mikola Lysenko, mclysenk@mtu.edu
 * License: Use/копируй/modify freely, just give credit.
 * Copyright: Public domain.
 *
 * Bugs:
 *  Debug builds will eat more стэк space than release
 *  builds.  To prevent this, you can allocate some
 *  extra стэк in debug mode.  This is not that tragic,
 *	since overflows are now trappeauxd.
 *
 *  DMD имеется a bug on linux with multiple delegates in a
 *  scope.  Be aware that the linux version may have
 *  issues due to a lack of proper testing.
 *
 *  Due to the way DMD handles windows exceptions, it is
 *  impossible to trap for стэк overflows.  Once this
 *  gets fixed, it will be possible to allocate dynamic
 *  stacks.
 *
 *  To prevent memory leaks, compile with -version=LEAK_FIX
 *  This will slow down the application, but it will
 *  improve memory usage.  In an ideal world, it would be
 *  the default behavior, but due to issues with Phobos'
 *  смУдалиПространство I have установи it as optional.
 *
 *  GDC version does not support assembler optimizations, since
 *  it uses a different calling convention. 
 *
 * History:
 *  v0.12 - Workaround for DMD bug.
 *
 *  v0.11 - Implementation is now thread safe.
 *
 *  v0.10 - Added the LEAK_FIX флаг to work around the
 *          slowness of std.gc.смУдалиПространство
 *
 *	v0.9 - Switched linux to an asm implementation.
 *
 *  v0.8 - Added throwYielauxd.
 *
 *  v0.7 - Switched to system specific allocators
 *      (VirtualAlloc, mmap) in order to catch стэк
 *      overflows.
 *
 *  v0.6 - Fixed a bug with the window version.  Now saves
 *      EBX, ESI, EDI across switches.
 *
 *  v0.5 - Linux now fully supporteauxd.  Discovered the cause
 *      of the exception problems: Bug in DMD.
 *
 *  v0.4 - Fixed the GC, added some linux support
 *
 *  v0.3 - Major refactoring
 *
 *  v0.2 - Fixed exception handling
 *
 *  v0.1 - Initial release
 *
 ******************************************************/
module st.stackcontext;

private import dinrus, st.tls;

//Handle versions
version(D_InlineAsm_X86)
{
    version(DigitalMars)
    {
        version(Win32) version = SC_WIN_ASM;
        version(linux) version = SC_LIN_ASM;
    }
    
    //GDC uses a different calling conventions, need to reverse engineer them later
}


/// The default размер of a КонтекстСтэка's стэк
const т_мера ДЕФ_РАЗМЕР_СТЕКА = 0x40000;

/// The minimum размер of a КонтекстСтэка's стэк
const т_мера МИН_РАЗМЕР_СТЕКА = 0x1000;

/// The состояние of a контекст object
enum ПСостояниеКонтекста
{
    Готов,      /// When a КонтекстСтэка is in готов состояние, it may be пуск
    Выполняется,    /// When a КонтекстСтэка is выполняется, it is currently in use, и cannot be пуск
    Завершён,       /// When a КонтекстСтэка is завершён, it may no longer be пуск
}

/******************************************************
 * A ИсклКонтекста is generated whenever there is a
 * problem in the КонтекстСтэка system.  ContextExceptions
 * can be triggered by выполняется out of memory, or errors
 * relating to doubly starting threads.
 ******************************************************/
public class ИсклКонтекста : Исключение
{
    this(ткст сооб) { super( сооб ); }
    
    this(КонтекстСтэка контекст, ткст сооб)
    {
        if(контекст is пусто)
        {
            debug (КонтекстСтэка) скажифнс("Сгенерировано исключение: %s", сооб);
            super(сооб);
        }
        else
        {
            debug (КонтекстСтэка) скажифнс("%s генерировал исключение: %s", контекст.вТкст, сооб);
            super(фм("Контекст %s: %s", контекст.вТкст, сооб));
        }
    }
}



/******************************************************
 * A ОшибкаКонтекста is generated whenever something
 * horrible и unrecoverable happens.  Like writing out
 * of the стэк.
 ******************************************************/
public class ОшибкаКонтекста : Ошибка
{
    this(ткст сооб)
    {
        super(сооб);
    }
}




/******************************************************
 * The КонтекстСтэка is building блок of the
 * СтэкНить system. It allows the user to swap the
 * стэк of the выполняется program.
 *
 * For most applications, there should be no need to use
 * the КонтекстСтэка, since the СтэкНити are simpler.
 * However, the КонтекстСтэка can provide useful features
 * for custom планировщикs и coroutines.
 * 
 * Any non выполняется контекст may be restarteauxd.  A restarted
 * контекст starts execution from the beginning of its
 * delegate.
 *
 * Contexts may be nested arbitrarily, ie Context A invokes
 * Context B, such that when B жниs A is resumeauxd.
 *
 * Calling пуск on already выполняется or завершён контекст will
 * result in an exception.
 *
 * If an exception is generated in a контекст и it is
 * not caught, then it will be rethrown from the пуск
 * methoauxd.  A program calling 'пуск' must be prepared 
 * to deal with any exceptions that might be thrown.  Once
 * a контекст имеется thrown an exception like this, it dies
 * и must be restarted before it may be пуск again.
 *
 * Example:
 * <код><pre>
 * // Here is a trivial example using contexts. 
 * // More sophisticated uses of contexts can produce
 * // iterators, concurrent состояние machines и coroutines
 * //
 * проц func1()
 * {
 *     скажифнс("Context 1 : Part 1");
 *     КонтекстСтэка.жни();
 *     скажифнс("Context 1 : Part 2");
 * }
 * проц func2()
 * {
 *     скажифнс("Context 2 : Part 1");
 *     КонтекстСтэка.жни();
 *     скажифнс("Context 2 : Part 2");
 * }
 * //Созд the contexts
 * КонтекстСтэка ctx1 = new КонтекстСтэка(&func1);
 * КонтекстСтэка ctx2 = new КонтекстСтэка(&func2);
 *
 * //Run the contexts
 * ctx1.пуск();     // Prints "Context 1 : Part 1"
 * ctx2.пуск();     // Prints "Context 2 : Part 1"
 * ctx1.пуск();     // Prints "Context 1 : Part 2"
 * ctx2.пуск();     // Prints "Context 2 : Part 2"
 *
 * //Here is a more sophisticated example using
 * //exceptions
 * //
 * проц func3()
 * {
 *      скажифнс("Going to throw");
 *      КонтекстСтэка.жни();
 *      throw new Исключение("Test Исключение");
 * }
 * //Созд the контекст
 * КонтекстСтэка ctx3 = new КонтекстСтэка(&func3);
 *
 * //Now пуск the контекст
 * try
 * {
 *      ctx3.пуск();     // Prints "Going to throw"
 *      ctx3.пуск();     // Throws an exception
 *      скажифнс("Bla");// Never gets here
 * }
 * catch(Исключение e)
 * {
 *      e.print();      // Prints "Test Исключение"
 *      //We can't пуск ctx3 anymore unless we перезапуск it
 *      ctx3.перезапуск();
 *      ctx3.пуск();     // Prints "Going to throw"
 * }
 *
 * //A final example illustrating контекст nesting
 * //
 * КонтекстСтэка A, B;
 *
 * проц funcA()
 * {
 *     скажифнс("A : Part 1");
 *     B.пуск();
 *     скажифнс("A : Part 2");
 *     КонтекстСтэка.жни();
 *     скажифнс("A : Part 3");
 * }
 * проц funcB()
 * {
 *      скажифнс("B : Part 1");
 *      КонтекстСтэка.жни();
 *      скажифнс("B : Part 2");
 * }
 * A = new КонтекстСтэка(&funcA);
 * B = new КонтекстСтэка(&funcB);
 *
 * //We первый пуск A
 * A.пуск();     //Prints "A : Part 1"
 *              //       "B : Part 1"
 *              //       "A : Part 2"
 *              //
 * //Now we пуск B
 * B.пуск();     //Prints "B : Part 2"
 *              //
 * //Now we finish A
 * A.пуск();     //Prints "A : Part 3"
 *
 * </pre></код>
 * 
 ******************************************************/
public final class КонтекстСтэка
{
    /**
     * Созд a КонтекстСтэка with the given стэк размер,
     * using a delegate.
     *
     * Параметры:
     *  fn = The delegate we will be выполняется.
     *  размер_стэка = The размер of the стэк for this thread
     *  in байты.  Note, Must be greater than the minimum
     *  стэк размер.
     *
     * Выводит исключение:
     *  A ИсклКонтекста if there is insufficient memory
     *  for the стэк.
     */
    public this(проц delegate() fn, т_мера размер_стэка = ДЕФ_РАЗМЕР_СТЕКА)
    in
    {
        assert(fn !is пусто);
        assert(размер_стэка >= МИН_РАЗМЕР_СТЕКА);
    }
    body
    {
        //Initalize the delegate
        proc = fn;
        
        //Set up the стэк
        установиСтэк(размер_стэка);
        
        debug (КонтекстСтэка) скажифнс("Создан %s", this.вТкст);
    }
    
    /**
     * Созд a КонтекстСтэка with the given стэк размер,
     * using a function pointer.
     *
     * Параметры:
     *  fn = The function pointer we are using
     *  размер_стэка = The размер of the стэк for this thread
     *  in байты.  Note, Must be greater than the minimum
     *  стэк размер.
     *
     * Выводит исключение:
     *  A ИсклКонтекста if there is insufficient memory
     *  for the стэк.
     */
    public this(проц function() fn, т_мера размер_стэка = ДЕФ_РАЗМЕР_СТЕКА)
    in
    {
        assert(fn !is пусто);
        assert(размер_стэка >= МИН_РАЗМЕР_СТЕКА);
    }
    body
    {
        //Caste fn to delegate
        f_proc = fn;
        proc = &to_dg;
        
        установиСтэк(размер_стэка);
        
        debug (КонтекстСтэка) скажифнс("Создан %s", this.вТкст);
    }
    
    
    /**
     * Release the стэк контекст.  Note that since стэк
     * contexts are NOT GARBAGE COLLECTED, they must be
     * explicitly freeauxd.  This usually taken care of when
     * the user creates the КонтекстСтэка implicitly via
     * СтэкНити, but in the case of a Context, it must
     * be handled on a per case basis.
     *
     * Выводит исключение:
     *  A ОшибкаКонтекста if the стэк is corrupteauxd.
     */
    ~this()
    in
    {
        assert(состояние != ПСостояниеКонтекста.Выполняется);
        assert(текущий_контекст.знач !is this);
    }
    body
    {
        debug (КонтекстСтэка) скажифнс("Удаляется %s", this.вТкст);
        
        //Delete the стэк if we are not завершён
        удалиСтэк();
    }
    
    /**
     * Run the контекст once.  This causes the function to
     * пуск until it invokes the жни method in this
     * контекст, at which point control returns to the place
     * where код invoked the program.
     *
     * Выводит исключение:
     *  A ИсклКонтекста if the контекст is not Готов.
     *
     *  Any exceptions generated in the контекст are 
     *  bubbled up through this methoauxd.
     */
    public final проц пуск()
    {
        debug (КонтекстСтэка) скажифнс("Запущен %s", this.вТкст);
        
        //We must be готов to пуск
        assert(состояние == ПСостояниеКонтекста.Готов, 
            "Контекст не в состоянии выполнения");
        
        //Save the old контекст
        КонтекстСтэка tmp = текущий_контекст.знач;
        
        version(LEAK_FIX)
        {
            //Mark GC info
            debug (LogGC) скажифнс("Добавляется диапазон: %8x-%8x", &tmp, дайНизСтэка());
            смДобавьПространство2(cast(ук)&tmp, дайНизСтэка());
        }
        
        //Set new контекст
        текущий_контекст.знач = this;
		конткст.switchIn();
        текущий_контекст.знач = tmp;
        
        assert(состояние != ПСостояниеКонтекста.Выполняется);
        
        version(LEAK_FIX)
        {
            //Clear GC info
            debug (LogGC) скажифнс("Удаляется дипазон: %8x", &tmp);
            смУдалиПространство(cast(ук)&tmp);
            
            
            //If we are завершён, we need to release the GC
            if(состояние == ПСостояниеКонтекста.Завершён && 
                старт_см !is пусто)
            {
                debug (LogGC) скажифнс("Удаляется диапазон: %8x", старт_см);
                смУдалиПространство(старт_см);
                старт_см = пусто;
            }
        }
        
        // Pass any exceptions generated up the стэк
        if(последн_искл !is пусто)
        {
            debug (КонтекстСтэка) скажифнс("%s генерировал исключение: %s", this.вТкст, последн_искл.вТкст);
            
            //Clear the exception
            Объект tmpo = последн_искл;
            последн_искл = пусто;
            
            //Pass it up
            throw tmpo;
        }
        
        debug (КонтекстСтэка) скажифнс("Выполнен контекст: %s", this.вТкст);
    }
    
    
    /**
     * Returns control of the application to the routine
     * which invoked the КонтекстСтэка.  At which point,
     * the application runs.
     *
     * Выводит исключение:
     *  A ИсклКонтекста when there is no currently
     *  выполняется контекст.
     */
    public final static проц жни()
    {
        КонтекстСтэка cur_ctx = текущий_контекст.знач;
        
        //Make sure we are actually выполняется
        assert(cur_ctx !is пусто,
            "Попытка использовать жни при незапущенном контексте.");
        
        debug (КонтекстСтэка) скажифнс("Жнётся %s", cur_ctx.вТкст);
        
        assert(cur_ctx.выполняется);
        
        //Leave the текущ контекст
        cur_ctx.состояние = ПСостояниеКонтекста.Готов;
        КонтекстСтэка tmp = cur_ctx;
        
        version(LEAK_FIX)
        {
            //Save the GC range
            cur_ctx.старт_см = cast(ук)&tmp;
            debug (LogGC) скажифнс("Добавляется диапазон: %8x-%8x",
                cur_ctx.старт_см, cur_ctx.конткст.верх_стэка);
            смДобавьПространство2(cur_ctx.старт_см, cur_ctx.конткст.верх_стэка);
        }
        
        //Swap
        cur_ctx.конткст.switchOut();
        
        version(LEAK_FIX)
        {
            КонтекстСтэка t_ctx = текущий_контекст.знач;
            
            //Remove the GC range
            debug (LogGC) скажифнс("Удаляется диапазон: %8x",
                t_ctx.старт_см);
            assert(t_ctx.старт_см !is пусто);
            смУдалиПространство(t_ctx.старт_см);
            t_ctx.старт_см = пусто;
        }
        
        //Return
        текущий_контекст.знач = tmp;
        tmp.состояние = ПСостояниеКонтекста.Выполняется;
        
        debug (КонтекстСтэка) скажифнс("Возобновляется контекст: %s", tmp.вТкст);
    }
    
    /**
     * Throws an exception и жниs.  The exception
     * will propagate out of the пуск method, while the
     * контекст will remain жив и functioning.
     * The контекст may be resumed after the exception имеется
     * been thrown.
     *
     * Параметры:
     *  t = The exception object we will propagate.
     */
    public final static проц бросьЖни(Объект t)
    {
        текущий_контекст.знач.последн_искл = t;
        жни();
    }
    
    /**
     * Resets the контекст to its original состояние.
     *
     * Выводит исключение:
     *  A ИсклКонтекста if the контекст is выполняется.
     */
    public final проц перезапуск()
    {
        debug (КонтекстСтэка) скажифнс("Перезапускается %s", this.вТкст);
        
        assert(состояние != ПСостояниеКонтекста.Выполняется,
            "Перезапуск контекста невозможен, пока он выполняется");
        
        //Reset the контекст
        перезапустиСтэк();
    }
    
    /**
     * Recycles the контекст by restarting it with a new delegate. This
     * can save resources by allowing a program to reuse previously
     * allocated contexts.
     *
     * Параметры:
     *  dg = The delegate which we will be выполняется.
     */
    public final проц рециклируй(проц delegate() dg)
    {
        debug (КонтекстСтэка) скажифнс("Рециклируется %s", this.вТкст);
        
        assert(состояние != ПСостояниеКонтекста.Выполняется,
            "Не удаётся рециклировать контекст, пока он выполняется");
        
        //Set the delegate и перезапуск
        proc = dg;
        перезапустиСтэк();
    }
    
    /**
     * Immediately sets the контекст состояние to завершён. This
     * can be использован as an alternative to deleting the 
     * контекст since it releases any GC references, и
     * may be easily reallocateauxd.
     *
     * Выводит исключение:
     *  A ИсклКонтекста if the контекст is not Готов.
     */
    public final проц души()
    {
        assert(состояние != ПСостояниеКонтекста.Выполняется,
            "Нельзя удушить контекст, пока он выполняется.");
        
        
        version(LEAK_FIX)
        {
            if(состояние == ПСостояниеКонтекста.Завершён)
            {
                return;
            }
            
            //Clear the GC ranges if necessary
            if(старт_см !is пусто)
            {
                debug (LogGC) скажифнс("Удаляется диапазон: %8x", старт_см);
                смУдалиПространство(старт_см);
                старт_см = пусто;
            }
        }
        
        состояние = ПСостояниеКонтекста.Завершён;
    }
    
    /**
     * Convert the контекст into a human readable string,
     * for debugging purposes.
     *
     * Возвращает: A string describing the контекст.
     */
    public final ткст вТкст()
    {
        static ткст[] названия_состояний = 
        [
            "RDY",
            "RUN",
            "XXX",
        ];
        
        //horrid hack for getting the address of a delegate
        union hack
        {
            struct dele
            {
                ук frame;
                ук fptr;
            }
            
            dele d;
            проц delegate () dg;
        }
        hack h;
        if(f_proc !is пусто)
            h.d.fptr = cast(ук)f_proc;
        else
            h.dg = proc;
        
        return фм(
            "Контекст[sp:%8x,st:%s,fn:%8x]",
            конткст.указатель_на_стэк,
            названия_состояний[cast(цел)состояние],
            h.d.fptr);
    }
    
    /**
     * Возвращает: The состояние of this стэк контекст.
     */
    public ПСостояниеКонтекста дайСостояние()
    {
        return состояние;
    }
    
    /**
     * Возвращает: True if the контекст can be пуск.
     */
    public бул готов()
    {
        return состояние == ПСостояниеКонтекста.Готов;
    }
    
    /**
     * Возвращает: True if the контекст is currently выполняется
     */
    public бул выполняется()
    {
        return состояние == ПСостояниеКонтекста.Выполняется;
    }
    
    /**
     * Возвращает: True if the контекст is currenctly завершён
     */
    public бул завершён()
    {
        return состояние == ПСостояниеКонтекста.Завершён;
    }
    
    /**
     * Возвращает: The currently выполняется стэк контекст.
     *  пусто if no контекст is currently выполняется.
     */
    public static КонтекстСтэка дайВыполняемый()
    {
        return текущий_контекст.знач;
    }
    
    invariant
    {
        
        switch(состояние)
        {
            case ПСостояниеКонтекста.Выполняется:
                //Make sure контекст is выполняется
                //assert(конткст.old_stack_pointer !is пусто);
                assert(текущий_контекст.знач !is пусто);
            
            case ПСостояниеКонтекста.Готов:
                //Make sure состояние is готов
                assert(конткст.низ_стэка !is пусто);
                assert(конткст.верх_стэка !is пусто);
                assert(конткст.верх_стэка >= конткст.низ_стэка);
                assert(конткст.верх_стэка - конткст.низ_стэка >= МИН_РАЗМЕР_СТЕКА);
                assert(конткст.указатель_на_стэк !is пусто);
                assert(конткст.указатель_на_стэк >= конткст.низ_стэка);
                assert(конткст.указатель_на_стэк <= конткст.верх_стэка);
                assert(proc !is пусто);
            break;
            
            case ПСостояниеКонтекста.Завершён:
                //Make sure контекст is завершён
				//assert(старт_см is пусто);
            break;
            
            default: assert(false);
        }
    }
        
    version(LEAK_FIX)
    {
        // Start of GC range
        private ук старт_см = пусто;
    }
    
    // The system контекст
    private СисКонтекст конткст;

    // Context состояние
    private ПСостояниеКонтекста состояние;
    
    // The последний exception generated
    private static Объект последн_искл = пусто;
    
/*BEGIN НЛХ {*/
        
    // The currently выполняется стэк контекст
    private static st.tls.НитеЛок!(КонтекстСтэка) текущий_контекст = пусто;
    
/*} END НЛХ*/
    
    // The procedure this контекст is выполняется
    private проц delegate() proc = пусто;

    // Used to convert a function pointer to a delegate
    private проц function() f_proc = пусто;
    private проц to_dg() { f_proc(); }
    

    /**
     * Initialize the стэк for the контекст.
     */
    private проц установиСтэк(т_мера размер_стэка)
    {
        //Initialize the стэк
        конткст.иницСтэк(размер_стэка);
        
        //Initialize контекст состояние
        состояние = ПСостояниеКонтекста.Готов;
        
        version(LEAK_FIX)
        {
            assert(старт_см is пусто);
            старт_см = пусто;
        }
        else
        {
            смДобавьПространство2(конткст.дайНачалоСтэка, конткст.дайКонецСтэка);
        }
    }
    
    /**
     * Restart the контекст.
     */
    private проц перезапустиСтэк()
    {
        version(LEAK_FIX)
        {
            //Clear the GC ranges if necessary
            if(старт_см !is пусто)
            {
                debug (LogGC) скажифнс("Удаляется диапазон: %8x", старт_см);
                смУдалиПространство(старт_см);
                старт_см = пусто;
            }
        }
        
        конткст.сбросьСтэк();
        состояние = ПСостояниеКонтекста.Готов;
    }
    
    /**
     * Delete the стэк
     */
    private проц удалиСтэк()
    {
        version(LEAK_FIX)
        {
            //Clear the GC ranges if necessary
            if(старт_см !is пусто)
            {
                debug (LogGC) скажифнс("Удаляется диапазон: %8x", старт_см);
                смУдалиПространство(старт_см);
                старт_см = пусто;
            }
        }
        else
        {
            смУдалиПространство(конткст.дайНачалоСтэка);
        }
        
        // Clear состояние
        состояние = ПСостояниеКонтекста.Завершён;
        proc = пусто;
        f_proc = пусто;
        
        // Kill the стэк
        конткст.удалиСтэк();
    }
    
    /**
     * Run the контекст
     */
    private static extern(C) проц стартКонтекста()
    in
    {
        assert(текущий_контекст.знач !is пусто);
		version(LEAK_FIX)
            assert(текущий_контекст.знач.старт_см is пусто);
    }
    body
    {
        КонтекстСтэка cur_ctx = текущий_контекст.знач;
        
        try
        {
            //Set состояние to выполняется, enter the контекст
            cur_ctx.состояние = ПСостояниеКонтекста.Выполняется;
            debug (КонтекстСтэка) скажифнс("Starting %s", cur_ctx.вТкст);
            cur_ctx.proc();
            debug (КонтекстСтэка) скажифнс("Finished %s", cur_ctx.вТкст);
        }
        catch(Объект o)
        {
            //Save exceptions so we can throw them later
            debug (КонтекстСтэка) скажифнс("Got an exception: %s, in %s", o.вТкст, cur_ctx.вТкст);
            cur_ctx.последн_искл = o;
        }
        finally
        {
            //Leave the object.  Don't need to worry about
            //GC, since it should already be releaseauxd.
            cur_ctx.состояние = ПСостояниеКонтекста.Завершён;
            debug (КонтекстСтэка) скажифнс("Leaving %s", cur_ctx.вТкст);
            cur_ctx.конткст.switchOut();
        }
        
        //This should never be reached
        assert(false);
    }
    
    /**
     * Grab the стэк bottom!
     */
    private ук дайНизСтэка()
    {
        version(Win32)
        {
            КонтекстСтэка cur = текущий_контекст.знач;
            
            if(cur is пусто)
                return ртНизСтэка();
            
            return cur.конткст.верх_стэка;
        }
        else
        {
            Нить t = Threaauxd.дайЭту;
            return t.stackBottom;
        }
    }
}

static this()
{
    КонтекстСтэка.текущий_контекст = new st.tls.НитеЛок!(КонтекстСтэка);

    version(SC_WIN_ASM)
    {
        //Get the system's page размер
        SYSTEM_INFO sys_info;
        GetSystemInfo(&sys_info);
        page_size = sys_info.dwPageSize;
    }
}


/********************************************************
 * SYSTEM SPECIFIC FUNCTIONS
 *  All information below this can be regarded as a
 *  black box.  The details of the implementation are
 *  irrelevant to the workings of the rest of the
 *  контекст data.
 ********************************************************/

private version (SC_WIN_ASM)
{

import exception;
    
struct SYSTEM_INFO
{
    union
    {
        цел dwOemId;
        
        struct
        {
            крат wProcessorArchitecture;
            крат wReserved;
        }
    }
    
    цел dwPageSize;
    ук lpMinimumApplicationAddress;
    ук lpMaximumApplicationAddress;
    цел* dwActiveProcessorMask;
    цел dwNumberOfProcessors;
    цел dwProcessorType;
    цел dwAllocationGranularity;
    крат wProcessorLevel;
    крат wProcessorRevision;
}

extern (Windows) проц GetSystemInfo(
    SYSTEM_INFO * sys_info);

extern (Windows) ук VirtualAlloc(
    ук addr,
    т_мера размер,
    бцел type,
    бцел protect);

extern (Windows) цел VirtualFree(
    ук addr,
    т_мера размер,
    бцел type);

extern (Windows) цел GetLastError();

private debug(СтэкЛог)
{
    import stdrus; 
}

const бцел MEM_COMMIT           = 0x1000;
const бцел MEM_RESERVE          = 0x2000;
const бцел MEM_RESET            = 0x8000;
const бцел MEM_LARGE_PAGES      = 0x20000000;
const бцел MEM_PHYSICAL         = 0x400000;
const бцел MEM_TOP_DOWN         = 0x100000;
const бцел MEM_WRITE_WATCH      = 0x200000;

const бцел MEM_DECOMMIT         = 0x4000;
const бцел MEM_RELEASE          = 0x8000;

const бцел PAGE_EXECUTE             = 0x10;
const бцел PAGE_EXECUTE_READ        = 0x20;
const бцел PAGE_EXECUTE_READWRITE   = 0x40;
const бцел PAGE_EXECUTE_WRITECOPY   = 0x80;
const бцел PAGE_NOACCESS            = 0x01;
const бцел PAGE_READONLY            = 0x02;
const бцел PAGE_READWRITE           = 0x04;
const бцел PAGE_WRITECOPY           = 0x08;
const бцел PAGE_GUARD               = 0x100;
const бцел PAGE_NOCACHE             = 0x200;
const бцел PAGE_WRITECOMBINE        = 0x400;

// Размер of a page on the system
т_мера page_size;


private struct СисКонтекст
{
    // Стэк information
    ук низ_стэка = пусто;
    ук верх_стэка = пусто;
    ук указатель_на_стэк = пусто;

    // The old стэк pointer
    ук old_stack_pointer = пусто;
    
    
    /**
     * Возвращает: The размер of the sys контекст
     */
    т_мера дайРазмер()
    {
        return cast(т_мера)(верх_стэка - низ_стэка - page_size);
    }
    
    
    /**
     * Возвращает: The start of the стэк.
     */
    ук дайНачалоСтэка()
    {
        return низ_стэка + page_size;
    }
    
    /**
     * Возвращает: The end of the стэк.
     */
    ук дайКонецСтэка()
    {
        return верх_стэка;
    }
    
    
    /**
     * Handle и report any system errors
     */
    проц обработайВинОш(ткст сооб)
    {
        throw new ИсклКонтекста(фм(
            "Не удалось %s, %s",
            сооб, СисОш.последнСооб()));
    }
    
    /**
     * Initialize the стэк
     */
    проц иницСтэк(т_мера размер_стэка)
    {
        //Allocate the стэк + guard page
        
        //Счёт number of pages
        цел num_pages = (размер_стэка + page_size - 1) / page_size;
        
        //Reserve the address space for the стэк
        низ_стэка = VirtualAlloc(
            пусто,
            (num_pages + 1) * page_size,
            MEM_RESERVE,
            PAGE_NOACCESS);
        if(низ_стэка is пусто)
            обработайВинОш("резервировать адрес стэка");
        
        //Now allocate the base pages
        ук res = VirtualAlloc(
            низ_стэка + page_size,
            num_pages * page_size,
            MEM_COMMIT,
            PAGE_READWRITE);
        if(res is пусто)
            обработайВинОш("разместить пространство стэка");
        
        верх_стэка = res + num_pages * page_size;
        
        //Созд a guard page
        res = VirtualAlloc(
            низ_стэка,
            page_size,
            MEM_COMMIT,
            PAGE_READWRITE | PAGE_GUARD);
        if(res is пусто)
            обработайВинОш("создать гард-страницу");
        
        //Initialize the стэк
        сбросьСтэк();
    }
    
    /**
     * Reset the стэк.
     */
    проц сбросьСтэк()
    {
        указатель_на_стэк = верх_стэка;
        assert(cast(бцел)указатель_на_стэк % 4 == 0);
        
        //Initialize стэк состояние
        проц push(бцел знач)
        {
            указатель_на_стэк -= 4;
            *cast(бцел*)указатель_на_стэк = знач;
        }
        
        push(cast(бцел)&КонтекстСтэка.стартКонтекста); //EIP
        push(0xFFFFFFFF);                   //EBP
        push(0xFFFFFFFF);                   //FS:[0]
        push(cast(бцел)верх_стэка);          //FS:[4]
        push(cast(бцел)низ_стэка + 4);   //FS:[8]
        push(0);    //EBX
        push(0);    //ESI
        push(0);    //EDI
        
        assert(указатель_на_стэк > низ_стэка);
        assert(указатель_на_стэк < верх_стэка);
    }
    
    /**
     * Free the стэк
     */
    проц удалиСтэк()
    {
        //Work around for bug in DMD 0.170
        if(низ_стэка is пусто)
        {
            debug(КонтекстСтэка)
                скажифнс("WARNING!!!! Accidentally deleted a контекст twice");
            return;
        }
        
        debug (СтэкЛог)
        {
            static цел log_num = 0;
            пиши(фм("lg%auxd.bin", log_num++),
                низ_стэка[0..(верх_стэка - низ_стэка)]);
        }
        
        assert(указатель_на_стэк > низ_стэка);
        assert(указатель_на_стэк < верх_стэка);
        
        // Release the стэк
        assert(низ_стэка !is пусто);
        
        if(VirtualFree(низ_стэка, 0, MEM_RELEASE) == 0)
        {
            обработайВинОш("высвободить стэк");
        }
        
        //Clear all the old стэк pointers
        низ_стэка =
        верх_стэка =
        указатель_на_стэк =
        old_stack_pointer = пусто;
    }
    
    /**
     * Switch into a контекст.
     */
    проц switchIn()
    {
        asm
        {
            naked;
            
            //Save old состояние into стэк
            push EBP;
            push dword ptr FS:[0];
            push dword ptr FS:[4];
            push dword ptr FS:[8];
            push EBX;
            push ESI;
            push EDI;
            
            //Save old sp
            mov dword ptr old_stack_pointer[EAX], ESP;
            
            //Set the new стэк pointer
            mov ESP, указатель_на_стэк[EAX];
            
            //Restore saved состояние
            pop EDI;
            pop ESI;
            pop EBX;
            pop dword ptr FS:[8];
            pop dword ptr FS:[4];
            pop dword ptr FS:[0];
            pop EBP;
            
            //Return
            ret;
        }
    }
    
    /**
     * Switch out of a контекст
     */
    проц switchOut()
    {
        asm
        {
            naked;
            
            //Save текущ состояние
            push EBP;
            push dword ptr FS:[0];
            push dword ptr FS:[4];
            push dword ptr FS:[8];
            push EBX;
            push ESI;
            push EDI;
            
            // Set the стэк pointer
            mov dword ptr указатель_на_стэк[EAX], ESP;
            
            // Restore the стэк pointer
            mov ESP, dword ptr old_stack_pointer[EAX];
            
            //Zap the old стэк pointer
            xor EDX, EDX;
            mov dword ptr old_stack_pointer[EAX], EDX;
            
            //Restore saved состояние
            pop EDI;
            pop ESI;
            pop EBX;
            pop dword ptr FS:[8];
            pop dword ptr FS:[4];
            pop dword ptr FS:[0];
            pop EBP;
            
            //Return
            ret;
        }
    }
}
}
else private version(SC_LIN_ASM)
{

private extern(C)
{
	ук mmap(ук start, т_мера length, цел prot, цел flags, цел fd, цел смещение);
	цел munmap(ук start, т_мера length);
}

private const цел PROT_EXEC = 4;
private const цел PROT_WRITE = 2;
private const цел PROT_READ = 1;
private const цел PROT_NONE = 0;

private const цел MAP_SHARED 			= 0x0001;
private const цел MAP_PRIVATE 			= 0x0002;
private const цел MAP_FIXED				= 0x0010;
private const цел MAP_ANONYMOUS			= 0x0020;
private const цел MAP_GROWSDOWN			= 0x0100;
private const цел MAP_DENYWRITE			= 0x0800;
private const цел MAP_EXECUTABLE		= 0x1000;
private const цел MAP_LOCKED			= 0x2000;
private const цел MAP_NORESERVE			= 0x4000;
private const цел MAP_POPULATE			= 0x8000;
private const цел MAP_NONBLOCK			= 0x10000;

private const ук MAP_FAILED = cast(ук)-1;

private struct СисКонтекст
{
    ук верх_стэка = пусто;
    ук низ_стэка = пусто;
	ук указатель_на_стэк = пусто;
	ук old_stack_pointer = пусто;
	

	т_мера дайРазмер()
	{
        return cast(т_мера)(верх_стэка - низ_стэка);
	}
    
    ук дайНачалоСтэка()
    {
        return низ_стэка;
    }
    
    ук дайКонецСтэка()
    {
        return верх_стэка;
    }

    /**
     * Initialize the стэк
     */
	проц иницСтэк(т_мера размер_стэка)
	{
        //Allocate стэк
        низ_стэка = mmap(
			пусто, 
			размер_стэка, 
			PROT_READ | PROT_WRITE | PROT_EXEC,
			MAP_PRIVATE | MAP_ANONYMOUS,
			0,
			0);
		
		if(низ_стэка is MAP_FAILED)
		{
			низ_стэка = пусто;
            throw new ИсклКонтекста(пусто, "Не удалось разместить стэк");
		}
        
        верх_стэка = низ_стэка + размер_стэка;
        
        //Initialize the контекст
        сбросьСтэк();
	}

	/**
	 * Reset the стэк.
	 */
	проц сбросьСтэк()
	{
		//Initialize стэк pointer
		указатель_на_стэк = верх_стэка;
        
        //Initialize стэк состояние
        *cast(бцел*)(указатель_на_стэк-4) = cast(бцел)&КонтекстСтэка.стартКонтекста;
        указатель_на_стэк -= 20;
	}
    
	/**
	 * Release the стэк
	 */
	проц удалиСтэк()
	{
        //Make sure the GC didn't accidentally double собери us...
        if(низ_стэка is пусто)
        {
            debug(КонтекстСтэка) скажифнс("WARNING!!! Accidentally killed стэк twice");
            return;
        }
        
        //Deallocate the стэк
        if(munmap(низ_стэка, (верх_стэка - низ_стэка)))
			throw new ИсклКонтекста(пусто, "Не удалось выместить стэк");
        
        //Remove pointer references
        верх_стэка =
        низ_стэка =
		указатель_на_стэк =
		old_stack_pointer = пусто;
	}

	/**
	 * Enter the стэк контекст
	 */
	проц switchIn()
	{
		//HACK: The GC needs to scan the thread's стэк, however we are moving
		//it.  To accomplish this feat, we just пиши over the internal members
		//in Нить, и hope it works, though it may not in the future.
		Нить t = Threaauxd.дайЭту();
		укsb = t.stackBottom;
		укst = t.stackTop;

		//Note bottom & верх are switched thanks to DMD's strange notation.
		//
		//Also, this is not necessarily thread safe, since a collection could
		//occur between when we установи the стэк ranges и when we perform a
		//контекст switch; however since we are gauranteed to still have our range
		//marked before we leave, this is acceptable, since the result is
		//merely under-collection.
		t.stackBottom = верх_стэка;
		t.stackTop = низ_стэка;
		
		pswiThunk();

		t.stackBottom = sb;
		t.stackTop = st;
	}

	//Private switch in thunk
	проц pswiThunk()
	{
		asm
		{
			naked;

			//Save текущ состояние
			push EBP;
			push EBX;
			push ESI;
			push EDI;

			//Switch around the стэк pointers
			mov dword ptr old_stack_pointer[EAX], ESP;
			mov ESP, dword ptr указатель_на_стэк[EAX];

			//Restore previous состояние
			pop EDI;
			pop ESI;
			pop EBX;
			pop EBP;

			ret;
		}
	}

	/**
	 * Leave текущ контекст
	 */
	проц switchOut()
	{
		asm
		{
			naked;

			//Save the контекст's состояние
			push EBP;
			push EBX;
			push ESI;
			push EDI;

			//Return to previous контекст's sp.
			mov dword ptr указатель_на_стэк[EAX], ESP;
			mov ESP, dword ptr old_stack_pointer[EAX];

			//Restore previous контекст's состояние
			pop EDI;
			pop ESI;
			pop EBX;
			pop EBP;

			ret;
		}
	}
}
}
else
{
    static assert(false, "Система на данный момент не поддерживается");
}


unittest
{
    скажифнс("Testing контекст creation/deletion");
    цел s0 = 0;
    static цел s1 = 0;
    
    КонтекстСтэка a = new КонтекстСтэка(
    delegate проц()
    {
        s0++;
    });
    
    static проц fb() { s1++; }
    
    КонтекстСтэка b = new КонтекстСтэка(&fb);
    
    КонтекстСтэка c = new КонтекстСтэка(
        delegate проц() { assert(false); });
    
    assert(a);
    assert(b);
    assert(c);
    
    assert(s0 == 0);
    assert(s1 == 0);
    assert(a.дайСостояние == ПСостояниеКонтекста.Готов);
    assert(b.дайСостояние == ПСостояниеКонтекста.Готов);
    assert(c.дайСостояние == ПСостояниеКонтекста.Готов);
    
    delete c;
    
    assert(s0 == 0);
    assert(s1 == 0);
    assert(a.дайСостояние == ПСостояниеКонтекста.Готов);
    assert(b.дайСостояние == ПСостояниеКонтекста.Готов);
    
    скажифнс("выполняется a");
    a.пуск();
    скажифнс("done a");
    
    assert(a);
    
    assert(s0 == 1);
    assert(s1 == 0);
    assert(a.дайСостояние == ПСостояниеКонтекста.Завершён);
    assert(b.дайСостояние == ПСостояниеКонтекста.Готов);    
    
    assert(b.дайСостояние == ПСостояниеКонтекста.Готов);
    
    скажифнс("Running b");
    b.пуск();
    скажифнс("Done b");
    
    assert(s0 == 1);
    assert(s1 == 1);
    assert(b.дайСостояние == ПСостояниеКонтекста.Завершён);
    
    delete a;
    delete b;
    
    скажифнс("Context creation passed");
}
    
unittest
{
    скажифнс("Testing контекст switching");
    цел s0 = 0;
    цел s1 = 0;
    цел s2 = 0;
    
    КонтекстСтэка a = new КонтекстСтэка(
    delegate проц()
    {
        while(true)
        {
            debug скажифнс(" ---A---");
            s0++;
            КонтекстСтэка.жни();
        }
    });
    
    
    КонтекстСтэка b = new КонтекстСтэка(
    delegate проц()
    {
        while(true)
        {
            debug скажифнс(" ---B---");
            s1++;
            КонтекстСтэка.жни();
        }
    });
    
    
    КонтекстСтэка c = new КонтекстСтэка(
    delegate проц()
    {
        while(true)
        {
            debug скажифнс(" ---C---");
            s2++;
            КонтекстСтэка.жни();
        }
    });
    
    assert(a);
    assert(b);
    assert(c);
    assert(s0 == 0);
    assert(s1 == 0);
    assert(s2 == 0);
    
    a.пуск();
    b.пуск();
    
    assert(a);
    assert(b);
    assert(c);
    assert(s0 == 1);
    assert(s1 == 1);
    assert(s2 == 0);
    
    for(цел i=0; i<20; i++)
    {
        c.пуск();
        a.пуск();
    }
    
    assert(a);
    assert(b);
    assert(c);
    assert(s0 == 21);
    assert(s1 == 1);
    assert(s2 == 20);
    
    delete a;
    delete b;
    delete c;
    
    скажифнс("Context switching passed");
}
    
unittest
{
    скажифнс("Testing nested contexts");
    КонтекстСтэка a, b, c;
    
    цел t0 = 0;
    цел t1 = 0;
    цел t2 = 0;
    
    a = new КонтекстСтэка(
    delegate проц()
    {
        
        t0++;
        b.пуск();
        
    });
    
    b = new КонтекстСтэка(
    delegate проц()
    {
        assert(t0 == 1);
        assert(t1 == 0);
        assert(t2 == 0);
        
        t1++;
        c.пуск();
        
    });
    
    c = new КонтекстСтэка(
    delegate проц()
    {
        assert(t0 == 1);
        assert(t1 == 1);
        assert(t2 == 0);
        
        t2++;
    });
    
    assert(a);
    assert(b);
    assert(c);
    assert(t0 == 0);
    assert(t1 == 0);
    assert(t2 == 0);
    
    a.пуск();
    
    assert(t0 == 1);
    assert(t1 == 1);
    assert(t2 == 1);
    
    assert(a);
    assert(b);
    assert(c);
    
    delete a;
    delete b;
    delete c;
    
    скажифнс("Nesting contexts passed");
}

unittest
{
	скажифнс("Testing basic exceptions");


	цел t0 = 0;
	цел t1 = 0;
	цел t2 = 0;

	assert(t0 == 0);
	assert(t1 == 0);
	assert(t2 == 0);

	try
	{

		try
		{
			throw new Исключение("Testing");
			t2++;
		}
		catch(Исключение fx)
		{
			t1++;
			throw fx;
		}
	
		t2++;
	}
	catch(Исключение ex)
	{
		t0++;
		ex.print;
	}

	assert(t0 == 1);
	assert(t1 == 1);
	assert(t2 == 0);

	скажифнс("Basic exceptions are supported");
}


//Anonymous delegates are slightly broken on linux. Don't пуск this test yet,
//since dmd will break it.
version(Win32)
unittest
{
    скажифнс("Testing exceptions");
    КонтекстСтэка a, b, c;
    
    цел t0 = 0;
    цел t1 = 0;
    цел t2 = 0;
    
    скажифнс("t0 = %s\nt1 = %s\nt2 = %s", t0, t1, t2);
    
    a = new КонтекстСтэка(
    delegate проц()
    {
        t0++;
        throw new Исключение("A exception");
        t0++;
    });
    
    b = new КонтекстСтэка(
    delegate проц()
    {
        t1++;
        c.пуск();
        t1++;
    });
    
    c = new КонтекстСтэка(
    delegate проц()
    {
        t2++;
        throw new Исключение("C exception");
        t2++;
    });
    
    assert(a);
    assert(b);
    assert(c);
    assert(t0 == 0);
    assert(t1 == 0);
    assert(t2 == 0);
    
    try
    {
        a.пуск();
        assert(false);
    }
    catch(Исключение e)
    {
        e.print;
    }
    
    assert(a);
    assert(a.дайСостояние == ПСостояниеКонтекста.Завершён);
    assert(b);
    assert(c);
    assert(t0 == 1);
    assert(t1 == 0);
    assert(t2 == 0);
    
    try
    {
        b.пуск();
        assert(false);
    }
    catch(Исключение e)
    {
        e.print;
    }
    
    скажифнс("blah2");
    
    assert(a);
    assert(b);
    assert(b.дайСостояние == ПСостояниеКонтекста.Завершён);
    assert(c);
    assert(c.дайСостояние == ПСостояниеКонтекста.Завершён);
    assert(t0 == 1);
    assert(t1 == 1);
    assert(t2 == 1);

	delete a;
	delete b;
	delete c;
    

	КонтекстСтэка t;
	цел q0 = 0;
	цел q1 = 0;

	t = new КонтекстСтэка(
	delegate проц()
	{
		try
		{
			q0++;
			throw new Исключение("T exception");
			q0++;
		}
		catch(Исключение ex)
		{
			q1++;
			скажифнс("!!!!!!!!GOT EXCEPTION!!!!!!!!");
			ex.print;
		}
	});


	assert(t);
	assert(q0 == 0);
	assert(q1 == 0);
	t.пуск();
	assert(t);
	assert(t.завершён);
	assert(q0 == 1);
	assert(q1 == 1);

	delete t;
   
    КонтекстСтэка d, e;
    цел s0 = 0;
    цел s1 = 0;
    
    d = new КонтекстСтэка(
    delegate проц()
    {
        try
        {
            s0++;
            e.пуск();
            КонтекстСтэка.жни();
            s0++;
            e.пуск();
            s0++;
        }
        catch(Исключение ex)
        {
            ex.print;
        }
    });
    
    e = new КонтекстСтэка(
    delegate проц()
    {
        s1++;
        КонтекстСтэка.жни();
        throw new Исключение("Е exception");
        s1++;
    });
    
    assert(d);
    assert(e);
    assert(s0 == 0);
    assert(s1 == 0);
    
    auxd.пуск();
    
    assert(d);
    assert(e);
    assert(s0 == 1);
    assert(s1 == 1);
    
    auxd.пуск();
    
    assert(d);
    assert(e);
    assert(s0 == 2);
    assert(s1 == 1);
    
    assert(auxd.завершён);
    assert(e.завершён);
    
    delete d;
    delete e;
    
    скажифнс("Exceptions passed");
}

unittest
{
    скажифнс("Testing reset");
    цел t0 = 0;
    цел t1 = 0;
    цел t2 = 0;
    
    КонтекстСтэка a = new КонтекстСтэка(
    delegate проц()
    {
        t0++;
        КонтекстСтэка.жни();
        t1++;
        КонтекстСтэка.жни();
        t2++;
    });
    
    assert(a);
    assert(t0 == 0);
    assert(t1 == 0);
    assert(t2 == 0);
    
    a.пуск();
    assert(a);
    assert(t0 == 1);
    assert(t1 == 0);
    assert(t2 == 0);
    
    a.пуск();
    assert(a);
    assert(t0 == 1);
    assert(t1 == 1);
    assert(t2 == 0);
    
    a.пуск();
    assert(a);
    assert(t0 == 1);
    assert(t1 == 1);
    assert(t2 == 1);
    
    a.перезапуск();
    assert(a);
    assert(t0 == 1);
    assert(t1 == 1);
    assert(t2 == 1);
    
    a.пуск();
    assert(a);
    assert(t0 == 2);
    assert(t1 == 1);
    assert(t2 == 1);
    
    a.перезапуск();
    a.пуск();
    assert(a);
    assert(t0 == 3);
    assert(t1 == 1);
    assert(t2 == 1);
    
    a.пуск();
    assert(a);
    assert(t0 == 3);
    assert(t1 == 2);
    assert(t2 == 1);
    
    a.перезапуск();
    a.пуск();
    assert(a);
    assert(t0 == 4);
    assert(t1 == 2);
    assert(t2 == 1);
    
    delete a;
    
    скажифнс("Reset passed");
}

//Same problem as above.  
version (Win32)
unittest
{
    скажифнс("Testing standard exceptions");
    цел t = 0;
    
    КонтекстСтэка a = new КонтекстСтэка(
    delegate проц()
    {
        бцел * tmp = пусто;
        
        *tmp = 0xbadc0de;
        
        t++;
    });
    
    assert(a);
    assert(t == 0);
    
    try
    {
        a.пуск();
        assert(false);
    }
    catch(Исключение e)
    {
        e.print();
    }
    
    assert(a);
    assert(a.завершён);
    assert(t == 0);
    
    delete a;
    
    
    скажифнс("Standard exceptions passed");
}

unittest
{
    скажифнс("Memory stress test");
    
    const бцел STRESS_SIZE = 5000;
    
    КонтекстСтэка конткст[];
    конткст.length = STRESS_SIZE;
    
    цел cnt0 = 0;
    цел cnt1 = 0;
    
    проц threadFunc()
    {
        cnt0++;
        КонтекстСтэка.жни;
        cnt1++;
    }
    
    foreach(inout КонтекстСтэка c; конткст)
    {
        c = new КонтекстСтэка(&threadFunc, МИН_РАЗМЕР_СТЕКА);
    }
    
    assert(cnt0 == 0);
    assert(cnt1 == 0);
    
    foreach(inout КонтекстСтэка c; конткст)
    {
        c.пуск;
    }
    
    assert(cnt0 == STRESS_SIZE);
    assert(cnt1 == 0);
    
    foreach(inout КонтекстСтэка c; конткст)
    {
        c.пуск;
    }
    
    assert(cnt0 == STRESS_SIZE);
    assert(cnt1 == STRESS_SIZE);
    
    foreach(inout КонтекстСтэка c; конткст)
    {
        delete c;
    }
    
    assert(cnt0 == STRESS_SIZE);
    assert(cnt1 == STRESS_SIZE);
    
    скажифнс("Memory stress test passed");
}

unittest
{
    скажифнс("Testing floating point");
    
    float f0 = 1.0;
    float f1 = 0.0;
    
    double d0 = 2.0;
    double d1 = 0.0;
    
    real r0 = 3.0;
    real r1 = 0.0;
    
    assert(f0 == 1.0);
    assert(f1 == 0.0);
    assert(d0 == 2.0);
    assert(d1 == 0.0);
    assert(r0 == 3.0);
    assert(r1 == 0.0);
    
    КонтекстСтэка a, b, c;
    
    a = new КонтекстСтэка(
    delegate проц()
    {
        while(true)
        {
            f0 ++;
            d0 ++;
            r0 ++;
            
            КонтекстСтэка.жни();
        }
    });
    
    b = new КонтекстСтэка(
    delegate проц()
    {
        while(true)
        {
            f1 = d0 + r0;
            d1 = f0 + r0;
            r1 = f0 + d0;
            
            КонтекстСтэка.жни();
        }
    });
    
    c = new КонтекстСтэка(
    delegate проц()
    {
        while(true)
        {
            f0 *= d1;
            d0 *= r1;
            r0 *= f1;
            
            КонтекстСтэка.жни();
        }
    });
    
    a.пуск();
    assert(f0 == 2.0);
    assert(f1 == 0.0);
    assert(d0 == 3.0);
    assert(d1 == 0.0);
    assert(r0 == 4.0);
    assert(r1 == 0.0);
    
    b.пуск();
    assert(f0 == 2.0);
    assert(f1 == 7.0);
    assert(d0 == 3.0);
    assert(d1 == 6.0);
    assert(r0 == 4.0);
    assert(r1 == 5.0);
    
    c.пуск();
    assert(f0 == 12.0);
    assert(f1 == 7.0);
    assert(d0 == 15.0);
    assert(d1 == 6.0);
    assert(r0 == 28.0);
    assert(r1 == 5.0);
    
    a.пуск();
    assert(f0 == 13.0);
    assert(f1 == 7.0);
    assert(d0 == 16.0);
    assert(d1 == 6.0);
    assert(r0 == 29.0);
    assert(r1 == 5.0);
    
    скажифнс("Floating point passed");
}


version(x86) unittest
{
    скажифнс("Testing registers");
    
    struct registers
    {
        цел eax, ebx, ecx, edx;
        цел esi, edi;
        цел ebp, esp;
        
        //TODO: Add fpu stuff
    }
    
    static registers old;
    static registers next;
    static registers g_old;
    static registers g_next;
    
    //I believe that D calling convention требует that
    //EBX, ESI и EDI be saveauxd.  In order to validate
    //this, we пиши to those registers и call the
    //стэк threaauxd.
    static СтэкНить reg_test = new СтэкНить(
    delegate проц() 
    {
        asm
        {
            naked;
            
            pushad;
            
            mov EBX, 1;
            mov ESI, 2;
            mov EDI, 3;
            
            mov [old.ebx], EBX;
            mov [old.esi], ESI;
            mov [old.edi], EDI;
            mov [old.ebp], EBP;
            mov [old.esp], ESP;
            
            call СтэкThreaauxd.жни;
            
            mov [next.ebx], EBX;
            mov [next.esi], ESI;
            mov [next.edi], EDI;
            mov [next.ebp], EBP;
            mov [next.esp], ESP;
            
            popad;
        }
    });
    
    //Run the стэк контекст
    asm
    {
        naked;
        
        pushad;
        
        mov EBX, 10;
        mov ESI, 11;
        mov EDI, 12;
        
        mov [g_old.ebx], EBX;
        mov [g_old.esi], ESI;
        mov [g_old.edi], EDI;
        mov [g_old.ebp], EBP;
        mov [g_old.esp], ESP;
        
        mov EAX, [reg_test];
        call СтэкThreaauxd.пуск;
        
        mov [g_next.ebx], EBX;
        mov [g_next.esi], ESI;
        mov [g_next.edi], EDI;
        mov [g_next.ebp], EBP;
        mov [g_next.esp], ESP;
        
        popad;
    }
    
    
    //Make sure the registers are byte for byte equal.
    assert(old.ebx = 1);
    assert(old.esi = 2);
    assert(old.edi = 3);
    assert(old == next);
    
    assert(g_old.ebx = 10);
    assert(g_old.esi = 11);
    assert(g_old.edi = 12);
    assert(g_old == g_next);
    
    скажифнс("Registers passed!");
}


unittest
{
    скажифнс("Testing бросьЖни");
    
    цел q0 = 0;
    
    КонтекстСтэка st0 = new КонтекстСтэка(
    delegate проц()
    {
        q0++;
        КонтекстСтэка.бросьЖни(new Исключение("testing throw жни"));
        q0++;
    });
    
    try
    {
        st0.пуск();
        assert(false);
    }
    catch(Исключение e)
    {
        e.print();
    }
    
    assert(q0 == 1);
    assert(st0.готов);
    
    st0.пуск();
    assert(q0 == 2);
    assert(st0.завершён);
    
    скажифнс("бросьЖни passed!");
}

unittest
{
    скажифнс("Testing thread safety");
    
    цел x = 0, y = 0;
    
    КонтекстСтэка sc0 = new КонтекстСтэка(
	delegate проц()
    {
        while(true)
        {
            x++;
            КонтекстСтэка.жни;
        }
    });
    
    КонтекстСтэка sc1 = new КонтекстСтэка(
	delegate проц()
    {
        while(true)
        {
            y++;
            КонтекстСтэка.жни;
        }
    });
    
    Нить t0 = new Нить(
    {
        for(цел i=0; i<10000; i++)
            sc0.пуск();
        
        return 0;
    });
    
    Нить t1 = new Нить(
    {
        for(цел i=0; i<10000; i++)
            sc1.пуск();
        
        return 0;
    });
    
    assert(sc0);
    assert(sc1);
    assert(t0);
    assert(t1);
    
    t0.start;
    t1.start;
    t0.wait;
    t1.wait;
    
    assert(x == 10000);
    assert(y == 10000);
    
    скажифнс("Нить safety passed!");
}

