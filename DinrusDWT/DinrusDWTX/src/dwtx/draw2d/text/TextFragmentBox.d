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
module dwtx.draw2d.text.TextFragmentBox;

import dwt.dwthelper.utils;
import dwtx.draw2d.text.ContentBox;
import dwtx.draw2d.text.TextFlow;
import dwtx.draw2d.text.FlowUtilities;
import tango.text.convert.Format;

/**
 * A Geometric object for representing a TextFragment region on a line of Text.
 */
public class TextFragmentBox
    : ContentBox
{

/**
 * The fragment's length in characters.
 */
public int length;

/**
 * The character offset at which this fragment begins.
 */
public int offset;

private TextFlow textflow;
private bool truncated;

/**
 * Creates a new TextFragmentBox for the given text flow.
 * @param textflow the text flow
 */
public this(TextFlow textflow) {
    this.textflow = textflow;
}

/**
 * @see dwtx.draw2d.text.FlowBox#containsPoint(int, int)
 */
public bool containsPoint(int x, int y) {
    return x >= getX()
        && x < getX() + getWidth()
        && y >= getBaseline() - getAscentWithBorder()
        && y <= getBaseline() + getDescentWithBorder();
}

/**
 * Returns the textflow's font's ascent. The ascent is the same for all fragments in a
 * given TextFlow.
 * @return the ascent
 */
public int getAscent() {
    return textflow.getAscent();
}

int getAscentWithBorder() {
    return textflow.getAscent() + FlowUtilities.getBorderAscent(textflow);
}

/**
 * Returns the textflow's font's descent. The descent is the same for all fragments in a
 * given TextFlow.
 * @return the descent
 */
public int getDescent() {
    return textflow.getDescent();
}

int getDescentWithBorder() {
    return textflow.getDescent() + FlowUtilities.getBorderDescent(textflow);
}

int getOuterAscent() {
    return textflow.getAscent() + FlowUtilities.getBorderAscentWithMargin(textflow);
}

int getOuterDescent() {
    return textflow.getDescent() + FlowUtilities.getBorderDescentWithMargin(textflow);
}

final int getTextTop() {
    return getBaseline() - getAscent();
}

/**
 * Returns <code>true</code> if the bidi level is odd.  Right to left fragments should be
 * queried and rendered with the RLO control character inserted in front.
 * @return <code>true</code> if right-to-left
 * @since 3.1
 */
public bool isRightToLeft() {
    // -1 % 2 is -1
    return getBidiLevel() % 2 is 1;
}

/**
 * Returns <code>true</code> if the fragment should be rendered as truncated.
 * @return <code>true</code> if the fragment is truncated
 * @since 3.1
 */
public bool isTruncated() {
    return truncated;
}

/**
 * Marks the fragment as having been truncated.
 * @param value <code>true</code> if the fragment is truncated
 * @since 3.1
 */
public void setTruncated(bool value) {
    this.truncated = value;
}

/**
 * @see java.lang.Object#toString()
 */
public String toString() {
    return Format("[{}, {}) = \"{}\"",offset, (offset + length), //$NON-NLS-1$ //$NON-NLS-2$
        textflow.getText().substring(offset, offset + length) ); //$NON-NLS-1$
}

}
