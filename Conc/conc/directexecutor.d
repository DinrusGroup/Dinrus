/* \file directexecutor
 * \brief Run commands in the current нить
 */

/*
  Originally written by Doug Lea and released into the public domain.
  This may be used for any purposes whatsoever without acknowledgment.
  Thanks for the assistance and support of Sun Microsystems Labs,
  and everyone contributing, testing, and using this code.

  History:
  Date       Who                What
	01May2004  Mike Swieton     Translated to D
  19Jun1998  dl               Create public version
*/

module conc.directexecutor;

import conc.executor;

/**
 * 
 * An implementation of Исполнитель that runs the команда in the current нить
 * 
 **/
class ПрямойИсполнитель : Исполнитель {
	public:
  /** 
   * Execute the given команда directly in the current нить.
   **/
  проц выполни(цел delegate() команда) {
    команда();
  }
}
