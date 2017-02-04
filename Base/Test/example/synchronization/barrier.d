/*******************************************************************************
  copyright:   Copyright (c) 2006 Juan Jose Comellas. All rights reserved
  license:     BSD style: $(LICENSE)
  author:      Juan Jose Comellas <juanjo@comellas.com.ar>
               Converted to use core.sync by Sean Kelly <sean@f4.ca>
*******************************************************************************/

private import core.sync.Barrier;
private import core.sync.Mutex;
private import core.Exception;
private import core.Thread;
private import io.Stdout;
private import text.convert.Integer;
debug (barrier)
{
    private import util.log.Log;
    private import util.log.ConsoleAppender;
    private import util.log.DateLayout;
}


/**
 * Example program for the core.sync.Barrier module.
 */
void main(char[][] args)
{
    const uint MaxThreadCount   = 100;
    const uint LoopsPerThread   = 10000;

    debug (barrier)
    {
        Logger log = Log.getLogger("barrier");

        log.addAppender(new ConsoleAppender(new DateLayout()));

        log.info("Barrier test");
    }

    Barrier barrier = new Barrier(MaxThreadCount);
    Mutex   mutex = new Mutex();
    uint    count = 0;
    uint    correctCount = 0;

    void barrierTestThread()
    {
        debug (barrier)
        {
            Logger log = Log.getLogger("barrier." ~ Thread.getThis().name());

            log.trace("Starting thread");
        }

        try
        {
            for (uint i; i < LoopsPerThread; ++i)
            {
                // 'count' is a resource shared by multiple threads, so we must
                // acquire the mutex before modifying it.
                synchronized (mutex)
                {
                    // debug (barrier)
                    //     log.trace("Acquired mutex");
                    count++;
                    // debug (barrier)
                    //     log.trace("Releasing mutex");
                }
            }

            // We wait for all the threads to finish counting.
            debug (barrier)
                log.trace("Waiting on barrier");
            barrier.wait();
            debug (barrier)
                log.trace("Barrier was opened");

            // We make sure that all the threads exited the barrier after
            // *all* of them had finished counting.
            synchronized (mutex)
            {
                // debug (barrier)
                //     log.trace("Acquired mutex");
                if (count == MaxThreadCount * LoopsPerThread)
                {
                    ++correctCount;
                }
                // debug (barrier)
                //     log.trace("Releasing mutex");
            }
        }
        catch (SyncException e)
        {
            Stderr.formatln("Sync exception caught in Barrier test thread {0}:\n{1}\n",
                            Thread.getThis().name, e.toString());
        }
        catch (Exception e)
        {
            Stderr.formatln("Unexpected exception caught in Barrier test thread {0}:\n{1}\n",
                            Thread.getThis().name, e.toString());
        }
    }

    ThreadGroup group = new ThreadGroup();
    Thread      thread;
    char[10]    tmp;

    for (uint i = 0; i < MaxThreadCount; ++i)
    {
        thread = new Thread(&barrierTestThread);
        thread.name = "thread-" ~ format(tmp, i);

        group.add(thread);
        debug (barrier)
            log.trace("Created thread " ~ thread.name);
        thread.start();
    }

    debug (barrier)
        log.trace("Waiting for threads to finish");
    group.joinAll();

    if (count == MaxThreadCount * LoopsPerThread)
    {
        debug (barrier)
            log.info("The Barrier test was successful");
    }
    else
    {
        debug (barrier)
        {
            log.error("The Barrier is not working properly: the counter has an incorrect value");
            assert(false);
        }
        else
        {
            assert(false, "The Barrier is not working properly: the counter has an incorrect value");
        }
    }
}
