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
module dwtx.draw2d.FreeformViewport;

import dwt.dwthelper.utils;

import dwtx.draw2d.geometry.Dimension;
import dwtx.draw2d.geometry.Rectangle;
import dwtx.draw2d.Viewport;
import dwtx.draw2d.ViewportLayout;
import dwtx.draw2d.IFigure;
import dwtx.draw2d.FreeformFigure;

/**
 * A viewport for {@link dwtx.draw2d.FreeformFigure FreeformFigures}.
 * FreeformFigures can only reside in this type of viewport.
 */
public class FreeformViewport
    : Viewport
{

class FreeformViewportLayout
    : ViewportLayout
{
    protected Dimension calculatePreferredSize(IFigure parent, int wHint, int hHint) {
        getContents().validate();
        wHint = Math.max(0, wHint);
        hHint = Math.max(0, hHint);
        return (cast(FreeformFigure)getContents())
            .getFreeformExtent()
            .getExpanded(getInsets())
            .union_(0, 0)
            .union_(wHint - 1, hHint - 1)
            .getSize();
    }

    protected bool isSensitiveHorizontally(IFigure parent) {
        return true;
    }

    protected bool isSensitiveVertically(IFigure parent) {
        return true;
    }


    public void layout(IFigure figure) {
        //Do nothing, contents updates itself.
    }
}

/**
 * Constructs a new FreeformViewport.  This viewport must use graphics translation to
 * scroll the FreeformFigures inside of it.
 */
public this() {
    super(true); //Must use graphics translate to scroll freeforms.
    setLayoutManager(new FreeformViewportLayout());
}

/**
 * Readjusts the scrollbars.  In doing so, it gets the freeform extent of the contents and
 * unions this rectangle with this viewport's client area, then sets the contents freeform
 * bounds to be this unioned rectangle.  Then proceeds to set the scrollbar values based
 * on this new information.
 * @see Viewport#readjustScrollBars()
 */
protected void readjustScrollBars() {
    if (getContents() is null)
        return;
    if (!( null !is cast(FreeformFigure)getContents() ))
        return;
    FreeformFigure ff = cast(FreeformFigure)getContents();
    Rectangle clientArea = getClientArea();
    Rectangle bounds = ff.getFreeformExtent().getCopy();
    bounds.union_(0, 0, clientArea.width, clientArea.height);
    ff.setFreeformBounds(bounds);

    getVerticalRangeModel().setAll(bounds.y, clientArea.height, bounds.bottom());
    getHorizontalRangeModel().setAll(bounds.x, clientArea.width, bounds.right());
}

/**
 * Returns <code>true</code>.
 * @see Figure#useLocalCoordinates()
 */
protected bool useLocalCoordinates() {
    return true;
}

}
