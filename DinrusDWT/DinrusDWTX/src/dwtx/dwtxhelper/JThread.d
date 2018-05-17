module dwtx.dwtxhelper.JThread;

import tango.core.Thread;
import dwt.dwthelper.utils;
import tango.util.log.Trace;

class JThread {

    private Thread thread;
    private Runnable runnable;

    private alias ThreadLocal!(JThread) TTLS;
    private static TTLS tls;

    public static const int MAX_PRIORITY  = 10;
    public static const int MIN_PRIORITY  =  1;
    public static const int NORM_PRIORITY =  5;

    private static TTLS getTls(){
        if( tls is null ){
            synchronized( JThread.classinfo ){
                if( tls is null ){
                    tls = new TTLS();
                }
            }
        }
        return tls;
    }

    public this(){
        thread = new Thread(&internalRun);
    }
    public this( void delegate() dg ){
        thread = new Thread(&internalRun);
        runnable = dgRunnable( dg );
    }
    public this(Runnable runnable){
        thread = new Thread(&internalRun);
        this.runnable = runnable;
    }
    public this(Runnable runnable, String name){
        thread = new Thread(&internalRun);
        this.runnable = runnable;
        thread.name = name;
    }
    public this(String name){
        thread = new Thread(&internalRun);
        thread.name = name;
    }

    public void start(){
        thread.start();
    }

    public static JThread currentThread(){
        auto res = getTls().val();
        if( res is null ){
            // no synchronized needed
            res = new JThread();
            res.thread = Thread.getThis();
            getTls().val( res );
        }
        assert( res );
        return res;
    }
    public int getPriority() {
        return (thread.priority-Thread.PRIORITY_MIN) * (MAX_PRIORITY-MIN_PRIORITY) / (Thread.PRIORITY_MAX-Thread.PRIORITY_MIN) + MIN_PRIORITY;
    }
    public void setPriority( int newPriority ) {
//         assert( MIN_PRIORITY < MAX_PRIORITY );
//         assert( Thread.PRIORITY_MIN < Thread.PRIORITY_MAX );
        auto scaledPrio = (newPriority-MIN_PRIORITY) * (Thread.PRIORITY_MAX-Thread.PRIORITY_MIN) / (MAX_PRIORITY-MIN_PRIORITY) +Thread.PRIORITY_MIN;
        Trace.formatln( "JThread.setPriority: scale ({} {} {}) -> ({} {} {})", MIN_PRIORITY, newPriority, MAX_PRIORITY, Thread.PRIORITY_MIN, scaledPrio, Thread.PRIORITY_MAX);
//         thread.priority( scaledPrio );
    }

    private void internalRun(){
        getTls().val( this );
        if( runnable !is null ){
            runnable.run();
        }
        else {
            run();
        }
    }

    public bool isAlive(){
        return thread.isRunning();
    }

    public bool isDaemon() {
        return thread.isDaemon();
    }

    public void join(){
        thread.join();
    }

    public void setDaemon(bool on) {
        thread.isDaemon(on);
    }

    public void setName(String name){
        thread.name = name;
    }
    public String getName(){
        return thread.name;
    }

    void interrupt() {
        implMissing(__FILE__,__LINE__);
    }

    static bool interrupted() {
        implMissing(__FILE__,__LINE__);
        return false;
    }

    public void run(){
        // default impl, do nothing
    }
    public static void sleep( int time ){
        Thread.sleep(time/1000.0);
    }
    public Thread nativeThread(){
        assert(thread);
        return thread;
    }
    public override char[] toString(){
        return "JThread "~thread.name;
    }
    public static void yield(){
        Thread.yield();
    }
}

