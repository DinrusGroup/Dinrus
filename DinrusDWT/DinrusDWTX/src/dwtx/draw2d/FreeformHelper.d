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
module dwtx.draw2d.FreeformHelper;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;

import dwtx.draw2d.geometry.Insets;
import dwtx.draw2d.geometry.Rectangle;
import dwtx.draw2d.FreeformListener;
import dwtx.draw2d.FreeformFigure;
import dwtx.draw2d.IFigure;
import dwtx.draw2d.FigureListener;

class FreeformHelper
    : FreeformListener
{

class ChildTracker : FigureListener {
    public void figureMoved(IFigure source) {
        invalidate();
    }
}

private FreeformFigure host;
private Rectangle freeformExtent;
private FigureListener figureListener;

private void instanceInit(){
    figureListener = new ChildTracker();
}
this(FreeformFigure host) {
    instanceInit();
    this.host = host;
}

public Rectangle getFreeformExtent() {
    if (freeformExtent !is null)
        return freeformExtent;
    Rectangle r;
    List children = host.getChildren();
    for (int i = 0; i < children.size(); i++) {
        IFigure child = cast(IFigure)children.get(i);
        if (null !is cast(FreeformFigure) child )
            r = (cast(FreeformFigure) child).getFreeformExtent();
        else
            r = child.getBounds();
        if (freeformExtent is null)
            freeformExtent = r.getCopy();
        else
            freeformExtent.union_(r);
    }
    Insets insets = host.getInsets();
    if (freeformExtent is null)
        freeformExtent = new Rectangle(0, 0, insets.getWidth(), insets.getHeight());
    else {
        host.translateToParent(freeformExtent);
        freeformExtent.expand(insets);
    }
//  System.out.println("New extent calculated for " + host + " = " + freeformExtent);
    return freeformExtent;
}

public void hookChild(IFigure child) {
    invalidate();
    if (null !is cast(FreeformFigure)child )
        (cast(FreeformFigure)child).addFreeformListener(this);
    else
        child.addFigureListener(figureListener);
}

void invalidate() {
    freeformExtent = null;
    host.fireExtentChanged();
    if (host.getParent() !is null)
        host.getParent().revalidate();
    else
        host.revalidate();
}

public void notifyFreeformExtentChanged() {
    //A childs freeform extent has changed, therefore this extent must be recalculated
    invalidate();
}

public void setFreeformBounds(Rectangle bounds) {
    host.setBounds(bounds);
    bounds = bounds.getCopy();
    host.translateFromParent(bounds);
    List children = host.getChildren();
    for (int i = 0; i < children.size(); i++) {
        IFigure child = cast(IFigure)children.get(i);
        if (null !is cast(FreeformFigure)child )
            (cast(FreeformFigure) child).setFreeformBounds(bounds);
    }
}

public void unhookChild(IFigure child) {
    invalidate();
    if (null !is cast(FreeformFigure)child )
        (cast(FreeformFigure)child).removeFreeformListener(this);
    else
        child.removeFigureListener(figureListener);
}

}
