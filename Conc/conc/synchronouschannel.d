/* \file synchronouschannel.d
 * \brief A рандеву канал.
 */

/*
  Originally written by Doug Lea and released into the public domain.
  This may be used for any purposes whatsoever without acknowledgment.
  Thanks for the assistance and support of Sun Microsystems Labs,
  and everyone contributing, testing, and using this code.
  Translated to D by Ben Hinkle 2004.
*/

module conc.synchronouschannel;

import conc.boundedchannel;
import conc.linkednode;

private import conc.sync; // for ИсклОжидания
private import conc.waitnotify;
private import cidrus;

private import thread; // for unittest

/** \class СинхронныйКанал
 * \brief A рандеву канал, similar to those used in CSP and Ada.
 *
 *  Each помести must жди for a возьми, and vice versa.  Synchronous
 * channels are well suited for handoff designs, in which an object
 * running in one нить must synch up with an object running in
 * another нить in order to hand it some information, событие, or
 * задание.
 *
 * <p> If you only need threads to synch up without
 * exchanging information, consider using a Барьер. If you need
 * bidirectional exchanges, consider using a Рандеву.  <p>
 */

class СинхронныйКанал(T) : ОграниченныйКанал!(T) {

  /*
    This implementation divides actions into two cases for puts:

    * An arriving putter that does not already have a ждущий taker 
      creates a node holding элт, and then waits for a taker to возьми it.
    * An arriving putter that does already have a ждущий taker fills
      the слот node created by the taker, and notifies it to continue.

   And symmetrically, two for takes:

    * An arriving taker that does not already have a ждущий putter
      creates an empty слот node, and then waits for a putter to fill it.
    * An arriving taker that does already have a ждущий putter takes
      элт from the node created by the putter, and notifies it to continue.

   This requires keeping two simple queues: ждущиеРазмещения and ждущиеВымещения.
   
   When a помести or возьми ждущий for the actions of its counterpart
   aborts due to interruption or таймаут, it marks the node
   it created as Canceled, which causes its counterpart to retry
   the entire помести or возьми sequence.
  */

  /* 
   *  Helper class to define a ЛинкованныйУзел that supports жди()/уведоми()
   */
  private class ОжидаемыйЛинкованныйУзел(T) : ЛинкованныйУзел!(T) {
    бул отменён;

    mixin ЖдиУведоми;
    this()  { иницЖдиУведоми(); }
    ~this() { удалиЖдиУведоми(); }
    this(T x) {
      иницЖдиУведоми();
      super(x);
    }
    this(T x, .ЛинкованныйУзел!(T) n) {
      иницЖдиУведоми();
      super(x,n);
    }
  }

  /**
   * Simple FIFO очередь class to hold ждущий puts/takes.
   */
  private class Очередь(T) {
    ОжидаемыйЛинкованныйУзел!(T) head;
    ОжидаемыйЛинкованныйУзел!(T) last;

    проц enq(ОжидаемыйЛинкованныйУзел!(T) p) { 
      if (last is пусто) 
        last = head = p;
      else 
        last.следщ = p;
        last = p;
    }

    ОжидаемыйЛинкованныйУзел!(T) deq() {
      ОжидаемыйЛинкованныйУзел!(T) p = head;
      if (!(p is пусто) && (head = cast(ОжидаемыйЛинкованныйУзел!(T))p.следщ) is пусто) 
        last = пусто;
      return p;
    }
  }

  this() {
    ждущиеРазмещения = new Очередь!(T);
    ждущиеВымещения = new Очередь!(T);
  }

  private Очередь!(T) ждущиеРазмещения;
  private Очередь!(T) ждущиеВымещения;

  /**
   * @return zero --
   * Synchronous channels have no internal ёмкость.
   */
  цел ёмкость() { return 0; }

  /**
   * @return пусто --
   * Synchronous channels do not hold contents unless actively taken
   */
  T подбери() {  return T.init;  }


  проц помести(T x) {
    // This code is conceptually straightforward, but messy
    // because we need to intertwine handling of помести-arrives первое
    // vs возьми-arrives первое cases.

    // Outer loop is to handle retry due to cancelled ждущий taker
    for (;;) { 

      // Exactly one of элт or слот will be nonnull at end of
      // synchronized block, depending on whether a помести or a возьми
      // arrived первое. 
      ОжидаемыйЛинкованныйУзел!(T) слот;
      ОжидаемыйЛинкованныйУзел!(T) элт = пусто;

      synchronized(this) {
        // Try to match up with a ждущий taker; fill and сигнал it below
        слот = ждущиеВымещения.deq();

        // If no takers yet, create a node and жди below
        if (слот is пусто) 
          ждущиеРазмещения.enq(элт = new ОжидаемыйЛинкованныйУзел!(T)(x));
      }
      if (!(слот is пусто)) { // There is a ждущий taker.
        // Fill in the слот created by the taker and сигнал taker to
        // continue.
        synchronized(слот) {
          if (!слот.отменён) {
	    слот.значение = x;
            слот.уведоми();
	    return;
          }
          // else the taker has cancelled, so retry внешний loop
        }
      }

      else { 
        // Wait for a taker to arrive and возьми the элт.
        synchronized(элт) {
          try {
            while (!(элт.значение is T.init))
              элт.жди();
	    return;
          }
          catch (ИсклОжидания ie) {
            // If элт was taken, return normally but установи interrupt status
            if (элт.значение is T.init) {
	      return;
            }
            else {
              элт.отменён = да;
              throw ie;
            }
          }
        }
      }
    }
  }

  T возьми() {
    // Entirely symmetric to помести()

    for (;;) {
      ОжидаемыйЛинкованныйУзел!(T) элт;
      ОжидаемыйЛинкованныйУзел!(T) слот = пусто;

      synchronized(this) {
        элт = ждущиеРазмещения.deq();
        if (элт is пусто) 
          ждущиеВымещения.enq(слот = new ОжидаемыйЛинкованныйУзел!(T)());
      }

      if (!(элт is пусто)) {
        synchronized(элт) {
          T x = элт.значение;
          if (!элт.отменён) {
            элт.значение = T.init;
            элт.следщ = пусто;
            элт.уведоми();
            return x;
          }
        }
      }

      else {
        synchronized(слот) {
          try {
            for (;;) {
              T x;
	      x = слот.значение;
              if (!(x is T.init)) {
                слот.следщ = пусто;
                return x;
              }
              else {
                слот.жди();
	      }
            }
          }
          catch(ИсклОжидания ie) {
            T x = слот.значение;
            if (!слот.отменён) {
              слот.значение = T.init;
              слот.следщ = пусто;
              return x;
            }
            else {
              слот.отменён = да;
              throw ie;
            }
          }
        }
      }
    }
  }

  /*
    Offer and запроси are just like помести and возьми, except even messier.
   */
  бул предложи(T x, дол мсек) {
    дол времяОжидания = мсек;
    дол времяСтарта = 0; // lazily initialize below if needed
    
    for (;;) {

      ОжидаемыйЛинкованныйУзел!(T) слот;
      ОжидаемыйЛинкованныйУзел!(T) элт = пусто;

      synchronized(this) {
        слот = ждущиеВымещения.deq();
        if (слот is пусто) {
          if (времяОжидания <= 0) 
            return нет;
          else 
            ждущиеРазмещения.enq(элт = new ОжидаемыйЛинкованныйУзел!(T)(x));
        }
      }

      if (!(слот is пусто)) {
        synchronized(слот) {
          if (!слот.отменён) {
            слот.значение = x;
            слот.уведоми();
            return да;
          }
        }
      }

      дол now = clock();
      if (времяСтарта == 0) 
        времяСтарта = now;
      else 
        времяОжидания = мсек - (now - времяСтарта);

      if (!(элт is пусто)) {
        synchronized(элт) {
          try {
            for (;;) {
              if (элт.значение is пусто) 
                return да;
              if (времяОжидания <= 0) {
                элт.отменён = да;
                return нет;
              }
              элт.жди(времяОжидания);
              времяОжидания = мсек - (clock() - времяСтарта);
            }
          }
          catch (ИсклОжидания ie) {
            if (элт.значение is T.init) {
              return да;
            }
            else {
              элт.отменён = да;
              throw ie;
            }
          }
        }
      }
    }
  }

  T запроси(дол мсек) {
    дол времяОжидания = мсек;
    дол времяСтарта = 0;

    for (;;) {

      ОжидаемыйЛинкованныйУзел!(T) элт;
      ОжидаемыйЛинкованныйУзел!(T) слот = пусто;

      synchronized(this) {
        элт = ждущиеРазмещения.deq();
        if (элт is пусто) {
          if (времяОжидания <= 0) 
            return пусто;
          else 
            ждущиеВымещения.enq(слот = new ОжидаемыйЛинкованныйУзел!(T)());
        }
      }

      if (!(элт is пусто)) {
        synchronized(элт) {
          T x = элт.значение;
          if (!(элт.отменён)) {
            элт.значение = T.init;
            элт.следщ = пусто;
            элт.уведоми();
            return x;
          }
        }
      }

      дол now = clock();
      if (времяСтарта == 0) 
        времяСтарта = now;
      else 
        времяОжидания = мсек - (now - времяСтарта);

      if (!(слот is пусто)) {
        synchronized(слот) {
          try {
            for (;;) {
              T x = слот.значение;
              if (!(x is T.init)) {
                слот.значение = T.init;
                слот.следщ = пусто;
                return x;
              }
              if (времяОжидания <= 0) {
                слот.отменён = да;
                return пусто;
              }
              слот.жди(времяОжидания);
              времяОжидания = мсек - (clock() - времяСтарта);
            }
          }
          catch(ИсклОжидания ie) {
	    слот.отменён = да;
	    throw ie;
          }
        }
      }
    }
  }
}

/+ seems to seg-v when outside of class
unittest {
  эхо("starting СинхронныйКанал unittest\n");

  СинхронныйКанал!(Объект) x = new СинхронныйКанал!(Объект)();
  Объект a = new Объект;
  Объект b;
  цел ff() { b = x.возьми(); return 0; }
  Нить t = new Нить(&ff);
  t.старт();
  x.помести(a);
  for (цел k=0;k<1000;k++) Нить.жни();
  assert(a is b);
    
  эхо("finished СинхронныйКанал unittest\n");
}
+/



