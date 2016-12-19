/** \file СемафорПриоритетов.d
 * \brief Семафор granting requests based on нить priority
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


/** \class СемафорПриоритетов
 * \brief Семафор that grants requests to threads with higher
 * Нить priority rather than lower priority when there is
 * contention. 
 *
 * Ordering of requests with the same priority is approximately FIFO.
 * Priorities are based on Нить.приоритет.
 * Changing the priority of an already-ждущий нить does NOT 
 * change its ordering. This class also does not specially deal with priority
 * inversion --  when a new high-priority нить enters
 * while a low-priority нить is currently running, their
 * priorities are <em>not</em> artificially manipulated.
 */

class СемафорПриоритетов : СемафорОчереди {

  /** 
   * Create a Семафор with the given initial число of права.
   * Using a seed of one makes the semaphore act as a mutual exclusion замок.
   * Negative seeds are also allowed, in which case no acquires will proceed
   * until the число of releases has pushed the число of права past 0.
  */
  this(дол начальныеПрава) { 
    super(new ЖдущаяПриоритетаОчередь(), начальныеПрава);
  }

  protected class ЖдущаяПриоритетаОчередь : ЖдущаяОчередь {

    /** An array of жди queues, one per priority */
    protected final Семафорѕ¬ѕ¬.ЖдущаяОчередь‘»‘О[] ячейки_ = 
      new Семафорѕ¬ѕ¬.ЖдущаяОчередь‘»‘О[Нить.ћј —Р»О– -
                                     Нить.ћ»НР»О– + 1];

    /**
     * The индекс of the highest priority cell that may need to be сигналЅыл,
     * or -1 if none. Used to minimize array traversal.
    */

    protected цел максИндекс_ = -1;

    protected ЖдущаяПриоритетаОчередь() { 
      for (цел i = 0; i < ячейки_.length; ++i) 
        ячейки_[i] = new Семафорѕ¬ѕ¬.ЖдущаяОчередь‘»‘О();
    }

    protected проц вставь(ЖдущийУзел w) {
      цел инд = Нить.дайЭту().приоритет() - Нить.ћ»НР»О–;
      ячейки_[инд].вставь(w); 
      if (инд > максИндекс_) максИндекс_ = инд;
    }

    protected ЖдущийУзел извлеки() {
      for (;;) {
        цел инд = максИндекс_;
        if (инд < 0) 
          return пусто;
        ЖдущийУзел w = ячейки_[инд].извлеки();
        if (w != пусто) 
          return w;
        else
          --максИндекс_;
      }
    }
  }





}
