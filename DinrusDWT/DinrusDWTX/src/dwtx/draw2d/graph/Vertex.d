/*******************************************************************************
 * Copyright (c) 2004, 2005 IBM Corporation and others.
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
module dwtx.draw2d.graph.Vertex;

import tango.text.convert.Format;
import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;

import dwtx.draw2d.PositionConstants;
import dwtx.draw2d.geometry.Point;
import dwtx.draw2d.geometry.Rectangle;
import dwtx.draw2d.graph.Obstacle;
import dwtx.draw2d.graph.Path;
import dwtx.draw2d.graph.Segment;

/**
 * A vertex representation for the ShortestPathRouting. Vertices are either one of
 * four corners on an <code>Obstacle</code>(Rectangle), or one of the two end points of a
 * <code>Path</code>.
 *
 * This class is not intended to be subclassed.
 * @author Whitney Sorenson
 * @since 3.0
 */
class Vertex
    : Point
{

// constants for the vertex type
static const int NOT_SET = 0;
static const int INNIE = 1;
static const int OUTIE = 2;

// for shortest path
List neighbors;
bool isPermanent = false;
Vertex label;
double cost = 0;

// for routing
int nearestObstacle = 0;
double offset = 0;
int type = NOT_SET;
int count = 0;
int totalCount = 0;
Obstacle obs;
List paths;
bool nearestObstacleChecked = false;
Map cachedCosines;
int positionOnObstacle = -1;

private int origX, origY;

/**
 * Creates a new Vertex with the given x, y position and on the given obstacle.
 *
 * @param x x point
 * @param y y point
 * @param obs obstacle - can be null
 */
this(int x, int y, Obstacle obs) {
    super(x, y);
    origX = x;
    origY = y;
    this.obs = obs;
}

/**
 * Creates a new Vertex with the given point position and on the given obstacle.
 *
 * @param p the point
 * @param obs obstacle - can be null
 */
this(Point p, Obstacle obs) {
    this(p.x, p.y, obs);
}

/**
 * Adds a path to this vertex, calculates angle between two segments and caches it.
 *
 * @param path the path
 * @param start the segment to this vertex
 * @param end the segment away from this vertex
 */
void addPath(Path path, Segment start, Segment end) {
    if (paths is null) {
        paths = new ArrayList();
        cachedCosines = new HashMap();
    }
    if (!paths.contains(path))
        paths.add(path);
    cachedCosines.put(path, new Double(start.cosine(end)));
}

/**
 * Creates a point that represents this vertex offset by the given amount times
 * the offset.
 *
 * @param modifier the offset
 * @return a Point that has been bent around this vertex
 */
Point bend(int modifier) {
    Point point = new Point(x, y);
    if ((positionOnObstacle & PositionConstants.NORTH) > 0)
        point.y -= modifier * offset;
    else
        point.y += modifier * offset;
    if ((positionOnObstacle & PositionConstants.EAST) > 0)
        point.x += modifier * offset;
    else
        point.x -= modifier * offset;
    return point;
}

/**
 * Resets all fields on this Vertex.
 */
void fullReset() {
    totalCount = 0;
    type = NOT_SET;
    count = 0;
    cost = 0;
    offset = getSpacing();
    nearestObstacle = 0;
    label = null;
    nearestObstacleChecked = false;
    isPermanent = false;
    if (neighbors !is null)
        neighbors.clear();
    if (cachedCosines !is null)
        cachedCosines.clear();
    if (paths !is null)
        paths.clear();
}

/**
 * Returns a Rectangle that represents the region around this vertex that
 * paths will be traveling in.
 *
 * @param extraOffset a buffer to add to the region.
 * @return the rectangle
 */
Rectangle getDeformedRectangle(int extraOffset) {
    Rectangle rect = new Rectangle(0, 0, 0, 0);

    if ((positionOnObstacle & PositionConstants.NORTH) > 0) {
        rect.y = y - extraOffset;
        rect.height = origY - y + extraOffset;
    } else {
        rect.y = origY;
        rect.height = y - origY + extraOffset;
    }
    if ((positionOnObstacle & PositionConstants.EAST) > 0) {
        rect.x = origX;
        rect.width = x - origX + extraOffset;
    } else {
        rect.x = x - extraOffset;
        rect.width = origX - x + extraOffset;
    }

    return rect;
}

private int getSpacing() {
    if (obs is null)
        return 0;
    return obs.getSpacing();
}

/**
 * Grows this vertex by its offset to its maximum size.
 */
void grow() {
    int modifier;

    if (nearestObstacle is 0)
        modifier = totalCount * getSpacing();
    else
        modifier = (nearestObstacle / 2) - 1;

    if ((positionOnObstacle & PositionConstants.NORTH) > 0)
        y -= modifier;
    else
        y += modifier;
    if ((positionOnObstacle & PositionConstants.EAST) > 0)
        x += modifier;
    else
        x -= modifier;
}

/**
 * Shrinks this vertex to its original size.
 */
void shrink() {
    x = origX;
    y = origY;
}

/**
 * Updates the offset of this vertex based on its shortest distance.
 */
void updateOffset() {
    if (nearestObstacle !is 0)
        offset = ((nearestObstacle / 2) - 1) / totalCount;
}

/**
 * @see dwtx.draw2d.geometry.Point#toString()
 */
public String toString() {
    return Format("V({}, {})", origX, origY ); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
}

}
