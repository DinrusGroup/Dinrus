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

module conc.puttable;

/** 
 * This interface exists to enable stricter type checking for channels. A
 * method argument or instance variable in a producer object can be declared as
 * only a Помещаемое rather than a Канал, in which case a compiler will
 * disallow возьми operations.
 * <p>
 * Full method descriptions appear in the Канал interface.
 * @see Канал
 * @see Извлекаемое
**/

interface Помещаемое(T) {

  /** 
   * Place элт in the канал, possibly ждущий indefinitely until
   * it can be accepted. Channels implementing the ОграниченныйКанал
   * subinterface are generally guaranteed to block on puts upon
   * reaching ёмкость, but другое implementations may or may not block.
   * @param элт the element to be inserted. Should be non-пусто.
  **/
  public проц помести(T элт);


  /** 
   * Place элт in канал only if it can be accepted within
   * мсек milliseconds. The время bound is interpreted in
   * a coarse-grained, best-effort fashion. 
   * @param элт the element to be inserted. Should be non-пусто.
   * @param мсек the число of milliseconds to жди. If less than
   * or equal to zero, the method does not perform any по_времени waits,
	 * but might still require access to a synchronization замок, which can impose
	 * unbounded delay if there is a lot of contention for the канал.
   * @return да if accepted, else нет
  **/
  public бул предложи(T элт, дол мсек);
}
