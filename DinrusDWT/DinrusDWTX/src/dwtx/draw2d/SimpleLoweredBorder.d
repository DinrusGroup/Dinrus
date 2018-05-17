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
module dwtx.draw2d.SimpleLoweredBorder;

import dwt.dwthelper.utils;

import dwt.graphics.Color;
import dwtx.draw2d.SchemeBorder;
import dwtx.draw2d.ColorConstants;

/**
 * Provides a lowered border.
 */
public final class SimpleLoweredBorder
    : SchemeBorder
{

private static Scheme DOUBLE_;
private static Scheme DOUBLE(){
    if( !initStaticCtor_done ) initStaticCtor();
    assert(DOUBLE_);
    return DOUBLE_;
}

private static bool initStaticCtor_done = false;
private static void initStaticCtor(){
    synchronized( SimpleLoweredBorder.classinfo ){
        if( !initStaticCtor_done ){
            DOUBLE_ = new Scheme(
                [ColorConstants.buttonDarkest,  ColorConstants.buttonDarker],
                [ColorConstants.buttonLightest, ColorConstants.button] );
            initStaticCtor_done = true;
        }
    }
}


/**
 * Constructs a SimpleLoweredBorder with the predefined button-pressed Scheme set as
 * default.
 *
 * @since 2.0
 */
public this() {
    super(SCHEMES.BUTTON_PRESSED);
}

/**
 * Constructs a SimpleLoweredBorder with the width of all sides provided as input. If
 * width is 2, this SimpleLoweredBorder will use the local DOUBLE Scheme, otherwise it
 * will use the {@link SchemeBorder.SCHEMES#BUTTON_PRESSED} Scheme.
 *
 * @param width the width of all the sides of the border
 * @since 2.0
 */
public this(int width) {
    super(width is 2 ? DOUBLE : SCHEMES.BUTTON_PRESSED);
}

}
