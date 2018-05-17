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
module dwtx.draw2d.geometry.Ray;

import dwt.dwthelper.utils;
import tango.text.convert.Format;

import dwtx.draw2d.geometry.Point;


/**
 * Represents a 2-dimensional directional Vector, or Ray. {@link java.util.Vector} is
 * commonly imported, so the name Ray was chosen.
 */
public final class Ray {

/** the X value */
public int x;
/** the Y value*/
public int y;

/**
 * Constructs a Ray &lt;0, 0&gt; with no direction and magnitude.
 * @since 2.0
 */
public this() { }

/**
 * Constructs a Ray pointed in the specified direction.
 *
 * @param x  X value.
 * @param y  Y value.
 * @since 2.0
 */
public this(int x, int y) {
    this.x = x;
    this.y = y;
}

/**
 * Constructs a Ray pointed in the direction specified by a Point.
 * @param p the Point
 * @since 2.0
 */
public this(Point p) {
    x = p.x; y = p.y;
}

/**
 * Constructs a Ray representing the direction and magnitude between to provided Points.
 * @param start Strarting Point
 * @param end End Point
 * @since 2.0
 */
public this(Point start, Point end) {
    x = end.x - start.x;
    y = end.y - start.y;
}

/**
 * Constructs a Ray representing the difference between two provided Rays.
 * @param start  The start Ray
 * @param end   The end Ray
 * @since 2.0
 */
public this(Ray start, Ray end) {
    x = end.x - start.x;
    y = end.y - start.y;
}

/**
 * Calculates the magnitude of the cross product of this Ray with another.
 * Represents the amount by which two Rays are directionally different.
 * Parallel Rays return a value of 0.
 * @param r  Ray being compared
 * @return  The assimilarity
 * @see #similarity(Ray)
 * @since 2.0
 */
public int assimilarity(Ray r) {
    return Math.abs(x * r.y - y * r.x);
}

/**
 * Calculates the dot product of this Ray with another.
 * @param r the Ray used to perform the dot product
 * @return The dot product
 * @since 2.0
 */
public int dotProduct(Ray r) {
    return x * r.x + y * r.y;
}

/**
 * @see java.lang.Object#equals(Object)
 */
public override int opEquals(Object obj) {
    if (obj is this)
        return true;
    if ( auto r = cast(Ray)obj ) {
        return x is r.x && y is r.y;
    }
    return false;
}

/**
 * Creates a new Ray which is the sum of this Ray with another.
 * @param r  Ray to be added with this Ray
 * @return  a new Ray
 * @since 2.0
 */
public Ray getAdded(Ray r) {
    return new Ray(r.x + x, r.y + y);
}

/**
 * Creates a new Ray which represents the average of this Ray with another.
 * @param r  Ray to calculate the average.
 * @return  a new Ray
 * @since 2.0
 */
public Ray getAveraged(Ray r) {
    return new Ray ((x + r.x) / 2, (y + r.y) / 2);
}

/**
 * Creates a new Ray which represents this Ray scaled by the amount provided.
 * @param s  Value providing the amount to scale.
 * @return  a new Ray
 * @since 2.0
 */
public Ray getScaled(int s) {
    return new Ray(x * s, y * s);
}

/**
 * @see java.lang.Object#toHash()
 */
public override hash_t toHash() {
    return (x * y) ^ (x + y);
}

/**
 * Returns true if this Ray has a non-zero horizontal comonent.
 * @return  true if this Ray has a non-zero horizontal comonent
 * @since 2.0
 */
public bool isHorizontal() {
    return x !is 0;
}

/**
 * Returns the length of this Ray.
 * @return  Length of this Ray
 * @since 2.0
 */
public double length() {
    return Math.sqrt(cast(real)dotProduct(this));
}

/**
 * Calculates the similarity of this Ray with another.
 * Similarity is defined as the absolute value of the dotProduct()
 * @param r  Ray being tested for similarity
 * @return  the Similarity
 * @see #assimilarity(Ray)
 * @since 2.0
 */
public int similarity(Ray r) {
    return Math.abs(dotProduct(r));
}

/**
 * @return a String representation
 */
public String toString() {
    return Format("({}, {})", x, y );//$NON-NLS-3$//$NON-NLS-2$//$NON-NLS-1$
}

}
