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
module dwtx.draw2d.FigureListener;

import dwt.dwthelper.utils;
import dwtx.draw2d.IFigure;

/**
 * A listener interface for receiving notification that an IFigure has moved.
 */
public interface FigureListener {

/**
 * Called when the given IFigure has moved.
 * @param source The IFigure that has moved.
 */
void figureMoved(IFigure source);

}
