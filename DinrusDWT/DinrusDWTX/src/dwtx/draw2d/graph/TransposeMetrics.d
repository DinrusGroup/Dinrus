/*******************************************************************************
 * Copyright (c) 2005, 2008 IBM Corporation and others.
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

module dwtx.draw2d.graph.TransposeMetrics;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;

import dwtx.draw2d.PositionConstants;
import dwtx.draw2d.geometry.Transposer;
import dwtx.draw2d.graph.GraphVisitor;
import dwtx.draw2d.graph.DirectedGraph;
import dwtx.draw2d.graph.Node;
import dwtx.draw2d.graph.Edge;
import dwtx.draw2d.graph.VirtualNode;

class TransposeMetrics : GraphVisitor {

Transposer t;

public this(){
    t = new Transposer();
}

public void visit(DirectedGraph g) {
    if (g.getDirection() is PositionConstants.SOUTH)
        return;
    t.setEnabled(true);
    int temp;
    g.setDefaultPadding(t.t(g.getDefaultPadding()));
    for (int i = 0; i < g.nodes.size(); i++) {
        Node node = g.nodes.getNode(i);
        temp = node.width;
        node.width = node.height;
        node.height = temp;
        if (node.getPadding() !is null)
            node.setPadding(t.t(node.getPadding()));
    }
}

public void revisit(DirectedGraph g) {
    if (g.getDirection() is PositionConstants.SOUTH)
        return;
    int temp;
    g.setDefaultPadding(t.t(g.getDefaultPadding()));
    for (int i = 0; i < g.nodes.size(); i++) {
        Node node = cast(Node)g.nodes.get(i);
        temp = node.width;
        node.width = node.height;
        node.height = temp;
        temp = node.y;
        node.y = node.x;
        node.x = temp;
        if (node.getPadding() !is null)
            node.setPadding(t.t(node.getPadding()));
    }
    for (int i = 0; i < g.edges.size(); i++) {
        Edge edge = g.edges.getEdge(i);
        edge.start.transpose();
        edge.end.transpose();
        edge.getPoints().transpose();
        List bends = edge.vNodes;
        if (bends is null)
            continue;
        for (int b = 0; b < bends.size(); b++) {
            VirtualNode vnode = cast(VirtualNode) bends.get(b);
            temp = vnode.y;
            vnode.y = vnode.x;
            vnode.x = temp;
            temp = vnode.width;
            vnode.width = vnode.height;
            vnode.height = temp;
        }
    }
    g.size.transpose();
}

}
