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
module dwtx.draw2d.StackLayout;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;

import dwtx.draw2d.geometry.Dimension;
import dwtx.draw2d.geometry.Rectangle;
import dwtx.draw2d.AbstractHintLayout;
import dwtx.draw2d.IFigure;

/**
 * Figures using the StackLayout as their layout manager have their children placed on top
 * of one another. Order of placement is determined by the order in which the children
 * were added, first child added placed on the bottom.
 */
public class StackLayout
    : AbstractHintLayout
{

/**
 * Returns the minimum size required by the input container. This is the size of the
 * largest child of the container, as all other children fit into this size.
 *
 * @see AbstractHintLayout#calculateMinimumSize(IFigure, int, int)
 */
protected Dimension calculateMinimumSize(IFigure figure, int wHint, int hHint) {
    if (wHint > -1)
        wHint = Math.max(0, wHint - figure.getInsets().getWidth());
    if (hHint > -1)
        hHint = Math.max(0, hHint - figure.getInsets().getHeight());
    Dimension d = new Dimension();
    List children = figure.getChildren();
    IFigure child;
    for (int i = 0; i < children.size(); i++) {
        child = cast(IFigure)children.get(i);
        if (!isObservingVisibility() || child.isVisible())
            d.union_(child.getMinimumSize(wHint, hHint));
    }

    d.expand(figure.getInsets().getWidth(),
             figure.getInsets().getHeight());
    d.union_(getBorderPreferredSize(figure));
    return d;

}

/**
 * Calculates and returns the preferred size of the given figure.  This is the union of
 * the preferred sizes of the widest and the tallest of all its children.
 *
 * @see AbstractLayout#calculatePreferredSize(IFigure, int, int)
 */
protected Dimension calculatePreferredSize(IFigure figure, int wHint, int hHint) {
    if (wHint > -1)
        wHint = Math.max(0, wHint - figure.getInsets().getWidth());
    if (hHint > -1)
        hHint = Math.max(0, hHint - figure.getInsets().getHeight());
    Dimension d = new Dimension();
    List children = figure.getChildren();
    IFigure child;
    for (int i = 0; i < children.size(); i++) {
        child = cast(IFigure)children.get(i);
        if (!isObservingVisibility() || child.isVisible())
            d.union_(child.getPreferredSize(wHint, hHint));
    }

    d.expand(figure.getInsets().getWidth(),
             figure.getInsets().getHeight());
    d.union_(getBorderPreferredSize(figure));
    return d;
}

/**
 * @see dwtx.draw2d.LayoutManager#layout(IFigure)
 */
public void layout(IFigure figure) {
    Rectangle r = figure.getClientArea();
    List children = figure.getChildren();
    IFigure child;
    for (int i = 0; i < children.size(); i++) {
        child = cast(IFigure)children.get(i);
        child.setBounds(r);
    }
}

}
