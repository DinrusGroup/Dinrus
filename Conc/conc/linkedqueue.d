/* \file linkedqueue
 * \brief Basic Канал implementation
 */

/*
  Originally written by Doug Lea and released into the public domain.
  This may be used for any purposes whatsoever without acknowledgment.
  Thanks for the assistance and support of Sun Microsystems Labs,
  and everyone contributing, testing, and using this code.

  History:
  Date       Who                What
  11Jun1998  dl               Create public version
  25aug1998  dl               added подбери
  10dec1998  dl               added пуст_ли
  10oct1999  dl               замок on node object to ensure visibility
	07May2004  Mike Swieton     Translated to D
*/

module conc.linkedqueue;

import cidrus, stdrus:Нить;

import conc.channel;
import conc.linkednode;
import conc.sync;
import conc.waitnotify;

extern (C) цел sleep(бцел seconds);
alias sleep спи;
/**
 * A linked list based канал implementation.
 * The algorithm avoids contention between puts
 * and takes when the очередь is not empty. 
 * Normally a помести and a возьми can proceed simultaneously. 
 * (Although it does not allow multiple concurrent puts or takes.)
 * This class tends to perform more efficently than
 * другое Канал implementations in producer/consumer
 * applications.
 **/

class ЛинкованнаяОчередь(T) : Канал!(T) {

	protected alias ЛинкованныйУзел!(T) тип_узла;

  /** 
   * Dummy header node of list. The первое actual node, if it exists, is always 
   * at голова_.следщ. After each возьми, the старый первое node becomes the head.
   **/
  protected тип_узла голова_;         

  /**
   * Helper monitor for managing access to last node.
   **/
  protected final ОбъектЖдиУведоми поместитьЗамок_;

  /** 
   * The last node of list. Put() appends to list, so modifies последний_
   **/
  protected тип_узла последний_;         

  /**
   * The число of threads ждущий for a возьми.
   * Notifications are provided in помести only if greater than zero.
   * The bookkeeping is worth it here since in reasonably balanced
   * usages, the notifications will hardly ever be necessary, so
   * the call overhead to уведоми can be eliminated.
   **/
  protected цел ожиданиеЗабора_ = 0;  

  public this() {
    поместитьЗамок_ = new ОбъектЖдиУведоми(); 
    голова_ = new тип_узла; 
    последний_ = голова_;
  }

  /** Main mechanics for помести/предложи **/
  protected проц вставь(T x)
	in {
		assert(x !is пусто);
	} body { 
    synchronized(поместитьЗамок_) {
      тип_узла p = new тип_узла(x);
      synchronized(последний_) {
        последний_.следщ = p;
        последний_ = p;
      }
      if (ожиданиеЗабора_ > 0)
        поместитьЗамок_.уведоми();
    }
  }

  /** Main mechanics for возьми/запроси **/
  protected synchronized T извлеки() {
    synchronized(голова_) {
      T x = пусто;
      тип_узла первое = голова_.следщ;
      if (первое !is пусто) {
        x = первое.значение;
        первое.значение = пусто;
        голова_ = первое; 
      }
      return x;
    }
  }


  public проц помести(T x)
	in {
		assert(x !is пусто); 
	} body {
    вставь(x); 
  }

  public бул предложи(T x, дол мсек)
	in {
		assert(x !is пусто);
		assert(мсек >= 0);
	} body { 
    вставь(x); 
    return да;
  }

	public T возьми() {
		// try to извлеки. If fail, then enter жди-based retry loop
		T x = извлеки();
		if (x !is пусто)
			return x;
		else { 
			synchronized(поместитьЗамок_) {
				++ожиданиеЗабора_;
				for (;;) {
					x = извлеки();
					if (x !is пусто) {
						--ожиданиеЗабора_;
						return x;
					}
					else {
						try {
							поместитьЗамок_.жди(); 
						} catch (ИсклОжидания искл)
						{
							поместитьЗамок_.уведоми();
							throw искл;
						}
					}
				}
			}
		}
	}

  public T подбери() {
    synchronized(голова_) {
      тип_узла первое = голова_.следщ;
      if (первое !is пусто) 
        return первое.значение;
      else 
        return пусто;
    }
  }    


  public бул пуст_ли() {
    synchronized(голова_) {
			return голова_.следщ is пусто;
		}
	}    

	public T запроси(дол мсек)
	in {
		assert(мсек >= 0);
	} body {
		T x = извлеки();
		if (x !is пусто) 
			return x;
		else {
			synchronized(поместитьЗамок_) {
				дол времяОжидания = мсек;
				дол старт = (мсек <= 0)? 0 : clock();
				++ожиданиеЗабора_;
				for (;;) {
					x = извлеки();
					if (x !is пусто || времяОжидания <= 0) {
						--ожиданиеЗабора_;
						return x;
					}
					else {
						try
						{
							поместитьЗамок_.жди(времяОжидания); 
							времяОжидания = мсек - (clock() - старт);
						} catch (ИсклОжидания искл) {
							поместитьЗамок_.уведоми();
							throw искл;
						}
					}
				}
			}
		}
	}
}

unittest
{
	class A
	{
	}

	эхо("started linkedqueue test 1\n");
	ЛинкованнаяОчередь!(A) lq = new ЛинкованнаяОчередь!(A);
	A o = new A;
	lq.помести(o);
	assert(o is lq.возьми());
	эхо("finished linkedqueue test 1\n");
}

private import thread;

unittest
{
	// can't parameterize on Объект, for some reason
	class A
	{
	}

	эхо("started linkedqueue test 2\n");
	ЛинкованнаяОчередь!(A) lq = new ЛинкованнаяОчередь!(A);

	бул running = нет;
	A o = new A;

	цел f1() {
		running = да;
		assert(lq.возьми() == o);
		running = нет;
		return 0;
	}

	Нить t = new Нить(&f1);

	t.старт();
	Нить.рви();

	assert(running == да);

	lq.помести(o);

	// give child время to work
	Нить.рви();
	спи(1);

	assert(running == нет);
	эхо("finished linkedqueue test 2\n");
}
