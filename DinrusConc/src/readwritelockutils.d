/* \file readwritelockutils.d
 * \brief A collection of ЧЗЗамок implementations that 
 * are useful in special situations.
 */

/*
  Originally written by Doug Lea and released into the public domain.
  This may be used for any purposes whatsoever without acknowledgment.
  Thanks for the assistance and support of Sun Microsystems Labs,
  and everyone contributing, testing, and using this code.
  Translated to D by Ben Hinkle 2004.
*/

module conc.readwritelockutils;

import conc.readwritelock, conc.sync;

private import conc.waitnotify;
private import conc.fifosemaphore;
private import cidrus;

private import thread:Нить; // for unittest

/** \class ЧЗЗамокПВПВ
 * \brief This class implements a policy for reader/writer locks in which
 * threads contend in a First-in/First-out manner for access (modulo
 * the limitations of СемафорПВПВ, which is used for queuing).  
 *
 * This policy does not particularly favor читатели or writers.  As a
 * byproduct of the FIFO policy, the <tt>пытайся</tt> methods may
 * return <tt>нет</tt> even when the замок might logically be
 * available, but, due to contention, cannot be accessed within the
 * given время bound.  <p>
 *
 * This замок is <em>NOT</em> reentrant. Current читатели and
 * writers should not try to re-obtain locks while holding them.
 * <p>
 *
 */

class ЧЗЗамокПВПВ : ОбъектЖдиУведоми, ЧЗЗамок {

  /** 
   * Fair Семафор serving as a kind of mutual exclusion замок.
   * Writers обрети on entry, and hold until rwlock exit.
   * Readers обрети and отпусти only during entry (but are
   * blocked from doing so if there is an active writer).
   */
  protected  СемафорПВПВ замокЗап;

  /** 
   * Number of threads that have entered read замок.  Note that this is
   * never reset to zero. Incremented only during acquisition of read
   * замок while the "замокЗаписи" is held, but read elsewhere, so is
   * declared volatile.
   */
  protected цел читатели;

  /** 
   * Number of threads that have exited read замок.  Note that this is
   * never reset to zero. Accessed only in code protected by
   * synchronized(this). When эксчитатели != читатели, the rwlock is
   * being used for reading. Else if the entry замок is held, it is
   * being used for writing (or in transition). Else it is free.
   * Note: To distinguish these states, we assume that fewer than 2^32
   * reader threads can simultaneously выполни.
   */
  protected цел эксчитатели;

  this() {
    замокЗап = new СемафорПВПВ(1);
    синхЧитатель = new СинхЧитатель(this);
    синхПисатель = new СинхПисатель(this);
  }

  ~this() {
    delete замокЗап;
  }

  protected проц обретиЧтение() {
    замокЗап.обрети();
    volatile {
      ++читатели;
    } 
    замокЗап.отпусти();
  }

  protected synchronized проц отпустиЧтение() {
    /*
      If this is the last reader, уведоми a possibly ждущий writer.
      Because waits occur only when entry замок is held, at most one
      writer can be ждущий for this notification.  Because increments
      to "читатели" aren't protected by "this" замок, the notification
      may be spurious (when an incoming reader in in the process of
      updating the field), but at the point tested in acquiring write
      замок, both locks will be held, thus avoiding нет alarms. And
      we will never miss an opportunity to send a notification when it
      is actually needed.
    */
    volatile {
      if (++эксчитатели == читатели) 
	уведоми(); 
    }
  }

  protected проц обретиЗапись() {
    // Acquiring замокЗап первое forces subsequent entering читатели
    // (as well as writers) to block.
    замокЗап.обрети();
    
    // Only read "читатели" once now before loop.  We know it won't
    // change because we hold the entry замок needed to update it.
    цел r;
    volatile {
      r = читатели;
    }
    
    try {
      synchronized(this) {
        while (эксчитатели != r) 
          жди();
      }
    }
    catch (ИсклОжидания ie) {
      замокЗап.отпусти();
      throw ie;
    }
  }

  protected проц отпустиЗапись() {
    замокЗап.отпусти();
  }

  protected бул пытайсяЧитать(дол мсек) {
    if (!замокЗап.пытайся(мсек)) 
      return нет;

    volatile {
      ++читатели;
    } 
    замокЗап.отпусти();
    return да;
  }

  protected бул пытайсяПисать(дол мсек) {
    дол времяСтарта = (мсек <= 0)? 0 : clock();

    if (!замокЗап.пытайся(мсек)) 
      return нет;

    цел r = читатели;

    try {
      synchronized(this) {
        while (эксчитатели != r) {
          дол остаток_времени = (мсек <= 0)? 0:
            мсек - (clock() - времяСтарта);
          
          if (остаток_времени <= 0) {
            замокЗап.отпусти();
            return нет;
          }
          
          жди(остаток_времени);
        }
        return да;
      }
    }
    catch (ИсклОжидания ie) {
      замокЗап.отпусти();
      throw ie;
    }
  }

  // support for ЧЗЗамок interface

  protected class СинхЧитатель : Синх {
    ЧЗЗамокПВПВ объ;
    this(ЧЗЗамокПВПВ объ) {
      this.объ = объ;
    }
    проц обрети() {
      объ.обретиЧтение();
    }
    проц отпусти() {
      объ.отпустиЧтение();
    }
    бул пытайся(дол мсек) {
      return объ.пытайсяЧитать(мсек);
    }
  }

  protected class СинхПисатель : Синх {
    ЧЗЗамокПВПВ объ;
    this(ЧЗЗамокПВПВ объ) {
      this.объ = объ;
    }
    проц обрети() {
      объ.обретиЗапись();
    }
    проц отпусти()  { 
      объ.отпустиЗапись();
    }
    бул пытайся(дол мсек) {
      return объ.пытайсяПисать(мсек);
    }
  }

  protected  Синх синхЧитатель;
  protected  Синх синхПисатель;

  Синх замокЗаписи() { return синхПисатель; }
  Синх замокЧтения() { return синхЧитатель; }

  unittest {
    class Test {
      ЧЗЗамокПВПВ rw;
      цел x;
      this() { rw = new ЧЗЗамокПВПВ(); }
      ~this() { delete rw; }
      проц read() {
	rw.замокЧтения().обрети();
	try {
	  эхо("x is %d\n",x);
	}
	finally {
	  rw.замокЧтения().отпусти();
	}
      }
      проц write() {
	rw.замокЗаписи().обрети();
	try {
	  // ... do the write
	  x++;
	}
	finally {
	  rw.замокЗаписи().отпусти();
	}
      }
    }
    эхо("starting ЧЗЗамокПВПВ unittest\n");
    Test x = new Test;
    x.write();
    x.read();
    delete x;
    эхо("finished ЧЗЗамокПВПВ unittest\n");
  }
}

/** \class ВозобновляемыйЧЗЗамокПредпочтенияПисателя
 * \brief A writer-preference ЧЗЗамок that allows both читатели and 
 * writers to reacquire
 * read or write locks in the style of a ВозобновляемыйЗамок.
 *
 * Readers are not allowed until all write locks held by
 * the writing нить have been released.
 * Among другое applications, reentrancy can be useful when
 * write locks are held during calls or callbacks to methods that perform
 * reads under read locks.
 * <p>
 * <b>Sample usage</b>. Here is a code sketch showing how to exploit
 * reentrancy to perform замок downgrading after updating a cache:
 * <pre>
 * class CachedData {
 *   Объект data;
 *   бул cacheValid;
 *   ВозобновляемыйЧЗЗамокПредпочтенияПисателя rwl = ...
 *
 *   проц processCachedData() {
 *     rwl.замокЧтения().обрети();
 *     if (!cacheValid) {
 *
 *        // upgrade замок:
 *        rwl.замокЧтения().отпусти();   // must отпусти первое to obtain writelock
 *        rwl.замокЗаписи().обрети();
 *        if (!cacheValid) { // перепроверь
 *          data = ...
 *          cacheValid = да;
 *        }
 *        // downgrade замок
 *        rwl.замокЧтения().обрети();  // reacquire read without giving up замок
 *        rwl.замокЗаписи().отпусти(); // отпусти write, still hold read
 *     }
 *
 *     use(data);
 *     rwl.замокЧтения().отпусти();
 *   }
 * }
 * </pre>
 *
 * 
 */
class ВозобновляемыйЧЗЗамокПредпочтенияПисателя : ЧЗЗамокПредпочтенияПисателя {

  /** Number of acquires on write замок by активныеПисатели_ нить **/
  protected дол задержкиЗаписи_ = 0;  

  /** Number of acquires on read замок by any reader нить **/
  protected цел[Нить] читатели_;

  protected бул позволитьЧитателю() {
    return (активныеПисатели_ is пусто && ждущиеПисатели_ == 0) ||
      активныеПисатели_ is Нить.дайЭту();
  }

  protected synchronized бул стартЧтения() {
    Нить t = Нить.дайЭту();
    if (t in читатели_) { // already held -- just increment hold счёт
      читатели_[t] = читатели_[t]+1;
      ++активныеЧитатели_;
      return да;
    }
    else if (позволитьЧитателю()) {
      читатели_[t] = 1;
      ++активныеЧитатели_;
      return да;
    }
    else
      return нет;
  }

  protected synchronized бул стартЗаписи() {
    if (активныеПисатели_ is Нить.дайЭту()) { // already held; re-обрети
      ++задержкиЗаписи_;
      return да;
    }
    else if (задержкиЗаписи_ == 0) {
      if (активныеЧитатели_ == 0 || 
          (читатели_.length == 1 && 
           Нить.дайЭту() in читатели_)) {
        активныеПисатели_ = Нить.дайЭту();
        задержкиЗаписи_ = 1;
        return да;
      }
      else
        return нет;
    }
    else
      return нет;
  }


  protected synchronized Сигналист конецЧтения() {
    Нить t = Нить.дайЭту();
    цел c = читатели_[t];
    --активныеЧитатели_;
    if (c != 1) { // more than one hold; decrement счёт
      читатели_[t] = c-1;
      return пусто;
    }
    else {
      читатели_.remove(t);
    
      if (задержкиЗаписи_ > 0) // a write замок is still held by current нить
        return пусто;
      else if (активныеЧитатели_ == 0 && ждущиеПисатели_ > 0)
        return замокПисателя_;
      else
        return пусто;
    }
  }

  protected synchronized Сигналист конецЗаписи() {
    --задержкиЗаписи_;
    if (задержкиЗаписи_ > 0)   // still being held
      return пусто;
    else {
      активныеПисатели_ = пусто;
      if (ждущиеЧитатели_ > 0 && позволитьЧитателю())
        return замокЧитателя_;
      else if (ждущиеПисатели_ > 0)
        return замокПисателя_;
      else
        return пусто;
    }
  }
  unittest {
    class Test2 {
      ВозобновляемыйЧЗЗамокПредпочтенияПисателя rw;
      цел x;
      this() { rw = new ВозобновляемыйЧЗЗамокПредпочтенияПисателя(); }
      ~this() { delete rw; }
      проц read() {
	rw.замокЧтения().обрети();
	try {
	  эхо("x is %d\n",x);
	}
	finally {
	  rw.замокЧтения().отпусти();
	}
      }
      проц write() {
	rw.замокЗаписи().обрети();
	try {
	  // ... do the write
	  x++;
	}
	finally {
	  rw.замокЗаписи().отпусти();
	}
      }
    }
    эхо("starting ВозобновляемыйЧЗЗамокПредпочтенияПисателя unittest\n");
    Test2 x = new Test2;
    x.write();
    x.read();
    delete x;
    эхо("finished ВозобновляемыйЧЗЗамокПредпочтенияПисателя unittest\n");
  }

}

/** \class ЧЗЗамокПредпочтенияЧитателя
 * \brief A ЧЗЗамок that prefers ждущий читатели over
 * ждущий writers when there is contention. 
 *
 * The range of applicability of this class is very limited. In the
 * majority of situations, writer preference locks provide more
 * reasonable semantics.
 * 
 */
class ЧЗЗамокПредпочтенияЧитателя : ЧЗЗамокПредпочтенияПисателя {
  protected бул позволитьЧитателю() {
    return активныеПисатели_ is пусто;
  }
}

