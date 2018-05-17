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
module dwtx.draw2d.text.LineBox;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;
import dwtx.draw2d.text.CompositeBox;
import dwtx.draw2d.text.FlowBox;

/**
 * @author hudsonr
 * @since 2.1
 */
public abstract class LineBox
    : CompositeBox
{

/**
 * The maximum ascent of all contained fragments.
 */
int contentAscent;

/**
 * The maximum descent of all contained fragments.
 */
int contentDescent;

List fragments;

public this(){
    fragments = new ArrayList();
}

/**
 * @see dwtx.draw2d.text.CompositeBox#add(dwtx.draw2d.text.FlowBox)
 */
public void add(FlowBox child) {
    fragments.add(child);
    width += child.getWidth();
    contentAscent = Math.max(contentAscent, child.getOuterAscent());
    contentDescent = Math.max(contentDescent, child.getOuterDescent());
}

/**
 * @see dwtx.draw2d.text.FlowBox#getAscent()
 */
public int getAscent() {
    int ascent = 0;
    for (int i = 0; i < fragments.size(); i++)
        ascent = Math.max(ascent, (cast(FlowBox)fragments.get(i)).getAscent());
    return ascent;
}

/**
 * Returns the remaining width available for line content.
 * @return the available width in pixels
 */
int getAvailableWidth() {
    if (recommendedWidth < 0)
        return Integer.MAX_VALUE;
    return recommendedWidth - getWidth();
}

int getBottomMargin() {
    return 0;
}

/**
 * @see dwtx.draw2d.text.FlowBox#getDescent()
 */
public int getDescent() {
    int descent = 0;
    for (int i = 0; i < fragments.size(); i++)
        descent = Math.max(descent, (cast(FlowBox)fragments.get(i)).getDescent());
    return descent;
}

/**
 * @return Returns the fragments.
 */
List getFragments() {
    return fragments;
}

int getTopMargin() {
    return 0;
}

/**
 * @return <code>true</code> if this box contains any fragments
 */
public bool isOccupied() {
    return !fragments.isEmpty();
}

/**
 * @see dwtx.draw2d.text.FlowBox#requiresBidi()
 */
public bool requiresBidi() {
    for (Iterator iter = getFragments().iterator(); iter.hasNext();) {
        FlowBox box = cast(FlowBox)iter.next();
        if (box.requiresBidi())
            return true;
    }
    return false;
}

}
