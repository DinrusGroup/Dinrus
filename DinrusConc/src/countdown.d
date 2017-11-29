/* \file countdown
 * \brief A latch that fires after a specified счёт
 */

/*
  Originally written by Doug Lea and released into the public domain.
  This may be used for any purposes whatsoever without acknowledgment.
  Thanks for the assistance and support of Sun Microsystems Labs,
  and everyone contributing, testing, and using this code.
*/

module conc.countdown;

import conc.sync;

private import conc.waitnotify;
private import cidrus;

private import thread; // for unittest

/** \class ОбратныйОтсчёт
 * \brief A ОбратныйОтсчёт can serve as a simple one-shot барьер. 
 *
 * A Countdown is initialized
 * with a given счёт значение. Each отпусти decrements the счёт.
 * All acquires block until the счёт reaches zero. Upon reaching
 * zero all current acquires are unblocked and all 
 * subsequent acquires пасс without blocking. This is a one-shot
 * phenomenon -- the счёт cannot be reset. 
 * If you need a version that resets the счёт, consider
 * using a Барьер.
 * <p>
 * <b>Sample usage.</b> Here are a установи of классы in which
 * a group of worker threads use a countdown to
 * уведоми a driver when all threads are complete.
 * \code
 * class Работяга { 
 *   private final ОбратныйОтсчёт done;
 *   this(ОбратныйОтсчёт d) { done = d; }
 *   цел пуск() {
 *     doWork();
 *    done.отпусти();
 *   }
 * }
 * 
 * проц test() {
 *   ОбратныйОтсчёт done = new ОбратныйОтсчёт(N);
 *   for (цел i = 0; i < N; ++i) {
 *     Работяга w = new Работяга(done);
 *     new Нить(&w.пуск).старт();
 *   }
 *   for (цел k=0;k<10000; k++){}
 *   done.обрети(); // жди for all to finish
 * }
 * \endcode
 *
 */

class ОбратныйОтсчёт : ОбъектЖдиУведомиВсех, Синх {
  protected final цел начальнСчёт_;
  protected цел счёт_;

  /** Create a new ОбратныйОтсчёт with given счёт значение */
  this(цел счёт) { 
    счёт_ = начальнСчёт_ = счёт; 
  }

  /*
    This could use double-check, but doesn't out of concern
    for surprising effects on user programs stemming
    from lack of memory barriers with lack of synch.
  */
  synchronized проц обрети() {
    while (счёт_ > 0) 
      жди();
  }


  synchronized бул пытайся(дол мсек) {
    if (счёт_ <= 0) 
      return да;
    else if (мсек <= 0) 
      return нет;
    else {
      дол времяОжидания = мсек;
      дол старт = clock();
      for (;;) {
	жди(времяОжидания);
	if (счёт_ <= 0) 
	  return да;
	else {
	  времяОжидания = мсек - (clock() - старт);
	  if (времяОжидания <= 0) 
	    return нет;
	}
      }
    }
  }

  /**
   * Decrement the счёт.
   * After the начальныйСчёт'th отпусти, all current and future
   * acquires will пасс
   */
  synchronized проц отпусти() {
    if (--счёт_ == 0) 
      уведомиВсех();
  }

  /** Return the initial счёт значение */
  цел начальныйСчёт() { return начальнСчёт_; }

  /** 
   * Return the current счёт значение.
   * This is just a snapshot значение, that may change immediately
   * after returning.
   */
  synchronized цел текущийСчёт() { return счёт_; }

  unittest {
  
    class Работяга { 
      private final ОбратныйОтсчёт done;
      this(ОбратныйОтсчёт d) { done = d; }
      цел пуск() {
	эхо("counting down...\n");
	for (цел k=0;k<10000; k++){}
	done.отпусти();
	return 0;
      }
    }
    цел N = 5;
    эхо("starting countdown unittest\n");
    ОбратныйОтсчёт done = new ОбратныйОтсчёт(N);
    for (цел i = 0; i < N; ++i) {
      Работяга w = new Работяга(done);
      Нить t = new Нить(&w.пуск);
      t.старт();
    }
    for (цел k=0;k<10000; k++){}
    done.обрети(); // жди for all to finish
    эхо("finished countdown unittest\n");
  }
}

