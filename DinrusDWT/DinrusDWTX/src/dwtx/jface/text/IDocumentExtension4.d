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
module dwtx.jface.text.IDocumentExtension4;

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

/**
 * Extension interface for {@link dwtx.jface.text.IDocument}. It adds the
 * following concepts:
 * <ul>
 *   <li>Rewrite sessions. A rewrite session is a sequence of replace operations
 *       that form a semantic unit.</li>
 *   <li>A modification stamp on the document</li>
 *   <li>The ability to set the initial line delimiter and to query the default
 *       line delimiter</li>
 * </ul>
 *
 * @since 3.1
 */
public interface IDocumentExtension4 {

    /**
     * Tells the document that it is about to be rewritten. That is, a sequence
     * of replace operations that form a semantic unit will be performed on this
     * document. A specification of the nature of the operation sequence is
     * given in form of the session type.
     * <p>
     * The document is considered being in rewrite mode as long as
     * <code>stopRewriteSession</code> has not been called.
     *
     * @param sessionType the session type
     * @return the started rewrite session
     * @throws IllegalStateException in case there is already an active rewrite session
     */
    DocumentRewriteSession startRewriteSession(DocumentRewriteSessionType sessionType) ;

    /**
     * Tells the document to stop the rewrite session. This method has only any
     * effect if <code>startRewriteSession</code> has been called before.
     * <p>
     * This method does not have any effect if the given session is not the
     * active rewrite session.
     *
     * @param session the session to stop
     */
    void stopRewriteSession(DocumentRewriteSession session);

    /**
     * Returns the active rewrite session of this document or <code>null</code>.
     *
     * @return the active rewrite session or <code>null</code>
     */
    DocumentRewriteSession getActiveRewriteSession();

    /**
     * Registers the document rewrite session listener with the document. After
     * registration the <code>IDocumentRewriteSessionListener</code> is
     * informed about each state change of rewrite sessions performed on this
     * document.
     * <p>
     * If the listener is already registered nothing happens.
     * <p>
     * An <code>IRewriteSessionDocumentListener</code> may call back to this
     * document when being inside a document notification.
     *
     * @param listener the listener to be registered
     */
    void addDocumentRewriteSessionListener(IDocumentRewriteSessionListener listener);

    /**
     * Removes the listener from the document's list of document rewrite session
     * listeners. If the listener is not registered with the document nothing
     * happens.
     * <p>
     * An <code>IDocumentRewriteSessionListener</code> may call back to this
     * document when being inside a document notification.
     *
     * @param listener the listener to be removed
     */
    void removeDocumentRewriteSessionListener(IDocumentRewriteSessionListener listener);

    /**
     * Substitutes the given text for the specified document range.
     * Sends a <code>DocumentEvent</code> to all registered <code>IDocumentListener</code>.
     *
     * @param offset the document offset
     * @param length the length of the specified range
     * @param text the substitution text
     * @param modificationStamp of the document after replacing
     * @exception BadLocationException if the offset is invalid in this document
     *
     * @see DocumentEvent
     * @see IDocumentListener
     */
    void replace(int offset, int length, String text, long modificationStamp) ;

    /**
     * Replaces the content of the document with the given text.
     * Sends a <code>DocumentEvent</code> to all registered <code>IDocumentListener</code>.
     * This method is a convenience method for <code>replace(0, getLength(), text)</code>.
     *
     * @param text the new content of the document
     * @param modificationStamp of the document after setting the content
     *
     * @see DocumentEvent
     * @see IDocumentListener
     */
    void set(String text, long modificationStamp);

    /**
     * The unknown modification stamp.
     */
    static const long UNKNOWN_MODIFICATION_STAMP= -1;

    /**
     * Returns the modification stamp of this document. The modification stamp
     * is updated each time a modifying operation is called on this document. If
     * two modification stamps of the same document are identical then the document
     * content is too, however, same content does not imply same modification stamp.
     * <p>
     * The magnitude or sign of the numerical difference between two modification stamps
     * is not significant.
     * </p>
     *
     * @return the modification stamp of this document or <code>UNKNOWN_MODIFICATION_STAMP</code>
     */
    long getModificationStamp();

    /**
     * Returns this document's default line delimiter.
     * <p>
     * This default line delimiter should be used by clients who
     * want unique delimiters (e.g. 'CR's) in the document.</p>
     *
     * @return the default line delimiter or <code>null</code> if none
     */
    String getDefaultLineDelimiter();

    /**
     * Sets this document's initial line delimiter i.e. the one
     * which is returned by <code>getDefaultLineDelimiter</code>
     * if the document does not yet contain any line delimiter.
     *
     * @param lineDelimiter the default line delimiter
     */
    void setInitialLineDelimiter(String lineDelimiter);
}
