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
module dwtx.draw2d.graph.NodeCluster;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;
import dwtx.draw2d.graph.NodeList;
import dwtx.draw2d.graph.CollapsedEdges;

/**
 * A group of nodes which are interlocked and cannot be separately placed.
 * @since 3.1
 */
class NodeCluster : NodeList {

alias NodeList.adjustRank adjustRank;

int toHash_;

bool isSetMember;
bool isDirty;
bool leftDirty;
bool rightDirty;

int leftFreedom;
int rightFreedom;
int leftNonzero;
int rightNonzero;
int leftCount = 0;
int rightCount = 0;

CollapsedEdges[] leftLinks;
CollapsedEdges[] rightLinks;
NodeCluster[] leftNeighbors;
NodeCluster[] rightNeighbors;

int effectivePull;
int weightedTotal;
int weightedDivisor;
int unweightedTotal;
int unweightedDivisor;

public this(){
    toHash_ = (new Object()).toHash();
    leftLinks = new CollapsedEdges[10];
    rightLinks = new CollapsedEdges[10];
    leftNeighbors = new NodeCluster[10];
    rightNeighbors = new NodeCluster[10];
}

void addLeftNeighbor(NodeCluster neighbor, CollapsedEdges link) {
    //Need to grow array in the following case
    if (leftNeighbors.length is leftCount) {
        int newSize = leftNeighbors.length * 2;

        NodeCluster newNeighbors[] = new NodeCluster[newSize];
        CollapsedEdges newLinks[] = new CollapsedEdges[newSize];

        System.arraycopy(leftNeighbors, 0, newNeighbors, 0, leftNeighbors.length);
        System.arraycopy(leftLinks, 0, newLinks, 0, leftLinks.length);

        leftNeighbors = newNeighbors;
        leftLinks = newLinks;
    }
    leftNeighbors[leftCount] = neighbor;
    leftLinks[leftCount++] = link;
}

void addRightNeighbor(NodeCluster neighbor, CollapsedEdges link) {
    if (rightNeighbors.length is rightCount) {
        int newSize = rightNeighbors.length * 2;

        NodeCluster newNeighbors[] = new NodeCluster[newSize];
        CollapsedEdges newLinks[] = new CollapsedEdges[newSize];

        System.arraycopy(rightNeighbors, 0, newNeighbors, 0, rightNeighbors.length);
        System.arraycopy(rightLinks, 0, newLinks, 0, rightLinks.length);

        rightNeighbors = newNeighbors;
        rightLinks = newLinks;
    }
    rightNeighbors[rightCount] = neighbor;
    rightLinks[rightCount++] = link;
}

public void adjustRank(int delta, Collection affected) {
    adjustRank(delta);
    NodeCluster neighbor;
    CollapsedEdges edges;
    for (int i = 0; i < leftCount; i++) {
        neighbor = leftNeighbors[i];
        if (neighbor.isSetMember)
            continue;
        edges = leftLinks[i];

        neighbor.weightedTotal += delta * edges.collapsedWeight;
        neighbor.unweightedTotal += delta * edges.collapsedCount;

        weightedTotal -= delta * edges.collapsedWeight;
        unweightedTotal -= delta * edges.collapsedCount;

        neighbor.rightDirty = leftDirty = true;
        if (!neighbor.isDirty) {
            neighbor.isDirty = true;
            affected.add(neighbor);
        }
    }
    for (int i = 0; i < rightCount; i++) {
        neighbor = rightNeighbors[i];
        if (neighbor.isSetMember)
            continue;
        edges = rightLinks[i];

        neighbor.weightedTotal += delta * edges.collapsedWeight;
        neighbor.unweightedTotal += delta * edges.collapsedCount;

        weightedTotal -= delta * edges.collapsedWeight;
        unweightedTotal -= delta * edges.collapsedCount;

        neighbor.leftDirty = rightDirty = true;
        if (!neighbor.isDirty) {
            neighbor.isDirty = true;
            affected.add(neighbor);
        }
    }
    isDirty = true;
    affected.add(this);
}

public override int opEquals(Object o) {
    return o is this;
}

CollapsedEdges getLeftNeighbor(NodeCluster neighbor) {
    for (int i = 0; i < leftCount; i++) {
        if (leftNeighbors[i] is neighbor)
            return leftLinks[i];
    }
    return null;
}

int getPull() {
    return effectivePull;
}

CollapsedEdges getRightNeighbor(NodeCluster neighbor) {
    for (int i = 0; i < rightCount; i++) {
        if (rightNeighbors[i] is neighbor)
            return rightLinks[i];
    }
    return null;
}

public override hash_t toHash() {
    return toHash_;
}

/**
 * Initializes pull and freedom values.
 */
void initValues() {
    weightedTotal = 0;
    weightedDivisor = 0;
    unweightedTotal = 0;
    int slack;

    leftNonzero = rightNonzero = leftFreedom = rightFreedom = Integer.MAX_VALUE;
    for (int i = 0; i < leftCount; i++) {
        CollapsedEdges edges = leftLinks[i];
        weightedTotal -= edges.getWeightedPull();
        unweightedTotal -= edges.tightestEdge.getSlack();
        unweightedDivisor += edges.collapsedCount;
        weightedDivisor += edges.collapsedWeight;
        slack = edges.tightestEdge.getSlack();
        leftFreedom = Math.min(slack, leftFreedom);
        if (slack > 0)
            leftNonzero = Math.min(slack, leftNonzero);
    }
    for (int i = 0; i < rightCount; i++) {
        CollapsedEdges edges = rightLinks[i];
        weightedTotal += edges.getWeightedPull();
        unweightedDivisor += edges.collapsedCount;
        unweightedTotal += edges.tightestEdge.getSlack();
        weightedDivisor += edges.collapsedWeight;
        slack = edges.tightestEdge.getSlack();
        rightFreedom = Math.min(slack, rightFreedom);
        if (slack > 0)
            rightNonzero = Math.min(slack, rightNonzero);
    }
    updateEffectivePull();
}

/**
 * Refreshes the left and right freedom.
 */
void refreshValues() {
    int slack;
    isDirty = false;
    if (leftDirty) {
        leftDirty = false;
        leftNonzero = leftFreedom = Integer.MAX_VALUE;
        for (int i = 0; i < leftCount; i++) {
            CollapsedEdges edges = leftLinks[i];
            slack = edges.tightestEdge.getSlack();
            leftFreedom = Math.min(slack, leftFreedom);
            if (slack > 0)
                leftNonzero = Math.min(slack, leftNonzero);
        }
    }
    if (rightDirty) {
        rightDirty = false;
        rightNonzero = rightFreedom = Integer.MAX_VALUE;
        for (int i = 0; i < rightCount; i++) {
            CollapsedEdges edges = rightLinks[i];
            slack = edges.tightestEdge.getSlack();
            rightFreedom = Math.min(slack, rightFreedom);
            if (slack > 0)
                rightNonzero = Math.min(slack, rightNonzero);
        }
    }
    updateEffectivePull();
}

private void updateEffectivePull() {
    if (weightedDivisor !is 0)
        effectivePull = weightedTotal / weightedDivisor;
    else if (unweightedDivisor !is 0)
            effectivePull = unweightedTotal / unweightedDivisor;
    else
        effectivePull = 0;
}

}
