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
module dwtx.draw2d.Shape;

import dwt.dwthelper.utils;
import dwtx.draw2d.Figure;
import dwtx.draw2d.Graphics;
import dwtx.draw2d.ColorConstants;

/**
 * Provides abstract support for a variety of shapes.
 * <p>
 * When customizing shapes, you shouldn't override paintFigure().  Override fillShape()
 * and outlineShape() methods instead.
 */
public abstract class Shape
    : Figure
{

/** The width of this shape's outline. */
protected int lineWidth = 1;
/** The line style to be used for this shape's outline. */
protected int lineStyle;

private bool
    fill = true,
    outline = true,
    xorFill,
    xorOutline;

/**
 * Default constructor.
 *
 * @since 2.0
 */
public this() {
    lineStyle = Graphics.LINE_SOLID;
}

/**
 * Fills the interior of the shape with the background color.
 * @param graphics the graphics object
 */
protected abstract void fillShape(Graphics graphics);

/**
 * Returns the line style used to outline this shape.
 * @return the line style
 */
public int getLineStyle() {
    return lineStyle;
}

/**
 * Returns the line width of this shape's outline.
 * @return the line width
 */
public int getLineWidth() {
    return lineWidth;
}

/**
 * Returns <code>false</code> as shapes only draw themselves onto other figures, and
 * generally dont have rectangular dimensions.
 *
 * @see Figure#isOpaque()
 * @since 2.0
 */
public bool isOpaque() {
    return false;
}

/**
 * Outlines this shape using the foreground color.
 * @param graphics the graphics object
 */
protected abstract void outlineShape(Graphics graphics);

/**
 * Paints the shape. Each shape has an outline to draw, and a region to fill within that
 * outline. Disabled shapes must visually depict the disabled state.
 *
 * @see Figure#paintFigure(Graphics)
 */
public void paintFigure(Graphics graphics) {
    if (!isEnabled()) {
        graphics.translate(1, 1);
        graphics.setBackgroundColor(ColorConstants.buttonLightest);
        graphics.setForegroundColor(ColorConstants.buttonLightest);
        if (fill) {
            graphics.setXORMode(xorFill);
            fillShape(graphics);
        }
        if (outline) {
            graphics.setXORMode(xorOutline);
            graphics.setLineStyle(lineStyle);
            graphics.setLineWidth(lineWidth);
            outlineShape(graphics);
        }
        graphics.setBackgroundColor(ColorConstants.buttonDarker);
        graphics.setForegroundColor(ColorConstants.buttonDarker);
        graphics.translate(-1, -1);
    }
    if (fill) {
        graphics.setXORMode(xorFill);
        fillShape(graphics);
    }
    if (outline) {
        graphics.setXORMode(xorOutline);
        graphics.setLineStyle(lineStyle);
        graphics.setLineWidth(lineWidth);
        outlineShape(graphics);
    }
}

/**
 * Sets whether this shape should fill its region or not. It repaints this figure.
 *
 * @param b fill state
 * @since 2.0
 */
public void setFill(bool b) {
    if (fill is b)
        return;
    fill = b;
    repaint();
}

/**
 * Sets whether XOR based fill should be used by the shape. It repaints this figure.
 *
 * @param b XOR fill state
 * @since 2.0
 */
public void setFillXOR(bool b) {
    if (xorFill is b)
        return;
    xorFill = b;
    repaint();
}

/**
 * Sets the line width to be used to outline the shape.
 *
 * @param w the new width
 * @since 2.0
 */
public void setLineWidth(int w) {
    if (lineWidth is w)
        return;
    lineWidth = w;
    repaint();
}

/**
 * Sets the style of line to be used by this shape.
 *
 * @param s the new line style
 * @since 2.0
 */
public void setLineStyle(int s) {
    if (lineStyle is s)
        return;
    lineStyle = s;
    repaint();
}

/**
 * Sets whether the outline should be drawn for this shape.
 *
 * @param b <code>true</code> if the shape should be outlined
 * @since 2.0
 */
public void setOutline(bool b) {
    if (outline is b)
        return;
    outline = b;
    repaint();
}

/**
 * Sets whether XOR based outline should be used for this shape.
 *
 * @param b <code>true</code> if the outline should be XOR'ed
 * @since 2.0
 */
public void setOutlineXOR(bool b) {
    if (xorOutline is b)
        return;
    xorOutline = b;
    repaint();
}

/**
 * Sets whether XOR based fill and XOR based outline should be used for this shape.
 *
 * @param b <code>true</code> if the outline and fill should be XOR'ed
 * @since 2.0
 */
public void setXOR(bool b) {
    xorOutline = xorFill = b;
    repaint();
}

}
