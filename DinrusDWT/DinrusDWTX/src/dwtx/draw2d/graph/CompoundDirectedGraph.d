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
module dwtx.draw2d.graph.CompoundDirectedGraph;

import dwt.dwthelper.utils;
import dwtx.draw2d.graph.DirectedGraph;
import dwtx.draw2d.graph.NodeList;
import dwtx.draw2d.graph.EdgeList;

/**
 * A <code>DirectedGraph</code> whose Nodes may be compound {@link Subgraph}s, which may
 * contain other nodes. Any node in the graph may be parented by one subgraph. Since
 * subgraphs are nodes, the source or target end of an {@link Edge} may be a subgraph.
 * For additional restrictions, refer to the JavaDoc for the layout algorithm being used.
 * <P>
 * A CompoundDirectedGraph is passed to a graph layout, which will position all of the
 * nodes, subgraphs, and edges in that graph.  This class serves as the data structure for
 * a layout algorithm.
 *
 * @author Randy Hudson
 * @since 2.1.2
 */
public class CompoundDirectedGraph : DirectedGraph {

/**
 * For internal use only.
 */
public NodeList subgraphs;

/**
 * For internal use only.
 */
public EdgeList containment;

public this(){
    subgraphs = new NodeList();
    containment = new EdgeList();
}

}
