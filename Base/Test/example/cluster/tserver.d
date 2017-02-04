/*******************************************************************************

*******************************************************************************/

import io.Console;

import net.InternetAddress;

import net.cluster.tina.CmdParser,
       net.cluster.tina.TaskServer;

import Add;

/*******************************************************************************

*******************************************************************************/

void main (char[][] args)
{
        auto arg = new CmdParser ("task.server");

        if (args.length > 1)
            arg.parse (args[1..$]);

        if (arg.help)
            Cout ("usage: taskserver -port=number -log[=trace, info, warn, error, fatal, none]").newline;
        else
           {
           auto server = new TaskServer (new InternetAddress(arg.port), arg.log);
           server.enroll (new NetCall!(add));
           server.enroll (new Subtract);
           server.start;
           }
}
