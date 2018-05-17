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
module dwtx.draw2d.TitleBarBorder;

import dwt.dwthelper.utils;



import dwt.graphics.Color;
import dwtx.draw2d.geometry.Insets;
import dwtx.draw2d.geometry.Rectangle;
import dwtx.draw2d.AbstractLabeledBorder;
import dwtx.draw2d.IFigure;
import dwtx.draw2d.Graphics;
import dwtx.draw2d.ColorConstants;
import dwtx.draw2d.PositionConstants;

/**
 * Border provides a title bar on the Figure for which this is the border of. Generally
 * used in conjunction with other borders to create window-like effects. Also provides for
 * alignment of the text in the bar.
 *
 * @see FrameBorder
 */
public class TitleBarBorder
    : AbstractLabeledBorder
{

private static Color defaultColor_;
private static Color defaultColor(){
    if( defaultColor_ is null ){
        synchronized( TitleBarBorder.classinfo ){
            if( defaultColor_ is null ){
                defaultColor_ = ColorConstants.menuBackgroundSelected;
            }
        }
    }
    return defaultColor_;
}

private int textAlignment;
private Insets padding;
private Color fillColor;

/**
 * Constructs a TitleBarBorder with its label set to the name of this class.
 *
 * @since 2.0
 */
public this() {
    textAlignment = PositionConstants.LEFT;
    padding = new Insets(1, 3, 2, 2);
    fillColor = defaultColor;
}

/**
 * Constructs a TitleBarBorder with its label set to the passed String.
 *
 * @param s text of the label
 * @since 2.0
 */
public this(String s) {
    this();
    setLabel(s);
}

/**
 * Calculates and returns the Insets for this border.
 *
 * @param figure the figure on which Insets calculations are based
 * @return the calculated Insets
 * @since 2.0
 */
protected Insets calculateInsets(IFigure figure) {
    return new Insets(getTextExtents(figure).height + padding.getHeight(), 0, 0, 0);
}

/**
 * Returns the background Color of this TitleBarBorder.
 * @return the background color
 * @since 2.0
 */
protected Color getBackgroundColor() {
    return fillColor;
}

/**
 * Returns this TitleBarBorder's padding. Padding provides spacing along the sides of the
 * TitleBarBorder. The default value is no padding along all sides.
 *
 * @return the Insets representing the space along the sides of the TitleBarBorder
 * @since 2.0
 */
protected Insets getPadding() {
    return padding;
}

/**
 * Returns the alignment of the text in the title bar. Possible values are
 * {@link PositionConstants#LEFT}, {@link PositionConstants#CENTER} and
 * {@link PositionConstants#RIGHT}.
 *
 * @return the text alignment
 * @since 2.0
 */
public int getTextAlignment() {
    return textAlignment;
}

/**
 * Returns <code>true</code> thereby filling up all the contents within its boundaries,
 * eleminating the need by the figure to clip the boundaries and do the same.
 *
 * @see Border#isOpaque()
 */
public bool isOpaque() {
    return true;
}

/**
 * @see Border#paint(IFigure, Graphics, Insets)
 */
public void paint(IFigure figure, Graphics g, Insets insets) {
    tempRect.setBounds(getPaintRectangle(figure, insets));
    Rectangle rec = tempRect;
    rec.height = Math.min(rec.height, getTextExtents(figure).height + padding.getHeight());
    g.clipRect(rec);
    g.setBackgroundColor(fillColor);
    g.fillRectangle(rec);

    int x = rec.x + padding.left;
    int y = rec.y + padding.top;

    int textWidth = getTextExtents(figure).width;
    int freeSpace = rec.width - padding.getWidth() - textWidth;

    if (getTextAlignment() is PositionConstants.CENTER)
        freeSpace /= 2;
    if (getTextAlignment() !is PositionConstants.LEFT)
        x += freeSpace;

    g.setFont(getFont(figure));
    g.setForegroundColor(getTextColor());
    g.drawString(getLabel(), x, y);
}

/**
 * Sets the background color of the area within the boundaries of this border. This is
 * required as this border takes responsibility for filling up the region, as
 * TitleBarBorders are always opaque.
 *
 * @param color the background color
 * @since 2.0
 */
public void setBackgroundColor(Color color) {
    fillColor = color;
}

/**
 * Sets the padding space to be applied on all sides of the border. The default value is
 * no padding on all sides.
 *
 * @param all the value of the padding on all sides
 * @since 2.0
 */
public void setPadding(int all) {
    padding = new Insets(all);
    invalidate();
}

/**
 * Sets the padding space of this TitleBarBorder to the passed value. The default value is
 * no padding on all sides.
 *
 * @param pad the padding
 * @since 2.0
 */
public void setPadding(Insets pad) {
    padding = pad; invalidate();
}

/**
 * Sets the alignment of the text in the title bar. Possible values are
 * {@link PositionConstants#LEFT}, {@link PositionConstants#CENTER} and
 * {@link PositionConstants#RIGHT}.
 *
 * @param align the new text alignment
 * @since 2.0
 */
public void setTextAlignment(int align_) {
    textAlignment = align_;
}

}
