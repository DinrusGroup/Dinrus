import util.log.Log;
import util.log.AppendFile;
import util.log.AppendFiles;
import util.log.AppendConsole;
import util.log.LayoutChainsaw;

/*******************************************************************************

        Shows how to setup multiple appenders on logging tree

*******************************************************************************/

void main ()
{
        // set default logging level at the root
        auto log = Log.root;
        log.level = Level.Trace;

        // 10 logs, all with 10 mbs each
        log.add (new AppendFiles ("rolling.log", 9, 1024*1024*10));

        // a single file appender, with an XML layout
        log.add (new AppendFile ("single.log", new LayoutChainsaw));

        // console appender
        log.add (new AppendConsole);

        // log to all
        log.trace ("three-way logging");
}

