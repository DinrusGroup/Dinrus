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
module dwtx.draw2d.text.TextLayout;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;

import dwtx.draw2d.text.FlowFigureLayout;
import dwtx.draw2d.text.TextFlow;
import dwtx.draw2d.text.TextFragmentBox;

/**
 * @author hudsonr
 * @since 2.1
 */
public abstract class TextLayout : FlowFigureLayout {

/**
 * Creates a new TextLayout with the given TextFlow
 * @param flow The TextFlow
 */
public this(TextFlow flow) {
    super(flow);
}

/**
 * Reuses an existing <code>TextFragmentBox</code>, or creates a new one.
 * @param i the index
 * @param fragments the original list of fragments
 * @return a TextFragmentBox
 */
protected TextFragmentBox getFragment(int i, List fragments) {
    if (fragments.size() > i)
        return cast(TextFragmentBox)fragments.get(i);
    TextFragmentBox box = new TextFragmentBox(cast(TextFlow)getFlowFigure());
    fragments.add(box);
    return box;
}

}
