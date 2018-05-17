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
module dwtx.draw2d.PolygonDecoration;

import dwt.dwthelper.utils;



import dwt.graphics.Color;
import dwtx.draw2d.geometry.Point;
import dwtx.draw2d.geometry.PointList;
import dwtx.draw2d.geometry.Transform;
import dwtx.draw2d.RotatableDecoration;
import dwtx.draw2d.Polygon;

/**
 * A rotatable, polygon shaped decoration most commonly used for decorating the ends of
 * {@link dwtx.draw2d.Polyline polylines}.
 */
public class PolygonDecoration
    : Polygon
    , RotatableDecoration
{

/** Template for a triangle that points to the right when the rotation angle is 0 */
private static bool initStaticConsts_done = false;
private static PointList TRIANGLE_TIP_;
/** Template for a triangle that points to the left when the rotation angle is 0 */
private static PointList INVERTED_TRIANGLE_TIP_;

public static PointList TRIANGLE_TIP(){
    if( !initStaticConsts_done ) initStaticConsts();
    return TRIANGLE_TIP_;
}
public static PointList INVERTED_TRIANGLE_TIP(){
    if( !initStaticConsts_done ) initStaticConsts();
    return INVERTED_TRIANGLE_TIP_;
}

private static void initStaticConsts() {
    synchronized( PolygonDecoration.classinfo ){
        if( !initStaticConsts_done ){
            TRIANGLE_TIP_ = new PointList();
            TRIANGLE_TIP_.addPoint(0, 0);
            TRIANGLE_TIP_.addPoint(-1, 1);
            TRIANGLE_TIP_.addPoint(-1, -1);

            INVERTED_TRIANGLE_TIP_ = new PointList();
            INVERTED_TRIANGLE_TIP_.addPoint(0, 1);
            INVERTED_TRIANGLE_TIP_.addPoint(0, -1);
            INVERTED_TRIANGLE_TIP_.addPoint(-1, 0);

            initStaticConsts_done = true;
        }
    }
}

private Point location;
private PointList template_;
private Transform transform;

/**
 * Constructs a PolygonDecoration. Defaults the PolygonDecoration to fill its region
 * with black.
 *
 * @since 2.0
 */
public this() {
    location = new Point();
    template_ = TRIANGLE_TIP;
    transform = new Transform();
    setFill(true);
    setScale(7, 3);
}

/**
 * @see dwtx.draw2d.IFigure#getBackgroundColor()
 */
public Color getLocalBackgroundColor() {
    if (super.getLocalBackgroundColor() is null)
        return getForegroundColor();
    return super.getLocalBackgroundColor();
}

/**
 * Returns the points in the PolygonDecoration as a PointList.
 *
 * @return the points in this PolygonDecoration
 * @since 2.0
 */
public PointList getPoints() {
    if (points is null) {
        points = new PointList();
        for (int i = 0; i < template_.size(); i++)
            points.addPoint(transform.getTransformed(template_.getPoint(i)));
    }
    return points;
}

/**
 * Sets the location of this PolygonDecoration.
 * @param p the new location
 */
public void setLocation(Point p) {
    points = null;
    bounds = null;
    location.setLocation(p);
    transform.setTranslation(p.x, p.y);
}

/**
 * Sets the PolygonDecorations point template_ to the passed PointList. This template_ is an
 * outline of the PolygonDecoration's region. (The default value is TRIANGLE_TIP which is
 * a triangle whose tip is pointing to the right).
 *
 * @param pl the PointList outline to use as the PolygonDecoration's region
 * @since 2.0
 */
public void setTemplate(PointList pl) {
    erase();
    template_ = pl;
    points = null;
    bounds = null;
    repaint();
}

/**
 * Sets the amount of scaling to be done along X and Y axes on the PolygonDecoration's
 * template_.
 *
 * @param x X scaling
 * @param y Y scaling
 * @since 2.0
 */
public void setScale(double x, double y) {
    points = null;
    bounds = null;
    transform.setScale(x, y);
}

/**
 * Sets the rotation of this decoration so that the decoration points toward the
 * given reference point.
 * @param ref the reference point
 */
public void setReferencePoint(Point ref_) {
    Point pt = Point.SINGLETON;
    pt.setLocation(ref_);
    pt.negate().translate(location);
    setRotation(Math.atan2(pt.y, pt.x));
}

/**
 * Sets the angle by which rotation is to be done on the PolygonDecoration.
 *
 * @param angle Angle of rotation
 * @since 2.0
 */
public void setRotation(double angle) {
    points = null;
    bounds = null;
    transform.setRotation(angle);
}

}
