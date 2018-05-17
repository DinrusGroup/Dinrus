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
module dwtx.draw2d.XYLayout;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;

import dwtx.draw2d.geometry.Dimension;
import dwtx.draw2d.geometry.Insets;
import dwtx.draw2d.geometry.Point;
import dwtx.draw2d.geometry.Rectangle;

import dwtx.draw2d.AbstractLayout;
import dwtx.draw2d.IFigure;

/**
 * This class implements the {@link dwtx.draw2d.LayoutManager} interface using the
 * XY Layout algorithm. This lays out the components using the layout constraints as
 * defined by each component.
 */
public class XYLayout
    : AbstractLayout
{

/** The layout contraints */
protected Map constraints;

this(){
    constraints = new HashMap();
}

/**
 * Calculates and returns the preferred size of the input figure. Since in XYLayout the
 * location of the child should be preserved, the preferred size would be a region which
 * would hold all the children of the input figure. If no constraint is set, that child
 * is ignored for calculation. If width and height are not positive, the preferred
 * dimensions of the child are taken.
 *
 * @see AbstractLayout#calculatePreferredSize(IFigure, int, int)
 * @since 2.0
 */
protected Dimension calculatePreferredSize(IFigure f, int wHint, int hHint) {
    Rectangle rect = new Rectangle();
    ListIterator children = f.getChildren().listIterator();
    while (children.hasNext()) {
        IFigure child = cast(IFigure)children.next();
        Rectangle r = cast(Rectangle)constraints.get(cast(Object)child);
        if (r is null)
            continue;

        if (r.width is -1 || r.height is -1) {
            Dimension preferredSize = child.getPreferredSize(r.width, r.height);
            r = r.getCopy();
            if (r.width is -1)
                r.width = preferredSize.width;
            if (r.height is -1)
                r.height = preferredSize.height;
        }
        rect.union_(r);
    }
    Dimension d = rect.getSize();
    Insets insets = f.getInsets();
    return (new Dimension(d.width + insets.getWidth(), d.height + insets.getHeight())).
        union_(getBorderPreferredSize(f));
}

/**
 * @see LayoutManager#getConstraint(IFigure)
 */
public Object getConstraint(IFigure figure) {
    return constraints.get(cast(Object)figure);
}

/**
 * Returns the origin for the given figure.
 * @param parent the figure whose origin is requested
 * @return the origin
 */
public Point getOrigin(IFigure parent) {
    return parent.getClientArea().getLocation();
}

/**
 * Implements the algorithm to layout the components of the given container figure.
 * Each component is laid out using its own layout constraint specifying its size
 * and position.
 *
 * @see LayoutManager#layout(IFigure)
 */
public void layout(IFigure parent) {
    Iterator children = parent.getChildren().iterator();
    Point offset = getOrigin(parent);
    IFigure f;
    while (children.hasNext()) {
        f = cast(IFigure)children.next();
        Rectangle bounds = cast(Rectangle)getConstraint(f);
        if (bounds is null) continue;

        if (bounds.width is -1 || bounds.height is -1) {
            Dimension preferredSize = f.getPreferredSize(bounds.width, bounds.height);
            bounds = bounds.getCopy();
            if (bounds.width is -1)
                bounds.width = preferredSize.width;
            if (bounds.height is -1)
                bounds.height = preferredSize.height;
        }
        bounds = bounds.getTranslated(offset);
        f.setBounds(bounds);
    }
}

/**
 * @see LayoutManager#remove(IFigure)
 */
public void remove(IFigure figure) {
    super.remove(figure);
    constraints.remove(cast(Object)figure);
}

/**
 * Sets the layout constraint of the given figure. The constraints can only be of type
 * {@link Rectangle}.
 *
 * @see LayoutManager#setConstraint(IFigure, Object)
 * @since 2.0
 */
public void setConstraint(IFigure figure, Object newConstraint) {
    super.setConstraint(figure, newConstraint);
    if (newConstraint !is null)
        constraints.put(cast(Object)figure, newConstraint);
}

}
