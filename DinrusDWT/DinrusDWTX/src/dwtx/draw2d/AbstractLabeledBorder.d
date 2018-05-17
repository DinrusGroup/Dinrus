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
module dwtx.draw2d.AbstractLabeledBorder;

import dwt.dwthelper.utils;



import dwt.graphics.Color;
import dwt.graphics.Font;
import dwtx.draw2d.geometry.Dimension;
import dwtx.draw2d.geometry.Insets;
import dwtx.draw2d.AbstractBorder;
import dwtx.draw2d.LabeledBorder;
import dwtx.draw2d.IFigure;
import dwtx.draw2d.ColorConstants;
import dwtx.draw2d.FigureUtilities;

/**
 * Provides support for a border with a label describing the contents of which it is
 * surrounding.
 */
public abstract class AbstractLabeledBorder
    : AbstractBorder
    , LabeledBorder
{

private Dimension textExtents;
private String label;
private Insets insets;
private Color textColor;
private Font font;

/**
 * Constructs a default AbstractLabeledBorder with the name of this class set as its
 * label.
 *
 * @since 2.0
 */
public this() {
    textColor = ColorConstants.black;
    String className = this.classinfo.name;
    setLabel(className.substring(className.lastIndexOf('.') + 1, className.length));
}

/**
 * Constructs a border with the label set to the String passed in as input.
 *
 * @param s  Label to be set on the border
 * @since 2.0
 */
public this(String s) {
    textColor = ColorConstants.black;
    setLabel(s);
}

/**
 * Calculates insets based on the current font and other attributes. This value will be
 * cached until {@link #invalidate()} is called.
 * @param figure The figure to which the border is being applied
 * @return The Insets
 */
protected abstract Insets calculateInsets(IFigure figure);

/**
 * Returns the font that this border will use. If no Font has been specified, the font
 * associated with the input Figure will be used.
 * @param f Figure used to get a default font
 * @return The font for this border
 */
protected Font getFont(IFigure f) {
    if (font is null)
        return f.getFont();
    return font;
}

/**
 * Returns the insets, or space associated for this border. Returns any previously set
 * value if present, else calculates it from the Figure provided in as input.
 * @param fig Figure used to calculate insets
 * @return The insets
 */
public Insets getInsets(IFigure fig) {
    if (insets is null)
        insets = calculateInsets(fig);
    return insets;
}

/**
 * @see dwtx.draw2d.LabeledBorder#getLabel()
 */
public String getLabel() {
    return label;
}

/**
 * @see dwtx.draw2d.Border#getPreferredSize(IFigure)
 */
public Dimension getPreferredSize(IFigure fig) {
    return new Dimension(getTextExtents(fig));
}

/**
 * Returns the text Color of this AbstractLabeledBorder's label.
 *
 * @return The text color
 * @since 2.0
 */
public Color getTextColor() {
    return textColor;
}

/**
 * Calculates and returns the size required by this border's label.
 *
 * @param f  IFigure on which the calculations are to be made
 * @return   Dimensions required by the text of this border's label
 * @since 2.0
 */
protected Dimension getTextExtents(IFigure f) {
    if (textExtents is null)
        textExtents = FigureUtilities.getTextExtents(label, getFont(f));
    return textExtents;
}

/**
 * Resets the internal values and state so that they can be recalculated. Called whenever
 * a state  change has occurred that effects the insets or  text extents of this border.
 */
protected void invalidate() {
    insets = null;
    textExtents = null;
}

/**
 * Sets the Font of this border to the input value, and invalidates the border forcing an
 * update of internal parameters of insets and text extents.
 * @param font The font
 */
public void setFont(Font font) {
    this.font = font;
    invalidate();
}

/**
 * @see dwtx.draw2d.LabeledBorder#setLabel(String)
 */
public void setLabel(String s) {
    label = ((s is null) ? "" : s);  //$NON-NLS-1$
    invalidate();
}

/**
 * Sets the color for this border's text.
 *
 * @param color  Color to be set for this border's text
 * @since 2.0
 */
public void setTextColor(Color color) {
    textColor = color;
}

}
