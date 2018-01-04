
module gtkD.glib.Atomic;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;






/**
 * Description
 * The following functions can be used to atomically access integers and
 * pointers. They are implemented as inline assembler function on most
 * platforms and use slower fall-backs otherwise. Using them can sometimes
 * save you from using a performance-expensive GMutex to protect the
 * integer or pointer.
 * The most important usage is reference counting. Using
 * g_atomic_int_inc() and g_atomic_int_dec_and_test() makes reference
 * counting a very fast operation.
 * Note
 * You must not directly read integers or pointers concurrently accessed
 * by multiple threads, but use the atomic accessor functions instead.
 * That is, always use g_atomic_int_get() and g_atomic_pointer_get() for
 * read outs.
 * They provide the neccessary synchonization mechanisms like memory
 * barriers to access memory locations concurrently.
 * Note
 * If you are using those functions for anything apart from simple
 * reference counting, you should really be aware of the implications of
 * doing that. There are literally thousands of ways to shoot yourself in
 * the foot. So if in doubt, use a GMutex. If you don't know, what
 * memory barriers are, do not use anything but g_atomic_int_inc() and
 * g_atomic_int_dec_and_test().
 * Note
 * It is not safe to set an integer or pointer just by assigning to it,
 * when it is concurrently accessed by other threads with the following
 * functions. Use g_atomic_int_compare_and_exchange() or
 * g_atomic_pointer_compare_and_exchange() respectively.
 */
public class Atomic
{
	
	/**
	 */
	
	/**
	 * Reads the value of the integer pointed to by atomic. Also acts as
	 * a memory barrier.
	 * Since 2.4
	 * Params:
	 * atomic = a pointer to an integer
	 * Returns:the value of *atomic
	 */
	public static int intGet(int* atomic);
	
	/**
	 * Sets the value of the integer pointed to by atomic.
	 * Also acts as a memory barrier.
	 * Since 2.10
	 * Params:
	 * atomic = a pointer to an integer
	 * newval = the new value
	 */
	public static void intSet(int* atomic, int newval);
	
	/**
	 * Atomically adds val to the integer pointed to by atomic.
	 * Also acts as a memory barrier.
	 * Since 2.4
	 * Params:
	 * atomic = a pointer to an integer.
	 * val = the value to add to *atomic.
	 */
	public static void intAdd(int* atomic, int val);
	
	/**
	 * Atomically adds val to the integer pointed to by atomic. It returns
	 * the value of *atomic just before the addition took place.
	 * Also acts as a memory barrier.
	 * Since 2.4
	 * Params:
	 * atomic = a pointer to an integer.
	 * val = the value to add to *atomic.
	 * Returns:the value of *atomic before the addition.
	 */
	public static int intExchangeAndAdd(int* atomic, int val);
	
	/**
	 * Compares oldval with the integer pointed to by atomic and
	 * if they are equal, atomically exchanges *atomic with newval.
	 * Also acts as a memory barrier.
	 * Since 2.4
	 * Params:
	 * atomic = a pointer to an integer.
	 * oldval = the assumed old value of *atomic.
	 * newval = the new value of *atomic.
	 * Returns:%TRUE, if *atomic was equal oldval. FALSE otherwise.
	 */
	public static int intCompareAndExchange(int* atomic, int oldval, int newval);
	
	/**
	 * Reads the value of the pointer pointed to by atomic. Also acts as
	 * a memory barrier.
	 * Since 2.4
	 * Params:
	 * atomic = a pointer to a gpointer.
	 * Returns:the value to add to *atomic.
	 */
	public static void* pointerGet(void** atomic);
	
	/**
	 * Sets the value of the pointer pointed to by atomic.
	 * Also acts as a memory barrier.
	 * Since 2.10
	 * Params:
	 * atomic = a pointer to a gpointer
	 * newval = the new value
	 */
	public static void pointerSet(void** atomic, void* newval);
	
	/**
	 * Compares oldval with the pointer pointed to by atomic and
	 * if they are equal, atomically exchanges *atomic with newval.
	 * Also acts as a memory barrier.
	 * Since 2.4
	 * Params:
	 * atomic = a pointer to a gpointer.
	 * oldval = the assumed old value of *atomic.
	 * newval = the new value of *atomic.
	 * Returns:%TRUE, if *atomic was equal oldval. FALSE otherwise.
	 */
	public static int pointerCompareAndExchange(void** atomic, void* oldval, void* newval);
	
	/**
	 * Atomically increments the integer pointed to by atomic by 1.
	 * Since 2.4
	 * Params:
	 * atomic = a pointer to an integer.
	 */
	public static void intInc(int* atomic);
	
	/**
	 * Atomically decrements the integer pointed to by atomic by 1.
	 * Since 2.4
	 * Params:
	 * atomic = a pointer to an integer.
	 * Returns:%TRUE, if the integer pointed to by atomic is 0 afterdecrementing it.
	 */
	public static int intDecAndTest(int* atomic);
}
