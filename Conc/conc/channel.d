/* \file канал
 * \brief Interface for inter-нить queues
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
	07May2004  Mike Swieton     Translated to D
*/

module conc.channel;

import conc.puttable;
import conc.takable;

/** 
 * Главный интерфейс для буферов, очередей, пайпов (туннелей), проводов и проч.
 * <p>
 * Канал представляет собой то, куда можно поместить элементы
 * и откуда их можно извлечь. Как в случае с интерфейсом Синх 
 * предоставляются обе политики блокировки (помести(x), возьми),
 * и таймаутов (предложи(x, мсек), запроси(мсек)).  Использование
 * нулевого таймаута для предложи и запроси приводит к политике pure balking.
 * <p>
 * To aid in efforts to use Channels in a more typesafe manner,
 * this interface extends Помещаемое and Извлекаемое. You can restrict
 * arguments of instance variables to this type as a way of
 * guaranteeing that producers never try to возьми, or consumers помести.
 * for example:
 * <pre>
 * class Producer {
 *   final Помещаемое!(Объект) chan;
 *   this(Помещаемое!(Объект) канал) { chan = канал; }
 *   public проц пуск() {
 *     for(;;) { chan.помести(produce()); }
 *   }
 *   Объект produce() { ... }
 * }
 *
 *
 * class Consumer {
 *   final Извлекаемое!(Объект) chan;
 *   this(Извлекаемое!(Объект) канал) { chan = канал; }
 *   public проц пуск() {
 *     for(;;) { consume(chan.возьми()); }
 *   }
 *   проц consume(Объект x) { ... }
 * }
 *
 * цел main(char[][] args) {
 *   Канал!(Объект) chan = new SomeChannelImplementation!(Объект)();
 *   Producer p = new Producer(chan);
 *   Consumer c = new Consumer(chan);
 *   new Нить(&p.пуск).старт();
 *   new Нить(&c.пуск).старт();
 * }
 * </pre>
 * <p>
 * A given канал implementation might or might not have bounded
 * ёмкость or другое insertion constraints, so in general, you cannot tell if a
 * given помести will block. However, Channels that are designed to have an element
 * ёмкость (and so always block when full) should implement the ОграниченныйКанал
 * subinterface.
 * <p>
 * Channels may hold any subclass of Объект. However,
 * insertion of пусто is not in general supported. Implementations
 * may (all currently do) enforce this with contracts.
 * <p>
 * By design, the Канал interface does not support any methods to determine
 * the current число of elements being held in the канал.  This decision
 * reflects the fact that in concurrent programming, such methods are so rarely
 * useful that including them invites misuse; at best they could provide a
 * snapshot of current state, that could change immediately after being
 * reported.  It is better practice to instead use запроси and предложи to try to
 * возьми and помести elements without blocking. For example, to empty out the
 * current contents of a канал, you could write:
 * <pre>
 *  for (;;) {
 *     Объект элт = канал.запроси(0);
 *     if (элт != пусто)
 *       process(элт);
 *     else
 *       break;
 *  }
 * </pre>
 * <p>
 * However, it is possible to determine whether an элт
 * exists in a Канал via <code>подбери</code>, which returns
 * but does NOT remove the следщ элт that can be taken (or пусто
 * if there is no such элт). The подбери operation has a limited
 * range of applicability, and must be used with care. Unless it
 * is known that a given нить is the only possible consumer
 * of a канал, and that no время-out-based <code>предложи</code> operations
 * are ever invoked, there is no guarantee that the элт returned
 * by подбери will be available for a subsequent возьми.
 * <p>
 * When appropriate, you can define an пуст_ли method to
 * return whether <code>подбери</code> returns пусто.
 * <p>
 * Also, as a compromise, even though it does not appear in interface,
 * implementation классы that can readily compute the число
 * of elements support a <code>размер()</code> method. This allows careful
 * use, for example in очередь length monitors, appropriate to the
 * particular implementation constraints and properties.
 * <p>
 * All channels allow multiple producers and/or consumers.
 * They do not support any kind of <em>close</em> method
 * to shut down operation or indicate completion of particular
 * producer or consumer threads. 
 * If you need to сигнал completion, one way to do it is to
 * create a class such as
 * <pre>
 * class EndOfStream { 
 *    // Application-dependent field/methods
 * }
 * </pre>
 * And to have producers помести an instance of this class into
 * the канал when they are done. The consumer side can then
 * check this via
 * <pre>
 *   Объект x = aChannel.возьми();
 *   if (cast(EndOfStream(x) != пусто) 
 *     // special actions; perhaps terminate
 *   else
 *     // process normally
 * </pre>
 * <p>
 * In время-out based methods (запроси(мсек) and предложи(x, мсек), 
 * время bounds are interpreted in
 * a coarse-grained, best-effort fashion. Since there is no
 * way in D to escape out of a жди for a synchronized
 * method/block, время bounds can sometimes be exceeded when
 * there is a lot contention for the канал. Additionally,
 * some Канал semantics entail a ``point of
 * no return'' where, once some parts of the operation have completed,
 * others must follow, regardless of время bound.
 * <p>
 * If a помести returns normally, an предложи returns да, or a помести or запроси returns
 * non-пусто, the operation completed successfully.  In all другое cases, the
 * operation fails cleanly -- the element is not помести or taken.
 * <p>
 * As with Синх классы, spinloops are not directly supported,
 * are not particularly recommended for routine use, but are not hard 
 * to construct. For example, here is an exponential backoff version:
 * <pre>
 * Объект backOffTake(Канал!(Объект) q) {
 *   дол времяОжидания = 0;
 *   for (;;) {
 *      Объект x = q.запроси(0);
 *      if (x != пусто)
 *        return x;
 *      else {
 *        usleep(времяОжидания);
 *        времяОжидания = 3 * времяОжидания / 2 + 1;
 *      }
 *    }
 * </pre>
 * @see Синх 
 * @see ОграниченныйКанал 
**/

interface Канал(T) : Помещаемое!(T), Извлекаемое!(T) {

  /** 
   * Place элт in the канал, possibly ждущий indefinitely until
   * it can be accepted. Channels implementing the ОграниченныйКанал
   * subinterface are generally guaranteed to block on puts upon
   * reaching ёмкость, but другое implementations may or may not block.
   * @param элт the element to be inserted. Should be non-пусто.
  **/
  public проц помести(T элт);

  /** 
   * Place элт in канал only if it can be accepted within
   * мсек milliseconds. The время bound is interpreted in
   * a coarse-grained, best-effort fashion. 
   * @param элт the element to be inserted. Should be non-пусто.
   * @param мсек the число of milliseconds to жди. If less than
   * or equal to zero, the method does not perform any по_времени waits,
   * but might still require
   * access to a synchronization замок, which can impose unbounded
   * delay if there is a lot of contention for the канал.
   * @return да if accepted, else нет
  **/
  public бул предложи(T элт, дол мсек);

  /** 
   * Return and remove an элт from канал, 
   * possibly ждущий indefinitely until
   * such an элт exists.
   * @return  some элт from the канал. Different implementations
   *  may guarantee various properties (such as FIFO) about that элт
   *
  **/
  public T возьми();


  /** 
   * Return and remove an элт from канал only if one is available within
   * мсек milliseconds. The время bound is interpreted in a coarse
   * grained, best-effort fashion.
   * @param мсек the число of milliseconds to жди. If less than
   *  or equal to zero, the operation does not perform any по_времени waits,
   * but might still require
   * access to a synchronization замок, which can impose unbounded
   * delay if there is a lot of contention for the канал.
   * @return some элт, or пусто if the канал is empty.
  **/

  public T запроси(дол мсек);

  /**
   * Return, but do not remove object at head of Канал,
   * or пусто if it is empty.
   **/
  public T подбери();
}

/**
	* Useful class for boxing primitive types for storage in Channels.
	* The Канал APIs do not support parameterization on any type that cannot be
	* пусто, so this class is useful to оберни them for storage.
	*/
class оберни(T)
{
	public:
		/** The stored значение */
		T значение;

		this() { }
		this(T t) { значение = t; }
}
