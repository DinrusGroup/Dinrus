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
module dwtx.draw2d.BufferedGraphicsSource;

import dwt.dwthelper.utils;



import dwt.DWT;
import dwt.DWTError;
import dwt.graphics.GC;
import dwt.graphics.Image;
static import dwt.graphics.Point;
import dwt.widgets.Canvas;
import dwt.widgets.Caret;
import dwt.widgets.Control;
import dwtx.draw2d.geometry.Rectangle;
import dwtx.draw2d.GraphicsSource;
import dwtx.draw2d.Graphics;
import dwtx.draw2d.SWTGraphics;

class BufferedGraphicsSource : GraphicsSource {

private Image imageBuffer;
private GC imageGC;
private GC controlGC;
private Control control;
private Rectangle inUse;

/**
 * Constructs a new buffered graphics source using the given control.
 * @since 2.1
 * @param c the control
 */
public this(Control c) {
    control = c;
}

/**
 * @see dwtx.draw2d.GraphicsSource#flushGraphics(dwtx.draw2d.geometry.Rectangle)
 */
public void flushGraphics(Rectangle region) {
    if (inUse.isEmpty())
        return;

    bool restoreCaret = false;
    Canvas canvas = null;
    if (auto canvas = cast(Canvas)control ) {
        Caret caret = canvas.getCaret();
        if (caret !is null)
            restoreCaret = caret.isVisible();
        if (restoreCaret)
            caret.setVisible(false);
    }
    /*
     * The imageBuffer may be null if double-buffering was not successful.
     */
    if (imageBuffer !is null) {
        imageGC.dispose();
        controlGC.drawImage(getImage(),
                0, 0, inUse.width, inUse.height,
                inUse.x, inUse.y, inUse.width, inUse.height);
        imageBuffer.dispose();
        imageBuffer = null;
        imageGC = null;
    }
    controlGC.dispose();
    controlGC = null;

    if (restoreCaret)
        canvas.getCaret().setVisible(true);
}

/**
 * @see dwtx.draw2d.GraphicsSource#getGraphics(dwtx.draw2d.geometry.Rectangle)
 */
public Graphics getGraphics(Rectangle region) {
    if (control is null || control.isDisposed())
        return null;

    dwt.graphics.Point.Point ptSWT = control.getSize();
    inUse = new Rectangle(0, 0, ptSWT.x, ptSWT.y);
    inUse.intersect(region);
    if (inUse.isEmpty())
        return null;

    /*
     * Bugzilla 53632 - Attempts to create large images on some platforms will fail.
     * When this happens, do not use double-buffering for painting.
     */
    try {
        imageBuffer = new Image(null, inUse.width, inUse.height);
    } catch (DWTError noMoreHandles) {
        imageBuffer = null;
    } catch (IllegalArgumentException tooBig) {
        imageBuffer = null;
    }

    controlGC = new GC(control,
            control.getStyle() & (DWT.RIGHT_TO_LEFT | DWT.LEFT_TO_RIGHT));
    Graphics graphics;
    if (imageBuffer !is null) {
        imageGC = new GC(imageBuffer,
                control.getStyle() & (DWT.RIGHT_TO_LEFT | DWT.LEFT_TO_RIGHT));
        imageGC.setBackground(controlGC.getBackground());
        imageGC.setForeground(controlGC.getForeground());
        imageGC.setFont(controlGC.getFont());
        imageGC.setLineStyle(controlGC.getLineStyle());
        imageGC.setLineWidth(controlGC.getLineWidth());
        imageGC.setXORMode(controlGC.getXORMode());
        graphics = new SWTGraphics(imageGC);
        graphics.translate(inUse.getLocation().negate());
    } else {
        graphics = new SWTGraphics(controlGC);
    }

    graphics.setClip(inUse);
    return graphics;
}

/**
 * Returns the current image buffer or <code>null</code>.
 * @since 2.1
 * @return the current image buffer
 */
protected Image getImage() {
    return imageBuffer;
}

/**
 * Returns the current GC used on the buffer or <code>null</code>.
 * @since 2.1
 * @return the GC for the image buffer
 */
protected GC getImageGC() {
    return imageGC;
}

}
