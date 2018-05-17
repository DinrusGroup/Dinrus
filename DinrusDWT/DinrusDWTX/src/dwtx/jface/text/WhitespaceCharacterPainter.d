/*******************************************************************************
 * Copyright (c) 2006, 2007 Wind River Systems, Inc. and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Anton Leherbauer (Wind River Systems) - initial API and implementation - https://bugs.eclipse.org/bugs/show_bug.cgi?id=22712
 *     Anton Leherbauer (Wind River Systems) - [painting] Long lines take too long to display when "Show Whitespace Characters" is enabled - https://bugs.eclipse.org/bugs/show_bug.cgi?id=196116
 *     Anton Leherbauer (Wind River Systems) - [painting] Whitespace characters not drawn when scrolling to right slowly - https://bugs.eclipse.org/bugs/show_bug.cgi?id=206633
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/
module dwtx.jface.text.WhitespaceCharacterPainter;

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

import dwt.custom.StyleRange;
import dwt.custom.StyledText;
import dwt.custom.StyledTextContent;
import dwt.events.PaintEvent;
import dwt.events.PaintListener;
import dwt.graphics.Color;
import dwt.graphics.FontMetrics;
import dwt.graphics.GC;
import dwt.graphics.Point;


/**
 * A painter for drawing visible characters for (invisible) whitespace
 * characters.
 *
 * @since 3.3
 */
public class WhitespaceCharacterPainter : IPainter, PaintListener {

    private static const char SPACE_SIGN= '\u00b7';
    private static const char IDEOGRAPHIC_SPACE_SIGN= '\u00b0';
    private static const char TAB_SIGN= '\u00bb';
    private static const char CARRIAGE_RETURN_SIGN= '\u00a4';
    private static const char LINE_FEED_SIGN= '\u00b6';

    /** Indicates whether this painter is active. */
    private bool fIsActive= false;
    /** The source viewer this painter is attached to. */
    private ITextViewer fTextViewer;
    /** The viewer's widget. */
    private StyledText fTextWidget;
    /** Tells whether the advanced graphics sub system is available. */
    private bool fIsAdvancedGraphicsPresent;

    /**
     * Creates a new painter for the given text viewer.
     *
     * @param textViewer  the text viewer the painter should be attached to
     */
    public this(ITextViewer textViewer) {
//         super();
        fTextViewer= textViewer;
        fTextWidget= textViewer.getTextWidget();
        GC gc= new GC(fTextWidget);
        gc.setAdvanced(true);
        fIsAdvancedGraphicsPresent= gc.getAdvanced();
        gc.dispose();
    }

    /*
     * @see dwtx.jface.text.IPainter#dispose()
     */
    public void dispose() {
        fTextViewer= null;
        fTextWidget= null;
    }

    /*
     * @see dwtx.jface.text.IPainter#paint(int)
     */
    public void paint(int reason) {
        IDocument document= fTextViewer.getDocument();
        if (document is null) {
            deactivate(false);
            return;
        }
        if (!fIsActive) {
            fIsActive= true;
            fTextWidget.addPaintListener(this);
            redrawAll();
        } else if (reason is CONFIGURATION || reason is INTERNAL) {
            redrawAll();
        } else if (reason is TEXT_CHANGE) {
            // redraw current line only
            try {
                IRegion lineRegion =
                    document.getLineInformationOfOffset(getDocumentOffset(fTextWidget.getCaretOffset()));
                int widgetOffset= getWidgetOffset(lineRegion.getOffset());
                int charCount= fTextWidget.getCharCount();
                int redrawLength= Math.min(lineRegion.getLength(), charCount - widgetOffset);
                if (widgetOffset >= 0 && redrawLength > 0) {
                    fTextWidget.redrawRange(widgetOffset, redrawLength, true);
                }
            } catch (BadLocationException e) {
                // ignore
            }
        }
    }

    /*
     * @see dwtx.jface.text.IPainter#deactivate(bool)
     */
    public void deactivate(bool redraw) {
        if (fIsActive) {
            fIsActive= false;
            fTextWidget.removePaintListener(this);
            if (redraw) {
                redrawAll();
            }
        }
    }

    /*
     * @see dwtx.jface.text.IPainter#setPositionManager(dwtx.jface.text.IPaintPositionManager)
     */
    public void setPositionManager(IPaintPositionManager manager) {
        // no need for a position manager
    }

    /*
     * @see dwt.events.PaintListener#paintControl(dwt.events.PaintEvent)
     */
    public void paintControl(PaintEvent event) {
        if (fTextWidget !is null) {
            handleDrawRequest(event.gc, event.x, event.y, event.width, event.height);
        }
    }

    /**
     * Draw characters in view range.
     *
     * @param gc
     * @param x
     * @param y
     * @param w
     * @param h
     */
    private void handleDrawRequest(GC gc, int x, int y, int w, int h) {
        int startLine= fTextWidget.getLineIndex(y);
        int endLine= fTextWidget.getLineIndex(y + h - 1);
        if (startLine <= endLine && startLine < fTextWidget.getLineCount()) {
            if (fIsAdvancedGraphicsPresent) {
                int alpha= gc.getAlpha();
                gc.setAlpha(100);
                drawLineRange(gc, startLine, endLine, x, w);
                gc.setAlpha(alpha);
            } else
                drawLineRange(gc, startLine, endLine, x, w);
        }
    }

    /**
     * Draw the given line range.
     *
     * @param gc
     * @param startLine  first line number
     * @param endLine  last line number (inclusive)
     * @param x  the X-coordinate of the drawing range
     * @param w  the width of the drawing range
     */
    private void drawLineRange(GC gc, int startLine, int endLine, int x, int w) {
        final int viewPortWidth= fTextWidget.getClientArea().width;
        for (int line= startLine; line <= endLine; line++) {
            int lineOffset= fTextWidget.getOffsetAtLine(line);
            // line end offset including line delimiter
            int lineEndOffset;
            if (line < fTextWidget.getLineCount() - 1) {
                lineEndOffset= fTextWidget.getOffsetAtLine(line + 1);
            } else {
                lineEndOffset= fTextWidget.getCharCount();
            }
            // line length excluding line delimiter
            int lineLength= lineEndOffset - lineOffset;
            while (lineLength > 0) {
                char c= fTextWidget.getTextRange(lineOffset + lineLength - 1, 1).charAt(0);
                if (c !is '\r' && c !is '\n') {
                    break;
                }
                --lineLength;
            }
            // compute coordinates of last character on line
            Point endOfLine= fTextWidget.getLocationAtOffset(lineOffset + lineLength);
            if (x - endOfLine.x > viewPortWidth) {
                // line is not visible
                continue;
            }
            // Y-coordinate of line
            int y= fTextWidget.getLinePixel(line);
            // compute first visible char offset
            int startOffset;
            try {
                startOffset= fTextWidget.getOffsetAtLocation(new Point(x, y)) - 1;
                if (startOffset - 2 <= lineOffset) {
                    startOffset= lineOffset;
                }
            } catch (IllegalArgumentException iae) {
                startOffset= lineOffset;
            }
            // compute last visible char offset
            int endOffset;
            if (x + w >= endOfLine.x) {
                // line end is visible
                endOffset= lineEndOffset;
            } else {
                try {
                    endOffset= fTextWidget.getOffsetAtLocation(new Point(x + w - 1, y)) + 1;
                    if (endOffset + 2 >= lineEndOffset) {
                        endOffset= lineEndOffset;
                    }
                } catch (IllegalArgumentException iae) {
                    endOffset= lineEndOffset;
                }
            }
            // draw character range
            if (endOffset > startOffset) {
                drawCharRange(gc, startOffset, endOffset);
            }
        }
    }

    /**
     * Draw characters of content range.
     *
     * @param gc the GC
     * @param startOffset inclusive start index
     * @param endOffset exclusive end index
     */
    private void drawCharRange(GC gc, int startOffset, int endOffset) {
        StyledTextContent content= fTextWidget.getContent();
        int length= endOffset - startOffset;
        String text= content.getTextRange(startOffset, length);
        StyleRange styleRange= null;
        Color fg= null;
        Point selection= fTextWidget.getSelection();
        StringBuffer visibleChar= new StringBuffer(10);
        for (int textOffset= 0; textOffset <= length; ++textOffset) {
            int delta= 0;
            bool eol= false;
            if (textOffset < length) {
                delta= 1;
                char c= text.charAt(textOffset);
                switch (c) {
                case ' ' :
                    visibleChar.append(SPACE_SIGN);
                    // 'continue' would improve performance but may produce drawing errors
                    // for long runs of space if width of space and dot differ
                    break;
                case '\u3000' : // ideographic whitespace
                    visibleChar.append(IDEOGRAPHIC_SPACE_SIGN);
                    // 'continue' would improve performance but may produce drawing errors
                    // for long runs of space if width of space and dot differ
                    break;
                case '\t' :
                    visibleChar.append(TAB_SIGN);
                    break;
                case '\r' :
                    visibleChar.append(CARRIAGE_RETURN_SIGN);
                    if (textOffset >= length - 1 || text.charAt(textOffset + 1) !is '\n') {
                        eol= true;
                        break;
                    }
                    continue;
                case '\n' :
                    visibleChar.append(LINE_FEED_SIGN);
                    eol= true;
                    break;
                default :
                    delta= 0;
                    break;
                }
            }
            if (visibleChar.length() > 0) {
                int widgetOffset= startOffset + textOffset - visibleChar.length() + delta;
                if (!eol || !isFoldedLine(content.getLineAtOffset(widgetOffset))) {
                    if (widgetOffset >= selection.x && widgetOffset < selection.y) {
                        fg= fTextWidget.getSelectionForeground();
                    } else if (styleRange is null || styleRange.start + styleRange.length <= widgetOffset) {
                        styleRange= fTextWidget.getStyleRangeAtOffset(widgetOffset);
                        if (styleRange is null || styleRange.foreground is null) {
                            fg= fTextWidget.getForeground();
                        } else {
                            fg= styleRange.foreground;
                        }
                    }
                    draw(gc, widgetOffset, visibleChar.toString(), fg);
                }
                visibleChar.truncate(0);
            }
        }
    }

    /**
     * Check if the given widget line is a folded line.
     *
     * @param widgetLine  the widget line number
     * @return <code>true</code> if the line is folded
     */
    private bool isFoldedLine(int widgetLine) {
        if ( cast(ITextViewerExtension5)fTextViewer ) {
            ITextViewerExtension5 extension= cast(ITextViewerExtension5)fTextViewer;
            int modelLine= extension.widgetLine2ModelLine(widgetLine);
            int widgetLine2= extension.modelLine2WidgetLine(modelLine + 1);
            return widgetLine2 is -1;
        }
        return false;
    }

    /**
     * Redraw all of the text widgets visible content.
     */
    private void redrawAll() {
        fTextWidget.redraw();
    }

    /**
     * Draw string at widget offset.
     *
     * @param gc
     * @param offset the widget offset
     * @param s the string to be drawn
     * @param fg the foreground color
     */
    private void draw(GC gc, int offset, String s, Color fg) {
        // Compute baseline delta (see https://bugs.eclipse.org/bugs/show_bug.cgi?id=165640)
        int baseline= fTextWidget.getBaseline(offset);
        FontMetrics fontMetrics= gc.getFontMetrics();
        int fontBaseline= fontMetrics.getAscent() + fontMetrics.getLeading();
        int baslineDelta= baseline - fontBaseline;

        Point pos= fTextWidget.getLocationAtOffset(offset);
        gc.setForeground(fg);
        gc.drawString(s, pos.x, pos.y + baslineDelta, true);
    }

    /**
     * Convert a document offset to the corresponding widget offset.
     *
     * @param documentOffset
     * @return widget offset
     */
    private int getWidgetOffset(int documentOffset) {
        if ( cast(ITextViewerExtension5)fTextViewer ) {
            ITextViewerExtension5 extension= cast(ITextViewerExtension5)fTextViewer;
            return extension.modelOffset2WidgetOffset(documentOffset);
        }
        IRegion visible= fTextViewer.getVisibleRegion();
        int widgetOffset= documentOffset - visible.getOffset();
        if (widgetOffset > visible.getLength()) {
            return -1;
        }
        return widgetOffset;
    }

    /**
     * Convert a widget offset to the corresponding document offset.
     *
     * @param widgetOffset
     * @return document offset
     */
    private int getDocumentOffset(int widgetOffset) {
        if ( cast(ITextViewerExtension5)fTextViewer ) {
            ITextViewerExtension5 extension= cast(ITextViewerExtension5)fTextViewer;
            return extension.widgetOffset2ModelOffset(widgetOffset);
        }
        IRegion visible= fTextViewer.getVisibleRegion();
        if (widgetOffset > visible.getLength()) {
            return -1;
        }
        return widgetOffset + visible.getOffset();
    }

}
