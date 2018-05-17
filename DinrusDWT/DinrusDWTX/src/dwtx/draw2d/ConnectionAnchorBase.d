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
module dwtx.draw2d.ConnectionAnchorBase;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;

import dwtx.draw2d.ConnectionAnchor;
import dwtx.draw2d.AnchorListener;

/**
 * Provides support for a ConnectionAnchor. A ConnectionAnchor is one of the end points
 * of a {@link Connection}. It holds listeners and notifies them if the anchor is moved.
 */
public abstract class ConnectionAnchorBase
    : ConnectionAnchor
{

/**
 * The list of listeners
 */
protected List listeners;

this(){
    listeners = new ArrayList(1);
}

/**
 * @see dwtx.draw2d.ConnectionAnchor#addAnchorListener(AnchorListener)
 */
public void addAnchorListener(AnchorListener listener) {
    listeners.add(cast(Object)listener);
}

/**
 * @see dwtx.draw2d.ConnectionAnchor#removeAnchorListener(AnchorListener)
 */
public void removeAnchorListener(AnchorListener listener) {
    listeners.remove(cast(Object)listener);
}

/**
 * Notifies all the listeners in the list of a change in position of this anchor. This is
 * called from one of the implementing anchors when its location is changed.
 *
 * @since 2.0
 */
protected void fireAnchorMoved() {
    Iterator iter = listeners.iterator();
    while (iter.hasNext())
        (cast(AnchorListener)iter.next()).anchorMoved(this);
}

}
