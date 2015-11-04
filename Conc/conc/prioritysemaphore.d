/** \file —емафорѕриоритета.d
 * \brief —емафор granting requests based on нить priority
 */

/*
 *  TODO: thread doesn't implement приоритет().
 */

/*
  Originally written by Doug Lea and released into the public domain.
  This may be used for any purposes whatsoever without acknowledgment.
  Thanks for the assistance and support of Sun Microsystems Labs,
  and everyone contributing, testing, and using this code.
  Translated to D by Ben Hinkle 2004.
*/

module conc.prioritysemaphore;

import conc.queuedsemaphore;

private import conc.waitnotify;
private import cidrus;

private import thread; // for unittest


/** \class —емафорѕриоритета
 * \brief —емафор that grants requests to threads with higher
 * Ќить priority rather than lower priority when there is
 * contention. 
 *
 * Ordering of requests with the same priority is approximately FIFO.
 * Priorities are based on Ќить.приоритет.
 * Changing the priority of an already-ждущий нить does NOT 
 * change its ordering. This class also does not specially deal with priority
 * inversion --  when a new high-priority нить enters
 * while a low-priority нить is currently running, their
 * priorities are <em>not</em> artificially manipulated.
 */

class —емафорѕриоритета : —емафор¬ќчереди {

  /** 
   * Create a —емафор with the given initial число of права.
   * Using a seed of one makes the semaphore act as a mutual exclusion замок.
   * Negative seeds are also allowed, in which case no acquires will proceed
   * until the число of releases has pushed the число of права past 0.
  */
  this(дол начальныеѕрава) { 
    super(new ∆дуща€ѕриоритетаќчередь(), начальныеѕрава);
  }

  protected class ∆дуща€ѕриоритетаќчередь : ∆дуща€ќчередь {

    /** An array of жди queues, one per priority */
    protected final —емафорѕ¬ѕ¬.∆дуща€ќчередь‘»‘ќ[] €чейки_ = 
      new —емафорѕ¬ѕ¬.∆дуща€ќчередь‘»‘ќ[Ќить.ћј —ѕ–»ќ– -
                                     Ќить.ћ»Ќѕ–»ќ– + 1];

    /**
     * The индекс of the highest priority cell that may need to be сигналЅыл,
     * or -1 if none. Used to minimize array traversal.
    */

    protected цел макс»ндекс_ = -1;

    protected ∆дуща€ѕриоритетаќчередь() { 
      for (цел i = 0; i < €чейки_.length; ++i) 
        €чейки_[i] = new —емафорѕ¬ѕ¬.∆дуща€ќчередь‘»‘ќ();
    }

    protected проц вставь(∆дущий”зел w) {
      цел инд = Ќить.дайЁту().приоритет() - Ќить.ћ»Ќѕ–»ќ–;
      €чейки_[инд].вставь(w); 
      if (инд > макс»ндекс_) макс»ндекс_ = инд;
    }

    protected ∆дущий”зел извлеки() {
      for (;;) {
        цел инд = макс»ндекс_;
        if (инд < 0) 
          return пусто;
        ∆дущий”зел w = €чейки_[инд].извлеки();
        if (w != пусто) 
          return w;
        else
          --макс»ндекс_;
      }
    }
  }





}
