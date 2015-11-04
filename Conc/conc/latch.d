/* \file latch.d
 * \brief A condition that is acquirable forever after the первое время.
 */

/*
  Originally written by Doug Lea and released into the public domain.
  This may be used for any purposes whatsoever without acknowledgment.
  Thanks for the assistance and support of Sun Microsystems Labs,
  and everyone contributing, testing, and using this code.
  Translated to D by Ben Hinkle 2004.
*/

module conc.latch;

import conc.sync;

private import conc.waitnotify;
private import cidrus;

private import stdrus:Нить; // for unittest

/** \class Щеколда
 * \brief A latch is a бул condition that is установи at most once, ever.
 * Once a single отпусти is issued, all acquires will пасс.
 *
 * <b>Sample usage.</b> Here are a установи of классы that use
 * a latch as a старт сигнал for a group of worker threads that
 * are created and started beforehand, and then later активен.
 * \code
 * class Работяга implements Пускаемый {
 *   private final Щеколда startSignal;
 *   Работяга(Щеколда l) { startSignal = l; }
 *    цел пуск() {
 *      startSignal.обрети();
 *      for (цел =0; i<10000; i++){} // do something
 *      эхо(" нить done\n");
 *      return 0;
 *   }
 * }
 *
 * class Driver { // ...
 *   проц main() {
 *     Щеколда go = new Щеколда();
 *     for (цел i = 0; i < N; ++i) {// make threads
 *       Работяга w = new Работяга(go);
 *       new Нить(&w.пуск).старт();
 *     }
 *     эхо("pausing\n");
 *     for (цел i=0; i<10000; i++) {} // pause
 *     эхо("let go\n");
 *     go.отпусти();              // let all threads proceed
 *   } 
 * }
 * \endcode
 */  

class Щеколда : ОбъектЖдиУведомиВсех, Синх {
  protected бул защёлкнут_ = нет;

  /*
    This could use double-check, but doesn't.
    If the latch is being used as an indicator of
    the presence or state of an object, the user would
    not necessarily дай the memory барьер that comes with synch
    that would be needed to correctly use that object. This
    would lead to errors that users would be very hard to track down. So, to
    be conservative, we always use synch.
  */

  synchronized проц обрети() {
    while (!защёлкнут_) 
      жди(); 
  }

  synchronized бул пытайся(дол мсек) {
    if (защёлкнут_) 
      return да;
    else if (мсек <= 0) 
      return нет;
    else {
      дол времяОжидания = мсек;
      дол старт = clock();
      for (;;) {
	жди(времяОжидания);
	if (защёлкнут_) 
	  return да;
	else {
	  времяОжидания = мсек - (clock() - старт);
	  if (времяОжидания <= 0) 
	    return нет;
	}
      }
    }
  }

  /** Enable all current and future acquires to пасс */
  synchronized проц отпусти() {
    защёлкнут_ = да;
    уведомиВсех();
  }

  unittest {
    class Работяга {
      private final Щеколда startSignal;
      this(Щеколда l) { startSignal = l; }
      цел пуск() {
	startSignal.обрети();
	эхо(" нить done\n");
	return 0;
      }
    }
 
    эхо("starting latch unittest\n");
    Щеколда go = new Щеколда();
    for (цел i = 0; i < 10; ++i) {// make threads
      Работяга w = new Работяга(go);
      Нить t = new Нить(&w.пуск);
      t.старт();
    }
    эхо("threads started\n");
    for (цел i=0; i<10000; i++) {} // pause
    эхо("отпусти latch\n");
    go.отпусти();              // let all threads proceed
    for (цел i=0; i<100; i++) {
      Нить.рви();
    }
    эхо("finished latch unittest\n");
  }
}

