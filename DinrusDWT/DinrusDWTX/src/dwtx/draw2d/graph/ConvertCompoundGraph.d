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
module dwtx.draw2d.graph.ConvertCompoundGraph;

import dwt.dwthelper.utils;

import dwtx.draw2d.geometry.Insets;
import dwtx.draw2d.graph.GraphVisitor;
import dwtx.draw2d.graph.NodeList;
import dwtx.draw2d.graph.Node;
import dwtx.draw2d.graph.Subgraph;
import dwtx.draw2d.graph.SubgraphBoundary;
import dwtx.draw2d.graph.CompoundDirectedGraph;
import dwtx.draw2d.graph.DirectedGraph;
import dwtx.draw2d.graph.Edge;

/**
 * Converts a compound directed graph into a simple directed graph.
 * @author Randy Hudson
 * @since 2.1.2
 */
class ConvertCompoundGraph : GraphVisitor {

private void addContainmentEdges(CompoundDirectedGraph graph) {
    //For all nested nodes, connect to head and/or tail of containing subgraph if present
    for (int i = 0; i < graph.nodes.size(); i++) {
        Node node = graph.nodes.getNode(i);
        Subgraph parent = node.getParent();
        if (parent is null)
            continue;
        if (auto sub = cast(Subgraph)node ) {
            connectHead(graph, sub.head, parent);
            connectTail(graph, sub.tail, parent);
        } else {
            connectHead(graph, node, parent);
            connectTail(graph, node, parent);
        }
    }
}

int buildNestingTreeIndices(NodeList nodes, int base) {
    for (int i = 0; i < nodes.size(); i++) {
        Node node = cast(Node)nodes.get(i);
        if (auto s = cast(Subgraph)node ) {
            s.nestingTreeMin = base;
            base = buildNestingTreeIndices(s.members, base);
        }
        node.nestingIndex = base++;
    }
    return base++;
}

private void connectHead(CompoundDirectedGraph graph, Node node, Subgraph parent) {
    bool connectHead = true;
    for (int j = 0; connectHead && j < node.incoming.size(); j++) {
        Node ancestor = node.incoming.getEdge(j).source;
        if (parent.isNested(ancestor))
            connectHead = false;
    }
    if (connectHead) {
        Edge e = new Edge(parent.head, node);
        e.weight = 0;
        graph.edges.add(e);
        graph.containment.add(e);
    }
}

private void connectTail(CompoundDirectedGraph graph, Node node, Subgraph parent) {
    bool connectTail = true;
    for (int j = 0; connectTail && j < node.outgoing.size(); j++) {
        Node ancestor = node.outgoing.getEdge(j).target;
        if (parent.isNested(ancestor))
            connectTail = false;
    }
    if (connectTail) {
        Edge e = new Edge(node, parent.tail);
        e.weight = 0;
        graph.edges.add(e);
        graph.containment.add(e);
    }
}

private void convertSubgraphEndpoints(CompoundDirectedGraph graph) {
    for (int i = 0; i < graph.edges.size(); i++) {
        Edge edge = cast(Edge)graph.edges.get(i);
        if (auto s = cast(Subgraph)edge.source ) {
            Node newSource;
            if (s.isNested(edge.target))
                newSource = s.head;
            else
                newSource = s.tail;
            //s.outgoing.remove(edge);
            edge.source = newSource;
            newSource.outgoing.add(edge);
        }
        if (auto s = cast(Subgraph)edge.target ) {
            Node newTarget;
            if (s.isNested(edge.source))
                newTarget = s.tail;
            else
                newTarget = s.head;

            //s.incoming.remove(edge);
            edge.target = newTarget;
            newTarget.incoming.add(edge);
        }
    }
}

private void replaceSubgraphsWithBoundaries(CompoundDirectedGraph graph) {
    for (int i = 0; i < graph.subgraphs.size(); i++) {
        Subgraph s = cast(Subgraph)graph.subgraphs.get(i);
        graph.nodes.add(s.head);
        graph.nodes.add(s.tail);
        graph.nodes.remove(s);
    }
}

void revisit(DirectedGraph g) {
    for (int i = 0; i < g.edges.size(); i++) {
        Edge e = g.edges.getEdge(i);
        if (null !is cast(SubgraphBoundary)e.source ) {
            e.source.outgoing.remove(e);
            e.source = e.source.getParent();
        }
        if (null !is cast(SubgraphBoundary)e.target ) {
            e.target.incoming.remove(e);
            e.target = e.target.getParent();
        }
    }
}

/**
 * @see GraphVisitor#visit(dwtx.draw2d.graph.DirectedGraph)
 */
public void visit(DirectedGraph dg) {
    CompoundDirectedGraph graph = cast(CompoundDirectedGraph)dg;

    NodeList roots = new NodeList();
    //Find all subgraphs and root subgraphs
    for (int i = 0; i < graph.nodes.size(); i++) {
        Object node = graph.nodes.get(i);
        if (auto s = cast(Subgraph)node ) {
            Insets padding = dg.getPadding(s);
            s.head = new SubgraphBoundary(s, padding, 0);
            s.tail = new SubgraphBoundary(s, padding, 2);
            Edge headToTail = new Edge(s.head, s.tail);
            headToTail.weight = 10;
            graph.edges.add(headToTail);
            graph.containment.add(headToTail);

            graph.subgraphs.add(s);
            if (s.getParent() is null)
                roots.add(s);
            if (s.members.size() is 2) //The 2 being the head and tail only
                graph.edges.add(new Edge(s.head, s.tail));
        }
    }

    buildNestingTreeIndices(roots, 0);
    convertSubgraphEndpoints(graph);
    addContainmentEdges(graph);
    replaceSubgraphsWithBoundaries(graph);
}

}
