module dwtx.dwtxhelper.TimerTask;

import tango.time.Time;
import dwt.dwthelper.utils;
import dwt.dwthelper.Runnable;
import dwtx.dwtxhelper.Timer;

class TimerTask : Runnable {

    package long scheduled;
    package long lastExecutionTime;
    package long period;
    package bool fixed;

    this(){
        this.scheduled = 0;
        this.lastExecutionTime = -1;
    }

    bool cancel(){
        bool prevented_execution = (this.scheduled >= 0);
        this.scheduled = -1;
        return prevented_execution;
    }

    abstract void run();

    long scheduledExcecutionTime(){
        return lastExecutionTime;
    }
}


