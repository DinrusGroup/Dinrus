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
module dwtx.jface.text.reconciler.IReconcilableModel;

import dwtx.jface.text.reconciler.IReconciler; // packageimport
import dwtx.jface.text.reconciler.DirtyRegionQueue; // packageimport
import dwtx.jface.text.reconciler.IReconcilingStrategy; // packageimport
import dwtx.jface.text.reconciler.AbstractReconcileStep; // packageimport
import dwtx.jface.text.reconciler.IReconcilingStrategyExtension; // packageimport
import dwtx.jface.text.reconciler.MonoReconciler; // packageimport
import dwtx.jface.text.reconciler.IReconcileStep; // packageimport
import dwtx.jface.text.reconciler.AbstractReconciler; // packageimport
import dwtx.jface.text.reconciler.Reconciler; // packageimport
import dwtx.jface.text.reconciler.DirtyRegion; // packageimport
import dwtx.jface.text.reconciler.IReconcileResult; // packageimport
import dwtx.jface.text.reconciler.IReconcilerExtension; // packageimport


import dwt.dwthelper.utils;


/**
 * Tagging interface for a model that can get reconciled during a
 * {@linkplain dwtx.jface.text.reconciler.IReconcileStep reconcile step}.
 * <p>
 * This model is not directly used by a {@linkplain dwtx.jface.text.reconciler.IReconciler reconciler}
 * or a {@linkplain dwtx.jface.text.reconciler.IReconcilingStrategy reconciling strategy}.
 * </p>
 *
 * <p>
 * This interface must be implemented by clients that want to use one of
 * their models as a reconcile step's input model.
 * </p>
 *
 * @see dwtx.jface.text.reconciler.IReconcileStep#setInputModel(IReconcilableModel)
 * @since 3.0
 */
public interface IReconcilableModel {

}
