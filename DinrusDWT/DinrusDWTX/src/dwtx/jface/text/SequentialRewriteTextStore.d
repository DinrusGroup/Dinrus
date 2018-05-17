/*******************************************************************************
 * Copyright (c) 2000, 2006 IBM Corporation and others.
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
module dwtx.jface.text.SequentialRewriteTextStore;

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
import dwtx.jface.text.DocumentRewriteSessionType; // packageimport
import dwtx.jface.text.TextAttribute; // packageimport
import dwtx.jface.text.ITextViewerExtension4; // packageimport
import dwtx.jface.text.ITypedRegion; // packageimport


import dwt.dwthelper.utils;


import dwtx.dwtxhelper.Collection;



/**
 * A text store that optimizes a given source text store for sequential rewriting.
 * While rewritten it keeps a list of replace command that serve as patches for
 * the source store. Only on request, the source store is indeed manipulated
 * by applying the patch commands to the source text store.
 *
 * @since 2.0
 * @deprecated since 3.3 as {@link GapTextStore} performs better even for sequential rewrite scenarios
 */
public class SequentialRewriteTextStore : ITextStore {

    /**
     * A buffered replace command.
     */
    private static class Replace {
        public int newOffset;
        public const int offset;
        public const int length;
        public const String text;

        public this(int offset, int newOffset, int length, String text) {
            this.newOffset= newOffset;
            this.offset= offset;
            this.length= length;
            this.text= text;
        }
    }

    /** The list of buffered replacements. */
    private LinkedList fReplaceList;
    /** The source text store */
    private ITextStore fSource;
    /** A flag to enforce sequential access. */
    private static const bool ASSERT_SEQUENTIALITY= false;


    /**
     * Creates a new sequential rewrite store for the given source store.
     *
     * @param source the source text store
     */
    public this(ITextStore source) {
        fReplaceList= new LinkedList();
        fSource= source;
    }

    /**
     * Returns the source store of this rewrite store.
     *
     * @return  the source store of this rewrite store
     */
    public ITextStore getSourceStore() {
        commit();
        return fSource;
    }

    /*
     * @see dwtx.jface.text.ITextStore#replace(int, int, java.lang.String)
     */
    public void replace(int offset, int length, String text) {
        if (text is null)
            text= ""; //$NON-NLS-1$

        if (fReplaceList.size() is 0) {
            fReplaceList.add(new Replace(offset, offset, length, text));

        } else {
            Replace firstReplace= cast(Replace) fReplaceList.getFirst();
            Replace lastReplace= cast(Replace) fReplaceList.getLast();

            // backward
            if (offset + length <= firstReplace.newOffset) {
                int delta= text.length - length;
                if (delta !is 0) {
                    for (Iterator i= fReplaceList.iterator(); i.hasNext(); ) {
                        Replace replace= cast(Replace) i.next();
                        replace.newOffset += delta;
                    }
                }

                fReplaceList.addFirst(new Replace(offset, offset, length, text));

            // forward
            } else if (offset >= lastReplace.newOffset + lastReplace.text.length) {
                int delta= getDelta(lastReplace);
                fReplaceList.add(new Replace(offset - delta, offset, length, text));

            } else if (ASSERT_SEQUENTIALITY) {
                throw new IllegalArgumentException(null);

            } else {
                commit();
                fSource.replace(offset, length, text);
            }
        }
    }

    /*
     * @see dwtx.jface.text.ITextStore#set(java.lang.String)
     */
    public void set(String text) {
        fSource.set(text);
        fReplaceList.clear();
    }

    /*
     * @see dwtx.jface.text.ITextStore#get(int, int)
     */
    public String get(int offset, int length) {

        if (fReplaceList.isEmpty())
            return fSource.get(offset, length);


        Replace firstReplace= cast(Replace) fReplaceList.getFirst();
        Replace lastReplace= cast(Replace) fReplaceList.getLast();

        // before
        if (offset + length <= firstReplace.newOffset) {
            return fSource.get(offset, length);

            // after
        } else if (offset >= lastReplace.newOffset + lastReplace.text.length) {
            int delta= getDelta(lastReplace);
            return fSource.get(offset - delta, length);

        } else if (ASSERT_SEQUENTIALITY) {
            throw new IllegalArgumentException(null);

        } else {

            int delta= 0;
            for (Iterator i= fReplaceList.iterator(); i.hasNext(); ) {
                Replace replace= cast(Replace) i.next();

                if (offset + length < replace.newOffset) {
                    return fSource.get(offset - delta, length);

                } else if (offset >= replace.newOffset && offset + length <= replace.newOffset + replace.text.length) {
                    return replace.text.substring(offset - replace.newOffset, offset - replace.newOffset + length);

                } else if (offset >= replace.newOffset + replace.text.length) {
                    delta= getDelta(replace);
                    continue;

                } else {
                    commit();
                    return fSource.get(offset, length);
                }
            }

            return fSource.get(offset - delta, length);
        }

    }

    /**
     * Returns the difference between the offset in the source store and the "same" offset in the
     * rewrite store after the replace operation.
     *
     * @param replace the replace command
     * @return the difference
     */
    private static final int getDelta(Replace replace) {
        return replace.newOffset - replace.offset + replace.text.length() - replace.length;
    }

    /*
     * @see dwtx.jface.text.ITextStore#get(int)
     */
    public char get(int offset) {
        if (fReplaceList.isEmpty())
            return fSource.get(offset);

        Replace firstReplace= cast(Replace) fReplaceList.getFirst();
        Replace lastReplace= cast(Replace) fReplaceList.getLast();

        // before
        if (offset < firstReplace.newOffset) {
            return fSource.get(offset);

            // after
        } else if (offset >= lastReplace.newOffset + lastReplace.text.length()) {
            int delta= getDelta(lastReplace);
            return fSource.get(offset - delta);

        } else if (ASSERT_SEQUENTIALITY) {
            throw new IllegalArgumentException(null);

        } else {

            int delta= 0;
            for (Iterator i= fReplaceList.iterator(); i.hasNext(); ) {
                Replace replace= cast(Replace) i.next();

                if (offset < replace.newOffset)
                    return fSource.get(offset - delta);

                else if (offset < replace.newOffset + replace.text.length())
                    return replace.text.charAt(offset - replace.newOffset);

                delta= getDelta(replace);
            }

            return fSource.get(offset - delta);
        }
    }

    /*
     * @see dwtx.jface.text.ITextStore#getLength()
     */
    public int getLength() {
        if (fReplaceList.isEmpty())
            return fSource.getLength();

        Replace lastReplace= cast(Replace) fReplaceList.getLast();
        return fSource.getLength() + getDelta(lastReplace);
    }

    /**
     * Disposes this rewrite store.
     */
    public void dispose() {
        fReplaceList= null;
        fSource= null;
    }

    /**
     * Commits all buffered replace commands.
     */
    private void commit() {

        if (fReplaceList.isEmpty())
            return;

        StringBuffer buffer= new StringBuffer();

        int delta= 0;
        for (Iterator i= fReplaceList.iterator(); i.hasNext(); ) {
            Replace replace= cast(Replace) i.next();

            int offset= buffer.length() - delta;
            buffer.append(fSource.get(offset, replace.offset - offset));
            buffer.append(replace.text);
            delta= getDelta(replace);
        }

        int offset= buffer.length() - delta;
        buffer.append(fSource.get(offset, fSource.getLength() - offset));

        fSource.set(buffer.toString());
        fReplaceList.clear();
    }
}
