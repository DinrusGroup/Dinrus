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
module dwtx.draw2d.text.InlineFlowLayout;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;
import dwtx.draw2d.text.FlowContainerLayout;
import dwtx.draw2d.text.FlowFigure;
import dwtx.draw2d.text.LineBox;
import dwtx.draw2d.text.CompositeBox;
import dwtx.draw2d.text.NestedLine;
import dwtx.draw2d.text.InlineFlow;

/**
 * The layout manager for {@link InlineFlow} figures.
 *
 * <P>WARNING: This class is not intended to be subclassed by clients.
 * @author hudsonr
 * @since 2.1
 */
public class InlineFlowLayout
    : FlowContainerLayout
{

/**
 * Creates a new InlineFlowLayout with the given FlowFigure.
 * @param flow The FlowFigure
 */
public this(FlowFigure flow) {
    super(flow);
}

/**
 * Adds the given box as a line below the current line.
 * @param box the box to add
 */
public void addLine(CompositeBox box) {
    endLine();
    getContext().addLine(box);
}

/**
 * @see FlowContainerLayout#createNewLine()
 */
protected void createNewLine() {
    currentLine = new NestedLine(cast(InlineFlow)getFlowFigure());
    setupLine(currentLine);
}

/**
 * @see FlowContext#endLine()
 */
public void endLine() {
    flush();
    getContext().endLine();
}

/**
 * @see FlowContainerLayout#flush()
 */
protected void flush() {
    if (currentLine !is null && currentLine.isOccupied()) {
        // We want to preserve the state when a linebox is being added
        bool sameLine = getContext().getContinueOnSameLine();
        getContext().addToCurrentLine(currentLine);
        (cast(InlineFlow)getFlowFigure()).getFragments().add(currentLine);
        currentLine = null;
        getContext().setContinueOnSameLine(sameLine);
    }
}

/**
 * InlineFlowLayout gets this information from its context.
 * @see FlowContext#getContinueOnSameLine()
 */
public bool getContinueOnSameLine() {
    return getContext().getContinueOnSameLine();
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

    getContext().getWidthLookahead(getFlowFigure(), result);
}

/**
 * @see FlowContainerLayout#isCurrentLineOccupied()
 */
public bool isCurrentLineOccupied() {
    return (currentLine !is null && !currentLine.getFragments().isEmpty())
        || getContext().isCurrentLineOccupied();
}

/**
 * Clears out all fragments prior to the call to layoutChildren().
 */
public void preLayout() {
    (cast(InlineFlow)getFlowFigure()).getFragments().clear();
}

/**
 * InlineFlow passes this information to its context.
 * @see FlowContext#setContinueOnSameLine(bool)
 */
public void setContinueOnSameLine(bool value) {
    getContext().setContinueOnSameLine(value);
}

/**
 * Initializes the given LineBox. Called by createNewLine().
 * @param line The LineBox to initialize.
 */
protected void setupLine(LineBox line) {
    line.setX(0);
    line.setRecommendedWidth(getContext().getRemainingLineWidth());
}

}
