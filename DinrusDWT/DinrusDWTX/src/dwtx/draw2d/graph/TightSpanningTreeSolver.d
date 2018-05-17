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
module dwtx.draw2d.graph.TightSpanningTreeSolver;

import dwt.dwthelper.utils;
import dwtx.draw2d.graph.SpanningTreeVisitor;
import dwtx.draw2d.graph.DirectedGraph;
import dwtx.draw2d.graph.Edge;
import dwtx.draw2d.graph.EdgeList;
import dwtx.draw2d.graph.Node;
import dwtx.draw2d.graph.NodeList;

/**
 * Finds a tight spanning tree from the graphs edges which induce a valid rank assignment.
 * This process requires that the nodes be initially given a feasible ranking.
 * @author Randy Hudson
 * @since 2.1.2
 */
class TightSpanningTreeSolver : SpanningTreeVisitor {

protected DirectedGraph graph;
protected CandidateList candidates;

static final class CandidateList {
    private Edge[] edges;
    private int size_;

    public this(){
        edges = new Edge[10];
    }
    public void add(Edge edge) {
        if (size_ is edges.length - 1) {
            Edge newEdges[] = new Edge[edges.length * 2];
            System.arraycopy(edges, 0, newEdges, 0, edges.length);
            edges = newEdges;
        }
        edges[size_++] = edge;
    }

    public Edge getEdge(int index) {
        return edges[index];
    }

    public void remove(Edge edge) {
        for (int i = 0; i < size_; i++) {
            if (edges[i] is edge) {
                edges[i] = edges[size_ - 1];
                size_--;
                return;
            }
        }
        throw new RuntimeException("Remove called on invalid Edge"); //$NON-NLS-1$
    }

    public int size() {
        return size_;
    }
}

protected NodeList members;

public this(){
    candidates = new CandidateList();
    members = new NodeList();
}

public void visit(DirectedGraph graph) {
    this.graph = graph;
    init();
    solve();
}

Node addEdge(Edge edge) {
    int delta = edge.getSlack();
    edge.tree = true;
    Node node;
    if (edge.target.flag) {
        delta = -delta;
        node = edge.source;
        setParentEdge(node, edge);
        getSpanningTreeChildren(edge.target).add(edge);
    } else {
        node = edge.target;
        setParentEdge(node, edge);
        getSpanningTreeChildren(edge.source).add(edge);
    }
    members.adjustRank(delta);
    addNode(node);
    return node;
}

private bool isNodeReachable(Node node) {
    return node.flag;
}

private void setNodeReachable(Node node) {
    node.flag = true;
}

private bool isCandidate(Edge e) {
    return e.flag;
}

private void setCandidate(Edge e) {
    e.flag = true;
}

void addNode(Node node) {
    setNodeReachable(node);
    EdgeList list = node.incoming;
    Edge e;
    for (int i = 0; i < list.size(); i++) {
        e = list.getEdge(i);
        if (!isNodeReachable(e.source)) {
            if (!isCandidate(e)) {
                setCandidate(e);
                candidates.add(e);
            }
        } else
            candidates.remove(e);
    }

    list = node.outgoing;
    for (int i = 0; i < list.size(); i++) {
        e = list.getEdge(i);
        if (!isNodeReachable(e.target)) {
            if (!isCandidate(e)) {
                setCandidate(e);
                candidates.add(e);
            }
        } else
            candidates.remove(e);
    }
    members.add(node);
}

void init() {
    graph.edges.resetFlags(true);
    graph.nodes.resetFlags();
    for (int i = 0; i < graph.nodes.size(); i++) {
        Node node = cast(Node)graph.nodes.get(i);
        node.workingData[0] = new EdgeList();
    }
}

protected void solve() {
    Node root = graph.nodes.getNode(0);
    setParentEdge(root, null);
    addNode(root);
    while (members.size() < graph.nodes.size()) {
        if (candidates.size() is 0)
            throw new RuntimeException("graph is not fully connected");//$NON-NLS-1$
        int minSlack = Integer.MAX_VALUE, slack;
        Edge minEdge = null, edge;
        for (int i = 0; i < candidates.size() && minSlack > 0; i++) {
            edge = candidates.getEdge(i);
            slack = edge.getSlack();
            if (slack < minSlack) {
                minSlack = slack;
                minEdge = edge;
            }
        }
        addEdge(minEdge);
    }
    graph.nodes.normalizeRanks();
}

}
