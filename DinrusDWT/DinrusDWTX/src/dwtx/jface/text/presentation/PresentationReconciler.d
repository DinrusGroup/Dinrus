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


module dwtx.jface.text.presentation.PresentationReconciler;

import dwtx.jface.text.presentation.IPresentationDamager; // packageimport
import dwtx.jface.text.presentation.IPresentationReconciler; // packageimport
import dwtx.jface.text.presentation.IPresentationRepairer; // packageimport
import dwtx.jface.text.presentation.IPresentationReconcilerExtension; // packageimport

import dwt.dwthelper.utils;

import dwtx.dwtxhelper.Collection;



import dwt.custom.StyleRange;
import dwtx.core.runtime.Assert;
import dwtx.jface.text.BadLocationException;
import dwtx.jface.text.BadPositionCategoryException;
import dwtx.jface.text.DefaultPositionUpdater;
import dwtx.jface.text.DocumentEvent;
import dwtx.jface.text.DocumentPartitioningChangedEvent;
import dwtx.jface.text.IDocument;
import dwtx.jface.text.IDocumentExtension3;
import dwtx.jface.text.IDocumentListener;
import dwtx.jface.text.IDocumentPartitioningListener;
import dwtx.jface.text.IDocumentPartitioningListenerExtension;
import dwtx.jface.text.IDocumentPartitioningListenerExtension2;
import dwtx.jface.text.IPositionUpdater;
import dwtx.jface.text.IRegion;
import dwtx.jface.text.ITextInputListener;
import dwtx.jface.text.ITextListener;
import dwtx.jface.text.ITextViewer;
import dwtx.jface.text.ITextViewerExtension5;
import dwtx.jface.text.ITypedRegion;
import dwtx.jface.text.Region;
import dwtx.jface.text.TextEvent;
import dwtx.jface.text.TextPresentation;
import dwtx.jface.text.TextUtilities;
import dwtx.jface.text.TypedPosition;



/**
 * Standard implementation of <code>IPresentationReconciler</code>. This
 * implementation assumes that the tasks performed by its presentation damagers
 * and repairers are lightweight and of low cost. This presentation reconciler
 * runs in the UI thread and always repairs the complete damage caused by a
 * document change rather than just the portion overlapping with the viewer's
 * viewport.
 * <p>
 * Usually, clients instantiate this class and configure it before using it.
 * </p>
 */
public class PresentationReconciler : IPresentationReconciler, IPresentationReconcilerExtension {

    /** Prefix of the name of the position category for tracking damage regions. */
    protected const static String TRACKED_PARTITION= "__reconciler_tracked_partition"; //$NON-NLS-1$


    /**
     * Internal listener class.
     */
    class InternalListener :
            ITextInputListener, IDocumentListener, ITextListener,
            IDocumentPartitioningListener, IDocumentPartitioningListenerExtension, IDocumentPartitioningListenerExtension2 {

        /** Set to <code>true</code> if between a document about to be changed and a changed event. */
        private bool fDocumentChanging= false;
        /**
         * The cached redraw state of the text viewer.
         * @since 3.0
         */
        private bool fCachedRedrawState= true;

        /*
         * @see ITextInputListener#inputDocumentAboutToBeChanged(IDocument, IDocument)
         */
        public void inputDocumentAboutToBeChanged(IDocument oldDocument, IDocument newDocument) {
            if (oldDocument !is null) {
                try {

                    fViewer.removeTextListener(this);
                    oldDocument.removeDocumentListener(this);
                    oldDocument.removeDocumentPartitioningListener(this);

                    oldDocument.removePositionUpdater(fPositionUpdater);
                    oldDocument.removePositionCategory(fPositionCategory);

                } catch (BadPositionCategoryException x) {
                    // should not happened for former input documents;
                }
            }
        }

        /*
         * @see ITextInputListener#inputDocumenChanged(IDocument, IDocument)
         */
        public void inputDocumentChanged(IDocument oldDocument, IDocument newDocument) {

            fDocumentChanging= false;
            fCachedRedrawState= true;

            if (newDocument !is null) {

                newDocument.addPositionCategory(fPositionCategory);
                newDocument.addPositionUpdater(fPositionUpdater);

                newDocument.addDocumentPartitioningListener(this);
                newDocument.addDocumentListener(this);
                fViewer.addTextListener(this);

                setDocumentToDamagers(newDocument);
                setDocumentToRepairers(newDocument);
                processDamage(new Region(0, newDocument.getLength()), newDocument);
            }
        }

        /*
         * @see IDocumentPartitioningListener#documentPartitioningChanged(IDocument)
         */
        public void documentPartitioningChanged(IDocument document) {
            if (!fDocumentChanging && fCachedRedrawState)
                processDamage(new Region(0, document.getLength()), document);
            else
                fDocumentPartitioningChanged= true;
        }

        /*
         * @see IDocumentPartitioningListenerExtension#documentPartitioningChanged(IDocument, IRegion)
         * @since 2.0
         */
        public void documentPartitioningChanged(IDocument document, IRegion changedRegion) {
            if (!fDocumentChanging && fCachedRedrawState) {
                processDamage(new Region(changedRegion.getOffset(), changedRegion.getLength()), document);
            } else {
                fDocumentPartitioningChanged= true;
                fChangedDocumentPartitions= changedRegion;
            }
        }

        /*
         * @see dwtx.jface.text.IDocumentPartitioningListenerExtension2#documentPartitioningChanged(dwtx.jface.text.DocumentPartitioningChangedEvent)
         * @since 3.0
         */
        public void documentPartitioningChanged(DocumentPartitioningChangedEvent event) {
            IRegion changedRegion= event.getChangedRegion(getDocumentPartitioning());
            if (changedRegion !is null)
                documentPartitioningChanged(event.getDocument(), changedRegion);
        }

        /*
         * @see IDocumentListener#documentAboutToBeChanged(DocumentEvent)
         */
        public void documentAboutToBeChanged(DocumentEvent e) {

            fDocumentChanging= true;
            if (fCachedRedrawState) {
                try {
                    int offset= e.getOffset() + e.getLength();
                    ITypedRegion region= getPartition(e.getDocument(), offset);
                    fRememberedPosition= new TypedPosition(region);
                    e.getDocument().addPosition(fPositionCategory, fRememberedPosition);
                } catch (BadLocationException x) {
                    // can not happen
                } catch (BadPositionCategoryException x) {
                    // should not happen on input elements
                }
            }
        }

        /*
         * @see IDocumentListener#documentChanged(DocumentEvent)
         */
        public void documentChanged(DocumentEvent e) {
            if (fCachedRedrawState) {
                try {
                    e.getDocument().removePosition(fPositionCategory, fRememberedPosition);
                } catch (BadPositionCategoryException x) {
                    // can not happen on input documents
                }
            }
            fDocumentChanging= false;
        }

        /*
         * @see ITextListener#textChanged(TextEvent)
         */
        public void textChanged(TextEvent e) {

            fCachedRedrawState= e.getViewerRedrawState();
            if (!fCachedRedrawState)
                return;

            IRegion damage= null;
            IDocument document= null;

            if (e.getDocumentEvent() is null) {
                document= fViewer.getDocument();
                if (document !is null)  {
                    if (e.getOffset() is 0 && e.getLength() is 0 && e.getText() is null) {
                        // redraw state change, damage the whole document
                        damage= new Region(0, document.getLength());
                    } else {
                        IRegion region= widgetRegion2ModelRegion(e);
                        try {
                            String text= document.get(region.getOffset(), region.getLength());
                            DocumentEvent de= new DocumentEvent(document, region.getOffset(), region.getLength(), text);
                            damage= getDamage(de, false);
                        } catch (BadLocationException x) {
                        }
                    }
                }
            } else  {
                DocumentEvent de= e.getDocumentEvent();
                document= de.getDocument();
                damage= getDamage(de, true);
            }

            if (damage !is null && document !is null)
                processDamage(damage, document);

            fDocumentPartitioningChanged= false;
            fChangedDocumentPartitions= null;
        }

        /**
         * Translates the given text event into the corresponding range of the viewer's document.
         *
         * @param e the text event
         * @return the widget region corresponding the region of the given event
         * @since 2.1
         */
        protected IRegion widgetRegion2ModelRegion(TextEvent e) {

            String text= e.getText();
            int length= text is null ? 0 : text.length();

            if ( cast(ITextViewerExtension5)fViewer ) {
                ITextViewerExtension5 extension= cast(ITextViewerExtension5) fViewer;
                return extension.widgetRange2ModelRange(new Region(e.getOffset(), length));
            }

            IRegion visible= fViewer.getVisibleRegion();
            IRegion region= new Region(e.getOffset() + visible.getOffset(), length);
            return region;
        }
    }

    /** The map of presentation damagers. */
    private Map fDamagers;
    /** The map of presentation repairers. */
    private Map fRepairers;
    /** The target viewer. */
    private ITextViewer fViewer;
    /** The internal listener. */
    private InternalListener fInternalListener;
    /** The name of the position category to track damage regions. */
    private String fPositionCategory;
    /** The position updated for the damage regions' position category. */
    private IPositionUpdater fPositionUpdater;
    /** The positions representing the damage regions. */
    private TypedPosition fRememberedPosition;
    /** Flag indicating the receipt of a partitioning changed notification. */
    private bool fDocumentPartitioningChanged= false;
    /** The range covering the changed partitioning. */
    private IRegion fChangedDocumentPartitions= null;
    /**
     * The partitioning used by this presentation reconciler.
     * @since 3.0
     */
    private String fPartitioning;

    /**
     * Creates a new presentation reconciler. There are no damagers or repairers
     * registered with this reconciler by default. The default partitioning
     * <code>IDocumentExtension3.DEFAULT_PARTITIONING</code> is used.
     */
    public this() {
        fInternalListener= new InternalListener();
//         super();
        fPartitioning= IDocumentExtension3.DEFAULT_PARTITIONING;
        fPositionCategory= TRACKED_PARTITION ~ Integer.toString(toHash());
        fPositionUpdater= new DefaultPositionUpdater(fPositionCategory);
    }

    /**
     * Sets the document partitioning for this presentation reconciler.
     *
     * @param partitioning the document partitioning for this presentation reconciler.
     * @since 3.0
     */
    public void setDocumentPartitioning(String partitioning) {
        Assert.isNotNull(partitioning);
        fPartitioning= partitioning;
    }

    /*
     * @see dwtx.jface.text.presentation.IPresentationReconcilerExtension#geDocumenttPartitioning()
     * @since 3.0
     */
    public String getDocumentPartitioning() {
        return fPartitioning;
    }

    /**
     * Registers the given presentation damager for a particular content type.
     * If there is already a damager registered for this type, the old damager
     * is removed first.
     *
     * @param damager the presentation damager to register, or <code>null</code> to remove an existing one
     * @param contentType the content type under which to register
     */
    public void setDamager(IPresentationDamager damager, String contentType) {

        Assert.isNotNull(contentType);

        if (fDamagers is null)
            fDamagers= new HashMap();

        if (damager is null)
            fDamagers.remove(contentType);
        else
            fDamagers.put(stringcast(contentType), cast(Object)damager);
    }

    /**
     * Registers the given presentation repairer for a particular content type.
     * If there is already a repairer registered for this type, the old repairer
     * is removed first.
     *
     * @param repairer the presentation repairer to register, or <code>null</code> to remove an existing one
     * @param contentType the content type under which to register
     */
    public void setRepairer(IPresentationRepairer repairer, String contentType) {

        Assert.isNotNull(contentType);

        if (fRepairers is null)
            fRepairers= new HashMap();

        if (repairer is null)
            fRepairers.remove(contentType);
        else
            fRepairers.put(stringcast(contentType), cast(Object)repairer);
    }

    /*
     * @see IPresentationReconciler#install(ITextViewer)
     */
    public void install(ITextViewer viewer) {
        Assert.isNotNull(cast(Object)viewer);

        fViewer= viewer;
        fViewer.addTextInputListener(fInternalListener);

        IDocument document= viewer.getDocument();
        if (document !is null)
            fInternalListener.inputDocumentChanged(null, document);
    }

    /*
     * @see IPresentationReconciler#uninstall()
     */
    public void uninstall() {
        fViewer.removeTextInputListener(fInternalListener);

        // Ensure we uninstall all listeners
        fInternalListener.inputDocumentAboutToBeChanged(fViewer.getDocument(), null);
    }

    /*
     * @see IPresentationReconciler#getDamager(String)
     */
    public IPresentationDamager getDamager(String contentType) {

        if (fDamagers is null)
            return null;

        return cast(IPresentationDamager) fDamagers.get(contentType);
    }

    /*
     * @see IPresentationReconciler#getRepairer(String)
     */
    public IPresentationRepairer getRepairer(String contentType) {

        if (fRepairers is null)
            return null;

        return cast(IPresentationRepairer) fRepairers.get(contentType);
    }

    /**
     * Informs all registered damagers about the document on which they will work.
     *
     * @param document the document on which to work
     */
    protected void setDocumentToDamagers(IDocument document) {
        if (fDamagers !is null) {
            Iterator e= fDamagers.values().iterator();
            while (e.hasNext()) {
                IPresentationDamager damager= cast(IPresentationDamager) e.next();
                damager.setDocument(document);
            }
        }
    }

    /**
     * Informs all registered repairers about the document on which they will work.
     *
     * @param document the document on which to work
     */
    protected void setDocumentToRepairers(IDocument document) {
        if (fRepairers !is null) {
            Iterator e= fRepairers.values().iterator();
            while (e.hasNext()) {
                IPresentationRepairer repairer= cast(IPresentationRepairer) e.next();
                repairer.setDocument(document);
            }
        }
    }

    /**
     * Constructs a "repair description" for the given damage and returns this
     * description as a text presentation. For this, it queries the partitioning
     * of the damage region and asks the appropriate presentation repairer for
     * each partition to construct the "repair description" for this partition.
     *
     * @param damage the damage to be repaired
     * @param document the document whose presentation must be repaired
     * @return the presentation repair description as text presentation or
     *         <code>null</code> if the partitioning could not be computed
     */
    protected TextPresentation createPresentation(IRegion damage, IDocument document) {
        try {
            if (fRepairers is null || fRepairers.isEmpty()) {
                TextPresentation presentation= new TextPresentation(damage, 100);
                presentation.setDefaultStyleRange(new StyleRange(damage.getOffset(), damage.getLength(), null, null));
                return presentation;
            }

            TextPresentation presentation= new TextPresentation(damage, 1000);

            ITypedRegion[] partitioning= TextUtilities.computePartitioning(document, getDocumentPartitioning(), damage.getOffset(), damage.getLength(), false);
            for (int i= 0; i < partitioning.length; i++) {
                ITypedRegion r= partitioning[i];
                IPresentationRepairer repairer= getRepairer(r.getType());
                if (repairer !is null)
                    repairer.createPresentation(presentation, r);
            }

            return presentation;

        } catch (BadLocationException x) {
            return null;
        }
    }


    /**
     * Checks for the first and the last affected partition affected by a
     * document event and calls their damagers. Invalidates everything from the
     * start of the damage for the first partition until the end of the damage
     * for the last partition.
     *
     * @param e the event describing the document change
     * @param optimize <code>true</code> if partition changes should be
     *        considered for optimization
     * @return the damaged caused by the change or <code>null</code> if
     *         computing the partitioning failed
     * @since 3.0
     */
    private IRegion getDamage(DocumentEvent e, bool optimize) {
        int length= e.getText() is null ? 0 : e.getText().length();

        if (fDamagers is null || fDamagers.isEmpty()) {
            length= Math.max(e.getLength(), length);
            length= Math.min(e.getDocument().getLength() - e.getOffset(), length);
            return new Region(e.getOffset(), length);
        }

        bool isDeletion= length is 0;
        IRegion damage= null;
        try {
            int offset= e.getOffset();
            if (isDeletion)
                offset= Math.max(0, offset - 1);
            ITypedRegion partition= getPartition(e.getDocument(), offset);
            IPresentationDamager damager= getDamager(partition.getType());
            if (damager is null)
                return null;

            IRegion r= damager.getDamageRegion(partition, e, fDocumentPartitioningChanged);

            if (!fDocumentPartitioningChanged && optimize && !isDeletion) {
                damage= r;
            } else {

                int damageEnd= getDamageEndOffset(e);

                int parititionDamageEnd= -1;
                if (fChangedDocumentPartitions !is null)
                    parititionDamageEnd= fChangedDocumentPartitions.getOffset() + fChangedDocumentPartitions.getLength();

                int end= Math.max(damageEnd, parititionDamageEnd);

                damage= end is -1 ? r : new Region(r.getOffset(), end - r.getOffset());
            }

        } catch (BadLocationException x) {
        }

        return damage;
    }

    /**
     * Returns the end offset of the damage. If a partition has been split by
     * the given document event also the second half of the original
     * partition must be considered. This is achieved by using the remembered
     * partition range.
     *
     * @param e the event describing the change
     * @return the damage end offset (excluding)
     * @exception BadLocationException if method accesses invalid offset
     */
    private int getDamageEndOffset(DocumentEvent e)  {

        IDocument d= e.getDocument();

        int length= 0;
        if (e.getText() !is null) {
            length= e.getText().length;
            if (length > 0)
                -- length;
        }

        ITypedRegion partition= getPartition(d, e.getOffset() + length);
        int endOffset= partition.getOffset() + partition.getLength();
        if (endOffset is e.getOffset())
            return -1;

        int end= fRememberedPosition is null ? -1 : fRememberedPosition.getOffset() + fRememberedPosition.getLength();
        if (endOffset < end && end < d.getLength())
            partition= getPartition(d, end);

        IPresentationDamager damager= getDamager(partition.getType());
        if (damager is null)
            return -1;

        IRegion r= damager.getDamageRegion(partition, e, fDocumentPartitioningChanged);

        return r.getOffset() + r.getLength();
    }

    /**
     * Processes the given damage.
     * @param damage the damage to be repaired
     * @param document the document whose presentation must be repaired
     */
    private void processDamage(IRegion damage, IDocument document) {
        if (damage !is null && damage.getLength() > 0) {
            TextPresentation p= createPresentation(damage, document);
            if (p !is null)
                applyTextRegionCollection(p);
        }
    }

    /**
     * Applies the given text presentation to the text viewer the presentation
     * reconciler is installed on.
     *
     * @param presentation the text presentation to be applied to the text viewer
     */
    private void applyTextRegionCollection(TextPresentation presentation) {
        fViewer.changeTextPresentation(presentation, false);
    }

    /**
     * Returns the partition for the given offset in the given document.
     *
     * @param document the document
     * @param offset the offset
     * @return the partition
     * @throws BadLocationException if offset is invalid in the given document
     * @since 3.0
     */
    private ITypedRegion getPartition(IDocument document, int offset)  {
        return TextUtilities.getPartition(document, getDocumentPartitioning(), offset, false);
    }
}
