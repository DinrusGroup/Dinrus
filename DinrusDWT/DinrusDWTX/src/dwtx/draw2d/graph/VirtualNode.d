/*******************************************************************************
 * Copyright (c) 2003, 2008 IBM Corporation and others.
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
module dwtx.draw2d.graph.VirtualNode;

import dwt.dwthelper.utils;
import tango.text.convert.Format;

import dwtx.draw2d.geometry.Insets;
import dwtx.draw2d.graph.Node;
import dwtx.draw2d.graph.Edge;
import dwtx.draw2d.graph.Subgraph;

/**
 * @deprecated virtual nodes of an edge should be cast to Node.
 * @author Randy Hudson
 * @since 2.1.2
 */
public class VirtualNode : Node {

/**
 * The next node.
 */
public Node next;

/**
 * The previous node.
 */
public Node prev;

/**
 * Constructs a virtual node.
 * @deprecated This class is for internal use only.
 * @param e the edge
 * @param i the row
 */
public this(Edge e, int i) {
    super(e);
    incoming.add(e);
    outgoing.add(e);
    width = e.width;
    height = 0;
    rank = i;
    setPadding(new Insets(0, e.padding, 0, e.padding));
}

/**
 * Constructor.
 * @param o object
 * @param parent subgraph
 */
public this(Object o, Subgraph parent) {
    super(o, parent);
}

/**
 * Returns the index of {@link #prev}.
 * @return median
 */
public double medianIncoming() {
    return prev.index;
}

/**
 * Returns the index of {@link #next}.
 * @return outgoing
 */
public double medianOutgoing() {
    return next.index;
}

/**
 * For internal use only.  Returns the original edge weight multiplied by the omega value
 * for the this node and the node on the previous rank.
 * @return the weighted weight, or omega
 */
public int omega() {
    Edge e = cast(Edge)data;
    if (e.source.rank + 1 < rank  && rank < e.target.rank)
        return 8 * e.weight;
    return 2 * e.weight;
}

/**
 * @see java.lang.Object#toString()
 */
public String toString() {
    if (auto edge = cast(Edge)data )
        return Format("VN[{}]({})", (edge.vNodes.indexOf(this) + 1) //$NON-NLS-1$
                , data ); //$NON-NLS-1$ //$NON-NLS-2$
    return super.toString();
}

}
