/*******************************************************************************
 * Copyright (c) 2000, 2007 IBM Corporation and others.
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
module dwtx.jface.text.reconciler.MonoReconciler;

import dwtx.jface.text.reconciler.IReconciler; // packageimport
import dwtx.jface.text.reconciler.DirtyRegionQueue; // packageimport
import dwtx.jface.text.reconciler.IReconcilingStrategy; // packageimport
import dwtx.jface.text.reconciler.AbstractReconcileStep; // packageimport
import dwtx.jface.text.reconciler.IReconcilingStrategyExtension; // packageimport
import dwtx.jface.text.reconciler.IReconcileStep; // packageimport
import dwtx.jface.text.reconciler.AbstractReconciler; // packageimport
import dwtx.jface.text.reconciler.Reconciler; // packageimport
import dwtx.jface.text.reconciler.IReconcilableModel; // packageimport
import dwtx.jface.text.reconciler.DirtyRegion; // packageimport
import dwtx.jface.text.reconciler.IReconcileResult; // packageimport
import dwtx.jface.text.reconciler.IReconcilerExtension; // packageimport


import dwt.dwthelper.utils;


import dwtx.core.runtime.Assert;
import dwtx.core.runtime.IProgressMonitor;
import dwtx.jface.text.IDocument;
import dwtx.jface.text.Region;


/**
 * Standard implementation of {@link dwtx.jface.text.reconciler.IReconciler}.
 * The reconciler is configured with a single {@linkplain dwtx.jface.text.reconciler.IReconcilingStrategy reconciling strategy}
 * that is used independently from where a dirty region is located in the reconciler's
 * document.
 * <p>
 * Usually, clients instantiate this class and configure it before using it.
 * </p>
 *
 * @see dwtx.jface.text.IDocumentListener
 * @see dwtx.jface.text.ITextInputListener
 * @see dwtx.jface.text.reconciler.DirtyRegion
 * @since 2.0
 */
public class MonoReconciler : AbstractReconciler {


    /** The reconciling strategy. */
    private IReconcilingStrategy fStrategy;


    /**
     * Creates a new reconciler that uses the same reconciling strategy to
     * reconcile its document independent of the type of the document's contents.
     *
     * @param strategy the reconciling strategy to be used
     * @param isIncremental the indication whether strategy is incremental or not
     */
    public this(IReconcilingStrategy strategy, bool isIncremental) {
        Assert.isNotNull(cast(Object)strategy);
        fStrategy= strategy;
        if ( cast(IReconcilingStrategyExtension)fStrategy ) {
            IReconcilingStrategyExtension extension= cast(IReconcilingStrategyExtension)fStrategy;
            extension.setProgressMonitor(getProgressMonitor());
        }

        setIsIncrementalReconciler(isIncremental);
    }

    /*
     * @see IReconciler#getReconcilingStrategy(String)
     */
    public IReconcilingStrategy getReconcilingStrategy(String contentType) {
        Assert.isNotNull(contentType);
        return fStrategy;
    }

    /*
     * @see AbstractReconciler#process(DirtyRegion)
     */
    protected void process(DirtyRegion dirtyRegion) {

        if(dirtyRegion !is null)
            fStrategy.reconcile(dirtyRegion, dirtyRegion);
        else {
            IDocument document= getDocument();
            if (document !is null)
                fStrategy.reconcile(new Region(0, document.getLength()));
        }
    }

    /*
     * @see AbstractReconciler#reconcilerDocumentChanged(IDocument)
     */
    protected void reconcilerDocumentChanged(IDocument document) {
        fStrategy.setDocument(document);
    }

    /*
     * @see AbstractReconciler#setProgressMonitor(IProgressMonitor)
     */
    public void setProgressMonitor(IProgressMonitor monitor) {
        super.setProgressMonitor(monitor);
        if ( cast(IReconcilingStrategyExtension)fStrategy ) {
            IReconcilingStrategyExtension extension= cast(IReconcilingStrategyExtension) fStrategy;
            extension.setProgressMonitor(monitor);
        }
    }

    /*
     * @see AbstractReconciler#initialProcess()
     */
    protected void initialProcess() {
        if ( cast(IReconcilingStrategyExtension)fStrategy ) {
            IReconcilingStrategyExtension extension= cast(IReconcilingStrategyExtension) fStrategy;
            extension.initialReconcile();
        }
    }
}
