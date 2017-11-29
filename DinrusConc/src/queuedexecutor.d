/* \file queuedexecutor
 * \brief Class that executes tasks in order
 */

/*
  Originally written by Doug Lea and released into the public domain.
  This may be used for any purposes whatsoever without acknowledgment.
  Thanks for the assistance and support of Sun Microsystems Labs,
  and everyone contributing, testing, and using this code.

  History:
  Date       Who                What
	07May2004  Mike Swieton     Translated to D
  21Jun1998  dl               Create public version
  28aug1998  dl               rely on ПользовательФабрикиНитей, рестарт now public
   4may1999  dl               removed redundant interrupt detect
   7sep2000  dl               new shutdown methods
*/

module conc.queuedexecutor;

import conc.boundedlinkedqueue;
import conc.channel;
import conc.executor;
import conc.threadfactoryuser;
import stdrus:Нить;

/**
 * 
 * An implementation of Исполнитель that queues incoming
 * requests until they can be processed by a single background
 * нить.
 * <p>
 * The нить is not actually started until the первое 
 * <code>выполни</code> request is encountered. Also, if the
 * нить is stopped for any reason (for example, after hitting
 * an unrecoverable exception in an executing задание), one is started 
 * upon encountering a new request, or if <code>рестарт()</code> is
 * invoked.
 * <p>
 * Beware that, especially in situations
 * where команда объекты themselves invoke выполни, queuing can
 * sometimes lead to lockups, since commands that might allow
 * другое threads to terminate do not пуск at all when they are in the очередь.
 * <p>[<a href="http://gee.cs.oswego.edu/dl/классы/EDU/oswego/cs/dl/util/concurrent/intro.html"> Introduction to this package. </a>]
 **/
public class ОчереднойИсполнитель : ПользовательФабрикиНитей, Исполнитель {
	/**
		* The type of element we're pushing through our очередь.
		**/ 
	alias оберни!(цел delegate()) тип_значения;

	/**
		* The template instance of Канал used for our очередь.
		**/
	alias Канал!(тип_значения) ифейс_очереди;

	/**
		* The template instance of ОграниченнаяЛинкованнаяОчередь used for our очередь, when we
		* have to make it ourselves.
		**/
	alias ОграниченнаяЛинкованнаяОчередь!(тип_значения) тип_очереди;
  
  /** The нить used to process commands **/
  protected Нить нить_;

	class КлассКонцаЗадания : тип_значения {
		this() { super(пусто); }
	}

  /** да if нить should shut down after processing current задание **/
  protected /* volatile */ бул прерывание_; // latches да;
  
  /**
   * Return the нить being used to process commands, or
   * пусто if there is no such нить. You can use this
   * to invoke any special methods on the нить, for
   * example, to interrupt it.
   **/
  public synchronized Нить дайНить() { 
    return нить_;
  }

  /** установи нить_ to пусто to indicate termination **/
  protected synchronized проц сотриНить() {
    нить_ = пусто;
  }

  /** The очередь **/
  protected final ифейс_очереди очередь_;

	/** The worker нить's main loop */
	protected цел пускЦикла () {
		while (да) {
			// прерывание_ is not protected by a замок here, so read it in volatile
			volatile if (прерывание_) break;

			тип_значения задание = очередь_.возьми();
			if (задание.значение == пусто) break;
			задание.значение();
			задание = пусто;
		}
		сотриНить();

		return 0;
	}

  /**
   * Construct a new ОчереднойИсполнитель that uses
   * the supplied Канал as its очередь. 
   * <p>
   * This class does not support any methods that 
   * reveal this очередь. If you need to access it
   * independently (for example to invoke any
   * special status monitoring operations), you
   * should record a reference to it separately.
   **/

  public this(ифейс_очереди очередь) {
    очередь_ = очередь;
  }

  /**
   * Construct a new ОчереднойИсполнитель that uses
   * a ОграниченнаяЛинкованнаяОчередь with the current
   * ДефолтнаяЁмкостьКанала as its очередь.
   **/

  public this() {
    this(new тип_очереди());
  }

/*
	public ~this() {
		// just in case пускЦикла terminates and clears the нить out from under us
		// while we're cleaning up
		Нить нить;
		synchronized if (нить_ != пусто) нить = нить_;

		// clean up the нить
		if (нить != пусто) {
			очередь_.помести(new тип_значения(пусто));
			нить.жди();
		}
	}
		*/

  /**
   * Start (or рестарт) the background нить to process commands. It has
   * no effect if a нить is already running. This
   * method can be invoked if the background нить crashed
   * due to an unrecoverable exception.
   **/

  public synchronized проц рестарт() {
		if (нить_ is пусто && !прерывание_) {
				нить_ = фабрикаНитей_.новаяНить(&пускЦикла);
				нить_.старт();
			}
  }

  /** 
   * Arrange for execution of the команда in the
   * background нить by adding it to the очередь. 
   * The method may block if the канал's помести
   * operation blocks.
   * <p>
   * If the background нить
   * does not exist, it is created and started.
   **/
  public проц выполни(цел delegate() команда) {
    рестарт();
		тип_значения c = new тип_значения(команда);
		очередь_.помести(c);
  }

  /**
   * Terminate background нить after it processes all
   * elements currently in очередь. Any tasks entered after this point will
   * not be processed. A shut down нить cannot be restarted.
   * This method may block if the задание очередь is finite and full.
   * Also, this method 
   * does not in general apply (and may lead to comparator-based
   * exceptions) if the задание очередь is a priority очередь.
   **/
	public synchronized проц прерываниеПослеОбработкиТекущихЗадачВОчереди() {
		if (нить_ !is пусто && !прерывание_) {
			очередь_.помести(new тип_значения(пусто));
		}
	}


  /**
   * Terminate background нить after it processes the 
   * current задание, removing другое queued tasks and leaving them unprocessed.
   * A shut down нить cannot be restarted.
   **/
	public synchronized проц прерываниеПослеОбработкиТекущихЗадачОчереди() {
		прерывание_ = да;
		if (нить_ !is пусто) {
			while (очередь_.запроси(0) !is пусто) { }; // дренируй
			очередь_.помести(new тип_значения(пусто)); 
		}
	}
}

private import conc.linkedqueue;
unittest
{
	эхо("starting queuedexecutor test 1\n");
	class Работяга
	{
		цел arg;

		this(цел x) {
			arg = x;
		}

		цел пуск()
		{
			эхо(" execing(%d)\n", arg);
			return arg;
		}
	}

	scope ОчереднойИсполнитель искл = new ОчереднойИсполнитель();

	for(цел i=0; i<10; i++)
	{
		Работяга w = new Работяга(i);
		искл.выполни(&w.пуск);
	}

	искл.прерываниеПослеОбработкиТекущихЗадачВОчереди();
	Нить t = искл.дайНить();
	if (t !is пусто) t.жди();

	эхо("finished queuedexecutor test 1\n");
}
