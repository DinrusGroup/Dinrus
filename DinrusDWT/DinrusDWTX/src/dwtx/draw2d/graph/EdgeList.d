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
module dwtx.draw2d.graph.EdgeList;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;
import dwtx.draw2d.graph.Edge;
/**
 * A list of <code>Edge</code>s.
 * @author hudsonr
 * @since 2.1.2
 */
public class EdgeList : ArrayList {

/**
 * Returns the edge for the given index.
 * @param index the index of the requested edge
 * @return the edge at the given index
 */
public Edge getEdge(int index) {
    return cast(Edge)super.get(index);
}

/**
 * For intrenal use only.
 * @param i and index
 * @return a value
 */
public int getSourceIndex(int i) {
    return getEdge(i).source.index;
}

/**
 * For internal use only.
 * @param i an index
 * @return a value
 */
public int getTargetIndex(int i) {
    return getEdge(i).target.index;
}

/**
 * For internal use only.
 * @return the minimum slack for this edge list
 */
public int getSlack() {
    int slack = Integer.MAX_VALUE;
    for (int i = 0; i < this.size(); i++)
        slack = Math.min(slack, getEdge(i).getSlack());
    return slack;
}

/**
 * For internal use only.
 * @return the total weight of all edges
 */
public int getWeight() {
    int w = 0;
    for (int i = 0; i < this.size(); i++)
        w += getEdge(i).weight;
    return w;
}

/**
 * For internal use only
 * @return <code>true</code> if completely flagged
 */
public bool isCompletelyFlagged() {
    for (int i = 0; i < size(); i++) {
        if (!getEdge(i).flag)
            return false;
    }
    return true;
}

/**
 * For internal use only.  Resets all flags.
 * @param resetTree internal
 */
public void resetFlags(bool resetTree) {
    for (int i = 0; i < size(); i++) {
        getEdge(i).flag = false;
        if (resetTree)
            getEdge(i).tree = false;
    }
}

/**
 * For internal use only.
 * @param value value
 */
public void setFlags(bool value) {
    for (int i = 0; i < size(); i++)
        getEdge(i).flag = value;
}

}
