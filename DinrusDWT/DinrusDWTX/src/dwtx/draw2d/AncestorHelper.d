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
module dwtx.draw2d.AncestorHelper;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Bean;

import dwtx.draw2d.IFigure;
import dwtx.draw2d.FigureListener;
import dwtx.draw2d.AncestorListener;

/**
 * A helper object which tracks the parent chain hierarchy.
 * @since 2.1
 */
class AncestorHelper
    : PropertyChangeListener, FigureListener
{

/**
 * The base figure whose ancestor chain is being observed.
 */
protected final IFigure base;
/**
 * The array of ancestor listeners.
 */
protected AncestorListener[] listeners;

/**
 * Constructs a new helper on the given base figure and starts listening to figure and
 * property changes on the base figure's parent chain.  When no longer needed, the helper
 * should be disposed.
 * @since 2.1
 * @param baseFigure
 */
public this(IFigure baseFigure) {
    this.base = baseFigure;
    addAncestors(baseFigure);
}

/**
 * Appends a new listener to the list of listeners.
 * @param listener the listener
 */
public void addAncestorListener(AncestorListener listener) {
    if (listeners is null) {
        listeners = new AncestorListener[1];
        listeners[0] = listener;
    } else {
        int oldSize = listeners.length;
        AncestorListener newListeners[] = new AncestorListener[oldSize + 1];
        SimpleType!(AncestorListener).arraycopy(listeners, 0, newListeners, 0, oldSize);
        newListeners[oldSize] = listener;
        listeners = newListeners;
    }
}

/**
 * Hooks up internal listeners used for maintaining the proper figure listeners.
 * @param rootFigure the root figure
 */
protected void addAncestors(IFigure rootFigure) {
    for (IFigure ancestor = rootFigure;
            ancestor !is null;
            ancestor = ancestor.getParent()) {
        ancestor.addFigureListener(this);
        ancestor.addPropertyChangeListener("parent", this); //$NON-NLS-1$
    }
}

/**
 * Removes all internal listeners.
 */
public void dispose() {
    removeAncestors(base);
    listeners = null;
}

/**
 * @see dwtx.draw2d.FigureListener#figureMoved(dwtx.draw2d.IFigure)
 */
public void figureMoved(IFigure ancestor) {
    fireAncestorMoved(ancestor);
}

/**
 * Fires notification to the listener list
 * @param ancestor the figure which moved
 */
protected void fireAncestorMoved(IFigure ancestor) {
    if (listeners is null)
        return;
    for (int i = 0; i < listeners.length; i++)
        listeners[i].ancestorMoved(ancestor);
}

/**
 * Fires notification to the listener list
 * @param ancestor the figure which moved
 */
protected void fireAncestorAdded(IFigure ancestor) {
    if (listeners is null)
        return;
    for (int i = 0; i < listeners.length; i++)
        listeners[i].ancestorAdded(ancestor);
}

/**
 * Fires notification to the listener list
 * @param ancestor the figure which moved
 */
protected void fireAncestorRemoved(IFigure ancestor) {
    if (listeners is null)
        return;
    for (int i = 0; i < listeners.length; i++)
        listeners[i].ancestorRemoved(ancestor);
}

/**
 * Returns the total number of listeners.
 * @return the number of listeners
 */
public bool isEmpty() {
    return listeners is null;
}

/**
 * @see java.beans.PropertyChangeListener#propertyChange(java.beans.PropertyChangeEvent)
 */
public void propertyChange(PropertyChangeEvent event) {
    if (event.getPropertyName().equals("parent")) { //$NON-NLS-1$
        IFigure oldParent = cast(IFigure)event.getOldValue();
        IFigure newParent = cast(IFigure)event.getNewValue();
        if (oldParent !is null) {
            removeAncestors(oldParent);
            fireAncestorRemoved(oldParent);
        }
        if (newParent !is null) {
            addAncestors(newParent);
            fireAncestorAdded(newParent);
        }
    }
}

/**
 * Removes the first occurence of the given listener
 * @param listener the listener to remove
 */
public void removeAncestorListener(AncestorListener listener) {
    if (listeners is null)
        return;
    for (int index = 0; index < listeners.length; index++)
        if (listeners[index] is listener) {
            int newSize = listeners.length - 1;
            AncestorListener newListeners[] = null;
            if (newSize !is 0) {
                newListeners = new AncestorListener[newSize];
                SimpleType!(AncestorListener).arraycopy(listeners, 0, newListeners, 0, index);
                SimpleType!(AncestorListener).arraycopy(listeners, index + 1, newListeners, index, newSize - index);
            }
            listeners = newListeners;
            return;
        }
}

/**
 * Unhooks listeners starting at the given figure
 * @param rootFigure
 */
protected void removeAncestors(IFigure rootFigure) {
    for (IFigure ancestor = rootFigure;
                ancestor !is null;
                ancestor = ancestor.getParent()) {
        ancestor.removeFigureListener(this);
        ancestor.removePropertyChangeListener("parent", this); //$NON-NLS-1$
    }
}

}
