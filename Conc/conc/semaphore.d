/** \file semaphore.d
 * \brief Counting semaphore
 */

/*
	 Originally written by Doug Lea and released into the public domain.
	 This may be used for any purposes whatsoever without acknowledgment.
	 Thanks for the assistance and support of Sun Microsystems Labs,
	 and everyone contributing, testing, and using this code.
	 Translated to D by Ben Hinkle 2004.
 */

module conc.semaphore;

import conc.sync;

private import conc.waitnotify;
private import cidrus;

private import stdrus:Нить; // for unittest

/** \class Семафор
 * \brief Base class for counting semaphores.
 *
 * Conceptually, a semaphore maintains a установи of права.
 * Each обрети() blocks if necessary
 * until a permit is available, and then takes it. 
 * Each отпусти adds a permit. However, no actual permit объекты
 * are used; the Семафор just keeps a счёт of the число
 * available and acts accordingly.
 * 
 * A semaphore initialized to 1 can serve as a mutual exclusion
 * замок. 
 * 
 * Different implementation subclasses may provide different
 * ordering guarantees (or lack thereof) surrounding which
 * threads will be resumed upon a сигнал.
 * 
 * The default implementation makes NO 
 * guarantees about the order in which threads will 
 * обрети права. It is often faster than другое implementations.
 * 
 * <b>Sample usage.</b> Here is a class that uses a semaphore to
 * help manage access to a pool of items.
 * \code
 * class Pool {
 *   static final MAX_AVAILABLE = 100;
 *   private final Семафор available = new Семафор(MAX_AVAILABLE);
 *   
 *   public Объект getItem() throws ИсклОжидания { // no synch
 *     available.обрети();
 *     return getNextAvailableItem();
 *   }
 *
 *   public проц putItem(Объект x) { // no synch
 *     if (markAsUnused(x))
 *       available.отпусти();
 *   }
 *
 *   // Not a particularly efficient data structure; just for demo
 *
 *   protected Объект[] items = ... whatever kinds of items being managed
 *   protected бул[] used = new бул[MAX_AVAILABLE];
 *
 *   protected synchronized Объект getNextAvailableItem() { 
 *     for (цел i = 0; i < MAX_AVAILABLE; ++i) {
 *       if (!used[i]) {
 *          used[i] = да;
 *          return items[i];
 *       }
 *     }
 *     return пусто; // not reached 
 *   }
 *
 *   protected synchronized бул markAsUnused(Объект элт) { 
 *     for (цел i = 0; i < MAX_AVAILABLE; ++i) {
 *       if (элт == items[i]) {
 *          if (used[i]) {
 *            used[i] = нет;
 *            return да;
 *          }
 *          else
 *            return нет;
 *       }
 *     }
 *   }
 *   return нет;
 *
 * }
 * \endcode
 * 
 */
class Семафор : ОбъектЖдиУведоми, Синх  {
  protected дол права_; ///< current число of available права

  /** 
   * Create a Семафор with the given initial число of права.
   * Using a seed of one makes the semaphore act as a mutual exclusion замок.
   * Negative seeds are also allowed, in which case no acquires will proceed
   * until the число of releases has pushed the число of права past 0.
   */
  this(дол начальныеПрава) {
    права_ = начальныеПрава;
  }

  /** Wait until a permit is available, and возьми one */
  synchronized проц обрети() {
    try {
      while (права_ <= 0) жди();
      --права_;
    }
    catch (ИсклОжидания искл) {
      уведоми();
      throw искл;
    }
  }

  /** Wait at most мсек millisconds for a permit. */
  synchronized бул пытайся(дол мсек) {
    if (права_ > 0) { 
      --права_;
      return да;
    }
    else if (мсек <= 0)   
      return нет;
    else {
      try {
	дол времяСтарта = clock();
	дол времяОжидания = мсек;

	for (;;) {
	  жди(времяОжидания);
	  if (права_ > 0) {
	    --права_;
	    return да;
	  }
	  else { 
	    времяОжидания = мсек - (clock() - времяСтарта);
	    if (времяОжидания <= 0) 
	      return нет;
	  }
	}
      }
      catch(ИсклОжидания искл) { 
	уведоми();
	throw искл;
      }
    }
  }


  /** 
   * Release N права. <code>отпусти(n)</code> is
   * equivalent in effect to:
   * \code
   *   for (цел i = 0; i < n; ++i) отпусти();
   * \endcode
   * <p>
   * But may be more efficient in some semaphore implementations.
   */
   
  проц отпусти(дол n) 
    in {
    assert( n >= 0 );
  }
  body {
    права_ += n;
    for (дол i = 0; i < n; ++i) уведоми();
  }

    /** Release a permit */
  synchronized проц отпусти() {
    ++права_;
    уведоми();
  }

  
  /**
   * Return the current число of available права.
   * Returns an accurate, but possibly unstable значение,
   * that may change immediately after returning.
   */
  synchronized дол права() {
    return права_;
  }
/+
  unittest {
    Семафор sem = new Семафор(2);
    цел done = 0;
    Нить[] t = new Нить[6];
    цел f() {
      цел n;
      Нить tt = Нить.дайЭту();
      for (n=0; n < t.length; n++) {
	if (tt is t[n])
	  break;
      }
      эхо(" нить %d started\n",n);
      sem.обрети();
      эхо(" нить %d aquired\n",n);
      эхо(" нить %d terminating\n",n);
      return 0;
    }
    цел f2() {
      цел n;
      Нить tt = Нить.дайЭту();
      for (n=0; n < t.length; n++) {
	if (tt is t[n])
	  break;
      }
      эхо(" нить %d releasing\n",n);
      sem.отпусти();
      эхо(" нить %d terminating\n",n);
      return 0;
    }
    цел n;
    for (n=0; n<t.length/2; n++) {
      t[n] = new Нить(&f);
    }
    for (; n<t.length; n++) {
      t[n] = new Нить(&f2);
    }
    эхо("starting semaphore unittest\n");
    for (n=0; n<t.length/2; n++) {
      t[n].старт();
    }
    Нить.рви();
    for (; n<t.length; n++) {
      t[n].старт();
      Нить.рви();
    }

    foreach(цел n, Нить нить; t)
      {
	эхо(" ждущий on %d\n", n);
	нить.жди();
      }

    эхо("finished semaphore unittest\n");
    delete sem;
    t[] = пусто;
  }
+/
  }

