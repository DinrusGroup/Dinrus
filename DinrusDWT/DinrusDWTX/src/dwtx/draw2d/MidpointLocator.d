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
module dwtx.draw2d.MidpointLocator;

import dwt.dwthelper.utils;

import dwtx.draw2d.geometry.Point;
import dwtx.draw2d.ConnectionLocator;
import dwtx.draw2d.Connection;

/**
 * A ConnectionLocator that is used to place figures at the midpoint between two points on
 * a {@link dwtx.draw2d.Connection}.
 */
public class MidpointLocator
    : ConnectionLocator
{

private int index;

/**
 * Constructs a MidpointLocator with associated Connection <i>c</i> and index <i>i</i>.
 * The points at index i and i+1 on the connection are used to calculate the midpoint of
 * the line segment.
 *
 * @param c the connection associated with the locator
 * @param i the point from where the connection's midpoint will be calculated.
 * @since 2.0
 */
public this(Connection c, int i) {
    super(c);
    index = i;
}

/**
 * Returns this MidpointLocator's index. This integer represents the position of the start
 * point in this MidpointLocator's associated {@link Connection} from where midpoint
 * calculation will be made.
 *
 * @return the locator's index
 * @since 2.0
 */

protected int getIndex() {
    return index;
}

/**
 * Returns the point of reference associated with this locator. This point will be midway
 * between points at 'index' and 'index' + 1.
 *
 * @return the reference point
 * @since 2.0
 */
protected Point getReferencePoint() {
    Connection conn = getConnection();
    Point p = Point.SINGLETON;
    Point p1 = conn.getPoints().getPoint(getIndex());
    Point p2 = conn.getPoints().getPoint(getIndex() + 1);
    conn.translateToAbsolute(p1);
    conn.translateToAbsolute(p2);
    p.x = (p2.x - p1.x) / 2 + p1.x;
    p.y = (p2.y - p1.y) / 2 + p1.y;
    return p;
}

}
