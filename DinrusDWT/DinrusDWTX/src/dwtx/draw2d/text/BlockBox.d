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
module dwtx.draw2d.text.BlockBox;

import dwt.dwthelper.utils;

import dwtx.draw2d.geometry.Rectangle;
import dwtx.draw2d.text.CompositeBox;
import dwtx.draw2d.text.BlockFlow;
import dwtx.draw2d.text.LineRoot;
import dwtx.draw2d.text.FlowBox;

/**
 * A CompositeBox suitable for containing multiple LineBox fragments.
 * @author hudsonr
 * @since 2.1
 */
public class BlockBox
    : CompositeBox
{

int height;
private int y;
BlockFlow owner;

this(BlockFlow owner) {
    this.owner = owner;
}

/**
 * @see CompositeBox#add(FlowBox)
 */
public void add(FlowBox box) {
    width = Math.max(width, box.getWidth());
    height = Math.max(height, box.getBaseline() + box.getDescent());
}

/**
 * @see FlowBox#containsPoint(int, int)
 */
public bool containsPoint(int x, int y) {
    return true;
}

/**
 * @see FlowBox#getAscent()
 */
public int getAscent() {
    return 0;
}

/**
 * @see FlowBox#getBaseline()
 */
public int getBaseline() {
    return y;
}

int getBottomMargin() {
    return owner.getBottomMargin();
}

/**
 * @see FlowBox#getDescent()
 */
public int getDescent() {
    return height;
}

/**
 * @return Returns the height.
 */
public int getHeight() {
    return height;
}

LineRoot getLineRoot() {
    return null;
}

int getTopMargin() {
    return owner.getTopMargin();
}

/**
 * Sets the height.
 * @param h The height
 */
public void setHeight(int h) {
    height = h;
}

/**
 * @see CompositeBox#setLineTop(int)
 */
public void setLineTop(int y) {
    this.y = y;
}

Rectangle toRectangle() {
    return new Rectangle(getX(), y, Math.max(getWidth(), recommendedWidth), height);
}

}
