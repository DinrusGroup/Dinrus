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
module dwtx.draw2d.MouseEvent;

import dwt.dwthelper.utils;

import dwtx.draw2d.geometry.Point;
import tango.text.convert.Format;
import dwtx.draw2d.InputEvent;
import dwtx.draw2d.EventDispatcher;
import dwtx.draw2d.IFigure;

/**
 * An event caused by the user interacting with the mouse.
 */
public class MouseEvent
    : InputEvent
{

/** The X coordinate of the mouse event. */
public int x;
/** The Y coordinate of the mouse event. */
public int y;

/** The button that was pressed or released: {1, 2, 3}. */
public int button;

this(int x, int y, EventDispatcher dispatcher,
            IFigure f, int button, int stateMask) {
    super(dispatcher, f, stateMask);
    Point pt = Point.SINGLETON;
    pt.setLocation(x, y);
    f.translateToRelative(pt);
    this.button = button;
    this.x = pt.x;
    this.y = pt.y;
}

/**
 * @return the location of this mouse event
 */
public Point getLocation() {
    return new Point(x, y);
}

/**
 * @see Object#toString()
 */
public override String toString() {
    return Format( "MouseEvent({},{}) to Figure: {}", x, y, source);//$NON-NLS-2$//$NON-NLS-1$
}

}
