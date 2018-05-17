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
module dwtx.draw2d.graph.MinCross;

import dwt.dwthelper.utils;
import dwtx.draw2d.graph.RankSorter;
import dwtx.draw2d.graph.DirectedGraph;
import dwtx.draw2d.graph.GraphVisitor;
import dwtx.draw2d.graph.Rank;

/**
 * Sweeps up and down the ranks rearranging them so as to reduce edge crossings.
 * @author Randy Hudson
 * @since 2.1.2
 */
class MinCross : GraphVisitor {

static const int MAX = 45;

private DirectedGraph g;
private RankSorter sorter;

public this() {
    sorter = new RankSorter();
}

/**
 * @since 3.1
 */
public this(RankSorter sorter) {
    this();
    setRankSorter(sorter);
}

public void setRankSorter(RankSorter sorter) {
    this.sorter = sorter;
}

void solve() {
    Rank rank;
    for (int loop = 0; loop < MAX; loop++) {
        for (int row = 1; row < g.ranks.size(); row++) {
            rank = g.ranks.getRank(row);
            sorter.sortRankIncoming(g, rank, row, cast(double)loop / MAX);
        }
        if (loop is MAX - 1)
            continue;
        for (int row = g.ranks.size() - 2; row >= 0; row--) {
            rank = g.ranks.getRank(row);
            sorter.sortRankOutgoing(g, rank, row, cast(double)loop / MAX);
        }
    }
}

/**
 *  @see GraphVisitor#visit(dwtx.draw2d.graph.DirectedGraph)
 */
public void visit(DirectedGraph g) {
    sorter.init(g);
    this.g = g;
    solve();
    sorter.optimize(g);
}

}
