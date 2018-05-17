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
module dwtx.draw2d.ConnectionRouter;

import dwt.dwthelper.utils;

import dwtx.draw2d.geometry.Point;
import dwtx.draw2d.geometry.PointList;
import dwtx.draw2d.AnchorListener;
import dwtx.draw2d.AbstractRouter;
import dwtx.draw2d.Connection;

/**
 * Routes a {@link Connection}, possibly using a constraint.
 */
public interface ConnectionRouter {

/**
 * Returns the constraint for the Connection.
 * @param connection The connection
 * @return The constraint
 */
Object getConstraint(Connection connection);

/**
 * Invalidates the given Connection.
 * @param connection The connection to be invalidated
 */
void invalidate(Connection connection);

/**
 * Routes the Connection.
 * @param connection The Connection to route
 */
void route(Connection connection);

/**
 * Removes the Connection from this router.
 * @param connection The Connection to remove
 */
void remove(Connection connection);

/**
 * Maps the given constraint to the given Connection.
 * @param connection The Connection
 * @param constraint The constraint
 */
void setConstraint(Connection connection, Object constraint);


}
/**
 * Routes Connections directly from the source anchor to the target anchor with no
 * bendpoints in between.
 */
class NullConnectionRouter
    : AbstractRouter
{

    /**
     * Constructs a new NullConnectionRouter.
     */
    this() { }

    /**
     * Routes the given Connection directly between the source and target anchors.
     * @param conn the connection to be routed
     */
    public void route(Connection conn) {
        PointList points = conn.getPoints();
        points.removeAllPoints();
        Point p;
        conn.translateToRelative(p = getStartPoint(conn));
        points.addPoint(p);
        conn.translateToRelative(p = getEndPoint(conn));
        points.addPoint(p);
        conn.setPoints(points);
    }
}


/**
 * The default router for Connections.
 */
private static NullConnectionRouter ConnectionRouter_NULL_;
public static NullConnectionRouter ConnectionRouter_NULL(){
    if( ConnectionRouter_NULL_ is null ){
        synchronized( NullConnectionRouter.classinfo ){
            if( ConnectionRouter_NULL_ is null ){
                ConnectionRouter_NULL_ = new NullConnectionRouter();
            }
        }
    }
    return ConnectionRouter_NULL_;
}


