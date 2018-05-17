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
module dwtx.draw2d.AutomaticRouter;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;

import dwtx.draw2d.geometry.Point;
import dwtx.draw2d.geometry.PointList;
import dwtx.draw2d.internal.MultiValueMap;
import dwtx.draw2d.AbstractRouter;
import dwtx.draw2d.ConnectionRouter;
import dwtx.draw2d.ConnectionAnchor;
import dwtx.draw2d.Connection;

/**
 * An abstract router implementation which detects when multiple connections are
 * overlapping. Two connections overlap if the combination of source and target
 * anchors are equal. Subclasses must implement {@link #handleCollision(PointList, int)}
 * to determine how to avoid the overlap.
 * <p>
 * This router can delegate to another connection router. The wrappered router will route
 * the connections first, after which overlapping will be determined.
 */
public abstract class AutomaticRouter
    : AbstractRouter
{

private ConnectionRouter nextRouter;
private MultiValueMap connections;

public this(){
    connections = new MultiValueMap();
}

private class HashKey {

    private ConnectionAnchor anchor1, anchor2;

    this(Connection conn) {
        anchor1 = conn.getSourceAnchor();
        anchor2 = conn.getTargetAnchor();
    }

    public override int opEquals(Object object) {
        bool isEqual = false;
        HashKey hashKey;

        if (auto hashKey = cast(HashKey)object ) {
            ConnectionAnchor hkA1 = hashKey.getFirstAnchor();
            ConnectionAnchor hkA2 = hashKey.getSecondAnchor();

            isEqual = ((cast(Object)hkA1).opEquals(cast(Object)anchor1) && (cast(Object)hkA2).opEquals(cast(Object)anchor2))
                || ((cast(Object)hkA1).opEquals(cast(Object)anchor2) && (cast(Object)hkA2).opEquals(cast(Object)anchor1));
        }
        return isEqual;
    }

    public ConnectionAnchor getFirstAnchor() {
        return anchor1;
    }

    public ConnectionAnchor getSecondAnchor() {
        return anchor2;
    }

    public override hash_t toHash() {
        return (cast(Object)anchor1).toHash() ^ (cast(Object)anchor2).toHash();
    }
}

/**
 * @see dwtx.draw2d.ConnectionRouter#getConstraint(Connection)
 */
public Object getConstraint(Connection connection) {
    if (next() !is null)
        return next().getConstraint(connection);
    return null;
}

/**
 * Handles collisions between 2 or more Connections. Collisions are currently defined as 2
 * connections with no bendpoints and whose start and end points coincide.  In other
 * words, the 2 connections are the exact same line.
 *
 * @param list The PointList of a connection that collides with another connection
 * @param index The index of the current connection in the list of colliding connections
 */
protected abstract void handleCollision(PointList list, int index);

/**
 * @see dwtx.draw2d.ConnectionRouter#invalidate(Connection)
 */
public void invalidate(Connection conn) {
    if (next() !is null)
        next().invalidate(conn);
    if (conn.getSourceAnchor() is null || conn.getTargetAnchor() is null)
        return;
    HashKey connectionKey = new HashKey(conn);
    ArrayList connectionList = connections.get(connectionKey);
    int affected = connections.remove(connectionKey, cast(Object)conn);
    if (affected !is -1) {
        for (int i = affected; i < connectionList.size(); i++)
            (cast(Connection)connectionList.get(i)).revalidate();
    } else
        connections.removeValue(cast(Object)conn);

}

/**
 * Returns the next router in the chain.
 * @return The next router
 * @since 2.0
 */
protected ConnectionRouter next() {
    return nextRouter;
}



/**
 * @see dwtx.draw2d.ConnectionRouter#remove(Connection)
 */
public void remove(Connection conn) {
    if (conn.getSourceAnchor() is null || conn.getTargetAnchor() is null)
        return;
    HashKey connectionKey = new HashKey(conn);
    ArrayList connectionList = connections.get(connectionKey);
    if (connectionList !is null) {
        int index = connections.remove(connectionKey,cast(Object) conn);
        for (int i = index + 1; i < connectionList.size(); i++)
            (cast(Connection)connectionList.get(i)).revalidate();
    }
    if (next() !is null)
        next().remove(conn);
}

/**
 * Routes the given connection.  Calls the 'next' router first (if one exists) and if no
 * bendpoints were added by the next router, collisions are dealt with by calling
 * {@link #handleCollision(PointList, int)}.
 * @param conn The connection to route
 */
public void route(Connection conn) {
    if (next() !is null)
        next().route(conn);
    else {
        conn.getPoints().removeAllPoints();
        setEndPoints(conn);
    }

    if (conn.getPoints().size() is 2) {
        PointList points = conn.getPoints();
        HashKey connectionKey = new HashKey(conn);
        ArrayList connectionList = connections.get(connectionKey);

        if (connectionList !is null) {

            int index;

            if (connectionList.contains(cast(Object)conn)) {
                index = connectionList.indexOf(cast(Object)conn) + 1;
            } else {
                index = connectionList.size() + 1;
                connections.put(connectionKey, cast(Object)conn);
            }

            handleCollision(points, index);
            conn.setPoints(points);
        } else {
            connections.put(connectionKey, cast(Object)conn);
        }
    }
}

/**
 * An AutomaticRouter needs no constraints for the connections it routes.  This method
 * invalidates the connections and calls {@link #setConstraint(Connection, Object)} on the
 * {@link #next()} router.
 * @see dwtx.draw2d.ConnectionRouter#setConstraint(Connection, Object)
 */
public void setConstraint(Connection connection, Object constraint) {
    invalidate(connection);
    if (next() !is null)
        next().setConstraint(connection, constraint);
}

/**
 * Sets the start and end points for the given connection.
 * @param conn The connection
 */
protected void setEndPoints(Connection conn) {
    PointList points = conn.getPoints();
    points.removeAllPoints();
    Point start = getStartPoint(conn);
    Point end = getEndPoint(conn);
    conn.translateToRelative(start);
    conn.translateToRelative(end);
    points.addPoint(start);
    points.addPoint(end);
    conn.setPoints(points);
}

/**
 * Sets the next router.
 * @param router The ConnectionRouter
 * @since 2.0
 */
public void setNextRouter(ConnectionRouter router) {
    nextRouter = router;
}

}
