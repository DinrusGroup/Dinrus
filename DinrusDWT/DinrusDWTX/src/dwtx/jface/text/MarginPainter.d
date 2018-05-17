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
module dwtx.jface.text.MarginPainter;

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


import dwt.DWT;
import dwt.custom.StyledText;
import dwt.events.PaintEvent;
import dwt.events.PaintListener;
import dwt.graphics.Color;
import dwt.graphics.GC;
import dwt.graphics.Rectangle;


/**
 * Paints a vertical line (margin line) after a given column respecting the text
 * viewer's font.
 * <p>
 * Clients usually instantiate and configure objects of this class.</p>
 * <p>
 * This class is not intended to be subclassed.</p>
 *
 * @since 2.1
 * @noextend This class is not intended to be subclassed by clients.
 */
public class MarginPainter : IPainter, PaintListener {

    /** The widget of the text viewer */
    private StyledText fTextWidget;

    /** The column after which to paint the line, default value <code>80</code> */
    private int fMarginWidth= 80;
    /** The color in which to paint the line */
    private Color fColor;
    /** The line style of the line to be painted, default value <code>DWT.LINE_SOLID</code> */
    private int fLineStyle= DWT.LINE_SOLID;
    /** The line width of the line to be painted, default value <code>1</code> */
    private int fLineWidth= 0; // NOTE: 0 means width is 1 but with optimized performance
    /** The cached x-offset of the <code>fMarginWidth</code> for the current font */
    private int fCachedWidgetX= -1;
    /** The active state of this painter */
    private bool fIsActive= false;

    /**
     * Creates a new painter for the given text viewer.
     *
     * @param textViewer the text viewer
     */
    public this(ITextViewer textViewer) {
        fTextWidget= textViewer.getTextWidget();
    }

    /**
     * Sets the column after which to draw the margin line.
     *
     * @param width the column
     */
    public void setMarginRulerColumn(int width) {
        fMarginWidth= width;
        initialize();
    }

    /**
     * Sets the line style of the margin line.
     *
     * @param lineStyle a <code>DWT</code> style constant describing the line style
     */
    public void setMarginRulerStyle(int lineStyle) {
        fLineStyle= lineStyle;
    }

    /**
     * Sets the line width of the margin line.
     *
     * @param lineWidth the line width
     */
    public void setMarginRulerWidth(int lineWidth) {
        if (lineWidth is 1)
            lineWidth= 0; // NOTE: 0 means width is 1 but with optimized performance
        fLineWidth= lineWidth;
    }

    /**
     * Sets the color of the margin line. Must be called before <code>paint</code> is called the first time.
     *
     * @param color the color
     */
    public void setMarginRulerColor(Color color) {
        fColor= color;
    }

    /**
     * Initializes this painter, by flushing and recomputing all caches and causing
     * the widget to be redrawn. Must be called explicitly when font of text widget changes.
     */
    public void initialize() {
        computeWidgetX();
        fTextWidget.redraw();
    }

    /**
     * Computes and remembers the x-offset of the margin column for the
     * current widget font.
     */
    private void computeWidgetX() {
        GC gc= new GC(fTextWidget);
        int pixels= gc.getFontMetrics().getAverageCharWidth();
        gc.dispose();

        fCachedWidgetX= pixels * fMarginWidth;
    }

    /*
     * @see IPainter#deactivate(bool)
     */
    public void deactivate(bool redraw) {
        if (fIsActive) {
            fIsActive= false;
            fCachedWidgetX= -1;
            fTextWidget.removePaintListener(this);
            if (redraw)
                fTextWidget.redraw();
        }
    }

    /*
     * @see IPainter#dispose()
     */
    public void dispose() {
        fTextWidget= null;
    }

    /*
     * @see IPainter#paint(int)
     */
    public void paint(int reason) {
        if (!fIsActive) {
            fIsActive= true;
            fTextWidget.addPaintListener(this);
            if (fCachedWidgetX is -1)
                computeWidgetX();
            fTextWidget.redraw();
        } else if (CONFIGURATION is reason || INTERNAL is reason)
            fTextWidget.redraw();
    }

    /*
     * @see dwt.events.PaintListener#paintControl(dwt.events.PaintEvent)
     */
    public void paintControl(PaintEvent e) {
        if (fTextWidget !is null) {
            int x= fCachedWidgetX - fTextWidget.getHorizontalPixel();
            if (x >= 0) {
                Rectangle area= fTextWidget.getClientArea();
                e.gc.setForeground(fColor);
                e.gc.setLineStyle(fLineStyle);
                e.gc.setLineWidth(fLineWidth);
                e.gc.drawLine(x, 0, x, area.height);
            }
        }
    }

    /*
     * @see dwtx.jface.text.IPainter#setPositionManager(dwtx.jface.text.IPaintPositionManager)
     */
    public void setPositionManager(IPaintPositionManager manager) {
    }
}
