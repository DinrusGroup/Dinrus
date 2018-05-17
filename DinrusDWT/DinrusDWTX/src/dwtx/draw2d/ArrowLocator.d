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
module dwtx.draw2d.ArrowLocator;

import dwt.dwthelper.utils;

import dwtx.draw2d.geometry.PointList;
import dwtx.draw2d.ConnectionLocator;
import dwtx.draw2d.IFigure;
import dwtx.draw2d.Connection;
import dwtx.draw2d.RotatableDecoration;

/**
 * Locator used to place a {@link RotatableDecoration} on a {@link Connection}. The
 * decoration can be placed at the source or target end of the connection figure. The
 * default connection implementation uses a {@link DelegatingLayout} which requires
 * locators.
 */
public class ArrowLocator : ConnectionLocator {

/**
 * Constructs an ArrowLocator associated with passed connection and tip location (either
 * {@link ConnectionLocator#SOURCE} or {@link ConnectionLocator#TARGET}).
 *
 * @param connection The connection associated with the locator
 * @param location Location of the arrow decoration
 * @since 2.0
 */
public this(Connection connection, int location) {
    super(connection, location);
}

/**
 * Relocates the passed in figure (which must be a {@link RotatableDecoration}) at either
 * the start or end of the connection.
 * @param target The RotatableDecoration to relocate
 */
public void relocate(IFigure target) {
    PointList points = getConnection().getPoints();
    RotatableDecoration arrow = cast(RotatableDecoration)target;
    arrow.setLocation(getLocation(points));

    if (getAlignment() is SOURCE)
        arrow.setReferencePoint(points.getPoint(1));
    else if (getAlignment() is TARGET)
        arrow.setReferencePoint(points.getPoint(points.size() - 2));
}

}
