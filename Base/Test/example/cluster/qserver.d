/*******************************************************************************

*******************************************************************************/

import io.Console;

import net.InternetAddress;

import net.cluster.tina.CmdParser,
       net.cluster.tina.QueueServer;

/*******************************************************************************

*******************************************************************************/

void main (char[][] args)
{
        auto arg = new CmdParser ("queue.server");

        if (args.length > 1)
            arg.parse (args[1..$]);
                
        if (arg.help)
            Cout ("usage: queueserver -port=number -log[=trace, info, warn, error, fatal, none]").newline;
        else
           (new QueueServer(new InternetAddress(arg.port), arg.log)).start;
}
