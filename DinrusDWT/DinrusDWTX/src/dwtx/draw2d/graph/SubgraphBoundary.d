/*******************************************************************************
 * Copyright (c) 2003, 2005 IBM Corporation and others.
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
module dwtx.draw2d.graph.SubgraphBoundary;

import dwt.dwthelper.utils;
import tango.text.convert.Format;

import dwtx.draw2d.geometry.Insets;
import dwtx.draw2d.graph.Node;
import dwtx.draw2d.graph.Subgraph;

/**
 * For INTERNAL use only.
 * @author hudsonr
 * @since 2.1.2
 */
class SubgraphBoundary : Node {

/**
 * constant indicating TOP.
 */
public static const int TOP = 0;

/**
 * constant indicating LEFT.
 */
public static const int LEFT = 1;

/**
 * constant indicating BOTTOM.
 */
public static const int BOTTOM = 2;

/**
 * constant indicating RIGHT.
 */
public static const int RIGHT = 3;

/**
 * Constructs a new boundary.
 * @param s the subgraph
 * @param p the padding
 * @param side which side
 */
public this(Subgraph s, Insets p, int side) {
    super(null, s);
    this.width = s.width;
    this.height = s.height;
    this.padding = new Insets();
    switch (side) {
        case LEFT :
            width = s.insets.left;
            y = s.y;
            padding.left = p.left;
            padding.right = s.innerPadding.left;
            padding.top = padding.bottom = 0;
            setParent(s.getParent());
            data = stringcast(Format("left({})", s )); //$NON-NLS-1$ //$NON-NLS-2$
            break;
        case RIGHT :
            width = s.insets.right;
            y = s.y;
            padding.right = p.right;
            padding.left = s.innerPadding.right;
            padding.top = padding.bottom = 0;
            setParent(s.getParent());
            data = stringcast(Format("right({})", s )); //$NON-NLS-1$ //$NON-NLS-2$
            break;
        case TOP :
            height = s.insets.top;
            //$TODO width of head/tail should be 0
            width = 5;
            padding.top = p.top;
            padding.bottom = s.innerPadding.top;
            padding.left = padding.right = 0;
            data = stringcast(Format("top({})", s )); //$NON-NLS-1$ //$NON-NLS-2$
            break;
        case BOTTOM :
            height = s.insets.bottom;
            //$TODO width of head/tail should be 0
            width = 5;
            padding.top = s.innerPadding.bottom;
            padding.bottom = p.bottom;
            padding.left = padding.right = 0;
            data = stringcast(Format("bottom({})", s )); //$NON-NLS-1$ //$NON-NLS-2$
            break;
        default:
    }
}

}
