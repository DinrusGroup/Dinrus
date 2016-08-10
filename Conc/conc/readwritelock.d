/* \file readwritelock.d
 * \brief A pair of locks for managing читатели and writers with a
 * default implemenation that prefers writers over читатели.
 */

/*
  Originally written by Doug Lea and released into the public domain.
  This may be used for any purposes whatsoever without acknowledgment.
  Thanks for the assistance and support of Sun Microsystems Labs,
  and everyone contributing, testing, and using this code.
  Translated to D by Ben Hinkle 2004.
*/

module conc.readwritelock;

import conc.sync;

private import conc.waitnotify;
private import cidrus;
private import thread:Нить;

/** \class ЧЗЗамок
 * \brief  ReadWriteLocks maintain a pair of associated locks.
 * The замокЧтения may be held simultanously by multiple
 * reader stdrus:Нитьs, so дол as there are no writers. The замокЗаписи
 * is exclusive. 
 *
 * ReadWrite locks are generally preferable to
 * plain Синх locks or synchronized methods in cases where:
 * <ul>
 *   <li> The methods in a class can be cleanly separated into
 *        those that only access (read) data vs those that 
 *        modify (write).
 *   <li> Target applications generally have more читатели than writers.
 *   <li> The methods are relatively время-consuming (as a rough
 *        rule of thumb, exceed more than a hundred instructions), so it
 *        pays to introduce a bit more overhead associated with
 *        ReadWrite locks compared to simple synchronized methods etc
 *        in order to allow concurrency among reader stdrus:Нитьs.
 *        
 * </ul>
 * Different implementation классы differ in policies surrounding
 * which stdrus:Нитьs to prefer when there is
 * contention. By far, the most commonly useful policy is 
 * ЧЗЗамокПредпочтенияПисателя. The другое implementations
 * are targeted for less common, niche applications.
 *<p>
 * Standard usage:
 * <pre>
 * class X {
 *   ЧЗЗамок rw;
 *   // ...
 *
 *   проц read() { 
 *     rw.замокЧтения().обрети();
 *     try {
 *       // ... do the read
 *     }
 *     finally {
 *       rw.замокЧтения().отпусти();
 *     }
 *   }
 *
 *
 *   проц write() { 
 *     rw.замокЗаписи().обрети();
 *     try {
 *       // ... do the write
 *     }
 *     finally {
 *       rw.замокЗаписи().отпусти()
 *     }
 *   }
 * }
 * </pre>
 */

interface ЧЗЗамок {
  /** дай the замокЧтения **/
  Синх замокЧтения();

  /** дай the замокЗаписи **/
  Синх замокЗаписи();
}

/**  \class WriterReadWriteLock
 * \brief A ЧЗЗамок that prefers ждущий writers over
 * ждущий читатели when there is contention. 
 *
 * The locks are <em>NOT</em> reentrant. In particular,
 * even though it may appear to usually work OK,
 * a нить holding a read замок should not пытайся to
 * re-обрети it. Doing so risks lockouts when there are
 * also ждущий writers.
 */

class ЧЗЗамокПредпочтенияПисателя : ЧЗЗамок {

  protected дол активныеЧитатели_ = 0; 
  protected Нить активныеПисатели_ = пусто;
  protected дол ждущиеЧитатели_ = 0;
  protected дол ждущиеПисатели_ = 0;

  protected ЗамокЧитателя замокЧитателя_;
  protected ЗамокПисателя замокПисателя_;

  this() {
    замокЧитателя_ = new ЗамокЧитателя(this);
    замокПисателя_ = new ЗамокПисателя(this);
  }
  ~this() {
    delete замокЧитателя_;
    delete замокПисателя_;
  }

  Синх замокЗаписи() { return замокПисателя_; }
  Синх замокЧтения() { return замокЧитателя_; }

  /*
    A bunch of small synchronized methods are needed
    to allow communication from the Lock объекты
    back to this object, that serves as controller
  */

  protected synchronized проц отменённыйЖдущийЧитатель() { --ждущиеЧитатели_; }
  protected synchronized проц отменённыйЖдущийПисатель() { --ждущиеПисатели_; }

  /** Override this method to change to reader preference */
  protected бул позволитьЧитателю() {
    return активныеПисатели_ is пусто && ждущиеПисатели_ == 0;
  }

  protected synchronized бул стартЧтения() {
    бул allowRead = позволитьЧитателю();
    if (allowRead)  ++активныеЧитатели_;
    return allowRead;
  }

  protected synchronized бул стартЗаписи() {

    // The allowWrite expression cannot be modified without
    // also changing стартЗаписи, so is hard-wired

    бул allowWrite = (активныеПисатели_ is пусто && активныеЧитатели_ == 0);
    if (allowWrite)  активныеПисатели_ = Нить.дайЭту();
    return allowWrite;
   }


  /* 
     Each of these variants is needed to maintain atomicity
     of жди counts during жди loops. They could be
     made faster by manually inlining each другое. We hope that
     compilers do this for us though.
  */

  protected synchronized бул стартЧтенияИзНовогоЧитателя() {
    бул пасс = стартЧтения();
    if (!пасс) ++ждущиеЧитатели_;
    return пасс;
  }

  protected synchronized бул стартЗаписиИзНовогоПисателя() {
    бул пасс = стартЗаписи();
    if (!пасс) ++ждущиеПисатели_;
    return пасс;
  }

  protected synchronized бул стартЧтенияИзЖдущегоЧитателя() {
    бул пасс = стартЧтения();
    if (пасс) --ждущиеЧитатели_;
    return пасс;
  }

  protected synchronized бул стартЗаписиИзЖдущегоПисателя() {
    бул пасс = стартЗаписи();
    if (пасс) --ждущиеПисатели_;
    return пасс;
  }

  /**
   * Called upon termination of a read.
   * Returns the object to сигнал to wake up a waiter, or пусто if no such
   */
  protected synchronized Сигналист конецЧтения() {
    if (--активныеЧитатели_ == 0 && ждущиеПисатели_ > 0)
      return замокПисателя_;
    else
      return пусто;
  }

  
  /**
   * Called upon termination of a write.
   * Returns the object to сигнал to wake up a waiter, or пусто if no such
   */
  protected synchronized Сигналист конецЗаписи() {
    активныеПисатели_ = пусто;
    if (ждущиеЧитатели_ > 0 && позволитьЧитателю())
      return замокЧитателя_;
    else if (ждущиеПисатели_ > 0)
      return замокПисателя_;
    else
      return пусто;
  }


  /**
   * Reader and Writer requests are maintained in two different
   * жди sets, by two different объекты. These объекты do not
   * know whether the жди sets need notification since they
   * don't know preference rules. So, each supports a
   * method that can be selected by main controlling object
   * to perform the notifications.  This base class simplifies mechanics.
   */

  protected interface Сигналист  { // base for ЗамокЧитателя and ЗамокПисателя
    проц ждутСигнала();
  }

  protected class ЗамокЧитателя : ОбъектЖдиУведомиВсех, Сигналист, Синх {
    ЧЗЗамокПредпочтенияПисателя объ;

    this(ЧЗЗамокПредпочтенияПисателя объ) {
      this.объ = объ;
    }

    проц обрети() {
      ИсклОжидания ie = пусто;
      synchronized(this) {
        if (!объ.стартЧтенияИзНовогоЧитателя()) {
          for (;;) {
            try { 
              жди();  
              if (объ.стартЧтенияИзЖдущегоЧитателя())
                return;
            }
            catch(ИсклОжидания искл){
              объ.отменённыйЖдущийЧитатель();
              ie = искл;
              break;
            }
          }
        }
      }
      if (!(ie is пусто)) {
        // fall through outside synch on interrupt.
        // This notification is not really needed here, 
        //   but may be in plausible subclasses
        объ.замокПисателя_.ждутСигнала();
        throw ie;
      }
    }


    проц отпусти() {
      Сигналист s = объ.конецЧтения();
      if (!(s is пусто)) s.ждутСигнала();
    }


    synchronized проц ждутСигнала() { уведомиВсех(); }

    бул пытайся(дол мсек) { 
      ИсклОжидания ie = пусто;
      synchronized(this) {
        if (мсек <= 0)
          return объ.стартЧтения();
        else if (объ.стартЧтенияИзНовогоЧитателя()) 
          return да;
        else {
          дол времяОжидания = мсек;
          дол старт = clock();
          for (;;) {
            try { жди(времяОжидания);  }
            catch(ИсклОжидания искл){
              объ.отменённыйЖдущийЧитатель();
              ie = искл;
              break;
            }
            if (объ.стартЧтенияИзЖдущегоЧитателя())
              return да;
            else {
              времяОжидания = мсек - (clock() - старт);
              if (времяОжидания <= 0) {
                объ.отменённыйЖдущийЧитатель();
                break;
              }
            }
          }
        }
      }
      // safeguard on interrupt or таймаут:
      объ.замокПисателя_.ждутСигнала();
      if (!(ie is пусто)) throw ie;
      else return нет; // по_времени out
    }

  }

  protected class ЗамокПисателя : ОбъектЖдиУведоми, Сигналист, Синх {
    ЧЗЗамокПредпочтенияПисателя объ;

    this(ЧЗЗамокПредпочтенияПисателя объ) {
      this.объ = объ;
    }

    проц обрети() {
      ИсклОжидания ie = пусто;
      synchronized(this) {
        if (!объ.стартЗаписиИзНовогоПисателя()) {
          for (;;) {
            try { 
              жди();  
              if (объ.стартЗаписиИзЖдущегоПисателя())
                return;
            }
            catch(ИсклОжидания искл){
              объ.отменённыйЖдущийПисатель();
              уведоми();
              ie = искл;
              break;
            }
          }
        }
      }
      if (!(ie is пусто)) {
        // Fall through outside synch on interrupt.
        //  On exception, we may need to сигнал читатели.
        //  It is not worth checking here whether it is strictly necessary.
        объ.замокЧитателя_.ждутСигнала();
        throw ie;
      }
    }

    проц отпусти(){
      Сигналист s = объ.конецЗаписи();
      if (!(s is пусто)) s.ждутСигнала();
    }

    synchronized проц ждутСигнала() { уведоми(); }

    бул пытайся(дол мсек) { 
      ИсклОжидания ie = пусто;
      synchronized(this) {
        if (мсек <= 0)
          return объ.стартЗаписи();
        else if (объ.стартЗаписиИзНовогоПисателя()) 
          return да;
        else {
          дол времяОжидания = мсек;
          дол старт = clock();
          for (;;) {
            try { жди(времяОжидания);  }
            catch(ИсклОжидания искл){
              объ.отменённыйЖдущийПисатель();
              уведоми();
              ie = искл;
              break;
            }
            if (объ.стартЗаписиИзЖдущегоПисателя())
              return да;
            else {
              времяОжидания = мсек - (clock() - старт);
              if (времяОжидания <= 0) {
                объ.отменённыйЖдущийПисатель();
                уведоми();
                break;
              }
            }
          }
        }
      }
      
      объ.замокЧитателя_.ждутСигнала();
      if (!(ie is пусто)) throw ie;
      else return нет; // по_времени out
    }
  }

  unittest {
    class Test {
      ЧЗЗамокПредпочтенияПисателя rw;
      цел x;
      this() { rw = new ЧЗЗамокПредпочтенияПисателя(); }
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
    эхо("starting ЧЗЗамокПредпочтенияПисателя unittest\n");
    Test x = new Test;
    x.write();
    x.read();
    delete x;
    эхо("finished ЧЗЗамокПредпочтенияПисателя unittest\n");
  }
}

