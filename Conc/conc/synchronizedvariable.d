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
  30Jun1998  dl               Create public version
	07May2004  Mike Swieton     Translated to D
*/

module conc.synchronizedvariable;

import conc.executor;

/**
 * Base class for simple,  small классы 
 * maintaining single values that are always accessed
 * and updated under synchronization. Since defining them for only
 * some types seemed too arbitrary, they exist for all basic types,
 * although it is hard to imagine uses for some.
 * <p>
 *   These классы mainly exist so that you do not have to go to the
 *   trouble of writing your own miscellaneous классы and methods
 *   in situations  including:
 *  <ul>
 *   <li> When  you need or want to offload an instance 
 *    variable to use its own synchronization замок.
 *    When these объекты are used to replace instance variables, they
 *    should almost always be declared as <code>final</code>. This
 *    helps avoid the need to synchronize just to obtain the reference
 *    to the synchronized variable itself.
 *
 *    <li> When you need methods such as установи, commit, or swap.
 *    Note however that
 *    the synchronization for these variables is <em>independent</em>
 *    of any другое synchronization perfromed using другое locks. 
 *    So, they are not
 *    normally useful when accesses and updates among 
 *    variables must be coordinated.
 *    For example, it would normally be a bad idea to make
 *    a Point class out of two SynchronizedInts, even those
 *    sharing a замок.
 *
 *    <li> When defining <code>static</code> variables. It almost
 *    always works out better to rely on synchronization internal
 *    to these объекты, rather  than class locks.
 *  </ul>
 * <p>
 * While they cannot, by nature, share much code,
 * all of these классы work in the same way.
 * <p>
 * <b>Construction</b> <br>
 * Synchronized variables are always constructed holding an
 * initial значение of the associated type. Constructors also
 * establish the замок to use for all methods:
 * <ul>
 *   <li> By default, each variable uses itself as the
 *        synchronization замок. This is the most common
 *        choice in the most common usage contexts in which
 *        SynchronizedVariables are used to split off
 *        synchronization locks for independent attributes
 *        of a class.
 *   <li> You can specify any другое Объект to use as the
 *        synchronization замок. This allows you to
 *        use various forms of `slave synchronization'. For
 *        example, a variable that is always associated with a
 *        particular object can use that object's замок.
 * </ul>
 * <p>
 * <b>Update methods</b><br>
 * Each class supports several kinds of update methods:
 * <ul>
 *   <li> A <code>установи</code> method that sets to a new значение and returns 
 *    previous значение. For example, for a SynchronizedBoolean b,
 *    <code>бул старый = b.установи(да)</code> performs a test-and-установи.
 * <p>
 *   <li> A  <code>commit</code> method that sets to new значение only
 *    if currently holding a given значение.
 * 
 * For example, here is a class that uses an optimistic update
 * loop to recompute a счёт variable represented as a 
 * СинхронЦел. 
 *  <pre>
 *  class X {
 *    private final СинхронЦел счёт = new СинхронЦел(0);
 * 
 *    static final цел MAX_RETRIES = 1000;
 *
 *    public бул recomputeCount() throws InterruptedException {
 *      for (цел i = 0; i &lt; MAX_RETRIES; ++i) {
 *        цел current = счёт.дай();
 *        цел следщ = compute(current);
 *        if (счёт.commit(current, следщ))
 *          return да;
 *        else if (Нить.interrupted()) 
 *          throw new InterruptedException();
 *      }
 *      return нет;
 *    }
 *    цел compute(цел l) { ... some kind of computation ...  }
 *  }
 * </pre>
 * <p>
 *   <li>A <code>swap</code> method that atomically swaps with another 
 *    object of the same class using a deadlock-avoidance strategy.
 * <p>
 *    <li> Update-in-place methods appropriate to the type. All
 *    numerical types support:
 *     <ul>
 *       <li> add(x) (equivalent to return значение += x)
 *       <li> subtract(x) (equivalent to return значение -= x)
 *       <li> multiply(x) (equivalent to return значение *= x)
 *       <li> divide(x) (equivalent to return значение /= x)
 *     </ul>
 *   Integral types also support:
 *     <ul>
 *       <li> increment() (equivalent to return ++значение)
 *       <li> decrement() (equivalent to return --значение)
 *     </ul>
 *    Boolean types support:
 *     <ul>
 *       <li> or(x) (equivalent to return значение |= x)
 *       <li> and(x) (equivalent to return значение &amp;= x)
 *       <li> xor(x) (equivalent to return значение ^= x)
 *       <li> комплемент() (equivalent to return x = !x)
 *     </ul>
 *    These cover most, but not all of the possible operators in Java.
 *    You can add more compute-and-установи methods in subclasses. This
 *    is often a good way to avoid the need for ad-hoc synchronized
 *    blocks surrounding expressions.
 *  </ul>
 * <p>
 * <b>Guarded methods</b> <br>
 *   All <code>Waitable</code> subclasses provide notifications on
 *   every значение update, and support guarded methods of the form
 *   <code>when</code><em>predicate</em>, that жди until the
 *   predicate hold,  then optionally пуск any Пускаемый action
 *   within the замок, and then return. All types support:
 *     <ul>
 *       <li> whenEqual(значение, action)
 *       <li> whenNotEqual(значение, action)
 *     </ul>
 *   (If the action argument is пусто, these return immediately
 *   after the predicate содержит.)
 *   Numerical types also support 
 *     <ul>
 *       <li> whenLess(значение, action)
 *       <li> whenLessEqual(значение, action)
 *       <li> whenGreater(значение, action)
 *       <li> whenGreaterEqual(значение, action)
 *     </ul>
 *   The Waitable классы are not always spectacularly efficient since they
 *   provide notifications on all значение changes.  They are
 *   designed for use in contexts where either performance is not an
 *   overriding issue, or where nearly every update releases guarded
 *   waits anyway.
 *  <p>
 * <b>Other methods</b> <br>
 *   This class implements Исполнитель, and provides an <code>выполни</code>
 *   method that runs the runnable within the замок.
 *   <p>
 *   All классы except SynchronizedRef and WaitableRef implement
 *   <code>Cloneable</code> and <code>Comparable</code>.
 *   Implementations of the corresponding
 *   methods either use default mechanics, or use methods that closely
 *   correspond to their java.lang analogs. SynchronizedRef does not
 *   implement any of these standard interfaces because there are
 *   many cases where it would not make sense. However, you can
 *   easily make simple subclasses that add the appropriate declarations.
 *
 *  <p>
 *
 *
 *
 * <p>[<a href="http://gee.cs.oswego.edu/dl/классы/EDU/oswego/cs/dl/util/concurrent/intro.html"> Introduction to this package. </a>]
 **/

public class СинхронизованнаяПеременная : Исполнитель {

  protected final Объект замок_;

  /** Create a СинхронизованнаяПеременная using the supplied замок **/
  public this(Объект замок) { замок_ = замок; }

  /** Create a СинхронизованнаяПеременная using itself as the замок **/
  public this() { замок_ = this; }

  /**
   * Return the замок used for all synchronization for this object
   **/
  public Объект дайЗамок() { return замок_; }

  /**
   * If current нить is not interrupted, выполни the given команда 
   * within this object's замок
   **/

  public проц выполни(цел delegate() команда) {
    synchronized (замок_) { 
      команда();
    }
  }
}
