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
module dwtx.draw2d.DelegatingLayout;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;

import dwtx.draw2d.geometry.Dimension;
import dwtx.draw2d.IFigure;
import dwtx.draw2d.AbstractLayout;
import dwtx.draw2d.Locator;

/**
 * Figures using a DelegatingLayout as their layout manager give
 * location responsibilities to their children. The children
 * of a Figure using a DelegatingLayout should have a
 * {@link Locator Locator} as a constraint whose
 * {@link Locator#relocate(IFigure target) relocate} method is
 * responsible for placing the child.
 */
public class DelegatingLayout
    : AbstractLayout
{

private Map constraints;

this(){
    constraints = new HashMap();
}
/**
 * Calculates the preferred size of the given Figure.
 * For the DelegatingLayout, this is the largest width and height
 * values of the passed Figure's children.
 *
 * @param parent the figure whose preferred size is being calculated
 * @param wHint the width hint
 * @param hHint the height hint
 * @return the preferred size
 * @since 2.0
 */
protected Dimension calculatePreferredSize(IFigure parent, int wHint, int hHint) {
    List children = parent.getChildren();
    Dimension d = new Dimension();
    for (int i = 0; i < children.size(); i++) {
        IFigure child = cast(IFigure)children.get(i);
        d.union_(child.getPreferredSize());
    }
    return d;
}

/**
 * @see dwtx.draw2d.LayoutManager#getConstraint(dwtx.draw2d.IFigure)
 */
public Object getConstraint(IFigure child) {
    return constraints.get(cast(Object)child);
}

/**
 * Lays out the given figure's children based on their {@link Locator} constraint.
 * @param parent the figure whose children should be layed out
 */
public void layout(IFigure parent) {
    List children = parent.getChildren();
    for (int i = 0; i < children.size(); i++) {
        IFigure child = cast(IFigure)children.get(i);
        Locator locator = cast(Locator)constraints.get(cast(Object)child);
        if (locator !is null) {
            locator.relocate(child);
        }
    }
}

/**
 * Removes the locator for the given figure.
 * @param child the child being removed
 */
public void remove(IFigure child) {
    constraints.remove(cast(Object)child);
}

/**
 * Sets the constraint for the given figure.
 * @param figure the figure whose contraint is being set
 * @param constraint the new constraint
 */
public void setConstraint(IFigure figure, Object constraint) {
    super.setConstraint(figure, constraint);
    if (constraint !is null)
        constraints.put(cast(Object)figure, constraint);
}

}
