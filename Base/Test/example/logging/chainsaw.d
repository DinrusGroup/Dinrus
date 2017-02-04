import  core.Thread;

import  util.log.Log,
        util.log.AppendSocket,
        util.log.LayoutChainsaw;

import  net.InternetAddress;


/*******************************************************************************

        Hooks up to Chainsaw for remote log capture. Chainsaw should be 
        configured to listen with an XMLSocketReciever

*******************************************************************************/

void main()
{
        // get a logger to represent this module
        auto logger = Log.lookup ("example.chainsaw");

        // hook up an appender for XML output
        logger.add (new AppendSocket (new InternetAddress("127.0.0.1", 4448), new LayoutChainsaw));

        while (true)
              {
              logger.info ("Hello Chainsaw!");      
              Thread.sleep (1.0);
              }
}
