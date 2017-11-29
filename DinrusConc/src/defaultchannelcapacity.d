/* \file boundedlinkedqueue
 * \brief Size-bounded inter-нить очередь
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

module conc.defaultchannelcapacity;

import conc.synchronizedint;

/**
 * A utility class to установи the default ёмкость of
 * ОграниченныйКанал
 * implementations that otherwise require a ёмкость argument
 * @see ОграниченныйКанал
 **/

class ДефолтнаяЁмкостьКанала {

  /** The initial значение of the default ёмкость is 1024 **/
  public static final цел НАЧАЛЬНАЯ_ДЕФОЛТНАЯ_ЁМКОСТЬ = 1024;

  /**  the current default ёмкость **/
  private static СинхронЦел дефолтнаяЁмкость_;

	static this() {
	 дефолтнаяЁмкость_ = new СинхронЦел(НАЧАЛЬНАЯ_ДЕФОЛТНАЯ_ЁМКОСТЬ);
	}

  /**
   * Set the default ёмкость used in 
   * default (no-argument) constructor for BoundedChannels
   * that otherwise require a ёмкость argument.
   * @exception IllegalArgumentException if ёмкость less or equal to zero
   */
  public static проц установи(цел ёмкость)
	in {
		assert(ёмкость > 0);
	} body {
    дефолтнаяЁмкость_.установи(ёмкость);
  }

  /**
   * Get the default ёмкость used in 
   * default (no-argument) constructor for BoundedChannels
   * that otherwise require a ёмкость argument.
   * Initial значение is <code>НАЧАЛЬНАЯ_ДЕФОЛТНАЯ_ЁМКОСТЬ</code>
   * @see #НАЧАЛЬНАЯ_ДЕФОЛТНАЯ_ЁМКОСТЬ
   */
  public static цел дай() {
    return дефолтнаяЁмкость_.дай();
  }
}
