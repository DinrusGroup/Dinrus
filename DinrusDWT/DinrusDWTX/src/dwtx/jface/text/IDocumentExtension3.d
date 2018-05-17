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
module dwtx.jface.text.IDocumentExtension3;

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
import dwtx.jface.text.PaintManager; // packageimport
import dwtx.jface.text.IFindReplaceTargetExtension3; // packageimport
import dwtx.jface.text.ITextDoubleClickStrategy; // packageimport
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
 * Extension interface for {@link dwtx.jface.text.IDocument}.
 * <p>
 * Adds the concept of multiple partitionings and the concept of zero-length
 * partitions in conjunction with open and delimited partitions. A delimited
 * partition has a well defined start delimiter and a well defined end
 * delimiter. Between two delimited partitions there may be an open partition of
 * length zero.
 * <p>
 *
 * In order to fulfill the contract of this interface, the document must be
 * configured with a document partitioner implementing
 * {@link dwtx.jface.text.IDocumentPartitionerExtension2}.
 *
 * @see dwtx.jface.text.IDocumentPartitionerExtension2
 * @since 3.0
 */
public interface IDocumentExtension3 {

    /**
     * The identifier of the default partitioning.
     */
    final static String DEFAULT_PARTITIONING= "__dftl_partitioning"; //$NON-NLS-1$


    /**
     * Returns the existing partitionings for this document. This includes
     * the default partitioning.
     *
     * @return the existing partitionings for this document
     */
    String[] getPartitionings();

    /**
     * Returns the set of legal content types of document partitions for the given partitioning
     * This set can be empty. The set can contain more content types than  contained by the
     * result of <code>getPartitioning(partitioning, 0, getLength())</code>.
     *
     * @param partitioning the partitioning for which to return the legal content types
     * @return the set of legal content types
     * @exception BadPartitioningException if partitioning is invalid for this document
     */
    String[] getLegalContentTypes(String partitioning) ;


    /**
     * Returns the type of the document partition containing the given offset
     * for the given partitioning. This is a convenience method for
     * <code>getPartition(partitioning, offset, bool).getType()</code>.
     * <p>
     * If <code>preferOpenPartitions</code> is <code>true</code>,
     * precedence is given to an open partition ending at <code>offset</code>
     * over a delimited partition starting at <code>offset</code>. If it is
     * <code>false</code>, precedence is given to the partition that does not
     * end at <code>offset</code>.
     * </p>
     * This is only supported if the connected <code>IDocumentPartitioner</code>
     * supports it, i.e. implements <code>IDocumentPartitionerExtension2</code>.
     * Otherwise, <code>preferOpenPartitions</code> is ignored.
     * </p>
     *
     * @param partitioning the partitioning
     * @param offset the document offset
     * @param preferOpenPartitions <code>true</code> if precedence should be
     *        given to a open partition ending at <code>offset</code> over a
     *        closed partition starting at <code>offset</code>
     * @return the partition type
     * @exception BadLocationException if offset is invalid in this document
     * @exception BadPartitioningException if partitioning is invalid for this document
     */
    String getContentType(String partitioning, int offset, bool preferOpenPartitions);

    /**
     * Returns the document partition of the given partitioning in which the
     * given offset is located.
     * <p>
     * If <code>preferOpenPartitions</code> is <code>true</code>,
     * precedence is given to an open partition ending at <code>offset</code>
     * over a delimited partition starting at <code>offset</code>. If it is
     * <code>false</code>, precedence is given to the partition that does not
     * end at <code>offset</code>.
     * </p>
     * This is only supported if the connected <code>IDocumentPartitioner</code>
     * supports it, i.e. implements <code>IDocumentPartitionerExtension2</code>.
     * Otherwise, <code>preferOpenPartitions</code> is ignored.
     * </p>
     *
     * @param partitioning the partitioning
     * @param offset the document offset
     * @param preferOpenPartitions <code>true</code> if precedence should be
     *        given to a open partition ending at <code>offset</code> over a
     *        closed partition starting at <code>offset</code>
     * @return a specification of the partition
     * @exception BadLocationException if offset is invalid in this document
     * @exception BadPartitioningException if partitioning is invalid for this document
     */
    ITypedRegion getPartition(String partitioning, int offset, bool preferOpenPartitions);

    /**
     * Computes the partitioning of the given document range based on the given
     * partitioning type.
     * <p>
     * If <code>includeZeroLengthPartitions</code> is <code>true</code>, a
     * zero-length partition of an open partition type (usually the default
     * partition) is included between two closed partitions. If it is
     * <code>false</code>, no zero-length partitions are included.
     * </p>
     * This is only supported if the connected <code>IDocumentPartitioner</code>
     * supports it, i.e. implements <code>IDocumentPartitionerExtension2</code>.
     * Otherwise, <code>includeZeroLengthPartitions</code> is ignored.
     * </p>
     *
     * @param partitioning the document's partitioning type
     * @param offset the document offset at which the range starts
     * @param length the length of the document range
     * @param includeZeroLengthPartitions <code>true</code> if zero-length
     *        partitions should be returned as part of the computed partitioning
     * @return a specification of the range's partitioning
     * @exception BadLocationException if the range is invalid in this document$
     * @exception BadPartitioningException if partitioning is invalid for this document
     */
    ITypedRegion[] computePartitioning(String partitioning, int offset, int length, bool includeZeroLengthPartitions);

    /**
     * Sets this document's partitioner. The caller of this method is responsible for
     * disconnecting the document's old partitioner from the document and to
     * connect the new partitioner to the document. Informs all document partitioning
     * listeners about this change.
     *
     * @param  partitioning the partitioning for which to set the partitioner
     * @param partitioner the document's new partitioner
     * @see IDocumentPartitioningListener
     */
    void setDocumentPartitioner(String partitioning, IDocumentPartitioner partitioner);

    /**
     * Returns the partitioner for the given partitioning or <code>null</code> if
     * no partitioner is registered.
     *
     * @param  partitioning the partitioning for which to set the partitioner
     * @return the partitioner for the given partitioning
     */
    IDocumentPartitioner getDocumentPartitioner(String partitioning);
}
