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
module dwtx.jface.internal.text.html.BrowserInformationControlInput;

import dwtx.jface.internal.text.html.HTML2TextReader; // packageimport
import dwtx.jface.internal.text.html.HTMLPrinter; // packageimport
import dwtx.jface.internal.text.html.BrowserInformationControl; // packageimport
import dwtx.jface.internal.text.html.SubstitutionTextReader; // packageimport
import dwtx.jface.internal.text.html.HTMLTextPresenter; // packageimport
import dwtx.jface.internal.text.html.BrowserInput; // packageimport
import dwtx.jface.internal.text.html.SingleCharReader; // packageimport
import dwtx.jface.internal.text.html.HTMLMessages; // packageimport


import dwt.dwthelper.utils;

import dwtx.jface.text.DefaultInformationControl;


/**
 * Provides input for a {@link BrowserInformationControl}.
 *
 * @since 3.4
 */
public abstract class BrowserInformationControlInput : BrowserInput {
    
    /**
     * Returns the leading image width.
     * 
     * @return the size of the leading image, by default <code>0</code> is returned
     * @since 3.4
     */
    public int getLeadingImageWidth() {
        return 0;
    }

    /**
     * Creates the next browser input with the given input as previous one.
     * 
     * @param previous the previous input or <code>null</code> if none
     */
    public this(BrowserInformationControlInput previous) {
        super(previous);
    }

    /**
     * @return the HTML contents
     */
    public abstract String getHtml();
    
    /**
     * Returns the HTML from {@link #getHtml()}.
     * This is a fallback mode for platforms where the {@link BrowserInformationControl}
     * is not available and this input is passed to a {@link DefaultInformationControl}.
     * 
     * @return {@link #getHtml()}
     */
    public override String toString() {
        return getHtml();
    }
}
