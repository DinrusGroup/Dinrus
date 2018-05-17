/*******************************************************************************
 * Copyright (c) 2000, 2008 IBM Corporation and others.
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
module dwtx.draw2d.DeferredUpdateManager;

import dwt.dwthelper.utils;
import dwt.dwthelper.Runnable;
import dwtx.dwtxhelper.Collection;

import dwt.DWT;
import dwt.DWTException;
import dwt.graphics.GC;
import dwt.widgets.Display;
import dwtx.draw2d.geometry.Rectangle;
import dwtx.draw2d.UpdateManager;
import dwtx.draw2d.GraphicsSource;
import dwtx.draw2d.Graphics;
import dwtx.draw2d.IFigure;
import dwtx.draw2d.SWTGraphics;

/**
 * An UpdateManager that asynchronously updates the affected figures.
 */
public class DeferredUpdateManager
    : UpdateManager
{
alias UpdateManager.addDirtyRegion addDirtyRegion;

/**
 * Calls {@link DeferredUpdateManager#performUpdate()}.
 */
protected class UpdateRequest
    : Runnable
{
    /**
     * Calls {@link DeferredUpdateManager#performUpdate()}.
     */
    public void run() {
        performUpdate();
    }
}
private Rectangle damage;
private Map dirtyRegions;

private GraphicsSource graphicsSource;
private List invalidFigures;
private IFigure root;
private bool updateQueued;

private bool updating;
private bool validating;
private RunnableChain afterUpdate;

private static class RunnableChain {
    RunnableChain next;
    Runnable run_;

    this(Runnable run_, RunnableChain next) {
        this.run_ = run_;
        this.next = next;
    }

    void run() {
        if (next !is null)
            next.run();
        run_.run();
    }
}

/**
 * Empty constructor.
 */
public this() {
    invalidFigures = new ArrayList();
    dirtyRegions = new HashMap();
}

/**
 * Constructs a new DererredUpdateManager with the given GraphicsSource.
 * @param gs the graphics source
 */
public this(GraphicsSource gs) {
    this();
    setGraphicsSource(gs);
}

/**
 * Adds a dirty region (defined by the rectangle <i>x, y, w, h</i>) to the update queue.
 * If the figure isn't visible or either the width or height are 0, the method returns
 * without queueing the dirty region.
 *
 * @param figure the figure that contains the dirty region
 * @param x the x coordinate of the dirty region
 * @param y the y coordinate of the dirty region
 * @param w the width of the dirty region
 * @param h the height of the dirty region
 */
public synchronized void addDirtyRegion(IFigure figure, int x, int y, int w, int h) {
    if (w is 0 || h is 0 || !figure.isShowing())
        return;

    Rectangle rect = cast(Rectangle)dirtyRegions.get(cast(Object)figure);
    if (rect is null) {
        rect = new Rectangle(x, y, w, h);
        dirtyRegions.put(cast(Object)figure, rect);
    } else
        rect.union_(x, y, w, h);

    queueWork();
}

/**
 * Adds the given figure to the update queue.  Invalid figures will be validated before
 * the damaged regions are repainted.
 *
 * @param f the invalid figure
 */
public synchronized void addInvalidFigure(IFigure f) {
    if (invalidFigures.contains(cast(Object)f))
        return;
    queueWork();
    invalidFigures.add(cast(Object)f);
}

/**
 * Returns a Graphics object for the given region.
 * @param region the region to be repainted
 * @return the Graphics object
 */
protected Graphics getGraphics(Rectangle region) {
    if (graphicsSource is null)
        return null;
    return graphicsSource.getGraphics(region);
}

void paint(GC gc) {
    if (!validating) {
        SWTGraphics graphics = new SWTGraphics(gc);
        if (!updating) {
            /**
             * If a paint occurs not as part of an update, we should notify that the region
             * is being painted. Otherwise, notification already occurs in repairDamage().
             */
            Rectangle rect = graphics.getClip(new Rectangle());
            HashMap map = new HashMap();
            map.put(cast(Object)root, rect);
            firePainting(rect, map);
        }
        performValidation();
        root.paint(graphics);
        graphics.dispose();
    } else {
        /*
         * If figures are being validated then we can simply
         * add a dirty region here and update will repaint this region with other
         * dirty regions when it gets to painting. We can't paint if we're not sure
         * that all figures are valid.
         */
        addDirtyRegion(root, new Rectangle(gc.getClipping()));
    }
}

/**
 * Performs the update.  Validates the invalid figures and then repaints the dirty
 * regions.
 * @see #validateFigures()
 * @see #repairDamage()
 */
public synchronized void performUpdate() {
    if (isDisposed() || updating)
        return;
    updating = true;
    try {
        performValidation();
        updateQueued = false;
        repairDamage();
        if (afterUpdate !is null) {
            RunnableChain chain = afterUpdate;
            afterUpdate = null;
            chain.run(); //chain may queue additional Runnable.
            if (afterUpdate !is null)
                queueWork();
        }
    } finally {
        updating = false;
    }
}

/**
 * @see UpdateManager#performValidation()
 */
public void performValidation() {
    if (invalidFigures.isEmpty() || validating)
        return;
    try {
        IFigure fig;
        validating = true;
        fireValidating();
        for (int i = 0; i < invalidFigures.size(); i++) {
            fig = cast(IFigure) invalidFigures.get(i);
            invalidFigures.set(i, null);
            fig.validate();
        }
    } finally {
        invalidFigures.clear();
        validating = false;
    }
}

/**
 * Adds the given exposed region to the update queue and then performs the update.
 *
 * @param exposed the exposed region
 */
public synchronized void performUpdate(Rectangle exposed) {
    addDirtyRegion(root, exposed);
    performUpdate();
}

/**
 * Posts an {@link UpdateRequest} using {@link Display#asyncExec(Runnable)}.  If work has
 * already been queued, a new request is not needed.
 */
protected void queueWork() {
    if (!updateQueued) {
        sendUpdateRequest();
        updateQueued = true;
    }
}

/**
 * Fires the <code>UpdateRequest</code> to the current display asynchronously.
 * @since 3.2
 */
protected void sendUpdateRequest() {
    Display display = Display.getCurrent();
    if (display is null) {
        throw new DWTException(DWT.ERROR_THREAD_INVALID_ACCESS);
    }
    display.asyncExec(new UpdateRequest());
}

/**
 * Releases the graphics object, which causes the GraphicsSource to flush.
 * @param graphics the graphics object
 */
protected void releaseGraphics(Graphics graphics) {
    graphics.dispose();
    graphicsSource.flushGraphics(damage);
}

/**
 * Repaints the dirty regions on the update queue and calls
 * {@link UpdateManager#firePainting(Rectangle, Map)}, unless there are no dirty regions.
 */
protected void repairDamage() {
    Iterator keys = dirtyRegions.keySet().iterator();
    Rectangle contribution;
    IFigure figure;
    IFigure walker;

    while (keys.hasNext()) {
        figure = cast(IFigure)keys.next();
        walker = figure.getParent();
        contribution = cast(Rectangle)dirtyRegions.get(cast(Object)figure);
        //A figure can't paint beyond its own bounds
        contribution.intersect(figure.getBounds());
        while (!contribution.isEmpty() && walker !is null) {
            walker.translateToParent(contribution);
            contribution.intersect(walker.getBounds());
            walker = walker.getParent();
        }
        if (damage is null)
            damage = new Rectangle(contribution);
        else
            damage.union_(contribution);
    }

    if (!dirtyRegions.isEmpty()) {
        Map oldRegions = dirtyRegions;
        dirtyRegions = new HashMap();
        firePainting(damage, oldRegions);
    }

    if (damage !is null && !damage.isEmpty()) {
        //ystem.out.println(damage);
        Graphics graphics = getGraphics(damage);
        if (graphics !is null) {
            root.paint(graphics);
            releaseGraphics(graphics);
        }
    }
    damage = null;
}

/**
 * Adds the given runnable and queues an update if an update is not under progress.
 * @param runnable the runnable
 */
public synchronized void runWithUpdate(Runnable runnable) {
    afterUpdate = new RunnableChain(runnable, afterUpdate);
    if (!updating)
        queueWork();
}

/**
 * Sets the graphics source.
 * @param gs the graphics source
 */
public void setGraphicsSource(GraphicsSource gs) {
    graphicsSource = gs;
}

/**
 * Sets the root figure.
 * @param figure the root figure
 */
public void setRoot(IFigure figure) {
    root = figure;
}

/**
 * Validates all invalid figures on the update queue and calls
 * {@link UpdateManager#fireValidating()} unless there are no invalid figures.
 */
protected void validateFigures() {
    performValidation();
}

}
