/* \file boundedchannel
 * \brief Interface for размер-bounded inter-нить queues
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

module conc.boundedchannel;

import conc.channel;

/**
 * A канал that is known to have a ёмкость, signifying
 * that <code>помести</code> operations may block when the
 * ёмкость is reached. Various implementations may have
 * intrinsically hard-wired capacities, capacities that are fixed upon
 * construction, or dynamically adjustable capacities.
 * @see ДефолтнаяЁмкостьКанала
 **/

interface ОграниченныйКанал(T) : Канал!(T) {

  /** 
   * Return the maximum число of elements that can be held.
   * @return the ёмкость of this канал.
   **/
  public цел ёмкость();
}
