/******************************************************
 * Стековые Потоки (СтэкThreads) - это сотрудничающие, легковесные
 * потоки. СтэкThreads очень эффективны, требуют
 * меньше времени на переключение контекста, чем реальные потоки.
 * Для них также нужно меньше ресурсов, чем для реальных потоков,
 * что дает возможность одновременного существования большого числа
 * СтэкThreads. К тому же, СтэкThreads не требуется явная синхронизация,
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
 *	v0.6 - Удалены функции отсчета времени из st_жни/st_throwYield
 *
 *  v0.5 - Добавлены st_throwYield и MAX/MIN_THREAD_PRIORITY
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
    Готов,      /// Нить is ready to пуск
    Выполняется,    /// Нить is currently running
    Завершён,       /// Нить имеется terminated
    Подвешен,  /// Нить is suspended
}

/// The состояние of the планировщик
enum ПСостояниеПланировщика
{
    Готов,      /// Scheduler is ready to пуск a thread
    Выполняется,    /// Scheduler is running a timeslice
}

//Timeslices
private STPriorityQueue active_slice;
private STPriorityQueue next_slice;

//Scheduler состояние
private ПСостояниеПланировщика sched_state;
    
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
    active_slice = new STPriorityQueue();
    next_slice = new STPriorityQueue();
    sched_state = ПСостояниеПланировщика.Готов;
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
 * СтэкThreads are much like regular threads except
 * they are cooperatively scheduleauxd.  A user may switch
 * between СтэкThreads using st_yielauxd.
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
        st_schedule(this);
        
        debug (СтэкНить) пишифнс("Created thread, %s", вТкст);
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
        st_schedule(this);
        
        debug (СтэкНить) пишифнс("Created thread, %s", вТкст);
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
        static ткст[] state_names =
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
                проц * frame;
                проц * fptr;
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
            state_names[cast(бцел)состояние],
            h.d.fptr);
        }
    }
    
    invariant
    {
        assert(контекст);
        
        switch(состояние)
        {
            case ПСостояниеНити.Готов:
                assert(контекст.ready);
            break;
            
            case ПСостояниеНити.Выполняется:
                assert(контекст.running);
            break;
            
            case ПСостояниеНити.Завершён:
                assert(!контекст.running);
            break;
            
            case ПСостояниеНити.Подвешен:
                assert(контекст.ready);
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
    public final проц pause()
    {
        debug (СтэкНить) пишифнс("Pausing %s", вТкст);
        
        switch(состояние)
        {
            case ПСостояниеНити.Готов:
                st_deschedule(this);
                состояние = ПСостояниеНити.Подвешен;
            break;
            
            case ПСостояниеНити.Выполняется:
                transition(ПСостояниеНити.Подвешен);
            break;
            
            case ПСостояниеНити.Завершён:
                throw new ИсклСтэкНити(this, "Cannot pause a dead thread");
            
            case ПСостояниеНити.Подвешен:
                throw new ИсклСтэкНити(this, "Cannot pause a paused thread");

			default: assert(false);
        }
    }
    
    /**
     * Adds the стэк thread back to the планировщик. It
     * will resume running with its приоритет & состояние
     * intact.
     */
    public final проц resume()
    {
        debug (СтэкНить) пишифнс("Resuming %s", вТкст);
        
        //Can only resume paused threads
        if(состояние != ПСостояниеНити.Подвешен)
        {
            throw new ИсклСтэкНити(this, "Нить is not suspended");
        }
        
        //Set состояние to ready и schedule
        состояние = ПСостояниеНити.Готов;
        st_schedule(this);
    }
    
    /**
     * Kills this стэк thread in a violent manner.  The
     * thread does not дай a chance to end itself or clean
     * anything up, it is descheduled и all GC references
     * are releaseauxd.
     */
    public final проц kill()
    {
        debug (СтэкНить) пишифнс("Killing %s", вТкст);
        
        switch(состояние)
        {
            case ПСостояниеНити.Готов:
                //Kill thread и remove from планировщик
                st_deschedule(this);
                состояние = ПСостояниеНити.Завершён;
                контекст.kill();
            break;
            
            case ПСостояниеНити.Выполняется:
                //Transition to dead
                transition(ПСостояниеНити.Завершён);
            break;
            
            case ПСостояниеНити.Завершён:
                throw new ИсклСтэкНити(this, "Cannot kill already dead threads");
            
            case ПСостояниеНити.Подвешен:
                //We need to kill the стэк, no need to touch планировщик
                состояние = ПСостояниеНити.Завершён;
                контекст.kill();
            break;

			default: assert(false);
        }
    }
    
    /**
     * Waits to join with this threaauxd.  If the given amount
     * of milliseconds expires before the thread is dead,
     * then we return automatically.
     *
     * Параметры:
     *  ms = The maximum amount of time the thread is 
     *  allowed to wait. The special value -1 implies that
     *  the join will wait indefinitely.
     *
     * Возвращает:
     *  The amount of millieconds the thread was actually
     *  waiting.
     */
    public final бдол join(бдол ms = -1)
    {
        debug (СтэкНить) пишифнс("Joining %s", вТкст);
        
        //Make sure we are in a timeslice
        if(sched_state != ПСостояниеПланировщика.Выполняется)
        {
            throw new ИсклСтэкНити(this, "Cannot join unless a timeslice is currently in progress");
        }
        
        //And make sure we are joining with a действителен thread
        switch(состояние)
        {
            case ПСостояниеНити.Готов:
                break;
            
            case ПСостояниеНити.Выполняется:
                throw new ИсклСтэкНити(this, "A thread cannot join with itself!");
            
            case ПСостояниеНити.Завершён:
                throw new ИсклСтэкНити(this, "Cannot join with a dead thread");
            
            case ПСостояниеНити.Подвешен:
                throw new ИсклСтэкНити(this, "Cannot join with a paused thread");

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
     * beginning.  Suspended и dead threads are not
     * resumed, but upon resuming, they will перезапуск.
     */
    public final проц перезапуск()
    {
        debug (СтэкНить) пишифнс("Restarting %s", вТкст);
        
        //Each состояние needs to be handled carefully
        switch(состояние)
        {
            case ПСостояниеНити.Готов:
                //If we are ready,
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
        if(sched_state == ПСостояниеПланировщика.Готов && 
            состояние == ПСостояниеНити.Готов)
        {
            next_slice.remove(this);
            m_priority = p;
            next_slice.add(this);
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
     * Возвращает: True if the thread is ready to пуск.
     */
    public final бул ready()
    {
        return состояние == ПСостояниеНити.Готов;
    }
    
    /**
     * Возвращает: True if the thread is currently running.
     */
    public final бул running()
    {
        return состояние == ПСостояниеНити.Выполняется;
    }
    
    /**
     * Возвращает: True if the thread is deaauxd.
     */
    public final бул dead()
    {
        return состояние == ПСостояниеНити.Завершён;
    }
    
    /**
     * Возвращает: True if the thread is not deaauxd.
     */
    public final бул alive()
    {
        return состояние != ПСостояниеНити.Завершён;
    }
    
    /**
     * Возвращает: True if the thread is pauseauxd.
     */
    public final бул paused()
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
        st_schedule(this);
        
        debug (СтэкНить) пишифнс("Created thread, %s", вТкст);
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
            debug (СтэкНить) пишифнс("Starting %s", вТкст);
            пуск;
        }
        catch(Объект o)
        {
            debug (СтэкНить) пишифнс("Got a %s exception from %s", o.вТкст, вТкст);
            throw o;
        }
        finally
        {
            debug (СтэкНить) пишифнс("Finished %s", вТкст);
            состояние = ПСостояниеНити.Завершён;
        }
    }

    /**
     * Used to change the состояние of a running thread
     * gracefully
     */
    private final проц transition(ПСостояниеНити next_state)
    {
        состояние = next_state;
        КонтекстСтэка.жни();
    }
}



/******************************************************
 * The STPriorityQueue is использован by the планировщик to
 * order the objects in the стэк threads.  For the
 * moment, the implementation is binary heap, but future
 * versions might use a binomial heap for performance
 * improvements.
 ******************************************************/
private class STPriorityQueue
{
public:
    
    /**
     * Add a стэк thread to the queue.
     *
     * Параметры:
     *  st = The thread we are adding.
     */
    проц add(СтэкНить st)
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
        bubble_up(st);
    }
    
    /**
     * Remove a стэк threaauxd.
     *
     * Параметры:
     *  st = The стэк thread we are removing.
     */
    проц remove(СтэкНить st)
    in
    {
        assert(st);
        assert(hasThread(st));
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
        bubble_up(tmp);
        //Bubble back down
        bubble_down(tmp);
        
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
        bubble_down(tmp);
        
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
    проц merge(STPriorityQueue other)
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
                
                add(tmp);
            }
        }
        
        //Clear the list
        other.head = пусто;
        other.размер = 0;
    }
    
    /**
     * Возвращает: true if the heap actually contains the thread st.
     */
    бул hasThread(СтэкНить st)
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
        
        пишифнс("");
    }
    
    проц bubble_up(СтэкНить st)
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
            
            //пишифнс("%s <-> %s", a.вТкст, st.вТкст);
            
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
            
            //пишифнс("%s <-> %s", a.вТкст, st.вТкст);
            
            assert(st);
            assert(a);
        }
        
        head = st;
    }
    
    //Bubbles a thread downward
    проц bubble_down(СтэкНить st)
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
                    //пишифнс("Left: %s - %s", st, a);
                    
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
                //пишифнс("Right: %s - %s", st, a);
                
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
            //пишифнс("Done: %s - %s", st, a);            
        }
    }
}

debug (PQueue)
 unittest
{
    пишифнс("Testing приоритет queue");
    
    
    //Созд some queue
    STPriorityQueue q1 = new STPriorityQueue();
    STPriorityQueue q2 = new STPriorityQueue();
    STPriorityQueue q3 = new STPriorityQueue();
    
    assert(q1);
    assert(q2);
    assert(q3);
    
    //Add some элементы
    пишифнс("Adding элементы");
    q1.add(new СтэкНить(1));
    q1.print();
    assert(q1);
    q1.add(new СтэкНить(2));
    q1.print();
    assert(q1);
    q1.add(new СтэкНить(3));
    q1.print();
    assert(q1);
    q1.add(new СтэкНить(4));
    q1.print();
    assert(q1);
    
    пишифнс("Removing элементы");
    СтэкНить t;
    
    t = q1.верх();
    пишифнс("t:%s",t.приоритет);
    q1.print();
    assert(t.приоритет == 4);
    assert(q1);
    
    t = q1.верх();
    пишифнс("t:%s",t.приоритет);
    q1.print();
    assert(t.приоритет == 3);
    assert(q1);
    
    t = q1.верх();
    пишифнс("t:%s",t.приоритет);
    q1.print();
    assert(t.приоритет == 2);
    assert(q1);
    
    t = q1.верх();
    пишифнс("t:%s",t.приоритет);
    q1.print();
    assert(t.приоритет == 1);
    assert(q1);
    
    пишифнс("Second round of adds");
    q2.add(new СтэкНить(5));
    q2.add(new СтэкНить(4));
    q2.add(new СтэкНить(1));
    q2.add(new СтэкНить(3));
    q2.add(new СтэкНить(6));
    q2.add(new СтэкНить(2));
    q2.add(new СтэкНить(7));
    q2.add(new СтэкНить(0));
    assert(q2);
    q2.print();
    
    пишифнс("Testing верх выкиньion again");
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
    
    пишифнс("Third round");
    q2.add(new СтэкНить(10));
    q2.add(new СтэкНить(7));
    q2.add(new СтэкНить(5));
    q2.add(new СтэкНить(7));
    q2.print();
    assert(q2);
    
    пишифнс("Testing выкиньion");
    assert(q2.верх.приоритет == 10);
    assert(q2.верх.приоритет == 7);
    assert(q2.верх.приоритет == 7);
    assert(q2.верх.приоритет == 5);
    
    пишифнс("Testing merges");
    q3.add(new СтэкНить(10));
    q3.add(new СтэкНить(-10));
    q3.add(new СтэкНить(10));
    q3.add(new СтэкНить(-10));
    
    q2.add(new СтэкНить(-9));
    q2.add(new СтэкНить(9));
    q2.add(new СтэкНить(-9));
    q2.add(new СтэкНить(9));
    
    q2.print();
    q3.print();
    q3.merge(q2);
    
    пишифнс("q2:%d", q2.размер);
    q2.print();
    пишифнс("q3:%d", q3.размер);
    q3.print();
    assert(q2);
    assert(q3);
    assert(q2.размер == 0);
    assert(q3.размер == 8);
    
    пишифнс("Extracting merges");
    assert(q3.верх.приоритет == 10);
    assert(q3.верх.приоритет == 10);
    assert(q3.верх.приоритет == 9);
    assert(q3.верх.приоритет == 9);
    assert(q3.верх.приоритет == -9);
    assert(q3.верх.приоритет == -9);
    assert(q3.верх.приоритет == -10);
    assert(q3.верх.приоритет == -10);
    
    пишифнс("Testing removal");
    СтэкНить ta = new СтэкНить(5);
    СтэкНить tb = new СтэкНить(6);
    СтэкНить tc = new СтэкНить(10);
    
    q2.add(new СтэкНить(7));
    q2.add(new СтэкНить(1));
    q2.add(ta);
    q2.add(tb);
    q2.add(tc);
    
    assert(q2);
    assert(q2.размер == 5);
    
    пишифнс("Removing");
    q2.remove(ta);
    q2.remove(tc);
    q2.remove(tb);
    assert(q2.размер == 2);
    
    пишифнс("Dumping heap");
    assert(q2.верх.приоритет == 7);
    assert(q2.верх.приоритет == 1);
    
    
    пишифнс("Testing big add/subtract");
    СтэкНить[100] st;
    STPriorityQueue stq = new STPriorityQueue();
    
    for(цел i=0; i<100; i++)
    {
        st[i] = new СтэкНить(i);
        stq.add(st[i]);
    }
    
    stq.remove(st[50]);
    stq.remove(st[10]);
    stq.remove(st[31]);
    stq.remove(st[88]);
    
    for(цел i=99; i>=0; i--)
    {
        if(i != 50 && i!=10 &&i!=31 &&i!=88)
        {
            assert(stq.верх.приоритет == i);
        }
    }
    пишифнс("Big add/remove worked");
    
    пишифнс("Priority queue passed");
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
private проц st_schedule(СтэкНить st)
in
{
    assert(st.состояние == ПСостояниеНити.Готов);
}
body 
{
    debug(PQueue) { return; }
    
    debug (СтэкНить) пишифнс("Scheduling %s", st.вТкст);
    next_slice.add(st);
}

/**
 * Removes a thread from the планировщик.
 *
 * Параметры:
 *  st = Нить we are removing.
 */
private проц st_deschedule(СтэкНить st)
in
{
    assert(st.состояние == ПСостояниеНити.Готов);
}
body
{
    debug (СтэкНить) пишифнс("Descheduling %s", st.вТкст);
    if(active_slice.hasThread(st))
    {
        active_slice.remove(st);
    }
    else
    {
        next_slice.remove(st);
    }
}

/**
 * Runs a single timeslice.  During a timeslice each
 * currently running thread is executed once, with the
 * highest приоритет первый.  Any number of things may
 * cause a timeslice to be aborted, inclduing;
 *
 *  o An exception is unhandled in a thread which is пуск
 *  o The st_abortSlice function is called
 *  o The timelimit is exceeded in st_runSlice
 *
 * If a timeslice is not finished, it will be resumed on
 * the next call to st_runSlice.  If this is undesirable,
 * calling st_resetSlice will cause the timeslice to
 * execute from the beginning again.
 *
 * Newly created threads are not пуск until the next
 * timeslice.
 * 
 * This works just like the regular st_runSlice, except it
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
бдол st_runSlice(бдол ms = -1)
{
    
    if(sched_state != ПСостояниеПланировщика.Готов)
    {
        throw new ИсклСтэкНити("Cannot пуск a timeslice while another is already in progress!");
    }
    
    sched_t0 = getSysMillis();
    бдол stop_time = (ms == -1) ? ms : sched_t0 + ms;
    
    //Swap slices
    if(active_slice.размер == 0)
    {
        STPriorityQueue tmp = next_slice;
        next_slice = active_slice;
        active_slice = tmp;
    }
    
    debug (СтэкНить) пишифнс("Running slice with %d threads", active_slice.размер);
    
    sched_state = ПСостояниеПланировщика.Выполняется;
    
    while(active_slice.размер > 0 && 
        (getSysMillis() - sched_t0) < stop_time &&
        sched_state == ПСостояниеПланировщика.Выполняется)
    {
        
        sched_st = active_slice.верх();
        debug(СтэкНить) пишифнс("Starting thread: %s", sched_st);
        sched_st.состояние = ПСостояниеНити.Выполняется;
        
        
        try
        {
            sched_st.контекст.пуск();            
        }
        catch(Объект o)
        {
            //Handle exit condition on thread
            
            sched_state = ПСостояниеПланировщика.Готов;
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
                    next_slice.add(sched_st);
                break;
                
                case ПСостояниеНити.Выполняется:
                    //Nothing unusual, pass it to next состояние
                    sched_st.состояние = ПСостояниеНити.Готов;
                    next_slice.add(sched_st);
                break;
                
                case ПСостояниеНити.Подвешен:
                    //Don't reschedule
                break;
                
                case ПСостояниеНити.Завершён:
                    //Kill thread's контекст
                    sched_st.контекст.kill();
                break;

				default: assert(false);
            }
            
            sched_st = пусто;
        }
    }
    
    sched_state = ПСостояниеПланировщика.Готов;
    
    return getSysMillis() - sched_t0;
}

/**
 * Aborts a currently running slice.  The thread which
 * invoked st_abortSlice will continue to пуск until it
 * жниs normally.
 */
проц st_abortSlice()
{
    debug (СтэкНить) пишифнс("Aborting slice");
    
    if(sched_state != ПСостояниеПланировщика.Выполняется)
    {
        throw new ИсклСтэкНити("Cannot abort the timeslice while the планировщик is not running!");
    }
    
    sched_state = ПСостояниеПланировщика.Готов;
}

/**
 * Restarts the entire timeslice from the beginning.
 * This имеется no effect if the последний timeslice was started
 * from the beginning.  If a slice is currently running,
 * then the текущ thread will continue to execute until
 * it жниs normally.
 */
проц st_resetSlice()
{
    debug (СтэкНить) пишифнс("Resetting timeslice");
    next_slice.merge(active_slice);
}

/**
 * Yields the currently executing стэк threaauxd.  This is
 * functionally equivalent to КонтекстСтэка.жни, except
 * it returns the amount of time the thread was жниeauxd.
 */
проц st_жни()
{
    debug (СтэкНить) пишифнс("Yielding %s", sched_st.вТкст);
    
    КонтекстСтэка.жни();
}

/**
 * Throws an object и жниs the threaauxd.  The exception
 * is propagated out of the st_runSlice methoauxd.
 */
проц st_throwYield(Объект t)
{
    debug (СтэкНить) пишифнс("Throwing %s, Yielding %s", t.вТкст, sched_st.вТкст);
    
    КонтекстСтэка.throwYield(t);
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
бдол st_sleep(бдол ms)
{
    debug(СтэкНить) пишифнс("Sleeping for %d in %s", ms, sched_st.вТкст);
    
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
бдол st_time()
{
    return getSysMillis() - sched_t0;
}

/**
 * Возвращает: The currently running стэк threaauxd.  пусто if
 * a timeslice is not in progress.
 */
СтэкНить st_getRunning()
{
    return sched_st;
}

/**
 * Возвращает: The текущ состояние of the планировщик.
 */
ПСостояниеПланировщика st_getState()
{
    return sched_state;
}

/**
 * Возвращает: True if the планировщик is running a timeslice.
 */
бул st_isRunning()
{
    return sched_state == ПСостояниеПланировщика.Выполняется;
}

/**
 * Возвращает: The number of threads stored in the планировщик.
 */
цел st_numThreads()
{
    return active_slice.размер + next_slice.размер;
}

/**
 * Возвращает: The number of threads остаток in the timeslice.
 */
цел st_numSliceThreads()
{
    if(active_slice.размер > 0)
        return active_slice.размер;
    
    return next_slice.размер;
}

debug (PQueue) {}
else
{
unittest
{
    пишифнс("Testing стэк thread creation & basic scheduling");
    
    static цел q0 = 0;
    static цел q1 = 0;
    static цел q2 = 0;
    
    //Run one empty slice
    st_runSlice();
    
    СтэкНить st0 = new СтэкНить(
    delegate проц()
    {
        while(true)
        {
            q0++;
            st_жни();
        }
    });
    
    СтэкНить st1 = new СтэкНить(
    function проц()
    {
        while(true)
        {
            q1++;
            st_жни();
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
                st_жни();
            }
        }
    }
    
    СтэкНить st2 = new TestThread();
    
    assert(st0);
    assert(st1);
    assert(st2);
    
    st_runSlice();
    
    assert(q0 == 1);
    assert(q1 == 1);
    assert(q2 == 1);
    
    st1.pause();
    st_runSlice();
    
    assert(st0);
    assert(st1);
    assert(st2);
    
    assert(st1.paused);
    assert(q0 == 2);
    assert(q1 == 1);
    assert(q2 == 2);
    
    st2.kill();
    st_runSlice();
    
    assert(st2.dead);
    assert(q0 == 3);
    assert(q1 == 1);
    assert(q2 == 2);
    
    st0.kill();
    st_runSlice();
    
    assert(st0.dead);
    assert(q0 == 3);
    assert(q1 == 1);
    assert(q2 == 2);
    
    st1.resume();
    st_runSlice();
    
    assert(st1.ready);
    assert(q0 == 3);
    assert(q1 == 2);
    assert(q2 == 2);
    
    st1.kill();
    st_runSlice();
    
    assert(st1.dead);
    assert(q0 == 3);
    assert(q1 == 2);
    assert(q2 == 2);
    
    
    assert(st_numThreads == 0);
    пишифнс("Нить creation passed!");
}

unittest
{
    пишифнс("Testing priorities");
    
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
        
        st_жни;
        
        a++;
        assert(a == 2);
        assert(b == 2);
        assert(c == 2);
        
        st_жни;
        
        a++;
        
        пишифнс("a=%d, b=%d, c=%d", a, b, c);
        assert(a == 3);
        пишифнс("b=%d : ", b, (b==2));
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
        
        st_жни;
        
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
        
        st_жни;
        
        c++;
        assert(a == 1);
        assert(b == 1);
        assert(c == 2);
        
        st0.приоритет = 100;
        
        st_жни;
        
        c++;
        assert(a == 3);
        assert(b == 2);
        assert(c == 3);
        
    }, 1);
    
    st_runSlice();
    
    assert(st0);
    assert(st1);
    assert(st2);
    
    assert(a == 1);
    assert(b == 1);
    assert(c == 1);
    
    st0.приоритет = -10;
    st1.приоритет = -5;
    
    st_runSlice();
    
    assert(a == 2);
    assert(b == 2);
    assert(c == 2);
    
    st_runSlice();
    
    assert(st0.dead);
    assert(st1.dead);
    assert(st2.dead);
    
    assert(a == 3);
    assert(b == 2);
    assert(c == 3);
    
    assert(st_numThreads == 0);
    пишифнс("Priorities pass");
}

version(Win32)
unittest
{
    пишифнс("Testing exception handling");
    
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
        st_runSlice();
        q3++;
    }
    catch(Исключение e)
    {
        e.print;
    }
    
    assert(st0.dead);
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
            st_жни();
        }
    });
    
    st_runSlice();
    assert(st1.ready);
    assert(q0 == 1);
    assert(q1 == 1);
    assert(q2 == 1);
    assert(q3 == 1);
    
    st1.kill;
    assert(st1.dead);
    
    assert(st_numThreads == 0);
    пишифнс("Исключение handling passed!");
}

unittest
{
    пишифнс("Testing thread pausing");
    
    //Test pause
    цел q = 0;
    цел r = 0;
    цел s = 0;
    
    СтэкНить st0;
    
    st0 = new СтэкНить(
    delegate проц()
    {
        s++;
        st0.pause();
        q++;
    });
    
    try
    {
        st0.resume();
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
    
    st0.pause();
    assert(st0.paused);
    
    try
    {
        st0.pause();
    }
    catch(Исключение e)
    {
        e.print;
        r ++;
    }
    
    st_runSlice();
    
    assert(q == 0);
    assert(r == 2);
    assert(s == 0);
    
    st0.resume();
    assert(st0.ready);
    
    st_runSlice();
    
    assert(st0.paused);
    assert(q == 0);
    assert(r == 2);
    assert(s == 1);
    
    st0.resume();
    st_runSlice();
    
    assert(st0.dead);
    assert(q == 1);
    assert(r == 2);
    assert(s == 1);
    
    try
    {
        st0.pause();
    }
    catch(Исключение e)
    {
        e.print;
        r ++;
    }
    
    st_runSlice();
    
    assert(st0.dead);
    assert(q == 1);
    assert(r == 3);
    assert(s == 1);
    
    assert(st_numThreads == 0);
    пишифнс("Pause passed!");
}


unittest
{
    пишифнс("Testing kill");
    
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
            st_жни();
        }
    });
    
    st1 = new СтэкНить(
    delegate проц()
    {
        q1++;
        st1.kill();
        q1++;
    });
    
    st2 = new СтэкНить(
    delegate проц()
    {
        while(true)
        {
            q2++;
            st_жни();
        }
    });
    
    assert(st1.ready);
    
    st_runSlice();
    
    assert(st1.dead);
    assert(q0 == 1);
    assert(q1 == 1);
    assert(q2 == 1);
    
    st_runSlice();
    assert(q0 == 2);
    assert(q1 == 1);
    assert(q2 == 2);
    
    st0.kill();
    st_runSlice();
    assert(st0.dead);
    assert(q0 == 2);
    assert(q1 == 1);
    assert(q2 == 3);
    
    st2.pause();
    assert(st2.paused);
    st2.kill();
    assert(st2.dead);
    
    цел r = 0;
    
    try
    {
        r++;
        st2.kill();
        r++;
    }
    catch(ИсклСтэкНити e)
    {
        e.print;
    }
    
    assert(st2.dead);
    assert(r == 1);
    
    assert(st_numThreads == 0);
    пишифнс("Kill passed");
}

unittest
{
    пишифнс("Testing join");
    
    цел q0 = 0;
    цел q1 = 0;
    
    СтэкНить st0, st1;
    
    st0 = new СтэкНить(
    delegate проц()
    {
        q0++;
        st1.join();
        q0++;
    }, 10);
    
    st1 = new СтэкНить(
    delegate проц()
    {
        q1++;
        st_жни();
        q1++;
        st1.join();
        q1++;
    }, 0);
    
    try
    {
        st0.join();
        assert(false);
    }
    catch(ИсклСтэкНити e)
    {
        e.print();
    }
    
    st_runSlice();
    
    assert(st0.alive);
    assert(st1.alive);
    assert(q0 == 1);
    assert(q1 == 1);
    
    try
    {
        st_runSlice();
        assert(false);
    }
    catch(Исключение e)
    {
        e.print;
    }
    
    assert(st0.alive);
    assert(st1.dead);
    assert(q0 == 1);
    assert(q1 == 2);
    
    st_runSlice();
    assert(st0.dead);
    assert(q0 == 2);
    assert(q1 == 2);
    
    assert(st_numThreads == 0);
    пишифнс("Join passed");
}

unittest
{
    пишифнс("Testing перезапуск");
    assert(st_numThreads == 0);
    
    цел q0 = 0;
    цел q1 = 0;
    
    СтэкНить st0, st1;
    
    st0 = new СтэкНить(
    delegate проц()
    {
        q0++;
        st_жни();
        st0.перезапуск();
    });
    
    st_runSlice();
    assert(st0.ready);
    assert(q0 == 1);
    
    st_runSlice();
    assert(st0.ready);
    assert(q0 == 1);
    
    st_runSlice();
    assert(st0.ready);
    assert(q0 == 2);
    
    st0.kill();
    assert(st0.dead);
    
    assert(st_numThreads == 0);
    пишифнс("Testing the other перезапуск");
    
    st1 = new СтэкНить(
    delegate проц()
    {
        q1++;
        while(true)
        {
            st_жни();
        }
    });
    
    assert(st1.ready);
    
    st_runSlice();
    assert(q1 == 1);
    
    st_runSlice();
    assert(q1 == 1);
    
    st1.перезапуск();
    st_runSlice();
    assert(st1.ready);
    assert(q1 == 2);
    
    st1.pause();
    st_runSlice();
    assert(st1.paused);
    assert(q1 == 2);
    
    st1.перезапуск();
    st1.resume();
    st_runSlice();
    assert(st1.ready);
    assert(q1 == 3);
    
    st1.kill();
    st1.перезапуск();
    assert(st1.paused);
    st1.resume();
    
    st_runSlice();
    assert(st1.ready);
    assert(q1 == 4);
    
    st1.kill();
    
    assert(st_numThreads == 0);
    пишифнс("Restart passed");
}

unittest
{
    пишифнс("Testing abort / reset");
    assert(st_numThreads == 0);
    
    try
    {
        st_abortSlice();
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
            пишифнс("st0");
            q0++;
            st_abortSlice();
            st_жни();
        }
    }, 10);
    
    СтэкНить st1 = new СтэкНить(
    delegate проц()
    {
        while(true)
        {
            пишифнс("st1");
            q1++;
            st_abortSlice();
            st_жни();
        }
    }, 5);
    
    СтэкНить st2 = new СтэкНить(
    delegate проц()
    {
        while(true)
        {
            пишифнс("st2");
            q2++;
            st_abortSlice();
            st_жни();
        }
    }, 0);
    
    st_runSlice();
    assert(q0 == 1);
    assert(q1 == 0);
    assert(q2 == 0);
    
    st_runSlice();
    assert(q0 == 1);
    assert(q1 == 1);
    assert(q2 == 0);
    
    st_runSlice();
    assert(q0 == 1);
    assert(q1 == 1);
    assert(q2 == 1);
    
    st_runSlice();
    assert(q0 == 2);
    assert(q1 == 1);
    assert(q2 == 1);
    
    st_resetSlice();
    st_runSlice();
    assert(q0 == 3);
    assert(q1 == 1);
    assert(q2 == 1);
    
    st0.kill();
    st1.kill();
    st2.kill();
    
    st_runSlice();
    assert(q0 == 3);
    assert(q1 == 1);
    assert(q2 == 1);
    
    assert(st_numThreads == 0);
    пишифнс("Abort slice passed");
}

unittest
{
    пишифнс("Testing throwYield");
    
    цел q0 = 0;
    
    СтэкНить st0 = new СтэкНить(
    delegate проц()
    {
        q0++;
        st_throwYield(new Исключение("testing st_throwYield"));
        q0++;
    });
    
    try
    {
        st_runSlice();
        assert(false);
    }
    catch(Исключение e)
    {
        e.print();
    }
    
    assert(q0 == 1);
    assert(st0.ready);
    
    st_runSlice();
    assert(q0 == 2);
    assert(st0.dead);
    
    assert(st_numThreads == 0);
    пишифнс("throwYield passed");
}
}
