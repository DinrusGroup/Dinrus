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
module dwtx.jface.text.PaintManager;

import dwtx.jface.text.IDocumentPartitioningListener; // packageimport
import dwtx.jface.text.DefaultTextHover; // packageimport
import dwtx.jface.text.AbstractInformationControl; // packageimport
import dwtx.jface.text.TextUtilities; // packageimport
import dwtx.jface.text.IInformationControlCreatorExtension; // packageimport
import dwtx.jface.text.AbstractInformationControlManager; // packageimport
import dwtx.jface.text.ITextViewerExtension2; // packageimport
import dwtx.jface.text.IDocumentPartitioner; // packageimport
import dwtx.jface.text.DefaultIndentLineAutoEditStrategy; // packageimport
import dwtx.jface.text.ITextSelection; // packageimport
import dwtx.jface.text.Document; // packageimport
import dwtx.jface.text.FindReplaceDocumentAdapterContentProposalProvider; // packageimport
import dwtx.jface.text.ITextListener; // packageimport
import dwtx.jface.text.BadPartitioningException; // packageimport
import dwtx.jface.text.ITextViewerExtension5; // packageimport
import dwtx.jface.text.IDocumentPartitionerExtension3; // packageimport
import dwtx.jface.text.IUndoManager; // packageimport
import dwtx.jface.text.ITextHoverExtension2; // packageimport
import dwtx.jface.text.IRepairableDocument; // packageimport
import dwtx.jface.text.IRewriteTarget; // packageimport
import dwtx.jface.text.DefaultPositionUpdater; // packageimport
import dwtx.jface.text.RewriteSessionEditProcessor; // packageimport
import dwtx.jface.text.TextViewerHoverManager; // packageimport
import dwtx.jface.text.DocumentRewriteSession; // packageimport
import dwtx.jface.text.TextViewer; // packageimport
import dwtx.jface.text.ITextViewerExtension8; // packageimport
import dwtx.jface.text.RegExMessages; // packageimport
import dwtx.jface.text.IDelayedInputChangeProvider; // packageimport
import dwtx.jface.text.ITextOperationTargetExtension; // packageimport
import dwtx.jface.text.IWidgetTokenOwner; // packageimport
import dwtx.jface.text.IViewportListener; // packageimport
import dwtx.jface.text.GapTextStore; // packageimport
import dwtx.jface.text.MarkSelection; // packageimport
import dwtx.jface.text.IDocumentPartitioningListenerExtension; // packageimport
import dwtx.jface.text.IDocumentAdapterExtension; // packageimport
import dwtx.jface.text.IInformationControlExtension; // packageimport
import dwtx.jface.text.IDocumentPartitioningListenerExtension2; // packageimport
import dwtx.jface.text.DefaultDocumentAdapter; // packageimport
import dwtx.jface.text.ITextViewerExtension3; // packageimport
import dwtx.jface.text.IInformationControlCreator; // packageimport
import dwtx.jface.text.TypedRegion; // packageimport
import dwtx.jface.text.ISynchronizable; // packageimport
import dwtx.jface.text.IMarkRegionTarget; // packageimport
import dwtx.jface.text.TextViewerUndoManager; // packageimport
import dwtx.jface.text.IRegion; // packageimport
import dwtx.jface.text.IInformationControlExtension2; // packageimport
import dwtx.jface.text.IDocumentExtension4; // packageimport
import dwtx.jface.text.IDocumentExtension2; // packageimport
import dwtx.jface.text.IDocumentPartitionerExtension2; // packageimport
import dwtx.jface.text.Assert; // packageimport
import dwtx.jface.text.DefaultInformationControl; // packageimport
import dwtx.jface.text.IWidgetTokenOwnerExtension; // packageimport
import dwtx.jface.text.DocumentClone; // packageimport
import dwtx.jface.text.DefaultUndoManager; // packageimport
import dwtx.jface.text.IFindReplaceTarget; // packageimport
import dwtx.jface.text.IAutoEditStrategy; // packageimport
import dwtx.jface.text.ILineTrackerExtension; // packageimport
import dwtx.jface.text.IUndoManagerExtension; // packageimport
import dwtx.jface.text.TextSelection; // packageimport
import dwtx.jface.text.DefaultAutoIndentStrategy; // packageimport
import dwtx.jface.text.IAutoIndentStrategy; // packageimport
import dwtx.jface.text.IPainter; // packageimport
import dwtx.jface.text.IInformationControl; // packageimport
import dwtx.jface.text.IInformationControlExtension3; // packageimport
import dwtx.jface.text.ITextViewerExtension6; // packageimport
import dwtx.jface.text.IInformationControlExtension4; // packageimport
import dwtx.jface.text.DefaultLineTracker; // packageimport
import dwtx.jface.text.IDocumentInformationMappingExtension; // packageimport
import dwtx.jface.text.IRepairableDocumentExtension; // packageimport
import dwtx.jface.text.ITextHover; // packageimport
import dwtx.jface.text.FindReplaceDocumentAdapter; // packageimport
import dwtx.jface.text.ILineTracker; // packageimport
import dwtx.jface.text.Line; // packageimport
import dwtx.jface.text.ITextViewerExtension; // packageimport
import dwtx.jface.text.IDocumentAdapter; // packageimport
import dwtx.jface.text.TextEvent; // packageimport
import dwtx.jface.text.BadLocationException; // packageimport
import dwtx.jface.text.AbstractDocument; // packageimport
import dwtx.jface.text.AbstractLineTracker; // packageimport
import dwtx.jface.text.TreeLineTracker; // packageimport
import dwtx.jface.text.ITextPresentationListener; // packageimport
import dwtx.jface.text.Region; // packageimport
import dwtx.jface.text.ITextViewer; // packageimport
import dwtx.jface.text.IDocumentInformationMapping; // packageimport
import dwtx.jface.text.MarginPainter; // packageimport
import dwtx.jface.text.IPaintPositionManager; // packageimport
import dwtx.jface.text.TextPresentation; // packageimport
import dwtx.jface.text.IFindReplaceTargetExtension; // packageimport
import dwtx.jface.text.ISlaveDocumentManagerExtension; // packageimport
import dwtx.jface.text.ISelectionValidator; // packageimport
import dwtx.jface.text.IDocumentExtension; // packageimport
import dwtx.jface.text.PropagatingFontFieldEditor; // packageimport
import dwtx.jface.text.ConfigurableLineTracker; // packageimport
import dwtx.jface.text.SlaveDocumentEvent; // packageimport
import dwtx.jface.text.IDocumentListener; // packageimport
import dwtx.jface.text.IFindReplaceTargetExtension3; // packageimport
import dwtx.jface.text.ITextDoubleClickStrategy; // packageimport
import dwtx.jface.text.IDocumentExtension3; // packageimport
import dwtx.jface.text.Position; // packageimport
import dwtx.jface.text.TextMessages; // packageimport
import dwtx.jface.text.CopyOnWriteTextStore; // packageimport
import dwtx.jface.text.WhitespaceCharacterPainter; // packageimport
import dwtx.jface.text.IPositionUpdater; // packageimport
import dwtx.jface.text.DefaultTextDoubleClickStrategy; // packageimport
import dwtx.jface.text.ListLineTracker; // packageimport
import dwtx.jface.text.ITextInputListener; // packageimport
import dwtx.jface.text.BadPositionCategoryException; // packageimport
import dwtx.jface.text.IWidgetTokenKeeperExtension; // packageimport
import dwtx.jface.text.IInputChangedListener; // packageimport
import dwtx.jface.text.ITextOperationTarget; // packageimport
import dwtx.jface.text.IDocumentInformationMappingExtension2; // packageimport
import dwtx.jface.text.ITextViewerExtension7; // packageimport
import dwtx.jface.text.IInformationControlExtension5; // packageimport
import dwtx.jface.text.IDocumentRewriteSessionListener; // packageimport
import dwtx.jface.text.JFaceTextUtil; // packageimport
import dwtx.jface.text.AbstractReusableInformationControlCreator; // packageimport
import dwtx.jface.text.TabsToSpacesConverter; // packageimport
import dwtx.jface.text.CursorLinePainter; // packageimport
import dwtx.jface.text.ITextHoverExtension; // packageimport
import dwtx.jface.text.IEventConsumer; // packageimport
import dwtx.jface.text.IDocument; // packageimport
import dwtx.jface.text.IWidgetTokenKeeper; // packageimport
import dwtx.jface.text.DocumentCommand; // packageimport
import dwtx.jface.text.TypedPosition; // packageimport
import dwtx.jface.text.IEditingSupportRegistry; // packageimport
import dwtx.jface.text.IDocumentPartitionerExtension; // packageimport
import dwtx.jface.text.AbstractHoverInformationControlManager; // packageimport
import dwtx.jface.text.IEditingSupport; // packageimport
import dwtx.jface.text.IMarkSelection; // packageimport
import dwtx.jface.text.ISlaveDocumentManager; // packageimport
import dwtx.jface.text.DocumentEvent; // packageimport
import dwtx.jface.text.DocumentPartitioningChangedEvent; // packageimport
import dwtx.jface.text.ITextStore; // packageimport
import dwtx.jface.text.JFaceTextMessages; // packageimport
import dwtx.jface.text.DocumentRewriteSessionEvent; // packageimport
import dwtx.jface.text.SequentialRewriteTextStore; // packageimport
import dwtx.jface.text.DocumentRewriteSessionType; // packageimport
import dwtx.jface.text.TextAttribute; // packageimport
import dwtx.jface.text.ITextViewerExtension4; // packageimport
import dwtx.jface.text.ITypedRegion; // packageimport


import dwt.dwthelper.utils;


import dwtx.dwtxhelper.Collection;



import dwt.custom.StyledText;
import dwt.events.KeyEvent;
import dwt.events.KeyListener;
import dwt.events.MouseEvent;
import dwt.events.MouseListener;
import dwt.widgets.Control;
import dwtx.jface.viewers.ISelectionChangedListener;
import dwtx.jface.viewers.ISelectionProvider;
import dwtx.jface.viewers.SelectionChangedEvent;


/**
 * Manages the {@link dwtx.jface.text.IPainter} object registered with an
 * {@link dwtx.jface.text.ITextViewer}.
 * <p>
 * Clients usually instantiate and configure objects of this type.</p>
 *
 * @since 2.1
 */
public final class PaintManager : KeyListener, MouseListener, ISelectionChangedListener, ITextListener, ITextInputListener {

    /**
     * Position updater used by the position manager. This position updater differs from the default position
     * updater in that it extends a position when an insertion happens at the position's offset and right behind
     * the position.
     */
    static class PaintPositionUpdater : DefaultPositionUpdater {

        /**
         * Creates the position updater for the given category.
         *
         * @param category the position category
         */
        protected this(String category) {
            super(category);
        }

        /**
         * If an insertion happens at a position's offset, the
         * position is extended rather than shifted. Also, if something is added
         * right behind the end of the position, the position is extended rather
         * than kept stable.
         */
        protected void adaptToInsert() {

            int myStart= fPosition.offset;
            int myEnd=   fPosition.offset + fPosition.length;
            myEnd= Math.max(myStart, myEnd);

            int yoursStart= fOffset;
            int yoursEnd=   fOffset + fReplaceLength;// - 1;
            yoursEnd= Math.max(yoursStart, yoursEnd);

            if (myEnd < yoursStart)
                return;

            if (myStart <= yoursStart)
                fPosition.length += fReplaceLength;
            else
                fPosition.offset += fReplaceLength;
        }
    }

    /**
     * The paint position manager used by this paint manager. The paint position
     * manager is installed on a single document and control the creation/disposed
     * and updating of a position category that will be used for managing positions.
     */
    static class PositionManager : IPaintPositionManager {

//      /** The document this position manager works on */
        private IDocument fDocument;
        /** The position updater used for the managing position category */
        private IPositionUpdater fPositionUpdater;
        /** The managing position category */
        private String fCategory;

        /**
         * Creates a new position manager. Initializes the managing
         * position category using its class name and its hash value.
         */
        public this() {
            fCategory= this.classinfo.name ~ Integer.toString(toHash());
            fPositionUpdater= new PaintPositionUpdater(fCategory);
        }

        /**
         * Installs this position manager in the given document. The position manager stays
         * active until <code>uninstall</code> or <code>dispose</code>
         * is called.
         *
         * @param document the document to be installed on
         */
        public void install(IDocument document) {
            fDocument= document;
            fDocument.addPositionCategory(fCategory);
            fDocument.addPositionUpdater(fPositionUpdater);
        }

        /**
         * Disposes this position manager. The position manager is automatically
         * removed from the document it has previously been installed
         * on.
         */
        public void dispose() {
            uninstall(fDocument);
        }

        /**
         * Uninstalls this position manager form the given document. If the position
         * manager has no been installed on this document, this method is without effect.
         *
         * @param document the document form which to uninstall
         */
        public void uninstall(IDocument document) {
            if (document is fDocument && document !is null) {
                try {
                    fDocument.removePositionUpdater(fPositionUpdater);
                    fDocument.removePositionCategory(fCategory);
                } catch (BadPositionCategoryException x) {
                    // should not happen
                }
                fDocument= null;
            }
        }

        /*
         * @see IPositionManager#addManagedPosition(Position)
         */
        public void managePosition(Position position) {
            try {
                fDocument.addPosition(fCategory, position);
            } catch (BadPositionCategoryException x) {
                // should not happen
            } catch (BadLocationException x) {
                // should not happen
            }
        }

        /*
         * @see IPositionManager#removeManagedPosition(Position)
         */
        public void unmanagePosition(Position position) {
            try {
                fDocument.removePosition(fCategory, position);
            } catch (BadPositionCategoryException x) {
                // should not happen
            }
        }
    }


    /** The painters managed by this paint manager. */
    private List fPainters;
    /** The position manager used by this paint manager */
    private PositionManager fManager;
    /** The associated text viewer */
    private ITextViewer fTextViewer;

    /**
     * Creates a new paint manager for the given text viewer.
     *
     * @param textViewer the text viewer associated to this newly created paint manager
     */
    public this(ITextViewer textViewer) {
        fPainters= new ArrayList(2);
        fTextViewer= textViewer;
    }


    /**
     * Adds the given painter to the list of painters managed by this paint manager.
     * If the painter is already registered with this paint manager, this method is
     * without effect.
     *
     * @param painter the painter to be added
     */
    public void addPainter(IPainter painter) {
        if (!fPainters.contains(cast(Object)painter)) {
            fPainters.add(cast(Object)painter);
            if (fPainters.size() is 1)
                install();
            painter.setPositionManager(fManager);
            painter.paint(IPainter.INTERNAL);
        }
    }

    /**
     * Removes the given painter from the list of painters managed by this
     * paint manager. If the painter has not previously been added to this
     * paint manager, this method is without effect.
     *
     * @param painter the painter to be removed
     */
    public void removePainter(IPainter painter) {
        if (fPainters.remove(cast(Object)painter)) {
            painter.deactivate(true);
            painter.setPositionManager(null);
        }
        if (fPainters.size() is 0)
            dispose();
    }

    /**
     * Installs/activates this paint manager. Is called as soon as the
     * first painter is to be managed by this paint manager.
     */
    private void install() {

        fManager= new PositionManager();
        if (fTextViewer.getDocument() !is null)
            fManager.install(fTextViewer.getDocument());

        fTextViewer.addTextInputListener(this);

        addListeners();
    }

    /**
     * Installs our listener set on the text viewer and the text widget,
     * respectively.
     */
    private void addListeners() {
        ISelectionProvider provider= fTextViewer.getSelectionProvider();
        provider.addSelectionChangedListener(this);

        fTextViewer.addTextListener(this);

        StyledText text= fTextViewer.getTextWidget();
        text.addKeyListener(this);
        text.addMouseListener(this);
    }

    /**
     * Disposes this paint manager. The paint manager uninstalls itself
     * and clears all registered painters. This method is also called when the
     * last painter is removed from the list of managed painters.
     */
    public void dispose() {

        if (fManager !is null) {
            fManager.dispose();
            fManager= null;
        }

        for (Iterator e = fPainters.iterator(); e.hasNext();)
            (cast(IPainter) e.next()).dispose();
        fPainters.clear();

        fTextViewer.removeTextInputListener(this);

        removeListeners();
    }

    /**
     * Removes our set of listeners from the text viewer and widget,
     * respectively.
     */
    private void removeListeners() {
        ISelectionProvider provider= fTextViewer.getSelectionProvider();
        if (provider !is null)
            provider.removeSelectionChangedListener(this);

        fTextViewer.removeTextListener(this);

        StyledText text= fTextViewer.getTextWidget();
        if (text !is null && !text.isDisposed()) {
            text.removeKeyListener(this);
            text.removeMouseListener(this);
        }
    }

    /**
     * Triggers all registered painters for the given reason.
     *
     * @param reason the reason
     * @see IPainter
     */
    private void paint(int reason) {
        for (Iterator e = fPainters.iterator(); e.hasNext();)
            (cast(IPainter) e.next()).paint(reason);
    }

    /*
     * @see KeyListener#keyPressed(KeyEvent)
     */
    public void keyPressed(KeyEvent e) {
        paint(IPainter.KEY_STROKE);
    }

    /*
     * @see KeyListener#keyReleased(KeyEvent)
     */
    public void keyReleased(KeyEvent e) {
    }

    /*
     * @see MouseListener#mouseDoubleClick(MouseEvent)
     */
    public void mouseDoubleClick(MouseEvent e) {
    }

    /*
     * @see MouseListener#mouseDown(MouseEvent)
     */
    public void mouseDown(MouseEvent e) {
        paint(IPainter.MOUSE_BUTTON);
    }

    /*
     * @see MouseListener#mouseUp(MouseEvent)
     */
    public void mouseUp(MouseEvent e) {
    }

    /*
     * @see ISelectionChangedListener#selectionChanged(SelectionChangedEvent)
     */
    public void selectionChanged(SelectionChangedEvent event) {
        paint(IPainter.SELECTION);
    }

    /*
     * @see ITextListener#textChanged(TextEvent)
     */
    public void textChanged(TextEvent event) {

        if (!event.getViewerRedrawState())
            return;

        Control control= fTextViewer.getTextWidget();
        if (control !is null) {
            control.getDisplay().asyncExec(new class()  Runnable {
                public void run() {
                    if (fTextViewer !is null)
                        paint(IPainter.TEXT_CHANGE);
                }
            });
        }
    }

    /*
     * @see ITextInputListener#inputDocumentAboutToBeChanged(IDocument, IDocument)
     */
    public void inputDocumentAboutToBeChanged(IDocument oldInput, IDocument newInput) {
        if (oldInput !is null) {
            for (Iterator e = fPainters.iterator(); e.hasNext();)
                (cast(IPainter) e.next()).deactivate(false);
            fManager.uninstall(oldInput);
            removeListeners();
        }
    }

    /*
     * @see ITextInputListener#inputDocumentChanged(IDocument, IDocument)
     */
    public void inputDocumentChanged(IDocument oldInput, IDocument newInput) {
        if (newInput !is null) {
            fManager.install(newInput);
            paint(IPainter.TEXT_CHANGE);
            addListeners();
        }
    }
}

