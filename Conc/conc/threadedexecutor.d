/* \file threadedexecutor
 * \brief Runs commands in a new нить
 */

/*
  Originally written by Doug Lea and released into the public domain.
  This may be used for any purposes whatsoever without acknowledgment.
  Thanks for the assistance and support of Sun Microsystems Labs,
  and everyone contributing, testing, and using this code.

  History:
  Date       Who                What
	01May2004  Mike Swieton     Translated to D
  21Jun1998  dl               Create public version
  28aug1998  dl               factored out ПользовательФабрикиНитей
*/

module conc.threadedexecutor;

import conc.executor;
import conc.threadfactoryuser;

/**
 * 
 * An implementation of Исполнитель that creates a new
 * Нить that invokes the пуск method of the supplied команда.
 * 
 **/
class ПоточныйИсполнитель : ПользовательФабрикиНитей, Исполнитель {

  /** 
   * Execute the given команда in a new нить.
   **/
  public synchronized проц выполни(цел delegate() команда) {
    Нить нить = дайФабрикуНитей().новаяНить(команда);
    нить.старт();
  }
}
