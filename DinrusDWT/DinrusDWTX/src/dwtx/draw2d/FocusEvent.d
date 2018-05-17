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
module dwtx.draw2d.FocusEvent;

import dwt.dwthelper.utils;
import dwtx.draw2d.IFigure;

/**
 * An event that occurs when an {@link dwtx.draw2d.IFigure} gains or loses focus.
 */
public class FocusEvent {

/** The figure losing focus */
public IFigure loser;
/** The figure gaining focus */
public IFigure gainer;

/**
 * Constructs a new FocusEvent.
 * @param loser the figure losing focus
 * @param gainer the figure gaining focus
 */
public this(IFigure loser, IFigure gainer) {
    this.loser = loser;
    this.gainer = gainer;
}

}
