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
module dwtx.draw2d.text.BlockFlow;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;

import dwt.DWT;
import dwtx.draw2d.ColorConstants;
import dwtx.draw2d.Graphics;
import dwtx.draw2d.IFigure;
import dwtx.draw2d.PositionConstants;
import dwtx.draw2d.geometry.Insets;
import dwtx.draw2d.geometry.Rectangle;
import dwtx.draw2d.text.FlowFigure;
import dwtx.draw2d.text.BlockBox;
import dwtx.draw2d.text.BidiProcessor;
import dwtx.draw2d.text.FlowFigureLayout;
import dwtx.draw2d.text.BidiChars;
import dwtx.draw2d.text.BlockFlowLayout;
import dwtx.draw2d.text.FlowBorder;

/**
 * A <code>FlowFigure</code> represented by a single {@link BlockBox} containing one or
 * more lines. A BlockFlow is a creator of LineBoxes, which its children require during
 * layout. A BlockFlow can be thought of as a foundation for a paragraph.
 * <P>
 * BlockFlows must be parented by a <code>FlowFigure</code>. {@link FlowPage} can be
 * used as a "root" block and can be parented by normal Figures.
 * <P>
 * Only {@link FlowFigure}s can be added to a BlockFlow.
 * <P>
 * WARNING: This class is not intended to be subclassed by clients.
 * @author hudsonr
 * @since 2.1
 */
public class BlockFlow
    : FlowFigure
{

private const BlockBox blockBox;
private int alignment = PositionConstants.NONE;
private int orientation = DWT.NONE;
private bool bidiValid;

/**
 * Constructs a new BlockFlow.
 */
public this() {
    blockBox = createBlockBox();
}

/**
 * BlockFlows contribute a paragraph separator so as to keep the Bidi state of the text
 * on either side of this block from affecting each other.  Since each block is like a
 * different paragraph, it does not contribute any actual text to its containing block.
 *
 * @see dwtx.draw2d.text.FlowFigure#contributeBidi(dwtx.draw2d.text.BidiProcessor)
 */
protected void contributeBidi(BidiProcessor proc) {
    proc.addControlChar(BidiChars.P_SEP);
}

BlockBox createBlockBox() {
    return new BlockBox(this);
}

/**
 * @see dwtx.draw2d.text.FlowFigure#createDefaultFlowLayout()
 */
protected FlowFigureLayout createDefaultFlowLayout() {
    return new BlockFlowLayout(this);
}

/**
 * Returns the BlockBox associated with this.
 * @return This BlockFlow's BlockBox
 */
protected BlockBox getBlockBox() {
    return blockBox;
}
package BlockBox getBlockBox_package() {
    return getBlockBox();
}

int getBottomMargin() {
    int margin = 0;
    if (auto border = cast(FlowBorder)getBorder() ) {
        return border.getBottomMargin();
    }
    List children = getChildren();
    int childIndex = children.size() - 1;
    if (childIndex >= 0 && null !is cast(BlockFlow)children.get(childIndex) ) {
        margin = Math.max(margin,
                (cast(BlockFlow)children.get(childIndex)).getBottomMargin());
    }
    return margin;
}

/**
 * Returns the effective horizontal alignment. This method will never return {@link
 * PositionConstants#NONE}. If the value is none, it will return the inherited alignment.
 * If no alignment was inherited, it will return the default alignment ({@link
 * PositionConstants#LEFT}).
 * @return the effective alignment
 */
public int getHorizontalAligment() {
    if (alignment !is PositionConstants.NONE)
        return alignment;
    IFigure parent = getParent();
    while (parent !is null && !( null !is cast(BlockFlow)parent ))
        parent = parent.getParent();
    if (parent !is null)
        return (cast(BlockFlow)parent).getHorizontalAligment();
    return PositionConstants.LEFT;
}

int getLeftMargin() {
    if ( auto b = cast(FlowBorder)getBorder() )
        return b.getLeftMargin();
    return 0;
}

/**
 * Returns the orientation set on this block.
 * @return LTR, RTL or NONE
 * @see #setOrientation(int)
 * @since 3.1
 */
public int getLocalOrientation() {
    return orientation;
}

/**
 * Returns the horizontal alignment set on this block.
 * @return LEFT, RIGHT, ALWAYS_LEFT, ALWAYS_RIGHT, NONE
 * @see #setHorizontalAligment(int)
 * @since 3.1
 */
public int getLocalHorizontalAlignment() {
    return alignment;
}

/**
 * Returns this block's Bidi orientation.  If none was set on this block, it
 * will inherit the one from its containing block.  If there is no containing block, it
 * will return the default orientation (DWT.RIGHT_TO_LEFT if mirrored; DWT.LEFT_TO_RIGHT
 * otherwise).
 *
 * @return DWT.RIGHT_TO_LEFT or DWT.LEFT_TO_RIGHT
 * @see #setOrientation(int)
 * @since 3.1
 */
public int getOrientation() {
    if (orientation !is DWT.NONE)
        return orientation;
    IFigure parent = getParent();
    while (parent !is null && !(null !is cast(BlockFlow)parent ))
        parent = parent.getParent();
    if (parent !is null)
        return (cast(BlockFlow)parent).getOrientation();
    return isMirrored() ? DWT.RIGHT_TO_LEFT : DWT.LEFT_TO_RIGHT;
}

int getRightMargin() {
    if (auto b = cast(FlowBorder)getBorder() )
        return b.getRightMargin();
    return 0;
}

int getTopMargin() {
    int margin = 0;
    if (auto border = cast(FlowBorder)getBorder() ) {
        return border.getTopMargin();
    }
    List children = getChildren();
    if (children.size() > 0 && null !is cast(BlockFlow)children.get(0) ) {
        margin = Math.max(margin,
                (cast(BlockFlow)children.get(0)).getTopMargin());
    }
    return margin;
}

/**
 * @see dwtx.draw2d.Figure#paintBorder(dwtx.draw2d.Graphics)
 */
public void paintBorder(Graphics graphics) {
    if ( auto b = cast(FlowBorder)getBorder() ) {
        Rectangle where = getBlockBox().toRectangle();
        where.crop(new Insets(getTopMargin(), getLeftMargin(),
                getBottomMargin(), getRightMargin()));
        (cast(FlowBorder)getBorder()).paint(this, graphics, where, DWT.LEAD | DWT.TRAIL);
    } else
        super.paintBorder(graphics);
    if (selectionStart !is -1) {
        graphics.restoreState();
        graphics.setXORMode(true);
        graphics.setBackgroundColor(ColorConstants.white);
        graphics.fillRectangle(getBounds());
    }
}

/**
 * @see dwtx.draw2d.text.FlowFigure#postValidate()
 */
public void postValidate() {
    Rectangle newBounds = getBlockBox().toRectangle();
    newBounds.crop(new Insets(getTopMargin(), getLeftMargin(),
            getBottomMargin(), getRightMargin()));
    setBounds(newBounds);
}

/**
 * @see FlowFigure#revalidate()
 */
public void revalidate() {
    BlockFlowLayout layout = cast(BlockFlowLayout)getLayoutManager();
    layout.blockContentsChanged();
    super.revalidate();
}

/**
 * A Block will invalidate the Bidi state of all its children, so that it is
 * re-evaluated when this block is next validated.
 * @see dwtx.draw2d.text.FlowFigure#revalidateBidi(dwtx.draw2d.IFigure)
 */
protected void revalidateBidi(IFigure origin) {
    if (bidiValid) {
        bidiValid = false;
        revalidate();
    }
}

/**
 * Sets the horitontal aligment of the block. Valid values are:
 * <UL>
 *   <LI>{@link PositionConstants#NONE NONE} - (default) Alignment is inherited from
 *   parent.  If a parent is not found then LEFT is used.</LI>
 *   <LI>{@link PositionConstants#LEFT} - Alignment is with leading edge</LI>
 *   <LI>{@link PositionConstants#RIGHT} - Alignment is with trailing edge</LI>
 *   <LI>{@link PositionConstants#CENTER}</LI>
 *   <LI>{@link PositionConstants#ALWAYS_LEFT} - Left, irrespective of orientation</LI>
 *   <LI>{@link PositionConstants#ALWAYS_RIGHT} - Right, irrespective of orientation</LI>
 * </UL>
 * @param value the aligment
 * @see #getHorizontalAligment()
 */
public void setHorizontalAligment(int value) {
    value &= PositionConstants.LEFT | PositionConstants.CENTER | PositionConstants.RIGHT
        | PositionConstants.ALWAYS_LEFT | PositionConstants.ALWAYS_RIGHT;
    if (value is alignment)
        return;
    alignment = value;
    revalidate();
}

/**
 * Sets the orientation for this block.  Orientation can be one of:
 * <UL>
 *   <LI>{@link DWT#LEFT_TO_RIGHT}
 *   <LI>{@link DWT#RIGHT_TO_LEFT}
 *   <LI>{@link DWT#NONE} (default)
 * </UL>
 * <code>NONE</code> is used to indicate that orientation should be inherited from the
 * encompassing block.
 *
 * @param orientation LTR, RTL or NONE
 * @see #getOrientation()
 * @since 3.1
 */
public void setOrientation(int orientation) {
    orientation &= DWT.LEFT_TO_RIGHT | DWT.RIGHT_TO_LEFT;
    if (this.orientation is orientation)
        return;
    this.orientation = orientation;
    revalidateBidi(this);
}

/**
 * @see dwtx.draw2d.Figure#useLocalCoordinates()
 */
protected bool useLocalCoordinates() {
    return true;
}

/**
 * Re-evaluate the Bidi state of all the fragments if it has been
 * invalidated.
 * @see dwtx.draw2d.IFigure#validate()
 */
public void validate() {
    if (!bidiValid) {
        BidiProcessor.INSTANCE.setOrientation(getOrientation());
        if (getOrientation() is DWT.LEFT_TO_RIGHT && isMirrored())
            BidiProcessor.INSTANCE.addControlChar(BidiChars.LRE);
        super.contributeBidi(BidiProcessor.INSTANCE);
        BidiProcessor.INSTANCE.process();
        bidiValid = true;
    }
    super.validate();
}

}
