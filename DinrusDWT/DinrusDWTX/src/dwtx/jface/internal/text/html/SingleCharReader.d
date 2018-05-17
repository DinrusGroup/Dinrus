/*******************************************************************************
 * Copyright (c) 2000, 2006 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/
module dwtx.jface.internal.text.html.SingleCharReader;

import dwtx.jface.internal.text.html.HTML2TextReader; // packageimport
import dwtx.jface.internal.text.html.HTMLPrinter; // packageimport
import dwtx.jface.internal.text.html.BrowserInformationControl; // packageimport
import dwtx.jface.internal.text.html.SubstitutionTextReader; // packageimport
import dwtx.jface.internal.text.html.HTMLTextPresenter; // packageimport
import dwtx.jface.internal.text.html.BrowserInput; // packageimport
import dwtx.jface.internal.text.html.BrowserInformationControlInput; // packageimport
import dwtx.jface.internal.text.html.HTMLMessages; // packageimport


import dwt.dwthelper.utils;

/**
 * <p>
 * Moved into this package from <code>dwtx.jface.internal.text.revisions</code>.</p>
 */
public abstract class SingleCharReader : Reader {

    /**
     * @see Reader#read()
     */
    public abstract int read() ;

    /**
     * @see Reader#read(char[],int,int)
     */
    public int read(char cbuf[], int off, int len)  {
        int end= off + len;
        for (int i= off; i < end; i++) {
            int ch= read();
            if (ch is -1) {
                if (i is off)
                    return -1;
                return i - off;
            }
            cbuf[i]= cast(char)ch;
        }
        return len;
    }

    /**
     * @see Reader#ready()
     */
    public bool ready()  {
        return true;
    }

    /**
     * Returns the readable content as string.
     * @return the readable content as string
     * @exception IOException in case reading fails
     */
    public String getString()  {
        StringBuffer buf= new StringBuffer();
        int ch;
        while ((ch= read()) !is -1) {
            buf.append(cast(char)ch);
        }
        return buf.toString();
    }
}
