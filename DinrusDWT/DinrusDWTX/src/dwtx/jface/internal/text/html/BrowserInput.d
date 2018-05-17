/*******************************************************************************
 * Copyright (c) 2008 IBM Corporation and others.
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
module dwtx.jface.internal.text.html.BrowserInput;

import dwtx.jface.internal.text.html.HTML2TextReader; // packageimport
import dwtx.jface.internal.text.html.HTMLPrinter; // packageimport
import dwtx.jface.internal.text.html.BrowserInformationControl; // packageimport
import dwtx.jface.internal.text.html.SubstitutionTextReader; // packageimport
import dwtx.jface.internal.text.html.HTMLTextPresenter; // packageimport
import dwtx.jface.internal.text.html.SingleCharReader; // packageimport
import dwtx.jface.internal.text.html.BrowserInformationControlInput; // packageimport
import dwtx.jface.internal.text.html.HTMLMessages; // packageimport


import dwt.dwthelper.utils;


/**
 * A browser input contains an input element and
 * a previous and a next input, if available.
 * 
 * The browser input also provides a human readable
 * name of its input element.
 * 
 * @since 3.4
 */
public abstract class BrowserInput {

    private const BrowserInput fPrevious;
    private BrowserInput fNext;

    /**
     * Create a new Browser input.
     * 
     * @param previous the input previous to this or <code>null</code> if this is the first
     */
    public this(BrowserInput previous) {
        fPrevious= previous;
        if (previous !is null)
            previous.fNext= this;
    }

    /**
     * The previous input or <code>null</code> if this
     * is the first.
     * 
     * @return the previous input or <code>null</code>
     */
    public BrowserInput getPrevious() {
        return fPrevious;
    }

    /**
     * The next input or <code>null</code> if this
     * is the last.
     * 
     * @return the next input or <code>null</code>
     */
    public BrowserInput getNext() {
        return fNext;
    }

    /**
     * The element to use to set the browsers input.
     * 
     * @return the input element
     */
    public abstract Object getInputElement();

    /**
     * A human readable name for the input.
     * 
     * @return the input name
     */
    public abstract String getInputName();
}
