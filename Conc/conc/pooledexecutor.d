/* \file pooledexecutor.d
 * \brief A tunable, extensible нить pool.
 */

/*
  Originally written by Doug Lea and released into the public domain.
  This may be used for any purposes whatsoever without acknowledgment.
  Thanks for the assistance and support of Sun Microsystems Labs,
  and everyone contributing, testing, and using this code.
  Translated to D by Ben Hinkle 2004.
*/

module conc.pooledexecutor;

import conc.threadfactoryuser;
import conc.executor;
import conc.channel;
import conc.waitnotify;

private import cidrus, exception;

private import stdrus:Нить; // for unittest
private import conc.synchronouschannel;

/** 
 * The maximum pool размер; used if not otherwise specified.  Default
 * значение is essentially infinite (Integer.MAX_VALUE)
 */
const цел  ДЕФ_МАКС_РАЗМ_ПУЛА = цел.max;

/** 
 * The minimum pool размер; used if not otherwise specified.  Default
 * значение is 1.
 */
const цел  ДЕФ_МИН_РАЗМ_ПУЛА = 1;

/**
 * The maximum время to keep worker threads alive ждущий for new
 * tasks; used if not otherwise specified. Default значение is one
 * minute (60000 milliseconds).
 */
const дол ДЕФ_ВРЕМЯ_АКТИВНОСТИ = 60000;

/** \class КатушечныйИсполнитель
 * \brief A tunable, extensible нить pool class. The main supported public
 * method is <code>выполни(Пускаемый команда)</code>, which can be
 * called instead of directly creating threads to выполни commands.
 *
 * <p>
 * Нить pools can be useful for several, usually intertwined
 * reasons:
 *
 * <ul>
 *
 *    <li> To bound resource use. A limit can be placed on the maximum
 *    число of simultaneously executing threads.
 *
 *    <li> To manage concurrency levels. A targeted число of threads
 *    can be allowed to выполни simultaneously.
 *
 *    <li> To manage a установи of threads performing related tasks.
 *
 *    <li> To minimize overhead, by reusing previously constructed
 *    Нить объекты rather than creating new ones.  (Note however
 *    that pools are hardly ever cure-alls for performance problems
 *    associated with нить construction, especially on JVMs that
 *    themselves internally pool or recycle threads.)  
 *
 * </ul>
 *
 * These goals introduce a число of policy parameters that are
 * encapsulated in this class. All of these parameters have defaults
 * and are tunable, either via дай/установи methods, or, in cases where
 * decisions should hold across lifetimes, via methods that can be
 * easily overridden in subclasses.  The main, most commonly установи
 * parameters can be established in constructors.  Policy choices
 * across these dimensions can and do interact.  Be careful, and
 * please read this documentation completely before using!  See also
 * the usage examples below.
 *
 * <dl>
 *   <dt> Queueing 
 *
 *   <dd> By default, this pool uses queueless synchronous channels to
 *   to hand off work to threads. This is a safe, conservative policy
 *   that avoids lockups when handling sets of requests that might
 *   have internal dependencies. (In these cases, queuing one задание
 *   could замок up another that would be able to continue if the
 *   queued задание were to пуск.)  If you are sure that this cannot
 *   happen, then you can instead supply a очередь of some sort (for
 *   example, a BoundedBuffer or ЛинкованнаяОчередь) in the constructor.
 *   This will cause new commands to be queued in cases where all
 *   MaximumPoolSize threads are busy. Queues are sometimes
 *   appropriate when each задание is completely independent of others,
 *   so tasks cannot affect each others execution.  For example, in an
 *   http server.  <p>
 *
 *   When given a choice, this pool always prefers adding a new нить
 *   rather than queueing if there are currently fewer than the
 *   current дайМинРазмПула threads running, but otherwise always
 *   prefers queuing a request rather than adding a new нить. Thus,
 *   if you use an unbounded buffer, you will never have more than
 *   дайМинРазмПула threads running. (Since the default
 *   minimumPoolSize is one, you will probably want to explicitly
 *   установиМинРазмПула.)  <p>
 *
 *   While queuing can be useful in smoothing out transient bursts of
 *   requests, especially in socket-based services, it is not very
 *   well behaved when commands continue to arrive on average faster
 *   than they can be processed.  Using bounds for both the очередь and
 *   the pool размер, along with пуск-when-blocked policy is often a
 *   reasonable response to such possibilities.  <p>
 *
 *   Очередь sizes and maximum pool sizes can often be traded off for
 *   each другое. Using large queues and small pools minimizes CPU
 *   usage, OS resources, and context-switching overhead, but can lead
 *   to artifically low throughput. Especially if tasks frequently
 *   block (for example if they are I/O bound), a JVM and underlying
 *   OS may be able to schedule время for more threads than you
 *   otherwise allow. Use of small queues or queueless handoffs
 *   generally requires larger pool sizes, which keeps CPUs busier but
 *   may encounter unacceptable scheduling overhead, which also
 *   decreases throughput.  <p>
 *
 *   <dt> Maximum Pool размер
 *
 *   <dd> The maximum число of threads to use, when needed.  The pool
 *   does not by default preallocate threads.  Instead, a нить is
 *   created, if necessary and if there are fewer than the maximum,
 *   only when an <code>выполни</code> request arrives.  The default
 *   значение is (for all practical purposes) infinite --
 *   <code>Integer.MAX_VALUE</code>, so should be установи in the
 *   constructor or the установи method unless you are just using the pool
 *   to minimize construction overhead.  Because задание handoffs to idle
 *   worker threads require synchronization that in turn relies on JVM
 *   scheduling policies to ensure progress, it is possible that a new
 *   нить will be created even though an existing worker нить has
 *   just become idle but has not progressed to the point at which it
 *   can accept a new задание. This phenomenon tends to occur on some
 *   JVMs when bursts of short tasks are executed.  <p>
 *
 *   <dt> Minimum Pool размер
 *
 *   <dd> The minimum число of threads to use, when needed (default
 *   1).  When a new request is received, and fewer than the minimum
 *   число of threads are running, a new нить is always created to
 *   handle the request even if другое worker threads are idly ждущий
 *   for work. Otherwise, a new нить is created only if there are
 *   fewer than the maximum and the request cannot immediately be
 *   queued.  <p>
 *
 *   <dt> Preallocation
 *
 *   <dd> You can override lazy нить construction policies via
 *   method создайНити, which establishes a given число of warm
 *   threads. Be aware that these preallocated threads will время out
 *   and die (and later be replaced with others if needed) if not used
 *   within the keep-alive время window. If you use preallocation, you
 *   probably want to increase the keepalive время.  The difference
 *   between установиМинРазмПула and создайНити is that
 *   создайНити immediately establishes threads, while setting the
 *   minimum pool размер waits until requests arrive.  <p>
 *
 *   <dt> Keep-alive время
 *
 *   <dd> If the pool maintained references to a fixed установи of threads
 *   in the pool, then it would impede garbage collection of otherwise
 *   idle threads. This would defeat the resource-management aspects
 *   of pools. One solution would be to use weak references.  However,
 *   this would impose costly and difficult synchronization issues.
 *   Instead, threads are simply allowed to terminate and thus be
 *   GCable if they have been idle for the given keep-alive время.  The
 *   значение of this parameter represents a trade-off between GCability
 *   and construction время. In most current Java VMs, нить
 *   construction and cleanup overhead is on the order of
 *   milliseconds. The default keep-alive значение is one minute, which
 *   means that the время needed to construct and then GC a нить is
 *   expended at most once per minute.  
 *   <p> 
 *
 *   To establish worker threads permanently, use a <em>negative</em>
 *   argument to установиВремяАктивности.  <p>
 *
 *   <dt> Blocked execution policy
 *
 *   <dd> If the maximum pool размер or очередь размер is bounded, then it
 *   is possible for incoming <code>выполни</code> requests to
 *   block. There are four supported policies for handling this
 *   problem, and mechanics (based on the Strategy Объект pattern) to
 *   allow others in subclasses: <p>
 *
 *   <dl>
 *     <dt> Run (the default)
 *     <dd> The нить making the <code>выполни</code> request
 *          runs the задание itself. This policy helps guard against lockup. 
 *     <dt> Wait
 *     <dd> Wait until a нить becomes available.  This
 *          policy should, in general, not be used if the minimum число of
 *          of threads is zero, in which case a нить may never become
 *          available.
 *     <dt> Abort
 *     <dd> Throw a RuntimeException
 *     <dt> Discard 
 *     <dd> Throw away the current request and return.
 *     <dt> DiscardOldest
 *     <dd> Throw away the oldest request and return.
 *   </dl>
 *
 *   Other plausible policies include raising the maximum pool размер
 *   after checking with some другое объекты that this is OK.  <p>
 *
 *   These cases can never occur if the maximum pool размер is unbounded
 *   or the очередь is unbounded.  In these cases you instead face
 *   potential resource exhaustion.)  The выполни method does not
 *   throw any checked exceptions in any of these cases since any
 *   errors associated with them must normally be dealt with via
 *   handlers or callbacks. (Although in some cases, these might be
 *   associated with throwing unchecked exceptions.)  You may wish to
 *   add special implementations even if you choose one of the listed
 *   policies. For example, the supplied Discard policy does not
 *   inform the вызывающий of the drop. You could add your own version
 *   that does so.  Since choice of policies is normally a system-wide
 *   decision, selecting a policy affects all calls to
 *   <code>выполни</code>.  If for some reason you would instead like
 *   to make per-call decisions, you could add variant versions of the
 *   <code>выполни</code> method (for example,
 *   <code>executeIfWouldNotBlock</code>) in subclasses.  <p>
 *
 *   <dt> Нить construction parameters
 *
 *   <dd> A settable ФабрикаНитей establishes each new нить.  By
 *   default, it merely generates a new instance of class Нить, but
 *   can be changed to use a Нить subclass, to установи priorities,
 *   ThreadLocals, etc.  <p>
 *
 *   <dt> Interruption policy
 *
 *   <dd> Работяга threads check for interruption after processing each
 *   команда, and terminate upon interruption.  Fresh threads will
 *   replace them if needed. Thus, new tasks will not старт out in an
 *   interrupted state due to an uncleared interruption in a previous
 *   задание. Also, unprocessed commands are never dropped upon
 *   interruption. It would conceptually suffice simply to clear
 *   interruption between tasks, but implementation characteristics of
 *   interruption-based methods are uncertain enough to warrant this
 *   conservative strategy. It is a good idea to be equally
 *   conservative in your code for the tasks running within pools.
 *   <p>
 *
 *   <dt> Shutdown policy
 *
 *   <dd> The прервиВсе method interrupts, but does not disable the
 *   pool. Two different shutdown methods are supported for use when
 *   you do want to (permanently) stop processing tasks. Method
 *   прерываниеПослеОбработкиТекущихЗадачВОчереди waits until all
 *   current tasks are finished. The shutDownNow method interrupts
 *   current threads and leaves другое queued requests unprocessed.
 *   <p>
 *
 *   <dt> Handling requests after shutdown
 *
 *   <dd> When the pool is shutdown, new incoming requests are handled
 *   by the blockedExecutionHandler. By default, the обработчик is установи to
 *   discard new requests, but this can be установи with an optional
 *   argument to method
 *   прерываниеПослеОбработкиТекущихЗадачВОчереди. <p> Also, if you are
 *   using some form of queuing, you may wish to call method дренируй()
 *   to remove (and return) unprocessed commands from the очередь after
 *   shutting down the pool and its clients. If you need to be sure
 *   these commands are processed, you can then пуск() each of the
 *   commands in the list returned by дренируй().
 *
 * </dl>
 * <p>
 *
 * <b>Usage examples.</b>
 * <p>
 *
 * Probably the most common use of pools is in statics or singletons
 * accessible from a число of классы in a package; for example:
 *
 * <pre>
 * class MyPool {
 *   // initialize to use a maximum of 8 threads.
 *   static КатушечныйИсполнитель pool = new КатушечныйИсполнитель(8);
 * }
 * </pre>
 * Here are some sample variants in initialization:
 * <ol>
 *  <li> Using a bounded buffer of 10 tasks, at least 4 threads (started only
 *       when needed due to incoming requests), but allowing
 *       up to 100 threads if the buffer gets full.
 *     <pre>
 *        pool = new КатушечныйИсполнитель(new BoundedBuffer(10), 100);
 *        pool.установиМинРазмПула(4);
 *     </pre>
 *  <li> Same as (1), except pre-старт 9 threads, allowing them to
 *        die if they are not used for five minutes.
 *     <pre>
 *        pool = new КатушечныйИсполнитель(new BoundedBuffer(10), 100);
 *        pool.установиМинРазмПула(4);
 *        pool.установиВремяАктивности(1000 * 60 * 5);
 *        pool.создайНити(9);
 *     </pre>
 *  <li> Same as (2) except clients abort if both the buffer is full and
 *       all 100 threads are busy:
 *     <pre>
 *        pool = new КатушечныйИсполнитель(new BoundedBuffer(10), 100);
 *        pool.установиМинРазмПула(4);
 *        pool.установиВремяАктивности(1000 * 60 * 5);
 *        pool.абортКогдаБлокировано();
 *        pool.создайНити(9);
 *     </pre>
 *  <li> An unbounded очередь serviced by exactly 5 threads:
 *     <pre>
 *        pool = new КатушечныйИсполнитель(new ЛинкованнаяОчередь());
 *        pool.установиВремяАктивности(-1); // live forever
 *        pool.создайНити(5);
 *     </pre>
 *  </ol>
 *
 * <p>
 * <b>Usage notes.</b>
 * <p>
 *
 * Pools do not mesh well with using нить-specific storage.
 * ThreadLocal relies on the identity of a нить executing a
 * particular задание. Pools use the same нить to perform different
 * tasks.  <p>
 *
 * If you need a policy not handled by the parameters in this class
 * consider writing a subclass.  <p>
 *
 */

class КатушечныйИсполнитель : ПользовательФабрикиНитей , Исполнитель {

  /** The maximum число of threads allowed in pool. */
  protected цел maximumPoolSize_ = ДЕФ_МАКС_РАЗМ_ПУЛА;

  /** The minumum число of threads to maintain in pool. */
  protected цел minimumPoolSize_ = ДЕФ_МИН_РАЗМ_ПУЛА;

  /**  Current pool размер.  */
  protected цел poolSize_ = 0;

  /** The maximum время for an idle нить to жди for new задание. */
  protected дол keepAliveTime_ = ДЕФ_ВРЕМЯ_АКТИВНОСТИ;

  /** 
   * Shutdown flag - latches да when a shutdown method is called 
   * in order to disable queuing/handoffs of new tasks.
   */
  protected бул прерывание_ = нет;

  alias цел delegate() Пускаемый;
  //  alias conc.synchronouschannel.СинхронныйКанал!(Пускаемый) СК;
  alias СинхронныйКанал!(Пускаемый) СК;

  /**
   * The канал used to hand off the команда to a нить in the pool.
   */
  Канал!(Пускаемый) handOff_;

  /**
   * The установи of active threads, declared as a map from workers to
   * their threads.  This is needed by the прервиВсе method.  It
   * may also be useful in subclasses that need to perform другое
   * нить management chores.
   */
  protected Нить[Работяга] threads_;

  /** The current обработчик for unserviceable requests. */
  protected ОбработчикБлокированногоВыполнения blockedExecutionHandler_;

  mixin ЖдиУведомиВсех;

  /** 
   * Create a new pool with all default settings
   */

  this() {
    this (new СК, ДЕФ_МАКС_РАЗМ_ПУЛА);
  }

  /** 
   * Create a new pool with all default settings except
   * for maximum pool размер.
   */

  this(цел максРазмПула) {
    this(new СК, максРазмПула);
  }

  /** 
   * Create a new pool that uses the supplied Канал for queuing, and
   * with all default parameter settings.
   */

  this(Канал!(Пускаемый) канал) {
    this(канал, ДЕФ_МАКС_РАЗМ_ПУЛА);
  }

  /** 
   * Create a new pool that uses the supplied Канал for queuing, and
   * with all default parameter settings except for maximum pool размер.
   */

  this(Канал!(Пускаемый) канал, цел максРазмПула) {
    maximumPoolSize_ = максРазмПула;
    handOff_ = канал;
    пускПослеБлокировки();
    иницЖдиУведомиВсех();
  }
  
  ~this() {
    удалиЖдиУведомиВсех();
  }

  /** 
   * Return the maximum число of threads to simultaneously выполни
   * New unqueued requests will be handled according to the current
   * blocking policy once this limit is exceeded.
   */
  synchronized цел дайМаксРазмПула() { 
    return maximumPoolSize_; 
  }

  /** 
   * Set the maximum число of threads to use. Decreasing the pool
   * размер will not immediately kill existing threads, but they may
   * later die when idle.
   * @exception IllegalArgumentException if less or equal to zero.
   * (It is
   * not considered an error to установи the maximum to be less than than
   * the minimum. However, in this case there are no guarantees
   * about behavior.)
   */
  synchronized проц установиМаксРазмПула(цел новМаксимум)
  in {
    assert( новМаксимум >= 0 );
  } 
  body { 
    maximumPoolSize_ = новМаксимум; 
  }

  /** 
   * Return the minimum число of threads to simultaneously выполни.
   * (Default значение is 1).  If fewer than the mininum число are
   * running upon reception of a new request, a new нить is started
   * to handle this request.
   */
  synchronized цел дайМинРазмПула() { 
    return minimumPoolSize_; 
  }

  /** 
   * Set the minimum число of threads to use. 
   * @exception IllegalArgumentException if less than zero. (It is not
   * considered an error to установи the minimum to be greater than the
   * maximum. However, in this case there are no guarantees about
   * behavior.)
   */
  synchronized проц установиМинРазмПула(цел новМинимум) 
  in {
    assert( новМинимум >= 0 );
  } 
  body { 
    minimumPoolSize_ = новМинимум; 
  }
  
  /** 
   * Return the current число of active threads in the pool.  This
   * число is just a snaphot, and may change immediately upon
   * returning
   */
  synchronized цел дайРазмПула() { 
    return poolSize_; 
  }

  /** 
   * Return the число of milliseconds to keep threads alive ждущий
   * for new commands. A negative значение means to жди forever. A zero
   * значение means not to жди at all.
   */
  synchronized дол дайВремяАктивности() { 
    return keepAliveTime_; 
  }

  /** 
   * Set the число of milliseconds to keep threads alive ждущий for
   * new commands. A negative значение means to жди forever. A zero
   * значение means not to жди at all.
   */
  synchronized проц установиВремяАктивности(дол мсек) { 
    keepAliveTime_ = мсек; 
  }

  /** Get the обработчик for blocked execution */
  synchronized ОбработчикБлокированногоВыполнения дайОбрБлокВып() {
    return blockedExecutionHandler_;
  }

  /** Set the обработчик for blocked execution */
  synchronized проц установиОбрБлокВып(ОбработчикБлокированногоВыполнения h) {
    blockedExecutionHandler_ = h;
  }

  /**
   * Create and старт a нить to handle a new команда.  Call only
   * when holding замок.
   */
  protected проц добавьНить(Пускаемый команда) {
    Работяга worker = new Работяга(команда,this);
    Нить нить = дайФабрикуНитей().новаяНить(команда);
    threads_[worker] = нить;
    ++poolSize_;
    нить.старт();
  }

  /**
   * Create and старт up to члоНитей threads in the pool.
   * Return the число created. This may be less than the число
   * requested if creating more would exceed maximum pool размер bound.
   */
  цел создайНити(цел члоНитей) {
    цел ncreated = 0;
    for (цел i = 0; i < члоНитей; ++i) {
      synchronized(this) { 
        if (poolSize_ < maximumPoolSize_) {
          добавьНить(пусто);
          ++ncreated;
        }
        else 
          break;
      }
    }
    return ncreated;
  }

  /**
   * Interrupt all threads in the pool, causing them all to
   * terminate. Assuming that executed tasks do not disable (clear)
   * interruptions, each нить will terminate after processing its
   * current задание. Threads will terminate sooner if the executed tasks
   * themselves respond to interrupts.
   */
  synchronized проц прервиВсе() {
    foreach (Нить t; threads_) {
      // TODO: what is the D equivalent to interrupt?
      //      t.interrupt();
    }
  }

  /**
   * Interrupt all threads and disable construction of new
   * threads. Any tasks entered after this point will be discarded. A
   * shut down pool cannot be restarted.
   */
  проц выполниШатдаун() {
    выполниШатдаун(new ВыместиКогдаБлокировано());
  }

  /**
   * Interrupt all threads and disable construction of new
   * threads. Any tasks entered after this point will be handled by
   * the given ОбработчикБлокированногоВыполнения.  A shut down pool cannot be
   * restarted.
   */
  synchronized проц выполниШатдаун(ОбработчикБлокированногоВыполнения обработчик) {
    установиОбрБлокВып(обработчик);
    прерывание_ = да; // don't allow new tasks
    minimumPoolSize_ = maximumPoolSize_ = 0; // don't make new threads
    прервиВсе(); // interrupt all existing threads
  }

  /**
   * Terminate threads after processing all elements currently in
   * очередь. Any tasks entered after this point will be discarded. A
   * shut down pool cannot be restarted.
   */
  проц прерываниеПослеОбработкиТекущихЗадачВОчереди() {
    прерываниеПослеОбработкиТекущихЗадачВОчереди(new ВыместиКогдаБлокировано());
  }

  /**
   * Terminate threads after processing all elements currently in
   * очередь. Any tasks entered after this point will be handled by the
   * given ОбработчикБлокированногоВыполнения.  A shut down pool cannot be
   * restarted.
   */
  synchronized проц прерываниеПослеОбработкиТекущихЗадачВОчереди(ОбработчикБлокированногоВыполнения обработчик) {
    установиОбрБлокВып(обработчик);
    прерывание_ = да;
    if (poolSize_ == 0) // disable new нить construction when idle
      minimumPoolSize_ = maximumPoolSize_ = 0;
  }

  /** 
   * Return да if a shutDown method has succeeded in terminating all
   * threads.
   */
  synchronized бул терминированоПослеШатдауна() {
    return прерывание_ && poolSize_ == 0;
  }

  /**
   * Wait for a shutdown pool to fully terminate, or until the таймаут
   * has expired. This method may only be called <em>after</em>
   * invoking выполниШатдаун or
   * прерываниеПослеОбработкиТекущихЗадачВОчереди.
   *
   * @param максВремОжидан  the maximum время in milliseconds to жди
   * @return да if the pool has terminated within the max жди period
   */
  synchronized бул ждиТерминированиеПослеШатдауна(дол максВремОжидан)
  in {
    assert(прерывание_);
  }
  body {
    if (poolSize_ == 0)
      return да;
    дол времяОжидания = максВремОжидан;
    if (времяОжидания <= 0)
      return нет;
    дол старт = clock();
    while (да) {
      жди(времяОжидания);
      if (poolSize_ == 0)
	return да;
      времяОжидания = максВремОжидан - (clock() - старт);
      if (времяОжидания <= 0)
	return нет;
    }
  }

  /**
   * Wait for a shutdown pool to fully terminate.  This method may
   * only be called <em>after</em> invoking выполниШатдаун or
   * прерываниеПослеОбработкиТекущихЗадачВОчереди.
   */
  synchronized проц ждиТерминированиеПослеШатдауна()
  in {
    assert(прерывание_);
  } 
  body {
    while (poolSize_ > 0)
      жди();
  }

  /**
   * Remove all unprocessed tasks from pool очередь, and return them in
   * an array. This method should be used only when there are
   * not any active clients of the pool. Otherwise you face the
   * possibility that the method will loop pulling out tasks as
   * clients are putting them in.  This method can be useful after
   * shutting down a pool (via выполниШатдаун) to determine whether there
   * are any pending tasks that were not processed.  You can then, for
   * example выполни all unprocessed commands via code along the lines
   * of:
   *
   * <pre>
   *   Пускаемый[] tasks = pool.дренируй();
   *   foreach (Пускаемый r, tasks)
   *     r();
   * </pre>
   */
  Пускаемый[] дренируй() {
    бул wasInterrupted = нет;
    Пускаемый[] tasks;
    while (да) {
      try {
        Пускаемый x = handOff_.запроси(0);
	tasks ~= x;
      }
      catch (Искл искл) {
        wasInterrupted = да; // postpone re-interrupt until drained
      }
    }
    return tasks;
  }
  
  /** 
   * Cleanup method called upon termination of worker нить.
   */
  protected synchronized проц работягаВыполнен(Работяга w) {
    threads_.remove(w);
    if (--poolSize_ == 0 && прерывание_) { 
      maximumPoolSize_ = minimumPoolSize_ = 0; // disable new threads
      уведомиВсех(); // уведоми ждиТерминированиеПослеШатдауна
    }

    // Create a replacement if needed
    if (poolSize_ == 0 || poolSize_ < minimumPoolSize_) {
      try {
         Пускаемый r = (handOff_.запроси(0));
         if (!(r is Пускаемый.init) && !прерывание_) // just consume задание if shut down
           добавьНить(r);
      } catch(Искл ie) {
        return;
      }
    }
  }

  /** 
   * Get a задание from the handoff очередь, or пусто if shutting down.
   */
  protected Пускаемый дайЗадачу() {
    дол времяОжидания;
    synchronized(this) {
      if (poolSize_ > maximumPoolSize_) // Cause to die if too many threads
        return пусто;
      времяОжидания = (прерывание_)? 0 : keepAliveTime_;
    }
    if (времяОжидания >= 0) 
      return handOff_.запроси(времяОжидания);
    else 
      return handOff_.возьми();
  }
  

  /**
   * Class defining the basic пуск loop for pooled threads.
   */
  class Работяга {
    protected Пускаемый firstTask_;
    protected КатушечныйИсполнитель объ;
    protected this(Пускаемый firstTask,КатушечныйИсполнитель объ) { 
      firstTask_ = firstTask; 
      this.объ = объ;
    }

    цел пуск() {
      try {
        Пускаемый задание = firstTask_;
        firstTask_ = Пускаемый.init; // enable GC

        if (!(задание is Пускаемый.init)) {
          задание();
          задание = пусто;
        }
        
        while ( !((задание = объ.дайЗадачу()) is Пускаемый.init) ) {
          задание();
          задание = пусто;
        }
      }
      catch (Искл искл) { } // fall through
      finally {
        объ.работягаВыполнен(this);
      }
      return 0;
    }
  }

  /**
   * Class for actions to возьми when выполни() blocks. Uses Strategy
   * pattern to represent different actions. You can add more in
   * subclasses, and/or create subclasses of these. If so, you will
   * also want to add or modify the corresponding methods that установи the
   * current blockedExectionHandler_.
   */
  interface ОбработчикБлокированногоВыполнения {
    /** 
     * Return да if successfully handled so, выполни should
     * terminate; else return нет if выполни loop should be retried.
     */
    бул блокированноеДействие(Пускаемый команда);
  }

  /** Class defining Run action. */
  class ПускПослеБлокировки : ОбработчикБлокированногоВыполнения {
    бул блокированноеДействие(Пускаемый команда) {
      команда();
      return да;
    }
  }

  /** 
   * Set the policy for blocked execution to be that the current
   * нить executes the команда if there are no available threads in
   * the pool.
   */
  проц пускПослеБлокировки() {
    установиОбрБлокВып(new ПускПослеБлокировки());
  }

  /** Class defining Wait action. */
  class ЖдиПокаБлокировано : ОбработчикБлокированногоВыполнения {
    КатушечныйИсполнитель объ;
    this(КатушечныйИсполнитель объ) {
      this.объ = объ;
    }
    бул блокированноеДействие(Пускаемый команда) {
      synchronized(объ) {
        if (объ.прерывание_)
          return да;
      }
      объ.handOff_.помести(команда);
      return да;
    }
  }

  /** 
   * Set the policy for blocked execution to be to жди until a нить
   * is available, unless the pool has been shut down, in which case
   * the action is discarded.
   */
  проц ждиПокаБлокировано() {
    установиОбрБлокВып(new ЖдиПокаБлокировано(this));
  }

  /** Class defining Discard action. */
  class ВыместиКогдаБлокировано : ОбработчикБлокированногоВыполнения {
    бул блокированноеДействие(Пускаемый команда) {
      return да;
    }
  }

  /** 
   * Set the policy for blocked execution to be to return without
   * executing the request.
   */
  проц выместиКогдаБлокировано() {
    установиОбрБлокВып(new ВыместиКогдаБлокировано());
  }


  /** Class defining Abort action. */
  class АбортКогдаБлокировано : ОбработчикБлокированногоВыполнения {
    бул блокированноеДействие(Пускаемый команда) {
      throw new Искл("Pool is blocked");
      return да;
    }
  }

  /** 
   * Set the policy for blocked execution to be to
   * throw a RuntimeException.
   */
  проц абортКогдаБлокировано() {
    установиОбрБлокВып(new АбортКогдаБлокировано());
  }


  /**
   * Class defining DiscardOldest action.  Under this policy, at most
   * one старый unhandled задание is discarded.  If the new задание can then be
   * handed off, it is.  Otherwise, the new задание is пуск in the current
   * нить (i.e., ПускПослеБлокировки is used as a backup policy.)
   */
  class ВыместиСтаршуюКогдаБлокировано : ОбработчикБлокированногоВыполнения {
    КатушечныйИсполнитель объ;
    this(КатушечныйИсполнитель объ) {
      this.объ = объ;
    }
    бул блокированноеДействие(Пускаемый команда) {
      объ.handOff_.запроси(0);
      if (!объ.handOff_.предложи(команда, 0))
        команда();
      return да;
    }
  }

  /** 
   * Set the policy for blocked execution to be to discard the oldest
   * unhandled request
   */
  проц выместиСтаршуюКогдаБлокировано() {
    установиОбрБлокВып(new ВыместиСтаршуюКогдаБлокировано(this));
  }

  /**
   * Arrange for the given команда to be executed by a нить in this
   * pool.  The method normally returns when the команда has been
   * handed off for (possibly later) execution.
   */
  проц выполни(Пускаемый команда) {
    for (;;) {
      synchronized(this) { 
        if (!прерывание_) {
          цел размер = poolSize_;

          // Ensure minimum число of threads
          if (размер < minimumPoolSize_) {
            добавьНить(команда);
            return;
          }
          
          // Try to give to existing нить
          if (handOff_.предложи(команда, 0)) { 
            return;
          }
          
          // If cannot handoff and still under maximum, create new нить
          if (размер < maximumPoolSize_) {
            добавьНить(команда);
            return;
          }
        }
      }

      // Cannot hand off and cannot create -- ask for help
      if (дайОбрБлокВып().блокированноеДействие(команда)) {
        return;
      }
    }
  }

  unittest {
    эхо("starting КатушечныйИсполнитель unittest\n");

    // initialize to use a maximum of 8 threads.
    КатушечныйИсполнитель pool = new КатушечныйИсполнитель(8);
    цел n=0;
    pool.выполни( delegate цел () {n++;return 0;} );
    pool.выполни( delegate цел () {n++;return 0;} );
    pool.выполни( delegate цел () {n++;return 0;} );
    while (n != 3) Нить.рви();

    эхо("finished КатушечныйИсполнитель unittest\n");
  }
}

