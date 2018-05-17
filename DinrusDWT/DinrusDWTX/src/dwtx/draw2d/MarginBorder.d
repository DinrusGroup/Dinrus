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
module dwtx.draw2d.MarginBorder;

import dwt.dwthelper.utils;

import dwtx.draw2d.geometry.Insets;
import dwtx.draw2d.AbstractBorder;
import dwtx.draw2d.IFigure;
import dwtx.draw2d.Graphics;

/**
 * A border that provides blank padding.
 */
public class MarginBorder
    : AbstractBorder
{

/**
 * This border's insets.
 */
protected Insets insets;

/**
 * Constructs a MarginBorder with dimensions specified by <i>insets</i>.
 *
 * @param insets The Insets for the border
 * @since 2.0
 */
public this(Insets insets) {
    this.insets = insets;
}

/**
 * Constructs a MarginBorder with padding specified by the passed values.
 *
 * @param t Top padding
 * @param l Left padding
 * @param b Bottom padding
 * @param r Right padding
 * @since 2.0
 */
public this(int t, int l, int b, int r) {
    this(new Insets(t, l, b, r));
}

/**
 * Constructs a MarginBorder with equal padding on all sides.
 *
 * @param allsides Padding size for all sides of the border.
 * @since 2.0
 */
public this(int allsides) {
    this(new Insets(allsides));
}
/**
 * @see dwtx.draw2d.Border#getInsets(IFigure)
 */
public Insets getInsets(IFigure figure) {
    return insets;
}

/**
 * This method does nothing, since this border is just for spacing.
 * @see dwtx.draw2d.Border#paint(IFigure, Graphics, Insets)
 */
public void paint(IFigure figure, Graphics graphics, Insets insets) { }

}
