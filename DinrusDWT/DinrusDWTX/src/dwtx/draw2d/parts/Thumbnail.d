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
module dwtx.draw2d.parts.Thumbnail;

import dwt.dwthelper.utils;
import dwt.dwthelper.Runnable;
import dwtx.dwtxhelper.Collection;

import dwt.DWT;
import dwt.graphics.Color;
import dwt.graphics.GC;
import dwt.graphics.Image;
static import dwtx.draw2d.geometry.Point;
import dwt.widgets.Display;
import dwtx.draw2d.Figure;
import dwtx.draw2d.Graphics;
import dwtx.draw2d.IFigure;
import dwtx.draw2d.SWTGraphics;
import dwtx.draw2d.ScaledGraphics;
import dwtx.draw2d.UpdateListener;
import dwtx.draw2d.geometry.Dimension;
import dwtx.draw2d.geometry.Rectangle;

/**
 * A Thumbnail is a Figure that displays an image of its source Figure at a
 * smaller size. The Thumbnail will maintain the aspect ratio of the source
 * Figure.
 *
 * @author Eric Bordeau
 */
public class Thumbnail
    : Figure
    , UpdateListener
{
alias Figure.getPreferredSize getPreferredSize;


/**
 * This updates the Thumbnail by breaking the thumbnail {@link Image} into
 * several tiles and updating each tile individually.
 */
class ThumbnailUpdater : Runnable {
    static final int MAX_BUFFER_SIZE = 256;
    private int currentHTile, currentVTile;
    private int hTiles, vTiles;
    private bool isActive_ = true;

    private bool isRunning_ = false;
    private GC thumbnailGC;
    private ScaledGraphics thumbnailGraphics;
    private Dimension tileSize;

    /**
     * Stops the updater and disposes of any resources.
     */
    public void deactivate() {
        setActive(false);
        stop();
        if (thumbnailImage !is null) {
            thumbnailImage.dispose();
            thumbnailImage = null;
            thumbnailImageSize = null;
        }
    }

    /**
     * Returns the current horizontal tile index.
     * @return current horizontal tile index.
     */
    protected int getCurrentHTile() {
        return currentHTile;
    }

    /**
     * Returns the current vertical tile index.
     * @return current vertical tile index.
     */
    protected int getCurrentVTile() {
        return currentVTile;
    }

    /**
     * Returns <code>true</code> if this ThumbnailUpdater is active.  An inactive
     * updater has disposed of its {@link Image}.  The updater may be active and
     * not currently running.
     * @return <code>true</code> if this ThumbnailUpdater is active
     */
    public bool isActive() {
        return isActive_;
    }

    /**
     * Returns <code>true</code> if this is currently running and updating at
     * least one tile on the thumbnail {@link Image}.
     * @return <code>true</code> if this is currently running
     */
    public bool isRunning() {
        return isRunning_;
    }

    /**
     * Resets the number of vertical and horizontal tiles, as well as the tile
     * size and current tile index.
     */
    public void resetTileValues() {
        hTiles = cast(int)Math.ceil(cast(float)getSourceRectangle().width
                                    / cast(float)MAX_BUFFER_SIZE);
        vTiles = cast(int)Math.ceil(cast(float)getSourceRectangle().height
                                    / cast(float)MAX_BUFFER_SIZE);

        tileSize = new Dimension(cast(int)Math.ceil(cast(float)getSourceRectangle().width
                                    / cast(float)hTiles),
                                cast(int)Math.ceil(cast(float)getSourceRectangle().height
                                    / cast(float)vTiles));

        currentHTile = 0;
        currentVTile = 0;
    }

    /**
     * Restarts the updater.
     */
    public void restart() {
        stop();
        start();
    }

    /**
     * Updates the current tile on the Thumbnail.  An area of the source Figure
     * is painted to an {@link Image}.  That Image is then drawn on the
     * Thumbnail.  Scaling of the source Image is done inside
     * {@link GC#drawImage(Image, int, int, int, int, int, int, int, int)} since
     * the source and target sizes are different.  The current tile indexes are
     * incremented and if more updating is necesary, this {@link Runnable} is
     * called again in a {@link Display#timerExec(int, Runnable)}.  If no more
     * updating is required, {@link #stop()} is called.
     */
    public void run() {
        if (!isActive() || !isRunning())
            return;
        int v = getCurrentVTile();
        int sy1 = v * tileSize.height;
        int sy2 = Math.min((v + 1) * tileSize.height, getSourceRectangle().height);

        int h = getCurrentHTile();
        int sx1 = h * tileSize.width;
        int sx2 = Math.min((h + 1) * tileSize.width, getSourceRectangle().width);
        dwtx.draw2d.geometry.Point.Point p = getSourceRectangle().getLocation();

        Rectangle rect = new Rectangle(sx1 + p.x, sy1 + p.y, sx2 - sx1, sy2 - sy1);
        thumbnailGraphics.pushState();
        thumbnailGraphics.setClip(rect);
        thumbnailGraphics.fillRectangle(rect);
        sourceFigure.paint(thumbnailGraphics);
        thumbnailGraphics.popState();

        if (getCurrentHTile() < (hTiles - 1))
            setCurrentHTile(getCurrentHTile() + 1);
        else {
            setCurrentHTile(0);
            if (getCurrentVTile() < (vTiles - 1))
                setCurrentVTile(getCurrentVTile() + 1);
            else
                setCurrentVTile(0);
        }

        if (getCurrentHTile() !is 0 || getCurrentVTile() !is 0)
            Display.getCurrent().asyncExec(this);
        else if (isDirty()) {
            setDirty(false);
            Display.getCurrent().asyncExec(this);
            repaint();
        } else {
            stop();
            repaint();
        }
    }

    /**
     * Sets the active flag.
     * @param value The active value
     */
    public void setActive(bool value) {
        isActive_ = value;
    }

    /**
     * Sets the current horizontal tile index.
     * @param count current horizontal tile index
     */
    protected void setCurrentHTile(int count) {
        currentHTile = count;
    }

    /**
     * Sets the current vertical tile index.
     * @param count current vertical tile index
     */
    protected void setCurrentVTile(int count) {
        currentVTile = count;
    }

    /**
     * Starts this updater.  This method initializes all the necessary resources
     * and puts this {@link Runnable} on the asynch queue.  If this updater is
     * not active or is already running, this method just returns.
     */
    public void start() {
        if (!isActive() || isRunning())
            return;

        isRunning_ = true;
        setDirty(false);
        resetTileValues();

        if (!targetSize.opEquals(thumbnailImageSize)) {
            resetThumbnailImage();
        }

        if (targetSize.isEmpty())
            return;

        thumbnailGC = new GC(thumbnailImage,
                sourceFigure.isMirrored() ? DWT.RIGHT_TO_LEFT : DWT.NONE);
        thumbnailGraphics = new ScaledGraphics(new SWTGraphics(thumbnailGC));
        thumbnailGraphics.scale(getScaleX());
        thumbnailGraphics.translate(getSourceRectangle().getLocation().negate());

        Color color = sourceFigure.getForegroundColor();
        if (color !is null)
            thumbnailGraphics.setForegroundColor(color);
        color = sourceFigure.getBackgroundColor();
        if (color !is null)
            thumbnailGraphics.setBackgroundColor(color);
        thumbnailGraphics.setFont(sourceFigure.getFont());

        setScales(targetSize.width / cast(float)getSourceRectangle().width,
                 targetSize.height / cast(float)getSourceRectangle().height);

        Display.getCurrent().asyncExec(this);
    }

    /**
     *
     * @since 3.2
     */
    private void resetThumbnailImage() {
        if (thumbnailImage !is null)
            thumbnailImage.dispose();

        if (!targetSize.isEmpty()) {
            thumbnailImage = new Image(Display.getDefault(),
                    targetSize.width,
                    targetSize.height);
            thumbnailImageSize = new Dimension(targetSize);
        }
        else {
            thumbnailImage = null;
            thumbnailImageSize = new Dimension(0, 0);
        }
    }

    /**
     * Stops this updater.  Also disposes of resources (except the thumbnail
     * image which is still needed for painting).
     */
    public void stop() {
        isRunning_ = false;
        if (thumbnailGC !is null) {
            thumbnailGC.dispose();
            thumbnailGC = null;
        }
        if (thumbnailGraphics !is null) {
            thumbnailGraphics.dispose();
            thumbnailGraphics = null;
        }
        // Don't dispose of the thumbnail image since it is needed to paint the
        // figure when the source is not dirty (i.e. showing/hiding the dock).
    }
}
private bool isDirty_;
private float scaleX;
private float scaleY;

private IFigure sourceFigure;
Dimension targetSize;
private Image thumbnailImage;
private Dimension thumbnailImageSize;
private ThumbnailUpdater updater;

/**
 * Creates a new Thumbnail.  The source Figure must be set separately if you
 * use this constructor.
 */
public this() {
    super();
    targetSize = new Dimension(0, 0);
    updater = new ThumbnailUpdater();
}

/**
 * Creates a new Thumbnail with the given IFigure as its source figure.
 * @param fig The source figure
 */
public this(IFigure fig) {
    this();
    setSource(fig);
}

private Dimension adjustToAspectRatio(Dimension size, bool adjustToMaxDimension) {
    Dimension sourceSize = getSourceRectangle().getSize();
    Dimension borderSize = new Dimension(getInsets().getWidth(), getInsets().getHeight());
    size.expand(borderSize.getNegated());
    int width, height;
    if (adjustToMaxDimension) {
        width  = Math.max(size.width, cast(int)(size.height * sourceSize.width
                                            / cast(float)sourceSize.height + 0.5));
        height = Math.max(size.height, cast(int)(size.width * sourceSize.height
                                            / cast(float)sourceSize.width + 0.5));
    } else {
        width  = Math.min(size.width,  cast(int)(size.height * sourceSize.width
                                            / cast(float)sourceSize.height + 0.5));
        height = Math.min(size.height, cast(int)(size.width * sourceSize.height
                                            / cast(float)sourceSize.width + 0.5));
    }
    size.width  = width;
    size.height = height;
    return size.expand(borderSize);
}

/**
 * Deactivates this Thumbnail.
 */
public void deactivate() {
    sourceFigure.getUpdateManager().removeUpdateListener(this);
    updater.deactivate();
}

/**
 * Returns the preferred size of this Thumbnail.  The preferred size will be
 * calculated in a way that maintains the source Figure's aspect ratio.
 *
 * @param wHint The width hint
 * @param hHint The height hint
 * @return The preferred size
 */
public Dimension getPreferredSize(int wHint, int hHint) {
    if (prefSize is null)
        return adjustToAspectRatio(getBounds().getSize(), false);

    Dimension preferredSize = adjustToAspectRatio(prefSize.getCopy(), true);

    if (maxSize is null)
        return preferredSize;

    Dimension maximumSize = adjustToAspectRatio(maxSize.getCopy(), true);
    if (preferredSize.contains(maximumSize))
        return maximumSize;
    else
        return preferredSize;
}

/**
 * Returns the scale factor on the X-axis.
 * @return X scale
 */
protected float getScaleX() {
    return scaleX;
}

/**
 * Returns the scale factor on the Y-axis.
 * @return Y scale
 */
protected float getScaleY() {
    return scaleY;
}

/**
 * Returns the source figure being used to generate a thumbnail.
 * @return the source figure
 */
protected IFigure getSource() {
    return sourceFigure;
}

/**
 * Returns the rectangular region relative to the source figure which will be the basis of
 * the thumbnail.  The value may be returned by reference and should not be modified by
 * the caller.
 * @since 3.1
 * @return the region of the source figure being used for the thumbnail
 */
protected Rectangle getSourceRectangle() {
    return sourceFigure.getBounds();
}

/**
 * Returns the scaled Image of the source Figure.  If the Image needs to be
 * updated, the ThumbnailUpdater will notified.
 *
 * @return The thumbnail image
 */
protected Image getThumbnailImage() {
    Dimension oldSize = targetSize;
    targetSize = getPreferredSize();
    targetSize.expand((new Dimension(getInsets().getWidth(),
                                    getInsets().getHeight())).negate());
    setScales(targetSize.width / cast(float)getSourceRectangle().width,
             targetSize.height / cast(float)getSourceRectangle().height);
    if ((isDirty()) && !updater.isRunning())
        updater.start();
    else if (oldSize !is null && !targetSize.opEquals(oldSize)) {
        revalidate();
        updater.restart();
    }

    return thumbnailImage;
}

/**
 * Returns <code>true</code> if the source figure has changed.
 * @return <code>true</code> if the source figure has changed
 */
protected bool isDirty() {
    return isDirty_;
}

/**
 * @see dwtx.draw2d.UpdateListener#notifyPainting(Rectangle, Map)
 */
public void notifyPainting(Rectangle damage, Map dirtyRegions) {
    Iterator dirtyFigures = dirtyRegions.keySet().iterator();
    while (dirtyFigures.hasNext()) {
        IFigure current = cast(IFigure)dirtyFigures.next();
        while (current !is null) {
            if (current is getSource()) {
                setDirty(true);
                repaint();
                return;
            }
            current = current.getParent();
        }
    }
}

/**
 * @see dwtx.draw2d.UpdateListener#notifyValidating()
 */
public void notifyValidating() {
//  setDirty(true);
//  revalidate();
}

/**
 * @see dwtx.draw2d.Figure#paintFigure(Graphics)
 */
protected void paintFigure(Graphics graphics) {
    Image thumbnail = getThumbnailImage();
    if (thumbnail is null)
        return;
    graphics.drawImage(thumbnail, getClientArea().getLocation());
}

/**
 * Sets the dirty flag.
 * @param value The dirty value
 */
public void setDirty(bool value) {
    isDirty_ = value;
}

/**
 * Sets the X and Y scales for the Thumbnail.  These scales represent the ratio
 * between the source figure and the Thumbnail.
 * @param x The X scale
 * @param y The Y scale
 */
protected void setScales(float x, float y) {
    scaleX = x;
    scaleY = y;
}

/**
 * Sets the source Figure.  Also sets the scales and creates the necessary
 * update manager.
 * @param fig The source figure
 */
public void setSource(IFigure fig) {
    if (sourceFigure is fig)
        return;
    if (sourceFigure !is null)
        sourceFigure.getUpdateManager().removeUpdateListener(this);
    sourceFigure = fig;
    if (sourceFigure !is null) {
        setScales(cast(float)getSize().width / cast(float)getSourceRectangle().width,
                cast(float)getSize().height / cast(float)getSourceRectangle().height);
        sourceFigure.getUpdateManager().addUpdateListener(this);
        repaint();
    }
}

}
