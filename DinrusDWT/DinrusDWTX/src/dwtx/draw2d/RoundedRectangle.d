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
module dwtx.draw2d.RoundedRectangle;

import dwt.dwthelper.utils;

import dwtx.draw2d.geometry.Dimension;
import dwtx.draw2d.geometry.Rectangle;
import dwtx.draw2d.Shape;
import dwtx.draw2d.Graphics;

/**
 * Draws a Rectangle whose corners are rounded in appearance. The size of the rectangle is
 * determined by the bounds set to it.
 */
public class RoundedRectangle : Shape {

/** The width and height radii applied to each corner. */
protected Dimension corner;

/**
 * Constructs a round cornered rectangle.
 */
public this() {
    corner = new Dimension(8, 8);
}

/**
 * @see Shape#fillShape(Graphics)
 */
protected void fillShape(Graphics graphics) {
    graphics.fillRoundRectangle(getBounds(), corner.width, corner.height);
}

/**
 * @see Shape#outlineShape(Graphics)
 */
protected void outlineShape(Graphics graphics) {
    Rectangle f = Rectangle.SINGLETON;
    Rectangle r = getBounds();
    f.x = r.x + lineWidth / 2;
    f.y = r.y + lineWidth / 2;
    f.width = r.width - lineWidth;
    f.height = r.height - lineWidth;
    graphics.drawRoundRectangle(f, corner.width, corner.height);
}

/**
 * Sets the dimensions of each corner. This will form the radii of the arcs which form the
 * corners.
 *
 * @param d the dimensions of the corner
 * @since 2.0
 */
public void setCornerDimensions(Dimension d) {
    corner.width = d.width;
    corner.height = d.height;
}

}
