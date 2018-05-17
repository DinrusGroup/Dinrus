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
module dwtx.draw2d.graph.CompoundVerticalPlacement;

import dwt.dwthelper.utils;
import dwtx.draw2d.graph.DirectedGraph;
import dwtx.draw2d.graph.VerticalPlacement;
import dwtx.draw2d.graph.CompoundDirectedGraph;
import dwtx.draw2d.graph.Subgraph;

/**
 * calculates the height and y-coordinates for nodes and subgraphs in a compound directed
 * graph.
 * @author Randy Hudson
 * @since 2.1.2
 */
class CompoundVerticalPlacement : VerticalPlacement {

/**
 * @see GraphVisitor#visit(DirectedGraph)
 * Extended to set subgraph values.
 */
void visit(DirectedGraph dg) {
    CompoundDirectedGraph g = cast(CompoundDirectedGraph)dg;
    super.visit(g);
    for (int i = 0; i < g.subgraphs.size(); i++) {
        Subgraph s = cast(Subgraph)g.subgraphs.get(i);
        s.y = s.head.y;
        s.height = s.tail.height + s.tail.y - s.y;
    }
}

}
