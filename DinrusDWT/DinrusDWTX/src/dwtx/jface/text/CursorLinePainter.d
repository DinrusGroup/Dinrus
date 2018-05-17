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


module dwtx.jface.text.CursorLinePainter;

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




import dwt.custom.LineBackgroundEvent;
import dwt.custom.LineBackgroundListener;
import dwt.custom.StyledText;
import dwt.graphics.Color;
import dwt.graphics.Point;


/**
 * A painter the draws the background of the caret line in a configured color.
 * <p>
 * Clients usually instantiate and configure object of this class.</p>
 * <p>
 * This class is not intended to be subclassed.</p>
 *
 * @since 2.1
 * @noextend This class is not intended to be subclassed by clients.
 */
public class CursorLinePainter : IPainter, LineBackgroundListener {

    /** The viewer the painter works on */
    private const ITextViewer fViewer;
    /** The cursor line back ground color */
    private Color fHighlightColor;
    /** The paint position manager for managing the line coordinates */
    private IPaintPositionManager fPositionManager;

    /** Keeps track of the line to be painted */
    private Position fCurrentLine;
    /** Keeps track of the line to be cleared */
    private Position fLastLine;
    /** Keeps track of the line number of the last painted line */
    private int fLastLineNumber= -1;
    /** Indicates whether this painter is active */
    private bool fIsActive;

    /**
     * Creates a new painter for the given source viewer.
     *
     * @param textViewer the source viewer for which to create a painter
     */
    public this(ITextViewer textViewer) {
        fCurrentLine= new Position(0, 0);
        fLastLine= new Position(0, 0);
        fViewer= textViewer;
    }

    /**
     * Sets the color in which to draw the background of the cursor line.
     *
     * @param highlightColor the color in which to draw the background of the cursor line
     */
    public void setHighlightColor(Color highlightColor) {
        fHighlightColor= highlightColor;
    }

    /*
     * @see LineBackgroundListener#lineGetBackground(LineBackgroundEvent)
     */
    public void lineGetBackground(LineBackgroundEvent event) {
        // don't use cached line information because of asynchronous painting

        StyledText textWidget= fViewer.getTextWidget();
        if (textWidget !is null) {

            int caret= textWidget.getCaretOffset();
            int length= event.lineText.length();

            if (event.lineOffset <= caret && caret <= event.lineOffset + length)
                event.lineBackground= fHighlightColor;
            else
                event.lineBackground= textWidget.getBackground();
        }
    }

    /**
     * Updates all the cached information about the lines to be painted and to be cleared. Returns <code>true</code>
     * if the line number of the cursor line has changed.
     *
     * @return <code>true</code> if cursor line changed
     */
    private bool updateHighlightLine() {
        try {

            IDocument document= fViewer.getDocument();
            int modelCaret= getModelCaret();
            int lineNumber= document.getLineOfOffset(modelCaret);

            // redraw if the current line number is different from the last line number we painted
            // initially fLastLineNumber is -1
            if (lineNumber !is fLastLineNumber || !fCurrentLine.overlapsWith(modelCaret, 0)) {

                fLastLine.offset= fCurrentLine.offset;
                fLastLine.length= fCurrentLine.length;
                fLastLine.isDeleted_= fCurrentLine.isDeleted_;

                if (fCurrentLine.isDeleted_) {
                    fCurrentLine.isDeleted_= false;
                    fPositionManager.managePosition(fCurrentLine);
                }

                fCurrentLine.offset= document.getLineOffset(lineNumber);
                if (lineNumber is document.getNumberOfLines() - 1)
                    fCurrentLine.length= document.getLength() - fCurrentLine.offset;
                else
                    fCurrentLine.length= document.getLineOffset(lineNumber + 1) - fCurrentLine.offset;

                fLastLineNumber= lineNumber;
                return true;

            }

        } catch (BadLocationException e) {
        }

        return false;
    }

    /**
     * Returns the location of the caret as offset in the source viewer's
     * input document.
     *
     * @return the caret location
     */
    private int getModelCaret() {
        int widgetCaret= fViewer.getTextWidget().getCaretOffset();
        if ( cast(ITextViewerExtension5)fViewer ) {
            ITextViewerExtension5 extension= cast(ITextViewerExtension5) fViewer;
            return extension.widgetOffset2ModelOffset(widgetCaret);
        }
        IRegion visible= fViewer.getVisibleRegion();
        return widgetCaret + visible.getOffset();
    }

    /**
     * Assumes the given position to specify offset and length of a line to be painted.
     *
     * @param position the specification of the line  to be painted
     */
    private void drawHighlightLine(Position position) {

        // if the position that is about to be drawn was deleted then we can't
        if (position.isDeleted())
            return;

        int widgetOffset= 0;
        if ( cast(ITextViewerExtension5)fViewer ) {

            ITextViewerExtension5 extension= cast(ITextViewerExtension5) fViewer;
            widgetOffset= extension.modelOffset2WidgetOffset(position.getOffset());
            if (widgetOffset is -1)
                return;

        } else {

            IRegion visible= fViewer.getVisibleRegion();
            widgetOffset= position.getOffset() - visible.getOffset();
            if (widgetOffset < 0 || visible.getLength() < widgetOffset )
                return;
        }

        StyledText textWidget= fViewer.getTextWidget();
        // check for https://bugs.eclipse.org/bugs/show_bug.cgi?id=64898
        // this is a guard against the symptoms but not the actual solution
        if (0 <= widgetOffset && widgetOffset <= textWidget.getCharCount()) {
            Point upperLeft= textWidget.getLocationAtOffset(widgetOffset);
            int width= textWidget.getClientArea().width + textWidget.getHorizontalPixel();
            int height= textWidget.getLineHeight(widgetOffset);
            textWidget.redraw(0, upperLeft.y, width, height, false);
        }
    }

    /*
     * @see IPainter#deactivate(bool)
     */
    public void deactivate(bool redraw) {
        if (fIsActive) {
            fIsActive= false;

            /* on turning off the feature one has to paint the currently
             * highlighted line with the standard background color
             */
            if (redraw)
                drawHighlightLine(fCurrentLine);

            fViewer.getTextWidget().removeLineBackgroundListener(this);

            if (fPositionManager !is null)
                fPositionManager.unmanagePosition(fCurrentLine);

            fLastLineNumber= -1;
            fCurrentLine.offset= 0;
            fCurrentLine.length= 0;
        }
    }

    /*
     * @see IPainter#dispose()
     */
    public void dispose() {
    }

    /*
     * @see IPainter#paint(int)
     */
    public void paint(int reason) {
        if (fViewer.getDocument() is null) {
            deactivate(false);
            return;
        }

        StyledText textWidget= fViewer.getTextWidget();

        // check selection
        Point selection= textWidget.getSelection();
        int startLine= textWidget.getLineAtOffset(selection.x);
        int endLine= textWidget.getLineAtOffset(selection.y);
        if (startLine !is endLine) {
            deactivate(true);
            return;
        }

        // initialization
        if (!fIsActive) {
            textWidget.addLineBackgroundListener(this);
            fPositionManager.managePosition(fCurrentLine);
            fIsActive= true;
        }

        //redraw line highlight only if it hasn't been drawn yet on the respective line
        if (updateHighlightLine()) {
            // clear last line
            drawHighlightLine(fLastLine);
            // draw new line
            drawHighlightLine(fCurrentLine);
        }
    }

    /*
     * @see IPainter#setPositionManager(IPaintPositionManager)
     */
    public void setPositionManager(IPaintPositionManager manager) {
        fPositionManager = manager;
    }
}
