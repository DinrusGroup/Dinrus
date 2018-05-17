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
module dwtx.draw2d.ScalableFreeformLayeredPane;

import dwt.dwthelper.utils;

import dwtx.draw2d.geometry.Rectangle;
import dwtx.draw2d.geometry.Translatable;
import dwtx.draw2d.FreeformLayeredPane;
import dwtx.draw2d.ScalableFigure;
import dwtx.draw2d.Graphics;
import dwtx.draw2d.ScaledGraphics;

/**
 * @author hudsonr
 * @since 2.1
 */
public class ScalableFreeformLayeredPane
    : FreeformLayeredPane
    , ScalableFigure
{

private double scale = 1.0;

/**
 * @see dwtx.draw2d.Figure#getClientArea()
 */
public Rectangle getClientArea(Rectangle rect) {
    super.getClientArea(rect);
    rect.width /= scale;
    rect.height /= scale;
    rect.x /= scale;
    rect.y /= scale;
    return rect;
}

/**
 * Returns the current zoom scale level.
 * @return the scale
 */
public double getScale() {
    return scale;
}

/**
 * @see dwtx.draw2d.IFigure#isCoordinateSystem()
 */
public bool isCoordinateSystem() {
    return true;
}

/**
 * @see dwtx.draw2d.Figure#paintClientArea(Graphics)
 */
protected void paintClientArea(Graphics graphics) {
    if (getChildren().isEmpty())
        return;
    if (scale is 1.0) {
        super.paintClientArea(graphics);
    } else {
        ScaledGraphics g = new ScaledGraphics(graphics);
        bool optimizeClip = getBorder() is null || getBorder().isOpaque();
        if (!optimizeClip)
            g.clipRect(getBounds().getCropped(getInsets()));
        g.scale(scale);
        g.pushState();
        paintChildren(g);
        g.dispose();
        graphics.restoreState();
    }
}

/**
 * Sets the zoom level
 * @param newZoom The new zoom level
 */
public void setScale(double newZoom) {
    if (scale is newZoom)
        return;
    scale = newZoom;
    superFireMoved(); //For AncestorListener compatibility
    getFreeformHelper().invalidate();
    repaint();
}

/**
 * @see dwtx.draw2d.Figure#translateToParent(Translatable)
 */
public void translateToParent(Translatable t) {
    t.performScale(scale);
}

/**
 * @see dwtx.draw2d.Figure#translateFromParent(Translatable)
 */
public void translateFromParent(Translatable t) {
    t.performScale(1 / scale);
}

/**
 * @see dwtx.draw2d.Figure#useLocalCoordinates()
 */
protected final bool useLocalCoordinates() {
    return false;
}

}
