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
module dwtx.draw2d.SubordinateUpdateManager;

import dwt.dwthelper.utils;

import dwtx.draw2d.geometry.Rectangle;
import dwtx.draw2d.UpdateManager;
import dwtx.draw2d.IFigure;
import dwtx.draw2d.GraphicsSource;

/**
 * @deprecated this class is not used
 */
public abstract class SubordinateUpdateManager
    : UpdateManager
{

/**
 * A root figure.
 */
protected IFigure root;

/**
 * A graphics source
 */
protected GraphicsSource graphicsSource;

/**
 * @see UpdateManager#addDirtyRegion(IFigure, int, int, int, int)
 */
public void addDirtyRegion(IFigure f, int x, int y, int w, int h) {
    if (getSuperior() is null)
        return;
    getSuperior().addDirtyRegion(f, x, y, w, h);
}

/**
 * @see UpdateManager#addInvalidFigure(IFigure)
 */
public void addInvalidFigure(IFigure f) {
    UpdateManager um = getSuperior();
    if (um is null)
        return;
    um.addInvalidFigure(f);
}

/**
 * Returns the host figure.
 * @return the host figure
 */
protected abstract IFigure getHost();

/**
 * Returns the superior update manager.
 * @return the superior
 */
protected UpdateManager getSuperior() {
    if (getHost().getParent() is null)
        return null;
    return getHost().getParent().getUpdateManager();
}

/**
 * @see UpdateManager#performUpdate()
 */
public void performUpdate() {
    UpdateManager um = getSuperior();
    if (um is null)
        return;
    um.performUpdate();
}

/**
 * @see UpdateManager#performUpdate(Rectangle)
 */
public void performUpdate(Rectangle rect) {
    UpdateManager um = getSuperior();
    if (um is null)
        return;
    um.performUpdate(rect);
}

/**
 * @see UpdateManager#setRoot(IFigure)
 */
public void setRoot(IFigure f) {
    root = f;
}

/**
 * @see UpdateManager#setGraphicsSource(GraphicsSource)
 */
public void setGraphicsSource(GraphicsSource gs) {
    graphicsSource = gs;
}
}
