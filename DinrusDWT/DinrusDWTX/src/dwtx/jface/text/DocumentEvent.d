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


module dwtx.jface.text.DocumentEvent;

// import dwtx.jface.text.IDocumentPartitioningListener; // packageimport
// import dwtx.jface.text.DefaultTextHover; // packageimport
// import dwtx.jface.text.AbstractInformationControl; // packageimport
// import dwtx.jface.text.TextUtilities; // packageimport
// import dwtx.jface.text.IInformationControlCreatorExtension; // packageimport
// import dwtx.jface.text.AbstractInformationControlManager; // packageimport
// import dwtx.jface.text.ITextViewerExtension2; // packageimport
// import dwtx.jface.text.IDocumentPartitioner; // packageimport
// import dwtx.jface.text.DefaultIndentLineAutoEditStrategy; // packageimport
// import dwtx.jface.text.ITextSelection; // packageimport
// import dwtx.jface.text.Document; // packageimport
// import dwtx.jface.text.FindReplaceDocumentAdapterContentProposalProvider; // packageimport
// import dwtx.jface.text.ITextListener; // packageimport
// import dwtx.jface.text.BadPartitioningException; // packageimport
// import dwtx.jface.text.ITextViewerExtension5; // packageimport
// import dwtx.jface.text.IDocumentPartitionerExtension3; // packageimport
// import dwtx.jface.text.IUndoManager; // packageimport
// import dwtx.jface.text.ITextHoverExtension2; // packageimport
// import dwtx.jface.text.IRepairableDocument; // packageimport
// import dwtx.jface.text.IRewriteTarget; // packageimport
// import dwtx.jface.text.DefaultPositionUpdater; // packageimport
// import dwtx.jface.text.RewriteSessionEditProcessor; // packageimport
// import dwtx.jface.text.TextViewerHoverManager; // packageimport
// import dwtx.jface.text.DocumentRewriteSession; // packageimport
// import dwtx.jface.text.TextViewer; // packageimport
// import dwtx.jface.text.ITextViewerExtension8; // packageimport
// import dwtx.jface.text.RegExMessages; // packageimport
// import dwtx.jface.text.IDelayedInputChangeProvider; // packageimport
// import dwtx.jface.text.ITextOperationTargetExtension; // packageimport
// import dwtx.jface.text.IWidgetTokenOwner; // packageimport
// import dwtx.jface.text.IViewportListener; // packageimport
// import dwtx.jface.text.GapTextStore; // packageimport
// import dwtx.jface.text.MarkSelection; // packageimport
// import dwtx.jface.text.IDocumentPartitioningListenerExtension; // packageimport
// import dwtx.jface.text.IDocumentAdapterExtension; // packageimport
// import dwtx.jface.text.IInformationControlExtension; // packageimport
// import dwtx.jface.text.IDocumentPartitioningListenerExtension2; // packageimport
// import dwtx.jface.text.DefaultDocumentAdapter; // packageimport
// import dwtx.jface.text.ITextViewerExtension3; // packageimport
// import dwtx.jface.text.IInformationControlCreator; // packageimport
// import dwtx.jface.text.TypedRegion; // packageimport
// import dwtx.jface.text.ISynchronizable; // packageimport
// import dwtx.jface.text.IMarkRegionTarget; // packageimport
// import dwtx.jface.text.TextViewerUndoManager; // packageimport
// import dwtx.jface.text.IRegion; // packageimport
// import dwtx.jface.text.IInformationControlExtension2; // packageimport
import dwtx.jface.text.IDocumentExtension4; // packageimport
// import dwtx.jface.text.IDocumentExtension2; // packageimport
// import dwtx.jface.text.IDocumentPartitionerExtension2; // packageimport
// import dwtx.jface.text.Assert; // packageimport
// import dwtx.jface.text.DefaultInformationControl; // packageimport
// import dwtx.jface.text.IWidgetTokenOwnerExtension; // packageimport
// import dwtx.jface.text.DocumentClone; // packageimport
// import dwtx.jface.text.DefaultUndoManager; // packageimport
// import dwtx.jface.text.IFindReplaceTarget; // packageimport
// import dwtx.jface.text.IAutoEditStrategy; // packageimport
// import dwtx.jface.text.ILineTrackerExtension; // packageimport
// import dwtx.jface.text.IUndoManagerExtension; // packageimport
// import dwtx.jface.text.TextSelection; // packageimport
// import dwtx.jface.text.DefaultAutoIndentStrategy; // packageimport
// import dwtx.jface.text.IAutoIndentStrategy; // packageimport
// import dwtx.jface.text.IPainter; // packageimport
// import dwtx.jface.text.IInformationControl; // packageimport
// import dwtx.jface.text.IInformationControlExtension3; // packageimport
// import dwtx.jface.text.ITextViewerExtension6; // packageimport
// import dwtx.jface.text.IInformationControlExtension4; // packageimport
// import dwtx.jface.text.DefaultLineTracker; // packageimport
// import dwtx.jface.text.IDocumentInformationMappingExtension; // packageimport
// import dwtx.jface.text.IRepairableDocumentExtension; // packageimport
// import dwtx.jface.text.ITextHover; // packageimport
// import dwtx.jface.text.FindReplaceDocumentAdapter; // packageimport
// import dwtx.jface.text.ILineTracker; // packageimport
// import dwtx.jface.text.Line; // packageimport
// import dwtx.jface.text.ITextViewerExtension; // packageimport
// import dwtx.jface.text.IDocumentAdapter; // packageimport
// import dwtx.jface.text.TextEvent; // packageimport
// import dwtx.jface.text.BadLocationException; // packageimport
// import dwtx.jface.text.AbstractDocument; // packageimport
// import dwtx.jface.text.AbstractLineTracker; // packageimport
// import dwtx.jface.text.TreeLineTracker; // packageimport
// import dwtx.jface.text.ITextPresentationListener; // packageimport
// import dwtx.jface.text.Region; // packageimport
// import dwtx.jface.text.ITextViewer; // packageimport
// import dwtx.jface.text.IDocumentInformationMapping; // packageimport
// import dwtx.jface.text.MarginPainter; // packageimport
// import dwtx.jface.text.IPaintPositionManager; // packageimport
// import dwtx.jface.text.TextPresentation; // packageimport
// import dwtx.jface.text.IFindReplaceTargetExtension; // packageimport
// import dwtx.jface.text.ISlaveDocumentManagerExtension; // packageimport
// import dwtx.jface.text.ISelectionValidator; // packageimport
// import dwtx.jface.text.IDocumentExtension; // packageimport
// import dwtx.jface.text.PropagatingFontFieldEditor; // packageimport
// import dwtx.jface.text.ConfigurableLineTracker; // packageimport
// import dwtx.jface.text.SlaveDocumentEvent; // packageimport
// import dwtx.jface.text.IDocumentListener; // packageimport
// import dwtx.jface.text.PaintManager; // packageimport
// import dwtx.jface.text.IFindReplaceTargetExtension3; // packageimport
// import dwtx.jface.text.ITextDoubleClickStrategy; // packageimport
// import dwtx.jface.text.IDocumentExtension3; // packageimport
// import dwtx.jface.text.Position; // packageimport
// import dwtx.jface.text.TextMessages; // packageimport
// import dwtx.jface.text.CopyOnWriteTextStore; // packageimport
// import dwtx.jface.text.WhitespaceCharacterPainter; // packageimport
// import dwtx.jface.text.IPositionUpdater; // packageimport
// import dwtx.jface.text.DefaultTextDoubleClickStrategy; // packageimport
// import dwtx.jface.text.ListLineTracker; // packageimport
// import dwtx.jface.text.ITextInputListener; // packageimport
// import dwtx.jface.text.BadPositionCategoryException; // packageimport
// import dwtx.jface.text.IWidgetTokenKeeperExtension; // packageimport
// import dwtx.jface.text.IInputChangedListener; // packageimport
// import dwtx.jface.text.ITextOperationTarget; // packageimport
// import dwtx.jface.text.IDocumentInformationMappingExtension2; // packageimport
// import dwtx.jface.text.ITextViewerExtension7; // packageimport
// import dwtx.jface.text.IInformationControlExtension5; // packageimport
// import dwtx.jface.text.IDocumentRewriteSessionListener; // packageimport
// import dwtx.jface.text.JFaceTextUtil; // packageimport
// import dwtx.jface.text.AbstractReusableInformationControlCreator; // packageimport
// import dwtx.jface.text.TabsToSpacesConverter; // packageimport
// import dwtx.jface.text.CursorLinePainter; // packageimport
// import dwtx.jface.text.ITextHoverExtension; // packageimport
// import dwtx.jface.text.IEventConsumer; // packageimport
import dwtx.jface.text.IDocument; // packageimport
// import dwtx.jface.text.IWidgetTokenKeeper; // packageimport
// import dwtx.jface.text.DocumentCommand; // packageimport
// import dwtx.jface.text.TypedPosition; // packageimport
// import dwtx.jface.text.IEditingSupportRegistry; // packageimport
// import dwtx.jface.text.IDocumentPartitionerExtension; // packageimport
// import dwtx.jface.text.AbstractHoverInformationControlManager; // packageimport
// import dwtx.jface.text.IEditingSupport; // packageimport
// import dwtx.jface.text.IMarkSelection; // packageimport
// import dwtx.jface.text.ISlaveDocumentManager; // packageimport
// import dwtx.jface.text.DocumentPartitioningChangedEvent; // packageimport
// import dwtx.jface.text.ITextStore; // packageimport
// import dwtx.jface.text.JFaceTextMessages; // packageimport
// import dwtx.jface.text.DocumentRewriteSessionEvent; // packageimport
// import dwtx.jface.text.SequentialRewriteTextStore; // packageimport
// import dwtx.jface.text.DocumentRewriteSessionType; // packageimport
// import dwtx.jface.text.TextAttribute; // packageimport
// import dwtx.jface.text.ITextViewerExtension4; // packageimport
// import dwtx.jface.text.ITypedRegion; // packageimport

import dwt.dwthelper.utils;

import dwtx.core.runtime.Assert;


/**
 * Specification of changes applied to documents. All changes are represented as
 * replace commands, i.e. specifying a document range whose text gets replaced
 * with different text. In addition to this information, the event also contains
 * the changed document.
 *
 * @see dwtx.jface.text.IDocument
 */
public class DocumentEvent {

    /**
     * Debug option for asserting that text is not null.
     * If the <code>dwtx.text/debug/DocumentEvent/assertTextNotNull</code>
     * system property is <code>true</code>
     *
     * @since 3.3
     */
    private static bool ASSERT_TEXT_NOT_NULL_init = false;
    private static bool ASSERT_TEXT_NOT_NULL_;
    private static bool ASSERT_TEXT_NOT_NULL(){
        if( !ASSERT_TEXT_NOT_NULL_init ){
            ASSERT_TEXT_NOT_NULL_init = true;
            ASSERT_TEXT_NOT_NULL_= Boolean.getBoolean("dwtx.text/debug/DocumentEvent/assertTextNotNull"); //$NON-NLS-1$
        }
        return ASSERT_TEXT_NOT_NULL_;
    }

    /** The changed document */
    public IDocument fDocument;
    /** The document offset */
    public int fOffset;
    /** Length of the replaced document text */
    public int fLength;
    /** Text inserted into the document */
    public String fText= ""; //$NON-NLS-1$
    /**
     * The modification stamp of the document when firing this event.
     * @since 3.1 and public since 3.3
     */
    public long fModificationStamp;

    /**
     * Creates a new document event.
     *
     * @param doc the changed document
     * @param offset the offset of the replaced text
     * @param length the length of the replaced text
     * @param text the substitution text
     */
    public this(IDocument doc, int offset, int length, String text) {

        Assert.isNotNull(cast(Object)doc);
        Assert.isTrue(offset >= 0);
        Assert.isTrue(length >= 0);

        if (ASSERT_TEXT_NOT_NULL)
            Assert.isNotNull(text);

        fDocument= doc;
        fOffset= offset;
        fLength= length;
        fText= text;

        if ( cast(IDocumentExtension4)fDocument )
            fModificationStamp= (cast(IDocumentExtension4)fDocument).getModificationStamp();
        else
            fModificationStamp= IDocumentExtension4.UNKNOWN_MODIFICATION_STAMP;
    }

    /**
     * Creates a new, not initialized document event.
     */
    public this() {
    }

    /**
     * Returns the changed document.
     *
     * @return the changed document
     */
    public IDocument getDocument() {
        return fDocument;
    }

    /**
     * Returns the offset of the change.
     *
     * @return the offset of the change
     */
    public int getOffset() {
        return fOffset;
    }

    /**
     * Returns the length of the replaced text.
     *
     * @return the length of the replaced text
     */
    public int getLength() {
        return fLength;
    }

    /**
     * Returns the text that has been inserted.
     *
     * @return the text that has been inserted
     */
    public String getText() {
        return fText;
    }

    /**
     * Returns the document's modification stamp at the
     * time when this event was sent.
     *
     * @return the modification stamp or {@link IDocumentExtension4#UNKNOWN_MODIFICATION_STAMP}.
     * @see IDocumentExtension4#getModificationStamp()
     * @since 3.1
     */
    public long getModificationStamp() {
        return fModificationStamp;
    }

    /*
     * @see java.lang.Object#toString()
     * @since 3.4
     */
    public override String toString() {
        StringBuffer buffer= new StringBuffer();
        buffer.append("offset: " ); //$NON-NLS-1$
        buffer.append(fOffset);
        buffer.append(", length: " ); //$NON-NLS-1$
        buffer.append(fLength);
        buffer.append(", timestamp: " ); //$NON-NLS-1$
        buffer.append(fModificationStamp);
        buffer.append("\ntext:>" ); //$NON-NLS-1$
        buffer.append(fText);
        buffer.append("<\n" ); //$NON-NLS-1$
        return buffer.toString();
    }
}
