/*******************************************************************************
 * Copyright (c) 2000, 2008 IBM Corporation and others.
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
module dwtx.draw2d.geometry.PrecisionPoint;

import dwt.dwthelper.utils;
import dwtx.draw2d.geometry.Point;

/**
 * @author danlee
 */
public class PrecisionPoint : Point {

/** Double value for X **/
public double preciseX_;

/** Double value for Y **/
public double preciseY_;

/**
 * Constructor for PrecisionPoint.
 */
public this() {
    super();
}

/**
 * Constructor for PrecisionPoint.
 * @param copy Point from which the initial values are taken
 */
public this(Point copy) {
    preciseX_ = copy.preciseX();
    preciseY_ = copy.preciseY();
    updateInts();
}

/**
 * Constructor for PrecisionPoint.
 * @param x X value
 * @param y Y value
 */
public this(int x, int y) {
    super(x, y);
    preciseX_ = x;
    preciseY_ = y;
}

/**
 * Constructor for PrecisionPoint.
 * @param x X value
 * @param y Y value
 */
public this(double x, double y) {
    preciseX_ = x;
    preciseY_ = y;
    updateInts();
}

/**
 * @see dwtx.draw2d.geometry.Point#getCopy()
 */
public Point getCopy() {
    return new PrecisionPoint(preciseX_, preciseY_);
}


/**
 * @see dwtx.draw2d.geometry.Point#performScale(double)
 */
public void performScale(double factor) {
    preciseX_ = preciseX_ * factor;
    preciseY_ = preciseY_ * factor;
    updateInts();
}

/**
 * @see dwtx.draw2d.geometry.Point#performTranslate(int, int)
 */
public void performTranslate(int dx, int dy) {
    preciseX_ += dx;
    preciseY_ += dy;
    updateInts();
}

/**
 * @see dwtx.draw2d.geometry.Point#setLocation(Point)
 */
public Point setLocation(Point pt) {
    preciseX_ = pt.preciseX();
    preciseY_ = pt.preciseY();
    updateInts();
    return this;
}

/**
 * Updates the integer fields using the precise versions.
 */
public final void updateInts() {
    x = cast(int)Math.floor(preciseX_ + 0.000000001);
    y = cast(int)Math.floor(preciseY_ + 0.000000001);
}

/**
 * @see dwtx.draw2d.geometry.Point#preciseX()
 */
public double preciseX() {
    return preciseX_;
}

/**
 * @see dwtx.draw2d.geometry.Point#preciseY()
 */
public double preciseY() {
    return preciseY_;
}

}
