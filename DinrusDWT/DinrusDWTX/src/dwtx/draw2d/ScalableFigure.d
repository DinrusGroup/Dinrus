/*******************************************************************************
 * Copyright (c) 2003, 2005 IBM Corporation and others.
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
module dwtx.draw2d.ScalableFigure;

import dwt.dwthelper.utils;
import dwtx.draw2d.IFigure;

/**
 * A figure that can be scaled.
 * @author Eric Bordeau
 * @since 2.1.1
 */
public interface ScalableFigure : IFigure {

/**
 * Returns the current scale.
 * @return the current scale
 */
double getScale();

/**
 * Sets the new scale factor.
 * @param scale the scale
 */
void setScale(double scale);

}
