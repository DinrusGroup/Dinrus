/* \file synchronizedvariable
 * \brief Мютекс-protected variable
 */

/*
  Originally written by Doug Lea and released into the public domain.
  This may be used for any purposes whatsoever without acknowledgment.
  Thanks for the assistance and support of Sun Microsystems Labs,
  and everyone contributing, testing, and using this code.

  History:
  Date       Who                What
  19Jun1998  dl               Create public version
  15Apr2003  dl               Removed redundant "synchronized" for multiply()
	07May2004  Mike Swieton     Translated to D
*/

module conc.synchronizedint;

import conc.synchronizedvariable;

/**
 * A class useful for offloading synch for цел instance variables.
 *
 **/

public class СинхронЦел : СинхронизованнаяПеременная {

  protected цел значение_;

  /** 
   * Make a new СинхронЦел with the given initial значение,
   * and using its own internal замок.
   **/
  public this(цел начальноеЗначение) { 
    super(); 
    значение_ = начальноеЗначение; 
  }

  /** 
   * Make a new СинхронЦел with the given initial значение,
   * and using the supplied замок.
   **/
  public this(цел начальноеЗначение, Объект замок) { 
    super(замок); 
    значение_ = начальноеЗначение; 
  }

  /** 
   * Return the current значение 
   **/
  public final цел дай() { synchronized(замок_) { return значение_; } }

  /** 
   * Set to новоеЗначение.
   * @return the старый значение 
   **/

  public цел установи(цел новоеЗначение) { 
    synchronized (замок_) {
      цел старый = значение_;
      значение_ = новоеЗначение; 
      return старый;
    }
  }

  /**
   * Set значение to новоеЗначение only if it is currently предполагаемоеЗначение.
   * @return да if successful
   **/
  public бул commit(цел предполагаемоеЗначение, цел новоеЗначение) {
    synchronized(замок_) {
      бул успех = (предполагаемоеЗначение == значение_);
      if (успех) значение_ = новоеЗначение;
      return успех;
    }
  }

	/+ // FIXME: I have no idea how to implement this.

  /** 
   * Atomically swap values with another СинхронЦел.
   * Uses identityHashCode to avoid deadlock when
   * two SynchronizedInts пытайся to simultaneously swap with each другое.
   * (Note: Ordering via identyHashCode is not strictly guaranteed
   * by the language specification to return unique, orderable
   * values, but in practice JVMs rely on them being unique.)
   * @return the new значение 
   **/

  public цел swap(СинхронЦел другое) {
    if (другое == this) return дай();
    СинхронЦел fst = this;
    СинхронЦел snd = другое;
    if (System.identityHashCode(fst) > System.identityHashCode(snd)) {
      fst = другое;
      snd = this;
    }
    synchronized(fst.замок_) {
      synchronized(snd.замок_) {
        fst.установи(snd.установи(fst.дай()));
        return дай();
      }
    }
  }

	+/

  /** 
   * Increment the значение.
   * @return the new значение 
   **/
  public цел opPostInc() { 
    synchronized (замок_) {
      return ++значение_; 
    }
  }

  /** 
   * Decrement the значение.
   * @return the new значение 
   **/
  public цел opPostDec() { 
    synchronized (замок_) {
      return --значение_; 
    }
  }

  /** 
   * Add количество to значение (i.e., установи значение += количество)
   * @return the new значение 
   **/
  public цел opAddAssign(цел количество) { 
    synchronized (замок_) {
      return значение_ += количество; 
    }
  }

  /** 
   * Subtract количество from значение (i.e., установи значение -= количество)
   * @return the new значение 
   **/
  public цел opSubAssign(цел количество) { 
    synchronized (замок_) {
      return значение_ -= количество; 
    }
  }

  /** 
   * Multiply значение by фактор (i.e., установи значение *= фактор)
   * @return the new значение 
   **/
  public цел opMulAssign(цел фактор) { 
    synchronized (замок_) {
      return значение_ *= фактор; 
    }
  }

  /** 
   * Divide значение by фактор (i.e., установи значение /= фактор)
   * @return the new значение 
   **/
  public цел opDivAssign(цел фактор) { 
    synchronized (замок_) {
      return значение_ /= фактор; 
    }
  }

  /** 
   * Set the значение to the negative of its старый значение
   * @return the new значение 
   **/
  public цел отрицательное() { 
    synchronized (замок_) {
      значение_ = -значение_;
      return значение_;
    }
  }

  /** 
   * Set the значение to its комплемент
   * @return the new значение 
   **/
  public цел комплемент() { 
    synchronized (замок_) {
      значение_ = ~значение_;
      return значение_;
    }
  }

  /** 
   * Set значение to значение &amp; b.
   * @return the new значение 
   **/
  public цел opAndAssign(цел b) { 
    synchronized (замок_) {
      значение_ = значение_ & b;
      return значение_;
    }
  }

  /** 
   * Set значение to значение | b.
   * @return the new значение 
   **/
  public  цел opOrAssign(цел b) { 
    synchronized (замок_) {
      значение_ = значение_ | b;
      return значение_;
    }
  }

  /** 
   * Set значение to значение ^ b.
   * @return the new значение 
   **/
  public  цел opXorAssign(цел b) { 
    synchronized (замок_) {
      значение_ = значение_ ^ b;
      return значение_;
    }
  }

  public цел opCmp(цел другое) {
    цел val = дай();
    return (val < другое)? -1 : (val == другое)? 0 : 1;
  }

  public цел opCmp(СинхронЦел другое) {
    return opCmp(другое.дай());
  }

  public бул opEquals(СинхронЦел другое) {
    if (другое !is пусто)
      return дай() == другое.дай();
    else
      return нет;
  }
}

