/*******************************************************************************


*******************************************************************************/

import io.Stdout;

import util.log.Log,
       util.log.Config;

import time.StopWatch;

import net.cluster.NetworkCache;

import net.cluster.tina.Cluster;

import Integer = text.convert.Integer;

/*******************************************************************************


*******************************************************************************/

void main (char[][] args)
{
        StopWatch w;
        
        if (args.length > 1)
           {
           auto cluster = (new Cluster).join (args[1..$]);
           auto cache   = new NetworkCache (cluster, "my.cache.channel");

           char[64] tmp;
           while (true)
                 {
                 w.start;
                 for (int i=10000; i--;)
                     {
                     auto key = Integer.format (tmp, i);
                     cache.put (key, cache.EmptyMessage);
                     }

                 Stdout.formatln ("{} put/s", 10000/w.stop);

                 w.start;
                 for (int i=10000; i--;)
                     {
                     auto key = Integer.format (tmp, i);
                     cache.get (key);
                     }
        
                 Stdout.formatln ("{} get/s", 10000/w.stop);
                 }
           }
        else
           Stdout.formatln ("usage: cache cachehost:port ...");
}

