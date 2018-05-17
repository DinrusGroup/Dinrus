/*******************************************************************************
 * Copyright (c) 2000, 2006 IBM Corporation and others.
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
module dwtx.jface.text.link.TabStopIterator;

import dwtx.jface.text.link.LinkedModeModel; // packageimport
import dwtx.jface.text.link.LinkedPosition; // packageimport
import dwtx.jface.text.link.ILinkedModeListener; // packageimport
import dwtx.jface.text.link.LinkedModeUI; // packageimport
import dwtx.jface.text.link.InclusivePositionUpdater; // packageimport
import dwtx.jface.text.link.LinkedPositionGroup; // packageimport
import dwtx.jface.text.link.LinkedModeManager; // packageimport
import dwtx.jface.text.link.LinkedPositionAnnotations; // packageimport
import dwtx.jface.text.link.ProposalPosition; // packageimport


import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;
import tango.core.Exception;

import dwtx.core.runtime.Assert;
import dwtx.jface.text.Position;



/**
 * Iterator that leaps over the double occurrence of an element when switching from forward
 * to backward iteration that is shown by <code>ListIterator</code>.
 * <p>
 * Package private, only for use by LinkedModeUI.
 * </p>
 * @since 3.0
 */
class TabStopIterator {
    /**
     * Comparator for <code>LinkedPosition</code>s. If the sequence number of two positions is equal, the
     * offset is used.
     */
    private static class SequenceComparator : Comparator {

        /**
         * {@inheritDoc}
         *
         * <p><code>o1</code> and <code>o2</code> are required to be instances
         * of <code>LinkedPosition</code>.</p>
         */
        public int compare(Object o1, Object o2) {
            LinkedPosition p1= cast(LinkedPosition)o1;
            LinkedPosition p2= cast(LinkedPosition)o2;
            int i= p1.getSequenceNumber() - p2.getSequenceNumber();
            if (i !is 0)
                return i;
            return p1.getOffset() - p2.getOffset();
        }

    }

    /** The comparator to sort the list of positions. */
    private static Comparator fComparator_;
    private static Comparator fComparator(){
        if( fComparator_ is null ){
            synchronized( TabStopIterator.classinfo ){
                if( fComparator_ is null ){
                    fComparator_ = new SequenceComparator();
                }
            }
        }
        return fComparator_;
    }

    /** The iteration sequence. */
    private const ArrayList fList;
    /** The size of <code>fList</code>. */
    private int fSize;
    /** Index of the current element, to the first one initially. */
    private int fIndex;
    /** Cycling property. */
    private bool fIsCycling= false;

    this(List positionSequence) {
        Assert.isNotNull(cast(Object)positionSequence);
        fList= new ArrayList(positionSequence);
        Collections.sort(fList, fComparator);
        fSize= fList.size();
        fIndex= -1;
        Assert.isTrue(fSize > 0);
    }

    bool hasNext(LinkedPosition current) {
        return getNextIndex(current) !is fSize;
    }

    private int getNextIndex(LinkedPosition current) {
        if (current !is null && fList.get(fIndex) !is current)
            return findNext(current);
        else if (fIsCycling && fIndex is fSize - 1)
            return 0;
        else
            // default: increase
            return fIndex + 1;
    }

    /**
     * Finds the closest position in the iteration set that follows after
     * <code>current</code> and sets <code>fIndex</code> accordingly. If <code>current</code>
     * is in the iteration set, the next in turn is chosen.
     *
     * @param current the current position
     * @return <code>true</code> if there is a next position, <code>false</code> otherwise
     */
    private int findNext(LinkedPosition current) {
        Assert.isNotNull(current);
        // if the position is in the iteration set, jump to the next one
        int index= fList.indexOf(current);
        if (index !is -1) {
            if (fIsCycling && index is fSize - 1)
                return 0;
            return index + 1;
        }

        // index is -1

        // find the position that follows closest to the current position
        LinkedPosition found= null;
        for (Iterator it= fList.iterator(); it.hasNext(); ) {
            LinkedPosition p= cast(LinkedPosition) it.next();
            if (p.offset > current.offset)
                if (found is null || found.offset > p.offset)
                    found= p;
        }

        if (found !is null) {
            return fList.indexOf(found);
        } else if (fIsCycling) {
            return 0;
        } else
            return fSize;
    }

    bool hasPrevious(LinkedPosition current) {
        return getPreviousIndex(current) !is -1;
    }

    private int getPreviousIndex(LinkedPosition current) {
        if (current !is null && fList.get(fIndex) !is current)
            return findPrevious(current);
        else if (fIsCycling && fIndex is 0)
            return fSize - 1;
        else
            return fIndex - 1;
    }

    /**
     * Finds the closest position in the iteration set that precedes
     * <code>current</code>. If <code>current</code>
     * is in the iteration set, the previous in turn is chosen.
     *
     * @param current the current position
     * @return the index of the previous position
     */
    private int findPrevious(LinkedPosition current) {
        Assert.isNotNull(current);
        // if the position is in the iteration set, jump to the next one
        int index= fList.indexOf(current);
        if (index !is -1) {
            if (fIsCycling && index is 0)
                return fSize - 1;
            return index - 1;
        }

        // index is -1

        // find the position that follows closest to the current position
        LinkedPosition found= null;
        for (Iterator it= fList.iterator(); it.hasNext(); ) {
            LinkedPosition p= cast(LinkedPosition) it.next();
            if (p.offset < current.offset)
                if (found is null || found.offset < p.offset)
                    found= p;
        }
        if (found !is null) {
            return fList.indexOf(found);
        } else if (fIsCycling) {
            return fSize - 1;
        } else
            return -1;
    }

    LinkedPosition next(LinkedPosition current) {
        if (!hasNext(current))
            throw new NoSuchElementException(null);
        return cast(LinkedPosition) fList.get(fIndex= getNextIndex(current));
    }

    LinkedPosition previous(LinkedPosition current) {
        if (!hasPrevious(current))
            throw new NoSuchElementException(null);
        return cast(LinkedPosition) fList.get(fIndex= getPreviousIndex(current));
    }

    void setCycling(bool mode) {
        fIsCycling= mode;
    }

    void addPosition(Position position) {
        fList.add(fSize++, position);
        Collections.sort(fList, fComparator);
    }

    void removePosition(Position position) {
        if (fList.remove(position))
            fSize--;
    }

    /**
     * @return Returns the isCycling.
     */
    bool isCycling() {
        return fIsCycling;
    }

    LinkedPosition[] getPositions() {
        return arraycast!(LinkedPosition)( fList.toArray());
    }
}
