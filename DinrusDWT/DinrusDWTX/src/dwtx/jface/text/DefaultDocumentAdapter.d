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
module dwtx.jface.text.DefaultDocumentAdapter;

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
import dwtx.jface.text.PaintManager; // packageimport
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



import dwt.DWT;
import dwt.custom.TextChangeListener;
import dwt.custom.TextChangedEvent;
import dwt.custom.TextChangingEvent;
import dwtx.core.runtime.Assert;


/**
 * Default implementation of {@link dwtx.jface.text.IDocumentAdapter}.
 * <p>
 * <strong>Note:</strong> This adapter does not work if the widget auto-wraps the text.
 * </p>
 */
class DefaultDocumentAdapter : IDocumentAdapter, IDocumentListener, IDocumentAdapterExtension {

    /** The adapted document. */
    private IDocument fDocument;
    /** The document clone for the non-forwarding case. */
    private IDocument fDocumentClone;
    /** The original content */
    private String fOriginalContent;
    /** The original line delimiters */
    private String[] fOriginalLineDelimiters;
    /** The registered text change listeners */
    private List fTextChangeListeners;
    /**
     * The remembered document event
     * @since 2.0
     */
    private DocumentEvent fEvent;
    /** The line delimiter */
    private String fLineDelimiter= null;
    /**
     * Indicates whether this adapter is forwarding document changes
     * @since 2.0
     */
    private bool fIsForwarding= true;
    /**
     * Length of document at receipt of <code>documentAboutToBeChanged</code>
     * @since 2.1
     */
    private int fRememberedLengthOfDocument;
    /**
     * Length of first document line at receipt of <code>documentAboutToBeChanged</code>
     * @since 2.1
     */
    private int fRememberedLengthOfFirstLine;
    /**
     * The data of the event at receipt of <code>documentAboutToBeChanged</code>
     * @since 2.1
     */
    private  DocumentEvent fOriginalEvent;


    /**
     * Creates a new document adapter which is initially not connected to
     * any document.
     */
    public this() {
        fTextChangeListeners= new ArrayList(1);
        fOriginalEvent= new DocumentEvent();
    }

    /**
     * Sets the given document as the document to be adapted.
     *
     * @param document the document to be adapted or <code>null</code> if there is no document
     */
    public void setDocument(IDocument document) {

        if (fDocument !is null)
            fDocument.removePrenotifiedDocumentListener(this);

        fDocument= document;
        fLineDelimiter= null;

        if (!fIsForwarding) {
            fDocumentClone= null;
            if (fDocument !is null) {
                fOriginalContent= fDocument.get();
                fOriginalLineDelimiters= fDocument.getLegalLineDelimiters();
            } else {
                fOriginalContent= null;
                fOriginalLineDelimiters= null;
            }
        }

        if (fDocument !is null)
            fDocument.addPrenotifiedDocumentListener(this);
    }

    /*
     * @see StyledTextContent#addTextChangeListener(TextChangeListener)
     */
    public void addTextChangeListener(TextChangeListener listener) {
        Assert.isNotNull(cast(Object)listener);
        if (!fTextChangeListeners.contains(cast(Object)listener))
            fTextChangeListeners.add(cast(Object)listener);
    }

    /*
     * @see StyledTextContent#removeTextChangeListener(TextChangeListener)
     */
    public void removeTextChangeListener(TextChangeListener listener) {
        Assert.isNotNull(cast(Object)listener);
        fTextChangeListeners.remove(cast(Object)listener);
    }

    /**
     * Tries to repair the line information.
     *
     * @param document the document
     * @see IRepairableDocument#repairLineInformation()
     * @since 3.0
     */
    private void repairLineInformation(IDocument document) {
        if ( cast(IRepairableDocument)document ) {
            IRepairableDocument repairable= cast(IRepairableDocument) document;
            repairable.repairLineInformation();
        }
    }

    /**
     * Returns the line for the given line number.
     *
     * @param document the document
     * @param line the line number
     * @return the content of the line of the given number in the given document
     * @throws BadLocationException if the line number is invalid for the adapted document
     * @since 3.0
     */
    private String doGetLine(IDocument document, int line)  {
        IRegion r= document.getLineInformation(line);
        return document.get(r.getOffset(), r.getLength());
    }

    private IDocument getDocumentForRead() {
        if (!fIsForwarding) {
            if (fDocumentClone is null) {
                String content= fOriginalContent is null ? "" : fOriginalContent; //$NON-NLS-1$
                String[] delims= fOriginalLineDelimiters is null ? DefaultLineTracker.DELIMITERS : fOriginalLineDelimiters;
                fDocumentClone= new DocumentClone(content, delims);
            }
            return fDocumentClone;
        }

        return fDocument;
    }

    /*
     * @see StyledTextContent#getLine(int)
     */
    public String getLine(int line) {

        IDocument document= getDocumentForRead();
        try {
            return doGetLine(document, line);
        } catch (BadLocationException x) {
            repairLineInformation(document);
            try {
                return doGetLine(document, line);
            } catch (BadLocationException x2) {
            }
        }

        DWT.error(DWT.ERROR_INVALID_ARGUMENT);
        return null;
    }

    /*
     * @see StyledTextContent#getLineAtOffset(int)
     */
    public int getLineAtOffset(int offset) {
        IDocument document= getDocumentForRead();
        try {
            return document.getLineOfOffset(offset);
        } catch (BadLocationException x) {
            repairLineInformation(document);
            try {
                return document.getLineOfOffset(offset);
            } catch (BadLocationException x2) {
            }
        }

        DWT.error(DWT.ERROR_INVALID_ARGUMENT);
        return -1;
    }

    /*
     * @see StyledTextContent#getLineCount()
     */
    public int getLineCount() {
        return getDocumentForRead().getNumberOfLines();
    }

    /*
     * @see StyledTextContent#getOffsetAtLine(int)
     */
    public int getOffsetAtLine(int line) {
        IDocument document= getDocumentForRead();
        try {
            return document.getLineOffset(line);
        } catch (BadLocationException x) {
            repairLineInformation(document);
            try {
                return document.getLineOffset(line);
            } catch (BadLocationException x2) {
            }
        }

        DWT.error(DWT.ERROR_INVALID_ARGUMENT);
        return -1;
    }

    /*
     * @see StyledTextContent#getTextRange(int, int)
     */
    public String getTextRange(int offset, int length) {
        try {
            return getDocumentForRead().get(offset, length);
        } catch (BadLocationException x) {
            DWT.error(DWT.ERROR_INVALID_ARGUMENT);
            return null;
        }
    }

    /*
     * @see StyledTextContent#replaceTextRange(int, int, String)
     */
    public void replaceTextRange(int pos, int length, String text) {
        try {
            fDocument.replace(pos, length, text);
        } catch (BadLocationException x) {
            DWT.error(DWT.ERROR_INVALID_ARGUMENT);
        }
    }

    /*
     * @see StyledTextContent#setText(String)
     */
    public void setText(String text) {
        fDocument.set(text);
    }

    /*
     * @see StyledTextContent#getCharCount()
     */
    public int getCharCount() {
        return getDocumentForRead().getLength();
    }

    /*
     * @see StyledTextContent#getLineDelimiter()
     */
    public String getLineDelimiter() {
        if (fLineDelimiter is null)
            fLineDelimiter= TextUtilities.getDefaultLineDelimiter(fDocument);
        return fLineDelimiter;
    }

    /*
     * @see IDocumentListener#documentChanged(DocumentEvent)
     */
    public void documentChanged(DocumentEvent event) {
        // check whether the given event is the one which was remembered
        if (fEvent is null || event !is fEvent)
            return;

        if (isPatchedEvent(event) || (event.getOffset() is 0 && event.getLength() is fRememberedLengthOfDocument)) {
            fLineDelimiter= null;
            fireTextSet();
        } else {
            if (event.getOffset() < fRememberedLengthOfFirstLine)
                fLineDelimiter= null;
            fireTextChanged();
        }
    }

    /*
     * @see IDocumentListener#documentAboutToBeChanged(DocumentEvent)
     */
    public void documentAboutToBeChanged(DocumentEvent event) {

        fRememberedLengthOfDocument= fDocument.getLength();
        try {
            fRememberedLengthOfFirstLine= fDocument.getLineLength(0);
        } catch (BadLocationException e) {
            fRememberedLengthOfFirstLine= -1;
        }

        fEvent= event;
        rememberEventData(fEvent);
        fireTextChanging();
    }

    /**
     * Checks whether this event has been changed between <code>documentAboutToBeChanged</code> and
     * <code>documentChanged</code>.
     *
     * @param event the event to be checked
     * @return <code>true</code> if the event has been changed, <code>false</code> otherwise
     */
    private bool isPatchedEvent(DocumentEvent event) {
        return fOriginalEvent.fOffset !is event.fOffset || fOriginalEvent.fLength !is event.fLength || fOriginalEvent.fText !is event.fText;
    }

    /**
     * Makes a copy of the given event and remembers it.
     *
     * @param event the event to be copied
     */
    private void rememberEventData(DocumentEvent event) {
        fOriginalEvent.fOffset= event.fOffset;
        fOriginalEvent.fLength= event.fLength;
        fOriginalEvent.fText= event.fText;
    }

    /**
     * Sends a text changed event to all registered listeners.
     */
    private void fireTextChanged() {

        if (!fIsForwarding)
            return;

        TextChangedEvent event= new TextChangedEvent(this);

        if (fTextChangeListeners !is null && fTextChangeListeners.size() > 0) {
            Iterator e= (new ArrayList(fTextChangeListeners)).iterator();
            while (e.hasNext())
                (cast(TextChangeListener) e.next()).textChanged(event);
        }
    }

    /**
     * Sends a text set event to all registered listeners.
     */
    private void fireTextSet() {

        if (!fIsForwarding)
            return;

        TextChangedEvent event = new TextChangedEvent(this);

        if (fTextChangeListeners !is null && fTextChangeListeners.size() > 0) {
            Iterator e= (new ArrayList(fTextChangeListeners)).iterator();
            while (e.hasNext())
                (cast(TextChangeListener) e.next()).textSet(event);
        }
    }

    /**
     * Sends the text changing event to all registered listeners.
     */
    private void fireTextChanging() {

        if (!fIsForwarding)
            return;

        try {
            IDocument document= fEvent.getDocument();
            if (document is null)
                return;

            TextChangingEvent event= new TextChangingEvent(this);
            event.start= fEvent.fOffset;
            event.replaceCharCount= fEvent.fLength;
            event.replaceLineCount= document.getNumberOfLines(fEvent.fOffset, fEvent.fLength) - 1;
            event.newText= fEvent.fText;
            event.newCharCount= (fEvent.fText is null ? 0 : fEvent.fText.length());
            event.newLineCount= (fEvent.fText is null ? 0 : document.computeNumberOfLines(fEvent.fText));

            if (fTextChangeListeners !is null && fTextChangeListeners.size() > 0) {
                Iterator e= (new ArrayList(fTextChangeListeners)).iterator();
                while (e.hasNext())
                     (cast(TextChangeListener) e.next()).textChanging(event);
            }

        } catch (BadLocationException e) {
        }
    }

    /*
     * @see IDocumentAdapterExtension#resumeForwardingDocumentChanges()
     * @since 2.0
     */
    public void resumeForwardingDocumentChanges() {
        fIsForwarding= true;
        fDocumentClone= null;
        fOriginalContent= null;
        fOriginalLineDelimiters= null;
        fireTextSet();
    }

    /*
     * @see IDocumentAdapterExtension#stopForwardingDocumentChanges()
     * @since 2.0
     */
    public void stopForwardingDocumentChanges() {
        fDocumentClone= null;
        fOriginalContent= fDocument.get();
        fOriginalLineDelimiters= fDocument.getLegalLineDelimiters();
        fIsForwarding= false;
    }

    /++
     + DWT extension
     +/
    public int utf8AdjustOffset( int offset ){
        if (fDocument is null)
            return offset;
        if (offset is 0)
            return offset;
        if( offset >= fDocument.getLength() ){
            return offset;
        }
        while( fDocument.getChar(offset) & 0xC0 is 0x80 && offset > 0 ){
            offset--;
        }
        return offset;
    }
}
