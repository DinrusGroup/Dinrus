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
module dwtx.jface.text.ListLineTracker;

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

import dwtx.jface.text.AbstractLineTracker;

/**
 * Abstract, read-only implementation of <code>ILineTracker</code>. It lets the definition of
 * line delimiters to subclasses. Assuming that '\n' is the only line delimiter, this abstract
 * implementation defines the following line scheme:
 * <ul>
 * <li> "" -> [0,0]
 * <li> "a" -> [0,1]
 * <li> "\n" -> [0,1], [1,0]
 * <li> "a\n" -> [0,2], [2,0]
 * <li> "a\nb" -> [0,2], [2,1]
 * <li> "a\nbc\n" -> [0,2], [2,3], [5,0]
 * </ul>
 * This class must be subclassed.
 *
 * @since 3.2
 */
abstract class ListLineTracker : ILineTracker {

    /** The line information */
    private const List fLines;
    /** The length of the tracked text */
    private int fTextLength;

    /**
     * Creates a new line tracker.
     */
    protected this() {
        fLines= new ArrayList();
    }

    /**
     * Binary search for the line at a given offset.
     *
     * @param offset the offset whose line should be found
     * @return the line of the offset
     */
    private int findLine(int offset) {

        if (fLines.size() is 0)
            return -1;

        int left= 0;
        int right= fLines.size() - 1;
        int mid= 0;
        Line line= null;

        while (left < right) {

            mid= (left + right) / 2;

            line= cast(Line) fLines.get(mid);
            if (offset < line.offset) {
                if (left is mid)
                    right= left;
                else
                    right= mid - 1;
            } else if (offset > line.offset) {
                if (right is mid)
                    left= right;
                else
                    left= mid + 1;
            } else if (offset is line.offset) {
                left= right= mid;
            }
        }

        line= cast(Line) fLines.get(left);
        if (line.offset > offset)
            --left;
        return left;
    }

    /**
     * Returns the number of lines covered by the specified text range.
     *
     * @param startLine the line where the text range starts
     * @param offset the start offset of the text range
     * @param length the length of the text range
     * @return the number of lines covered by this text range
     * @exception BadLocationException if range is undefined in this tracker
     */
    private int getNumberOfLines(int startLine, int offset, int length)  {

        if (length is 0)
            return 1;

        int target= offset + length;

        Line l= cast(Line) fLines.get(startLine);

        if (l.delimiter is null)
            return 1;

        if (l.offset + l.length > target)
            return 1;

        if (l.offset + l.length is target)
            return 2;

        return getLineNumberOfOffset(target) - startLine + 1;
    }

    /*
     * @see dwtx.jface.text.ILineTracker#getLineLength(int)
     */
    public final int getLineLength(int line)  {
        int lines= fLines.size();

        if (line < 0 || line > lines)
            throw new BadLocationException();

        if (lines is 0 || lines is line)
            return 0;

        Line l= cast(Line) fLines.get(line);
        return l.length;
    }

    /*
     * @see dwtx.jface.text.ILineTracker#getLineNumberOfOffset(int)
     */
    public final int getLineNumberOfOffset(int position)  {
        if (position < 0 || position > fTextLength)
            throw new BadLocationException();

        if (position is fTextLength) {

            int lastLine= fLines.size() - 1;
            if (lastLine < 0)
                return 0;

            Line l= cast(Line) fLines.get(lastLine);
            return (l.delimiter !is null ? lastLine + 1 : lastLine);
        }

        return findLine(position);
    }

    /*
     * @see dwtx.jface.text.ILineTracker#getLineInformationOfOffset(int)
     */
    public final IRegion getLineInformationOfOffset(int position)  {
        if (position > fTextLength)
            throw new BadLocationException();

        if (position is fTextLength) {
            int size= fLines.size();
            if (size is 0)
                return new Region(0, 0);
            Line l= cast(Line) fLines.get(size - 1);
            return (l.delimiter !is null ? new Line(fTextLength, 0) : new Line(fTextLength - l.length, l.length));
        }

        return getLineInformation(findLine(position));
    }

    /*
     * @see dwtx.jface.text.ILineTracker#getLineInformation(int)
     */
    public final IRegion getLineInformation(int line)  {
        int lines= fLines.size();

        if (line < 0 || line > lines)
            throw new BadLocationException();

        if (lines is 0)
            return new Line(0, 0);

        if (line is lines) {
            Line l= cast(Line) fLines.get(line - 1);
            return new Line(l.offset + l.length, 0);
        }

        Line l= cast(Line) fLines.get(line);
        return (l.delimiter !is null ? new Line(l.offset, l.length - l.delimiter.length()) : l);
    }

    /*
     * @see dwtx.jface.text.ILineTracker#getLineOffset(int)
     */
    public final int getLineOffset(int line)  {
        int lines= fLines.size();

        if (line < 0 || line > lines)
            throw new BadLocationException();

        if (lines is 0)
            return 0;

        if (line is lines) {
            Line l= cast(Line) fLines.get(line - 1);
            if (l.delimiter !is null)
                return l.offset + l.length;
            throw new BadLocationException();
        }

        Line l= cast(Line) fLines.get(line);
        return l.offset;
    }

    /*
     * @see dwtx.jface.text.ILineTracker#getNumberOfLines()
     */
    public final int getNumberOfLines() {
        int lines= fLines.size();

        if (lines is 0)
            return 1;

        Line l= cast(Line) fLines.get(lines - 1);
        return (l.delimiter !is null ? lines + 1 : lines);
    }

    /*
     * @see dwtx.jface.text.ILineTracker#getNumberOfLines(int, int)
     */
    public final int getNumberOfLines(int position, int length)  {

        if (position < 0 || position + length > fTextLength)
            throw new BadLocationException();

        if (length is 0) // optimization
            return 1;

        return getNumberOfLines(getLineNumberOfOffset(position), position, length);
    }

    /*
     * @see dwtx.jface.text.ILineTracker#computeNumberOfLines(java.lang.String)
     */
    public final int computeNumberOfLines(String text) {
        int count= 0;
        int start= 0;
        AbstractLineTracker_DelimiterInfo delimiterInfo= nextDelimiterInfo(text, start);
        while (delimiterInfo !is null && delimiterInfo.delimiterIndex > -1) {
            ++count;
            start= delimiterInfo.delimiterIndex + delimiterInfo.delimiterLength;
            delimiterInfo= nextDelimiterInfo(text, start);
        }
        return count;
    }

    /*
     * @see dwtx.jface.text.ILineTracker#getLineDelimiter(int)
     */
    public final String getLineDelimiter(int line)  {
        int lines= fLines.size();

        if (line < 0 || line > lines)
            throw new BadLocationException();

        if (lines is 0)
            return null;

        if (line is lines)
            return null;

        Line l= cast(Line) fLines.get(line);
        return l.delimiter;
    }

    /**
     * Returns the information about the first delimiter found in the given text starting at the
     * given offset.
     *
     * @param text the text to be searched
     * @param offset the offset in the given text
     * @return the information of the first found delimiter or <code>null</code>
     */
    protected abstract AbstractLineTracker_DelimiterInfo nextDelimiterInfo(String text, int offset);

    /**
     * Creates the line structure for the given text. Newly created lines are inserted into the line
     * structure starting at the given position. Returns the number of newly created lines.
     *
     * @param text the text for which to create a line structure
     * @param insertPosition the position at which the newly created lines are inserted into the
     *        tracker's line structure
     * @param offset the offset of all newly created lines
     * @return the number of newly created lines
     */
    private int createLines(String text, int insertPosition, int offset) {

        int count= 0;
        int start= 0;
        AbstractLineTracker_DelimiterInfo delimiterInfo= nextDelimiterInfo(text, 0);

        while (delimiterInfo !is null && delimiterInfo.delimiterIndex > -1) {

            int index= delimiterInfo.delimiterIndex + (delimiterInfo.delimiterLength - 1);

            if (insertPosition + count >= fLines.size())
                fLines.add(new Line(offset + start, offset + index, delimiterInfo.delimiter));
            else
                fLines.add(insertPosition + count, new Line(offset + start, offset + index, delimiterInfo.delimiter));

            ++count;
            start= index + 1;
            delimiterInfo= nextDelimiterInfo(text, start);
        }

        if (start < text.length()) {
            if (insertPosition + count < fLines.size()) {
                // there is a line below the current
                Line l= cast(Line) fLines.get(insertPosition + count);
                int delta= text.length() - start;
                l.offset-= delta;
                l.length+= delta;
            } else {
                fLines.add(new Line(offset + start, offset + text.length() - 1, null));
                ++count;
            }
        }

        return count;
    }

    /*
     * @see dwtx.jface.text.ILineTracker#replace(int, int, java.lang.String)
     */
    public final void replace(int position, int length, String text)  {
        throw new UnsupportedOperationException();
    }

    /*
     * @see dwtx.jface.text.ILineTracker#set(java.lang.String)
     */
    public final void set(String text) {
        fLines.clear();
        if (text !is null) {
            fTextLength= text.length();
            createLines(text, 0, 0);
        }
    }

    /**
     * Returns the internal data structure, a {@link List} of {@link Line}s. Used only by
     * {@link TreeLineTracker#TreeLineTracker(ListLineTracker)}.
     *
     * @return the internal list of lines.
     */
    final List getLines() {
        return fLines;
    }
}
