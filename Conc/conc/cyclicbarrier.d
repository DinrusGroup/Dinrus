/* \file cyclicbarrier
 * \brief A fixed размер барьер 
 */

/*
  Originally written by Doug Lea and released into the public domain.
  This may be used for any purposes whatsoever without acknowledgment.
  Thanks for the assistance and support of Sun Microsystems Labs,
  and everyone contributing, testing, and using this code.
  Translated to D by Ben Hinkle 2004.
*/

module conc.cyclicbarrier;

import conc.barrier;

private import conc.waitnotify, conc.sync;
private import cidrus;

/** \class ЦиклическийБарьер
 * \brief A cyclic барьер is a reasonable choice for a барьер in contexts
 * involving a fixed sized group of threads that
 * must occasionally жди for each другое. 
 *
 * (A Рандеву better handles applications in which
 * any число of threads meet, n-at-a-время.)
 * <p>
 * CyclicBarriers use an all-or-none breakage model
 * for failed synchronization attempts: If threads
 * leave a барьер point prematurely because of таймаут
 * or interruption, others will also leave abnormally
 * (via ИсклСломанногоБарьера), until
 * the барьер is <code>рестарт</code>ed. This is usually
 * the simplest and best strategy for sharing knowledge
 * about failures among cooperating threads in the most
 * common usages contexts of Barriers.
 * This implementation  has the property that interruptions
 * among newly arriving threads can cause as-yet-unresumed
 * threads from a previous барьер cycle to return out
 * as сломан. This transmits breakage
 * as early as possible, but with the possible byproduct that
 * only some threads returning out of a барьер will realize
 * that it is newly сломан. (Others will not realize this until a
 * future cycle.) (The Рандеву class has a more uniform, but
 * sometimes less desirable policy.)
 * <p>
 * Barriers support an optional function команда
 * that is пуск once per барьер point.
 * <p>
 * <b>Sample usage</b> Here is a code sketch of 
 *  a  барьер in a parallel decomposition design.
 * \code
 * class Solver {
 *   final цел N;
 *   final float[][] data;
 *   final ЦиклическийБарьер барьер;
 *   
 *   class Работяга implements Пускаемый {
 *      цел myRow;
 *      Работяга(цел row) { myRow = row; }
 *      public проц пуск() {
 *         while (!done()) {
 *            processRow(myRow);
 *
 *            try {
 *              барьер.барьер(); 
 *            }
 *            catch (InterruptedException искл) { return; }
 *            catch (ИсклСломанногоБарьера искл) { return; }
 *         }
 *      }
 *   }
 *
 *   public Solver(float[][] matrix) {
 *     data = matrix;
 *     N = matrix.length;
 *     барьер = new ЦиклическийБарьер(N);
 *     барьер.установиКомандуБарьера(new Пускаемый() {
 *       public проц пуск() { mergeRows(...); }
 *     });
 *     for (цел i = 0; i < N; ++i) {
 *       new Нить(new Работяга(i)).старт();
 *     waitUntilDone();
 *    }
 * }
 * \endcode
 */
class ЦиклическийБарьер : ОбъектЖдиУведомиВсех, Барьер {

  alias цел function() Пускаемый;

  protected final цел участники_;
  protected бул сорван_ = нет;
  protected Пускаемый командаБарьер_ = пусто;
  protected цел счёт_; // число of участники still ждущий
  protected цел сбросы_ = 0; // incremented on each отпусти

  /** 
   * Create a ЦиклическийБарьер for the indicated число of участники,
   * and no команда to пуск at each барьер.
   */

  this(цел участники) { this(участники, пусто); }

  /** 
   * Create a ЦиклическийБарьер for the indicated число of участники.
   * and the given команда to пуск at each барьер point.
   */

  this(цел участники, Пускаемый команда) 
  in { 
    assert (участники > 0);
  }
  body {
    участники_ = участники; 
    счёт_ = участники;
    командаБарьер_ = команда;
  }

  /**
   * Set the команда to пуск at the point at which all threads reach the
   * барьер. This команда is пуск exactly once, by the нить
   * that trips the барьер. The команда is not пуск if the барьер is
   * сломан.
   * @param команда the команда to пуск. If пусто, no команда is пуск.
   * @return the previous команда
   */

  synchronized Пускаемый установиКомандуБарьера(Пускаемый команда) {
    Пускаемый старый = командаБарьер_;
    командаБарьер_ = команда;
    return старый;
  }

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

  synchronized проц рестарт() { 
    сорван_ = нет; 
    ++сбросы_;
    счёт_ = участники_;
    уведомиВсех();
  }
  
 
  цел участники() { return участники_; }

  /**
   * Enter барьер and жди for the другое участники()-1 threads.
   * \return the arrival индекс: the число of другое участники 
   * that were still ждущий
   * upon entry. This is a unique значение from zero to участники()-1.
   * If it is zero, then the current
   * нить was the last party to hit барьер point
   * and so was responsible for releasing the others. 
   * \exception ИсклСломанногоБарьера if any другое нить
   * in any previous or current барьер 
   * since either creation or the last <code>рестарт</code>
   * operation left the барьер
   * prematurely due to interruption or время-out. (If so,
   * the <code>сломан</code> status is also установи.)
   */

  цел барьер() {
    return делайБарьер(нет, 0);
  }

  /**
   * Enter барьер and жди at most мсек for the другое участники()-1 threads.
   * \return if not по_времени out, the arrival индекс: the число of другое участники 
   * that were still ждущий
   * upon entry. This is a unique значение from zero to участники()-1.
   * If it is zero, then the current
   * нить was the last party to hit барьер point
   * and so was responsible for releasing the others. 
   * \exception ИсклСломанногоБарьера 
   * if any другое нить
   * in any previous or current барьер 
   * since either creation or the last <code>рестарт</code>
   * operation left the барьер
   * prematurely due to interruption or время-out. (If so,
   * the <code>сломан</code> status is also установи.) 
   * \exception ИсклТаймаута if this нить по_времени out ждущий for
   *  the барьер. If the таймаут occured while already in the
   * барьер, <code>сломан</code> status is also установи.
   */

  цел пробуйБарьер(дол мсек) {
    return делайБарьер(да, мсек);
  }

  protected synchronized цел делайБарьер(бул по_времени, дол мсек) {
    
    цел индекс = --счёт_;

    if (сорван_) {
      throw new ИсклСломанногоБарьера(индекс);
    }
    else if (индекс == 0) {  // tripped
      счёт_ = участники_;
      ++сбросы_;
      уведомиВсех();
      try {
        if (командаБарьер_ != пусто)
          return командаБарьер_();
      }
      catch (Искл искл) {
        сорван_ = да;
        return 0;
      }
    }
    else if (по_времени && мсек <= 0) {
      сорван_ = да;
      уведомиВсех();
      throw new ИсклТаймаута(мсек);
    }
    else {                   // жди until следщ reset
      цел r = сбросы_;      
      дол времяСтарта = (по_времени)? clock() : 0;
      дол времяОжидания = мсек;
      for (;;) {
        try {
          жди(времяОжидания);
        }
        catch (ИсклОжидания искл) {
          // Only claim that сломан if interrupted before reset
          if (сбросы_ == r) { 
            сорван_ = да;
            уведомиВсех();
            throw искл;
          }
        }

        if (сорван_) 
          throw new ИсклСломанногоБарьера(индекс);

        else if (r != сбросы_)
          return индекс;

        else if (по_времени) {
          времяОжидания = мсек - (clock() - времяСтарта);
          if  (времяОжидания <= 0) {
            сорван_ = да;
            уведомиВсех();
            throw new ИсклТаймаута(мсек);
          }
        }
      }
    }
  }

}
