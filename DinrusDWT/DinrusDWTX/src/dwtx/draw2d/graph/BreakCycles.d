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
module dwtx.draw2d.graph.BreakCycles;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;
import dwtx.draw2d.graph.GraphVisitor;
import dwtx.draw2d.graph.NodeList;
import dwtx.draw2d.graph.DirectedGraph;
import dwtx.draw2d.graph.Node;
import dwtx.draw2d.graph.Edge;

/**
 * This visitor eliminates cycles in the graph using a "greedy" heuristic.  Nodes which
 * are sources and sinks are marked and placed in a source and sink list, leaving only
 * nodes involved in cycles. A remaining node with the highest (outgoing-incoming) edges
 * score is then chosen greedily as if it were a source. The process is repeated until all
 * nodes have been marked and placed in a list.  The lists are then concatenated, and any
 * edges which go backwards in this list will be inverted during the layout procedure.
 *
 * @author Daniel Lee
 * @since 2.1.2
 */
class BreakCycles : GraphVisitor {

// Used in identifying cycles and in cycle removal.
// Flag field indicates "presence". If true, the node has been removed from the list.
NodeList graphNodes;

public this(){
    graphNodes = new NodeList();
}

private bool allNodesFlagged() {
    for (int i = 0; i < graphNodes.size(); i++) {
        if (graphNodes.getNode(i).flag is false)
            return false;
    }
    return true;
}

private void breakCycles(DirectedGraph g) {
    initializeDegrees(g);
    greedyCycleRemove(g);
    invertEdges(g);
}

/*
 * Returns true if g contains cycles, false otherwise
 */
private bool containsCycles(DirectedGraph g) {
    List noLefts = new ArrayList();
    //Identify all initial nodes for removal
    for (int i = 0; i < graphNodes.size(); i++) {
        Node node = graphNodes.getNode(i);
        if (getIncomingCount(node) is 0)
            sortedInsert(noLefts, node);
    }

    while (noLefts.size() > 0) {
        Node node = cast(Node)noLefts.remove(noLefts.size() - 1);
        node.flag = true;
        for (int i = 0; i < node.outgoing.size(); i++) {
            Node right = node.outgoing.getEdge(i).target;
            setIncomingCount(right, getIncomingCount(right) - 1);
            if (getIncomingCount(right) is 0)
                sortedInsert(noLefts, right);
        }
    }

    if (allNodesFlagged())
        return false;
    return true;
}

/*
 * Returns the node in graphNodes with the largest
 * (outgoing edge count - incoming edge count) value
 */
private Node findNodeWithMaxDegree() {
    int max = Integer.MIN_VALUE;
    Node maxNode = null;

    for (int i = 0; i < graphNodes.size(); i++) {
        Node node = graphNodes.getNode(i);
        if (getDegree(node) >= max && node.flag is false) {
            max = getDegree(node);
            maxNode = node;
        }
    }
    return maxNode;
}

private int getDegree(Node n) {
    return n.workingInts[3];
}

private int getIncomingCount(Node n) {
    return n.workingInts[0];
}

private int getInDegree(Node n) {
    return n.workingInts[1];
}

private int getOrderIndex(Node n) {
    return n.workingInts[0];
}

private int getOutDegree(Node n) {
    return n.workingInts[2];
}

private void greedyCycleRemove(DirectedGraph g) {
    NodeList sL = new NodeList();
    NodeList sR = new NodeList();

    do {
        // Add all sinks and isolated nodes to sR
        bool hasSink;
        do {
            hasSink = false;
            for (int i = 0; i < graphNodes.size(); i++) {
                Node node = graphNodes.getNode(i);
                if (getOutDegree(node) is 0 && node.flag is false) {
                    hasSink = true;
                    node.flag = true;
                    updateIncoming(node);
                    sR.add(node);
                    break;
                }
            }
        } while (hasSink);

        // Add all sources to sL
        bool hasSource;
        do {
            hasSource = false;
            for (int i = 0; i < graphNodes.size(); i++) {
                Node node = graphNodes.getNode(i);
                if (getInDegree(node) is 0 && node.flag is false) {
                    hasSource = true;
                    node.flag = true;
                    updateOutgoing(node);
                    sL.add(node);
                    break;
                }
            }
        } while (hasSource);

        // When all sinks and sources are removed, choose a node with the
        // maximum degree (outDegree - inDegree) and add it to sL
        Node max = findNodeWithMaxDegree();
        if (max !is null) {
            sL.add(max);
            max.flag = true;
            updateIncoming(max);
            updateOutgoing(max);
        }
    } while (!allNodesFlagged());

    // Assign order indexes
    int orderIndex = 0;
    for (int i = 0; i < sL.size(); i++) {
        setOrderIndex(sL.getNode(i), orderIndex++);
    }
    for (int i = sR.size() - 1; i >= 0; i--) {
        setOrderIndex(sR.getNode(i), orderIndex++);
    }
}

private void initializeDegrees(DirectedGraph g) {
    graphNodes.resetFlags();
    for (int i = 0; i < g.nodes.size(); i++) {
        Node n = graphNodes.getNode(i);
        setInDegree(n, n.incoming.size());
        setOutDegree(n, n.outgoing.size());
        setDegree(n, n.outgoing.size() - n.incoming.size());
    }
}

private void invertEdges(DirectedGraph g) {
    for (int i = 0; i < g.edges.size(); i++) {
        Edge e = g.edges.getEdge(i);
        if (getOrderIndex(e.source) > getOrderIndex(e.target)) {
            e.invert();
            e.isFeedback_ = true;
        }
    }
}

private void setDegree(Node n, int deg) {
    n.workingInts[3] = deg;
}

private void setIncomingCount(Node n, int count) {
    n.workingInts[0] = count;
}

private void setInDegree(Node n, int deg) {
    n.workingInts[1] = deg;
}

private void setOutDegree(Node n, int deg) {
    n.workingInts[2] = deg;
}

private void setOrderIndex(Node n, int index) {
    n.workingInts[0] = index;
}

private void sortedInsert(List list, Node node) {
    int insert = 0;
    while (insert < list.size()
      && (cast(Node)list.get(insert)).sortValue > node.sortValue)
        insert++;
    list.add(insert, node);
}

/*
 * Called after removal of n. Updates the degree values of n's incoming nodes.
 */
private void updateIncoming(Node n) {
    for (int i = 0; i < n.incoming.size(); i++) {
        Node in_ = n.incoming.getEdge(i).source;
        if (in_.flag is false) {
            setOutDegree(in_, getOutDegree(in_) - 1);
            setDegree(in_, getOutDegree(in_) - getInDegree(in_));
        }
    }
}

/*
 * Called after removal of n. Updates the degree values of n's outgoing nodes.
 */
private void updateOutgoing(Node n) {
    for (int i = 0; i < n.outgoing.size(); i++) {
        Node out_ = n.outgoing.getEdge(i).target;
        if (out_.flag is false) {
            setInDegree(out_, getInDegree(out_) - 1);
            setDegree(out_, getOutDegree(out_) - getInDegree(out_));
        }
    }
}

public void revisit(DirectedGraph g) {
    for (int i = 0; i < g.edges.size(); i++) {
        Edge e = g.edges.getEdge(i);
        if (e.isFeedback())
            e.invert();
    }
}

/**
 * @see GraphVisitor#visit(dwtx.draw2d.graph.DirectedGraph)
 */
public void visit(DirectedGraph g) {
    // put all nodes in list, initialize index
    graphNodes.resetFlags();
    for (int i = 0; i < g.nodes.size(); i++) {
        Node n = g.nodes.getNode(i);
        setIncomingCount(n, n.incoming.size());
        graphNodes.add(n);
    }
    if (containsCycles(g)) {
        breakCycles(g);
    }
}

}
