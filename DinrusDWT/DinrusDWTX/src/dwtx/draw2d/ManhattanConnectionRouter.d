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
module dwtx.draw2d.ManhattanConnectionRouter;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;

import dwtx.draw2d.geometry.Point;
import dwtx.draw2d.geometry.PointList;
import dwtx.draw2d.geometry.Ray;
import dwtx.draw2d.geometry.Rectangle;
import dwtx.draw2d.AbstractRouter;
import dwtx.draw2d.Connection;
import dwtx.draw2d.ConnectionAnchor;

/**
 * Provides a {@link Connection} with an orthogonal route between the Connection's source
 * and target anchors.
 */
public final class ManhattanConnectionRouter
    : AbstractRouter
{

private Map rowsUsed;
private Map colsUsed;
//private Hashtable offsets = new Hashtable(7);

private Map reservedInfo;

private class ReservedInfo {
    public List reservedRows;
    public List reservedCols;
    this(){
        reservedRows = new ArrayList(2);
        reservedCols = new ArrayList(2);
    }
}

private static Ray  UP_, DOWN_, LEFT_, RIGHT_;
private static Ray UP(){
    if( !initStaticCtor_done ) initStaticCtor();
    assert(UP_);
    return UP_;
}
private static Ray DOWN(){
    if( !initStaticCtor_done ) initStaticCtor();
    assert(DOWN_);
    return DOWN_;
}
private static Ray LEFT(){
    if( !initStaticCtor_done ) initStaticCtor();
    assert(LEFT_);
    return LEFT_;
}
private static Ray RIGHT(){
    if( !initStaticCtor_done ) initStaticCtor();
    assert(RIGHT_);
    return RIGHT_;
}

private static bool initStaticCtor_done = false;
private static void initStaticCtor(){
    synchronized( ManhattanConnectionRouter.classinfo ){
        if( !initStaticCtor_done ){
            UP_      = new Ray(0, -1);
            DOWN_    = new Ray(0, 1);
            LEFT_    = new Ray(-1, 0);
            RIGHT_   = new Ray(1, 0);
            initStaticCtor_done = true;
        }
    }
}



public this(){
    rowsUsed = new HashMap();
    colsUsed = new HashMap();
    reservedInfo = new HashMap();
}

/**
 * @see ConnectionRouter#invalidate(Connection)
 */
public void invalidate(Connection connection) {
    removeReservedLines(connection);
}

private int getColumnNear(Connection connection, int r, int n, int x) {
    int min = Math.min(n, x),
        max = Math.max(n, x);
    if (min > r) {
        max = min;
        min = r - (min - r);
    }
    if (max < r) {
        min = max;
        max = r + (r - max);
    }
    int proximity = 0;
    int direction = -1;
    if (r % 2 is 1)
        r--;
    Integer i;
    while (proximity < r) {
        i = new Integer(r + proximity * direction);
        if (!colsUsed.containsKey(i)) {
            colsUsed.put(i, i);
            reserveColumn(connection, i);
            return i.intValue();
        }
        int j = i.intValue();
        if (j <= min)
            return j + 2;
        if (j >= max)
            return j - 2;
        if (direction is 1)
            direction = -1;
        else {
            direction = 1;
            proximity += 2;
        }
    }
    return r;
}

/**
 * Returns the direction the point <i>p</i> is in relation to the given rectangle.
 * Possible values are LEFT (-1,0), RIGHT (1,0), UP (0,-1) and DOWN (0,1).
 *
 * @param r the rectangle
 * @param p the point
 * @return the direction from <i>r</i> to <i>p</i>
 */
protected Ray getDirection(Rectangle r, Point p) {
    int i, distance = Math.abs(r.x - p.x);
    Ray direction;

    direction = LEFT;

    i = Math.abs(r.y - p.y);
    if (i <= distance) {
        distance = i;
        direction = UP;
    }

    i = Math.abs(r.bottom() - p.y);
    if (i <= distance) {
        distance = i;
        direction = DOWN;
    }

    i = Math.abs(r.right() - p.x);
    if (i < distance) {
        distance = i;
        direction = RIGHT;
    }

    return direction;
}

protected Ray getEndDirection(Connection conn) {
    ConnectionAnchor anchor = conn.getTargetAnchor();
    Point p = getEndPoint(conn);
    Rectangle rect;
    if (anchor.getOwner() is null)
        rect = new Rectangle(p.x - 1, p.y - 1, 2, 2);
    else {
        rect = conn.getTargetAnchor().getOwner().getBounds().getCopy();
        conn.getTargetAnchor().getOwner().translateToAbsolute(rect);
    }
    return getDirection(rect, p);
}

protected int getRowNear(Connection connection, int r, int n, int x) {
    int min = Math.min(n, x),
        max = Math.max(n, x);
    if (min > r) {
        max = min;
        min = r - (min - r);
    }
    if (max < r) {
        min = max;
        max = r + (r - max);
    }

    int proximity = 0;
    int direction = -1;
    if (r % 2 is 1)
        r--;
    Integer i;
    while (proximity < r) {
        i = new Integer(r + proximity * direction);
        if (!rowsUsed.containsKey(i)) {
            rowsUsed.put(i, i);
            reserveRow(connection, i);
            return i.intValue();
        }
        int j = i.intValue();
        if (j <= min)
            return j + 2;
        if (j >= max)
            return j - 2;
        if (direction is 1)
            direction = -1;
        else {
            direction = 1;
            proximity += 2;
        }
    }
    return r;
}

protected Ray getStartDirection(Connection conn) {
    ConnectionAnchor anchor = conn.getSourceAnchor();
    Point p = getStartPoint(conn);
    Rectangle rect;
    if (anchor.getOwner() is null)
        rect = new Rectangle(p.x - 1, p.y - 1, 2, 2);
    else {
        rect = conn.getSourceAnchor().getOwner().getBounds().getCopy();
        conn.getSourceAnchor().getOwner().translateToAbsolute(rect);
    }
    return getDirection(rect, p);
}

protected void processPositions(Ray start, Ray end, List positions,
                                bool horizontal, Connection conn) {
    removeReservedLines(conn);

    int pos[] = new int[positions.size() + 2];
    if (horizontal)
        pos[0] = start.x;
    else
        pos[0] = start.y;
    int i;
    for (i = 0; i < positions.size(); i++) {
        pos[i + 1] = (cast(Integer)positions.get(i)).intValue();
    }
    if (horizontal is (positions.size() % 2 is 1))
        pos[++i] = end.x;
    else
        pos[++i] = end.y;

    PointList points = new PointList();
    points.addPoint(new Point(start.x, start.y));
    Point p;
    int current, prev, min, max;
    bool adjust;
    for (i = 2; i < pos.length - 1; i++) {
        horizontal = !horizontal;
        prev = pos[i - 1];
        current = pos[i];

        adjust = (i !is pos.length - 2);
        if (horizontal) {
            if (adjust) {
                min = pos[i - 2];
                max = pos[i + 2];
                pos[i] = current = getRowNear(conn, current, min, max);
            }
            p = new Point(prev, current);
        } else {
            if (adjust) {
                min = pos[i - 2];
                max = pos[i + 2];
                pos[i] = current = getColumnNear(conn, current, min, max);
            }
            p = new Point(current, prev);
        }
        points.addPoint(p);
    }
    points.addPoint(new Point(end.x, end.y));
    conn.setPoints(points);
}

/**
 * @see ConnectionRouter#remove(Connection)
 */
public void remove(Connection connection) {
    removeReservedLines(connection);
}

protected void removeReservedLines(Connection connection) {
    ReservedInfo rInfo = cast(ReservedInfo) reservedInfo.get(cast(Object)connection);
    if (rInfo is null)
        return;

    for (int i = 0; i < rInfo.reservedRows.size(); i++) {
        rowsUsed.remove(rInfo.reservedRows.get(i));
    }
    for (int i = 0; i < rInfo.reservedCols.size(); i++) {
        colsUsed.remove(rInfo.reservedCols.get(i));
    }
    reservedInfo.remove(cast(Object)connection);
}

protected void reserveColumn(Connection connection, Integer column) {
    ReservedInfo info = cast(ReservedInfo) reservedInfo.get(cast(Object)connection);
    if (info is null) {
        info = new ReservedInfo();
        reservedInfo.put(cast(Object)connection, info);
    }
    info.reservedCols.add(column);
}

protected void reserveRow(Connection connection, Integer row) {
    ReservedInfo info = cast(ReservedInfo) reservedInfo.get(cast(Object)connection);
    if (info is null) {
        info = new ReservedInfo();
        reservedInfo.put(cast(Object)connection, info);
    }
    info.reservedRows.add(row);
}

/**
 * @see ConnectionRouter#route(Connection)
 */
public void route(Connection conn) {
    if ((conn.getSourceAnchor() is null) || (conn.getTargetAnchor() is null))
        return;
    int i;
    Point startPoint = getStartPoint(conn);
    conn.translateToRelative(startPoint);
    Point endPoint = getEndPoint(conn);
    conn.translateToRelative(endPoint);

    Ray start = new Ray(startPoint);
    Ray end = new Ray(endPoint);
    Ray average = start.getAveraged(end);

    Ray direction = new Ray(start, end);
    Ray startNormal = getStartDirection(conn);
    Ray endNormal   = getEndDirection(conn);

    List positions = new ArrayList(5);
    bool horizontal = startNormal.isHorizontal();
    if (horizontal)
        positions.add(new Integer(start.y));
    else
        positions.add(new Integer(start.x));
    horizontal = !horizontal;

    if (startNormal.dotProduct(endNormal) is 0) {
        if ((startNormal.dotProduct(direction) >= 0)
            && (endNormal.dotProduct(direction) <= 0)) {
            // 0
        } else {
            // 2
            if (startNormal.dotProduct(direction) < 0)
                i = startNormal.similarity(start.getAdded(startNormal.getScaled(10)));
            else {
                if (horizontal)
                    i = average.y;
                else
                    i = average.x;
            }
            positions.add(new Integer(i));
            horizontal = !horizontal;

            if (endNormal.dotProduct(direction) > 0)
                i = endNormal.similarity(end.getAdded(endNormal.getScaled(10)));
            else {
                if (horizontal)
                    i = average.y;
                else
                    i = average.x;
            }
            positions.add(new Integer(i));
            horizontal = !horizontal;
        }
    } else {
        if (startNormal.dotProduct(endNormal) > 0) {
            //1
            if (startNormal.dotProduct(direction) >= 0)
                i = startNormal.similarity(start.getAdded(startNormal.getScaled(10)));
            else
                i = endNormal.similarity(end.getAdded(endNormal.getScaled(10)));
            positions.add(new Integer(i));
            horizontal = !horizontal;
        } else {
            //3 or 1
            if (startNormal.dotProduct(direction) < 0) {
                i = startNormal.similarity(start.getAdded(startNormal.getScaled(10)));
                positions.add(new Integer(i));
                horizontal = !horizontal;
            }

            if (horizontal)
                i = average.y;
            else
                i = average.x;
            positions.add(new Integer(i));
            horizontal = !horizontal;

            if (startNormal.dotProduct(direction) < 0) {
                i = endNormal.similarity(end.getAdded(endNormal.getScaled(10)));
                positions.add(new Integer(i));
                horizontal = !horizontal;
            }
        }
    }
    if (horizontal)
        positions.add(new Integer(end.y));
    else
        positions.add(new Integer(end.x));

    processPositions(start, end, positions, startNormal.isHorizontal(), conn);
}

}
