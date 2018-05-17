/*******************************************************************************
 * Copyright (c) 2004, 2005 IBM Corporation and others.
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

module dwtx.draw2d.text.FlowBorder;

import dwt.dwthelper.utils;

import dwtx.draw2d.Border;
import dwtx.draw2d.Graphics;
import dwtx.draw2d.geometry.Rectangle;
import dwtx.draw2d.text.FlowFigure;

/**
 * Experimental API. This is a special type of border for use with {@link
 * dwtx.draw2d.text.FlowFigure}s. This interface should not be implemented by
 * clients. Clients should extend {@link dwtx.draw2d.text.AbstractFlowBorder}.
 * @since 3.1
 */
public interface FlowBorder : Border {

/**
 * Returns the collapsable bottom margin in pixels. Margin is the space external to the
 * border and the flow box on which it is rendered. Vertical margins (top and bottom) may
 * collapse in some situations, such as adjacent or nested blocks.
 * @return the bottom margin
 * @since 3.1
 */
int getBottomMargin();

/**
 * Returns the left margin in pixels. Margin is the space external to the border and the
 * flow box on which it is rendered.
 * @return the left margin
 * @since 3.1
 */
int getLeftMargin();

/**
 * Returns the right margin in pixels. Margin is the space external to the border and the
 * flow box on which it is rendered.
 * @return the right margin
 * @since 3.1
 */
int getRightMargin();

/**
 * Returns the collapsable top margin in pixels. Margin is the space external to the
 * border and the flow box on which it is rendered. Vertical margins (top and bottom) may
 * collapse in some situations, such as adjacent or nested blocks.
 * @return the top margin
 * @since 3.1
 */
int getTopMargin();

/**
 * Paints the border around the given box location. The border is asked to paint each of
 * the FlowFigure's boxes. The <code>sideInfo</code> parameter is used to indicate whether
 * the left and right sides should be rendered. This parameter will contain the following
 * bit flags:
 * <UL>
 *   <LI>{@link dwt.DWT#LEAD}
 *   <LI>{@link dwt.DWT#TRAIL}
 *   <LI>{@link dwt.DWT#RIGHT_TO_LEFT}
 * </UL>
 * @param figure the flow figure whose border is being painted
 * @param g the graphics
 * @param where the relative location of the box
 * @param sides bits indicating sides and bidi orientation
 * @since 3.1
 */
void paint(FlowFigure figure, Graphics g, Rectangle where, int sides);

}
