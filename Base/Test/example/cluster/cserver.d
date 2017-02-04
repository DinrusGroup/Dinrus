/*******************************************************************************

*******************************************************************************/

import io.Console;

import net.InternetAddress;

import net.cluster.tina.CmdParser,
       net.cluster.tina.CacheServer;

/*******************************************************************************

*******************************************************************************/

void main (char[][] args)
{
        auto arg = new CmdParser ("cache.server");

        // default number of cache entries
        arg.size = 8192;

        if (args.length > 1)
            arg.parse (args[1..$]);
                        
        if (arg.help)
            Cout ("usage: cacheserver -port=number -size=cachesize -log[=trace, info, warn, error, fatal, none]").newline;
        else
           (new CacheServer(new InternetAddress(arg.port), arg.log, arg.size)).start;
}
