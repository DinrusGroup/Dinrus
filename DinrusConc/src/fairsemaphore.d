/** \file fairsemaphore.d
 * \brief Counting semaphore with enforced fairness
 */

/*
  Originally written by Doug Lea and released into the public domain.
  This may be used for any purposes whatsoever without acknowledgment.
  Thanks for the assistance and support of Sun Microsystems Labs,
  and everyone contributing, testing, and using this code.
  Translated to D by Ben Hinkle 2004.
*/

module conc.fairsemaphore;

import conc.semaphore;

private import conc.waitnotify, conc.sync;
private import cidrus;

private import thread; // for unittest


/** \class ЯсныйСемафор
 * \brief An implementation of counting Semaphores that
 *  enforces enough fairness for applications that
 *  need to avoid indefinite overtaking without
 *  necessarily requiring FIFO ordered access.
 *
 *  Empirically, very little is paid for this property
 *  unless there is a lot of contention among threads
 *  or very unfair native нить scheduling.
 *  The обрети method waits even if there are права
 *  available but have not yet been claimed by threads that have
 *  been notified but not yet resumed. This makes the semaphore
 *  almost as fair as the underlying primitives allow. 
 *  So, if synch замок entry and уведоми are both fair
 *  so is the semaphore -- almost:  Rewaits stemming
 *  from timeouts in пытайся, along with potentials for
 *  interrupted threads to be notified can compromise fairness,
 *  possibly allowing later-arriving threads to пасс before
 *  later arriving ones. However, in no case can a newly
 *  entering нить obtain a permit if there are still others ждущий.
 *  Also, signalling order need not coincide with
 *  resumption order. Later-arriving threads might дай права
 *  and continue before другое resumable threads are actually resumed.
 *  However, all of these potential fairness breaches are
 *  very rare in practice unless the underlying native threads
 *  performs strictly LIFO notifications in which case you need to use
 *  a СемафорПВПВ to maintain a reasonable approximation
 *  of fairness.
 * 
*/

final class ЯсныйСемафор : Семафор  {

  /** 
   * Create a Семафор with the given initial число of права.
  */
  this(дол initial) {  super(initial); }

  protected дол ждут_ = 0;   ///< Number of ждущий threads

  synchronized проц обрети() {
    /*
      Only возьми if there are more права than threads ждущий
      for права. This prevents infinite overtaking.
    */ 
    if (права_ > ждут_) { 
      --права_;
      return;
    }
    else { 
      ++ждут_;
      try { 
	for (;;) {
	  жди(); 
	  if (права_ > 0) {
	    --ждут_;
	    --права_;
	    return;
	  }
	}
      }
      catch(ИсклОжидания искл) { 
	--ждут_;
	уведоми();
	throw искл;
      }
    }
  }

  synchronized бул пытайся(дол мсек) {
    if (права_ > ждут_) { 
      --права_;
      return да;
    }
    else if (мсек <= 0)   
      return нет;
    else {
      ++ждут_;
        
      дол времяСтарта = clock();
      дол времяОжидания = мсек;
        
      try {
	for (;;) {
	  жди(времяОжидания);
	  if (права_ > 0) {
	    --ждут_;
	    --права_;
	    return да;
	  }
	  else { // got a время-out or нет-alarm уведоми
	    времяОжидания = мсек - (clock() - времяСтарта);
	    if (времяОжидания <= 0) {
	      --ждут_;
	      return нет;
	    }
	  }
	}
      }
      catch(ИсклОжидания искл) { 
	--ждут_;
	уведоми();
	throw искл;
      }
    }
  }

  synchronized проц отпусти() {
    ++права_;
    уведоми();
  }

  /** Release N права */
  synchronized проц отпусти(дол n) {
    права_ += n;
    for (дол i = 0; i < n; ++i) уведоми();
  }
/+
  unittest {
    ЯсныйСемафор sem = new ЯсныйСемафор(2);
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
      return 0;
    }
    цел n;
    for (n=0; n<t.length/2; n++) {
      t[n] = new Нить(&f);
    }
    for (; n<t.length; n++) {
      t[n] = new Нить(&f2);
    }
    эхо("starting fair semaphore unittest\n");
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

    эхо("finished fair semaphore unittest\n");
    delete sem;
    t[] = пусто;
  }
  +/
}

