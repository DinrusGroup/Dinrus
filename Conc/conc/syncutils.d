/* \file syncutils.d
 * \brief Utility классы for Синх объекты
 */

/*
  Originally written by Doug Lea and released into the public domain.
  This may be used for any purposes whatsoever without acknowledgment.
  Thanks for the assistance and support of Sun Microsystems Labs,
  and everyone contributing, testing, and using this code.
  Translated to D by Ben Hinkle 2004.
*/

module conc.syncutils;

import conc.sync;


/** \class НуллСинх
 * \brief A No-Op implementation of Синх. 
 *
 * Acquire never blocks,
 * Attempt always succeeds, Release has no effect.
 * The methods are synchronized, so preserve memory барьер properties
 * of Syncs.
 * <p>
 * NullSyncs can be useful in optimizing классы when
 * it is found that locking is not strictly necesssary.
 */
class НуллСинх : Синх {

  synchronized проц обрети() {}

  synchronized бул пытайся(дол мсек) {
    return да;
  }

  synchronized проц отпусти() {}
}


/** \class ТаймаутСинх
 * \brief A sync where all calls have timeouts.
 *
 *  A ТаймаутСинх is an adaptor class that transforms all
 * calls to обрети to instead invoke пытайся with a predetermined
 * таймаут значение.
 */
class ТаймаутСинх : Синх {

  protected final Синх синх_;     // the adapted sync
  protected final дол таймаут_;  // таймаут значение

  /** 
   * Create a ТаймаутСинх using the given Синх object, and
   * using the given таймаут значение for all calls to обрети.
   */
  this(Синх sync, дол таймаут) {
    синх_ = sync;
    таймаут_ = таймаут;
  }

  /** Destroy ТаймаутСинх and отпусти system resources */
  ~this() {
    delete синх_;
  }

  проц обрети() {
    if (!синх_.пытайся(таймаут_)) throw new ИсклТаймаута(таймаут_);
  }

  бул пытайся(дол мсек) {
    return синх_.пытайся(мсек);
  }

  проц отпусти() {
    синх_.отпусти();
  }
}

/** \class СлойныйСинх
 * \brief A class that can be used to compose Syncs.
 *
 * A СлойныйСинх object manages two другое Синх объекты,
 * <em>внешний</em> and <em>внутренний</em>. The обрети operation
 * invokes <em>внешний</em>.обрети() followed by <em>внутренний</em>.обрети(),
 * but backing out of внешний (via отпусти) upon an exception in внутренний.
 * The другое methods work similarly.
 * <p>
 * LayeredSyncs can be used to compose arbitrary chains
 * by arranging that either of the managed Syncs be another
 * СлойныйСинх.
 *
 */
class СлойныйСинх : Синх {

  protected final Синх внешний_;
  protected final Синх внутренний_;

  /** 
   * Create a СлойныйСинх managing the given внешний and внутренний Синх
   * объекты
   */
  this(Синх внешний, Синх внутренний) {
    внешний_ = внешний;
    внутренний_ = внутренний;
  }

  /** Destroy СлойныйСинх and отпусти system resources */
  ~this() {
    delete внешний_;
    delete внутренний_;
  }

  проц обрети() {
    внешний_.обрети();
    try {
      внутренний_.обрети();
    }
    catch (ИсклОжидания искл) {
      внешний_.отпусти();
      throw искл;
    }
  }

  бул пытайся(дол мсек) {

    дол старт = (мсек <= 0)? 0 : clock();
    дол времяОжидания = мсек;

    if (внешний_.пытайся(времяОжидания)) {
      try {
        if (мсек > 0)
          времяОжидания = мсек - (clock() - старт);
        if (внутренний_.пытайся(времяОжидания))
          return да;
        else {
          внешний_.отпусти();
          return нет;
        }
      }
      catch (ИсклОжидания искл) {
        внешний_.отпусти();
        throw искл;
      }
    }
    else
      return нет;
  }

  public проц отпусти() {
    внутренний_.отпусти();
    внешний_.отпусти();
  }

}
