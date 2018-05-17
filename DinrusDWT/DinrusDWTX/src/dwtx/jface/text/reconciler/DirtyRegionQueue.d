/*******************************************************************************
 * Copyright (c) 2000, 2008 IBM Corporation and others.
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
module dwtx.jface.text.reconciler.DirtyRegionQueue;

import dwtx.jface.text.reconciler.IReconciler; // packageimport
import dwtx.jface.text.reconciler.IReconcilingStrategy; // packageimport
import dwtx.jface.text.reconciler.AbstractReconcileStep; // packageimport
import dwtx.jface.text.reconciler.IReconcilingStrategyExtension; // packageimport
import dwtx.jface.text.reconciler.MonoReconciler; // packageimport
import dwtx.jface.text.reconciler.IReconcileStep; // packageimport
import dwtx.jface.text.reconciler.AbstractReconciler; // packageimport
import dwtx.jface.text.reconciler.Reconciler; // packageimport
import dwtx.jface.text.reconciler.IReconcilableModel; // packageimport
import dwtx.jface.text.reconciler.DirtyRegion; // packageimport
import dwtx.jface.text.reconciler.IReconcileResult; // packageimport
import dwtx.jface.text.reconciler.IReconcilerExtension; // packageimport


import dwt.dwthelper.utils;

import dwtx.dwtxhelper.Collection;

import tango.core.sync.Mutex;
import tango.core.sync.Condition;

/**
 * Queue used by {@link dwtx.jface.text.reconciler.AbstractReconciler} to manage
 * dirty regions. When a dirty region is inserted into the queue, the queue tries
 * to fold it into the neighboring dirty region.
 *
 * @see dwtx.jface.text.reconciler.AbstractReconciler
 * @see dwtx.jface.text.reconciler.DirtyRegion
 */
class DirtyRegionQueue : Mutex {

    /** The list of dirty regions. */
    private List fDirtyRegions;
    private Condition cond;
    /**
     * Creates a new empty dirty region.
     */
    public this() {
        //super();
        fDirtyRegions= new ArrayList();
        cond = new Condition(this);
    }

    public void wait(){
        cond.wait();
    }
    public void wait(int delay){
        cond.wait(delay/1000.0);
    }
    public void notifyAll(){
        cond.notifyAll();
    }

    /**
     * Adds a dirty region to the end of the dirty-region queue.
     *
     * @param dr the dirty region to add
     */
    public void addDirtyRegion(DirtyRegion dr) {
        // If the dirty region being added is directly after the last dirty
        // region on the queue then merge the two dirty regions together.
        DirtyRegion lastDR= getLastDirtyRegion();
        bool wasMerged= false;
        if (lastDR !is null)
            if (lastDR.getType() is dr.getType())
                if (lastDR.getType() is DirtyRegion.INSERT) {
                    if (lastDR.getOffset() + lastDR.getLength() is dr.getOffset()) {
                        lastDR.mergeWith(dr);
                        wasMerged= true;
                    }
                } else if (lastDR.getType() is DirtyRegion.REMOVE) {
                    if (dr.getOffset() + dr.getLength() is lastDR.getOffset()) {
                        lastDR.mergeWith(dr);
                        wasMerged= true;
                    }
                }

        if (!wasMerged)
            // Don't merge- just add the new one onto the queue.
            fDirtyRegions.add(dr);
    }

    /**
     * Returns the last dirty region that was added to the queue.
     *
     * @return the last DirtyRegion on the queue
     */
    private DirtyRegion getLastDirtyRegion() {
        int size= fDirtyRegions.size();
        return (size is 0 ? null : cast(DirtyRegion) fDirtyRegions.get(size - 1));
    }

    /**
     * Returns the number of regions in the queue.
     *
     * @return the dirty-region queue-size
     */
    public int getSize() {
        return fDirtyRegions.size();
    }

    /**
     * Throws away all entries in the queue.
     */
    public void purgeQueue() {
        fDirtyRegions.clear();
    }

    /**
     * Removes and returns the first dirty region in the queue
     *
     * @return the next dirty region on the queue
     */
    public DirtyRegion removeNextDirtyRegion() {
        if (fDirtyRegions.size() is 0)
            return null;
        DirtyRegion dr= cast(DirtyRegion) fDirtyRegions.get(0);
        fDirtyRegions.remove(0);
        return dr;
    }
}
