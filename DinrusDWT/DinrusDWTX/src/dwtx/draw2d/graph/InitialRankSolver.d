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
module dwtx.draw2d.graph.InitialRankSolver;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;
import dwtx.draw2d.graph.GraphVisitor;
import dwtx.draw2d.graph.DirectedGraph;
import dwtx.draw2d.graph.NodeList;
import dwtx.draw2d.graph.Node;
import dwtx.draw2d.graph.EdgeList;
import dwtx.draw2d.graph.Edge;

/**
 * Assigns a valid rank assignment to all nodes based on their edges.  The assignment is
 * not optimal in that it does not provide the minimum global length of edge lengths.
 * @author Randy Hudson
 * @since 2.1.2
 */
class InitialRankSolver : GraphVisitor {

protected DirectedGraph graph;
protected EdgeList candidates;
protected NodeList members;

public this(){
    candidates = new EdgeList();
    members = new NodeList();
}

public void visit(DirectedGraph graph) {
    this.graph = graph;
    graph.edges.resetFlags(false);
    graph.nodes.resetFlags();
    solve();
}

protected void solve() {
    if (graph.nodes.size() is 0)
        return;
    NodeList unranked = new NodeList(graph.nodes);
    NodeList rankMe = new NodeList();
    Node node;
    int i;
    while (!unranked.isEmpty()) {
        rankMe.clear();
        for (i = 0; i < unranked.size();) {
            node = unranked.getNode(i);
            if (node.incoming.isCompletelyFlagged()) {
                rankMe.add(node);
                unranked.remove(i);
            } else
                i++;
        }
        if (rankMe.size() is 0)
            throw new RuntimeException("Cycle detected in graph"); //$NON-NLS-1$
        for (i = 0; i < rankMe.size(); i++) {
            node = rankMe.getNode(i);
            assignMinimumRank(node);
            node.outgoing.setFlags(true);
        }
    }

    connectForest();
}

private void connectForest() {
    List forest = new ArrayList();
    Stack stack = new Stack();
    NodeList tree;
    graph.nodes.resetFlags();
    for (int i = 0; i < graph.nodes.size(); i++) {
        Node neighbor, n = graph.nodes.getNode(i);
        if (n.flag)
            continue;
        tree = new NodeList();
        stack.push(n);
        while (!stack.isEmpty()) {
            n = cast(Node) stack.pop();
            n.flag = true;
            tree.add(n);
            for (int s = 0; s < n.incoming.size(); s++) {
                neighbor = n.incoming.getEdge(s).source;
                if (!neighbor.flag)
                    stack.push(neighbor);
            }
            for (int s = 0; s < n.outgoing.size(); s++) {
                neighbor = n.outgoing.getEdge(s).target;
                if (!neighbor.flag)
                    stack.push(neighbor);
            }
        }
        forest.add(tree);
    }

    if (forest.size() > 1) {
        //connect the forest
        graph.forestRoot = new Node(stringcast("the forest root")); //$NON-NLS-1$
        graph.nodes.add(graph.forestRoot);
        for (int i = 0; i < forest.size(); i++) {
            tree = cast(NodeList) forest.get(i);
            graph.edges.add(new Edge(graph.forestRoot, tree.getNode(0), 0, 0));
        }
    }
}

private void assignMinimumRank(Node node) {
    int rank = 0;
    Edge e;
    for (int i1 = 0; i1 < node.incoming.size(); i1++) {
        e = node.incoming.getEdge(i1);
        rank = Math.max(rank, e.delta + e.source.rank);
    }
    node.rank = rank;
}

}
