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
module dwtx.draw2d.geometry.PrecisionRectangle;

import dwt.dwthelper.utils;
import dwtx.draw2d.geometry.Rectangle;
import dwtx.draw2d.geometry.Insets;
import dwtx.draw2d.geometry.Point;
import dwtx.draw2d.geometry.Dimension;
import dwtx.draw2d.geometry.PrecisionPoint;

/**
 * A Rectangle implementation using floating point values which are truncated into the inherited
 * integer fields. The use of floating point prevents rounding errors from accumulating.
 * @author hudsonr
 * Created on Apr 9, 2003
 */
public final class PrecisionRectangle : Rectangle {

/** Double value for height */
public double preciseHeight_;

/** Double value for width */
public double preciseWidth_;

/** Double value for X */
public double preciseX_;

/** Double value for Y */
public double preciseY_;

/**
 * Constructs a new PrecisionRectangle with all values 0.
 */
public this() { }

/**
 * Constructs a new PrecisionRectangle from the given integer Rectangle.
 * @param rect the base rectangle
 */
public this(Rectangle rect) {
    preciseX_ = rect.preciseX();
    preciseY_ = rect.preciseY();
    preciseWidth_ = rect.preciseWidth();
    preciseHeight_ = rect.preciseHeight();
    updateInts();
}

/**
 * @see dwtx.draw2d.geometry.Rectangle#getCopy()
 */
public Rectangle getCopy() {
    return getPreciseCopy();
}

/**
 * Returns a precise copy of this.
 * @return a precise copy
 */
public PrecisionRectangle getPreciseCopy() {
    PrecisionRectangle result = new PrecisionRectangle();
    result.preciseX_ = preciseX_;
    result.preciseY_ = preciseY_;
    result.preciseWidth_ = preciseWidth_;
    result.preciseHeight_ = preciseHeight_;
    result.updateInts();
    return result;
}

/**
 * @see dwtx.draw2d.geometry.Rectangle#crop(dwtx.draw2d.geometry.Insets)
 */
public Rectangle crop(Insets insets) {
    if (insets is null)
        return this;
    setX(preciseX_ + insets.left);
    setY(preciseY_ + insets.top);
    setWidth(preciseWidth_ - (insets.getWidth()));
    setHeight(preciseHeight_ - (insets.getHeight()));

    return this;
}

/**
 * @see Rectangle#equals(Object)
 */
public override int opEquals(Object o) {
    if ( auto pr = cast(PrecisionRectangle)o ) {
        return super.opEquals(o)
            && Math.abs(pr.preciseX_ - preciseX_) < 0.000000001
            && Math.abs(pr.preciseY_ - preciseY_) < 0.000000001
            && Math.abs(pr.preciseWidth_ - preciseWidth_) < 0.000000001
            && Math.abs(pr.preciseHeight_ - preciseHeight_) < 0.00000001;
    }

    return super.opEquals(o);
}

/**
 * @see dwtx.draw2d.geometry.Rectangle#performScale(double)
 */
public void performScale(double factor) {
    preciseX_ *= factor;
    preciseY_ *= factor;
    preciseWidth_ *= factor;
    preciseHeight_ *= factor;
    updateInts();
}

/**
 * @see dwtx.draw2d.geometry.Rectangle#performTranslate(int, int)
 */
public void performTranslate(int dx, int dy) {
    preciseX_ += dx;
    preciseY_ += dy;
    x += dx;
    y += dy;
}

/**
 * Returns the bottom coordinte in double precision.
 * @return the precise bottom
 */
public double preciseBottom() {
    return preciseHeight_ + preciseY_;
}

/**
 * Returns the right side in double precision.
 * @return the precise right
 */
public double preciseRight() {
    return preciseWidth_ + preciseX_;
}


/**
 * @see dwtx.draw2d.geometry.Rectangle#resize(dwtx.draw2d.geometry.Dimension)
 */
public Rectangle resize(Dimension sizeDelta) {
    preciseWidth_ += sizeDelta.preciseWidth();
    preciseHeight_ += sizeDelta.preciseHeight();
    updateInts();
    return this;
}

/**
 * Sets the height.
 * @param value the new height
 */
public void setHeight(double value) {
    preciseHeight_ = value;
    height = cast(int)Math.floor(preciseHeight_ + 0.000000001);
}

/**
 * Sets the width.
 * @param value the new width
 */
public void setWidth(double value) {
    preciseWidth_ = value;
    width = cast(int)Math.floor(preciseWidth_ + 0.000000001);
}

/**
 * Sets the x value.
 * @param value the new x value
 */
public void setX(double value) {
    preciseX_ = value;
    x = cast(int)Math.floor(preciseX_ + 0.000000001);
}

/**
 * Sets the y value.
 * @param value the new y value
 */
public void setY(double value) {
    preciseY_ = value;
    y = cast(int)Math.floor(preciseY_ + 0.000000001);
}

/**
 * @see dwtx.draw2d.geometry.Rectangle#translate(dwtx.draw2d.geometry.Point)
 */
public Rectangle translate(Point p) {
    preciseX_ += p.preciseX();
    preciseY_ += p.preciseY();
    updateInts();
    return this;
}

/**
 * Unions the given PrecisionRectangle with this rectangle and returns <code>this</code>
 * for convenience.
 * @since 3.0
 * @param other the rectangle being unioned
 * @return <code>this</code> for convenience
 * @deprecated
 * Use {@link #union(Rectangle)} instead
 */
public PrecisionRectangle union_(PrecisionRectangle other) {
    double newright = Math.max(preciseRight(), other.preciseRight());
    double newbottom = Math.max(preciseBottom(), other.preciseBottom());
    preciseX_ = Math.min(preciseX_, other.preciseX_);
    preciseY_ = Math.min(preciseY_, other.preciseY_);
    preciseWidth_ = newright - preciseX_;
    preciseHeight_ = newbottom - preciseY_;
    updateInts();

    return this;
}

/**
 * @see dwtx.draw2d.geometry.Rectangle#union(dwtx.draw2d.geometry.Rectangle)
 */
public Rectangle union_(Rectangle other) {
    double newright = Math.max(preciseRight(), other.preciseX() + other.preciseWidth());
    double newbottom = Math.max(preciseBottom(), other.preciseY() + other.preciseHeight());
    preciseX_ = Math.min(preciseX_, other.preciseX());
    preciseY_ = Math.min(preciseY_, other.preciseY());
    preciseWidth_ = newright - preciseX_;
    preciseHeight_ = newbottom - preciseY_;
    updateInts();

    return this;
}

/**
 * Updates the integer values based on the current precise values.  The integer values ar
 * the floor of the double values.  This is called automatically when calling api which is
 * overridden in this class.
 * @since 3.0
 */
public void updateInts() {
    x = cast(int)Math.floor(preciseX_ + 0.000000001);
    y = cast(int)Math.floor(preciseY_ + 0.000000001);
    width = cast(int)Math.floor(preciseWidth_ + preciseX_ + 0.000000001) - x;
    height = cast(int)Math.floor(preciseHeight_ + preciseY_ + 0.000000001) - y;
}

/**
 * @see dwtx.draw2d.geometry.Rectangle#union(dwtx.draw2d.geometry.Point)
 */
public void union_(Point p) {
    if (p.preciseX() < preciseX_) {
        preciseWidth_ += (preciseX_ - p.preciseX());
        preciseX_ = p.preciseX();
    } else {
        double right = preciseX_ + preciseWidth_;
        if (p.preciseX() > right) {
            preciseWidth_ = p.preciseX() - preciseX_;
        }
    }
    if (p.preciseY() < preciseY_) {
        preciseHeight_ += (preciseY - p.preciseY());
        preciseY_ = p.preciseY();
    } else {
        double bottom = preciseY_ + preciseHeight_;
        if (p.preciseY() > bottom) {
            preciseHeight_ = p.preciseY() - preciseY_;
        }
    }
    updateInts();
}

/**
 * @see dwtx.draw2d.geometry.Rectangle#transpose()
 */
public Rectangle transpose() {
    double temp = preciseX_;
    preciseX_ = preciseY_;
    preciseY_ = temp;
    temp = preciseWidth_;
    preciseWidth_ = preciseHeight_;
    preciseHeight_ = temp;
    super.transpose();
    return this;
}

/**
 * @see dwtx.draw2d.geometry.Rectangle#setLocation(dwtx.draw2d.geometry.Point)
 */
public Rectangle setLocation(Point loc) {
    preciseX_ = loc.preciseX();
    preciseY_ = loc.preciseY();
    updateInts();
    return this;
}

/**
 * Returns the precise geometric centre of the rectangle
 *
 * @return <code>PrecisionPoint</code> geometric center of the rectangle
 * @since 3.4
 */
public Point getCenter() {
    return new PrecisionPoint(preciseX_ + preciseWidth_ / 2.0, preciseY_ + preciseHeight_ / 2.0);
}

/**
 * Shrinks the sides of this Rectangle by the horizontal and vertical values
 * provided as input, and returns this Rectangle for convenience. The center of
 * this Rectangle is kept constant.
 *
 * @param h  Horizontal reduction amount
 * @param v  Vertical reduction amount
 * @return  <code>this</code> for convenience
 * @since 3.4
 */
public Rectangle shrink(double h, double v) {
    preciseX_ += h;
    preciseWidth_ -= (h + h);
    preciseY_ += v;
    preciseHeight_ -= (v + v);
    updateInts();
    return this;
}

/**
 * Expands the horizontal and vertical sides of this Rectangle with the values
 * provided as input, and returns this for convenience. The location of its
 * center is kept constant.
 *
 * @param h  Horizontal increment
 * @param v  Vertical increment
 * @return  <code>this</code> for convenience
 * @since 3.4
 */
public Rectangle expand(double h, double v) {
    return shrink(-h, -v);
}

/**
 * @see dwtx.draw2d.geometry.Rectangle#shrink(int, int)
 */
public Rectangle shrink(int h, int v) {
    return shrink(cast(double)h, cast(double)v);
}

/**
 * @see dwtx.draw2d.geometry.Rectangle#contains(dwtx.draw2d.geometry.Point)
 */
public bool contains(Point p) {
    return preciseX_ <= p.preciseX() && p.preciseX() <= preciseX_ + preciseWidth_
    && preciseY_ <= p.preciseY() && p.preciseY() <= preciseY_ + preciseHeight_;
}

/**
 * @see dwtx.draw2d.geometry.Rectangle#preciseX()
 */
public double preciseX() {
    return preciseX_;
}

/**
 * @see dwtx.draw2d.geometry.Rectangle#preciseY()
 */
public double preciseY() {
    return preciseY_;
}

/**
 * @see dwtx.draw2d.geometry.Rectangle#preciseWidth()
 */
public double preciseWidth() {
    return preciseWidth_;
}

/**
 * @see dwtx.draw2d.geometry.Rectangle#preciseHeight()
 */
public double preciseHeight() {
    return preciseHeight_;
}

/**
 * @see dwtx.draw2d.geometry.Rectangle#setSize(dwtx.draw2d.geometry.Dimension)
 */
public Rectangle setSize(Dimension d) {
    preciseWidth_ = d.preciseWidth();
    preciseHeight_ = d.preciseHeight();
    return super.setSize(d);
}

}
