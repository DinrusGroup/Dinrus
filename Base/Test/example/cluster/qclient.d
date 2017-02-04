/*******************************************************************************


*******************************************************************************/

import io.Stdout;

import util.log.Log,
       util.log.Config;

import time.StopWatch;

import net.cluster.NetworkQueue;

import net.cluster.tina.Cluster;

/*******************************************************************************


*******************************************************************************/

void main (char[][] args)
{
        StopWatch w;

        auto cluster = (new Cluster).join;
        auto queue   = new NetworkQueue (cluster, "my.queue.channel");

        while (true)
              {
              w.start;
              for (int i=10000; i--;)
                   queue.put (queue.EmptyMessage);

              Stdout.formatln ("{} put/s", 10000/w.stop);

              uint count;
              w.start;
              while (queue.get !is null)
                     ++count;
        
              Stdout.formatln ("{} get/s", count/w.stop);
              }
}

