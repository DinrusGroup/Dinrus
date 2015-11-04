/** \file queuedsemaphore.d
 * \brief Abstract semaphore with queued жди nodes.
 */

/*
  Originally written by Doug Lea and released into the public domain.
  This may be used for any purposes whatsoever without acknowledgment.
  Thanks for the assistance and support of Sun Microsystems Labs,
  and everyone contributing, testing, and using this code.
  Translated to D by Ben Hinkle 2004.
*/

module conc.queuedsemaphore;

import conc.semaphore;

private import conc.waitnotify, conc.sync;
private import cidrus;

private import stdrus:Нить; // for unittest

/** \class СемафорВОчереди
 * Abstract base class for semaphores relying on queued жди nodes.
 */
class СемафорВОчереди : Семафор {
  
  protected final ЖдущаяОчередь wq_;

  this(ЖдущаяОчередь q, дол начальныеПрава) { 
    super(начальныеПрава);  
    wq_ = q;
  }

  проц обрети() {
    if (предпроверь()) return;
    ЖдущийУзел w = new ЖдущийУзел();
    w.жди_ка(this);
  }

  бул пытайся(дол мсек) {
    if (предпроверь()) return да;
    if (мсек <= 0) return нет;

    ЖдущийУзел w = new ЖдущийУзел();
    return w.жди_каПоВремени(this, мсек);
  }

  protected synchronized бул предпроверь() {
    бул пасс = (права_ > 0);
    if (пасс) --права_;
    return пасс;
  }

  protected synchronized бул перепроверь(ЖдущийУзел w) {
    бул пасс = (права_ > 0);
    if (пасс) --права_;
    else      wq_.вставь(w);
    return пасс;
  }


  protected synchronized ЖдущийУзел дайСигнализатора() {
    ЖдущийУзел w = wq_.извлеки();
    if (w is пусто) ++права_; // if none, inc права for new arrivals
    return w;
  }

  проц отпусти() {
    for (;;) {
      ЖдущийУзел w = дайСигнализатора();
      if (w is пусто) return;  // no one to сигнал
      if (w.сигнал()) return; // уведоми if still ждущий, else skip
    }
  }

  /** Release N права */
  проц отпусти(дол n) 
  in {
    assert(n >= 0);
  }
  body {
    for (дол i = 0; i < n; ++i) отпусти();
  }

  /** 
   * Base class for internal очередь классы for semaphores, etc.
   * Relies on subclasses to actually implement очередь mechanics
   */
  interface ЖдущаяОчередь {
    проц вставь(ЖдущийУзел w);// assumed not to block
    ЖдущийУзел извлеки();     // should return пусто if empty
  }

}

class ЖдущийУзел : ОбъектЖдиУведоми {
  бул ждущий = да;
  ЖдущийУзел следщ = пусто;
  protected synchronized бул сигнал() {
    бул сигналБыл = да;
    if (сигналБыл) {
      ждущий = нет;
      уведоми();
    }
    return сигналБыл;
  }

  protected synchronized бул жди_каПоВремени(СемафорВОчереди sem, 
					  дол мсек)  {
    if (sem.перепроверь(this) || !ждущий) 
      return да;
    else if (мсек <= 0) {
      ждущий = нет;
      return нет;
    }
    else { 
      дол времяОжидания = мсек;
      дол старт = clock();

      try {
	for (;;) {
	  жди(времяОжидания);  
	  if (!ждущий)   // definitely сигналБыл
	    return да;
	  else { 
	    времяОжидания = мсек - (clock() - старт);
	    if (времяОжидания <= 0) { //  по_времени out
	      ждущий = нет;
	      return нет;
	    }
	  }
	}
      }
      catch(ИсклОжидания искл) {
	if (ждущий) { // no notification
	  ждущий = нет; // invalidate for the signaller
	  throw искл;
	}
      }
    }
  }

  protected synchronized проц жди_ка(СемафорВОчереди sem) {
    if (!sem.перепроверь(this)) {
      try {
	while (ждущий) жди();  
      }
      catch(ИсклОжидания искл) {
	if (ждущий) { // no notification
	  ждущий = нет; // invalidate for the signaller
	  throw искл;
	}
      }
    }
  }
}
