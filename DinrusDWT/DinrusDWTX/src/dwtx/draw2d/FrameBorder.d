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
module dwtx.draw2d.FrameBorder;

import dwt.dwthelper.utils;

import dwt.graphics.Color;
import dwt.graphics.Font;
import dwtx.draw2d.CompoundBorder;
import dwtx.draw2d.LabeledBorder;
import dwtx.draw2d.SchemeBorder;
import dwtx.draw2d.ColorConstants;
import dwtx.draw2d.TitleBarBorder;


/**
 * Provides for a frame-like border which contains a title bar for holding the title of a
 * Figure.
 */
public class FrameBorder
    : CompoundBorder
    , LabeledBorder
{

/**
 * The border scheme that determines the border highlight and shadow colors, as well as
 * the border width (3).
 */
private static SchemeBorder.Scheme SCHEME_FRAME_;
protected static SchemeBorder.Scheme SCHEME_FRAME(){
    if( SCHEME_FRAME_ is null ){
        synchronized( FrameBorder.classinfo ){
            if( SCHEME_FRAME_ is null ){
                SCHEME_FRAME_ = new SchemeBorder.Scheme(
                    [
                        ColorConstants.button,
                        ColorConstants.buttonLightest,
                        ColorConstants.button
                    ],
                    [
                        ColorConstants.buttonDarkest,
                        ColorConstants.buttonDarker,
                        ColorConstants.button
                    ]
                );
            }
        }
    }
    return SCHEME_FRAME_;
}
private void instanceInit(){
    createBorders();
}

/**
 * Constructs a FrameBorder with its label set to the name of the {@link TitleBarBorder}
 * class.
 *
 * @since 2.0
 */
public this() {
    instanceInit();
}

/**
 * Constructs a FrameBorder with the title set to the passed String.
 *
 * @param label  label or title of the frame.
 * @since 2.0
 */
public this(String label) {
    instanceInit();
    setLabel(label);
}

/**
 * Creates the necessary borders for this FrameBorder. The inner border is a
 * {@link TitleBarBorder}. The outer border is a {@link SchemeBorder}.
 *
 * @since 2.0
 */
protected void createBorders() {
    inner = new TitleBarBorder();
    outer = new SchemeBorder(SCHEME_FRAME);
}

/**
 * Returns the inner border of this FrameBorder, which contains the label for the
 * FrameBorder.
 *
 * @return  the border holding the label.
 * @since 2.0
 */
protected LabeledBorder getLabeledBorder() {
    return cast(LabeledBorder)inner;
}

/**
 * @return the label for this border
 */
public String getLabel() {
    return getLabeledBorder().getLabel();
}

/**
 * Sets the label for this border.
 * @param label the label
 */
public void setLabel(String label) {
    getLabeledBorder().setLabel(label);
}

/**
 * Sets the font for this border's label.
 * @param font the font
 */
public void setFont(Font font) {
    getLabeledBorder().setFont(font);
}

}
