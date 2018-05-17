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
module dwtx.draw2d.graph.NodeList;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;
import dwtx.draw2d.graph.Node;

/**
 * A list containing nodes.
 * @author hudsonr
 * @since 2.1.2
 */
public class NodeList : ArrayList {

/**
 * Constructs an empty NodeList.
 */
public this() { }

/**
 * Constructs a NodeList with the elements from the specified list.
 * @param list the list whose elements are to be added to this list
 */
public this(NodeList list) {
    super(list);
}

void adjustRank (int delta) {
    if (delta is 0)
        return;
    for (int i = 0; i < size(); i++)
        getNode(i).rank += delta;
}

void resetSortValues() {
    for (int i = 0; i < size(); i++)
        getNode(i).sortValue = 0.0;
}

void resetIndices() {
    for (int i = 0; i < size(); i++)
        getNode(i).index = 0;
}

void normalizeRanks() {
    int minRank = Integer.MAX_VALUE;
    for (int i = 0; i < size(); i++)
        minRank = Math.min(minRank, getNode(i).rank);
    adjustRank(-minRank);
}

/**
 * Returns the Node at the given index.
 * @param index the index
 * @return the node at a given index
 */
public Node getNode(int index) {
    return cast(Node)super.get(index);
}

void resetFlags() {
    for (int i = 0; i < size(); i++) {
        getNode(i).flag = false;
    }
}

}
