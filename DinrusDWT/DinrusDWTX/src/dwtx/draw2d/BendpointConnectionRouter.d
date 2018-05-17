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
module dwtx.draw2d.BendpointConnectionRouter;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;

import dwtx.draw2d.geometry.Point;
import dwtx.draw2d.geometry.PointList;
import dwtx.draw2d.geometry.PrecisionPoint;
import dwtx.draw2d.AbstractRouter;
import dwtx.draw2d.Connection;
import dwtx.draw2d.Bendpoint;

/**
 * Routes {@link Connection}s through a <code>List</code> of {@link Bendpoint Bendpoints}.
 */
public class BendpointConnectionRouter
    : AbstractRouter
{

private Map constraints;

private static PrecisionPoint A_POINT_;
private static PrecisionPoint A_POINT(){
    if( A_POINT_ is null ){
        synchronized( BendpointConnectionRouter.classinfo ){
            if( A_POINT_ is null ){
                A_POINT_ = new PrecisionPoint();
            }
        }
    }
    return A_POINT_;
}

public this(){
    constraints = new HashMap(11);
}

/**
 * Gets the constraint for the given {@link Connection}.
 *
 * @param connection The connection whose constraint we are retrieving
 * @return The constraint
 */
public Object getConstraint(Connection connection) {
    return constraints.get(cast(Object)connection);
}

/**
 * Removes the given connection from the map of constraints.
 *
 * @param connection The connection to remove
 */
public void remove(Connection connection) {
    constraints.remove(cast(Object)connection);
}

/**
 * Routes the {@link Connection}.  Expects the constraint to be a List
 * of {@link dwtx.draw2d.Bendpoint Bendpoints}.
 *
 * @param conn The connection to route
 */
public void route(Connection conn) {
    PointList points = conn.getPoints();
    points.removeAllPoints();

    List bendpoints = cast(List)getConstraint(conn);
    if (bendpoints is null)
        bendpoints = Collections.EMPTY_LIST;

    Point ref1, ref2;

    if (bendpoints.isEmpty()) {
        ref1 = conn.getTargetAnchor().getReferencePoint();
        ref2 = conn.getSourceAnchor().getReferencePoint();
    } else {
        ref1 = new Point((cast(Bendpoint)bendpoints.get(0)).getLocation());
        conn.translateToAbsolute(ref1);
        ref2 = new Point((cast(Bendpoint)bendpoints.get(bendpoints.size() - 1)).getLocation());
        conn.translateToAbsolute(ref2);
    }

    A_POINT.setLocation(conn.getSourceAnchor().getLocation(ref1));
    conn.translateToRelative(A_POINT);
    points.addPoint(A_POINT);

    for (int i = 0; i < bendpoints.size(); i++) {
        Bendpoint bp = cast(Bendpoint)bendpoints.get(i);
        points.addPoint(bp.getLocation());
    }

    A_POINT.setLocation(conn.getTargetAnchor().getLocation(ref2));
    conn.translateToRelative(A_POINT);
    points.addPoint(A_POINT);
    conn.setPoints(points);
}

/**
 * Sets the constraint for the given {@link Connection}.
 *
 * @param connection The connection whose constraint we are setting
 * @param constraint The constraint
 */
public void setConstraint(Connection connection, Object constraint) {
    constraints.put(cast(Object)connection, constraint);
}

}
