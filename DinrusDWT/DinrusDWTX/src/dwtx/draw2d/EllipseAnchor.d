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
module dwtx.draw2d.EllipseAnchor;

import dwt.dwthelper.utils;

import dwtx.draw2d.geometry.Point;
import dwtx.draw2d.geometry.Rectangle;
import dwtx.draw2d.AbstractConnectionAnchor;
import dwtx.draw2d.IFigure;

/**
 * Similar to a {@link dwtx.draw2d.ChopboxAnchor}, except this anchor is located on
 * the ellipse defined by the owners bounding box.
 * @author Alex Selkov
 * Created 31.08.2002 23:11:43
 */
public class EllipseAnchor : AbstractConnectionAnchor {

/**
 * @see dwtx.draw2d.AbstractConnectionAnchor#AbstractConnectionAnchor()
 */
public this() { }

/**
 * @see dwtx.draw2d.AbstractConnectionAnchor#AbstractConnectionAnchor(IFigure)
 */
public this(IFigure owner) {
    super(owner);
}

/**
 * Returns a point on the ellipse (defined by the owner's bounding box) where the
 * connection should be anchored.
 * @see dwtx.draw2d.ConnectionAnchor#getLocation(Point)
 */
public Point getLocation(Point reference) {
    Rectangle r = Rectangle.SINGLETON;
    r.setBounds(getOwner().getBounds());
    r.translate(-1, -1);
    r.resize(1, 1);
    getOwner().translateToAbsolute(r);

    Point ref_ = r.getCenter().negate().translate(reference);

    if (ref_.x is 0)
        return new Point(reference.x, (ref_.y > 0) ? r.bottom() : r.y);
    if (ref_.y is 0)
        return new Point((ref_.x > 0) ? r.right() : r.x, reference.y);

    float dx = (ref_.x > 0) ? 0.5f : -0.5f;
    float dy = (ref_.y > 0) ? 0.5f : -0.5f;

    // ref.x, ref.y, r.width, r.height !is 0 => safe to proceed

    float k = cast(float)(ref_.y * r.width) / (ref_.x * r.height);
    k = k * k;

    return r.getCenter().translate(cast(int)(r.width * dx / Math.sqrt(1 + k)),
                                    cast(int)(r.height * dy / Math.sqrt(1 + 1 / k)));
}
}
