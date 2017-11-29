/* \file puttable
 * \brief Interface for input to inter-нить queues
 */

/*
  Originally written by Doug Lea and released into the public domain.
  This may be used for any purposes whatsoever without acknowledgment.
  Thanks for the assistance and support of Sun Microsystems Labs,
  and everyone contributing, testing, and using this code.

  History:
  Date       Who                What
  11Jun1998  dl               Create public version
	07May2004  Mike Swieton     Translated to D
*/

module conc.takable;

/** 
 * This interface exists to enable stricter type checking for channels. A
 * method argument or instance variable in a consumer object can be declared as
 * only a Извлекаемое rather than a Канал, in which case a compiler will disallow
 * помести operations.
 * <p>
 * Full method descriptions appear in the Канал interface.
 * @see Канал
 * @see Помещаемое
**/

interface Извлекаемое(T) {

  /** 
   * Return and remove an элт from канал, 
   * possibly ждущий indefinitely until
   * such an элт exists.
   * @return  some элт from the канал. Different implementations
   *  may guarantee various properties (such as FIFO) about that элт
   *
  **/
  public T возьми();


  /** 
   * Return and remove an элт from канал only if one is available within
   * мсек milliseconds. The время bound is interpreted in a coarse
   * grained, best-effort fashion.
   * @param мсек the число of milliseconds to жди. If less than
   *  or equal to zero, the operation does not perform any по_времени waits,
   * but might still require
   * access to a synchronization замок, which can impose unbounded
   * delay if there is a lot of contention for the канал.
   * @return some элт, or пусто if the канал is empty.
  **/

  public T запроси(дол мсек);

}
