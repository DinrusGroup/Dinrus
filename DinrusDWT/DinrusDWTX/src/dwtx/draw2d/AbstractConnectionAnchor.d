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
module dwtx.draw2d.AbstractConnectionAnchor;

import dwt.dwthelper.utils;

import dwtx.draw2d.geometry.Point;
import dwtx.draw2d.ConnectionAnchorBase;
import dwtx.draw2d.AncestorListener;
import dwtx.draw2d.IFigure;
import dwtx.draw2d.AnchorListener;

/**
 * Provides support for anchors which depend on a figure for thier location.
 * @author hudsonr
 */
public abstract class AbstractConnectionAnchor
    : ConnectionAnchorBase
    , AncestorListener
{

private IFigure owner;

/**
 * Constructs an AbstractConnectionAnchor with no owner.
 *
 * @since 2.0
 */
public this() { }

/**
 * Constructs an AbstractConnectionAnchor with the owner supplied as input.
 *
 * @since 2.0
 * @param owner  Owner of this anchor
 */
public this(IFigure owner) {
    setOwner(owner);
}

/**
 * Adds the given listener to the listeners to be notified of anchor location changes.
 *
 * @since 2.0
 * @param listener   Listener to be added
 * @see  #removeAnchorListener(AnchorListener)
 */
public void addAnchorListener(AnchorListener listener) {
    if (listener is null)
        return;
    if (listeners.size() is 0)
        getOwner().addAncestorListener(this);
    super.addAnchorListener(listener);
}

/**
 * Notifies all the listeners of this anchor's location change.
 *
 * @since 2.0
 * @param figure  Anchor-owning Figure which has moved
 * @see dwtx.draw2d.AncestorListener#ancestorMoved(IFigure)
 */
public void ancestorMoved(IFigure figure) {
    fireAnchorMoved();
}

/**
 * @see dwtx.draw2d.AncestorListener#ancestorAdded(IFigure)
 */
public void ancestorAdded(IFigure ancestor) { }

/**
 * @see dwtx.draw2d.AncestorListener#ancestorRemoved(IFigure)
 */
public void ancestorRemoved(IFigure ancestor) { }

/**
 * Returns the owner Figure on which this anchor's location is dependent.
 *
 * @since 2.0
 * @return  Owner of this anchor
 * @see #setOwner(IFigure)
 */
public IFigure getOwner() {
    return owner;
}

/**
 * Returns the point which is used as the reference by this AbstractConnectionAnchor. It
 * is generally dependent on the Figure which is the owner of this
 * AbstractConnectionAnchor.
 *
 * @since 2.0
 * @return  The reference point of this anchor
 * @see dwtx.draw2d.ConnectionAnchor#getReferencePoint()
 */
public Point getReferencePoint() {
    if (getOwner() is null)
        return null;
    else {
        Point ref_ = getOwner().getBounds().getCenter();
        getOwner().translateToAbsolute(ref_);
        return ref_;
    }
}

/**
 * Removes the given listener from this anchor. If all the listeners are removed, then
 * this anchor removes itself from its owner.
 *
 * @since 2.0
 * @param listener  Listener to be removed from this anchors listeners list
 * @see #addAnchorListener(AnchorListener)
 */
public void removeAnchorListener(AnchorListener listener) {
    super.removeAnchorListener(listener);
    if (listeners.size() is 0)
        getOwner().removeAncestorListener(this);
}

/**
 * Sets the owner of this anchor, on whom this anchors location is dependent.
 *
 * @since 2.0
 * @param owner  Owner of this anchor
 */
public void setOwner(IFigure owner) {
    this.owner = owner;
}

}
