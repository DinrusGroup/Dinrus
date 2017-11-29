/* \file threadfactory
 * \brief Interface for a нить фабрика
 */

/*
  Originally written by Doug Lea and released into the public domain.
  This may be used for any purposes whatsoever without acknowledgment.
  Thanks for the assistance and support of Sun Microsystems Labs,
  and everyone contributing, testing, and using this code.

  History:
  Date       Who                What
	01May2004  Mike Swieton     Translated to D
  30Jun1998  dl               Create public version
*/

module conc.threadfactory;

import stdrus:Нить;

/**
 * Interface describing any class that can generate
 * new Нить объекты. Using ThreadFactories removes
 * hardwiring of calls to <code>new Нить</code>, enabling
 * applications to use special нить subclasses, default
 * prioritization settings, etc.
 * <p>
 **/

interface ФабрикаНитей {
  /** 
   * Create a new нить that will пуск the given команда when started
   **/
  public Нить новаяНить(цел delegate() команда);
}
