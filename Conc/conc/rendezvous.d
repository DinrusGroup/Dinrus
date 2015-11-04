/** \file рандеву.d
 * \brief A барьер with abritrary threads and information exchange.
 */

/*
  Originally written by Doug Lea and released into the public domain.
  This may be used for any purposes whatsoever without acknowledgment.
  Thanks for the assistance and support of Sun Microsystems Labs,
  and everyone contributing, testing, and using this code.
  Translated to D by Ben Hinkle 2004.
*/

module conc.rendezvous;

import conc.barrier;

private import conc.fairsemaphore, conc.semaphore, conc.sync;
private import conc.waitnotify;
private import stdrus:Нить;
private import cidrus;

/** \class Рандеву
 * \brief A барьер with  information exchange.
 *
 * A рандеву is a барьер that:
 *   - Unlike a ЦиклическийБарьер, is not restricted to use 
 *     with fixed-sized groups of threads.
 *     Any число of threads can пытайся to enter a рандеву,
 *     but only the predetermined число of участники enter
 *     and later become released from the рандеву at any give время.
 *   - Enables each participating нить to exchange information
 *     with others at the рандеву point. Each entering нить
 *     presents some object on entry to the рандеву, and
 *     returns some object on отпусти. The object returned is
 *     the result of a ФункцРандеву that is пуск once per
 *     рандеву, (it is пуск by the last-entering нить). By
 *     default, the function applied is a rotation, so each
 *     нить returns the object given by the следщ (modulo участники)
 *     entering нить. This default function faciliates simple
 *     application of a common use of рандеву, as exchangers.
 *
 * Рандеву use an all-or-none breakage model
 * for failed synchronization attempts: If threads
 * leave a рандеву point prematurely because of таймаут
 * or interruption, others will also leave abnormally
 * (via ИсклСломанногоБарьера), until
 * the рандеву is <code>рестарт</code>ed. This is usually
 * the simplest and best strategy for sharing knowledge
 * about failures among cooperating threads in the most
 * common usages contexts of Рандеву.
 *
 * While any positive число (including 1) of участники can
 * be handled, the most common case is to have two участники.
 *
 * <b>Sample Usage</b><p>
 * Here are the highlights of a class that uses a Рандеву to
 * swap buffers between threads so that the нить filling the
 * buffer  gets a freshly
 * emptied one when it needs it, handing off the filled one to
 * the нить emptying the buffer.
 * \code
 * class FillAndEmpty {
 *   Рандеву exchanger = new Рандеву(2);
 *   Buffer initialEmptyBuffer = ... a made-up type
 *   Buffer initialFullBuffer = ...
 *
 *   class FillingLoop implements Пускаемый {
 *     public проц пуск() {
 *       Buffer currentBuffer = initialEmptyBuffer;
 *       try {
 *         while (currentBuffer != пусто) {
 *           addToBuffer(currentBuffer);
 *           if (currentBuffer.full()) 
 *             currentBuffer = (Buffer)(exchanger.рандеву(currentBuffer));
 *         }
 *       }
 *       catch (ИсклСломанногоБарьера искл) {
 *         return;
 *       }
 *       catch (ИсклОжидания искл) {
 *         Нить.дайЭту().interrupt();
 *       }
 *     }
 *   }
 *
 *   class EmptyingLoop implements Пускаемый {
 *     public проц пуск() {
 *       Buffer currentBuffer = initialFullBuffer;
 *       try {
 *         while (currentBuffer != пусто) {
 *           takeFromBuffer(currentBuffer);
 *           if (currentBuffer.empty()) 
 *             currentBuffer = (Buffer)(exchanger.рандеву(currentBuffer));
 *         }
 *       }
 *       catch (ИсклСломанногоБарьера искл) {
 *         return;
 *       }
 *       catch (ИсклОжидания искл) {
 *         Нить.дайЭту().interrupt();
 *       }
 *     }
 *   }
 *
 *   проц старт() {
 *     new Нить(new FillingLoop()).старт();
 *     new Нить(new EmptyingLoop()).старт();
 *   }
 * }
 */

class Рандеву : ОбъектЖдиУведомиВсех, Барьер {

  /**
   * Perform some function on the объекты presented at
   * a рандеву. The объекты array содержит all presented
   * items; one per нить. Its length is the число of участники. 
   * The array is ordered by arrival into the рандеву.
   * So, the last element (at объекты[объекты.length-1])
   * is guaranteed to have been presented by the нить performing
   * this function. No identifying information is
   * otherwise kept about which нить presented which элт.
   * If you need to 
   * trace origins, you will need to use an элт type for рандеву
   * that includes identifying information. After return of this
   * function, другое threads are released, and each returns with
   * the элт with the same индекс as the one it presented.
   */
  alias проц function(Объект[] объекты) ФункцРандеву;

  /**
   * The default рандеву function. Rotates the array
   * so that each нить returns an элт presented by some
   * другое нить (or itself, if участники is 1).
   */
  static проц функцРандеву(Объект[] объекты) {
    цел lastIdx = объекты.length - 1;
    Объект первое = объекты[0];
    for (цел i = 0; i < lastIdx; ++i) объекты[i] = объекты[i+1];
    объекты[lastIdx] = первое;
  }

  protected final цел участники_;

  protected бул сорван_ = нет;

  /** 
   * Number of threads that have entered рандеву
   */
  protected цел вхождения_ = 0;

  /** 
   * Number of threads that are permitted to depart рандеву 
   */
  protected дол отправлены_ = 0;

  /** 
   * Incoming threads pile up on entry until last установи done.
   */
  protected final Семафор ворота_;

  /**
   * Temporary holder for items in exchange
   */
  protected final Объект[] слоты_;

  /**
   * The function to пуск at рандеву point
   */

  protected ФункцРандеву функцРандеву_;

  /** 
   * Create a Барьер for the indicated число of участники,
   * and the default Rotator function to пуск at each барьер point.
   */

  this(цел участники) { 
    this(участники, &функцРандеву); 
  }

  /** 
   * Create a Барьер for the indicated число of участники.
   * and the given function to пуск at each барьер point.
   */
  this(цел участники, ФункцРандеву функц_) 
  in { 
    assert(участники > 0);
  }
  body {
    участники_ = участники; 
    функцРандеву_ = функц_;
    ворота_ = new ЯсныйСемафор(участники);
    слоты_ = new Объект[участники];
  }

  /**
   * Set the function to call at the point at which all threads reach the
   * рандеву. This function is пуск exactly once, by the нить
   * that trips the барьер. The function is not пуск if the барьер is
   * сломан. 
   * /param function the function to пуск. If пусто, no function is пуск.
   * /return the previous function
   */
  synchronized ФункцРандеву установиФункцРандеву(ФункцРандеву функц_) {
    ФункцРандеву старый = функцРандеву_;
    функцРандеву_ = функц_;
    return старый;
  }

  цел участники() { return участники_; }

  synchronized бул сломан() { return сорван_; }

  /**
   * Reset to initial state. Clears both the сломан status
   * and any record of ждущий threads, and releases all
   * currently ждущий threads with indeterminate return status.
   * This method is intended only for use in recovery actions
   * in which it is somehow known
   * that no нить could possibly be relying on the
   * the synchronization properties of this барьер.
   */
  public проц рестарт() { 
    // This is not very good, but probably the best that can be done
    for (;;) {
      synchronized(this) {
        if (вхождения_ != 0) {
          уведомиВсех();
        }
        else {
          сорван_ = нет; 
          return;
        }
      }
      Нить.рви();
    }
  }


  /**
   * Enter a рандеву; returning after all другое участники arrive.
   * /param x the элт to present at рандеву point. 
   * By default, this элт is exchanged with another.
   * /return an элт x given by some нить, and/or processed
   * by the функцРандеву.
   * /exception ИсклСломанногоБарьера 
   * if any другое нить
   * in any previous or current барьер 
   * since either creation or the last <code>рестарт</code>
   * operation left the барьер
   * prematurely due to interruption or время-out. (If so,
   * the <code>сломан</code> status is also установи.) 
   * Also returns as
   * сломан if the ФункцРандеву encountered a пуск-время exception.
   */
  Объект рандеву(Объект x) {
    return делайРандеву(x, нет, 0);
  }

  /**
   * Wait мсек to complete a рандеву.
   * \param x the элт to present at рандеву point. 
   * By default, this элт is exchanged with another.
   * \param мсек The maximum время to жди.
   * \return an элт x given by some нить, and/or processed
   * by the функцРандеву.
   * \exception ИсклСломанногоБарьера 
   * if any другое нить
   * in any previous or current барьер 
   * since either creation or the last <code>рестарт</code>
   * operation left the барьер
   * prematurely due to interruption or время-out. (If so,
   * the <code>сломан</code> status is also установи.) 
   * Also returns as
   * сломан if the ФункцРандеву encountered a пуск-время exception.
   * \exception ИсклОжидания if this нить was interrupted
   * during the exchange. If so, <code>сломан</code> status is also установи.
   * \exception ИсклТаймаута if this нить по_времени out ждущий for
   * the exchange. If the таймаут occured while already in the
   * exchange, <code>сломан</code> status is also установи.
   */


  Объект пробуйРандеву(Объект x, дол мсек) {
    return делайРандеву(x, да, мсек);
  }

  protected Объект делайРандеву(Объект x, бул по_времени, дол мсек) {

    // rely on semaphore to throw interrupt on entry

    дол времяСтарта;

    if (по_времени) {
      времяСтарта = clock();
      if (!ворота_.пытайся(мсек)) {
        throw new ИсклТаймаута(мсек);
      }
    }
    else {
      времяСтарта = 0;
      ворота_.обрети();
    }

    synchronized(this) {

      Объект y = пусто;

      цел индекс =  вхождения_++;
      слоты_[индекс] = x;

      try { 
        // last one in runs function and releases
        if (вхождения_ == участники_) {

          отправлены_ = вхождения_;
          уведомиВсех();

          try {
            if (!сорван_ && функцРандеву_ != пусто)
            функцРандеву_(слоты_);
          }
          catch (Искл искл) {
            сорван_ = да;
          }

        }

        else {

          while (!сорван_ && отправлены_ < 1) {
            дол остаток_времени = 0;
            if (по_времени) {
              остаток_времени = мсек - (clock() - времяСтарта);
              if (остаток_времени <= 0) {
                сорван_ = да;
                отправлены_ = вхождения_;
                уведомиВсех();
                throw new ИсклТаймаута(мсек);
              }
            }
            
            try {
              жди(остаток_времени); 
            }
            catch (ИсклОжидания искл) { 
              if (сорван_ || отправлены_ > 0) {
                break;
              }
              else {
                сорван_ = да;
                отправлены_ = вхождения_;
                уведомиВсех();
                throw искл;
              }
            }
          }
        }

      }

      finally {

        y = слоты_[индекс];
        
        // Last one out cleans up and allows следщ установи of threads in
        if (--отправлены_ <= 0) {
          for (цел i = 0; i < слоты_.length; ++i) слоты_[i] = пусто;
          ворота_.отпусти(вхождения_);
          вхождения_ = 0;
        }
      }

      // continue if no IE/TO throw
      if (сорван_)
        throw new ИсклСломанногоБарьера(индекс);
      else
        return y;
    }
  }

}


