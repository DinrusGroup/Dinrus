/*******************************************************************************
 * Copyright (c) 2000, 2005 IBM Corporation and others.
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
module dwtx.jface.text.hyperlink.IHyperlink;

import dwtx.jface.text.hyperlink.IHyperlinkPresenterExtension; // packageimport
import dwtx.jface.text.hyperlink.MultipleHyperlinkPresenter; // packageimport
import dwtx.jface.text.hyperlink.HyperlinkManager; // packageimport
import dwtx.jface.text.hyperlink.URLHyperlink; // packageimport
import dwtx.jface.text.hyperlink.IHyperlinkDetectorExtension2; // packageimport
import dwtx.jface.text.hyperlink.IHyperlinkDetector; // packageimport
import dwtx.jface.text.hyperlink.IHyperlinkPresenter; // packageimport
import dwtx.jface.text.hyperlink.URLHyperlinkDetector; // packageimport
import dwtx.jface.text.hyperlink.DefaultHyperlinkPresenter; // packageimport
import dwtx.jface.text.hyperlink.AbstractHyperlinkDetector; // packageimport
import dwtx.jface.text.hyperlink.IHyperlinkDetectorExtension; // packageimport
import dwtx.jface.text.hyperlink.HyperlinkMessages; // packageimport


import dwt.dwthelper.utils;

import dwtx.jface.text.IRegion;


/**
 * Represents a hyperlink.
 * <p>
 * Clients may implement this interface.
 * </p>
 *
 * @since 3.1
 */
public interface IHyperlink {

    /**
     * The region covered by this type of hyperlink.
     *
     * @return the hyperlink region
     */
    IRegion getHyperlinkRegion();

    /**
     * Optional label for this type of hyperlink.
     * <p>
     * This type label can be used by {@link IHyperlinkPresenter}s
     * which show several hyperlinks at once.
     * </p>
     *
     * @return the type label or <code>null</code> if none
     */
    String getTypeLabel();

    /**
     * Optional text for this hyperlink.
     * <p>
     * This can be used in situations where there are
     * several targets for the same hyperlink location.
     * </p>
     *
     * @return the text or <code>null</code> if none
     */
    String getHyperlinkText();

    /**
     * Opens the given hyperlink.
     */
    void open();
}
