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
module dwtx.draw2d.text.FlowContainerLayout;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;

import dwtx.draw2d.Figure;
import dwtx.draw2d.text.FlowFigureLayout;
import dwtx.draw2d.text.FlowBox;
import dwtx.draw2d.text.LineBox;
import dwtx.draw2d.text.FlowContext;
import dwtx.draw2d.text.FlowFigure;

/**
 * A layout for FlowFigures with children.
 *
 * <P>WARNING: This class is not intended to be subclassed by clients.
 * @author hudsonr
 * @since 2.1
 */
public abstract class FlowContainerLayout
    : FlowFigureLayout
    , FlowContext
{

/**
 * the current line
 */
LineBox currentLine;

/**
 * @see dwtx.draw2d.text.FlowFigureLayout#FlowFigureLayout(FlowFigure)
 */
protected this(FlowFigure flowFigure) {
    super(flowFigure);
}

/**
 * Adds the given box the current line and clears the context's state.
 * @see dwtx.draw2d.text.FlowContext#addToCurrentLine(FlowBox)
 */
public void addToCurrentLine(FlowBox child) {
    getCurrentLine().add(child);
    setContinueOnSameLine(false);
}

/**
 * Flush anything pending and free all temporary data used during layout.
 */
protected void cleanup() {
    currentLine = null;
}

/**
 * Used by getCurrentLine().
 */
protected abstract void createNewLine();

/**
 * Called after {@link #layoutChildren()} when all children have been laid out. This
 * method exists to flush the last line.
 */
protected abstract void flush();

/**
 * FlowBoxes shouldn't be added directly to the current line.  Use
 * {@link #addToCurrentLine(FlowBox)} for that.
 * @see dwtx.draw2d.text.FlowContext#getCurrentLine()
 */
LineBox getCurrentLine() {
    if (currentLine is null)
        createNewLine();
    return currentLine;
}

/**
 * @see FlowContext#getRemainingLineWidth()
 */
public int getRemainingLineWidth() {
    return getCurrentLine().getAvailableWidth();
}

/**
 * @see FlowContext#isCurrentLineOccupied()
 */
public bool isCurrentLineOccupied() {
    return currentLine !is null && currentLine.isOccupied();
}

/**
 * @see FlowFigureLayout#layout()
 */
protected void layout() {
    preLayout();
    layoutChildren();
    flush();
    cleanup();
}

/**
 * Layout all children.
 */
protected void layoutChildren() {
    List children = getFlowFigure().getChildren();
    for (int i = 0; i < children.size(); i++) {
        Figure f = cast(Figure)children.get(i);
        if (forceChildInvalidation(f))
            f.invalidate();
        f.validate();
    }
}

bool forceChildInvalidation(Figure f) {
    return true;
}

/**
 * Called before layoutChildren() to setup any necessary state.
 */
protected abstract void preLayout();

}
