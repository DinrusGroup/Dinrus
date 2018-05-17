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
module dwtx.draw2d.ShortestPathConnectionRouter;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;

import dwtx.draw2d.geometry.Point;
import dwtx.draw2d.geometry.PointList;
import dwtx.draw2d.geometry.PrecisionPoint;
import dwtx.draw2d.geometry.Rectangle;
import dwtx.draw2d.graph.Path;
import dwtx.draw2d.graph.ShortestPathRouter;
import dwtx.draw2d.AbstractRouter;
import dwtx.draw2d.IFigure;
import dwtx.draw2d.LayoutListener;
import dwtx.draw2d.FigureListener;
import dwtx.draw2d.Connection;
import dwtx.draw2d.Bendpoint;

/**
 * Routes multiple connections around the children of a given container figure.
 * @author Whitney Sorenson
 * @author Randy Hudson
 * @since 3.1
 */
public final class ShortestPathConnectionRouter
    : AbstractRouter
{

private class LayoutTracker : LayoutListenerStub {
    public void postLayout(IFigure container) {
        processLayout();
    }
    public void remove(IFigure child) {
        removeChild(child);
    }
    public void setConstraint(IFigure child, Object constraint) {
        addChild(child);
    }
}

private Map constraintMap;
private Map figuresToBounds;
private Map connectionToPaths;
private bool isDirty;
private ShortestPathRouter algorithm;
private IFigure container;
private Set staleConnections;
private LayoutListener listener;

private FigureListener figureListener;
private void initFigureListener(){
    figureListener = new class() FigureListener {
        public void figureMoved(IFigure source) {
            Rectangle newBounds = source.getBounds().getCopy();
            if (algorithm.updateObstacle(cast(Rectangle)figuresToBounds.get(cast(Object)source), newBounds)) {
                queueSomeRouting();
                isDirty = true;
            }

            figuresToBounds.put(cast(Object)source, newBounds);
        }
    };
}
private bool ignoreInvalidate;

/**
 * Creates a new shortest path router with the given container. The container
 * contains all the figure's which will be treated as obstacles for the connections to
 * avoid. Any time a child of the container moves, one or more connections will be
 * revalidated to process the new obstacle locations. The connections being routed must
 * not be contained within the container.
 *
 * @param container the container
 */
public this(IFigure container) {
    initFigureListener();
    constraintMap = new HashMap();
    algorithm = new ShortestPathRouter();
    staleConnections = new HashSet();
    listener = new LayoutTracker();
    isDirty = false;
    algorithm = new ShortestPathRouter();
    this.container = container;
}

void addChild(IFigure child) {
    if (connectionToPaths is null)
        return;
    if (figuresToBounds.containsKey(cast(Object)child))
        return;
    Rectangle bounds = child.getBounds().getCopy();
    algorithm.addObstacle(bounds);
    figuresToBounds.put(cast(Object)child, bounds);
    child.addFigureListener(figureListener);
    isDirty = true;
}

private void hookAll() {
    figuresToBounds = new HashMap();
    for (int i = 0; i < container.getChildren().size(); i++)
        addChild(cast(IFigure)container.getChildren().get(i));
    container.addLayoutListener(listener);
}

private void unhookAll() {
    container.removeLayoutListener(listener);
    if (figuresToBounds !is null) {
        Iterator figureItr = figuresToBounds.keySet().iterator();
        while (figureItr.hasNext()) {
            //Must use iterator's remove to avoid concurrent modification
            IFigure child = cast(IFigure)figureItr.next();
            figureItr.remove();
            removeChild(child);
        }
        figuresToBounds = null;
    }
}

/**
 * Gets the constraint for the given {@link Connection}.  The constraint is the paths
 * list of bend points for this connection.
 *
 * @param connection The connection whose constraint we are retrieving
 * @return The constraint
 */
public Object getConstraint(Connection connection) {
    return constraintMap.get(cast(Object)connection);
}

/**
 * Returns the default spacing maintained on either side of a connection. The default
 * value is 4.
 * @return the connection spacing
 * @since 3.2
 */
public int getSpacing() {
    return algorithm.getSpacing();
}

/**
 * @see ConnectionRouter#invalidate(Connection)
 */
public void invalidate(Connection connection) {
    if (ignoreInvalidate)
        return;
    staleConnections.add(cast(Object)connection);
    isDirty = true;
}

private void processLayout() {
    if (staleConnections.isEmpty())
        return;
    (cast(Connection)staleConnections.iterator().next()).revalidate();
}

private void processStaleConnections() {
    Iterator iter = staleConnections.iterator();
    if (iter.hasNext() && connectionToPaths is null) {
        connectionToPaths = new HashMap();
        hookAll();
    }

    while (iter.hasNext()) {
        Connection conn = cast(Connection)iter.next();

        Path path = cast(Path)connectionToPaths.get(cast(Object)conn);
        if (path is null) {
            path = new Path(cast(Object)conn);
            connectionToPaths.put(cast(Object)conn, path);
            algorithm.addPath(path);
        }

        List constraint = cast(List)getConstraint(conn);
        if (constraint is null)
            constraint = Collections.EMPTY_LIST;

        Point start = conn.getSourceAnchor().getReferencePoint().getCopy();
        Point end = conn.getTargetAnchor().getReferencePoint().getCopy();

        container.translateToRelative(start);
        container.translateToRelative(end);

        path.setStartPoint(start);
        path.setEndPoint(end);

        if (!constraint.isEmpty()) {
            PointList bends = new PointList(constraint.size());
            for (int i = 0; i < constraint.size(); i++) {
                Bendpoint bp = cast(Bendpoint)constraint.get(i);
                bends.addPoint(bp.getLocation());
            }
            path.setBendPoints(bends);
        } else
            path.setBendPoints(null);

        isDirty |= path.isDirty;
    }
    staleConnections.clear();
}

void queueSomeRouting() {
    if (connectionToPaths is null || connectionToPaths.isEmpty())
        return;
    try {
        ignoreInvalidate = true;
        (cast(Connection)connectionToPaths.keySet().iterator().next())
            .revalidate();
    } finally {
        ignoreInvalidate = false;
    }
}

/**
 * @see ConnectionRouter#remove(Connection)
 */
public void remove(Connection connection) {
    staleConnections.remove(cast(Object)connection);
    constraintMap.remove(cast(Object)connection);
    if (connectionToPaths is null)
        return;
    Path path = cast(Path)connectionToPaths.remove(cast(Object)connection);
    algorithm.removePath(path);
    isDirty = true;
    if (connectionToPaths.isEmpty()) {
        unhookAll();
        connectionToPaths = null;
    } else {
        //Make sure one of the remaining is revalidated so that we can re-route again.
        queueSomeRouting();
    }
}

void removeChild(IFigure child) {
    if (connectionToPaths is null)
        return;
    Rectangle bounds = child.getBounds().getCopy();
    bool change = algorithm.removeObstacle(bounds);
    figuresToBounds.remove(cast(Object)child);
    child.removeFigureListener(figureListener);
    if (change) {
        isDirty = true;
        queueSomeRouting();
    }
}

/**
 * @see ConnectionRouter#route(Connection)
 */
public void route(Connection conn) {
    if (isDirty) {
        ignoreInvalidate = true;
        processStaleConnections();
        isDirty = false;
        List updated = algorithm.solve();
        Connection current;
        for (int i = 0; i < updated.size(); i++) {
            Path path = cast(Path) updated.get(i);
            current = cast(Connection)path.data;
            current.revalidate();

            PointList points = path.getPoints().getCopy();
            Point ref1, ref2, start, end;
            ref1 = new PrecisionPoint(points.getPoint(1));
            ref2 = new PrecisionPoint(points.getPoint(points.size() - 2));
            current.translateToAbsolute(ref1);
            current.translateToAbsolute(ref2);

            start = current.getSourceAnchor().getLocation(ref1).getCopy();
            end = current.getTargetAnchor().getLocation(ref2).getCopy();

            current.translateToRelative(start);
            current.translateToRelative(end);
            points.setPoint(start, 0);
            points.setPoint(end, points.size() - 1);

            current.setPoints(points);
        }
        ignoreInvalidate = false;
    }
}

/**
 * @see ConnectionRouter#setConstraint(Connection, Object)
 */
public void setConstraint(Connection connection, Object constraint) {
    //Connection.setConstraint() already calls revalidate, so we know that a
    // route() call will follow.
    staleConnections.add(cast(Object)connection);
    constraintMap.put(cast(Object)connection, constraint);
    isDirty = true;
}

/**
 * Sets the default space that should be maintained on either side of a connection. This
 * causes the connections to be separated from each other and from the obstacles. The
 * default value is 4.
 *
 * @param spacing the connection spacing
 * @since 3.2
 */
public void setSpacing(int spacing) {
    algorithm.setSpacing(spacing);
}

}
