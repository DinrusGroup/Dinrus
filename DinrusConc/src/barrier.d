/* \file барьер
 * \brief A барьер for a group of threads
 */

/*
  Originally written by Doug Lea and released into the public domain.
  This may be used for any purposes whatsoever without acknowledgment.
  Thanks for the assistance and support of Sun Microsystems Labs,
  and everyone contributing, testing, and using this code.
  Translated to D by Ben Hinkle 2004.
*/

module conc.barrier;

import conc.sync;

/** \class Барьер
 * \brief  Barriers serve as synchronization points for groups of threads that
 * must occasionally жди for each другое. 
 *
 * Barriers may support any of several methods that
 * accomplish this synchronization. This interface
 * merely expresses their minimal commonalities:
 *   - Every барьер is defined for a given число
 *     of <code>участники</code> -- the число of threads
 *     that must meet at the барьер point. (In all current
 *     implementations, this
 *     значение is fixed upon construction of the Барьер.)
 *   - A барьер can become <code>сломан</code> if
 *     one or more threads leave a барьер point prematurely,
 *     generally due to interruption or таймаут. Corresponding
 *     synchronization methods in barriers fail, throwing
 *     ИсклСломанногоБарьера for другое threads
 *     when barriers are in сломан states.
 */
interface Барьер {

  /** 
   * Return the число of участники that must meet per барьер
   * point. The число of участники is always at least 1.
   */

  цел участники();

  /**
   * Returns да if the барьер has been compromised
   * by threads leaving the барьер before a synchronization
   * point (normally due to interruption or таймаут). 
   * Барьер methods in implementation классы throw
   * throw ИсклСломанногоБарьера upon detection of breakage.
   * Implementations may also support some means
   * to clear this status.
   */

  бул сломан();
}

/** \class ИсклСломанногоБарьера
 * Thrown when a барьер has been compromised by
 * threads leaving the барьер before a synchronization point.
 */
class ИсклСломанногоБарьера : Искл {

  /** 
   * The индекс that барьер would have returned upon
   * normal return;
   */
  final цел индекс;

  /**
   * Constructs a ИсклСломанногоБарьера with given индекс
   */
  this(цел инд) {
    super("Сломанный барьер");
    индекс = инд;
  }

  /**
   * Constructs a ИсклСломанногоБарьера with the
   * specified индекс and detail сооб.
   */
  this(цел инд, ткст сооб) {
    super(сооб);
    индекс = инд;
  }
}

/** \class ИсклТаймаута
 * Thrown by synchronization классы that report
 * timeouts via exceptions. The exception is treated
 * as a form (subclass) of ИсклОжидания. This both
 * simplifies handling, and conceptually reflects the fact that
 * по_времени-out operations are artificially interrupted by timers.
 */
class ИсклТаймаута : ИсклОжидания {
  /** 
   * The approximate время that the operation lasted before 
   * this таймаут exception was thrown.
   */
  public final дол продолжительность;

  /**
   * Constructs a ИсклТаймаута with given продолжительность значение.
   */
  this(дол время) {
    super("Исключение таймаута");
    продолжительность = время;
  }

  /**
   * Constructs a ИсклТаймаута with the
   * specified продолжительность значение and detail сооб.
   */
  this(дол время, ткст сооб) {
    super(сооб);
    продолжительность = время;
  }
}
