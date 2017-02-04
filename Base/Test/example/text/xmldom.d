/*******************************************************************************

        Copyright: Copyright (C) 2007-2008 Kris Bell. All rights reserved.

        License:   BSD Style
        Authors:   Kris

*******************************************************************************/

import io.device.File;
import io.Stdout;
import time.StopWatch;
import text.xml.Document;
import text.xml.DocPrinter;

/*******************************************************************************

*******************************************************************************/

void bench (int iterations) 
{       
        StopWatch elapsed;

        auto doc = new Document!(char);
        auto content = cast (char[]) File.get ("hamlet.xml");

        elapsed.start;
        for (auto i=0; ++i < iterations;)
             doc.parse (content);

        foreach (node; doc.query.descendant("xyz"))
                 node.detach;

        auto print = new DocPrinter!(char);
        Stdout (print (doc)).newline;
//        Stdout.formatln ("{} MB/s", (content.length * iterations) / (elapsed.stop * (1024 * 1024)));
}
        
/*******************************************************************************

*******************************************************************************/

void main()
{
        for (int i=1; i--;)
             bench (2000);
}

