/* \file мютекс.d
 * \brief Mutual exlusive замок
 */

/*
  Originally written by Doug Lea and released into the public domain.
  This may be used for any purposes whatsoever without acknowledgment.
  Thanks for the assistance and support of Sun Microsystems Labs,
  and everyone contributing, testing, and using this code.
  Translated to D by Ben Hinkle 2004.
*/

module conc.mutex;

import conc.sync;

private import conc.waitnotify;
private import cidrus;

private import thread; // for unittest

/** \class Мютекс
 * \brief A simple non-reentrant mutual exclusion замок.
 * 
 * The замок is free upon construction. Each обрети gets the
 * замок, and each отпусти frees it. Releasing a замок that
 * is already free has no effect. 
 * 
 * This implementation makes no пытайся to provide any fairness
 * or ordering guarantees. If you need them, consider using one of
 * the Семафор implementations as a locking mechanism.
 * 
 * <b>Sample usage</b><br>
 * 
 * Мютекс can be useful in constructions that cannot be
 * expressed using synchronized blocks because the
 * обрети/отпусти pairs do not occur in the same method or
 * code block. For example, you can use them for hand-over-hand
 * locking across the nodes of a linked list. This allows
 * extremely fine-grained locking,  and so increases 
 * potential concurrency, at the cost of additional complexity and
 * overhead that would normally make this worthwhile only in cases of
 * extreme contention.
 * \code
 * class Node { 
 *   Объект элт; 
 *   Node следщ; 
 *   Мютекс замок = new Мютекс(); // each node keeps its own замок
 *
 *   Node(Объект x, Node n) { элт = x; следщ = n; }
 * }
 *
 * class List {
 *    protected Node head; // pointer to первое node of list
 *
 *    // Use plain synchronization to protect head field.
 *    //  (We could instead use a Мютекс here too but there is no
 *    //  reason to do so.)
 *    protected synchronized Node getHead() { 
 *      return head; 
 *    }
 *
 *    бул search(Объект x) {
 *      Node p = getHead();
 *      if (p is пусто) return нет;
 *
 *      //  (This could be made more compact, but for clarity of illustration,
 *      //  all of the cases that can arise are handled separately.)
 *
 *      p.замок.обрети();              // Prime loop by acquiring первое замок.
 *                                     //    (If the обрети fails due to
 *                                     //    interrupt, the method will throw
 *                                     //    ИсклОжидания now,
 *                                     //    so there is no need for any
 *                                     //    further cleanup.)
 *      for (;;) {
 *        if (x == p.элт) {
 *          p.замок.отпусти();          // отпусти current before return
 *          return да;
 *        }
 *        else {
 *          Node nextp = p.следщ;
 *          if (nextp is пусто) {
 *            p.замок.отпусти();       // отпусти final замок that was held
 *            return нет;
 *          }
 *          else {
 *            try {
 *              nextp.замок.обрети(); // дай следщ замок before releasing current
 *            }
 *            catch (ИсклОжидания искл) {
 *              p.замок.отпусти();    // also отпусти current if обрети fails
 *              throw искл;
 *            }
 *            p.замок.отпусти();      // отпусти старый замок now that new one held
 *            p = nextp;
 *          }
 *        }
 *      }
 *    }
 *
 *    проц synchronized add(Объект x) { // simple prepend
 *      // The use of `synchronized'  here protects only head field.
 *      // The method does not need to жди out другое traversers 
 *      // who have already made it past head.
 *      head = new Node(x, head);
 *    }
 *
 *    // ...  другое similar traversal and update methods ...
 * }
 * \endcode
 *
 */

class Мютекс : ОбъектЖдиУведоми,Синх  {

  protected бул inuse_ = нет; ///< The замок status

  synchronized проц обрети() {
    try {
      while (inuse_) жди();
      inuse_ = да;
    }
    catch (ИсклОжидания искл) {
      уведоми();
      throw искл;
    }
  }

  synchronized проц отпусти()  {
    inuse_ = нет;
    уведоми(); 
  }


  synchronized бул пытайся(дол мсек) {
    if (!inuse_) {
      inuse_ = да;
      return да;
    }
    else if (мсек <= 0)
      return нет;
    else {
      дол времяОжидания = мсек;
      дол старт = clock();
      try {
	for (;;) {
	  жди(времяОжидания);
	  if (!inuse_) {
	    inuse_ = да;
	    return да;
	  }
	  else {
	    времяОжидания = мсек - (clock() - старт);
	    if (времяОжидания <= 0) 
	      return нет;
	  }
	}
      }
      catch (ИсклОжидания искл) {
	уведоми();
	throw искл;
      }
    }
  }

  unittest {
    class Test {
      Мютекс замок;
      цел acquired;
      Нить[] t;
      цел f() {
	цел n;
	Нить tt = Нить.дайЭту();
	for (n=0; n < t.length; n++) {
	  if (tt is t[n])
	    break;
	}
	эхо(" нить %d started\n",n);
	замок.обрети();
	эхо(" нить %d aquired\n",n);
	замок.отпусти();
	acquired++;
	эхо(" нить %d released\n",n);
	return 0;
      }
      проц пуск() {
	замок = new Мютекс();
	acquired = 0;
	t = new Нить[3];
	цел n;
	for (n=0; n<t.length; n++) {
	  t[n] = new Нить(&this.f);
	}
	эхо("starting мютекс unittest\n");
	for (n=0; n<t.length; n++) {
	  t[n].старт();
	}
	while (acquired != n)
	  Нить.рви();
	эхо("finished мютекс unittest\n");
      }
    }
    Test t = new Test();
    t.пуск();
  }
}
