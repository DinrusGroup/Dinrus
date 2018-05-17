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
module dwtx.draw2d.graph.CompoundRankSorter;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;
import dwtx.draw2d.graph.RankSorter;
import dwtx.draw2d.graph.Subgraph;
import dwtx.draw2d.graph.Node;
import dwtx.draw2d.graph.DirectedGraph;
import dwtx.draw2d.graph.Rank;
import dwtx.draw2d.graph.NestingTree;
import dwtx.draw2d.graph.CompoundDirectedGraph;
import dwtx.draw2d.graph.Edge;
import dwtx.draw2d.graph.LocalOptimizer;

/**
 * Sorts nodes in a compound directed graph.
 * @author Randy Hudson
 * @since 2.1.2
 */
class CompoundRankSorter : RankSorter {

static class RowEntry {
    double contribution;
    int count;
    void reset() {
        count = 0;
        contribution = 0;
    }
}

static class RowKey {
    int rank;
    Subgraph s;
    this() { }
    this(Subgraph s, int rank) {
        this.s = s;
        this.rank = rank;
    }

    public override int opEquals(Object obj) {
        RowKey rp = cast(RowKey)obj;
        return rp.s is s && rp.rank is rank;
    }

    public override hash_t toHash() {
        return s.toHash() ^ (rank * 31);
    }
}

bool init_;
RowKey key;

Map map;

public this(){
    key = new RowKey();
    map = new HashMap();
}

void addRowEntry(Subgraph s, int row) {
    key.s = s;
    key.rank = row;
    if (!map.containsKey(key))
        map.put(new RowKey(s, row), new RowEntry());
}

protected void assignIncomingSortValues() {
    super.assignIncomingSortValues();
    pullTogetherSubgraphs();
}

protected void assignOutgoingSortValues() {
    super.assignOutgoingSortValues();
    pullTogetherSubgraphs();
}

void optimize(DirectedGraph g) {
    CompoundDirectedGraph graph = cast(CompoundDirectedGraph)g;
    Iterator containment = graph.containment.iterator();
    while (containment.hasNext())
        graph.removeEdge(cast(Edge)containment.next());
    graph.containment.clear();
    (new LocalOptimizer())
        .visit(graph);
}

private void pullTogetherSubgraphs() {
    if (true)
        return;
    for (int j = 0; j < rank.count(); j++) {
        Node n = rank.getNode(j);
        Subgraph s = n.getParent();
        while (s !is null) {
            getRowEntry(s, currentRow).reset();
            s = s.getParent();
        }
    }
    for (int j = 0; j < rank.count(); j++) {
        Node n = rank.getNode(j);
        Subgraph s = n.getParent();
        while (s !is null) {
            RowEntry entry = getRowEntry(s, currentRow);
            entry.count++;
            entry.contribution += n.sortValue;
            s = s.getParent();
        }
    }

    double weight = 0.5;// * (1.0 - progress) * 3;

    for (int j = 0; j < rank.count(); j++) {
        Node n = rank.getNode(j);
        Subgraph s = n.getParent();
        if (s !is null) {
            RowEntry entry = getRowEntry(s, currentRow);
            n.sortValue =
                n.sortValue * (1.0 - weight) + weight * entry.contribution / entry.count;
        }
    }
}

double evaluateNodeOutgoing() {
    double result = super.evaluateNodeOutgoing();
//  result += Math.random() * rankSize * (1.0 - progress) / 3.0;
    if (progress > 0.2) {
        Subgraph s = node.getParent();
        double connectivity = mergeConnectivity(s, node.rank + 1, result, progress);
        result = connectivity;
    }
    return result;
}

double evaluateNodeIncoming() {
    double result = super.evaluateNodeIncoming();
//  result += Math.random() * rankSize * (1.0 - progress) / 3.0;
    if (progress > 0.2) {
        Subgraph s = node.getParent();
        double connectivity = mergeConnectivity(s, node.rank - 1, result, progress);
        result = connectivity;
    }
    return result;
}

double mergeConnectivity(Subgraph s, int row, double result, double scaleFactor) {
    while (s !is null && getRowEntry(s, row) is null)
        s = s.getParent();
    if (s !is null) {
        RowEntry entry = getRowEntry(s, row);
        double connectivity = entry.contribution / entry.count;
        result = connectivity * 0.3 + (0.7) * result;
        s = s.getParent();
    }
    return result;
}

RowEntry getRowEntry(Subgraph s, int row) {
    key.s = s;
    key.rank = row;
    return cast(RowEntry)map.get(key);
}

void copyConstraints(NestingTree tree) {
    if (tree.subgraph !is null)
        tree.sortValue = tree.subgraph.rowOrder;
    for (int i = 0; i < tree.contents.size(); i++) {
        Object child = tree.contents.get(i);
        if (auto n = cast(Node)child ) {
            n.sortValue = n.rowOrder;
        } else {
            copyConstraints(cast(NestingTree)child);
        }
    }
}

public void init(DirectedGraph g) {
    super.init(g);
    init_ = true;

    for (int row = 0; row < g.ranks.size(); row++) {
        Rank rank = g.ranks.getRank(row);

        NestingTree tree = NestingTree.buildNestingTreeForRank(rank);
        copyConstraints(tree);
        tree.recursiveSort(true);
        rank.clear();
        tree.repopulateRank(rank);

        for (int j = 0; j < rank.count(); j++) {
            Node n = rank.getNode(j);
            Subgraph s = n.getParent();
            while (s !is null) {
                addRowEntry(s, row);
                s = s.getParent();
            }
        }
    }
}

protected void postSort() {
    super.postSort();
    if (init_)
        updateRank(rank);
}

void updateRank(Rank rank) {
    for (int j = 0; j < rank.count(); j++) {
        Node n = rank.getNode(j);
        Subgraph s = n.getParent();
        while (s !is null) {
            getRowEntry(s, currentRow).reset();
            s = s.getParent();
        }
    }
    for (int j = 0; j < rank.count(); j++) {
        Node n = rank.getNode(j);
        Subgraph s = n.getParent();
        while (s !is null) {
            RowEntry entry = getRowEntry(s, currentRow);
            entry.count++;
            entry.contribution += n.index;
            s = s.getParent();
        }
    }
}

}
