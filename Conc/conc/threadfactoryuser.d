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
  28aug1998  dl               refactored from Исполнитель классы
*/

module conc.threadfactoryuser;

import conc.threadfactory, stdrus:Нить;

/**
 * 
 * Base class for Executors and related классы that rely on нить factories.
 * Generally intended to be used as a mixin-style abstract class, but
 * can also be used stand-alone.
 **/

public class ПользовательФабрикиНитей {

	protected:
		ФабрикаНитей фабрикаНитей_;

		class ДефолтнаяФабрикаНитей : ФабрикаНитей {
			public Нить новаяНить(цел delegate() команда) {
				return new Нить(команда);
			}
		}

	public:
		/**
		 * Create a new ПользовательФабрикиНитей
		 **/
		this()
		{
			фабрикаНитей_ = new ДефолтнаяФабрикаНитей();
		}

		/** 
		 * Set the фабрика for creating new threads.
		 * By default, new threads are created without any special priority,
		 * threadgroup, or status parameters.
		 * You can use a different фабрика
		 * to change the kind of Нить class used or its construction
		 * parameters.
		 * @param фабрика the фабрика to use
		 * @return the previous фабрика
		 **/
		synchronized ФабрикаНитей установиФабрикуНитей(ФабрикаНитей фабрика) {
			ФабрикаНитей старый = фабрикаНитей_;
			фабрикаНитей_ = фабрика;
			return старый;
		}

		/** 
		 * Get the фабрика for creating new threads.
		 **/  
		synchronized ФабрикаНитей дайФабрикуНитей() {
			return фабрикаНитей_;
		}
}
