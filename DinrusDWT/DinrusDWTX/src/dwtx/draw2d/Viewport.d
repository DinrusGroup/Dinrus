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
module dwtx.draw2d.Viewport;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Bean;

import dwtx.draw2d.geometry.Point;
import dwtx.draw2d.geometry.Rectangle;
import dwtx.draw2d.geometry.Translatable;
import dwtx.draw2d.Figure;
import dwtx.draw2d.IFigure;
import dwtx.draw2d.Graphics;
import dwtx.draw2d.RangeModel;
import dwtx.draw2d.ViewportLayout;
import dwtx.draw2d.DefaultRangeModel;

/**
 * A Viewport is a flexible window onto a {@link ScrollPane} and represents the visible
 * portion of the ScrollPane.
 */
public class Viewport
    : Figure
    , PropertyChangeListener
{

public alias Figure.getClientArea getClientArea;

/** ID for the view location property */
public static final String PROPERTY_VIEW_LOCATION = "viewLocation"; //$NON-NLS-1$
private IFigure view;

private bool useTranslate = false;
private bool trackWidth = false;
private bool trackHeight = false;
private bool ignoreScroll = false;
private RangeModel
    horiztonalRangeModel = null,
    verticalRangeModel = null;

private void instanceInit(){
    setLayoutManager(new ViewportLayout());
    setHorizontalRangeModel(new DefaultRangeModel());
    setVerticalRangeModel(new DefaultRangeModel());
}

/**
 * Constructs a new Viewport with the default values.
 */
public this() {
    instanceInit();
}

/**
 * Constructs a new Viewport.  If <i>setting</i> is <code>true</code>, the viewport will
 * use graphics translation to paint.
 * @param setting whether to use graphics translation
 */
public this(bool setting) {
    instanceInit();
    useTranslate = setting;
}

/**
 * @see IFigure#getClientArea(Rectangle)
 */
public Rectangle getClientArea(Rectangle rect) {
    super.getClientArea(rect);
    if (useGraphicsTranslate())
        rect.translate(getViewLocation());
    return rect;
}

/**
 * Returns the view, which is the contents of the {@link ScrollPane} associated with this
 * Viewport.
 *
 * @return the contents
 * @since 2.0
 */
public IFigure getContents() {
    return view;
}

/**
 * Returns the RangeModel associated with the horizontal motion of this Viewport
 * @return the RangeModel
 *
 * @since 2.0
 */
public RangeModel getHorizontalRangeModel() {
    return horiztonalRangeModel;
}

/**
 * Returns <code>true</code> if the Viewport resizes itself in the vertical direction when
 * the  available height of its view is decreased, false otherwise. This option is turned
 * off by default, and can be activated by calling
 * {@link #setContentsTracksHeight(bool)} and passing in <code>true</code>.
 *
 * @return whether the contents tracks height
 * @since 2.0
 */
public bool getContentsTracksHeight() {
    return trackHeight;
}

/**
 * Returns <code>true</code> if the Viewport resizes itself in the horizontal direction
 * when the available width of its view is decreased, false otherwise. This option is
 * turned off by default, and can be activated by calling
 * {@link #setContentsTracksWidth(bool)} and passing in <code>true</code>.
 *
 * @return whether the contents tracks width
 * @since 2.0
 */
public bool getContentsTracksWidth() {
    return trackWidth;
}

/**
 * Returns the range model associated with the vertical motion of the Viewport.
 * @return the RangeModel
 *
 * @since 2.0
 */
public RangeModel getVerticalRangeModel() {
    return verticalRangeModel;
}

/**
 * Returns the current location of this Viewport.
 * @return the current location of this Viewport
 *
 * @since 2.0
 */
public Point getViewLocation() {
    return new Point(
        getHorizontalRangeModel().getValue(),
        getVerticalRangeModel().getValue());
}

private void localRevalidate() {
    invalidate();
    if (getLayoutManager() !is null)
        getLayoutManager().invalidate();
    getUpdateManager().addInvalidFigure(this);
}

/**
 * @see Figure#paintClientArea(Graphics)
 */
protected void paintClientArea(Graphics g) {
    if (useGraphicsTranslate()) {
        Point p = getViewLocation();
        try {
            g.translate(-p.x, -p.y);
            g.pushState();
            super.paintClientArea(g);
            g.popState();
        } finally {
            g.translate(p.x, p.y);
        }
    } else
        super.paintClientArea(g);
}

/**
 * @see dwtx.draw2d.Figure#isCoordinateSystem()
 */
public bool isCoordinateSystem() {
    return useGraphicsTranslate() || super.isCoordinateSystem();
}

/**
 * Listens for either of the {@link RangeModel RangeModels} to fire a property change
 * event and updates the view accordingly.
 * @param event the event
 */
public void propertyChange(PropertyChangeEvent event) {
    if (null !is cast(RangeModel)(event.getSource()) ) {
        if (RangeModel.PROPERTY_VALUE.equals(event.getPropertyName())) {
            if (!ignoreScroll) {
                localRevalidate();
                if (useGraphicsTranslate()) {
                    repaint();
                    fireMoved();
                }
            }
            firePropertyChange(PROPERTY_VIEW_LOCATION, event.getOldValue(),
                                event.getNewValue());
        }
    }
}

/**
 * Sets extents of {@link RangeModel RangeModels} to the client area of this Viewport.
 * Sets RangeModel minimums to zero. Sets RangeModel maximums to this Viewport's
 * height/width.
 *
 * @since 2.0
 */
protected void readjustScrollBars() {
    if (getContents() is null)
        return;
    getVerticalRangeModel().setAll(0, getClientArea().height,
                                    getContents().getBounds().height);
    getHorizontalRangeModel().setAll(0, getClientArea().width,
                                    getContents().getBounds().width);
}

/**
 * Sets this Viewport to be associated with the passed Figure.
 *
 * @param figure the new contents
 * @since 2.0
 */
public void setContents(IFigure figure) {
    if (view is figure)
        return;
    if (view !is null)
        remove(view);
    view = figure;
    if (view !is null)
        add(figure);
}

/**
 * Toggles the Viewport's ability to resize itself automatically when its view is
 * decreased in size in the vertical direction. This is disabled by default.
 *
 * @param track whether this viewport should track its height
 * @since 2.0
 */
public void setContentsTracksHeight(bool track) {
    trackHeight = track;
}

/**
 * Toggles the Viewport's ability to resize itself automatically when its view is
 * decreased in size in the horizontal direction. This is disabled by default.
 *
 * @param track whether this viewport should track its width
 * @since 2.0
 */
public void setContentsTracksWidth(bool track) {
    trackWidth = track;
}

/**
 * Sets the horizontal location of the Viewport's view to the passed value.
 *
 * @param value the new horizontal location
 * @since 2.0
 */
public void setHorizontalLocation(int value) {
    setViewLocation(value, getVerticalRangeModel().getValue());
}

/**
 * Sets the horizontal range model to the passed RangeModel.
 *
 * @param rangeModel the new horizontal range model
 * @since 2.0
 */
public void setHorizontalRangeModel(RangeModel rangeModel) {
    if (horiztonalRangeModel !is null)
        horiztonalRangeModel.removePropertyChangeListener(this);
    horiztonalRangeModel = rangeModel;
    horiztonalRangeModel.addPropertyChangeListener(this);
}

/**
 * If <i>value</i> is <code>true</code>, this viewport will ignore any scrolling that
 * occurs until this method is called again with <code>false</code>.
 *
 * @param value whether this viewport should ignore future scrolls
 */
public void setIgnoreScroll(bool value) {
    ignoreScroll = value;
}

/**
 * Sets the vertical location of the Viewport's view to the passed value.
 *
 * @param value the new vertical location
 * @since 2.0
 */
public void setVerticalLocation(int value) {
    setViewLocation(getHorizontalRangeModel().getValue(), value);
}

/**
 * Sets the vertical range model to the passed RangeModel.
 *
 * @param rangeModel the new vertical RangeModel
 * @since 2.0
 */
public void setVerticalRangeModel(RangeModel rangeModel) {
    if (verticalRangeModel !is null)
        verticalRangeModel.removePropertyChangeListener(this);
    verticalRangeModel = rangeModel;
    verticalRangeModel.addPropertyChangeListener(this);
}

/**
 * Sets the location of the Viewport's view to the passed values.
 *
 * @param x The new x coordinate of the Viewport's view.
 * @param y The new y coordinate of the Viewport's view.
 * @since 2.0
 */
public void setViewLocation(int x, int y) {
    if (getHorizontalRangeModel().getValue() !is x)
        getHorizontalRangeModel().setValue(x);
    if (getVerticalRangeModel().getValue() !is y)
        getVerticalRangeModel().setValue(y);
}

/**
 * Sets the location of the Viewport's view to the passed Point.
 *
 * @param p The new location of the Viewport's view.
 * @since 2.0
 */
public void setViewLocation(Point p) {
    setViewLocation(p.x, p.y);
}

/**
 * @see IFigure#translateFromParent(Translatable)
 */
public void translateFromParent(Translatable t) {
    if (useTranslate)
        t.performTranslate(
            getHorizontalRangeModel().getValue(),
            getVerticalRangeModel().getValue()
        );
    super.translateFromParent(t);
}

/**
 * @see IFigure#translateToParent(Translatable)
 */
public void translateToParent(Translatable t) {
    if (useTranslate)
        t.performTranslate(
            -getHorizontalRangeModel().getValue(),
            -getVerticalRangeModel().getValue()
        );
    super.translateToParent(t);
}

/**
 * Returns <code>true</code> if this viewport uses graphics translation.
 * @return whether this viewport uses graphics translation
 */
public bool useGraphicsTranslate() {
    return useTranslate;
}

/**
 * @see IFigure#validate()
 */
public void validate() {
    super.validate();
    readjustScrollBars();
}

}
