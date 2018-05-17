/*******************************************************************************
 * Copyright (c) 2006, 2007 IBM Corporation and others.
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

module dwtx.jface.viewers.BaseLabelProvider;

import dwtx.jface.viewers.IBaseLabelProvider;
import dwtx.jface.viewers.ILabelProviderListener;
import dwtx.jface.viewers.LabelProviderChangedEvent;

import dwtx.core.commands.common.EventManager;
import dwtx.jface.util.SafeRunnable;

import dwt.dwthelper.utils;

/**
 * BaseLabelProvider is a default concrete implementation of
 * {@link IBaseLabelProvider}
 *
 * @since 3.3
 *
 */
public class BaseLabelProvider : EventManager, IBaseLabelProvider {

    /* (non-Javadoc)
     * Method declared on IBaseLabelProvider.
     */
    public void addListener(ILabelProviderListener listener) {
        addListenerObject(cast(Object)listener);
    }

    /**
     * The <code>BaseLabelProvider</code> implementation of this
     * <code>IBaseLabelProvider</code> method clears its internal listener list.
     * Subclasses may extend but should call the super implementation.
     */
    public void dispose() {
        clearListeners();
    }

    /**
     * The <code>BaseLabelProvider</code> implementation of this
     * <code>IBaseLabelProvider</code> method returns <code>true</code>. Subclasses may
     * override.
     */
    public bool isLabelProperty(Object element, String property) {
        return true;
    }


    /* (non-Javadoc)
     * @see dwtx.jface.viewers.IBaseLabelProvider#removeListener(dwtx.jface.viewers.ILabelProviderListener)
     */
    public void removeListener(ILabelProviderListener listener) {
        removeListenerObject(cast(Object)listener);
    }

    /**
     * Fires a label provider changed event to all registered listeners Only
     * listeners registered at the time this method is called are notified.
     *
     * @param event
     *            a label provider changed event
     *
     * @see ILabelProviderListener#labelProviderChanged
     */
    protected void fireLabelProviderChanged(LabelProviderChangedEvent event) {
        Object[] listeners = getListeners();
        for (int i = 0; i < listeners.length; ++i) {
            SafeRunnable.run(new class(event,cast(ILabelProviderListener) listeners[i]) SafeRunnable {
                LabelProviderChangedEvent event_;
                ILabelProviderListener l;
                this(LabelProviderChangedEvent a,ILabelProviderListener b){
                    event_=a;
                    l = b;
                }
                public void run() {
                    l.labelProviderChanged(event_);
                }
            });

        }
    }
}
