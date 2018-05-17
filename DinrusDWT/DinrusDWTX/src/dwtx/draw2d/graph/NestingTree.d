/*******************************************************************************
 * Copyright (c) 2005 IBM Corporation and others.
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
module dwtx.draw2d.graph.NestingTree;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;
import dwtx.draw2d.graph.Node;
import dwtx.draw2d.graph.Rank;
import dwtx.draw2d.graph.Subgraph;

class NestingTree {

List contents;
bool isLeaf = true;
int size;
double sortValue;
Node subgraph;

public this(){
    contents = new ArrayList();
}
private static void addToNestingTree(Map map, Node child) {
    Subgraph subgraph = child.getParent();
    NestingTree parent = cast(NestingTree)map.get(subgraph);
    if (parent is null) {
        parent = new NestingTree();
        parent.subgraph = subgraph;
        map.put(subgraph, parent);
        if (subgraph !is null)
            addToNestingTree(map, parent);
    }
    parent.contents.add(child);
}

private static void addToNestingTree(Map map, NestingTree branch) {
    Subgraph subgraph = branch.subgraph.getParent();
    NestingTree parent = cast(NestingTree)map.get(subgraph);
    if (parent is null) {
        parent = new NestingTree();
        parent.subgraph = subgraph;
        map.put(subgraph, parent);
        if (subgraph !is null)
            addToNestingTree(map, parent);
    }
    parent.contents.add(branch);
}

static NestingTree buildNestingTreeForRank(Rank rank) {
    Map nestingMap = new HashMap();

    for (int j = 0; j < rank.count(); j++) {
        Node node = rank.getNode(j);
        addToNestingTree(nestingMap, node);
    }

    return cast(NestingTree)nestingMap.get(cast(Object)null);
}

void calculateSortValues() {
    int total = 0;
    for (int i = 0; i < contents.size(); i++) {
        Object o = contents.get(i);
        if ( auto e = cast(NestingTree)o ) {
            isLeaf = false;
            e.calculateSortValues();
            total += cast(int)(e.sortValue * e.size);
            size += e.size;
        } else {
            Node n = cast(Node)o;
            n.sortValue = n.index;
            total += n.index;
            size++;
        }
    }
    sortValue = cast(double)total / size;
}

void getSortValueFromSubgraph() {
    if (subgraph !is null)
        sortValue = subgraph.sortValue;
    for (int i = 0; i < contents.size(); i++) {
        Object o = contents.get(i);
        if (auto nt = cast(NestingTree)o )
            nt.getSortValueFromSubgraph();
    }
}

void recursiveSort(bool sortLeaves) {
    if (isLeaf && !sortLeaves)
        return;
    bool change = false;
    //Use modified bubble sort for almost-sorted lists.
    do {
        change = false;
        for (int i = 0; i < contents.size() - 1; i++)
            change |= swap(i);
        if (!change)
            break;
        change = false;
        for (int i = contents.size() - 2; i >= 0; i--)
            change |= swap(i);
    } while (change);
    for (int i = 0; i < contents.size(); i++) {
        Object o = contents.get(i);
        if (auto nt = cast(NestingTree)o )
            nt.recursiveSort(sortLeaves);
    }
}

void repopulateRank(Rank r) {
    for (int i = 0; i < contents.size(); i++) {
        Object o = contents.get(i);
        if (null !is cast(Node)o )
            r.add(o);
        else
            (cast(NestingTree)o).repopulateRank(r);
    }
}


bool swap(int index) {
    Object left = contents.get(index);
    Object right = contents.get(index + 1);
    double iL = (null !is cast(Node)left )
        ? (cast(Node)left).sortValue
        : (cast(NestingTree)left).sortValue;
    double iR = (null !is cast(Node)right )
        ? (cast(Node)right).sortValue
        : (cast(NestingTree)right).sortValue;
    if (iL <= iR)
        return false;
    contents.set(index, right);
    contents.set(index + 1, left);
    return true;
}

public String toString() {
    if( subgraph )
        return "Nesting:" ~ subgraph.toString; //$NON-NLS-1$
    return "Nesting: null"; //$NON-NLS-1$
}

}
