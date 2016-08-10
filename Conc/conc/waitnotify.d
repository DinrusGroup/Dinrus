/** \file waitnotify.d
 *  \brief Support жди/уведоми synchronization and жди/уведоми/уведомиВсех
 *
 *  This module exports a mixin ЖдиУведоми for жди() and
 *  уведоми(), a mixin ЖдиУведомиВсех that implements
 *  жди() and уведомиВсех() and the subclasses ОбъектЖдиУведоми
 *  and ОбъектЖдиУведомиВсех.
 *
 *  In general the user model is similar to Java's
 *  жди/уведоми/уведомиВсех user model except that уведоми and уведомиВсех
 *  are separate mixins.
 */

/*  Originally written by Ben Hinkle for use in the D port of Doug Lea's
 *  concurrent Java package and released into the public domain.
 *  This may be used for any purposes whatsoever without acknowledgment.
 */

module conc.waitnotify;

import conc.sync;

private import thread;

/////////////////////////////////////////////////////////
//
//  Platform and compiler-specific implementation of
//  ЖдиУведоми and ЖдиУведомиВсех
//
/////////////////////////////////////////////////////////

version (Windows) {
  private import winapi;

  version = ATOMIC; 

  private проц ждиВин32Реализ(HANDLE событие, Объект объ, бцел таймаут) {
    // how can we check that нить has объ's monitor?
    if (таймаут == 0) 
      таймаут = INFINITE; 
    InternalObjectRep* iobj = cast(InternalObjectRep*)объ;
    LONG RecursionCount = iobj.monitor.RecursionCount;
    DWORD firedEvent;
    version (ATOMIC) {
      // Atomically отпусти the LockSemaphore (if present) and жди.
      iobj.monitor.RecursionCount = 0;
      iobj.monitor.OwningThread = INVALID_HANDLE_VALUE;
      for (цел k=1;k<RecursionCount;k++) {
	InterlockedDecrement(&iobj.monitor.LockCount);
      }
      // hmm. this probably still isn't atomic since 
      // EnterCriticalSection most likely checks the LockCount
      // before ждущий on the LockSemaphore.
      if (InterlockedDecrement(&iobj.monitor.LockCount) >= 0) {

	// in case another нить is trying to synchronize on this
	// critical section just as we are about to отпусти it we
	// have to жди until that нить is done making the LockSemaphore
	while (!iobj.monitor.LockSemaphore)
	  Sleep(1);

	firedEvent = SignalObjectAndWait(iobj.monitor.LockSemaphore,
					 событие,таймаут,0);
      } else {
	firedEvent = WaitForSingleObject(событие,таймаут);
      }
    } else {
      iobj.monitor.RecursionCount = 1;
      for (цел k=1;k<RecursionCount;k++) {
	InterlockedDecrement(&iobj.monitor.LockCount);
      }
      _d_monitorexit(объ);
      firedEvent = WaitForSingleObject(событие,таймаут);
    }
    _d_monitorenter(&объ);
    iobj.monitor.RecursionCount = RecursionCount;
    for (цел k=1;k<RecursionCount;k++) {
      InterlockedIncrement(&iobj.monitor.LockCount);
    }
    if (firedEvent == WAIT_FAILED) {
      throw new ИсклОжидания("Ошибка ожидания");
    }
  }

  private struct ЖдиСообщиРеализ {
    private HANDLE событие;

    проц иниц() {
      событие = CreateEventA(пусто,0,0,пусто);
    }

    проц разрушь() {
      CloseHandle(событие);
    }

    проц жди(Объект объ) {
      жди(объ,0);
    }

    проц жди(Объект объ, бцел таймаут) {
      ждиВин32Реализ(событие,объ,таймаут);
    }

    проц уведоми() {
      SetEvent(событие); // wakes one нить and resets событие
    }
  }

  private struct ЖдиСообщиВсемРеализ {
    private HANDLE событие;

    проц иниц() {
      событие = CreateEventA(пусто,1,0,пусто);
    }

    проц разрушь() {
      CloseHandle(событие);
    }

    проц жди(Объект объ) {
      жди(объ,0);
    }

    проц жди(Объект объ, бцел таймаут) {
      ждиВин32Реализ(событие,объ,таймаут);
    }

    проц уведомиВсех() {
      PulseEvent(событие); // wakes all нить and resets событие
    }
  }

  private {
    extern (Windows) {
      HANDLE CreateEventA(LPSECURITY_ATTRIBUTES, BOOL, BOOL, LPCSTR);
      DWORD WaitForSingleObject(HANDLE, DWORD);
      DWORD SignalObjectAndWait(HANDLE,HANDLE, DWORD,BOOL);
      DWORD SetEvent(HANDLE);
      DWORD PulseEvent(HANDLE);
      DWORD ResetEvent(HANDLE);
      DWORD WaitForMultipleObjects(DWORD, HANDLE*, BOOL, DWORD);
    }
    const DWORD INFINITE = -1;
    const DWORD WAIT_FAILED = -1;
    struct RTL_CRITICAL_SECTION {
      проц* DebugInfo;
      LONG LockCount;
      LONG RecursionCount;
      HANDLE OwningThread;
      HANDLE LockSemaphore;
      // ignore the rest
    }
    /* D Объект layout puts monitor after vtbl */
    struct InternalObjectRep {
      проц* vtbl;
      RTL_CRITICAL_SECTION* monitor;
    }
  }

} else version (linux) {

  // TODO: redo with helper C code to avoid hard-coding in various
  // header information.

  /* 
   *  Initialize the recursive замок counter for this system. It
   *  seems like some systems like 0 and some like 1.
   */
  private цел ZeroRecursionCount;
  static this() {
    Объект объ = new Объект;
    synchronized (объ) {
      InternalObjectRep* iobj = cast(InternalObjectRep*)объ;
      ZeroRecursionCount = iobj.monitor.__m_count;
    }
    объ = пусто;
  }

  private {
    import std.c.linux.linux;
    import std.c.linux.linuxextern;
  }

  struct ЖдиСообщиРеализ {
    private ubyte[48] cond;    // _pthread_cond_t has sizeof 48

    проц иниц() {
      pthread_cond_init(cond,пусто);
    }
    проц разрушь() {
      pthread_cond_destroy(cond);
    }

    проц жди(Объект объ) {
      // how can we check that нить has объ's monitor?
      InternalObjectRep* iobj = cast(InternalObjectRep*)объ;
			
      цел RecursionCount = iobj.monitor.__m_count;
      iobj.monitor.__m_count = ZeroRecursionCount;
      цел res = pthread_cond_wait(cond,iobj.monitor);

      // установи the мютекс to back the way we found it
      iobj.monitor.__m_count = RecursionCount;

      if (res) {
      	throw new ИсклОжидания("Wait failed");
      }
    }

    проц жди(Объект объ, бцел таймаут) {
      // how can we check that нить has объ's monitor?
      InternalObjectRep* iobj = cast(InternalObjectRep*)объ;
      timespec abstime;
      timeval tv;
      gettimeofday(&tv,пусто);
      дол micro = tv.tv_usec+таймаут*1000;
      abstime.tv_sec = tv.tv_sec+micro/1000000;
      abstime.tv_nsec = (micro%1000000)*1000;
      цел RecursionCount = iobj.monitor.__m_count;
      iobj.monitor.__m_count = ZeroRecursionCount;
      цел res = pthread_cond_timedwait(cond,iobj.monitor,&abstime);
      if (res) {
	_d_monitorenter(объ);
	iobj.monitor.__m_count = RecursionCount;
	if (res != ETIMEDOUT) {
	  throw new ИсклОжидания("Wait failed");
	}
      } else {
	iobj.monitor.__m_count = RecursionCount;
      }
    }

    проц уведоми() {
      pthread_cond_signal(cond);
    }

  }

  struct ЖдиСообщиВсемРеализ {
    ЖдиСообщиРеализ wnlock;
    проц иниц() {
      wnlock.иниц();
    }
    проц разрушь() {
      wnlock.разрушь();
    }
    проц жди(Объект объ) {
      wnlock.жди(объ);
    }
    проц жди(Объект объ, бцел таймаут) {
      wnlock.жди(объ,таймаут);
    }
    проц уведомиВсех() {
      pthread_cond_broadcast(wnlock.cond);
    }
  }

  private {
    struct timespec {
      time_t tv_sec;		/* Seconds.  */
      цел tv_nsec;		/* Nanoseconds.  */
    }
    /* from bits/pthreadtypes.h */
    struct pthread_mutex_t {
      цел __m_reserved;       
      цел __m_count;          
      // ignore the rest
    };

    /* D Объект layout puts monitor after vtbl */
    struct InternalObjectRep {
      проц* vtbl;
      pthread_mutex_t* monitor;
    }
    const цел ETIMEDOUT = 110; // from errno.h
    extern (C) {
      цел pthread_cond_init(проц* cond, проц* attr);
      цел pthread_cond_destroy(проц* cond);
      цел pthread_cond_wait(проц* cond, проц* мютекс);
      цел pthread_cond_timedwait(проц* cond, проц* мютекс, timespec* abstime);
      цел pthread_cond_signal(проц* cond);
      цел pthread_cond_broadcast(проц* cond);
    }
  }
}

/* Internal D functions to aquire/отпусти object monitor */
private {
  extern (C) проц _d_monitorexit(проц* h);
  extern (C) проц _d_monitorenter(проц* h);
}


/////////////////////////////////////////////////////////
//
//  Platform-independent API for ЖдиУведоми and ЖдиУведомиВсех
//
/////////////////////////////////////////////////////////


/** \class ЖдиУведоми
 * \brief Mixin for supporting жди() and уведоми() synchronization.
 * 
 *  ЖдиУведоми adds support for Java-style жди() and уведоми()
 *  methods. It is similar also to POSIX threading functions cond_wait
 *  and cond_signal.
 *
 *  An example of a class using ЖдиУведоми:
 *  \code
 *    class A {
 *      mixin ЖдиУведоми;
 *      бул done;
 *      this()  { иницЖдиУведоми(); }
 *      ~this() { удалиЖдиУведоми(); }
 *      проц doSomething1() {
 *        synchronized(this) {
 *          ...
 *          while (!done)
 *            жди();
 *          ...
 *        }
 *      }
 *      проц doSomething2() {
 *        synchronized(this) {
 *          ...
 *          done = да;
 *          уведоми();
 *          ...
 *        }
 *      }
 *    }
 *  \endcode
 */
template ЖдиУведоми() {

  ЖдиСообщиРеализ waitNotifyImpl;

  /** Initialize ЖдиУведоми
   */
  проц иницЖдиУведоми() {
    waitNotifyImpl.иниц();
  }

  /** Destroy ЖдиУведоми
   */
  проц удалиЖдиУведоми() {
    waitNotifyImpl.разрушь();
  }

  /** Causes current нить to жди until another нить invokes the уведоми() method.
   *
   * Causes current нить to жди until another нить invokes the
   * уведоми() method method for this замок.
   *
   * The current нить must own the object's monitor. The
   * нить releases ownership of the monitor and waits until another
   * нить notifies threads ждущий on this замок to wake up through a
   * call to the уведоми method. The нить then waits until it can
   * re-obtain ownership of the monitor and resumes execution.
   *
   * This method should only be called by a нить that is the owner
   * of the object's monitor. See the уведоми method for a description
   * of the ways in which a нить can become the owner of a monitor.
   */
  проц жди() {
    waitNotifyImpl.жди(this);
  }


  /** Causes current нить to жди until another нить invokes the уведоми() method.
   *
   * Causes current нить to жди until either another нить invokes
   * the уведоми() method method for this замок, or a specified количество
   * of время has elapsed.
   *
   * The current нить must own the object's monitor. 
   *
   * This method should only be called by a нить that is the owner
   * of the object's monitor. See the уведоми method for a description
   * of the ways in which a нить can become the owner of a monitor.
   *
   * \param бцел таймаут maximum время to жди in milliseconds
   */
  проц жди(бцел таймаут) {
    waitNotifyImpl.жди(this,таймаут);
  }

  /** Wakes up a single нить that is ждущий on this object.
   *
   *  If any threads are ждущий on this замок, one of
   *  them is chosen to be awakened. The choice is arbitrary and
   *  occurs at the discretion of the implementation. A нить waits
   *  on this замок by calling one of the жди methods.
   *
   *  The awakened нить will not be able to proceed until the
   *  current нить relinquishes the замок on the object. The
   *  awakened нить will compete in the usual manner with any
   *  другое threads that might be actively competing to synchronize
   *  on the object; for example, the awakened нить enjoys no
   *  reliable privilege or disadvantage in being the следщ нить to
   *  замок the object.
   *
   *  This method should only be called by a нить that is the
   *  owner of the object's monitor.
   */
  проц уведоми() {
    waitNotifyImpl.уведоми();
  }

}

/** \class ОбъектЖдиУведоми
 * \brief Subclass of Объект with жди() and уведоми() support.
 */
class ОбъектЖдиУведоми {
  mixin ЖдиУведоми;
  this()  { иницЖдиУведоми(); }
  ~this() { удалиЖдиУведоми(); }
}

/** \class ЖдиУведомиВсех
 * \brief Mixin for supporting жди() and уведомиВсех() synchronization.
 * 
 *  ЖдиУведомиВсех adds support for Java-style жди() and уведомиВсех()
 *  methods. It is similar also to POSIX threading functions cond_wait
 *  and cond_broadcast.
 */
template ЖдиУведомиВсех() {
  ЖдиСообщиВсемРеализ waitNotifyAllImpl;

  /** Initialize ЖдиУведомиВсех
   */
  проц иницЖдиУведомиВсех() { 
    waitNotifyAllImpl.иниц(); 
  }

  /** Destroy ЖдиУведомиВсех
   */
  проц удалиЖдиУведомиВсех() { 
    waitNotifyAllImpl.разрушь(); 
  }

  /**  Causes current нить to жди until another нить invokes the уведомиВсех() method.
   *
   *  Same semantics as ЖдиУведоми.жди except that уведомиВсех
   *  will wake up all ждущий threads.
   */
  проц жди() {
    waitNotifyAllImpl.жди(this);
  }

  /**  Causes current нить to жди until another нить invokes the уведомиВсех() method.
   *
   *  Same semantics as ЖдиУведоми.жди except that уведомиВсех
   *  will wake up all ждущий threads.
   *
   * \param бцел таймаут maximum время to жди in milliseconds
   */
  проц жди(бцел таймаут) {
    waitNotifyAllImpl.жди(this,таймаут);
  }

  /** Wakes up all threads that are ждущий on this object.
   *
   *  Same semantics as ЖдиУведоми.уведоми except that уведомиВсех
   *  will wake up all threads ждущий on this замок. The threads will
   *  compete with другое threads for the object monitor once this
   *  нить releases the monitor.
   */
  проц уведомиВсех() {
    waitNotifyAllImpl.уведомиВсех();
  }
}

/** \class ОбъектЖдиУведомиВсех
 * \brief Subclass of Объект with жди() and уведомиВсех() support.
 */
class ОбъектЖдиУведомиВсех {
  mixin ЖдиУведомиВсех;
  this()  { иницЖдиУведомиВсех(); }
  ~this() { удалиЖдиУведомиВсех(); }
}

unittest {

  class A {
    mixin ЖдиУведоми;
    бул done;
    this()  { иницЖдиУведоми(); }
    ~this() { удалиЖдиУведоми(); }

    synchronized проц doSomething1() {
      while (!done) {
	//	эхо("S1 ждущий\n");
	жди();
      }

      //return 0;
    }

    synchronized проц doSomething2() {
      done = да;
      //      эхо("S1 notifying\n");
      уведоми();
     // return 0;
    }
  } // A
	
  эхо("starting waitnotify unittest\n");
  A a = new A();
  Нить t1 = new Нить(&a.doSomething1);
  Нить t2 = new Нить(&a.doSomething2);
  t1.старт();
  t2.старт();

  t1.жди();
  t2.жди();
  //  delete a;  // causes errors with DMD on linux
  эхо("finished waitnotify unittest\n");
	
  assert(да);
}


