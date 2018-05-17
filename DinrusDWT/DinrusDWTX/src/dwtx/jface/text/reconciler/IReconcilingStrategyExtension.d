/*******************************************************************************
 * Copyright (c) 2000, 2005 IBM Corporation and others.
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
module dwtx.jface.text.reconciler.IReconcilingStrategyExtension;

import dwtx.jface.text.reconciler.IReconciler; // packageimport
import dwtx.jface.text.reconciler.DirtyRegionQueue; // packageimport
import dwtx.jface.text.reconciler.IReconcilingStrategy; // packageimport
import dwtx.jface.text.reconciler.AbstractReconcileStep; // packageimport
import dwtx.jface.text.reconciler.MonoReconciler; // packageimport
import dwtx.jface.text.reconciler.IReconcileStep; // packageimport
import dwtx.jface.text.reconciler.AbstractReconciler; // packageimport
import dwtx.jface.text.reconciler.Reconciler; // packageimport
import dwtx.jface.text.reconciler.IReconcilableModel; // packageimport
import dwtx.jface.text.reconciler.DirtyRegion; // packageimport
import dwtx.jface.text.reconciler.IReconcileResult; // packageimport
import dwtx.jface.text.reconciler.IReconcilerExtension; // packageimport


import dwt.dwthelper.utils;

import dwtx.core.runtime.IProgressMonitor;


/**
 * Extends {@link dwtx.jface.text.reconciler.IReconcilingStrategy}
 * with the following functions:
 * <ul>
 *  <li>usage of a progress monitor</li>
 *  <li>initial reconciling step: if a reconciler runs as periodic activity in the background, this
 *      methods offers the reconciler a chance for initializing its strategies and achieving a
 *      reconciled state before the periodic activity starts.</li>
 * </ul>
 *
 * @since 2.0
 */
public interface IReconcilingStrategyExtension {

    /**
     * Tells this reconciling strategy with which progress monitor
     * it will work. This method will be called before any other
     * method and can be called multiple times.
     *
     * @param monitor the progress monitor with which this strategy will work
     */
    void setProgressMonitor(IProgressMonitor monitor);

    /**
     * Called only once in the life time of this reconciling strategy.
     */
    void initialReconcile();
}
