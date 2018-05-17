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
module dwtx.draw2d.FreeformLayeredPane;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;

import dwtx.draw2d.geometry.Rectangle;
import dwtx.draw2d.LayeredPane;
import dwtx.draw2d.FreeformFigure;
import dwtx.draw2d.FreeformHelper;
import dwtx.draw2d.IFigure;
import dwtx.draw2d.FreeformListener;

/**
 * A LayeredPane that contains {@link dwtx.draw2d.FreeformLayer FreeformLayers}.
 */
public class FreeformLayeredPane
    : LayeredPane
    , FreeformFigure
{
private FreeformHelper helper;

/**
 * Constructs a new FreeformLayeredPane.
 */
public this() {
    helper = new FreeformHelper(this);
    setLayoutManager(null);
}

/**
 * @see IFigure#add(IFigure, Object, int)
 */
public void add(IFigure child, Object constraint, int index) {
    super.add(child, constraint, index);
    helper.hookChild(child);
}

/**
 * @see FreeformFigure#addFreeformListener(FreeformListener)
 */
public void addFreeformListener(FreeformListener listener) {
    addListener(FreeformListener.classinfo, cast(Object)listener);
}

/**
 * @see FreeformFigure#fireExtentChanged()
 */
public void fireExtentChanged() {
    Iterator iter = getListeners(FreeformListener.classinfo);
    while (iter.hasNext())
        (cast(FreeformListener)iter.next())
            .notifyFreeformExtentChanged();
}

/**
 * Overrides to do nothing.
 * @see Figure#fireMoved()
 */
protected void fireMoved() { }

/**
 * Returns the FreeformHelper.
 * @return the FreeformHelper
 */
protected FreeformHelper getFreeformHelper() {
    return helper;
}

/**
 * @see FreeformFigure#getFreeformExtent()
 */
public Rectangle getFreeformExtent() {
    return helper.getFreeformExtent();
}

/**
 * @see Figure#primTranslate(int, int)
 */
protected void primTranslate(int dx, int dy) {
    bounds.x += dx;
    bounds.y += dy;
}

/**
 * @see IFigure#remove(IFigure)
 */
public void remove(IFigure child) {
    helper.unhookChild(child);
    super.remove(child);
}

/**
 * @see FreeformFigure#removeFreeformListener(FreeformListener)
 */
public void removeFreeformListener(FreeformListener listener) {
    removeListener(FreeformListener.classinfo, cast(Object)listener);
}

/**
 * @see FreeformFigure#setFreeformBounds(Rectangle)
 */
public void setFreeformBounds(Rectangle bounds) {
    helper.setFreeformBounds(bounds);
}

/**
 * Calls {@link Figure#fireMoved() super.fireMoved()}.
 */
protected void superFireMoved() {
    super.fireMoved();
}

}
