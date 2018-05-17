/*******************************************************************************
 * Copyright (c) 2003, 2008 IBM Corporation and others.
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
module dwtx.draw2d.geometry.PrecisionDimension;

import dwt.dwthelper.utils;
import dwtx.draw2d.geometry.Dimension;


/**
 * @author Randy Hudson
 */
public class PrecisionDimension : Dimension {

/**
 * The width in double precision.
 */
public double preciseWidth_;
/**
 * The height in double precision.
 */
public double preciseHeight_;

/**
 * Constructs a new precision dimension.
 */
public this() {
}

/**
 * Constructs a new precision dimension with the given values.
 * @param width the width
 * @param height the height
 */
public this(double width, double height) {
    preciseWidth_ = width;
    preciseHeight_ = height;
    updateInts();
}

/**
 * Constructs a precision representation of the given dimension.
 * @param d the reference dimension
 */
public this(Dimension d) {
    preciseHeight_ = d.preciseHeight();
    preciseWidth_ = d.preciseWidth();
    updateInts();
}

/**
 * @see dwtx.draw2d.geometry.Dimension#performScale(double)
 */
public void performScale(double factor) {
    preciseHeight_ *= factor;
    preciseWidth_ *= factor;
    updateInts();
}

/**
 * Updates the integer fields using the precise versions.
 */
public final void updateInts() {
    width = cast(int)Math.floor(preciseWidth_ + 0.000000001);
    height = cast(int)Math.floor(preciseHeight_ + 0.000000001);
}

/**
 * @see dwtx.draw2d.geometry.Dimension#preciseWidth()
 */
public double preciseWidth() {
    return preciseWidth_;
}

/**
 * @see dwtx.draw2d.geometry.Dimension#preciseHeight()
 */
public double preciseHeight() {
    return preciseHeight_;
}

}
