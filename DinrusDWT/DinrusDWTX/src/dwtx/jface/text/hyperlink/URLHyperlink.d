/*******************************************************************************
 * Copyright (c) 2000, 2008 IBM Corporation and others.
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
module dwtx.jface.text.hyperlink.URLHyperlink;

import dwtx.jface.text.hyperlink.IHyperlinkPresenterExtension; // packageimport
import dwtx.jface.text.hyperlink.MultipleHyperlinkPresenter; // packageimport
import dwtx.jface.text.hyperlink.HyperlinkManager; // packageimport
import dwtx.jface.text.hyperlink.IHyperlinkDetectorExtension2; // packageimport
import dwtx.jface.text.hyperlink.IHyperlinkDetector; // packageimport
import dwtx.jface.text.hyperlink.IHyperlinkPresenter; // packageimport
import dwtx.jface.text.hyperlink.URLHyperlinkDetector; // packageimport
import dwtx.jface.text.hyperlink.DefaultHyperlinkPresenter; // packageimport
import dwtx.jface.text.hyperlink.AbstractHyperlinkDetector; // packageimport
import dwtx.jface.text.hyperlink.IHyperlinkDetectorExtension; // packageimport
import dwtx.jface.text.hyperlink.HyperlinkMessages; // packageimport
import dwtx.jface.text.hyperlink.IHyperlink; // packageimport


import dwt.dwthelper.utils;
import dwtx.dwtxhelper.MessageFormat;

import dwt.program.Program;
import dwtx.core.runtime.Assert;
import dwtx.jface.text.IRegion;





/**
 * URL hyperlink.
 *
 * @since 3.1
 */
public class URLHyperlink : IHyperlink {

    private String fURLString;
    private IRegion fRegion;

    /**
     * Creates a new URL hyperlink.
     *
     * @param region
     * @param urlString
     */
    public this(IRegion region, String urlString) {
        Assert.isNotNull(urlString);
        Assert.isNotNull(cast(Object)region);

        fRegion= region;
        fURLString= urlString;
    }

    /*
     * @see dwtx.jdt.internal.ui.javaeditor.IHyperlink#getHyperlinkRegion()
     */
    public IRegion getHyperlinkRegion() {
        return fRegion;
    }

    /*
     * @see dwtx.jdt.internal.ui.javaeditor.IHyperlink#open()
     */
    public void open() {
        if (fURLString !is null) {
            Program.launch(fURLString);
            fURLString= null;
            return;
        }
    }

    /*
     * @see dwtx.jdt.internal.ui.javaeditor.IHyperlink#getTypeLabel()
     */
    public String getTypeLabel() {
        return null;
    }

    /*
     * @see dwtx.jdt.internal.ui.javaeditor.IHyperlink#getHyperlinkText()
     */
    public String getHyperlinkText() {
        return MessageFormat.format(HyperlinkMessages.getString("URLHyperlink.hyperlinkText"), stringcast(fURLString) ); //$NON-NLS-1$
    }

    /**
     * Returns the URL string of this hyperlink.
     *
     * @return the URL string
     * @since 3.2
     */
    public String getURLString() {
        return fURLString;
    }

}
