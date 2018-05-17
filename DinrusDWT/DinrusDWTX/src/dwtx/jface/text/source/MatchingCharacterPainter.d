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
module dwtx.jface.text.source.MatchingCharacterPainter;

import dwtx.jface.text.source.ISharedTextColors; // packageimport
import dwtx.jface.text.source.ILineRange; // packageimport
import dwtx.jface.text.source.IAnnotationPresentation; // packageimport
import dwtx.jface.text.source.IVerticalRulerInfoExtension; // packageimport
import dwtx.jface.text.source.ICharacterPairMatcher; // packageimport
import dwtx.jface.text.source.TextInvocationContext; // packageimport
import dwtx.jface.text.source.LineChangeHover; // packageimport
import dwtx.jface.text.source.IChangeRulerColumn; // packageimport
import dwtx.jface.text.source.IAnnotationMap; // packageimport
import dwtx.jface.text.source.IAnnotationModelListenerExtension; // packageimport
import dwtx.jface.text.source.ISourceViewerExtension2; // packageimport
import dwtx.jface.text.source.IAnnotationHover; // packageimport
import dwtx.jface.text.source.ContentAssistantFacade; // packageimport
import dwtx.jface.text.source.IAnnotationAccess; // packageimport
import dwtx.jface.text.source.IVerticalRulerExtension; // packageimport
import dwtx.jface.text.source.IVerticalRulerColumn; // packageimport
import dwtx.jface.text.source.LineNumberRulerColumn; // packageimport
import dwtx.jface.text.source.IAnnotationModelExtension; // packageimport
import dwtx.jface.text.source.ILineDifferExtension; // packageimport
import dwtx.jface.text.source.DefaultCharacterPairMatcher; // packageimport
import dwtx.jface.text.source.LineNumberChangeRulerColumn; // packageimport
import dwtx.jface.text.source.IAnnotationAccessExtension; // packageimport
import dwtx.jface.text.source.ISourceViewer; // packageimport
import dwtx.jface.text.source.AnnotationModel; // packageimport
import dwtx.jface.text.source.ILineDifferExtension2; // packageimport
import dwtx.jface.text.source.IAnnotationModelListener; // packageimport
import dwtx.jface.text.source.IVerticalRuler; // packageimport
import dwtx.jface.text.source.DefaultAnnotationHover; // packageimport
import dwtx.jface.text.source.SourceViewer; // packageimport
import dwtx.jface.text.source.SourceViewerConfiguration; // packageimport
import dwtx.jface.text.source.AnnotationBarHoverManager; // packageimport
import dwtx.jface.text.source.CompositeRuler; // packageimport
import dwtx.jface.text.source.ImageUtilities; // packageimport
import dwtx.jface.text.source.VisualAnnotationModel; // packageimport
import dwtx.jface.text.source.IAnnotationModel; // packageimport
import dwtx.jface.text.source.ISourceViewerExtension3; // packageimport
import dwtx.jface.text.source.ILineDiffInfo; // packageimport
import dwtx.jface.text.source.VerticalRulerEvent; // packageimport
import dwtx.jface.text.source.ChangeRulerColumn; // packageimport
import dwtx.jface.text.source.ILineDiffer; // packageimport
import dwtx.jface.text.source.AnnotationModelEvent; // packageimport
import dwtx.jface.text.source.AnnotationColumn; // packageimport
import dwtx.jface.text.source.AnnotationRulerColumn; // packageimport
import dwtx.jface.text.source.IAnnotationHoverExtension; // packageimport
import dwtx.jface.text.source.AbstractRulerColumn; // packageimport
import dwtx.jface.text.source.ISourceViewerExtension; // packageimport
import dwtx.jface.text.source.AnnotationMap; // packageimport
import dwtx.jface.text.source.IVerticalRulerInfo; // packageimport
import dwtx.jface.text.source.IAnnotationModelExtension2; // packageimport
import dwtx.jface.text.source.LineRange; // packageimport
import dwtx.jface.text.source.IAnnotationAccessExtension2; // packageimport
import dwtx.jface.text.source.VerticalRuler; // packageimport
import dwtx.jface.text.source.JFaceTextMessages; // packageimport
import dwtx.jface.text.source.IOverviewRuler; // packageimport
import dwtx.jface.text.source.Annotation; // packageimport
import dwtx.jface.text.source.IVerticalRulerListener; // packageimport
import dwtx.jface.text.source.ISourceViewerExtension4; // packageimport
import dwtx.jface.text.source.AnnotationPainter; // packageimport
import dwtx.jface.text.source.IAnnotationHoverExtension2; // packageimport
import dwtx.jface.text.source.OverviewRuler; // packageimport
import dwtx.jface.text.source.OverviewRulerHoverManager; // packageimport


import dwt.dwthelper.utils;




import dwt.custom.StyledText;
import dwt.events.PaintEvent;
import dwt.events.PaintListener;
import dwt.graphics.Color;
import dwt.graphics.GC;
import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwtx.jface.text.BadLocationException;
import dwtx.jface.text.IDocument;
import dwtx.jface.text.IPaintPositionManager;
import dwtx.jface.text.IPainter;
import dwtx.jface.text.IRegion;
import dwtx.jface.text.ITextViewerExtension5;
import dwtx.jface.text.Position;
import dwtx.jface.text.Region;

/**
 * Highlights the peer character matching the character near the caret position.
 * This painter can be configured with an
 * {@link dwtx.jface.text.source.ICharacterPairMatcher}.
 * <p>
 * Clients instantiate and configure object of this class.</p>
 *
 * @since 2.1
 */
public final class MatchingCharacterPainter : IPainter, PaintListener {

    /** Indicates whether this painter is active */
    private bool fIsActive= false;
    /** The source viewer this painter is associated with */
    private ISourceViewer fSourceViewer;
    /** The viewer's widget */
    private StyledText fTextWidget;
    /** The color in which to highlight the peer character */
    private Color fColor;
    /** The paint position manager */
    private IPaintPositionManager fPaintPositionManager;
    /** The strategy for finding matching characters */
    private ICharacterPairMatcher fMatcher;
    /** The position tracking the matching characters */
    private Position fPairPosition;
    /** The anchor indicating whether the character is left or right of the caret */
    private int fAnchor;


    /**
     * Creates a new MatchingCharacterPainter for the given source viewer using
     * the given character pair matcher. The character matcher is not adopted by
     * this painter. Thus,  it is not disposed. However, this painter requires
     * exclusive access to the given pair matcher.
     *
     * @param sourceViewer
     * @param matcher
     */
    public this(ISourceViewer sourceViewer, ICharacterPairMatcher matcher) {
        fPairPosition= new Position(0, 0);
        fSourceViewer= sourceViewer;
        fMatcher= matcher;
        fTextWidget= sourceViewer.getTextWidget();
    }

    /**
     * Sets the color in which to highlight the match character.
     *
     * @param color the color
     */
    public void setColor(Color color) {
        fColor= color;
    }

    /*
     * @see dwtx.jface.text.IPainter#dispose()
     */
    public void dispose() {
        if (fMatcher !is null) {
            fMatcher.clear();
            fMatcher= null;
        }

        fColor= null;
        fTextWidget= null;
    }

    /*
     * @see dwtx.jface.text.IPainter#deactivate(bool)
     */
    public void deactivate(bool redraw) {
        if (fIsActive) {
            fIsActive= false;
            fTextWidget.removePaintListener(this);
            if (fPaintPositionManager !is null)
                fPaintPositionManager.unmanagePosition(fPairPosition);
            if (redraw)
                handleDrawRequest(null);
        }
    }

    /*
     * @see dwt.events.PaintListener#paintControl(dwt.events.PaintEvent)
     */
    public void paintControl(PaintEvent event) {
        if (fTextWidget !is null)
            handleDrawRequest(event.gc);
    }

    /**
     * Handles a redraw request.
     *
     * @param gc the GC to draw into.
     */
    private void handleDrawRequest(GC gc) {

        if (fPairPosition.isDeleted)
            return;

        int offset= fPairPosition.getOffset();
        int length= fPairPosition.getLength();
        if (length < 1)
            return;

        if ( cast(ITextViewerExtension5)fSourceViewer ) {
            ITextViewerExtension5 extension= cast(ITextViewerExtension5) fSourceViewer;
            IRegion widgetRange= extension.modelRange2WidgetRange(new Region(offset, length));
            if (widgetRange is null)
                return;

            try {
                // don't draw if the pair position is really hidden and widgetRange just
                // marks the coverage around it.
                IDocument doc= fSourceViewer.getDocument();
                int startLine= doc.getLineOfOffset(offset);
                int endLine= doc.getLineOfOffset(offset + length);
                if (extension.modelLine2WidgetLine(startLine) is -1 || extension.modelLine2WidgetLine(endLine) is -1)
                    return;
            } catch (BadLocationException e) {
                return;
            }

            offset= widgetRange.getOffset();
            length= widgetRange.getLength();

        } else {
            IRegion region= fSourceViewer.getVisibleRegion();
            if (region.getOffset() > offset || region.getOffset() + region.getLength() < offset + length)
                return;
            offset -= region.getOffset();
        }

        if (ICharacterPairMatcher.RIGHT is fAnchor)
            draw(gc, offset, 1);
        else
            draw(gc, offset + length -1, 1);
    }

    /**
     * Highlights the given widget region.
     *
     * @param gc the GC to draw into
     * @param offset the offset of the widget region
     * @param length the length of the widget region
     */
    private void draw(GC gc, int offset, int length) {
        if (gc !is null) {

            gc.setForeground(fColor);

            Rectangle bounds;
            if (length > 0)
                bounds= fTextWidget.getTextBounds(offset, offset + length - 1);
            else {
                Point loc= fTextWidget.getLocationAtOffset(offset);
                bounds= new Rectangle(loc.x, loc.y, 1, fTextWidget.getLineHeight(offset));
            }

            // draw box around line segment
            gc.drawRectangle(bounds.x, bounds.y, bounds.width - 1, bounds.height - 1);

            // draw box around character area
//          int widgetBaseline= fTextWidget.getBaseline();
//          FontMetrics fm= gc.getFontMetrics();
//          int fontBaseline= fm.getAscent() + fm.getLeading();
//          int fontBias= widgetBaseline - fontBaseline;

//          gc.drawRectangle(left.x, left.y + fontBias, right.x - left.x - 1, fm.getHeight() - 1);

        } else {
            fTextWidget.redrawRange(offset, length, true);
        }
    }

    /*
     * @see dwtx.jface.text.IPainter#paint(int)
     */
    public void paint(int reason) {

        IDocument document= fSourceViewer.getDocument();
        if (document is null) {
            deactivate(false);
            return;
        }

        Point selection= fSourceViewer.getSelectedRange();
        if (selection.y > 0) {
            deactivate(true);
            return;
        }

        IRegion pair= fMatcher.match(document, selection.x);
        if (pair is null) {
            deactivate(true);
            return;
        }

        if (fIsActive) {

            if (IPainter.CONFIGURATION is reason) {

                // redraw current highlighting
                handleDrawRequest(null);

            } else if (pair.getOffset() !is fPairPosition.getOffset() ||
                    pair.getLength() !is fPairPosition.getLength() ||
                    fMatcher.getAnchor() !is fAnchor) {

                // otherwise only do something if position is different

                // remove old highlighting
                handleDrawRequest(null);
                // update position
                fPairPosition.isDeleted_= false;
                fPairPosition.offset= pair.getOffset();
                fPairPosition.length= pair.getLength();
                fAnchor= fMatcher.getAnchor();
                // apply new highlighting
                handleDrawRequest(null);

            }
        } else {

            fIsActive= true;

            fPairPosition.isDeleted_= false;
            fPairPosition.offset= pair.getOffset();
            fPairPosition.length= pair.getLength();
            fAnchor= fMatcher.getAnchor();

            fTextWidget.addPaintListener(this);
            fPaintPositionManager.managePosition(fPairPosition);
            handleDrawRequest(null);
        }
    }

    /*
     * @see dwtx.jface.text.IPainter#setPositionManager(dwtx.jface.text.IPaintPositionManager)
     */
    public void setPositionManager(IPaintPositionManager manager) {
        fPaintPositionManager= manager;
    }
}
