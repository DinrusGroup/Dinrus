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
module dwtx.draw2d.RotatableDecoration;

import dwt.dwthelper.utils;

import dwtx.draw2d.geometry.Point;
import dwtx.draw2d.IFigure;

/**
 * An IFigure that can be rotated.
 */
public interface RotatableDecoration
    : IFigure
{

/**
 * Sets the location of this figure.
 * @param p The location
 */
void setLocation(Point p);

/**
 * Sets the reference point used to determine the rotation angle.
 * @param p The reference point
 */
void setReferencePoint(Point p);

}
