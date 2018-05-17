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
module dwtx.draw2d.graph.CompoundPopulateRanks;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;
import dwtx.draw2d.graph.PopulateRanks;
import dwtx.draw2d.graph.DirectedGraph;
import dwtx.draw2d.graph.Subgraph;
import dwtx.draw2d.graph.CompoundDirectedGraph;
import dwtx.draw2d.graph.Edge;
import dwtx.draw2d.graph.NodeList;
import dwtx.draw2d.graph.Node;

/**
 * Places nodes into ranks for a compound directed graph.  If a subgraph spans a rank
 * without any nodes which belong to that rank, a bridge node is inserted to prevent nodes
 * from violating the subgraph boundary.
 * @author Randy Hudson
 * @since 2.1.2
 */
class CompoundPopulateRanks : PopulateRanks {

public void visit(DirectedGraph g) {
    CompoundDirectedGraph graph = cast(CompoundDirectedGraph)g;

    /**
     * Remove long containment edges at this point so they don't affect MinCross.
     */
    Iterator containment = graph.containment.iterator();
    while (containment.hasNext()) {
        Edge e = cast(Edge)containment.next();
        if (e.getSlack() > 0) {
            graph.removeEdge(e);
            containment.remove();
        }
    }

    super.visit(g);
    NodeList subgraphs = graph.subgraphs;
    for (int i = 0; i < subgraphs.size(); i++) {
        Subgraph subgraph = cast(Subgraph)subgraphs.get(i);
        bridgeSubgraph(subgraph, graph);
    }
}

/**
 * @param subgraph
 */
private void bridgeSubgraph(Subgraph subgraph, CompoundDirectedGraph g) {
    int offset = subgraph.head.rank;
    bool occupied[] = new bool[subgraph.tail.rank - subgraph.head.rank + 1];
    Node bridge[] = new Node[occupied.length];

    for (int i = 0; i < subgraph.members.size(); i++) {
        Node n = cast(Node)subgraph.members.get(i);
        if (auto s = cast(Subgraph)n ) {
            for (int r = s.head.rank; r <= s.tail.rank; r++)
                occupied[r - offset] = true;
        } else
            occupied[n.rank - offset] = true;
    }

    for (int i = 0; i < bridge.length; i++) {
        if (!occupied[i]) {
            Node br = bridge[i] = new Node(stringcast("bridge"), subgraph); //$NON-NLS-1$
            br.rank = i + offset;
            br.height = br.width = 0;
            br.nestingIndex = subgraph.nestingIndex;
            g.ranks.getRank(br.rank).add(br);
            g.nodes.add(br);
        }
    }
}

}
