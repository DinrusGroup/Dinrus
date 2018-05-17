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


module dwtx.jface.text.DefaultTextDoubleClickStrategy;

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
import dwtx.jface.text.IDocumentExtension3; // packageimport
import dwtx.jface.text.Position; // packageimport
import dwtx.jface.text.TextMessages; // packageimport
import dwtx.jface.text.CopyOnWriteTextStore; // packageimport
import dwtx.jface.text.WhitespaceCharacterPainter; // packageimport
import dwtx.jface.text.IPositionUpdater; // packageimport
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

import dwtx.dwtxhelper.CharacterIterator;

import dwtx.dwtxhelper.mangoicu.UBreakIterator;

/**
 * Standard implementation of
 * {@link dwtx.jface.text.ITextDoubleClickStrategy}.
 * <p>
 * Selects words using <code>java.text.UBreakIterator</code> for the default
 * locale.</p>
 * <p>
 * This class is not intended to be subclassed.
 * </p>
 *
 * @see java.text.UBreakIterator
 * @noextend This class is not intended to be subclassed by clients.
 */
public class DefaultTextDoubleClickStrategy : ITextDoubleClickStrategy {

/++
    /**
     * Implements a character iterator that works directly on
     * instances of <code>IDocument</code>. Used to collaborate with
     * the break iterator.
     *
     * @see IDocument
     * @since 2.0
     */
    static class DocumentCharacterIterator : CharacterIterator {

        /** Document to iterate over. */
        private IDocument fDocument;
        /** Start offset of iteration. */
        private int fOffset= -1;
        /** End offset of iteration. */
        private int fEndOffset= -1;
        /** Current offset of iteration. */
        private int fIndex= -1;

        /** Creates a new document iterator. */
        public this() {
        }

        /**
         * Configures this document iterator with the document section to be visited.
         *
         * @param document the document to be iterated
         * @param iteratorRange the range in the document to be iterated
         */
        public void setDocument(IDocument document, IRegion iteratorRange) {
            fDocument= document;
            fOffset= iteratorRange.getOffset();
            fEndOffset= fOffset + iteratorRange.getLength();
        }

        /*
         * @see CharacterIterator#first()
         */
        public char first() {
            fIndex= fOffset;
            return current();
        }

        /*
         * @see CharacterIterator#last()
         */
        public char last() {
            fIndex= fOffset < fEndOffset ? fEndOffset -1 : fEndOffset;
            return current();
        }

        /*
         * @see CharacterIterator#current()
         */
        public char current() {
            if (fOffset <= fIndex && fIndex < fEndOffset) {
                try {
                    return fDocument.getChar(fIndex);
                } catch (BadLocationException x) {
                }
            }
            return DONE;
        }

        /*
         * @see CharacterIterator#next()
         */
        public char next() {
            ++fIndex;
            int end= getEndIndex();
            if (fIndex >= end) {
                fIndex= end;
                return DONE;
            }
            return current();
        }

        /*
         * @see CharacterIterator#previous()
         */
        public char previous() {
            if (fIndex is fOffset)
                return DONE;

            if (fIndex > fOffset)
                -- fIndex;

            return current();
        }

        /*
         * @see CharacterIterator#setIndex(int)
         */
        public char setIndex(int index) {
            fIndex= index;
            return current();
        }

        /*
         * @see CharacterIterator#getBeginIndex()
         */
        public int getBeginIndex() {
            return fOffset;
        }

        /*
         * @see CharacterIterator#getEndIndex()
         */
        public int getEndIndex() {
            return fEndOffset;
        }

        /*
         * @see CharacterIterator#getIndex()
         */
        public int getIndex() {
            return fIndex;
        }

        /*
         * @see CharacterIterator#clone()
         */
        public Object clone() {
            DocumentCharacterIterator i= new DocumentCharacterIterator();
            i.fDocument= fDocument;
            i.fIndex= fIndex;
            i.fOffset= fOffset;
            i.fEndOffset= fEndOffset;
            return i;
        }
    }
++/

    /**
     * The document character iterator used by this strategy.
     * @since 2.0
     */
//     private DocumentCharacterIterator fDocIter= new DocumentCharacterIterator();


    /**
     * Creates a new default text double click strategy.
     */
    public this() {
//         super();
    }

    /*
     * @see dwtx.jface.text.ITextDoubleClickStrategy#doubleClicked(dwtx.jface.text.ITextViewer)
     */
    public void doubleClicked(ITextViewer text) {

        int position= text.getSelectedRange().x;

        if (position < 0)
            return;

        try {

            IDocument document= text.getDocument();
            IRegion line= document.getLineInformationOfOffset(position);
            if (position is line.getOffset() + line.getLength())
                return;

            //mangoicu
//             fDocIter.setDocument(document, line);
            String strLine = document.get( line.getOffset(), line.getLength() );
            UBreakIterator breakIter= UBreakIterator.openWordIterator( ULocale.Default, strLine/+fDocIter+/ );


            //int start= breakIter.preceding(position);
            int start= breakIter.previous(position); // mangoicu
            if (start is UBreakIterator.DONE)
                start= line.getOffset();

            int end= breakIter.following(position);
            if (end is UBreakIterator.DONE)
                end= line.getOffset() + line.getLength();

            if (breakIter.isBoundary(position)) {
                if (end - position > position- start)
                    start= position;
                else
                    end= position;
            }

            if (start !is end)
                text.setSelectedRange(start, end - start);

        } catch (BadLocationException x) {
        }
    }
}
