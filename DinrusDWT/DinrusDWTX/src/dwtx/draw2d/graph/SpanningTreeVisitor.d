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
module dwtx.draw2d.graph.SpanningTreeVisitor;

import dwt.dwthelper.utils;
import dwtx.draw2d.graph.GraphVisitor;
import dwtx.draw2d.graph.Edge;
import dwtx.draw2d.graph.Node;
import dwtx.draw2d.graph.EdgeList;

/**
 * A base class for visitors which operate on the graphs spanning tree used to induce rank
 * assignments.
 * @author Randy Hudson
 * @since 2.1.2
 */
abstract class SpanningTreeVisitor : GraphVisitor {

Edge getParentEdge(Node node) {
    return cast(Edge)node.workingData[1];
}

EdgeList getSpanningTreeChildren(Node node) {
    return cast(EdgeList)node.workingData[0];
}

protected Node getTreeHead(Edge edge) {
    if (getParentEdge(edge.source) is edge)
        return edge.target;
    return edge.source;
}

Node getTreeParent(Node node) {
    Edge e = getParentEdge(node);
    if (e is null)
        return null;
    return e.opposite(node);
}

protected Node getTreeTail(Edge edge) {
    if (getParentEdge(edge.source) is edge)
        return edge.source;
    return edge.target;
}

void setParentEdge(Node node, Edge edge) {
    node.workingData[1] = edge;
}

}
