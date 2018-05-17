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
module dwtx.draw2d.LineBorder;

import dwt.dwthelper.utils;


import dwtx.draw2d.AbstractBorder;
import dwtx.draw2d.IFigure;
import dwtx.draw2d.Graphics;

import dwt.graphics.Color;
import dwtx.draw2d.geometry.Insets;

/**
 * Provides for a line border with sides of equal widths.
 */
public class LineBorder
    : AbstractBorder
{

private int width = 1;
private Color color;

/**
 * Constructs a LineBorder with the specified color and of the specified width.
 *
 * @param color The color of the border.
 * @param width The width of the border in pixels.
 * @since 2.0
 */
public this(Color color, int width) {
    setColor(color);
    setWidth(width);
}

/**
 * Constructs a LineBorder with the specified color and a width of 1 pixel.
 *
 * @param color The color of the border.
 * @since 2.0
 */
public this(Color color) {
    this(color, 1);
}

/**
 * Constructs a black LineBorder with the specified width.
 *
 * @param width The width of the border in pixels.
 * @since 2.0
 */
public this(int width) {
    this(null, width);
}

/**
 * Constructs a default black LineBorder with a width of one pixel.
 *
 * @since 2.0
 */
public this() { }

/**
 * Returns the line color of this border.
 * @return The line color of this border
 */
public Color getColor() {
    return color;
}

/**
 * Returns the space used by the border for the figure provided as input. In this border
 * all sides always have equal width.
 * @param figure The figure this border belongs to
 * @return This border's insets
 */
public Insets getInsets(IFigure figure) {
    return new Insets(getWidth());
}

/**
 * Returns the line width of this border.
 * @return The line width of this border
 */
public int getWidth() {
    return width;
}

/**
 * Returns <code>true</code> since this border is opaque. Being opaque it is responsible
 * to fill in the area within its boundaries.
 * @return <code>true</code> since this border is opaque
 */
public bool isOpaque() {
    return true;
}

/**
 * @see dwtx.draw2d.Border#paint(IFigure, Graphics, Insets)
 */
public void paint(IFigure figure, Graphics graphics, Insets insets) {
    tempRect.setBounds(getPaintRectangle(figure, insets));
    if (getWidth() % 2 is 1) {
        tempRect.width--;
        tempRect.height--;
    }
    tempRect.shrink(getWidth() / 2, getWidth() / 2);
    graphics.setLineWidth(getWidth());
    if (getColor() !is null)
        graphics.setForegroundColor(getColor());
    graphics.drawRectangle(tempRect);
}

/**
 * Sets the line color for this border.
 * @param color The line color
 */
public void setColor(Color color) {
    this.color = color;
}

/**
 * Sets the line width for this border.
 * @param width The line width
 */
public void setWidth(int width) {
    this.width = width;
}

}
