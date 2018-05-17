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
module dwtx.draw2d.parts.ScrollableThumbnail;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Bean;

import dwt.DWT;
import dwt.graphics.Image;
import dwt.graphics.ImageData;
import dwt.graphics.PaletteData;
import dwt.graphics.RGB;
import dwt.widgets.Display;
import dwtx.draw2d.ColorConstants;
import dwtx.draw2d.Figure;
import dwtx.draw2d.FigureListener;
import dwtx.draw2d.Graphics;
import dwtx.draw2d.IFigure;
import dwtx.draw2d.KeyEvent;
import dwtx.draw2d.KeyListener;
import dwtx.draw2d.MouseEvent;
import dwtx.draw2d.MouseListener;
import dwtx.draw2d.MouseMotionListener;
import dwtx.draw2d.Viewport;
import dwtx.draw2d.geometry.Dimension;
import dwtx.draw2d.geometry.Point;
import dwtx.draw2d.geometry.Rectangle;
import dwtx.draw2d.parts.Thumbnail;

/**
 * A scaled image representation of a Figure.  If the source Figure is not completely
 * visible, a SelectorFigure is placed over the thumbnail representing the viewable area
 * and can be dragged around to scroll the source figure.
 */
public final class ScrollableThumbnail
    : Thumbnail
{

private class ClickScrollerAndDragTransferrer
    : MouseMotionListener.Stub
    , MouseListener
{
    private bool dragTransfer;
    public void mouseDoubleClicked(MouseEvent me) { }
    public void mouseDragged(MouseEvent me) {
        if (dragTransfer)
            syncher.mouseDragged(me);
    }
    public void mousePressed(MouseEvent me) {
        if (!(this.outer.getClientArea().contains(me.getLocation())))
            return;
        Dimension selectorCenter = selector.getBounds().getSize().scale(0.5f);
        Point scrollPoint = me.getLocation()
                            .getTranslated(getLocation().getNegated())
                            .translate(selectorCenter.negate())
                            .scale(1.0f / getViewportScaleX(), 1.0f / getViewportScaleY())
                            .translate(
                                    viewport.getHorizontalRangeModel().getMinimum(),
                                    viewport.getVerticalRangeModel().getMinimum());
        viewport.setViewLocation(scrollPoint);
        syncher.mousePressed(me);
        dragTransfer = true;
    }
    public void mouseReleased(MouseEvent me) {
        syncher.mouseReleased(me);
        dragTransfer = false;
    }
}

private class ScrollSynchronizer
    : MouseMotionListener.Stub
    , MouseListener
{
    private Point startLocation;
    private Point viewLocation;

    public void mouseDoubleClicked(MouseEvent me) { }

    public void mouseDragged(MouseEvent me) {
        Dimension d = me.getLocation().getDifference(startLocation);
        d.scale(1.0f / getViewportScaleX(), 1.0f / getViewportScaleY());
        viewport.setViewLocation(viewLocation.getTranslated(d));
        me.consume();
    }

    public void mousePressed(MouseEvent me) {
        startLocation = me.getLocation();
        viewLocation = viewport.getViewLocation();
        me.consume();
    }

    public void mouseReleased(MouseEvent me) { }
}

private class SelectorFigure
    : Figure
{
    this(){
        iBounds = new Rectangle(0, 0, 1, 1);
        Display display = Display.getCurrent();
        PaletteData pData = new PaletteData(0xFF, 0xFF00, 0xFF0000);
        RGB rgb = ColorConstants.menuBackgroundSelected.getRGB();
        int fillColor = pData.getPixel(rgb);
        ImageData iData = new ImageData(1, 1, 24, pData);
        iData.setPixel(0, 0, fillColor);
        iData.setAlpha(0, 0, 55);
        image = new Image(display, iData);
    }
    private Rectangle iBounds;

    private Image image;

    protected void dispose() {
        image.dispose();
    }

    public void paintFigure(Graphics g) {
        Rectangle bounds = getBounds().getCopy();

        // Avoid drawing images that are 0 in dimension
        if (bounds.width < 5 || bounds.height < 5)
            return;

        // Don't paint the selector figure if the entire source is visible.
        Dimension thumbnailSize = new Dimension(getThumbnailImage());
        // expand to compensate for rounding errors in calculating bounds
        Dimension size = getSize().getExpanded(1, 1);
        if (size.contains(thumbnailSize))
            return;

        bounds.height--;
        bounds.width--;
        g.drawImage(image, iBounds, bounds);

        g.setForegroundColor(ColorConstants.menuBackgroundSelected);
        g.drawRectangle(bounds);
    }

}
private FigureListener figureListener;
private void initFigureListener(){
    figureListener = new class() FigureListener {
        public void figureMoved(IFigure source) {
            reconfigureSelectorBounds();
        }
    };
}
private KeyListener keyListener;
private void initKeyListener(){
    keyListener = new class() KeyListenerStub {
        public void keyPressed(KeyEvent ke) {
            int moveX = viewport.getClientArea().width / 4;
            int moveY = viewport.getClientArea().height / 4;
            if (ke.keycode is DWT.HOME || (isMirrored() ? ke.keycode is DWT.ARROW_RIGHT
                    : ke.keycode is DWT.ARROW_LEFT))
                viewport.setViewLocation(viewport.getViewLocation().translate(-moveX, 0));
            else if (ke.keycode is DWT.END || (isMirrored() ? ke.keycode is DWT.ARROW_LEFT
                    : ke.keycode is DWT.ARROW_RIGHT))
                viewport.setViewLocation(viewport.getViewLocation().translate(moveX, 0));
            else if (ke.keycode is DWT.ARROW_UP || ke.keycode is DWT.PAGE_UP)
                viewport.setViewLocation(viewport.getViewLocation().translate(0, -moveY));
            else if (ke.keycode is DWT.ARROW_DOWN  || ke.keycode is DWT.PAGE_DOWN)
                viewport.setViewLocation(viewport.getViewLocation().translate(0, moveY));
        }
    };
}

private PropertyChangeListener propListener;
private void initPropListener(){
    propListener = new class() PropertyChangeListener {
        public void propertyChange(PropertyChangeEvent evt) {
            reconfigureSelectorBounds();
        }
    };
}

private SelectorFigure selector;

private ScrollSynchronizer syncher;
private Viewport viewport;

/**
 * Creates a new ScrollableThumbnail.
 */
public this() {
    super();
    initFigureListener();
    initKeyListener();
    initPropListener();
    initialize();
}

/**
 * Creates a new ScrollableThumbnail that synchs with the given Viewport.
 * @param port The Viewport
 */
public this(Viewport port) {
    super();
    initFigureListener();
    initKeyListener();
    initPropListener();
    setViewport(port);
    initialize();
}

/**
 * @see Thumbnail#deactivate()
 */
public void deactivate() {
    viewport.removePropertyChangeListener(Viewport.PROPERTY_VIEW_LOCATION, propListener);
    viewport.removeFigureListener(figureListener);
    remove(selector);
    selector.dispose();
    super.deactivate();
}

private double getViewportScaleX() {
    return cast(double)targetSize.width / viewport.getContents().getBounds().width;
}

private double getViewportScaleY() {
    return cast(double)targetSize.height / viewport.getContents().getBounds().height;
}

private void initialize() {
    selector = new SelectorFigure();
    selector.addMouseListener(syncher = new ScrollSynchronizer());
    selector.addMouseMotionListener(syncher);
    selector.setFocusTraversable(true);
    selector.addKeyListener(keyListener);
    add(selector);
    ClickScrollerAndDragTransferrer transferrer =
                new ClickScrollerAndDragTransferrer();
    addMouseListener(transferrer);
    addMouseMotionListener(transferrer);
}

private void reconfigureSelectorBounds() {
    Rectangle rect = new Rectangle();
    Point offset = viewport.getViewLocation();
    offset.x -= viewport.getHorizontalRangeModel().getMinimum();
    offset.y -= viewport.getVerticalRangeModel().getMinimum();
    rect.setLocation(offset);
    rect.setSize(viewport.getClientArea().getSize());
    rect.scale(getViewportScaleX(), getViewportScaleY());
    rect.translate(getClientArea().getLocation());
    selector.setBounds(rect);
}

/**
 * Reconfigures the SelectorFigure's bounds if the scales have changed.
 * @param scaleX The X scale
 * @param scaleY The Y scale
 * @see dwtx.draw2d.parts.Thumbnail#setScales(float, float)
 */
protected void setScales(float scaleX, float scaleY) {
    if (scaleX is getScaleX() && scaleY is getScaleY())
        return;

    super.setScales(scaleX, scaleY);
    reconfigureSelectorBounds();
}

/**
 * Sets the Viewport that this ScrollableThumbnail will synch with.
 * @param port The Viewport
 */
public void setViewport(Viewport port) {
    port.addPropertyChangeListener(Viewport.PROPERTY_VIEW_LOCATION, propListener);
    port.addFigureListener(figureListener);
    viewport = port;
}

}
