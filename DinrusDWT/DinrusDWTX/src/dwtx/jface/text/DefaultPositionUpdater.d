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
module dwtx.jface.text.DefaultPositionUpdater;

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
 * Default implementation of {@link dwtx.jface.text.IPositionUpdater}.
 * <p>
 * A default position updater must be configured with the position category whose positions it will
 * update. Other position categories are not affected by this updater.
 * </p>
 * <p>
 * This implementation follows the specification below:
 * </p>
 * <ul>
 * <li>Inserting or deleting text before the position shifts the position accordingly.</li>
 * <li>Inserting text at the position offset shifts the position accordingly.</li>
 * <li>Inserting or deleting text strictly contained by the position shrinks or stretches the
 * position.</li>
 * <li>Inserting or deleting text after a position does not affect the position.</li>
 * <li>Deleting text which strictly contains the position deletes the position. Note that the
 * position is not deleted if its only shrunken to length zero. To delete a position, the
 * modification must delete from <i>strictly before</i> to <i>strictly after</i> the position.</li>
 * <li>Replacing text overlapping with the position is considered as a sequence of first deleting
 * the replaced text and afterwards inserting the new text. Thus, a position might first be shifted
 * and shrunken and then be stretched.</li>
 * </ul>
 * This class can be used as is or be adapted by subclasses. Fields are protected to allow
 * subclasses direct access. Because of the frequency with which position updaters are used this is
 * a performance decision.
 */
public class DefaultPositionUpdater : IPositionUpdater {

    /** The position category the updater draws responsible for */
    private String fCategory;

    /** Caches the currently investigated position */
    protected Position fPosition;
    /**
     * Remembers the original state of the investigated position
     * @since 2.1
     */
    protected Position fOriginalPosition;
    /** Caches the offset of the replaced text */
    protected int fOffset;
    /** Caches the length of the replaced text */
    protected int fLength;
    /** Caches the length of the newly inserted text */
    protected int fReplaceLength;
    /** Catches the document */
    protected IDocument fDocument;


    /**
     * Creates a new default position updater for the given category.
     *
     * @param category the category the updater is responsible for
     */
    public this(String category) {
        fOriginalPosition= new Position(0, 0);
        fCategory= category;
    }

    /**
     * Returns the category this updater is responsible for.
     *
     * @return the category this updater is responsible for
     */
    protected String getCategory() {
        return fCategory;
    }

    /**
     * Returns whether the current event describes a well formed replace
     * by which the current position is directly affected.
     *
     * @return <code>true</code> the current position is directly affected
     * @since 3.0
     */
    protected bool isAffectingReplace() {
        return fLength > 0 && fReplaceLength > 0 && fPosition.length < fOriginalPosition.length;
    }

    /**
     * Adapts the currently investigated position to an insertion.
     */
    protected void adaptToInsert() {

        int myStart= fPosition.offset;
        int myEnd=   fPosition.offset + fPosition.length - 1;
        myEnd= Math.max(myStart, myEnd);

        int yoursStart= fOffset;
        int yoursEnd=   fOffset + fReplaceLength -1;
        yoursEnd= Math.max(yoursStart, yoursEnd);

        if (myEnd < yoursStart)
            return;

        if (fLength <= 0) {

            if (myStart < yoursStart)
                fPosition.length += fReplaceLength;
            else
                fPosition.offset += fReplaceLength;

        } else {

            if (myStart <= yoursStart && fOriginalPosition.offset <= yoursStart)
                fPosition.length += fReplaceLength;
            else
                fPosition.offset += fReplaceLength;
        }
    }

    /**
     * Adapts the currently investigated position to a deletion.
     */
    protected void adaptToRemove() {

        int myStart= fPosition.offset;
        int myEnd=   fPosition.offset + fPosition.length -1;
        myEnd= Math.max(myStart, myEnd);

        int yoursStart= fOffset;
        int yoursEnd=   fOffset + fLength -1;
        yoursEnd= Math.max(yoursStart, yoursEnd);

        if (myEnd < yoursStart)
            return;

        if (myStart <= yoursStart) {

            if (yoursEnd <= myEnd)
                fPosition.length -= fLength;
            else
                fPosition.length -= (myEnd - yoursStart +1);

        } else if (yoursStart < myStart) {

            if (yoursEnd < myStart)
                fPosition.offset -= fLength;
            else {
                fPosition.offset -= (myStart - yoursStart);
                fPosition.length -= (yoursEnd - myStart +1);
            }

        }

        // validate position to allowed values
        if (fPosition.offset < 0)
            fPosition.offset= 0;

        if (fPosition.length < 0)
            fPosition.length= 0;
    }

    /**
     * Adapts the currently investigated position to the replace operation.
     * First it checks whether the change replaces the whole range of the position.
     * If not, it performs first the deletion of the previous text and afterwards
     * the insertion of the new text.
     */
    protected void adaptToReplace() {

        if (fPosition.offset is fOffset && fPosition.length is fLength && fPosition.length > 0) {

            // replace the whole range of the position
            fPosition.length += (fReplaceLength - fLength);
            if (fPosition.length < 0) {
                fPosition.offset += fPosition.length;
                fPosition.length= 0;
            }

        } else {

            if (fLength >  0)
                adaptToRemove();

            if (fReplaceLength > 0)
                adaptToInsert();
        }
    }

    /**
     * Determines whether the currently investigated position has been deleted by
     * the replace operation specified in the current event. If so, it deletes
     * the position and removes it from the document's position category.
     *
     * @return <code>true</code> if position has not been deleted
     */
    protected bool notDeleted() {

        if (fOffset < fPosition.offset && (fPosition.offset + fPosition.length < fOffset + fLength)) {

            fPosition.delete_();

            try {
                fDocument.removePosition(fCategory, fPosition);
            } catch (BadPositionCategoryException x) {
            }

            return false;
        }

        return true;
    }

    /*
     * @see dwtx.jface.text.IPositionUpdater#update(dwtx.jface.text.DocumentEvent)
     */
    public void update(DocumentEvent event) {

        try {


            fOffset= event.getOffset();
            fLength= event.getLength();
            fReplaceLength= (event.getText() is null ? 0 : event.getText().length());
            fDocument= event.getDocument();

            Position[] category= fDocument.getPositions(fCategory);
            for (int i= 0; i < category.length; i++) {

                fPosition= category[i];
                fOriginalPosition.offset= fPosition.offset;
                fOriginalPosition.length= fPosition.length;

                if (notDeleted())
                    adaptToReplace();
            }

        } catch (BadPositionCategoryException x) {
            // do nothing
        } finally {
            fDocument= null;
        }
    }
}
