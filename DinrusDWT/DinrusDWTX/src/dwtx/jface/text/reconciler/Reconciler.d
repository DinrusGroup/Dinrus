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
module dwtx.jface.text.reconciler.Reconciler;

import dwtx.jface.text.reconciler.IReconciler; // packageimport
import dwtx.jface.text.reconciler.DirtyRegionQueue; // packageimport
import dwtx.jface.text.reconciler.IReconcilingStrategy; // packageimport
import dwtx.jface.text.reconciler.AbstractReconcileStep; // packageimport
import dwtx.jface.text.reconciler.IReconcilingStrategyExtension; // packageimport
import dwtx.jface.text.reconciler.MonoReconciler; // packageimport
import dwtx.jface.text.reconciler.IReconcileStep; // packageimport
import dwtx.jface.text.reconciler.AbstractReconciler; // packageimport
import dwtx.jface.text.reconciler.IReconcilableModel; // packageimport
import dwtx.jface.text.reconciler.DirtyRegion; // packageimport
import dwtx.jface.text.reconciler.IReconcileResult; // packageimport
import dwtx.jface.text.reconciler.IReconcilerExtension; // packageimport


import dwt.dwthelper.utils;

import dwtx.dwtxhelper.Collection;





import dwtx.core.runtime.Assert;
import dwtx.core.runtime.IProgressMonitor;
import dwtx.jface.text.BadLocationException;
import dwtx.jface.text.IDocument;
import dwtx.jface.text.IDocumentExtension3;
import dwtx.jface.text.IRegion;
import dwtx.jface.text.ITypedRegion;
import dwtx.jface.text.Region;
import dwtx.jface.text.TextUtilities;
import dwtx.jface.text.TypedRegion;


/**
 * Standard implementation of {@link dwtx.jface.text.reconciler.IReconciler}.
 * The reconciler is configured with a set of {@linkplain dwtx.jface.text.reconciler.IReconcilingStrategy reconciling strategies}
 * each of which is responsible for a particular content type.
 * <p>
 * Usually, clients instantiate this class and configure it before using it.
 * </p>
 *
 * @see dwtx.jface.text.IDocumentListener
 * @see dwtx.jface.text.ITextInputListener
 * @see dwtx.jface.text.reconciler.DirtyRegion
 */
public class Reconciler : AbstractReconciler , IReconcilerExtension {

    /** The map of reconciling strategies. */
    private Map fStrategies;

    /**
     * The partitioning this reconciler uses.
     *@since 3.0
     */
    private String fPartitioning;

    /**
     * Creates a new reconciler with the following configuration: it is
     * an incremental reconciler with a standard delay of 500 milliseconds. There
     * are no predefined reconciling strategies. The partitioning it uses
     * is the default partitioning {@link IDocumentExtension3#DEFAULT_PARTITIONING}.
     */
    public this() {
        super();
        fPartitioning= IDocumentExtension3.DEFAULT_PARTITIONING;
    }

    /**
     * Sets the document partitioning for this reconciler.
     *
     * @param partitioning the document partitioning for this reconciler
     * @since 3.0
     */
    public void setDocumentPartitioning(String partitioning) {
        Assert.isNotNull(partitioning);
        fPartitioning= partitioning;
    }

    /*
     * @see dwtx.jface.text.reconciler.IReconcilerExtension#getDocumentPartitioning()
     * @since 3.0
     */
    public String getDocumentPartitioning() {
        return fPartitioning;
    }

    /**
     * Registers a given reconciling strategy for a particular content type.
     * If there is already a strategy registered for this type, the new strategy
     * is registered instead of the old one.
     *
     * @param strategy the reconciling strategy to register, or <code>null</code> to remove an existing one
     * @param contentType the content type under which to register
     */
    public void setReconcilingStrategy(IReconcilingStrategy strategy, String contentType) {

        Assert.isNotNull(contentType);

        if (fStrategies is null)
            fStrategies= new HashMap();

        if (strategy is null)
            fStrategies.remove(contentType);
        else {
            fStrategies.put(contentType, cast(Object)strategy);
            if (cast(IReconcilingStrategyExtension )strategy && getProgressMonitor() !is null) {
                IReconcilingStrategyExtension extension= cast(IReconcilingStrategyExtension) strategy;
                extension.setProgressMonitor(getProgressMonitor());
            }
        }
    }

    /*
     * @see IReconciler#getReconcilingStrategy(String)
     */
    public IReconcilingStrategy getReconcilingStrategy(String contentType) {

        Assert.isNotNull(contentType);

        if (fStrategies is null)
            return null;

        return cast(IReconcilingStrategy) fStrategies.get(contentType);
    }

    /**
     * Processes a dirty region. If the dirty region is <code>null</code> the whole
     * document is consider being dirty. The dirty region is partitioned by the
     * document and each partition is handed over to a reconciling strategy registered
     * for the partition's content type.
     *
     * @param dirtyRegion the dirty region to be processed
     * @see AbstractReconciler#process(DirtyRegion)
     */
    protected void process(DirtyRegion dirtyRegion) {

        IRegion region= dirtyRegion;

        if (region is null)
            region= new Region(0, getDocument().getLength());

        ITypedRegion[] regions= computePartitioning(region.getOffset(), region.getLength());

        for (int i= 0; i < regions.length; i++) {
            ITypedRegion r= regions[i];
            IReconcilingStrategy s= getReconcilingStrategy(r.getType());
            if (s is null)
                continue;

            if(dirtyRegion !is null)
                s.reconcile(dirtyRegion, r);
            else
                s.reconcile(r);
        }
    }

    /*
     * @see AbstractReconciler#reconcilerDocumentChanged(IDocument)
     * @since 2.0
     */
    protected void reconcilerDocumentChanged(IDocument document) {
        if (fStrategies !is null) {
            Iterator e= fStrategies.values().iterator();
            while (e.hasNext()) {
                IReconcilingStrategy strategy= cast(IReconcilingStrategy) e.next();
                strategy.setDocument(document);
            }
        }
    }

    /*
     * @see AbstractReconciler#setProgressMonitor(IProgressMonitor)
     * @since 2.0
     */
    public void setProgressMonitor(IProgressMonitor monitor) {
        super.setProgressMonitor(monitor);

        if (fStrategies !is null) {
            Iterator e= fStrategies.values().iterator();
            while (e.hasNext()) {
                IReconcilingStrategy strategy= cast(IReconcilingStrategy) e.next();
                if ( cast(IReconcilingStrategyExtension)strategy ) {
                    IReconcilingStrategyExtension extension= cast(IReconcilingStrategyExtension) strategy;
                    extension.setProgressMonitor(monitor);
                }
            }
        }
    }

    /*
     * @see AbstractReconciler#initialProcess()
     * @since 2.0
     */
    protected void initialProcess() {
        ITypedRegion[] regions= computePartitioning(0, getDocument().getLength());
        List contentTypes= new ArrayList(regions.length);
        for (int i= 0; i < regions.length; i++) {
            String contentType= regions[i].getType();
            if( contentTypes.contains(contentType))
                continue;
            contentTypes.add(contentType);
            IReconcilingStrategy s= getReconcilingStrategy(contentType);
            if ( cast(IReconcilingStrategyExtension)s ) {
                IReconcilingStrategyExtension e= cast(IReconcilingStrategyExtension) s;
                e.initialReconcile();
            }
        }
    }

    /**
     * Computes and returns the partitioning for the given region of the input document
     * of the reconciler's connected text viewer.
     *
     * @param offset the region offset
     * @param length the region length
     * @return the computed partitioning
     * @since 3.0
     */
    private ITypedRegion[] computePartitioning(int offset, int length) {
        ITypedRegion[] regions= null;
        try {
            regions= TextUtilities.computePartitioning(getDocument(), getDocumentPartitioning(), offset, length, false);
        } catch (BadLocationException x) {
            regions= new ITypedRegion[0];
        }
        return regions;
    }
}
