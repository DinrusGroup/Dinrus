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
module dwtx.draw2d.text.BlockFlowLayout;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;

import dwt.DWT;
import dwtx.draw2d.Figure;
import dwtx.draw2d.PositionConstants;
import dwtx.draw2d.geometry.Insets;
import dwtx.draw2d.text.FlowContainerLayout;
import dwtx.draw2d.text.BlockBox;
import dwtx.draw2d.text.BlockFlow;
import dwtx.draw2d.text.CompositeBox;
import dwtx.draw2d.text.FlowFigure;
import dwtx.draw2d.text.LineRoot;

/**
 * The layout for {@link BlockFlow} figures.
 *
 * <P>WARNING: This class is not intended to be subclassed by clients.
 * @author hudsonr
 * @since 2.1
 */
public class BlockFlowLayout
    : FlowContainerLayout
{

BlockBox blockBox;
bool blockInvalid = false;
private bool continueOnSameLine = false;
private CompositeBox previousLine = null;

/**
 * Creates a new BlockFlowLayout with the given BlockFlow.
 * @param blockFlow the BlockFlow
 */
public this(BlockFlow blockFlow) {
    super(blockFlow);
}

private void addBelowPreviousLine(CompositeBox line) {
    if (previousLine is null)
        line.setLineTop(line.getTopMargin());
    else
        line.setLineTop(previousLine.getBaseline() + previousLine.getDescent()
                + Math.max(previousLine.getBottomMargin(), line.getTopMargin()));

    int alignment = getBlockFlow().getHorizontalAligment();
    if (alignment is PositionConstants.LEFT || alignment is PositionConstants.RIGHT) {
        int orientation = getBlockFlow().getOrientation();
        if (alignment is PositionConstants.LEFT)
            alignment = orientation is DWT.LEFT_TO_RIGHT
                    ? PositionConstants.ALWAYS_LEFT : PositionConstants.ALWAYS_RIGHT;
        else
            alignment = orientation is DWT.LEFT_TO_RIGHT
                    ? PositionConstants.ALWAYS_RIGHT : PositionConstants.ALWAYS_LEFT;
    }
    if (alignment !is PositionConstants.CENTER && getBlockFlow().isMirrored())
        alignment = (PositionConstants.ALWAYS_LEFT | PositionConstants.ALWAYS_RIGHT)
                & ~alignment;

    switch (alignment) {
        case PositionConstants.ALWAYS_RIGHT:
            line.setX(blockBox.getRecommendedWidth() - line.getWidth());
            break;
        case PositionConstants.CENTER:
            line.setX((blockBox.getRecommendedWidth() - line.getWidth()) / 2);
            break;
        case PositionConstants.ALWAYS_LEFT:
            line.setX(0);
            break;
        default:
            throw new RuntimeException("Unexpected state"); //$NON-NLS-1$
    }
    blockBox.add(line);
    previousLine = line;
}

/**
 * Align the line horizontally and then commit it.
 */
protected void addCurrentLine() {
    addBelowPreviousLine(currentLine);
    (cast(LineRoot)currentLine).commit();
}

/**
 * @see FlowContext#addLine(CompositeBox)
 */
public void addLine(CompositeBox box) {
    endLine();
    addBelowPreviousLine(box);
}

/**
 * Marks the blocks contents as changed.  This means that children will be invalidated
 * during validation.
 * @since 3.1
 */
public void blockContentsChanged() {
    blockInvalid = true;
}

/**
 * @see FlowContainerLayout#cleanup()
 */
protected void cleanup() {
    super.cleanup();
    previousLine = null;
}

/**
 * @see FlowContainerLayout#createNewLine()
 */
protected void createNewLine() {
    currentLine = new LineRoot(getBlockFlow().isMirrored());
    currentLine.setRecommendedWidth(blockBox.getRecommendedWidth());
}

/**
 * Called by flush(), adds the BlockBox associated with this BlockFlowLayout
 * to the current line and then ends the line.
 */
protected void endBlock() {
    if (blockInvalid) {
        Insets insets = getBlockFlow().getInsets();
        blockBox.height += insets.getHeight();
        blockBox.width += insets.getWidth();
    }

    if (getContext() !is null)
        getContext().addLine(blockBox);

    if (blockInvalid) {
        blockInvalid = false;
        List v = getFlowFigure().getChildren();
        for (int i = 0; i < v.size(); i++)
            (cast(FlowFigure)v.get(i)).postValidate();
    }
}

/**
 * @see FlowContext#endLine()
 */
public void endLine() {
    if (currentLine is null || !currentLine.isOccupied())
        return;
    addCurrentLine();
    currentLine = null;
}

/**
 * @see FlowContainerLayout#flush()
 */
protected void flush() {
    endLine();
    endBlock();
}

bool forceChildInvalidation(Figure f) {
    return blockInvalid;
}

/**
 * Returns the BlockFlow associated with this BlockFlowLayout
 * @return the BlockFlow
 */
protected final BlockFlow getBlockFlow() {
    return cast(BlockFlow)getFlowFigure();
}

int getContextWidth() {
    return getContext().getRemainingLineWidth();
}

/**
 * @see FlowContext#getContinueOnSameLine()
 */
public bool getContinueOnSameLine() {
    return continueOnSameLine;
}

/**
 * @see FlowContext#getWidthLookahead(FlowFigure, int[])
 */
public void getWidthLookahead(FlowFigure child, int result[]) {
    List children = getFlowFigure().getChildren();
    int index = -1;
    if (child !is null)
        index = children.indexOf(child);

    for (int i = index + 1; i < children.size(); i++)
        if ((cast(FlowFigure)children.get(i)).addLeadingWordRequirements(result))
            return;
}

/**
 * @see FlowContainerLayout#preLayout()
 */
protected void preLayout() {
    setContinueOnSameLine(false);
    blockBox = getBlockFlow().getBlockBox_package();
    setupBlock();
    //Probably could setup current and previous line here, or just previous
}

/**
 * @see dwtx.draw2d.text.FlowContext#setContinueOnSameLine(bool)
 */
public void setContinueOnSameLine(bool value) {
    continueOnSameLine = value;
}

/**
 * sets up the single block that contains all of the lines.
 */
protected void setupBlock() {
    int recommended = getContextWidth();
    if (recommended is Integer.MAX_VALUE)
        recommended = -1;
    BlockFlow bf = getBlockFlow();
    if (recommended > 0) {
        int borderCorrection = bf.getInsets().getWidth() + bf.getLeftMargin()
                + bf.getRightMargin();
        recommended = Math.max(0, recommended - borderCorrection);
    }

    if (recommended !is blockBox.recommendedWidth) {
        blockInvalid = true;
        blockBox.setRecommendedWidth(recommended);
    }

    if (blockInvalid) {
        blockBox.height = 0;
        blockBox.setWidth(Math.max(0, recommended));
    }
}

}
