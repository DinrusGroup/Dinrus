/* \file syncutils.d
 * \brief Utility классы for —инх объекты
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


/** \class Ќулл—инх
 * \brief A No-Op implementation of —инх. 
 *
 * Acquire never blocks,
 * Attempt always succeeds, Release has no effect.
 * The methods are synchronized, so preserve memory барьер properties
 * of Syncs.
 * <p>
 * NullSyncs can be useful in optimizing классы when
 * it is found that locking is not strictly necesssary.
 */
class Ќулл—инх : —инх {

  synchronized проц обрети() {}

  synchronized бул пытайс€(дол мсек) {
    return да;
  }

  synchronized проц отпусти() {}
}


/** \class “аймаут—инх
 * \brief A sync where all calls have timeouts.
 *
 *  A “аймаут—инх is an adaptor class that transforms all
 * calls to обрети to instead invoke пытайс€ with a predetermined
 * таймаут значение.
 */
class “аймаут—инх : —инх {

  protected final —инх синх_;     // the adapted sync
  protected final дол таймаут_;  // таймаут значение

  /** 
   * Create a “аймаут—инх using the given —инх object, and
   * using the given таймаут значение for all calls to обрети.
   */
  this(—инх sync, дол таймаут) {
    синх_ = sync;
    таймаут_ = таймаут;
  }

  /** Destroy “аймаут—инх and отпусти system resources */
  ~this() {
    delete синх_;
  }

  проц обрети() {
    if (!синх_.пытайс€(таймаут_)) throw new »скл“аймаута(таймаут_);
  }

  бул пытайс€(дол мсек) {
    return синх_.пытайс€(мсек);
  }

  проц отпусти() {
    синх_.отпусти();
  }
}

/** \class —лойный—инх
 * \brief A class that can be used to compose Syncs.
 *
 * A —лойный—инх object manages two другое —инх объекты,
 * <em>внешний</em> and <em>внутренний</em>. The обрети operation
 * invokes <em>внешний</em>.обрети() followed by <em>внутренний</em>.обрети(),
 * but backing out of внешний (via отпусти) upon an exception in внутренний.
 * The другое methods work similarly.
 * <p>
 * LayeredSyncs can be used to compose arbitrary chains
 * by arranging that either of the managed Syncs be another
 * —лойный—инх.
 *
 */
class —лойный—инх : —инх {

  protected final —инх внешний_;
  protected final —инх внутренний_;

  /** 
   * Create a —лойный—инх managing the given внешний and внутренний —инх
   * объекты
   */
  this(—инх внешний, —инх внутренний) {
    внешний_ = внешний;
    внутренний_ = внутренний;
  }

  /** Destroy —лойный—инх and отпусти system resources */
  ~this() {
    delete внешний_;
    delete внутренний_;
  }

  проц обрети() {
    внешний_.обрети();
    try {
      внутренний_.обрети();
    }
    catch (»склќжидани€ искл) {
      внешний_.отпусти();
      throw искл;
    }
  }

  бул пытайс€(дол мсек) {

    дол старт = (мсек <= 0)? 0 : clock();
    дол врем€ќжидани€ = мсек;

    if (внешний_.пытайс€(врем€ќжидани€)) {
      try {
        if (мсек > 0)
          врем€ќжидани€ = мсек - (clock() - старт);
        if (внутренний_.пытайс€(врем€ќжидани€))
          return да;
        else {
          внешний_.отпусти();
          return нет;
        }
      }
      catch (»склќжидани€ искл) {
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
