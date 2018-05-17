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
module dwtx.draw2d.AbstractBorder;

import dwt.dwthelper.utils;

import dwtx.draw2d.Border;
import dwtx.draw2d.IFigure;

import dwtx.draw2d.geometry.Dimension;
import dwtx.draw2d.geometry.Insets;
import dwtx.draw2d.geometry.Rectangle;

/**
 * Provides generic support for borders.
 * @author hudsonr
 */
public abstract class AbstractBorder
    : Border
{

private static Dimension EMPTY_;
private static Dimension EMPTY(){
    if( EMPTY_ is null ){
        synchronized( AbstractBorder.classinfo ){
            if( EMPTY_ is null ){
                EMPTY_ = new Dimension();
            }
        }
    }
    return EMPTY_;
}

/** A temporary Rectangle*/
private static Rectangle tempRect_;
protected static Rectangle tempRect(){
    if( tempRect_ is null ){
        synchronized( AbstractBorder.classinfo ){
            if( tempRect_ is null ){
                tempRect_ = new Rectangle();
            }
        }
    }
    return tempRect_;
}

/**
 * Returns a temporary rectangle representing the figure's bounds cropped by the specified
 * insets.  This method exists for convenience and performance; the method does not new
 * any Objects and returns a rectangle which the caller can manipulate.
 * @since 2.0
 * @param figure  Figure for which the paintable rectangle is needed
 * @param insets The insets
 * @return The paintable region on the Figure f
 */
protected static final Rectangle getPaintRectangle(IFigure figure, Insets insets) {
    tempRect.setBounds(figure.getBounds());
    return tempRect.crop(insets);
}

/**
 * @see dwtx.draw2d.Border#getPreferredSize(IFigure)
 */
public Dimension getPreferredSize(IFigure f) {
    return EMPTY;
}

/**
 * @see dwtx.draw2d.Border#isOpaque()
 */
public bool isOpaque() {
    return false;
}

}
