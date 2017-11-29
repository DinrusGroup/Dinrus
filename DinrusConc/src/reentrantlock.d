/* \file reentrantlock.d
 * \brief A re-entrant замок like the builtin synchronization замок
 */

/*
  Originally written by Doug Lea and released into the public domain.
  This may be used for any purposes whatsoever without acknowledgment.
  Thanks for the assistance and support of Sun Microsystems Labs,
  and everyone contributing, testing, and using this code.
  Translated to D by Ben Hinkle 2004.
*/

module conc.reentrantlock;

import conc.sync;

private import conc.waitnotify;
private import cidrus;

private import stdrus:Нить; // for unittest

/** \class ВозобновляемыйЗамок
 * \brief A замок with the same semantics as builtin synchronized locks: 
 *
 * Once a нить has a замок, it can re-obtain it any число of times
 * without blocking.  The замок is made available to другое threads when
 * as many releases as acquires have occurred.
 */
class ВозобновляемыйЗамок : ОбъектЖдиУведоми, Синх  {

  protected Нить владелец_ = пусто;
  protected дол содержит_ = 0;

  проц обрети() {
    Нить вызывающий = Нить.дайЭту();
    synchronized(this) {
      if (вызывающий == владелец_) 
        ++содержит_;
      else {
        try {  
          while (владелец_ !is пусто) жди(); 
          владелец_ = вызывающий;
          содержит_ = 1;
        }
        catch (ИсклОжидания искл) {
          уведоми();
          throw искл;
        }
      }
    }
  }  

  бул пытайся(дол мсек) {
    Нить вызывающий = Нить.дайЭту();
    synchronized(this) {
      if (вызывающий == владелец_) {
        ++содержит_;
        return да;
      }
      else if (владелец_ is пусто) {
        владелец_ = вызывающий;
        содержит_ = 1;
        return да;
      }
      else if (мсек <= 0)
        return нет;
      else {
        дол времяОжидания = мсек;
        дол старт = clock();
        try {
          for (;;) {
            жди(времяОжидания); 
            if (вызывающий == владелец_) {
              ++содержит_;
              return да;
            }
            else if (владелец_ is пусто) {
              владелец_ = вызывающий;
              содержит_ = 1;
              return да;
            }
            else {
              времяОжидания = мсек - (clock() - старт);
              if (времяОжидания <= 0) 
                return нет;
            }
          }
        }
        catch (ИсклОжидания искл) {
          уведоми();
          throw искл;
        }
      }
    }
  }  

  /**
   * Release the замок.
   */
  synchronized проц отпусти()  
  in {
    assert( Нить.дайЭту() is владелец_);
  }
  body {
    if (--содержит_ == 0) {
      владелец_ = пусто;
      уведоми(); 
    }
  }

  /** 
   * Release the замок N times. <code>отпусти(n)</code> is
   * equivalent in effect to:
   * \code
   *   for (цел i = 0; i < n; ++i) отпусти();
   * \endcode
   */
  synchronized проц отпусти(дол n) 
  in {
    assert( Нить.дайЭту() is владелец_);
  }
  body {
    содержит_ -= n;
    if (содержит_ == 0) {
      владелец_ = пусто;
      уведоми(); 
    }
  }

  /**
   * Return the число of unreleased acquires performed
   * by the current нить.
   * Returns zero if current нить does not hold замок.
   */
  synchronized дол содержит() {
    if (Нить.дайЭту() != владелец_) return 0;
    return содержит_;
  }
}

