/* \file executor
 * \brief Interface for running commands
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

module conc.executor;

/**
 * Interface for объекты that выполни Runnables,
 * as well as various объекты that can be wrapped
 * as Runnables.
 * The main reason to use Исполнитель throughout a program or
 * subsystem is to provide flexibility: You can easily
 * change from using нить-per-задание to using pools or
 * queuing, without needing to change most of your code that
 * generates tasks.
 * <p>
 * The general intent is that execution be asynchronous,
 * or at least independent of the вызывающий. For example,
 * one of the simplest implementations of <code>выполни</code>
 * (as performed in ПоточныйИсполнитель)
 * is <code>new Нить(команда).старт();</code>.
 * However, this interface allows implementations that instead
 * employ queueing or pooling, or perform additional
 * bookkeeping.
 * 
 **/
interface Исполнитель {
  /** 
   * Execute the given команда. This method is guaranteed
   * only to arrange for execution, that may actually
   * occur sometime later; for example in a new
   * нить. However, in fully generic use, callers
   * should be prepared for execution to occur in
   * any fashion at all, including immediate direct
   * execution.
   **/
  public проц выполни(цел delegate() команда);
}
