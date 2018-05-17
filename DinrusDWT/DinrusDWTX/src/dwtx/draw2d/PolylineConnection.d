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
module dwtx.draw2d.PolylineConnection;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;

import dwtx.draw2d.geometry.Point;
import dwtx.draw2d.geometry.Rectangle;
import dwtx.draw2d.geometry.PointList;
import dwtx.draw2d.Polyline;
import dwtx.draw2d.Connection;
import dwtx.draw2d.ConnectionAnchor;
import dwtx.draw2d.AnchorListener;
import dwtx.draw2d.ConnectionRouter;
import dwtx.draw2d.ConnectionLocator;
import dwtx.draw2d.RotatableDecoration;
import dwtx.draw2d.RoutingListener;
import dwtx.draw2d.DelegatingLayout;
import dwtx.draw2d.IFigure;
import dwtx.draw2d.ArrowLocator;

/**
 * An implementation of {@link Connection} based on Polyline.  PolylineConnection adds
 * the following additional features:
 * <UL>
 * <LI>
 *   A {@link ConnectionRouter} may be provided which will be used to determine the
 *   connections points.
 * <LI>
 *   Children may be added. The bounds calculation is extended such that the bounds is
 *   the smallest Rectangle which is large enough to display the Polyline and all of its
 *   children figures.
 * <LI>
 *   A {@link DelegatingLayout} is set as the default layout.  A delegating layout allows
 *   children to position themselves via {@link Locator Locators}.
 * </UL>
 * <P>
 */
public class PolylineConnection
    : Polyline
    , Connection, AnchorListener
{

// reimplement for Connection
PointList getPoints(){
    return super.getPoints();
}
// reimplement for Connection
void setPoints(PointList list){
    super.setPoints(list);
}


private ConnectionAnchor startAnchor, endAnchor;
private ConnectionRouter connectionRouter;
private RotatableDecoration startArrow, endArrow;

private void instanceInit(){
    connectionRouter = ConnectionRouter_NULL;
    setLayoutManager(new DelegatingLayout());
    addPoint(new Point(0, 0));
    addPoint(new Point(100, 100));
}

this(){
    instanceInit();
}
/**
 * Hooks the source and target anchors.
 * @see Figure#addNotify()
 */
public void addNotify() {
    super.addNotify();
    hookSourceAnchor();
    hookTargetAnchor();
}

/**
 * Appends the given routing listener to the list of listeners.
 * @param listener the routing listener
 * @since 3.2
 */
public void addRoutingListener(RoutingListener listener) {
    if (auto notifier = cast(RoutingNotifier)connectionRouter ) {
        notifier.listeners.add(cast(Object)listener);
    } else
        connectionRouter = new RoutingNotifier(connectionRouter, listener);
}

/**
 * Called by the anchors of this connection when they have moved, revalidating this
 * polyline connection.
 * @param anchor the anchor that moved
 */
public void anchorMoved(ConnectionAnchor anchor) {
    revalidate();
}

/**
 * Returns the bounds which holds all the points in this polyline connection. Returns any
 * previously existing bounds, else calculates by unioning all the children's
 * dimensions.
 * @return the bounds
 */
public Rectangle getBounds() {
    if (bounds is null) {
        super.getBounds();
        for (int i = 0; i < getChildren().size(); i++) {
            IFigure child = cast(IFigure)getChildren().get(i);
            bounds.union_(child.getBounds());
        }
    }
    return bounds;
}

/**
 * Returns the <code>ConnectionRouter</code> used to layout this connection. Will not
 * return <code>null</code>.
 * @return this connection's router
 */
public ConnectionRouter getConnectionRouter() {
    if (auto n = cast(RoutingNotifier)connectionRouter )
        return n.realRouter;
    return connectionRouter;
}

/**
 * Returns this connection's routing constraint from its connection router.  May return
 * <code>null</code>.
 * @return the connection's routing constraint
 */
public Object getRoutingConstraint() {
    if (getConnectionRouter() !is null)
        return getConnectionRouter().getConstraint(this);
    else
        return null;
}

/**
 * @return the anchor at the start of this polyline connection (may be null)
 */
public ConnectionAnchor getSourceAnchor() {
    return startAnchor;
}

/**
 * @return the source decoration (may be null)
 */
protected RotatableDecoration getSourceDecoration() {
    return startArrow;
}

/**
 * @return the anchor at the end of this polyline connection (may be null)
 */
public ConnectionAnchor getTargetAnchor() {
    return endAnchor;
}

/**
 * @return the target decoration (may be null)
 *
 * @since 2.0
 */
protected RotatableDecoration getTargetDecoration() {
    return endArrow;
}

private void hookSourceAnchor() {
    if (getSourceAnchor() !is null)
        getSourceAnchor().addAnchorListener(this);
}

private void hookTargetAnchor() {
    if (getTargetAnchor() !is null)
        getTargetAnchor().addAnchorListener(this);
}

/**
 * Layouts this polyline. If the start and end anchors are present, the connection router
 * is used to route this, after which it is laid out. It also fires a moved method.
 */
public void layout() {
    if (getSourceAnchor() !is null && getTargetAnchor() !is null)
        connectionRouter.route(this);

    Rectangle oldBounds = bounds;
    super.layout();
    bounds = null;

    if (!getBounds().contains(oldBounds)) {
        getParent().translateToParent(oldBounds);
        getUpdateManager().addDirtyRegion(getParent(), oldBounds);
    }

    repaint();
    fireFigureMoved();
}

/**
 * Called just before the receiver is being removed from its parent. Results in removing
 * itself from the connection router.
 *
 * @since 2.0
 */
public void removeNotify() {
    unhookSourceAnchor();
    unhookTargetAnchor();
    connectionRouter.remove(this);
    super.removeNotify();
}

/**
 * Removes the first occurence of the given listener.
 * @param listener the listener being removed
 * @since 3.2
 */
public void removeRoutingListener(RoutingListener listener) {
    if ( auto notifier = cast(RoutingNotifier)connectionRouter ) {
        notifier.listeners.remove(cast(Object)listener);
        if (notifier.listeners.isEmpty())
            connectionRouter = notifier.realRouter;
    }
}

/**
 * @see IFigure#revalidate()
 */
public void revalidate() {
    super.revalidate();
    connectionRouter.invalidate(this);
}

/**
 * Sets the connection router which handles the layout of this polyline. Generally set by
 * the parent handling the polyline connection.
 * @param cr the connection router
 */
public void setConnectionRouter(ConnectionRouter cr) {
    if (cr is null)
        cr = ConnectionRouter_NULL;
    ConnectionRouter oldRouter = getConnectionRouter();
    if (oldRouter !is cr) {
        connectionRouter.remove(this);
        if (auto n = cast(RoutingNotifier)connectionRouter )
            n.realRouter = cr;
        else
            connectionRouter = cr;
        firePropertyChange(Connection.PROPERTY_CONNECTION_ROUTER, cast(Object)oldRouter, cast(Object)cr);
        revalidate();
    }
}

/**
 * Sets the routing constraint for this connection.
 * @param cons the constraint
 */
public void setRoutingConstraint(Object cons) {
    if (connectionRouter !is null)
        connectionRouter.setConstraint(this, cons);
    revalidate();
}

/**
 * Sets the anchor to be used at the start of this polyline connection.
 * @param anchor the new source anchor
 */
public void setSourceAnchor(ConnectionAnchor anchor) {
    if (anchor is startAnchor)
        return;
    unhookSourceAnchor();
    //No longer needed, revalidate does this.
    //getConnectionRouter().invalidate(this);
    startAnchor = anchor;
    if (getParent() !is null)
        hookSourceAnchor();
    revalidate();
}

/**
 * Sets the decoration to be used at the start of the {@link Connection}.
 * @param dec the new source decoration
 * @since 2.0
 */
public void setSourceDecoration(RotatableDecoration dec) {
    if (startArrow is dec)
        return;
    if (startArrow !is null)
        remove(startArrow);
    startArrow = dec;
    if (startArrow !is null)
        add(startArrow, new ArrowLocator(this, ConnectionLocator.SOURCE));
}

/**
 * Sets the anchor to be used at the end of the polyline connection. Removes this listener
 * from the old anchor and adds it to the new anchor.
 * @param anchor the new target anchor
 */
public void setTargetAnchor(ConnectionAnchor anchor) {
    if (anchor is endAnchor)
        return;
    unhookTargetAnchor();
    //No longer needed, revalidate does this.
    //getConnectionRouter().invalidate(this);
    endAnchor = anchor;
    if (getParent() !is null)
        hookTargetAnchor();
    revalidate();
}

/**
 * Sets the decoration to be used at the end of the {@link Connection}.
 * @param dec the new target decoration
 */
public void setTargetDecoration(RotatableDecoration dec) {
    if (endArrow is dec)
        return;
    if (endArrow !is null)
        remove(endArrow);
    endArrow = dec;
    if (endArrow !is null)
        add(endArrow, new ArrowLocator(this, ConnectionLocator.TARGET));
}

private void unhookSourceAnchor() {
    if (getSourceAnchor() !is null)
        getSourceAnchor().removeAnchorListener(this);
}

private void unhookTargetAnchor() {
    if (getTargetAnchor() !is null)
        getTargetAnchor().removeAnchorListener(this);
}

final class RoutingNotifier : ConnectionRouter {

    ConnectionRouter realRouter;
    List listeners;

    this(ConnectionRouter router, RoutingListener listener) {
        listeners = new ArrayList(1);
        realRouter = router;
        listeners.add(cast(Object)listener);
    }

    public Object getConstraint(Connection connection) {
        return realRouter.getConstraint(connection);
    }

    public void invalidate(Connection connection) {
        for (int i = 0; i < listeners.size(); i++)
            (cast(RoutingListener)listeners.get(i)).invalidate(connection);

        realRouter.invalidate(connection);
    }

    public void route(Connection connection) {
        bool consumed = false;
        for (int i = 0; i < listeners.size(); i++)
            consumed |= (cast(RoutingListener)listeners.get(i)).route(connection);

        if (!consumed)
            realRouter.route(connection);

        for (int i = 0; i < listeners.size(); i++)
            (cast(RoutingListener)listeners.get(i)).postRoute(connection);
    }

    public void remove(Connection connection) {
        for (int i = 0; i < listeners.size(); i++)
            (cast(RoutingListener)listeners.get(i)).remove(connection);
        realRouter.remove(connection);
    }

    public void setConstraint(Connection connection, Object constraint) {
        for (int i = 0; i < listeners.size(); i++)
            (cast(RoutingListener)listeners.get(i)).setConstraint(connection, constraint);
        realRouter.setConstraint(connection, constraint);
    }

}

}
