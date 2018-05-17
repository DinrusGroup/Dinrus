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
module dwtx.jface.text.IDocumentPartitioner;

// import dwtx.jface.text.IDocumentPartitioningListener; // packageimport
// import dwtx.jface.text.DefaultTextHover; // packageimport
// import dwtx.jface.text.AbstractInformationControl; // packageimport
// import dwtx.jface.text.TextUtilities; // packageimport
// import dwtx.jface.text.IInformationControlCreatorExtension; // packageimport
// import dwtx.jface.text.AbstractInformationControlManager; // packageimport
// import dwtx.jface.text.ITextViewerExtension2; // packageimport
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
// import dwtx.jface.text.IDocumentExtension4; // packageimport
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
import dwtx.jface.text.DocumentEvent; // packageimport
// import dwtx.jface.text.DocumentPartitioningChangedEvent; // packageimport
// import dwtx.jface.text.ITextStore; // packageimport
// import dwtx.jface.text.JFaceTextMessages; // packageimport
// import dwtx.jface.text.DocumentRewriteSessionEvent; // packageimport
// import dwtx.jface.text.SequentialRewriteTextStore; // packageimport
// import dwtx.jface.text.DocumentRewriteSessionType; // packageimport
// import dwtx.jface.text.TextAttribute; // packageimport
// import dwtx.jface.text.ITextViewerExtension4; // packageimport
import dwtx.jface.text.ITypedRegion; // packageimport


import dwt.dwthelper.utils;



/**
 * A document partitioner divides a document into a set
 * of disjoint text partitions. Each partition has a content type, an
 * offset, and a length. The document partitioner is connected to one document
 * and informed about all changes of this document before any of the
 * document's document listeners. A document partitioner can thus
 * incrementally update on the receipt of a document change event.<p>
 *
 * In order to provided backward compatibility for clients of <code>IDocumentPartitioner</code>, extension
 * interfaces are used to provide a means of evolution. The following extension interfaces
 * exist:
 * <ul>
 * <li> {@link dwtx.jface.text.IDocumentPartitionerExtension} since version 2.0 replacing
 *      the <code>documentChanged</code> method with a new one returning the minimal document region
 *      comprising all partition changes.</li>
 * <li> {@link dwtx.jface.text.IDocumentPartitionerExtension2} since version 3.0
 *      introducing zero-length partitions in conjunction with the distinction between
 *      open and closed partitions. Also provides inside in the implementation of the partitioner
 *      by exposing the position category used for managing the partitioning information.</li>
 * <li> {@link dwtx.jface.text.IDocumentPartitionerExtension3} since version 3.1 introducing
 *      rewrite session. It also replaces the existing {@link #connect(IDocument)} method with
 *      a new one: {@link dwtx.jface.text.IDocumentPartitionerExtension3#connect(IDocument, bool)}.
 * </ul>
 * <p>
 * Clients may implement this interface and its extension interfaces or use the standard
 * implementation <code>DefaultPartitioner</code>.
 * </p>
 *
 * @see dwtx.jface.text.IDocumentPartitionerExtension
 * @see dwtx.jface.text.IDocumentPartitionerExtension2
 * @see dwtx.jface.text.IDocument
 */
public interface IDocumentPartitioner {

    /**
     * Connects the partitioner to a document.
     * Connect indicates the begin of the usage of the receiver
     * as partitioner of the given document. Thus, resources the partitioner
     * needs to be operational for this document should be allocated.<p>
     *
     * The caller of this method must ensure that this partitioner is
     * also set as the document's document partitioner.<p>
     *
     * This method has been replaced with {@link IDocumentPartitionerExtension3#connect(IDocument, bool)}.
     * Implementers should default a call <code>connect(document)</code> to
     * <code>connect(document, false)</code> in order to sustain the same semantics.
     *
     * @param document the document to be connected to
     */
    void connect(IDocument document);

    /**
     * Disconnects the partitioner from the document it is connected to.
     * Disconnect indicates the end of the usage of the receiver as
     * partitioner of the connected document. Thus, resources the partitioner
     * needed to be operation for its connected document should be deallocated.<p>
     * The caller of this method should also must ensure that this partitioner is
     * no longer the document's partitioner.
     */
    void disconnect();

    /**
     * Informs about a forthcoming document change. Will be called by the
     * connected document and is not intended to be used by clients
     * other than the connected document.
     *
     * @param event the event describing the forthcoming change
     */
    void documentAboutToBeChanged(DocumentEvent event);

    /**
     * The document has been changed. The partitioner updates
     * the document's partitioning and returns whether the structure of the
     * document partitioning has been changed, i.e. whether partitions
     * have been added or removed. Will be called by the connected document and
     * is not intended to be used by clients other than the connected document.<p>
     *
     * This method has been replaced by {@link IDocumentPartitionerExtension#documentChanged2(DocumentEvent)}.
     *
     * @param event the event describing the document change
     * @return <code>true</code> if partitioning changed
     */
    bool documentChanged(DocumentEvent event);

    /**
     * Returns the set of all legal content types of this partitioner.
     * I.e. any result delivered by this partitioner may not contain a content type
     * which would not be included in this method's result.
     *
     * @return the set of legal content types
     */
    String[] getLegalContentTypes();

    /**
     * Returns the content type of the partition containing the
     * given offset in the connected document. There must be a
     * document connected to this partitioner.<p>
     *
     * Use {@link IDocumentPartitionerExtension2#getContentType(int, bool)} when
     * zero-length partitions are supported. In that case this method is
     * equivalent:
     * <pre>
     *    IDocumentPartitionerExtension2 extension= cast(IDocumentPartitionerExtension2) partitioner;
     *    return extension.getContentType(offset, false);
     * </pre>
     *
     * @param offset the offset in the connected document
     * @return the content type of the offset's partition
     */
    String getContentType(int offset);

    /**
     * Returns the partitioning of the given range of the connected
     * document. There must be a document connected to this partitioner.<p>
     *
     * Use {@link IDocumentPartitionerExtension2#computePartitioning(int, int, bool)} when
     * zero-length partitions are supported. In that case this method is
     * equivalent:
     * <pre>
     *    IDocumentPartitionerExtension2 extension= cast(IDocumentPartitionerExtension2) partitioner;
     *    return extension.computePartitioning(offset, length, false);
     * </pre>
     *
     * @param offset the offset of the range of interest
     * @param length the length of the range of interest
     * @return the partitioning of the range
     */
    ITypedRegion[] computePartitioning(int offset, int length);

    /**
     * Returns the partition containing the given offset of
     * the connected document. There must be a document connected to this
     * partitioner.<p>
     *
     * Use {@link IDocumentPartitionerExtension2#getPartition(int, bool)} when
     * zero-length partitions are supported. In that case this method is
     * equivalent:
     * <pre>
     *    IDocumentPartitionerExtension2 extension= cast(IDocumentPartitionerExtension2) partitioner;
     *    return extension.getPartition(offset, false);
     * </pre>
     *
     * @param offset the offset for which to determine the partition
     * @return the partition containing the offset
     */
    ITypedRegion getPartition(int offset);
}
