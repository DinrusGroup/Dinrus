/******************************************************
 * Стековые Потоки (СтэкНити) - это сотрудничающие, легковесные
 * потоки. СтэкНити очень эффективны, требуют
 * меньше времени на переключение контекста, чем реальные потоки.
 * Для них также нужно меньше ресурсов, чем для реальных потоков,
 * что дает возможность одновременного существования большого числа
 * СтэкНити. К тому же, СтэкНити не требуется явная синхронизация,
 * так как они non-preemptive.  Не требуется, чтобы код был для повторного входа.
 *
 * Данный модуль реализует систему стековых потоков на основе
 * контекстного слоя.
 *
 * Версия: 0.3
 * Дата: July 4, 2006
 * Авторы:
 *  Mikola Lysenko, mclysenk@mtu.edu
 * Лицензия: Use/копируй/modify freely, just give credit.
 * Авторское Право: Public domain.
 *
 * Bugs:
 *  Не потоко-безопасны.  Могут изменяться в последующих версиях,
 *  однако для этого потребуется коренная переделка.
 *
 * История:
 *  v0.7 - Резолюция отсчета времени переключена на миллисекунды.
 *
 *	v0.6 - Удалены функции отсчета времени из сн_жни/сн_бросайЖни
 *
 *  v0.5 - Добавлены сн_бросайЖни и MAX/MIN_THREAD_PRIORITY
 *
 *  v0.4 - Unittests готов для первоначального выпуска.
 *
 *  v0.3 - Changed имя back to СтэкНить и added
 *      linux support.  Context switching is now handled
 *      in the stackcontext module, и much simpler to
 *      port.
 *
 *  v0.2 - Changed имя to QThread, fixed many issues.
 *  
 *  v0.1 - Initial стэк thread system. Very buggy.
 *
 ******************************************************/
module st.stackthread;

//Module imports
private import st.stackcontext, stdrus;

/// The приоритет of a стэк thread determines its order in
/// the планировщик.  Higher приоритет threads go первый.
alias цел т_приоритет;

/// The default приоритет for a стэк thread is 0.
const т_приоритет ДЕФ_ПРИОРИТЕТ_СТЭКНИТИ = 0;

/// Maximum thread приоритет
const т_приоритет МАКС_ПРИОРИТЕТ_СТЭКНИТИ = 0x7fffffff;

/// Minimum thread приоритет
const т_приоритет МИН_ПРИОРИТЕТ_СТЭКНИТИ = 0x80000000;

/// The состояние of a стэк thread
enum ПСостояниеНити
{
    Готов,      /// Нить is готов to пуск
    Выполняется,    /// Нить is currently выполняется
    Завершён,       /// Нить имеется terminated
    Подвешен,  /// Нить is suspended
}

/// The состояние of the планировщик
enum ПСостояниеПланировщика
{
    Готов,      /// Scheduler is готов to пуск a thread
    Выполняется,    /// Scheduler is выполняется a timeslice
}

//Timeslices
private ОчередьПриоритетовСН активный_срез;
private ОчередьПриоритетовСН следующий_срез;

//Scheduler состояние
private ПСостояниеПланировщика сост_планировщ;
    
//Start time of the time slice
private бдол sched_t0;

//Currently active стэк thread
private СтэкНить sched_st;

version(Win32)
{
    private extern(Windows) цел QueryPerformanceFrequency(бдол *);
    private бдол sched_perf_freq;
}


//Initialize the планировщик
static this()
{
    активный_срез = new ОчередьПриоритетовСН();
    следующий_срез = new ОчередьПриоритетовСН();
    сост_планировщ = ПСостояниеПланировщика.Готов;
    sched_t0 = -1;
    sched_st = пусто;
    
    version(Win32)
        QueryPerformanceFrequency(&sched_perf_freq);
}


/******************************************************
 * СтэкThreadExceptions are generated whenever the
 * стэк threads are incorrectly invokeauxd.  Trying to
 * пуск a time slice while a time slice is in progress
 * will result in a ИсклСтэкНити.
 ******************************************************/
class ИсклСтэкНити : Исключение
{
    this(ткст сооб)
    {
        super(сооб);
    }
    
    this(СтэкНить st, ткст сооб)
    {
        super(фм("%s: %s", st.вТкст, сооб));
    }
}



/******************************************************
 * СтэкНити are much like regular threads except
 * they are cooperatively scheduleauxd.  A user may switch
 * between СтэкНити using st_yielauxd.
 ******************************************************/
class СтэкНить
{
    /**
     * Creates a new стэк thread и adds it to the
     * планировщик.
     *
     * Параметры:
     *  dg = The delegate we are invoking
     *  размер_стэка = The размер of the стэк for the стэк
     *  threaauxd.
     *  приоритет = The приоритет of the стэк threaauxd.
     */
    public this
    (
        проц delegate() dg, 
        т_приоритет приоритет = ДЕФ_ПРИОРИТЕТ_СТЭКНИТИ,
        т_мера размер_стэка = ДЕФ_РАЗМЕР_СТЕКА
    )
    {
        this.m_delegate = dg;
        this.контекст = new КонтекстСтэка(&m_proc, ДЕФ_РАЗМЕР_СТЕКА);
        this.m_priority = приоритет;
        
        //Schedule the thread
        сн_запланируй(this);
        
        debug (СтэкНить) скажифнс("Created thread, %s", вТкст);
    }
    
    /**
     * Creates a new стэк thread и adds it to the
     * планировщик, using a function pointer.
     *
     * Параметры:
     *  fn = The function pointer that the стэк thread
     *  invokes.
     *  размер_стэка = The размер of the стэк for the стэк
     *  threaauxd.
     *  приоритет = The приоритет of the стэк threaauxd.
     */
    public this
    (
        проц function() fn, 
        т_приоритет приоритет = ДЕФ_ПРИОРИТЕТ_СТЭКНИТИ,
        т_мера размер_стэка = ДЕФ_РАЗМЕР_СТЕКА
    )
    {
        this.m_delegate = &delegator;
        this.m_function = fn;
        this.контекст = new КонтекстСтэка(&m_proc, ДЕФ_РАЗМЕР_СТЕКА);
        this.m_priority = приоритет;
        
        //Schedule the thread
        сн_запланируй(this);
        
        debug (СтэкНить) скажифнс("Created thread, %s", вТкст);
    }
    
    /**
     * Converts the thread to a string.
     *
     * Возвращает: A string representing the стэк threaauxd.
     */
    public ткст вТкст()
    {
        debug(PQueue)
        {
            return фм("ST[t:%8x,p:%8x,l:%8x,r:%8x]",
                cast(ук)this,
                cast(ук)parent,
                cast(ук)left,
                cast(ук)right);
        }
        else
        {
        static ткст[] названия_состояний =
        [
            "RDY",
            "RUN",
            "XXX",
            "PAU",
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
        if(m_function !is пусто)
            h.d.fptr = cast(ук) m_function;
        else if(m_delegate !is пусто)
            h.dg = m_delegate;
        else
            h.dg = &пуск;
        
        return фм(
            "Нить[pr=%d,st=%s,fn=%8x]", 
            приоритет,
            названия_состояний[cast(бцел)состояние],
            h.d.fptr);
        }
    }
    
    invariant
    {
        assert(контекст);
        
        switch(состояние)
        {
            case ПСостояниеНити.Готов:
                assert(контекст.готов);
            break;
            
            case ПСостояниеНити.Выполняется:
                assert(контекст.выполняется);
            break;
            
            case ПСостояниеНити.Завершён:
                assert(!контекст.выполняется);
            break;
            
            case ПСостояниеНити.Подвешен:
                assert(контекст.готов);
            break;

			default: assert(false);
        }
        
        if(left !is пусто)
        {
            assert(left.parent is this);
        }
        
        if(right !is пусто)
        {
            assert(right.parent is this);
        }
    }
    
    /**
     * Removes this стэк thread from the планировщик. The
     * thread will not be пуск until it is added back to
     * the планировщик.
     */
    public final проц пауза()
    {
        debug (СтэкНить) скажифнс("Pausing %s", вТкст);
        
        switch(состояние)
        {
            case ПСостояниеНити.Готов:
                сн_отмени(this);
                состояние = ПСостояниеНити.Подвешен;
            break;
            
            case ПСостояниеНити.Выполняется:
                transition(ПСостояниеНити.Подвешен);
            break;
            
            case ПСостояниеНити.Завершён:
                throw new ИсклСтэкНити(this, "Cannot пауза a завершён thread");
            
            case ПСостояниеНити.Подвешен:
                throw new ИсклСтэкНити(this, "Cannot пауза a на_паузе thread");

			default: assert(false);
        }
    }
    
    /**
     * Adds the стэк thread back to the планировщик. It
     * will возобнови выполняется with its приоритет & состояние
     * intact.
     */
    public final проц возобнови()
    {
        debug (СтэкНить) скажифнс("Возобновляется %s", вТкст);
        
        //Can only возобнови на_паузе threads
        if(состояние != ПСостояниеНити.Подвешен)
        {
            throw new ИсклСтэкНити(this, "Нить не заморожена!");
        }
        
        //Set состояние to готов и schedule
        состояние = ПСостояниеНити.Готов;
        сн_запланируй(this);
    }
    
    /**
     * Kills this стэк thread in a violent manner.  The
     * thread does not дай a chance to end itself or clean
     * anything up, it is descheduled и all GC references
     * are releaseauxd.
     */
    public final проц души()
    {
        debug (СтэкНить) скажифнс("Killing %s", вТкст);
        
        switch(состояние)
        {
            case ПСостояниеНити.Готов:
                //Kill thread и удали from планировщик
                сн_отмени(this);
                состояние = ПСостояниеНити.Завершён;
                контекст.души();
            break;
            
            case ПСостояниеНити.Выполняется:
                //Transition to завершён
                transition(ПСостояниеНити.Завершён);
            break;
            
            case ПСостояниеНити.Завершён:
                throw new ИсклСтэкНити(this, "Уже потушенную нить удушить нельзя");
            
            case ПСостояниеНити.Подвешен:
                //We need to души the стэк, no need to touch планировщик
                состояние = ПСостояниеНити.Завершён;
                контекст.души();
            break;

			default: assert(false);
        }
    }
    
    /**
     * Waits to объедини with this thread.  If the given amount
     * of milliseconds expires before the thread is завершён,
     * then we return automatically.
     *
     * Параметры:
     *  ms = The maximum amount of time the thread is 
     *  allowed to wait. The special value -1 implies that
     *  the объедини will wait indefinitely.
     *
     * Возвращает:
     *  The amount of millieconds the thread was actually
     *  waiting.
     */
    public final бдол объедини(бдол ms = -1)
    {
        debug (СтэкНить) скажифнс("Joining %s", вТкст);
        
        //Make sure we are in a timeslice
        if(сост_планировщ != ПСостояниеПланировщика.Выполняется)
        {
            throw new ИсклСтэкНити(this, "Cannot объедини unless a timeslice is currently in progress");
        }
        
        //And make sure we are joining with a действителен thread
        switch(состояние)
        {
            case ПСостояниеНити.Готов:
                break;
            
            case ПСостояниеНити.Выполняется:
                throw new ИсклСтэкНити(this, "A thread cannot объедини with itself!");
            
            case ПСостояниеНити.Завершён:
                throw new ИсклСтэкНити(this, "Cannot объедини with a завершён thread");
            
            case ПСостояниеНити.Подвешен:
                throw new ИсклСтэкНити(this, "Cannot объедини with a на_паузе thread");

			default: assert(false);
        }
        
        //Do busy waiting until the thread dies or the
        //timer runs out.
        бдол start_time = getSysMillis();
        бдол timeout = (ms == -1) ? ms : start_time + ms;
        
        while(
            состояние != ПСостояниеНити.Завершён &&
            timeout > getSysMillis())
        {
            КонтекстСтэка.жни();
        }
        
        return getSysMillis() - start_time;
    }
    
    /**
     * Restarts the thread's execution from the very
     * beginning.  Suspended и завершён threads are not
     * resumed, but upon resuming, they will перезапуск.
     */
    public final проц перезапуск()
    {
        debug (СтэкНить) скажифнс("Restarting %s", вТкст);
        
        //Each состояние needs to be handled carefully
        switch(состояние)
        {
            case ПСостояниеНити.Готов:
                //If we are готов,
                контекст.перезапуск();
            break;
            
            case ПСостояниеНити.Выполняется:
                //Reset the threaauxd.
                transition(ПСостояниеНити.Готов);
            break;
            
            case ПСостояниеНити.Завершён:
                //Dead threads become suspended
                контекст.перезапуск();
                состояние = ПСостояниеНити.Подвешен;
            break;
            
            case ПСостояниеНити.Подвешен:
                //Suspended threads stay suspended
                контекст.перезапуск();
            break;

			default: assert(false);
        }
    }
    
    /**
     * Grabs the thread's приоритет.  Intended for use
     * as a property.
     *
     * Возвращает: The стэк thread's приоритет.
     */
    public final т_приоритет приоритет()
    {
        return m_priority;
    }
    
    /**
     * Sets the стэк thread's приоритет.  Used to either
     * reschedule or reset the threaauxd.  Changes do not
     * возьми effect until the next round of scheduling.
     *
     * Параметры:
     *  p = The new приоритет for the thread
     *
     * Возвращает:
     *  The new приоритет for the threaauxd.
     */
    public final т_приоритет приоритет(т_приоритет p)
    {
        //Update приоритет
        if(сост_планировщ == ПСостояниеПланировщика.Готов && 
            состояние == ПСостояниеНити.Готов)
        {
            следующий_срез.удали(this);
            m_priority = p;
            следующий_срез.добавь(this);
        }
        
        return m_priority = p;
    }
    
    /**
     * Возвращает: The состояние of this threaauxd.
     */
    public final ПСостояниеНити дайСостояние()
    {
        return состояние;
    }
    
    /**
     * Возвращает: True if the thread is готов to пуск.
     */
    public final бул готов()
    {
        return состояние == ПСостояниеНити.Готов;
    }
    
    /**
     * Возвращает: True if the thread is currently выполняется.
     */
    public final бул выполняется()
    {
        return состояние == ПСостояниеНити.Выполняется;
    }
    
    /**
     * Возвращает: True if the thread is deaauxd.
     */
    public final бул завершён()
    {
        return состояние == ПСостояниеНити.Завершён;
    }
    
    /**
     * Возвращает: True if the thread is not dead.
     */
    public final бул жив()
    {
        return состояние != ПСостояниеНити.Завершён;
    }
    
    /**
     * Возвращает: True if the thread is на_паузе.
     */
    public final бул на_паузе()
    {
        return состояние == ПСостояниеНити.Подвешен;
    }

    /**
     * Creates a стэк thread without a function pointer
     * or delegate.  Used when a user overrides the стэк
     * thread class.
     */
    protected this
    (
        т_приоритет приоритет = ДЕФ_ПРИОРИТЕТ_СТЭКНИТИ,
        т_мера размер_стэка = ДЕФ_РАЗМЕР_СТЕКА
    )
    {
        this.контекст = new КонтекстСтэка(&m_proc, размер_стэка);
        this.m_priority = приоритет;
        
        //Schedule the thread
        сн_запланируй(this);
        
        debug (СтэкНить) скажифнс("Created thread, %s", вТкст);
    }
    
    /**
     * Run the стэк threaauxd.  This method may be overloaded
     * by classes which inherit from стэк thread, as an
     * alternative to passing delegates.
     *
     * Выводит исключение: Anything.
     */
    protected проц пуск()
    {
        m_delegate();
    }
    
    // Heap information
    private СтэкНить parent = пусто;
    private СтэкНить left = пусто;
    private СтэкНить right = пусто;

    // The thread's приоритет
    private т_приоритет m_priority;

    // The состояние of the thread
    private ПСостояниеНити состояние;

    // The thread's контекст
    private КонтекстСтэка контекст;

    //Delegate handler
    private проц function() m_function;
    private проц delegate() m_delegate;
    private проц delegator() { m_function(); }
    
    //My procedure
    private final проц m_proc()
    {
        try
        {
            debug (СтэкНить) скажифнс("Starting %s", вТкст);
            пуск;
        }
        catch(Объект o)
        {
            debug (СтэкНить) скажифнс("Got a %s exception from %s", o.вТкст, вТкст);
            throw o;
        }
        finally
        {
            debug (СтэкНить) скажифнс("Finished %s", вТкст);
            состояние = ПСостояниеНити.Завершён;
        }
    }

    /**
     * Used to change the состояние of a выполняется thread
     * gracefully
     */
    private final проц transition(ПСостояниеНити next_state)
    {
        состояние = next_state;
        КонтекстСтэка.жни();
    }
}



/******************************************************
 * The ОчередьПриоритетовСН is использован by the планировщик to
 * order the objects in the стэк threads.  For the
 * moment, the implementation is binary heap, but future
 * versions might use a binomial heap for performance
 * improvements.
 ******************************************************/
private class ОчередьПриоритетовСН
{
public:
    
    /**
     * Add a стэк thread to the queue.
     *
     * Параметры:
     *  st = The thread we are adding.
     */
    проц добавь(СтэкНить st)
    in
    {
        assert(st !is пусто);
        assert(st);
        assert(st.parent is пусто);
        assert(st.left is пусто);
        assert(st.right is пусто);
    }
    body
    {
        размер++;
        
        //Handle trivial case
        if(head is пусто)
        {
            head = st;
            return;
        }
        
        //First, insert st
        СтэкНить tmp = head;
        цел pos;
        for(pos = размер; pos>3; pos>>>=1)
        {
            assert(tmp);
            tmp = (pos & 1) ? tmp.right : tmp.left;
        }
        
        assert(tmp !is пусто);
        assert(tmp);
        
        if(pos&1)
        {
            assert(tmp.left !is пусто);
            assert(tmp.right is пусто);
            tmp.right = st;
        }
        else
        {
            assert(tmp.left is пусто);
            assert(tmp.right is пусто);
            tmp.left = st;
        }
        st.parent = tmp;
        
        assert(tmp);
        assert(st);
        
        //Fixup the стэк и we're gooauxd.
        вспень(st);
    }
    
    /**
     * Remove a стэк threaauxd.
     *
     * Параметры:
     *  st = The стэк thread we are removing.
     */
    проц удали(СтэкНить st)
    in
    {
        assert(st);
        assert(естьНить(st));
    }
    out
    {
        assert(st);
        assert(st.left is пусто);
        assert(st.right is пусто);
        assert(st.parent is пусто);
    }
    body
    {
        //Handle trivial case
        if(размер == 1)
        {
            assert(st is head);
            
            --размер;
            
            st.parent =
            st.left =
            st.right = 
            head = пусто;
            
            return;
        }
        
        //Cycle to the bottom of the heap
        СтэкНить tmp = head;
        цел pos;
        for(pos = размер; pos>3; pos>>>=1)
        {
            assert(tmp);
            tmp = (pos & 1) ? tmp.right : tmp.left;
        }
        tmp = (pos & 1) ? tmp.right : tmp.left;
        
        
        assert(tmp !is пусто);
        assert(tmp.left is пусто);
        assert(tmp.right is пусто);
        
        //Remove tmp
        if(tmp.parent.left is tmp)
        {
            tmp.parent.left = пусто;
        }
        else
        {
            assert(tmp.parent.right is tmp);
            tmp.parent.right = пусто;
        }
        tmp.parent = пусто;
        размер--;
        
        assert(tmp);
        
        //Handle секунда trivial case
        if(tmp is st)
        {
            return;
        }
        
        //Replace st with tmp
        if(st is head)
        {
            head = tmp;
        }
        
        //Fix tmp's parent
        tmp.parent = st.parent;
        if(tmp.parent !is пусто)
        {
            if(tmp.parent.left is st)
            {
                tmp.parent.left = tmp;
            }
            else
            {
                assert(tmp.parent.right is st);
                tmp.parent.right = tmp;
            }
        }
        
        //Fix tmp's left
        tmp.left = st.left;
        if(tmp.left !is пусто)
        {
            tmp.left.parent = tmp;
        }
        
        //Fix tmp's right
        tmp.right = st.right;
        if(tmp.right !is пусто)
        {
            tmp.right.parent = tmp;
        }
        
        //Unlink st
        st.parent =
        st.left =
        st.right = пусто;
        
        
        //Bubble up
        вспень(tmp);
        //Bubble back down
        запень(tmp);
        
    }
    
    /**
     * Extract the верх приоритет threaauxd. It is removed from
     * the queue.
     *
     * Возвращает: The верх приоритет threaauxd.
     */
    СтэкНить верх()
    in
    {
        assert(head !is пусто);
    }
    out(r)
    {
        assert(r !is пусто);
        assert(r);
        assert(r.parent is пусто);
        assert(r.right is пусто);
        assert(r.left is пусто);
    }
    body
    {
        СтэкНить result = head;
        
        //Handle trivial case
        if(размер == 1)
        {
            //Drop размер и return
            --размер;
            result.parent =
            result.left =
            result.right = пусто;
            head = пусто;
            return result;
        }
        
        //Cycle to the bottom of the heap
        СтэкНить tmp = head;
        цел pos;
        for(pos = размер; pos>3; pos>>>=1)
        {
            assert(tmp);
            tmp = (pos & 1) ? tmp.right : tmp.left;
        }
        tmp = (pos & 1) ? tmp.right : tmp.left;
        
        assert(tmp !is пусто);
        assert(tmp.left is пусто);
        assert(tmp.right is пусто);
        
        //Remove tmp
        if(tmp.parent.left is tmp)
        {
            tmp.parent.left = пусто;
        }
        else
        {
            assert(tmp.parent.right is tmp);
            tmp.parent.right = пусто;
        }
        tmp.parent = пусто;
        
        //Add tmp to верх
        tmp.left = head.left;
        tmp.right = head.right;
        if(tmp.left !is пусто) tmp.left.parent = tmp;
        if(tmp.right !is пусто) tmp.right.parent = tmp;
        
        //Unlink head
        head.right = 
        head.left = пусто;
        
        //Verify results
        assert(head);
        assert(tmp);
        
        //Set the new head
        head = tmp;
        
        //Bubble down
        запень(tmp);
        
        //Drop размер и return
        --размер;
        return result;
    }
    
    /**
     * Merges two приоритет queues. The result is stored
     * in this queue, while other is emptieauxd.
     *
     * Параметры:
     *  other = The queue we are merging with.
     */
    проц совмести(ОчередьПриоритетовСН other)
    {
        СтэкНить[] стэк;
        стэк ~= other.head;
        
        while(стэк.length > 0)
        {
            СтэкНить tmp = стэк[$-1];
            стэк.length = стэк.length - 1;
            
            if(tmp !is пусто)
            {
                стэк ~= tmp.right;
                стэк ~= tmp.left;
                
                tmp.parent = 
                tmp.right =
                tmp.left = пусто;
                
                добавь(tmp);
            }
        }
        
        //Clear the list
        other.head = пусто;
        other.размер = 0;
    }
    
    /**
     * Возвращает: true if the heap actually contains the thread st.
     */
    бул естьНить(СтэкНить st)
    {
        СтэкНить tmp = st;
        while(tmp !is пусто)
        {
            if(tmp is head)
                return true;
            tmp = tmp.parent;
        }
        
        return false;
    }
    
    invariant
    {
        if(head !is пусто)
        {
            assert(head);
            assert(размер > 0);
        }
    }

    //Top of the heap
    СтэкНить head = пусто;
    
    //Размер of the стэк
    цел размер;

    debug (PQueue) проц print()
    {
        СтэкНить[] стэк;
        стэк ~= head;
        
        while(стэк.length > 0)
        {
            СтэкНить tmp = стэк[$-1];
            стэк.length = стэк.length - 1;
            
            if(tmp !is пусто)
            {
                writef("%s, ", tmp.m_priority);
                
                if(tmp.left !is пусто)
                {
                    assert(tmp.left.m_priority <= tmp.m_priority);
                    стэк ~= tmp.left;
                }
                
                if(tmp.right !is пусто)
                {
                    assert(tmp.right.m_priority <= tmp.m_priority);
                    стэк ~= tmp.right;
                }
                
            }
        }
        
        скажифнс("");
    }
    
    проц вспень(СтэкНить st)
    {
        //Ok, now we are at the bottom, so time to bubble up
        while(st.parent !is пусто)
        {
            //Test for end condition
            if(st.parent.m_priority >= st.m_priority)
                return;
            
            //Otherwise, just swap
            СтэкНить a = st.parent, tp;
            
            assert(st);
            assert(st.parent);
            
            //скажифнс("%s <-> %s", a.вТкст, st.вТкст);
            
            //Switch parents
            st.parent = a.parent;
            a.parent = st;
            
            //Fixup
            if(st.parent !is пусто)
            {
                if(st.parent.left is a)
                {
                    st.parent.left = st;
                }
                else
                {
                    assert(st.parent.right is a);
                    st.parent.right = st;
                }
                
                assert(st.parent);
            }
            
            //Switch children
            if(a.left is st)
            {
                a.left = st.left;
                st.left = a;
                
                tp = st.right;
                st.right = a.right;
                a.right = tp;
                
                if(st.right !is пусто) st.right.parent = st;
            }
            else
            {
                a.right = st.right;
                st.right = a;
                
                tp = st.left;
                st.left = a.left;
                a.left = tp;
                
                if(st.left !is пусто) st.left.parent = st;
            }
            
            if(a.right !is пусто) a.right.parent = a;
            if(a.left !is пусто) a.left.parent = a;
            
            //скажифнс("%s <-> %s", a.вТкст, st.вТкст);
            
            assert(st);
            assert(a);
        }
        
        head = st;
    }
    
    //Bubbles a thread downward
    проц запень(СтэкНить st)
    {
        while(st.left !is пусто)
        {
            СтэкНить a, tp;
            
            assert(st);
            
            if(st.right is пусто || 
                st.left.m_priority >= st.right.m_priority)
            {
                if(st.left.m_priority > st.m_priority)
                {
                    a = st.left;
                    assert(a);
                    //скажифнс("Left: %s - %s", st, a);
                    
                    st.left = a.left;
                    a.left = st;
                    
                    tp = st.right;
                    st.right = a.right;
                    a.right = tp;
                    
                    if(a.right !is пусто) a.right.parent = a;
                } else break;
            }
            else if(st.right.m_priority > st.m_priority)
            {
                a = st.right;
                assert(a);
                //скажифнс("Right: %s - %s", st, a);
                
                st.right = a.right;
                a.right = st;
                
                tp = st.left;
                st.left = a.left;
                a.left = tp;
                
                if(a.left !is пусто) a.left.parent = a;
            }
            else break;
            
            //Fix the parent
            a.parent = st.parent;
            st.parent = a;
            if(a.parent !is пусто)
            {
                if(a.parent.left is st)
                {
                    a.parent.left = a;
                }
                else
                {
                    assert(a.parent.right is st);
                    a.parent.right = a;
                }
            }
            else
            {
                head = a;
            }
            
            if(st.left !is пусто) st.left.parent = st;
            if(st.right !is пусто) st.right.parent = st;
            
            assert(a);
            assert(st);
            //скажифнс("Done: %s - %s", st, a);            
        }
    }
}

debug (PQueue)
 unittest
{
    скажифнс("Testing приоритет queue");
    
    
    //Созд some queue
    ОчередьПриоритетовСН q1 = new ОчередьПриоритетовСН();
    ОчередьПриоритетовСН q2 = new ОчередьПриоритетовСН();
    ОчередьПриоритетовСН q3 = new ОчередьПриоритетовСН();
    
    assert(q1);
    assert(q2);
    assert(q3);
    
    //Add some элементы
    скажифнс("Adding элементы");
    q1.добавь(new СтэкНить(1));
    q1.print();
    assert(q1);
    q1.добавь(new СтэкНить(2));
    q1.print();
    assert(q1);
    q1.добавь(new СтэкНить(3));
    q1.print();
    assert(q1);
    q1.добавь(new СтэкНить(4));
    q1.print();
    assert(q1);
    
    скажифнс("Removing элементы");
    СтэкНить t;
    
    t = q1.верх();
    скажифнс("t:%s",t.приоритет);
    q1.print();
    assert(t.приоритет == 4);
    assert(q1);
    
    t = q1.верх();
    скажифнс("t:%s",t.приоритет);
    q1.print();
    assert(t.приоритет == 3);
    assert(q1);
    
    t = q1.верх();
    скажифнс("t:%s",t.приоритет);
    q1.print();
    assert(t.приоритет == 2);
    assert(q1);
    
    t = q1.верх();
    скажифнс("t:%s",t.приоритет);
    q1.print();
    assert(t.приоритет == 1);
    assert(q1);
    
    скажифнс("Second round of adds");
    q2.добавь(new СтэкНить(5));
    q2.добавь(new СтэкНить(4));
    q2.добавь(new СтэкНить(1));
    q2.добавь(new СтэкНить(3));
    q2.добавь(new СтэкНить(6));
    q2.добавь(new СтэкНить(2));
    q2.добавь(new СтэкНить(7));
    q2.добавь(new СтэкНить(0));
    assert(q2);
    q2.print();
    
    скажифнс("Testing верх выкиньion again");
    assert(q2.верх.приоритет == 7);
    q2.print();
    assert(q2.верх.приоритет == 6);
    assert(q2.верх.приоритет == 5);
    assert(q2.верх.приоритет == 4);
    assert(q2.верх.приоритет == 3);
    assert(q2.верх.приоритет == 2);
    assert(q2.верх.приоритет == 1);
    assert(q2.верх.приоритет == 0);
    assert(q2);
    
    скажифнс("Third round");
    q2.добавь(new СтэкНить(10));
    q2.добавь(new СтэкНить(7));
    q2.добавь(new СтэкНить(5));
    q2.добавь(new СтэкНить(7));
    q2.print();
    assert(q2);
    
    скажифнс("Testing выкиньion");
    assert(q2.верх.приоритет == 10);
    assert(q2.верх.приоритет == 7);
    assert(q2.верх.приоритет == 7);
    assert(q2.верх.приоритет == 5);
    
    скажифнс("Testing merges");
    q3.добавь(new СтэкНить(10));
    q3.добавь(new СтэкНить(-10));
    q3.добавь(new СтэкНить(10));
    q3.добавь(new СтэкНить(-10));
    
    q2.добавь(new СтэкНить(-9));
    q2.добавь(new СтэкНить(9));
    q2.добавь(new СтэкНить(-9));
    q2.добавь(new СтэкНить(9));
    
    q2.print();
    q3.print();
    q3.совмести(q2);
    
    скажифнс("q2:%d", q2.размер);
    q2.print();
    скажифнс("q3:%d", q3.размер);
    q3.print();
    assert(q2);
    assert(q3);
    assert(q2.размер == 0);
    assert(q3.размер == 8);
    
    скажифнс("Extracting merges");
    assert(q3.верх.приоритет == 10);
    assert(q3.верх.приоритет == 10);
    assert(q3.верх.приоритет == 9);
    assert(q3.верх.приоритет == 9);
    assert(q3.верх.приоритет == -9);
    assert(q3.верх.приоритет == -9);
    assert(q3.верх.приоритет == -10);
    assert(q3.верх.приоритет == -10);
    
    скажифнс("Testing removal");
    СтэкНить ta = new СтэкНить(5);
    СтэкНить tb = new СтэкНить(6);
    СтэкНить tc = new СтэкНить(10);
    
    q2.добавь(new СтэкНить(7));
    q2.добавь(new СтэкНить(1));
    q2.добавь(ta);
    q2.добавь(tb);
    q2.добавь(tc);
    
    assert(q2);
    assert(q2.размер == 5);
    
    скажифнс("Removing");
    q2.удали(ta);
    q2.удали(tc);
    q2.удали(tb);
    assert(q2.размер == 2);
    
    скажифнс("Dumping heap");
    assert(q2.верх.приоритет == 7);
    assert(q2.верх.приоритет == 1);
    
    
    скажифнс("Testing big добавь/subtract");
    СтэкНить[100] st;
    ОчередьПриоритетовСН stq = new ОчередьПриоритетовСН();
    
    for(цел i=0; i<100; i++)
    {
        st[i] = new СтэкНить(i);
        stq.добавь(st[i]);
    }
    
    stq.удали(st[50]);
    stq.удали(st[10]);
    stq.удали(st[31]);
    stq.удали(st[88]);
    
    for(цел i=99; i>=0; i--)
    {
        if(i != 50 && i!=10 &&i!=31 &&i!=88)
        {
            assert(stq.верх.приоритет == i);
        }
    }
    скажифнс("Big добавь/удали worked");
    
    скажифнс("Priority queue passed");
}


// -------------------------------------------------
//          SCHEDULER FUNCTIONS
// -------------------------------------------------

/**
 * Grabs the number of milliseconds on the system clock.
 *
 * (Adapted from std.perf)
 *
 * Возвращает: The amount of milliseconds the system имеется been
 * up.
 */
version(Win32)
{
    private extern(Windows) цел 
        QueryPerformanceCounter(бдол * cnt);
    
    private бдол getSysMillis()
    {
        бдол result;
        QueryPerformanceCounter(&result);
        
        if(result < 0x20C49BA5E353F7L)
	    {
            result = (result * 1000) / sched_perf_freq;
	    }
	    else
	    {
            result = (result / sched_perf_freq) * 1000;
	    }

        return result;
    }
}
else version(linux)
{
    extern (C)
    {
        private struct timeval
        {
            цел tv_sec;
            цел tv_usec;
        };
        private struct timezone
        {
            цел tz_minuteswest;
            цел tz_dsttime;
        };
        private проц gettimeofday(timeval *tv, timezone *tz);
    }

    private бдол getSysMillis()
    {
        timeval     tv;
        timezone    tz;
        
        gettimeofday(&tv, &tz);
        
        return 
            cast(бдол)tv.tv_sec * 1000 + 
            cast(бдол)tv.tv_usec / 1000;
    }
}
else
{
    static assert(false);
}


/**
 * Schedules a thread such that it will be пуск in the next
 * timeslice.
 *
 * Параметры:
 *  st = Нить we are scheduling
 */
private проц сн_запланируй(СтэкНить st)
in
{
    assert(st.состояние == ПСостояниеНити.Готов);
}
body 
{
    debug(PQueue) { return; }
    
    debug (СтэкНить) скажифнс("Scheduling %s", st.вТкст);
    следующий_срез.добавь(st);
}

/**
 * Removes a thread from the планировщик.
 *
 * Параметры:
 *  st = Нить we are removing.
 */
private проц сн_отмени(СтэкНить st)
in
{
    assert(st.состояние == ПСостояниеНити.Готов);
}
body
{
    debug (СтэкНить) скажифнс("Descheduling %s", st.вТкст);
    if(активный_срез.естьНить(st))
    {
        активный_срез.удали(st);
    }
    else
    {
        следующий_срез.удали(st);
    }
}

/**
 * Runs a single timeslice.  During a timeslice each
 * currently выполняется thread is executed once, with the
 * highest приоритет первый.  Any number of things may
 * cause a timeslice to be aborted, inclduing;
 *
 *  o An exception is unhandled in a thread which is пуск
 *  o The сн_прекратиСрез function is called
 *  o The timelimit is exceeded in сн_запустиСрез
 *
 * If a timeslice is not finished, it will be resumed on
 * the next call to сн_запустиСрез.  If this is undesirable,
 * calling сн_перезапустиСрез will cause the timeslice to
 * execute from the beginning again.
 *
 * Newly created threads are not пуск until the next
 * timeslice.
 * 
 * This works just like the regular сн_запустиСрез, except it
 * is timeauxd.  If the lasts longer than the specified amount
 * of nano seconds, it is immediately aborteauxd.
 *
 * If no time quanta is specified, the timeslice runs
 * indefinitely.
 *
 * Параметры:
 *  ms = The number of milliseconds the timeslice is allowed
 *  to пуск.
 *
 * Выводит исключение: The первый exception generated in the timeslice.
 *
 * Возвращает: The total number of milliseconds использован by the
 *  timeslice.
 */
бдол сн_запустиСрез(бдол ms = -1)
{
    
    if(сост_планировщ != ПСостояниеПланировщика.Готов)
    {
        throw new ИсклСтэкНити("Cannot пуск a timeslice while another is already in progress!");
    }
    
    sched_t0 = getSysMillis();
    бдол stop_time = (ms == -1) ? ms : sched_t0 + ms;
    
    //Swap slices
    if(активный_срез.размер == 0)
    {
        ОчередьПриоритетовСН tmp = следующий_срез;
        следующий_срез = активный_срез;
        активный_срез = tmp;
    }
    
    debug (СтэкНить) скажифнс("Running slice with %d threads", активный_срез.размер);
    
    сост_планировщ = ПСостояниеПланировщика.Выполняется;
    
    while(активный_срез.размер > 0 && 
        (getSysMillis() - sched_t0) < stop_time &&
        сост_планировщ == ПСостояниеПланировщика.Выполняется)
    {
        
        sched_st = активный_срез.верх();
        debug(СтэкНить) скажифнс("Starting thread: %s", sched_st);
        sched_st.состояние = ПСостояниеНити.Выполняется;
        
        
        try
        {
            sched_st.контекст.пуск();            
        }
        catch(Объект o)
        {
            //Handle exit condition on thread
            
            сост_планировщ = ПСостояниеПланировщика.Готов;
            throw o;
        }
        finally
        {
            //Process any состояние transition
            switch(sched_st.состояние)
            {
                case ПСостояниеНити.Готов:
                    //Нить wants to be restarted
                    sched_st.контекст.перезапуск();
                    следующий_срез.добавь(sched_st);
                break;
                
                case ПСостояниеНити.Выполняется:
                    //Nothing unusual, pass it to next состояние
                    sched_st.состояние = ПСостояниеНити.Готов;
                    следующий_срез.добавь(sched_st);
                break;
                
                case ПСостояниеНити.Подвешен:
                    //Don't reschedule
                break;
                
                case ПСостояниеНити.Завершён:
                    //Kill thread's контекст
                    sched_st.контекст.души();
                break;

				default: assert(false);
            }
            
            sched_st = пусто;
        }
    }
    
    сост_планировщ = ПСостояниеПланировщика.Готов;
    
    return getSysMillis() - sched_t0;
}

/**
 * Aborts a currently выполняется slice.  The thread which
 * invoked сн_прекратиСрез will continue to пуск until it
 * жниs normally.
 */
проц сн_прекратиСрез()
{
    debug (СтэкНить) скажифнс("Aborting slice");
    
    if(сост_планировщ != ПСостояниеПланировщика.Выполняется)
    {
        throw new ИсклСтэкНити("Cannot abort the timeslice while the планировщик is not выполняется!");
    }
    
    сост_планировщ = ПСостояниеПланировщика.Готов;
}

/**
 * Restarts the entire timeslice from the beginning.
 * This имеется no effect if the последний timeslice was started
 * from the beginning.  If a slice is currently выполняется,
 * then the текущ thread will continue to execute until
 * it жниs normally.
 */
проц сн_перезапустиСрез()
{
    debug (СтэкНить) скажифнс("Resetting timeslice");
    следующий_срез.совмести(активный_срез);
}

/**
 * Yields the currently executing стэк threaauxd.  This is
 * functionally equivalent to КонтекстСтэка.жни, except
 * it returns the amount of time the thread was жниeauxd.
 */
проц сн_жни()
{
    debug (СтэкНить) скажифнс("Yielding %s", sched_st.вТкст);
    
    КонтекстСтэка.жни();
}

/**
 * Throws an object и жниs the threaauxd.  The exception
 * is propagated out of the сн_запустиСрез methoauxd.
 */
проц сн_бросайЖни(Объект t)
{
    debug (СтэкНить) скажифнс("Throwing %s, Yielding %s", t.вТкст, sched_st.вТкст);
    
    КонтекстСтэка.бросьЖни(t);
}

/**
 * Causes the currently executing thread to wait for the
 * specified amount of milliseconds.  After the time
 * имеется passed, the thread resumes execution.
 *
 * Параметры:
 *  ms = The amount of milliseconds the thread will sleep.
 *
 * Возвращает: The number of milliseconds the thread was
 * asleep.
 */
бдол сн_спи(бдол ms)
{
    debug(СтэкНить) скажифнс("Sleeping for %d in %s", ms, sched_st.вТкст);
    
    бдол t0 = getSysMillis();
    
    while((getSysMillis - t0) >= ms)
        КонтекстСтэка.жни();
    
    return getSysMillis() - t0;
}

/**
 * This function retrieves the number of milliseconds since
 * the start of the timeslice.
 *
 * Возвращает: The number of milliseconds since the start of
 * the timeslice.
 */
бдол сн_время()
{
    return getSysMillis() - sched_t0;
}

/**
 * Возвращает: The currently выполняется стэк threaauxd.  пусто if
 * a timeslice is not in progress.
 */
СтэкНить сн_дайВыполняемый()
{
    return sched_st;
}

/**
 * Возвращает: The текущ состояние of the планировщик.
 */
ПСостояниеПланировщика сн_дайСостояние()
{
    return сост_планировщ;
}

/**
 * Возвращает: True if the планировщик is выполняется a timeslice.
 */
бул сн_выполянем_ли()
{
    return сост_планировщ == ПСостояниеПланировщика.Выполняется;
}

/**
 * Возвращает: The number of threads stored in the планировщик.
 */
цел сн_члоНитей()
{
    return активный_срез.размер + следующий_срез.размер;
}

/**
 * Возвращает: The number of threads остаток in the timeslice.
 */
цел сн_члоНитейВСрезе()
{
    if(активный_срез.размер > 0)
        return активный_срез.размер;
    
    return следующий_срез.размер;
}

debug (PQueue) {}
else
{
unittest
{
    скажифнс("Testing стэк thread creation & basic scheduling");
    
    static цел q0 = 0;
    static цел q1 = 0;
    static цел q2 = 0;
    
    //Run one empty slice
    сн_запустиСрез();
    
    СтэкНить st0 = new СтэкНить(
    delegate проц()
    {
        while(true)
        {
            q0++;
            сн_жни();
        }
    });
    
    СтэкНить st1 = new СтэкНить(
    function проц()
    {
        while(true)
        {
            q1++;
            сн_жни();
        }
    });
    
    class TestThread : СтэкНить
    {
        this() { super(); }
        
        override проц пуск()
        {
            while(true)
            {
                q2++;
                сн_жни();
            }
        }
    }
    
    СтэкНить st2 = new TestThread();
    
    assert(st0);
    assert(st1);
    assert(st2);
    
    сн_запустиСрез();
    
    assert(q0 == 1);
    assert(q1 == 1);
    assert(q2 == 1);
    
    st1.пауза();
    сн_запустиСрез();
    
    assert(st0);
    assert(st1);
    assert(st2);
    
    assert(st1.на_паузе);
    assert(q0 == 2);
    assert(q1 == 1);
    assert(q2 == 2);
    
    st2.души();
    сн_запустиСрез();
    
    assert(st2.завершён);
    assert(q0 == 3);
    assert(q1 == 1);
    assert(q2 == 2);
    
    st0.души();
    сн_запустиСрез();
    
    assert(st0.завершён);
    assert(q0 == 3);
    assert(q1 == 1);
    assert(q2 == 2);
    
    st1.возобнови();
    сн_запустиСрез();
    
    assert(st1.готов);
    assert(q0 == 3);
    assert(q1 == 2);
    assert(q2 == 2);
    
    st1.души();
    сн_запустиСрез();
    
    assert(st1.завершён);
    assert(q0 == 3);
    assert(q1 == 2);
    assert(q2 == 2);
    
    
    assert(сн_члоНитей == 0);
    скажифнс("Нить creation passed!");
}

unittest
{
    скажифнс("Testing priorities");
    
    //Test приоритет based scheduling
    цел a = 0;
    цел b = 0;
    цел c = 0;
    
    
    СтэкНить st0 = new СтэкНить(
    delegate проц()
    {
        a++;
        assert(a == 1);
        assert(b == 0);
        assert(c == 0);
        
        сн_жни;
        
        a++;
        assert(a == 2);
        assert(b == 2);
        assert(c == 2);
        
        сн_жни;
        
        a++;
        
        скажифнс("a=%d, b=%d, c=%d", a, b, c);
        assert(a == 3);
        скажифнс("b=%d : ", b, (b==2));
        assert(b == 2);
        assert(c == 2);
        
        
    }, 10);
    
    СтэкНить st1 = new СтэкНить(
    delegate проц()
    {
        b++;
        assert(a == 1);
        assert(b == 1);
        assert(c == 0);
        
        сн_жни;
        
        b++;
        assert(a == 1);
        assert(b == 2);
        assert(c == 2);
        
    }, 5);
    
    СтэкНить st2 = new СтэкНить(
    delegate проц()
    {
        c++;
        assert(a == 1);
        assert(b == 1);
        assert(c == 1);
        
        сн_жни;
        
        c++;
        assert(a == 1);
        assert(b == 1);
        assert(c == 2);
        
        st0.приоритет = 100;
        
        сн_жни;
        
        c++;
        assert(a == 3);
        assert(b == 2);
        assert(c == 3);
        
    }, 1);
    
    сн_запустиСрез();
    
    assert(st0);
    assert(st1);
    assert(st2);
    
    assert(a == 1);
    assert(b == 1);
    assert(c == 1);
    
    st0.приоритет = -10;
    st1.приоритет = -5;
    
    сн_запустиСрез();
    
    assert(a == 2);
    assert(b == 2);
    assert(c == 2);
    
    сн_запустиСрез();
    
    assert(st0.завершён);
    assert(st1.завершён);
    assert(st2.завершён);
    
    assert(a == 3);
    assert(b == 2);
    assert(c == 3);
    
    assert(сн_члоНитей == 0);
    скажифнс("Priorities pass");
}

version(Win32)
unittest
{
    скажифнс("Testing exception handling");
    
    цел q0 = 0;
    цел q1 = 0;
    цел q2 = 0;
    цел q3 = 0;
    
    СтэкНить st0, st1;
    
    st0 = new СтэкНить(
    delegate проц()
    {
        q0++;
        throw new Исключение("Test exception");
        q0++;
    });
    
    try
    {
        q3++;
        сн_запустиСрез();
        q3++;
    }
    catch(Исключение e)
    {
        e.print;
    }
    
    assert(st0.завершён);
    assert(q0 == 1);
    assert(q1 == 0);
    assert(q2 == 0);
    assert(q3 == 1);
    
    st1 = new СтэкНить(
    delegate проц()
    {
        try
        {
            q1++;
            throw new Исключение("Testing");
            q1++;
        }
        catch(Исключение e)
        {
            e.print();
        }
        
        while(true)
        {
            q2++;
            сн_жни();
        }
    });
    
    сн_запустиСрез();
    assert(st1.готов);
    assert(q0 == 1);
    assert(q1 == 1);
    assert(q2 == 1);
    assert(q3 == 1);
    
    st1.души;
    assert(st1.завершён);
    
    assert(сн_члоНитей == 0);
    скажифнс("Исключение handling passed!");
}

unittest
{
    скажифнс("Testing thread pausing");
    
    //Test пауза
    цел q = 0;
    цел r = 0;
    цел s = 0;
    
    СтэкНить st0;
    
    st0 = new СтэкНить(
    delegate проц()
    {
        s++;
        st0.пауза();
        q++;
    });
    
    try
    {
        st0.возобнови();
    }
    catch(Исключение e)
    {
        e.print;
        r ++;
    }
    
    assert(st0);
    assert(q == 0);
    assert(r == 1);
    assert(s == 0);
    
    st0.пауза();
    assert(st0.на_паузе);
    
    try
    {
        st0.пауза();
    }
    catch(Исключение e)
    {
        e.print;
        r ++;
    }
    
    сн_запустиСрез();
    
    assert(q == 0);
    assert(r == 2);
    assert(s == 0);
    
    st0.возобнови();
    assert(st0.готов);
    
    сн_запустиСрез();
    
    assert(st0.на_паузе);
    assert(q == 0);
    assert(r == 2);
    assert(s == 1);
    
    st0.возобнови();
    сн_запустиСрез();
    
    assert(st0.завершён);
    assert(q == 1);
    assert(r == 2);
    assert(s == 1);
    
    try
    {
        st0.пауза();
    }
    catch(Исключение e)
    {
        e.print;
        r ++;
    }
    
    сн_запустиСрез();
    
    assert(st0.завершён);
    assert(q == 1);
    assert(r == 3);
    assert(s == 1);
    
    assert(сн_члоНитей == 0);
    скажифнс("Pause passed!");
}


unittest
{
    скажифнс("Testing души");
    
    цел q0 = 0;
    цел q1 = 0;
    цел q2 = 0;
    
    СтэкНить st0, st1, st2;
    
    st0 = new СтэкНить(
    delegate проц()
    {
        while(true)
        {
            q0++;
            сн_жни();
        }
    });
    
    st1 = new СтэкНить(
    delegate проц()
    {
        q1++;
        st1.души();
        q1++;
    });
    
    st2 = new СтэкНить(
    delegate проц()
    {
        while(true)
        {
            q2++;
            сн_жни();
        }
    });
    
    assert(st1.готов);
    
    сн_запустиСрез();
    
    assert(st1.завершён);
    assert(q0 == 1);
    assert(q1 == 1);
    assert(q2 == 1);
    
    сн_запустиСрез();
    assert(q0 == 2);
    assert(q1 == 1);
    assert(q2 == 2);
    
    st0.души();
    сн_запустиСрез();
    assert(st0.завершён);
    assert(q0 == 2);
    assert(q1 == 1);
    assert(q2 == 3);
    
    st2.пауза();
    assert(st2.на_паузе);
    st2.души();
    assert(st2.завершён);
    
    цел r = 0;
    
    try
    {
        r++;
        st2.души();
        r++;
    }
    catch(ИсклСтэкНити e)
    {
        e.print;
    }
    
    assert(st2.завершён);
    assert(r == 1);
    
    assert(сн_члоНитей == 0);
    скажифнс("Kill passed");
}

unittest
{
    скажифнс("Testing объедини");
    
    цел q0 = 0;
    цел q1 = 0;
    
    СтэкНить st0, st1;
    
    st0 = new СтэкНить(
    delegate проц()
    {
        q0++;
        st1.объедини();
        q0++;
    }, 10);
    
    st1 = new СтэкНить(
    delegate проц()
    {
        q1++;
        сн_жни();
        q1++;
        st1.объедини();
        q1++;
    }, 0);
    
    try
    {
        st0.объедини();
        assert(false);
    }
    catch(ИсклСтэкНити e)
    {
        e.print();
    }
    
    сн_запустиСрез();
    
    assert(st0.жив);
    assert(st1.жив);
    assert(q0 == 1);
    assert(q1 == 1);
    
    try
    {
        сн_запустиСрез();
        assert(false);
    }
    catch(Исключение e)
    {
        e.print;
    }
    
    assert(st0.жив);
    assert(st1.завершён);
    assert(q0 == 1);
    assert(q1 == 2);
    
    сн_запустиСрез();
    assert(st0.завершён);
    assert(q0 == 2);
    assert(q1 == 2);
    
    assert(сн_члоНитей == 0);
    скажифнс("Join passed");
}

unittest
{
    скажифнс("Testing перезапуск");
    assert(сн_члоНитей == 0);
    
    цел q0 = 0;
    цел q1 = 0;
    
    СтэкНить st0, st1;
    
    st0 = new СтэкНить(
    delegate проц()
    {
        q0++;
        сн_жни();
        st0.перезапуск();
    });
    
    сн_запустиСрез();
    assert(st0.готов);
    assert(q0 == 1);
    
    сн_запустиСрез();
    assert(st0.готов);
    assert(q0 == 1);
    
    сн_запустиСрез();
    assert(st0.готов);
    assert(q0 == 2);
    
    st0.души();
    assert(st0.завершён);
    
    assert(сн_члоНитей == 0);
    скажифнс("Testing the other перезапуск");
    
    st1 = new СтэкНить(
    delegate проц()
    {
        q1++;
        while(true)
        {
            сн_жни();
        }
    });
    
    assert(st1.готов);
    
    сн_запустиСрез();
    assert(q1 == 1);
    
    сн_запустиСрез();
    assert(q1 == 1);
    
    st1.перезапуск();
    сн_запустиСрез();
    assert(st1.готов);
    assert(q1 == 2);
    
    st1.пауза();
    сн_запустиСрез();
    assert(st1.на_паузе);
    assert(q1 == 2);
    
    st1.перезапуск();
    st1.возобнови();
    сн_запустиСрез();
    assert(st1.готов);
    assert(q1 == 3);
    
    st1.души();
    st1.перезапуск();
    assert(st1.на_паузе);
    st1.возобнови();
    
    сн_запустиСрез();
    assert(st1.готов);
    assert(q1 == 4);
    
    st1.души();
    
    assert(сн_члоНитей == 0);
    скажифнс("Restart passed");
}

unittest
{
    скажифнс("Testing abort / reset");
    assert(сн_члоНитей == 0);
    
    try
    {
        сн_прекратиСрез();
        assert(false);
    }
    catch(ИсклСтэкНити e)
    {
        e.print;
    }
    
    
    цел q0 = 0;
    цел q1 = 0;
    цел q2 = 0;
    
    СтэкНить st0 = new СтэкНить(
    delegate проц()
    {
        while(true)
        {
            скажифнс("st0");
            q0++;
            сн_прекратиСрез();
            сн_жни();
        }
    }, 10);
    
    СтэкНить st1 = new СтэкНить(
    delegate проц()
    {
        while(true)
        {
            скажифнс("st1");
            q1++;
            сн_прекратиСрез();
            сн_жни();
        }
    }, 5);
    
    СтэкНить st2 = new СтэкНить(
    delegate проц()
    {
        while(true)
        {
            скажифнс("st2");
            q2++;
            сн_прекратиСрез();
            сн_жни();
        }
    }, 0);
    
    сн_запустиСрез();
    assert(q0 == 1);
    assert(q1 == 0);
    assert(q2 == 0);
    
    сн_запустиСрез();
    assert(q0 == 1);
    assert(q1 == 1);
    assert(q2 == 0);
    
    сн_запустиСрез();
    assert(q0 == 1);
    assert(q1 == 1);
    assert(q2 == 1);
    
    сн_запустиСрез();
    assert(q0 == 2);
    assert(q1 == 1);
    assert(q2 == 1);
    
    сн_перезапустиСрез();
    сн_запустиСрез();
    assert(q0 == 3);
    assert(q1 == 1);
    assert(q2 == 1);
    
    st0.души();
    st1.души();
    st2.души();
    
    сн_запустиСрез();
    assert(q0 == 3);
    assert(q1 == 1);
    assert(q2 == 1);
    
    assert(сн_члоНитей == 0);
    скажифнс("Abort slice passed");
}

unittest
{
    скажифнс("Testing бросьЖни");
    
    цел q0 = 0;
    
    СтэкНить st0 = new СтэкНить(
    delegate проц()
    {
        q0++;
        сн_бросайЖни(new Исключение("testing сн_бросайЖни"));
        q0++;
    });
    
    try
    {
        сн_запустиСрез();
        assert(false);
    }
    catch(Исключение e)
    {
        e.print();
    }
    
    assert(q0 == 1);
    assert(st0.готов);
    
    сн_запустиСрез();
    assert(q0 == 2);
    assert(st0.завершён);
    
    assert(сн_члоНитей == 0);
    скажифнс("бросьЖни passed");
}
}
