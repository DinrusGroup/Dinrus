private import  core.Thread;

private import  util.log.Log,
                util.log.Config;

private import  net.cluster.NetworkAlert;

private import  net.cluster.tina.Cluster;

/*******************************************************************************

        How to send and recieve Alert messages using net.cluster

*******************************************************************************/

void main()
{
        // hook into the cluster
        auto cluster = (new Cluster).join;

        // hook into the Alert layer
        auto alert = new NetworkAlert (cluster, "my.kind.of.alert");

        // listen for the broadcast (on this channel)
        alert.createConsumer (delegate void (IEvent event)
                             {event.log.info ("Recieved alert on channel " ~ event.channel.name);}
                             );

        // say what's going on
        alert.log.info ("broadcasting alert");

        // and send everyone an empty alert (on this channel)
        alert.broadcast;

        // wait for it to arrive ...
        Thread.sleep(1);
}
