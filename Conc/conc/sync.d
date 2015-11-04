/* \file sync.d
 * \brief Interface for locks, gates and conditions.
 */

/*
  Originally written by Doug Lea and released into the public domain.
  This may be used for any purposes whatsoever without acknowledgment.
  Thanks for the assistance and support of Sun Microsystems Labs,
  and everyone contributing, testing, and using this code.
  Translated to D by Ben Hinkle 2004.
*/

module conc.sync;

/** \class Синх
 * \brief Main interface for locks, gates, and conditions.
 *
 * Синх объекты isolate ждущий and notification for particular
 * logical states, resource availability, events, and the like that are
 * shared across multiple threads. Use of Syncs sometimes
 * (but by no means always) adds flexibility and efficiency
 * compared to the use of plain D monitor methods
 * and locking, and are sometimes (but by no means always)
 * simpler to program with.
 *
 * Most Syncs are intended to be used primarily (although
 * not exclusively) in  before/after constructions such as:
 * \code
 * class X {
 *   Синх gate;
 *   // ...
 *
 *   public проц m() { 
 *     try {
 *       gate.обрети();  // block until condition содержит
 *       try {
 *         // ... method body
 *       }
 *       finally {
 *         gate.отпусти()
 *       }
 *     }
 *     catch (ИсклОжидания искл) {
 *       // ... evasive action
 *     }
 *   }
 *
 *   public проц m2(Синх cond) { // use supplied condition
 *     try {
 *       if (cond.пытайся(10)) {         // try the condition for 10 ms
 *         try {
 *           // ... method body
 *         }
 *         finally {
 *           cond.отпусти()
 *         }
 *       }
 *     }
 *     catch (ИсклОжидания искл) {
 *       // ... evasive action
 *     }
 *   }
 * }
 * \endcode
 * Syncs may be used in somewhat tedious but more flexible replacements
 * for built-in synchronized blocks. For example:
 * \code
 * class HandSynched {          
 *   private double state_ = 0.0; 
 *   private final Синх замок;  // use замок type supplied in constructor
 *   public HandSynched(Синх l) { замок = l; } 
 *
 *   public проц changeState(double d) {
 *     try {
 *       замок.обрети(); 
 *       try     { state_ = updateFunction(d); } 
 *       finally { замок.отпусти(); }
 *     } 
 *     catch(ИсклОжидания искл) { }
 *   }
 *
 *   public double getState() {
 *     double d = 0.0;
 *     try {
 *       замок.обрети(); 
 *       try     { d = accessFunction(state_); }
 *       finally { замок.отпусти(); }
 *     } 
 *     catch(ИсклОжидания искл){}
 *     return d;
 *   }
 *   private double updateFunction(double d) { ... }
 *   private double accessFunction(double d) { ... }
 * }
 * \endcode
 * 
 * One reason to bother with such constructions is to use deadlock-
 * avoiding back-offs when dealing with locks involving multiple объекты.
 * For example, here is a Cell class that uses пытайся to back-off
 * and retry if two Cells are trying to swap values with each другое 
 * at the same время.
 * \code
 * class Cell {
 *   дол значение;
 *   Синх замок = ... // some sync implementation class
 *   проц swapValue(Cell другое) {
 *     for (;;) { 
 *       try {
 *         замок.обрети();
 *         try {
 *           if (другое.замок.пытайся(100)) {
 *             try { 
 *               дол t = значение; 
 *               значение = другое.значение;
 *               другое.значение = t;
 *               return;
 *             }
 *             finally { другое.замок.отпусти(); }
 *           }
 *         }
 *         finally { замок.отпусти(); }
 *       } 
 *       catch (ИсклОжидания искл) { return; }
 *     }
 *   }
 * }
 * \endcode
 * 
 * Timed versions of пытайся report failure via return значение.
 * If so desired, you can transform such constructions to use exception
 * throws via 
 * \code
 *   if (!c.пытайся(timeval)) throw new ИсклТаймаута(timeval);
 * \endcode
 * 
 * The TimoutSync wrapper class can be used to automate such usages.
 * 
 * All время values are expressed in milliseconds as longs, which have a maximum
 * значение of Long.MAX_VALUE, or almost 300,000 centuries.
 * For convenience, some useful время values are defined as static constants.
 * 
 * Syncs may also be used in spinlock constructions. Although
 * it is normally best to just use обрети(), various forms
 * of busy waits can be implemented. For a simple example 
 * (but one that would probably never be preferable to using обрети()):
 * \code
 * class X {
 *   Синх замок = ...
 *   проц spinUntilAcquired() {
 *     // Two phase. 
 *     // First spin without pausing.
 *     цел purespins = 10; 
 *     for (цел i = 0; i < purespins; ++i) {
 *       if (замок.пытайся(0))
 *         return да;
 *     }
 *     // Second phase - use по_времени waits
 *     дол времяОжидания = 1; // 1 millisecond
 *     for (;;) {
 *       if (замок.пытайся(времяОжидания))
 *         return да;
 *       else 
 *         времяОжидания = времяОжидания * 3 / 2 + 1; // increase 50% 
 *     }
 *   }
 * }
 * \endcode
 * 
 * In addition pure synchronization control, Syncs
 * may be useful in any context requiring before/after methods.
 * For example, you can use an ObservableSync
 * (perhaps as part of a СлойныйСинх) in order to obtain callbacks
 * before and after each method invocation for a given class.
 * 
 */


public interface Синх {

  /** 
   *  Wait (possibly forever) until successful passage.
   *  Fail only upon interuption. Interruptions always result in
   *  `clean' failures. On failure,  you can be sure that it has not 
   *  been acquired, and that no 
   *  corresponding отпусти should be performed. Conversely,
   *  a normal return guarantees that the обрети was successful.
   */

  public проц обрети();

  /** 
   * Wait at most мсек to пасс; report whether passed.
   * <p>
   * The method has best-effort semantics:
   * The мсек bound cannot
   * be guaranteed to be a precise upper bound on жди время in D.
   * Implementations generally can only пытайся to return as soon as possible
   * after the specified bound. So, мсек arguments should be used in
   * a coarse-grained manner. Further,
   * implementations cannot always guarantee that this method
   * will return at all without blocking indefinitely when used in
   * unintended ways. For example, deadlocks may be encountered
   * when called in an unintended context.
   * <p>
   * \param мсек the число of milleseconds to жди.
   * An argument less than or equal to zero means not to жди at all. 
   * However, this may still require
   * access to a synchronization замок, which can impose unbounded
   * delay if there is a lot of contention among threads.
   * \return да if acquired
   */

  public бул пытайся(дол мсек);

  /** 
   * Potentially enable others to пасс.
   * <p>
   * Because отпусти does not raise exceptions, 
   * it can be used in `finally' clauses without requiring extra
   * embedded try/catch blocks. But keep in mind that
   * as with any method, implementations may 
   * still throw unchecked exceptions such as Error or NullPointerException
   * when faced with uncontinuable errors. However, these should normally
   * only be caught by higher-level error handlers.
   */

  public проц отпусти();

  /**  One second, in milliseconds; convenient as a время-out значение */
  public const дол СЕКУНДА = 1000;

  /**  One minute, in milliseconds; convenient as a время-out значение */
  public const дол МИНУТА = 60 * СЕКУНДА;

  /**  One hour, in milliseconds; convenient as a время-out значение */
  public const дол ЧАС = 60 * МИНУТА;

  /**  One day, in milliseconds; convenient as a время-out значение */
  public const дол ДЕНЬ = 24 * ЧАС;

  /**  One week, in milliseconds; convenient as a время-out значение */
  public const дол НЕДЕЛЯ = 7 * ДЕНЬ;

  /**  One year in milliseconds; convenient as a время-out значение  */
  public const дол ГОД = cast(дол)(365.2425 * ДЕНЬ);

  /**  One century in milliseconds; convenient as a время-out значение */
  public const дол ВЕК = 100 * ГОД;


}

/** \class ИсклОжидания
 *
 *  Искл class thrown when a жди() method call fails.
 */
class ИсклОжидания : Искл {
  public this(ткст ткт) { super(ткт); }
}

