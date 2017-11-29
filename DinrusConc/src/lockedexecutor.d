/* \file lockedexecutor
 * \brief Runs commands in a мютекс замок
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
*/

module conc.lockedexecutor;

import conc.executor;
import conc.sync;

/**
 * An implementation of Исполнитель that 
 * invokes the пуск method of the supplied команда within
 * a synchronization замок and then returns.
 * 
 **/
class БлокированныйИсполнитель : Исполнитель {
  
  /** The мютекс **/
	protected:
		Синх мютекс_;

	public:

  /** 
   * Create a new БлокированныйИсполнитель that relies on the given mutual
   * exclusion замок. 
   * @param мютекс Any mutual exclusion замок.
   * Standard usage is to supply an instance of <code>Мютекс</code>,
   * but, for example, a Семафор initialized to 1 also works.
   * On the другое hand, many другое Синх implementations would not
   * work here, so some care is required to supply a sensible 
   * synchronization object.
   **/
  this(Синх мютекс) {
		мютекс_ = мютекс;
  }

  /** 
   * Execute the given команда directly in the current нить,
   * within the supplied замок.
   **/
  проц выполни(цел delegate() команда) {
    мютекс_.обрети();
    try {
      команда();
    }
    finally {
      мютекс_.отпусти();
    }
  }
}
