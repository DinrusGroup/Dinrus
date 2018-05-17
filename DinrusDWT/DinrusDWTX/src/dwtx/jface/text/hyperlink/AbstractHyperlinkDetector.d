/*******************************************************************************
 * Copyright (c) 2007 IBM Corporation and others.
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
module dwtx.jface.text.hyperlink.AbstractHyperlinkDetector;

import dwtx.jface.text.hyperlink.IHyperlinkPresenterExtension; // packageimport
import dwtx.jface.text.hyperlink.MultipleHyperlinkPresenter; // packageimport
import dwtx.jface.text.hyperlink.HyperlinkManager; // packageimport
import dwtx.jface.text.hyperlink.URLHyperlink; // packageimport
import dwtx.jface.text.hyperlink.IHyperlinkDetectorExtension2; // packageimport
import dwtx.jface.text.hyperlink.IHyperlinkDetector; // packageimport
import dwtx.jface.text.hyperlink.IHyperlinkPresenter; // packageimport
import dwtx.jface.text.hyperlink.URLHyperlinkDetector; // packageimport
import dwtx.jface.text.hyperlink.DefaultHyperlinkPresenter; // packageimport
import dwtx.jface.text.hyperlink.IHyperlinkDetectorExtension; // packageimport
import dwtx.jface.text.hyperlink.HyperlinkMessages; // packageimport
import dwtx.jface.text.hyperlink.IHyperlink; // packageimport


import dwt.dwthelper.utils;

import dwtx.core.runtime.Assert;
import dwtx.core.runtime.IAdaptable;


/**
 * A hyperlink detector that can provide adapters through
 * a context that can be set by the creator of this hyperlink
 * detector.
 * <p>
 * Clients may subclass.
 * </p>
 * 
 * @since 3.3
 */
public abstract class AbstractHyperlinkDetector : IHyperlinkDetector, IHyperlinkDetectorExtension {

    /**
     * The context of this hyperlink detector.
     */
    private IAdaptable fContext;

    /**
     * Sets this hyperlink detector's context which
     * is responsible to provide the adapters.
     * 
     * @param context the context for this hyperlink detector
     * @throws IllegalArgumentException if the context is <code>null</code>
     * @throws IllegalStateException if this method is called more than once
     */
    public final void setContext(IAdaptable context)  {
        Assert.isLegal(context !is null);
        if (fContext !is null)
            throw new IllegalStateException();
        fContext= context;
    }

    /*
     * @see dwtx.jface.text.hyperlink.IHyperlinkDetectorExtension#dispose()
     */
    public void dispose() {
        fContext= null;
    }

    /**
     * Returns an object which is an instance of the given class
     * and provides additional context for this hyperlink detector.
     *
     * @param adapterClass the adapter class to look up
     * @return an instance that can be cast to the given class, 
     *          or <code>null</code> if this object does not
     *          have an adapter for the given class
     */
    protected final Object getAdapter(ClassInfo adapterClass) {
        Assert.isLegal(adapterClass !is null);
        if (fContext !is null)
            return fContext.getAdapter(adapterClass);
        return null;
    }

}
