/*******************************************************************************
 * Copyright (c) 2006, 2008 IBM Corporation and others.
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
module dwtx.jface.text.JFaceTextUtil;

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



import dwt.custom.StyledText;
import dwt.graphics.GC;
import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwt.widgets.Control;
import dwtx.jface.text.source.ILineRange;
import dwtx.jface.text.source.LineRange;

/**
 * A collection of JFace Text functions.
 * <p>
 * This class is neither intended to be instantiated nor subclassed.
 * </p>
 *
 * @since 3.3
 * @noinstantiate This class is not intended to be instantiated by clients.
 */
public final class JFaceTextUtil {

    private this() {
        // Do not instantiate
    }

    /**
     * Computes the line height for the given line range.
     *
     * @param textWidget the <code>StyledText</code> widget
     * @param startLine the start line
     * @param endLine the end line (exclusive)
     * @param lineCount the line count used by the old API
     * @return the height of all lines starting with <code>startLine</code> and ending above <code>endLime</code>
     */
    public static int computeLineHeight(StyledText textWidget, int startLine, int endLine, int lineCount) {
        return getLinePixel(textWidget, endLine) - getLinePixel(textWidget, startLine);
    }

    /**
     * Returns the last fully visible line of the widget. The exact semantics of "last fully visible
     * line" are:
     * <ul>
     * <li>the last line of which the last pixel is visible, if any
     * <li>otherwise, the only line that is partially visible
     * </ul>
     *
     * @param widget the widget
     * @return the last fully visible line
     */
    public static int getBottomIndex(StyledText widget) {
        int lastPixel= computeLastVisiblePixel(widget);

        // bottom is in [0 .. lineCount - 1]
        int bottom= widget.getLineIndex(lastPixel);

        // bottom is the first line - no more checking
        if (bottom is 0)
            return bottom;

        int pixel= widget.getLinePixel(bottom);
        // bottom starts on or before the client area start - bottom is the only visible line
        if (pixel <= 0)
            return bottom;

        int offset= widget.getOffsetAtLine(bottom);
        int height= widget.getLineHeight(offset);

        // bottom is not showing entirely - use the previous line
        if (pixel + height - 1 > lastPixel)
            return bottom - 1;

        // bottom is fully visible and its last line is exactly the last pixel
        return bottom;
    }

    /**
     * Returns the index of the first (possibly only partially) visible line of the widget
     *
     * @param widget the widget
     * @return the index of the first line of which a pixel is visible
     */
    public static int getPartialTopIndex(StyledText widget) {
        // see StyledText#getPartialTopIndex()
        int top= widget.getTopIndex();
        int pixels= widget.getLinePixel(top);

        // FIXME remove when https://bugs.eclipse.org/bugs/show_bug.cgi?id=123770 is fixed
        if (pixels is -widget.getLineHeight(widget.getOffsetAtLine(top))) {
            top++;
            pixels= 0;
        }

        if (pixels > 0)
            top--;

        return top;
    }

    /**
     * Returns the index of the last (possibly only partially) visible line of the widget
     *
     * @param widget the text widget
     * @return the index of the last line of which a pixel is visible
     */
    public static int getPartialBottomIndex(StyledText widget) {
        // @see StyledText#getPartialBottomIndex()
        int lastPixel= computeLastVisiblePixel(widget);
        int bottom= widget.getLineIndex(lastPixel);
        return bottom;
    }

    /**
     * Returns the last visible pixel in the widget's client area.
     *
     * @param widget the widget
     * @return the last visible pixel in the widget's client area
     */
    private static int computeLastVisiblePixel(StyledText widget) {
        int caHeight= widget.getClientArea().height;
        int lastPixel= caHeight - 1;
        // XXX what if there is a margin? can't take trim as this includes the scrollbars which are not part of the client area
//      if ((textWidget.getStyle() & DWT.BORDER) !is 0)
//          lastPixel -= 4;
        return lastPixel;
    }

    /**
     * Returns the line index of the first visible model line in the viewer. The line may be only
     * partially visible.
     *
     * @param viewer the text viewer
     * @return the first line of which a pixel is visible, or -1 for no line
     */
    public static int getPartialTopIndex(ITextViewer viewer) {
        StyledText widget= viewer.getTextWidget();
        int widgetTop= getPartialTopIndex(widget);
        return widgetLine2ModelLine(viewer, widgetTop);
    }

    /**
     * Returns the last, possibly partially, visible line in the view port.
     *
     * @param viewer the text viewer
     * @return the last, possibly partially, visible line in the view port
     */
    public static int getPartialBottomIndex(ITextViewer viewer) {
        StyledText textWidget= viewer.getTextWidget();
        int widgetBottom= getPartialBottomIndex(textWidget);
        return widgetLine2ModelLine(viewer, widgetBottom);
    }

    /**
     * Returns the range of lines that is visible in the viewer, including any partially visible
     * lines.
     *
     * @param viewer the viewer
     * @return the range of lines that is visible in the viewer, <code>null</code> if no lines are
     *         visible
     */
    public static ILineRange getVisibleModelLines(ITextViewer viewer) {
        int top= getPartialTopIndex(viewer);
        int bottom= getPartialBottomIndex(viewer);
        if (top is -1 || bottom is -1)
            return null;
        return new LineRange(top, bottom - top + 1);
    }

    /**
     * Converts a widget line into a model (i.e. {@link IDocument}) line using the
     * {@link ITextViewerExtension5} if available, otherwise by adapting the widget line to the
     * viewer's {@link ITextViewer#getVisibleRegion() visible region}.
     *
     * @param viewer the viewer
     * @param widgetLine the widget line to convert.
     * @return the model line corresponding to <code>widgetLine</code> or -1 to signal that there
     *         is no corresponding model line
     */
    public static int widgetLine2ModelLine(ITextViewer viewer, int widgetLine) {
        int modelLine;
        if ( cast(ITextViewerExtension5)viewer ) {
            ITextViewerExtension5 extension= cast(ITextViewerExtension5) viewer;
            modelLine= extension.widgetLine2ModelLine(widgetLine);
        } else {
            try {
                IRegion r= viewer.getVisibleRegion();
                IDocument d= viewer.getDocument();
                modelLine= widgetLine + d.getLineOfOffset(r.getOffset());
            } catch (BadLocationException x) {
                modelLine= widgetLine;
            }
        }
        return modelLine;
    }

    /**
     * Converts a model (i.e. {@link IDocument}) line into a widget line using the
     * {@link ITextViewerExtension5} if available, otherwise by adapting the model line to the
     * viewer's {@link ITextViewer#getVisibleRegion() visible region}.
     *
     * @param viewer the viewer
     * @param modelLine the model line to convert.
     * @return the widget line corresponding to <code>modelLine</code> or -1 to signal that there
     *         is no corresponding widget line
     */
    public static int modelLineToWidgetLine(ITextViewer viewer, int modelLine) {
        int widgetLine;
        if ( cast(ITextViewerExtension5)viewer ) {
            ITextViewerExtension5 extension= cast(ITextViewerExtension5) viewer;
            widgetLine= extension.modelLine2WidgetLine(modelLine);
        } else {
            IRegion region= viewer.getVisibleRegion();
            IDocument document= viewer.getDocument();
            try {
                int visibleStartLine= document.getLineOfOffset(region.getOffset());
                int visibleEndLine= document.getLineOfOffset(region.getOffset() + region.getLength());
                if (modelLine < visibleStartLine || modelLine > visibleEndLine)
                    widgetLine= -1;
                else
                widgetLine= modelLine - visibleStartLine;
            } catch (BadLocationException x) {
                // ignore and return -1
                widgetLine= -1;
            }
        }
        return widgetLine;
    }


    /**
     * Returns the number of hidden pixels of the first partially visible line. If there is no
     * partially visible line, zero is returned.
     *
     * @param textWidget the widget
     * @return the number of hidden pixels of the first partial line, always &gt;= 0
     */
    public static int getHiddenTopLinePixels(StyledText textWidget) {
        int top= getPartialTopIndex(textWidget);
        return -textWidget.getLinePixel(top);
    }

    /*
     * @see StyledText#getLinePixel(int)
     */
    public static int getLinePixel(StyledText textWidget, int line) {
        return textWidget.getLinePixel(line);
    }

    /*
     * @see StyledText#getLineIndex(int)
     */
    public static int getLineIndex(StyledText textWidget, int y) {
        int lineIndex= textWidget.getLineIndex(y);
        return lineIndex;
    }

    /**
     * Returns <code>true</code> if the widget displays the entire contents, i.e. it cannot
     * be vertically scrolled.
     *
     * @param widget the widget
     * @return <code>true</code> if the widget displays the entire contents, i.e. it cannot
     *         be vertically scrolled, <code>false</code> otherwise
     */
    public static bool isShowingEntireContents(StyledText widget) {
        if (widget.getTopPixel() !is 0) // more efficient shortcut
            return false;

        int lastVisiblePixel= computeLastVisiblePixel(widget);
        int lastPossiblePixel= widget.getLinePixel(widget.getLineCount());
        return lastPossiblePixel <= lastVisiblePixel;
    }

    /**
     * Determines the graphical area covered by the given text region in
     * the given viewer.
     *
     * @param region the region whose graphical extend must be computed
     * @param textViewer the text viewer containing the region
     * @return the graphical extend of the given region in the given viewer
     *
     * @since 3.4
     */
    public static Rectangle computeArea(IRegion region, ITextViewer textViewer) {
        int start= 0;
        int end= 0;
        IRegion widgetRegion= modelRange2WidgetRange(region, textViewer);
        if (widgetRegion !is null) {
            start= widgetRegion.getOffset();
            end= start + widgetRegion.getLength();
        }

        StyledText styledText= textViewer.getTextWidget();
        Rectangle bounds;
        if (end > 0 && start < end)
            bounds= styledText.getTextBounds(start, end - 1);
        else {
            Point loc= styledText.getLocationAtOffset(start);
            bounds= new Rectangle(loc.x, loc.y, getAverageCharWidth(textViewer.getTextWidget()), styledText.getLineHeight(start));
        }

        return new Rectangle(bounds.x, bounds.y, bounds.width, bounds.height);
    }

    /**
     * Translates a given region of the text viewer's document into
     * the corresponding region of the viewer's widget.
     *
     * @param region the document region
     * @param textViewer the viewer containing the region
     * @return the corresponding widget region
     *
     * @since 3.4
     */
    private static IRegion modelRange2WidgetRange(IRegion region, ITextViewer textViewer) {
        if ( cast(ITextViewerExtension5)textViewer ) {
            ITextViewerExtension5 extension= cast(ITextViewerExtension5) textViewer;
            return extension.modelRange2WidgetRange(region);
        }

        IRegion visibleRegion= textViewer.getVisibleRegion();
        int start= region.getOffset() - visibleRegion.getOffset();
        int end= start + region.getLength();
        if (end > visibleRegion.getLength())
            end= visibleRegion.getLength();

        return new Region(start, end - start);
    }

    /**
     * Returns the average character width of the given control's font.
     *
     * @param control the control to calculate the average char width for
     * @return the average character width of the controls font
     *
     * @since 3.4
     */
    public static int getAverageCharWidth(Control control) {
        GC gc= new GC(control);
        gc.setFont(control.getFont());
        int increment= gc.getFontMetrics().getAverageCharWidth();
        gc.dispose();
        return increment;
    }

}
