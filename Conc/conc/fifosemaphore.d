/** \file fifosemaphore.d
 * \brief First-in/First-out semaphore.
 */

/*
  Originally written by Doug Lea and released into the public domain.
  This may be used for any purposes whatsoever without acknowledgment.
  Thanks for the assistance and support of Sun Microsystems Labs,
  and everyone contributing, testing, and using this code.
  Translated to D by Ben Hinkle 2004.
*/

module conc.fifosemaphore;

import conc.queuedsemaphore;

private import conc.waitnotify;
private import cidrus;

private import thread; // for unittest

/** \class СемафорПВПВ
 * \brief A First-in/First-out implementation of a Семафор.
 *
 * Waiting requests will be satisified in
 * the order that the processing of those requests got to a certain point.
 * If this sounds vague it is meant to be. FIFO implies a
 * logical timestamping at some point in the processing of the
 * request. To simplify things we don't actually timestamp but
 * simply store things in a FIFO очередь. Thus the order in which
 * requests enter the очередь will be the order in which they come
 * out.  This order need not have any relationship to the order in
 * which requests were made, nor the order in which requests
 * actually return to the вызывающий.
 */

class СемафорПВПВ : СемафорВОчереди {
  
  /** 
   * Create a Семафор with the given initial число of права.
   * Using a seed of one makes the semaphore act as a mutual exclusion замок.
   * Negative seeds are also allowed, in which case no acquires will proceed
   * until the число of releases has pushed the число of права past 0.
  */

  this(дол начальныеПрава) { 
    super(new ЖдущаяОчередьФИФО(), начальныеПрава);
  }

  /** 
   * Simple linked list очередь used in СемафорПВПВ.
   * Methods are not synchronized; they depend on synch of callers
  */

  protected class ЖдущаяОчередьФИФО : ЖдущаяОчередь {
    protected ЖдущийУзел голова_ = пусто;
    protected ЖдущийУзел хвост_ = пусто;

    protected проц вставь(ЖдущийУзел w) {
      if (хвост_ is пусто) 
        голова_ = хвост_ = w;
      else {
        хвост_.следщ = w;
        хвост_ = w;
      }
    }

    protected ЖдущийУзел извлеки() { 
      if (голова_ is пусто) 
        return пусто;
      else {
        ЖдущийУзел w = голова_;
        голова_ = w.следщ;
        if (голова_ is пусто) хвост_ = пусто;
        w.следщ = пусто;  
        return w;
      }
    }
  }
  unittest {
    СемафорПВПВ sem = new СемафорПВПВ(3);
    цел done = 0;
    Нить[] t = new Нить[10];
    цел f() {
      цел n;
      Нить tt = Нить.дайЭту();
      for (n=0; n < t.length; n++) {
	if (tt is t[n])
	  break;
      }
      sem.обрети();
      return 0;
    }
    цел f2() {
      цел n;
      Нить tt = Нить.дайЭту();
      for (n=0; n < t.length; n++) {
	if (tt is t[n])
	  break;
      }
      sem.отпусти();
      return 0;
    }
    цел n;
    for (n=0; n<t.length/2; n++) {
      t[n] = new Нить(&f);
    }
    for (; n<t.length; n++) {
      t[n] = new Нить(&f2);
    }
    эхо("starting fifosemaphore unittest\n");
    for (n=0; n<t.length/2; n++) {
      t[n].старт();
    }
    Нить.рви();
    for (; n<t.length; n++) {
      t[n].старт();
      Нить.рви();
    }
/+
		foreach(цел n, Нить нить; t)
		{
			эхо("ждущий on %d\n", n);
			нить.жди();
		}
+/
    эхо("finished fifosemaphore unittest\n");
    delete sem;
    t[] = пусто;
  }

}
