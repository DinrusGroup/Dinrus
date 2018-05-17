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
module dwtx.draw2d.ViewportLayout;

import dwt.dwthelper.utils;

import dwtx.draw2d.geometry.Dimension;
import dwtx.draw2d.geometry.Insets;
import dwtx.draw2d.geometry.Point;
import dwtx.draw2d.geometry.Rectangle;
import dwtx.draw2d.AbstractHintLayout;
import dwtx.draw2d.IFigure;
import dwtx.draw2d.Viewport;

/**
 * Layout for a viewport. A viewport is a flexible window
 * onto a figure.
 */
public class ViewportLayout
    : AbstractHintLayout
{

/**
 * Returns the minimum size required by the input viewport figure. Since viewport is
 * flexible, the minimum size required would be the just the size of the borders.
 * @see AbstractHintLayout#calculateMinimumSize(IFigure, int, int)
 */
protected Dimension calculateMinimumSize(IFigure figure, int wHint, int hHint) {
    Viewport viewport = cast(Viewport)figure;
    Dimension min = new Dimension();
    Insets insets = viewport.getInsets();
    return min.getExpanded(insets.getWidth(), insets.getHeight());
}

/**
 * Calculates and returns the preferred size of the figure based on the given hints. The
 * given wHint is ignored unless the viewport (parent) is tracking width. The same is true
 * for the height hint.
 * @param parent the Viewport whose preferred size is to be calculated
 * @param wHint the width hint
 * @param hHint the height hint
 * @return the Preferred size of the given viewport
 * @since   2.0
 */
protected Dimension calculatePreferredSize(IFigure parent, int wHint, int hHint) {
    Viewport viewport = cast(Viewport)parent;
    Insets insets = viewport.getInsets();
    IFigure contents = viewport.getContents();

    if (viewport.getContentsTracksWidth() && wHint > -1)
        wHint = Math.max(0, wHint - insets.getWidth());
    else
        wHint = -1;
    if (viewport.getContentsTracksHeight() && hHint > -1)
        hHint = Math.max(0, hHint - insets.getHeight());
    else
        hHint = -1;

    if (contents is null) {
        return new Dimension(insets.getWidth(), insets.getHeight());
    } else {
        Dimension minSize = contents.getMinimumSize(wHint, hHint);
        if (wHint > -1)
            wHint = Math.max(wHint, minSize.width);
        if (hHint > -1)
            hHint = Math.max(hHint, minSize.height);
        return contents
            .getPreferredSize(wHint, hHint)
            .getExpanded(insets.getWidth(), insets.getHeight());
    }

    //Layout currently does not union border's preferred size.
}

/**
 * @see dwtx.draw2d.AbstractHintLayout#isSensitiveHorizontally(IFigure)
 */
protected bool isSensitiveHorizontally(IFigure parent) {
    return (cast(Viewport)parent).getContentsTracksWidth();
}

/**
 * @see dwtx.draw2d.AbstractHintLayout#isSensitiveHorizontally(IFigure)
 */
protected bool isSensitiveVertically(IFigure parent) {
    return (cast(Viewport)parent).getContentsTracksHeight();
}

/**
 * @see dwtx.draw2d.LayoutManager#layout(IFigure)
 */
public void layout(IFigure figure) {
    Viewport viewport = cast(Viewport)figure;
    IFigure contents = viewport.getContents();

    if (contents is null) return;
    Point p = viewport.getClientArea().getLocation();

    p.translate(viewport.getViewLocation().getNegated());

    // Calculate the hints
    Rectangle hints = viewport.getClientArea();
    int wHint = viewport.getContentsTracksWidth() ? hints.width : -1;
    int hHint = viewport.getContentsTracksHeight() ? hints.height : -1;

    Dimension newSize = viewport.getClientArea().getSize();
    Dimension min = contents.getMinimumSize(wHint, hHint);
    Dimension pref = contents.getPreferredSize(wHint, hHint);

    if (viewport.getContentsTracksHeight())
        newSize.height = Math.max(newSize.height, min.height);
    else
        newSize.height = Math.max(newSize.height, pref.height);

    if (viewport.getContentsTracksWidth())
        newSize.width = Math.max(newSize.width, min.width);
    else
        newSize.width = Math.max(newSize.width, pref.width);

    contents.setBounds(new Rectangle(p, newSize));
}

}
