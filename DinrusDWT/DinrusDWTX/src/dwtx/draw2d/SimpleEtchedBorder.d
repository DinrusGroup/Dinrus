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
module dwtx.draw2d.SimpleEtchedBorder;

import dwt.dwthelper.utils;

import dwtx.draw2d.geometry.Insets;
import dwtx.draw2d.geometry.Rectangle;
import dwtx.draw2d.SchemeBorder;
import dwtx.draw2d.Border;
import dwtx.draw2d.IFigure;
import dwtx.draw2d.Graphics;
import dwtx.draw2d.FigureUtilities;

/**
 * Provides a two pixel wide constant sized border, having an etched look.
 */
public final class SimpleEtchedBorder
    : SchemeBorder
{

/** The singleton instance of this class */
private static Border singleton_;

/** The insets */
private static Insets INSETS_;

public static Border singleton(){
    if( !initStaticCtor_done ) initStaticCtor();
    assert(singleton_);
    return singleton_;
}
protected static Insets INSETS(){
    if( !initStaticCtor_done ) initStaticCtor();
    assert(INSETS_);
    return INSETS_;
}

private static bool initStaticCtor_done = false;
private static void initStaticCtor(){
    synchronized( SimpleEtchedBorder.classinfo ){
        if( !initStaticCtor_done ){
            singleton_ = new SimpleEtchedBorder();
            INSETS_ = new Insets(2);
            initStaticCtor_done = true;
        }
    }
}




/**
 * Constructs a default border having a two pixel wide border.
 *
 * @since 2.0
 */
protected this() { }

/**
 * Returns the Insets used by this border. This is a constant value of two pixels in each
 * direction.
 * @see Border#getInsets(IFigure)
 */
public Insets getInsets(IFigure figure) {
    return new Insets(INSETS);
}

/**
 * Returns the opaque state of this border. This border is opaque and takes responsibility
 * to fill the region it encloses.
 * @see Border#isOpaque()
 */
public bool isOpaque() {
    return true;
}

/**
 * @see Border#paint(IFigure, Graphics, Insets)
 */
public void paint(IFigure figure, Graphics g, Insets insets) {
    Rectangle rect = getPaintRectangle(figure, insets);
    FigureUtilities.paintEtchedBorder(g, rect);
}

}
