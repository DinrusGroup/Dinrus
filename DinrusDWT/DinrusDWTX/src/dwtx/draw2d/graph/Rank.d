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
module dwtx.draw2d.graph.Rank;

import dwt.dwthelper.utils;
import dwtx.draw2d.graph.Node;
import dwtx.draw2d.graph.SubgraphBoundary;
import dwtx.draw2d.graph.NodeList;

/**
 * For Internal Use only.
 * @author hudsonr
 * @since 2.1.2
 */
public class Rank : NodeList {

alias NodeList.add add;

int bottomPadding;
int height;
int location;

const int hash;
int topPadding;
int total;

public this(){
    hash = (new Object()).toHash();
}

void add(Node n) {
    super.add(n);
}

void assignIndices() {
    total = 0;
    Node node;

    int mag;
    for (int i = 0; i < size(); i++) {
        node = getNode(i);
        mag = Math.max(1, node.incoming.size() + node.outgoing.size());
        mag = Math.min(mag, 5);
        if (null !is cast(SubgraphBoundary)node )
            mag = 4;
        total += mag;
        node.index = total;
        total += mag;
    }
}

/**
 * Returns the number of nodes in this rank.
 * @return the number of nodes
 */
public int count() {
    return super.size();
}

/**
 * @see Object#equals(Object)
 */
public override int opEquals(Object o) {
    return o is this;
}

/**
 * @see Object#toHash()
 * Overridden for speed based on equality.
 */
public override hash_t toHash() {
    return hash;
}

void setDimensions(int location, int rowHeight) {
    this.height = rowHeight;
    this.location = location;
    for (int i = 0; i < size(); i++) {
        Node n = getNode(i);
        n.y = location;
        n.height = rowHeight;
    }
}

/**
 * @deprecated Do not call
 */
public void sort() { }

}
