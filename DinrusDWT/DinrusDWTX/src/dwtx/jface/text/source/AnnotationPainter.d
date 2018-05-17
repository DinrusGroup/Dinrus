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
module dwtx.jface.text.source.AnnotationPainter;

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
import dwtx.jface.text.source.MatchingCharacterPainter; // packageimport
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
import dwtx.jface.text.source.IAnnotationHoverExtension2; // packageimport
import dwtx.jface.text.source.OverviewRuler; // packageimport
import dwtx.jface.text.source.OverviewRulerHoverManager; // packageimport

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;
import tango.text.convert.Format;
import tango.io.Stdout;

import dwt.DWT;
import dwt.DWTException;
import dwt.custom.StyleRange;
import dwt.custom.StyledText;
import dwt.events.PaintEvent;
import dwt.events.PaintListener;
import dwt.graphics.Color;
import dwt.graphics.GC;
import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwt.graphics.TextStyle;
import dwt.widgets.Display;
import dwtx.core.runtime.Assert;
import dwtx.core.runtime.Platform;
import dwtx.jface.text.BadLocationException;
import dwtx.jface.text.IDocument;
import dwtx.jface.text.IPaintPositionManager;
import dwtx.jface.text.IPainter;
import dwtx.jface.text.IRegion;
import dwtx.jface.text.ITextInputListener;
import dwtx.jface.text.ITextPresentationListener;
import dwtx.jface.text.ITextViewerExtension2;
import dwtx.jface.text.ITextViewerExtension5;
import dwtx.jface.text.JFaceTextUtil;
import dwtx.jface.text.Position;
import dwtx.jface.text.Region;
import dwtx.jface.text.TextPresentation;


    /**
     * A drawing strategy draws the decoration for an annotation onto the text widget.
     *
     * @since 3.0
     */
    public interface IDrawingStrategy {
        /**
         * Draws a decoration for an annotation onto the specified GC at the given text range. There
         * are two different invocation modes of the <code>draw</code> method:
         * <ul>
         * <li><strong>drawing mode:</strong> the passed GC is the graphics context of a paint
         * event occurring on the text widget. The strategy should draw the decoration onto the
         * graphics context, such that the decoration appears at the given range in the text
         * widget.</li>
         * <li><strong>clearing mode:</strong> the passed GC is <code>null</code>. In this case
         * the strategy must invalidate enough of the text widget's client area to cover any
         * decoration drawn in drawing mode. This can usually be accomplished by calling
         * {@linkplain StyledText#redrawRange(int, int, bool) textWidget.redrawRange(offset, length, true)}.</li>
         * </ul>
         *
         * @param annotation the annotation to be drawn
         * @param gc the graphics context, <code>null</code> when in clearing mode
         * @param textWidget the text widget to draw on
         * @param offset the offset of the line
         * @param length the length of the line
         * @param color the color of the line
         */
        void draw(Annotation annotation, GC gc, StyledText textWidget, int offset, int length, Color color);
    }

    alias IDrawingStrategy AnnotationPainter_IDrawingStrategy;

/**
 * Paints decorations for annotations provided by an annotation model and/or
 * highlights them in the associated source viewer.
 * <p>
 * The annotation painter can be configured with drawing strategies. A drawing
 * strategy defines the visual presentation of a particular type of annotation
 * decoration.</p>
 * <p>
 * Clients usually instantiate and configure objects of this class.</p>
 *
 * @since 2.1
 */
public class AnnotationPainter : IPainter, PaintListener, IAnnotationModelListener, IAnnotationModelListenerExtension, ITextPresentationListener {

    /**
     * Squiggles drawing strategy.
     *
     * @since 3.0
     * @deprecated As of 3.4, replaced by {@link AnnotationPainter.UnderlineStrategy}
     */
    public static class SquigglesStrategy : IDrawingStrategy {

        /*
         * @see dwtx.jface.text.source.AnnotationPainter.IDrawingStrategy#draw(dwtx.jface.text.source.Annotation, dwt.graphics.GC, dwt.custom.StyledText, int, int, dwt.graphics.Color)
         * @since 3.0
         */
        public void draw(Annotation annotation, GC gc, StyledText textWidget, int offset, int length, Color color) {
            if (gc !is null) {

                if (length < 1)
                    return;

                Point left= textWidget.getLocationAtOffset(offset);
                Point right= textWidget.getLocationAtOffset(offset + length);
                Rectangle rect= textWidget.getTextBounds(offset, offset + length - 1);
                left.x= rect.x;
                right.x= rect.x + rect.width;

                int[] polyline= computePolyline(left, right, textWidget.getBaseline(offset), textWidget.getLineHeight(offset));

                gc.setLineWidth(0); // NOTE: 0 means width is 1 but with optimized performance
                gc.setLineStyle(DWT.LINE_SOLID);
                gc.setForeground(color);
                gc.drawPolyline(polyline);

            } else {
                textWidget.redrawRange(offset, length, true);
            }
        }

        /**
         * Computes an array of alternating x and y values which are the corners of the squiggly line of the
         * given height between the given end points.
         *
         * @param left the left end point
         * @param right the right end point
         * @param baseline the font's baseline
         * @param lineHeight the height of the line
         * @return the array of alternating x and y values which are the corners of the squiggly line
         */
        private int[] computePolyline(Point left, Point right, int baseline, int lineHeight) {

            final int WIDTH= 4; // must be even
            final int HEIGHT= 2; // can be any number

            int peaks= (right.x - left.x) / WIDTH;
            if (peaks is 0 && right.x - left.x > 2)
                peaks= 1;

            int leftX= left.x;

            // compute (number of point) * 2
            int length_= ((2 * peaks) + 1) * 2;
            if (length_ < 0)
                return new int[0];

            int[] coordinates= new int[length_];

            // cache peeks' y-coordinates
            int top= left.y + Math.min(baseline + 1, lineHeight - HEIGHT - 1);
            int bottom= top + HEIGHT;

            // populate array with peek coordinates
            for (int i= 0; i < peaks; i++) {
                int index= 4 * i;
                coordinates[index]= leftX + (WIDTH * i);
                coordinates[index+1]= bottom;
                coordinates[index+2]= coordinates[index] + WIDTH/2;
                coordinates[index+3]= top;
            }

            // the last down flank is missing
            coordinates[length_-2]= Math.min(Math.max(0, right.x - 1), left.x + (WIDTH * peaks));
            coordinates[length_-1]= bottom;

            return coordinates;
        }
    }

    /**
     * Drawing strategy that does nothing.
     *
     * @since 3.0
     */
    public static final class NullStrategy : IDrawingStrategy {

        /*
         * @see dwtx.jface.text.source.AnnotationPainter.IDrawingStrategy#draw(dwtx.jface.text.source.Annotation, dwt.graphics.GC, dwt.custom.StyledText, int, int, dwt.graphics.Color)
         * @since 3.0
         */
        public void draw(Annotation annotation, GC gc, StyledText textWidget, int offset, int length, Color color) {
            // do nothing
        }
    }


    /**
     * A text style painting strategy draws the decoration for an annotation
     * onto the text widget by applying a {@link TextStyle} on a given
     * {@link StyleRange}.
     *
     * @since 3.4
     */
    public interface ITextStyleStrategy {

        /**
         * Applies a text style on the given <code>StyleRange</code>.
         *
         * @param styleRange the style range on which to apply the text style
         * @param annotationColor the color of the annotation
         */
        void applyTextStyle(StyleRange styleRange, Color annotationColor);
    }


    /**
     * @since 3.4
     */
    public static final class HighlightingStrategy : ITextStyleStrategy {
        public void applyTextStyle(StyleRange styleRange, Color annotationColor) {
            styleRange.background= annotationColor;
        }
    }


    /**
     * Underline text style strategy.
     *
     * @since 3.4
     */
    public static final class UnderlineStrategy : ITextStyleStrategy {

        int fUnderlineStyle;

        public this(int style) {
            Assert.isLegal(style is DWT.UNDERLINE_SINGLE || style is DWT.UNDERLINE_DOUBLE || style is DWT.UNDERLINE_ERROR || style is DWT.UNDERLINE_SQUIGGLE);
            fUnderlineStyle= style;
        }

        public void applyTextStyle(StyleRange styleRange, Color annotationColor) {
            styleRange.underline= true;
            styleRange.underlineStyle= fUnderlineStyle;
            styleRange.underlineColor= annotationColor;
        }
    }


    /**
     * Box text style strategy.
     *
     * @since 3.4
     */
    public static final class BoxStrategy : ITextStyleStrategy {

        int fBorderStyle;

        public this(int style) {
            Assert.isLegal(style is DWT.BORDER_DASH || style is DWT.BORDER_DASH || style is DWT.BORDER_SOLID);
            fBorderStyle= style;
        }

        public void applyTextStyle(StyleRange styleRange, Color annotationColor) {
            styleRange.borderStyle= fBorderStyle;
            styleRange.borderColor= annotationColor;
        }
    }


    /**
     * Implementation of <code>IRegion</code> that can be reused
     * by setting the offset and the length.
     */
    private static class ReusableRegion : Position , IRegion {
        public override int getOffset(){
            return super.getOffset();
        }
        public override int getLength(){
            return super.getLength();
        }
    }

    /**
     * Tells whether this class is in debug mode.
     * @since 3.0
     */
    private static bool DEBUG_;
    private static bool DEBUG_init = false;
    private static bool DEBUG(){
        if( !DEBUG_init ){
            DEBUG_init = true;
            DEBUG_ = "true".equalsIgnoreCase(Platform.getDebugOption("dwtx.jface.text/debug/AnnotationPainter"));  //$NON-NLS-1$//$NON-NLS-2$
        }
        return DEBUG_;
    }

    /**
     * The squiggly painter strategy.
     * @since 3.0
     */
    private static IDrawingStrategy SQUIGGLES_STRATEGY_;
    private static IDrawingStrategy SQUIGGLES_STRATEGY(){
        if( SQUIGGLES_STRATEGY_ is null ){
            synchronized( AnnotationPainter.classinfo ){
                if( SQUIGGLES_STRATEGY_ is null ){
                    SQUIGGLES_STRATEGY_ = new SquigglesStrategy();
                }
            }
        }
        return SQUIGGLES_STRATEGY_;
    }


    /**
     * This strategy is used to mark the <code>null</code> value in the chache
     * maps.
     *
     * @since 3.4
     */
    private static IDrawingStrategy NULL_STRATEGY_;
    private static IDrawingStrategy NULL_STRATEGY(){
        if( NULL_STRATEGY_ is null ){
            synchronized( AnnotationPainter.classinfo ){
                if( NULL_STRATEGY_ is null ){
                    NULL_STRATEGY_= new NullStrategy();
                }
            }
        }
        return NULL_STRATEGY_;
    }
    /**
     * The squiggles painter id.
     * @since 3.0
     */
    private static Object SQUIGGLES_;
    private static Object SQUIGGLES(){
        if( SQUIGGLES_ is null ){
            synchronized( AnnotationPainter.classinfo ){
                if( SQUIGGLES_ is null ){
                    SQUIGGLES_= new Object();
                }
            }
        }
        return SQUIGGLES_;
    }
    /**
     * The squiggly painter strategy.
     *
     * @since 3.4
     */
    private static ITextStyleStrategy HIGHLIGHTING_STRATEGY_;
    private static ITextStyleStrategy HIGHLIGHTING_STRATEGY(){
        if( HIGHLIGHTING_STRATEGY_ is null ){
            synchronized( AnnotationPainter.classinfo ){
                if( HIGHLIGHTING_STRATEGY_ is null ){
                    HIGHLIGHTING_STRATEGY_= new HighlightingStrategy();
                }
            }
        }
        return HIGHLIGHTING_STRATEGY_;
    }

    /**
     * The highlighting text style strategy id.
     *
     * @since 3.4
     */
    private static Object HIGHLIGHTING_;
    private static Object HIGHLIGHTING(){
        if( HIGHLIGHTING_ is null ){
            synchronized( AnnotationPainter.classinfo ){
                if( HIGHLIGHTING_ is null ){
                    HIGHLIGHTING_= new Object();
                }
            }
        }
        return HIGHLIGHTING_;
    }

    /**
     * The presentation information (decoration) for an annotation.  Each such
     * object represents one decoration drawn on the text area, such as squiggly lines
     * and underlines.
     */
    private static class Decoration {
        /** The position of this decoration */
        private Position fPosition;
        /** The color of this decoration */
        private Color fColor;
        /**
         * The annotation's layer
         * @since 3.0
         */
        private int fLayer;
        /**
         * The painting strategy for this decoration.
         * @since 3.0
         */
        private Object fPaintingStrategy;
    }


    /** Indicates whether this painter is active */
    private bool fIsActive= false;
    /** Indicates whether this painter is managing decorations */
    private bool fIsPainting= false;
    /** Indicates whether this painter is setting its annotation model */
    private /+volatile+/ bool  fIsSettingModel= false;
    /** The associated source viewer */
    private ISourceViewer fSourceViewer;
    /** The cached widget of the source viewer */
    private StyledText fTextWidget;
    /** The annotation model providing the annotations to be drawn */
    private IAnnotationModel fModel;
    /** The annotation access */
    private IAnnotationAccess fAnnotationAccess;
    /**
     * The map with decorations
     * @since 3.0
     */
    private Map fDecorationsMap; // see https://bugs.eclipse.org/bugs/show_bug.cgi?id=50767
    /**
     * The map with of highlighted decorations.
     * @since 3.0
     */
    private Map fHighlightedDecorationsMap;
    /**
     * Mutex for highlighted decorations map.
     * @since 3.0
     */
    private Object fDecorationMapLock;
    /**
     * Mutex for for decorations map.
     * @since 3.0
     */
    private Object fHighlightedDecorationsMapLock;
    /**
     * Maps an annotation type to its registered color.
     *
     * @see #setAnnotationTypeColor(Object, Color)
     */
    private Map fAnnotationType2Color;

    /**
     * Cache that maps the annotation type to its color.
     * @since 3.4
     */
    private Map fCachedAnnotationType2Color;
    /**
     * The range in which the current highlight annotations can be found.
     * @since 3.0
     */
    private Position fCurrentHighlightAnnotationRange= null;
    /**
     * The range in which all added, removed and changed highlight
     * annotations can be found since the last world change.
     * @since 3.0
     */
    private Position fTotalHighlightAnnotationRange= null;
    /**
     * The range in which the currently drawn annotations can be found.
     * @since 3.3
     */
    private Position fCurrentDrawRange= null;
    /**
     * The range in which all added, removed and changed drawn
     * annotations can be found since the last world change.
     * @since 3.3
     */
    private Position fTotalDrawRange= null;
    /**
     * The text input listener.
     * @since 3.0
     */
    private ITextInputListener fTextInputListener;
    /**
     * Flag which tells that a new document input is currently being set.
     * @since 3.0
     */
    private bool fInputDocumentAboutToBeChanged;
    /**
     * Maps annotation types to painting strategy identifiers.
     *
     * @see #addAnnotationType(Object, Object)
     * @since 3.0
     */
    private Map fAnnotationType2PaintingStrategyId;
    /**
     * Maps annotation types to painting strategy identifiers.
     * @since 3.4
     */
    private Map fCachedAnnotationType2PaintingStrategy;

    /**
     * Maps painting strategy identifiers to painting strategies.
     *
     * @since 3.0
     */
    private Map fPaintingStrategyId2PaintingStrategy;

    /**
     * Reuse this region for performance reasons.
     * @since 3.3
     */
    private ReusableRegion fReusableRegion;

    /**
     * Creates a new annotation painter for the given source viewer and with the
     * given annotation access. The painter is not initialized, i.e. no
     * annotation types are configured to be painted.
     *
     * @param sourceViewer the source viewer for this painter
     * @param access the annotation access for this painter
     */
    public this(ISourceViewer sourceViewer, IAnnotationAccess access) {
        fDecorationsMap= new HashMap(); // see https://bugs.eclipse.org/bugs/show_bug.cgi?id=50767
        fHighlightedDecorationsMap= new HashMap(); // see https://bugs.eclipse.org/bugs/show_bug.cgi?id=50767
        fDecorationMapLock= new Object();
        fHighlightedDecorationsMapLock= new Object();
        fAnnotationType2Color= new HashMap();
        fCachedAnnotationType2Color= new HashMap();
        fReusableRegion= new ReusableRegion();
        fAnnotationType2PaintingStrategyId= new HashMap();
        fCachedAnnotationType2PaintingStrategy= new HashMap();
        fPaintingStrategyId2PaintingStrategy= new HashMap();

        fSourceViewer= sourceViewer;
        fAnnotationAccess= access;
        fTextWidget= sourceViewer.getTextWidget();

        // default drawing strategies: squiggles were the only decoration style before version 3.0
        fPaintingStrategyId2PaintingStrategy.put(SQUIGGLES, cast(Object)SQUIGGLES_STRATEGY);
        fPaintingStrategyId2PaintingStrategy.put(HIGHLIGHTING, cast(Object)HIGHLIGHTING_STRATEGY);
    }

    /**
     * Returns whether this painter has to draw any squiggles.
     *
     * @return <code>true</code> if there are squiggles to be drawn, <code>false</code> otherwise
     */
    private bool hasDecorations() {
        synchronized (fDecorationMapLock) {
            return !fDecorationsMap.isEmpty();
        }
    }

    /**
     * Enables painting. This painter registers a paint listener with the
     * source viewer's widget.
     */
    private void enablePainting() {
        if (!fIsPainting && hasDecorations()) {
            fIsPainting= true;
            fTextWidget.addPaintListener(this);
            handleDrawRequest(null);
        }
    }

    /**
     * Disables painting, if is has previously been enabled. Removes
     * any paint listeners registered with the source viewer's widget.
     *
     * @param redraw <code>true</code> if the widget should be redrawn after disabling
     */
    private void disablePainting(bool redraw) {
        if (fIsPainting) {
            fIsPainting= false;
            fTextWidget.removePaintListener(this);
            if (redraw && hasDecorations())
                handleDrawRequest(null);
        }
    }

    /**
     * Sets the annotation model for this painter. Registers this painter
     * as listener of the give model, if the model is not <code>null</code>.
     *
     * @param model the annotation model
     */
    private void setModel(IAnnotationModel model) {
        if (fModel !is model) {
            if (fModel !is null)
                fModel.removeAnnotationModelListener(this);
            fModel= model;
            if (fModel !is null) {
                try {
                    fIsSettingModel= true;
                    fModel.addAnnotationModelListener(this);
                } finally {
                    fIsSettingModel= false;
                }
            }
        }
    }

    /**
     * Updates the set of decorations based on the current state of
     * the painter's annotation model.
     *
     * @param event the annotation model event
     */
    private void catchupWithModel(AnnotationModelEvent event) {

        synchronized (fDecorationMapLock) {
            if (fDecorationsMap is null)
                return;
        }

        IRegion clippingRegion= computeClippingRegion(null, true);
        IDocument document= fSourceViewer.getDocument();

        int highlightAnnotationRangeStart= Integer.MAX_VALUE;
        int highlightAnnotationRangeEnd= -1;

        int drawRangeStart= Integer.MAX_VALUE;
        int drawRangeEnd= -1;

        if (fModel !is null) {

            Map decorationsMap;
            Map highlightedDecorationsMap;

            // Clone decoration maps
            synchronized (fDecorationMapLock) {
                decorationsMap= new HashMap(fDecorationsMap);
            }
            synchronized (fHighlightedDecorationsMapLock) {
                highlightedDecorationsMap= new HashMap(fHighlightedDecorationsMap);
            }

            bool isWorldChange= false;

            Iterator e;
            if (event is null || event.isWorldChange()) {
                isWorldChange= true;

                if (DEBUG && event is null)
                    System.out_.println("AP: INTERNAL CHANGE"); //$NON-NLS-1$

                Iterator iter= decorationsMap.entrySet().iterator();
                while (iter.hasNext()) {
                    Map.Entry entry= cast(Map.Entry)iter.next();
                    Annotation annotation= cast(Annotation)entry.getKey();
                    Decoration decoration= cast(Decoration)entry.getValue();
                    drawDecoration(decoration, null, annotation, clippingRegion, document);
                }

                decorationsMap.clear();

                highlightedDecorationsMap.clear();

                e= fModel.getAnnotationIterator();


            } else {

                // Remove annotations
                Annotation[] removedAnnotations= event.getRemovedAnnotations();
                for (int i=0, length= removedAnnotations.length; i < length; i++) {
                    Annotation annotation= removedAnnotations[i];
                    Decoration decoration= cast(Decoration)highlightedDecorationsMap.remove(annotation);
                    if (decoration !is null) {
                        Position position= decoration.fPosition;
                        if (position !is null) {
                            highlightAnnotationRangeStart= Math.min(highlightAnnotationRangeStart, position.offset);
                            highlightAnnotationRangeEnd= Math.max(highlightAnnotationRangeEnd, position.offset + position.length);
                        }
                    }
                    decoration= cast(Decoration)decorationsMap.remove(annotation);
                    if (decoration !is null) {
                        drawDecoration(decoration, null, annotation, clippingRegion, document);
                        Position position= decoration.fPosition;
                        if (position !is null) {
                            drawRangeStart= Math.min(drawRangeStart, position.offset);
                            drawRangeEnd= Math.max(drawRangeEnd, position.offset + position.length);
                        }
                    }

                }

                // Update existing annotations
                Annotation[] changedAnnotations= event.getChangedAnnotations();
                for (int i=0, length= changedAnnotations.length; i < length; i++) {
                    Annotation annotation= changedAnnotations[i];

                    bool isHighlighting= false;

                    Decoration decoration= cast(Decoration)highlightedDecorationsMap.get(annotation);

                    if (decoration !is null) {
                        isHighlighting= true;
                        // The call below updates the decoration - no need to create new decoration
                        decoration= getDecoration(annotation, decoration);
                        if (decoration is null)
                            highlightedDecorationsMap.remove(annotation);
                    } else {
                        decoration= getDecoration(annotation, decoration);
                        if (decoration !is null && cast(ITextStyleStrategy)decoration.fPaintingStrategy ) {
                            highlightedDecorationsMap.put(annotation, decoration);
                            isHighlighting= true;
                        }
                    }

                    bool usesDrawingStrategy= !isHighlighting && decoration !is null;

                    Position position= null;
                    if (decoration is null)
                        position= fModel.getPosition(annotation);
                    else
                        position= decoration.fPosition;

                    if (position !is null && !position.isDeleted()) {
                        if (isHighlighting) {
                            highlightAnnotationRangeStart= Math.min(highlightAnnotationRangeStart, position.offset);
                            highlightAnnotationRangeEnd= Math.max(highlightAnnotationRangeEnd, position.offset + position.length);
                        }
                        if (usesDrawingStrategy) {
                            drawRangeStart= Math.min(drawRangeStart, position.offset);
                            drawRangeEnd= Math.max(drawRangeEnd, position.offset + position.length);
                        }
                    } else {
                        highlightedDecorationsMap.remove(annotation);
                    }

                    if (usesDrawingStrategy) {
                        Decoration oldDecoration= cast(Decoration)decorationsMap.get(annotation);
                        if (oldDecoration !is null) {
                            drawDecoration(oldDecoration, null, annotation, clippingRegion, document);

                        if (decoration !is null)
                            decorationsMap.put(annotation, decoration);
                        else if (oldDecoration !is null)
                            decorationsMap.remove(annotation);
                        }
                    }
                }

                e= Arrays.asList(event.getAddedAnnotations()).iterator();
            }

            // Add new annotations
            while (e.hasNext()) {
                Annotation annotation= cast(Annotation) e.next();
                Decoration pp= getDecoration(annotation, null);
                if (pp !is null) {
                    if (cast(IDrawingStrategy)pp.fPaintingStrategy ) {
                        decorationsMap.put(annotation, pp);
                        drawRangeStart= Math.min(drawRangeStart, pp.fPosition.offset);
                        drawRangeEnd= Math.max(drawRangeEnd, pp.fPosition.offset + pp.fPosition.length);
                    } else if (cast(ITextStyleStrategy)pp.fPaintingStrategy ) {
                        highlightedDecorationsMap.put(annotation, pp);
                        highlightAnnotationRangeStart= Math.min(highlightAnnotationRangeStart, pp.fPosition.offset);
                        highlightAnnotationRangeEnd= Math.max(highlightAnnotationRangeEnd, pp.fPosition.offset + pp.fPosition.length);
                    }

                }
            }

            synchronized (fDecorationMapLock) {
                fDecorationsMap= decorationsMap;
                updateDrawRanges(drawRangeStart, drawRangeEnd, isWorldChange);
            }

            synchronized (fHighlightedDecorationsMapLock) {
                fHighlightedDecorationsMap= highlightedDecorationsMap;
                updateHighlightRanges(highlightAnnotationRangeStart, highlightAnnotationRangeEnd, isWorldChange);
            }
        } else {
            // annotation model is null -> clear all
            synchronized (fDecorationMapLock) {
                fDecorationsMap.clear();
            }
            synchronized (fHighlightedDecorationsMapLock) {
                fHighlightedDecorationsMap.clear();
            }
        }
    }

    /**
     * Updates the remembered highlight ranges.
     *
     * @param highlightAnnotationRangeStart the start of the range
     * @param highlightAnnotationRangeEnd   the end of the range
     * @param isWorldChange                 tells whether the range belongs to a annotation model event reporting a world change
     * @since 3.0
     */
    private void updateHighlightRanges(int highlightAnnotationRangeStart, int highlightAnnotationRangeEnd, bool isWorldChange) {
        if (highlightAnnotationRangeStart !is Integer.MAX_VALUE) {

            int maxRangeStart= highlightAnnotationRangeStart;
            int maxRangeEnd= highlightAnnotationRangeEnd;

            if (fTotalHighlightAnnotationRange !is null) {
                maxRangeStart= Math.min(maxRangeStart, fTotalHighlightAnnotationRange.offset);
                maxRangeEnd= Math.max(maxRangeEnd, fTotalHighlightAnnotationRange.offset + fTotalHighlightAnnotationRange.length);
            }

            if (fTotalHighlightAnnotationRange is null)
                fTotalHighlightAnnotationRange= new Position(0);
            if (fCurrentHighlightAnnotationRange is null)
                fCurrentHighlightAnnotationRange= new Position(0);

            if (isWorldChange) {
                fTotalHighlightAnnotationRange.offset= highlightAnnotationRangeStart;
                fTotalHighlightAnnotationRange.length= highlightAnnotationRangeEnd - highlightAnnotationRangeStart;
                fCurrentHighlightAnnotationRange.offset= maxRangeStart;
                fCurrentHighlightAnnotationRange.length= maxRangeEnd - maxRangeStart;
            } else {
                fTotalHighlightAnnotationRange.offset= maxRangeStart;
                fTotalHighlightAnnotationRange.length= maxRangeEnd - maxRangeStart;
                fCurrentHighlightAnnotationRange.offset=highlightAnnotationRangeStart;
                fCurrentHighlightAnnotationRange.length= highlightAnnotationRangeEnd - highlightAnnotationRangeStart;
            }
        } else {
            if (isWorldChange) {
                fCurrentHighlightAnnotationRange= fTotalHighlightAnnotationRange;
                fTotalHighlightAnnotationRange= null;
            } else {
                fCurrentHighlightAnnotationRange= null;
            }
        }

        adaptToDocumentLength(fCurrentHighlightAnnotationRange);
        adaptToDocumentLength(fTotalHighlightAnnotationRange);
    }

    /**
     * Updates the remembered decoration ranges.
     *
     * @param drawRangeStart    the start of the range
     * @param drawRangeEnd      the end of the range
     * @param isWorldChange     tells whether the range belongs to a annotation model event reporting a world change
     * @since 3.3
     */
    private void updateDrawRanges(int drawRangeStart, int drawRangeEnd, bool isWorldChange) {
        if (drawRangeStart !is Integer.MAX_VALUE) {

            int maxRangeStart= drawRangeStart;
            int maxRangeEnd= drawRangeEnd;

            if (fTotalDrawRange !is null) {
                maxRangeStart= Math.min(maxRangeStart, fTotalDrawRange.offset);
                maxRangeEnd= Math.max(maxRangeEnd, fTotalDrawRange.offset + fTotalDrawRange.length);
            }

            if (fTotalDrawRange is null)
                fTotalDrawRange= new Position(0);
            if (fCurrentDrawRange is null)
                fCurrentDrawRange= new Position(0);

            if (isWorldChange) {
                fTotalDrawRange.offset= drawRangeStart;
                fTotalDrawRange.length= drawRangeEnd - drawRangeStart;
                fCurrentDrawRange.offset= maxRangeStart;
                fCurrentDrawRange.length= maxRangeEnd - maxRangeStart;
            } else {
                fTotalDrawRange.offset= maxRangeStart;
                fTotalDrawRange.length= maxRangeEnd - maxRangeStart;
                fCurrentDrawRange.offset=drawRangeStart;
                fCurrentDrawRange.length= drawRangeEnd - drawRangeStart;
            }
        } else {
            if (isWorldChange) {
                fCurrentDrawRange= fTotalDrawRange;
                fTotalDrawRange= null;
            } else {
                fCurrentDrawRange= null;
            }
        }

        adaptToDocumentLength(fCurrentDrawRange);
        adaptToDocumentLength(fTotalDrawRange);
    }

    /**
     * Adapts the given position to the document length.
     *
     * @param position the position to adapt
     * @since 3.0
     */
    private void adaptToDocumentLength(Position position) {
        if (position is null)
            return;

        int length= fSourceViewer.getDocument().getLength();
        position.offset= Math.min(position.offset, length);
        position.length= Math.min(position.length, length - position.offset);
    }

    /**
     * Returns a decoration for the given annotation if this
     * annotation is valid and shown by this painter.
     *
     * @param annotation            the annotation
     * @param decoration            the decoration to be adapted and returned or <code>null</code> if a new one must be created
     * @return the decoration or <code>null</code> if there's no valid one
     * @since 3.0
     */
    private Decoration getDecoration(Annotation annotation, Decoration decoration) {

        if (annotation.isMarkedDeleted())
            return null;

        String type= annotation.getType();

        Object paintingStrategy= getPaintingStrategy(type);
        if (paintingStrategy is null || cast(NullStrategy)paintingStrategy )
            return null;

        Color color= getColor(stringcast(type));
        if (color is null)
            return null;

        Position position= fModel.getPosition(annotation);
        if (position is null || position.isDeleted())
            return null;

        if (decoration is null)
            decoration= new Decoration();

        decoration.fPosition= position;
        decoration.fColor= color;
        if ( cast(IAnnotationAccessExtension)fAnnotationAccess ) {
            IAnnotationAccessExtension extension= cast(IAnnotationAccessExtension) fAnnotationAccess;
            decoration.fLayer= extension.getLayer(annotation);
        } else {
            decoration.fLayer= IAnnotationAccessExtension.DEFAULT_LAYER;
        }

        decoration.fPaintingStrategy= paintingStrategy;

        return decoration;
    }

    /**
     * Returns the painting strategy for the given annotation.
     *
     * @param type the annotation type
     * @return the annotation painter
     * @since 3.0
     */
    private Object getPaintingStrategy(String type) {
        Object strategy= fCachedAnnotationType2PaintingStrategy.get(type);
        if (strategy !is null)
            return strategy;

        strategy= fPaintingStrategyId2PaintingStrategy.get(fAnnotationType2PaintingStrategyId.get(type));
        if (strategy !is null) {
            fCachedAnnotationType2PaintingStrategy.put(type, strategy);
            return strategy;
        }

        if ( cast(IAnnotationAccessExtension)fAnnotationAccess ) {
            IAnnotationAccessExtension ext = cast(IAnnotationAccessExtension) fAnnotationAccess;
            Object[] sts = ext.getSupertypes(stringcast(type));
            for (int i= 0; i < sts.length; i++) {
                strategy= fPaintingStrategyId2PaintingStrategy.get(fAnnotationType2PaintingStrategyId.get(sts[i]));
                if (strategy !is null) {
                    fCachedAnnotationType2PaintingStrategy.put(type, strategy);
                    return strategy;
                }
            }
        }

        fCachedAnnotationType2PaintingStrategy.put(type, cast(Object)NULL_STRATEGY);
        return null;

    }

    /**
     * Returns the color for the given annotation type
     *
     * @param annotationType the annotation type
     * @return the color
     * @since 3.0
     */
    private Color getColor(Object annotationType) {
        Color color= cast(Color)fCachedAnnotationType2Color.get(annotationType);
        if (color !is null)
            return color;

        color= cast(Color)fAnnotationType2Color.get(annotationType);
        if (color !is null) {
            fCachedAnnotationType2Color.put(annotationType, color);
            return color;
        }

        if ( cast(IAnnotationAccessExtension)fAnnotationAccess ) {
            IAnnotationAccessExtension extension= cast(IAnnotationAccessExtension) fAnnotationAccess;
            Object[] superTypes= extension.getSupertypes(annotationType);
            if (superTypes !is null) {
                for (int i= 0; i < superTypes.length; i++) {
                    color= cast(Color)fAnnotationType2Color.get(superTypes[i]);
                    if (color !is null) {
                        fCachedAnnotationType2Color.put(annotationType, color);
                        return color;
                    }
                }
            }
        }

        return null;
    }

    /**
     * Recomputes the squiggles to be drawn and redraws them.
     *
     * @param event the annotation model event
     * @since 3.0
     */
    private void updatePainting(AnnotationModelEvent event) {
        disablePainting(event is null);

        catchupWithModel(event);

        if (!fInputDocumentAboutToBeChanged)
            invalidateTextPresentation();

        enablePainting();
    }

    private void invalidateTextPresentation() {
        IRegion r= null;
        synchronized (fHighlightedDecorationsMapLock) {
            if (fCurrentHighlightAnnotationRange !is null)
                r= new Region(fCurrentHighlightAnnotationRange.getOffset(), fCurrentHighlightAnnotationRange.getLength());
        }
        if (r is null)
            return;

        if ( cast(ITextViewerExtension2)fSourceViewer ) {
            if (DEBUG)
                System.out_.println(Format("AP: invalidating offset: {}, length= {}", r.getOffset(), r.getLength())); //$NON-NLS-1$ //$NON-NLS-2$

            (cast(ITextViewerExtension2)fSourceViewer).invalidateTextPresentation(r.getOffset(), r.getLength());

        } else {
            fSourceViewer.invalidateTextPresentation();
        }
    }

    /*
     * @see dwtx.jface.text.ITextPresentationListener#applyTextPresentation(dwtx.jface.text.TextPresentation)
     * @since 3.0
     */
    public void applyTextPresentation(TextPresentation tp) {
        Set decorations;

        synchronized (fHighlightedDecorationsMapLock) {
            if (fHighlightedDecorationsMap is null || fHighlightedDecorationsMap.isEmpty())
                return;

            decorations= new HashSet(fHighlightedDecorationsMap.entrySet());
        }

        IRegion region= tp.getExtent();

        if (DEBUG)
            System.out_.println(Format("AP: applying text presentation offset: {}, length= {}", region.getOffset(), region.getLength())); //$NON-NLS-1$ //$NON-NLS-2$

        for (int layer= 0, maxLayer= 1; layer < maxLayer; layer++) {

            for (Iterator iter= decorations.iterator(); iter.hasNext();) {
                Map.Entry entry= cast(Map.Entry)iter.next();

                Annotation a= cast(Annotation)entry.getKey();
                if (a.isMarkedDeleted())
                    continue;

                Decoration pp = cast(Decoration)entry.getValue();

                maxLayer= Math.max(maxLayer, pp.fLayer + 1); // dynamically update layer maximum
                if (pp.fLayer !is layer) // wrong layer: skip annotation
                    continue;

                Position p= pp.fPosition;
                if ( cast(ITextViewerExtension5)fSourceViewer ) {
                    ITextViewerExtension5 extension3= cast(ITextViewerExtension5) fSourceViewer;
                    if (null is extension3.modelRange2WidgetRange(new Region(p.getOffset(), p.getLength())))
                        continue;
                } else if (!fSourceViewer.overlapsWithVisibleRegion(p.offset, p.length)) {
                    continue;
                }

                int regionEnd= region.getOffset() + region.getLength();
                int pEnd= p.getOffset() + p.getLength();
                if (pEnd >= region.getOffset() && regionEnd > p.getOffset()) {
                    int start= Math.max(p.getOffset(), region.getOffset());
                    int end= Math.min(regionEnd, pEnd);
                    int length= Math.max(end - start, 0);
                    StyleRange styleRange= new StyleRange(start, length, null, null);
                    (cast(ITextStyleStrategy)pp.fPaintingStrategy).applyTextStyle(styleRange, pp.fColor);
                    tp.mergeStyleRange(styleRange);
                }
            }
        }
    }

    /*
     * @see dwtx.jface.text.source.IAnnotationModelListener#modelChanged(dwtx.jface.text.source.IAnnotationModel)
     */
    public synchronized void modelChanged(IAnnotationModel model) {
        if (DEBUG)
            System.err.println("AP: OLD API of AnnotationModelListener called"); //$NON-NLS-1$

        modelChanged(new AnnotationModelEvent(model));
    }

    /*
     * @see dwtx.jface.text.source.IAnnotationModelListenerExtension#modelChanged(dwtx.jface.text.source.AnnotationModelEvent)
     */
    public void modelChanged(AnnotationModelEvent event) {
        Display textWidgetDisplay;
        try {
            StyledText textWidget= fTextWidget;
            if (textWidget is null || textWidget.isDisposed())
                return;
            textWidgetDisplay= textWidget.getDisplay();
        } catch (DWTException ex) {
            if (ex.code is DWT.ERROR_WIDGET_DISPOSED)
                return;
            throw ex;
        }

        if (fIsSettingModel) {
            // inside the UI thread -> no need for posting
            if (textWidgetDisplay is Display.getCurrent())
                updatePainting(event);
            else {
                /*
                 * we can throw away the changes since
                 * further update painting will happen
                 */
                return;
            }
        } else {
            if (DEBUG && event !is null && event.isWorldChange()) {
                System.out_.println("AP: WORLD CHANGED, stack trace follows:"); //$NON-NLS-1$
                ExceptionPrintStackTrace( new Exception(""), Stdout );
            }

            // XXX: posting here is a problem for annotations that are being
            // removed and the positions of which are not updated to document
            // changes any more. If the document gets modified between
            // now and running the posted runnable, the position information
            // is not accurate any longer.
            textWidgetDisplay.asyncExec( dgRunnable( (AnnotationModelEvent event_){
                if (fTextWidget !is null && !fTextWidget.isDisposed())
                    updatePainting(event_);
            }, event ));
        }
    }

    /**
     * Sets the color in which the squiggly for the given annotation type should be drawn.
     *
     * @param annotationType the annotation type
     * @param color the color
     */
    public void setAnnotationTypeColor(Object annotationType, Color color) {
        if (color !is null)
            fAnnotationType2Color.put(annotationType, color);
        else
            fAnnotationType2Color.remove(annotationType);
        fCachedAnnotationType2Color.clear();
    }

    /**
     * Adds the given annotation type to the list of annotation types whose
     * annotations should be painted by this painter using squiggly drawing. If the annotation  type
     * is already in this list, this method is without effect.
     *
     * @param annotationType the annotation type
     */
    public void addAnnotationType(Object annotationType) {
        addAnnotationType(annotationType, SQUIGGLES);
    }

    /**
     * Adds the given annotation type to the list of annotation types whose
     * annotations should be painted by this painter using the given drawing strategy.
     * If the annotation type is already in this list, the old drawing strategy gets replaced.
     *
     * @param annotationType the annotation type
     * @param drawingStrategyID the id of the drawing strategy that should be used for this annotation type
     * @since 3.0
     */
    public void addAnnotationType(Object annotationType, Object drawingStrategyID) {
        fAnnotationType2PaintingStrategyId.put(annotationType, drawingStrategyID);
        fCachedAnnotationType2PaintingStrategy.clear();

        if (fTextInputListener is null) {
            fTextInputListener= new class()  ITextInputListener {

                /*
                 * @see dwtx.jface.text.ITextInputListener#inputDocumentAboutToBeChanged(dwtx.jface.text.IDocument, dwtx.jface.text.IDocument)
                 */
                public void inputDocumentAboutToBeChanged(IDocument oldInput, IDocument newInput) {
                    fInputDocumentAboutToBeChanged= true;
                }

                /*
                 * @see dwtx.jface.text.ITextInputListener#inputDocumentChanged(dwtx.jface.text.IDocument, dwtx.jface.text.IDocument)
                 */
                public void inputDocumentChanged(IDocument oldInput, IDocument newInput) {
                    fInputDocumentAboutToBeChanged= false;
                }
            };
            fSourceViewer.addTextInputListener(fTextInputListener);
        }

    }

    /**
     * Registers a new drawing strategy under the given ID. If there is already a
     * strategy registered under <code>id</code>, the old strategy gets replaced.
     * <p>The given id can be referenced when adding annotation types, see
     * {@link #addAnnotationType(Object, Object)}.</p>
     *
     * @param id the identifier under which the strategy can be referenced, not <code>null</code>
     * @param strategy the new strategy
     * @since 3.0
     */
    public void addDrawingStrategy(Object id, IDrawingStrategy strategy) {
        // don't permit null as null is used to signal that an annotation type is not
        // registered with a specific strategy, and that its annotation hierarchy should be searched
        if (id is null)
            throw new IllegalArgumentException(null);
        fPaintingStrategyId2PaintingStrategy.put(id, cast(Object)strategy);
        fCachedAnnotationType2PaintingStrategy.clear();
    }

    /**
     * Registers a new drawing strategy under the given ID. If there is already
     * a strategy registered under <code>id</code>, the old strategy gets
     * replaced.
     * <p>
     * The given id can be referenced when adding annotation types, see
     * {@link #addAnnotationType(Object, Object)}.
     * </p>
     *
     * @param id the identifier under which the strategy can be referenced, not <code>null</code>
     * @param strategy the new strategy
     * @since 3.4
     */
    public void addTextStyleStrategy(Object id, ITextStyleStrategy strategy) {
        // don't permit null as null is used to signal that an annotation type is not
        // registered with a specific strategy, and that its annotation hierarchy should be searched
        if (id is null)
            throw new IllegalArgumentException(null);
        fPaintingStrategyId2PaintingStrategy.put(id, cast(Object)strategy);
        fCachedAnnotationType2PaintingStrategy.clear();
    }

    /**
     * Adds the given annotation type to the list of annotation types whose
     * annotations should be highlighted this painter. If the annotation  type
     * is already in this list, this method is without effect.
     *
     * @param annotationType the annotation type
     * @since 3.0
     */
    public void addHighlightAnnotationType(Object annotationType) {
        addAnnotationType(annotationType, HIGHLIGHTING);
    }

    /**
     * Removes the given annotation type from the list of annotation types whose
     * annotations are painted by this painter. If the annotation type is not
     * in this list, this method is without effect.
     *
     * @param annotationType the annotation type
     */
    public void removeAnnotationType(Object annotationType) {
        fCachedAnnotationType2PaintingStrategy.clear();
        fAnnotationType2PaintingStrategyId.remove(annotationType);
        if (fAnnotationType2PaintingStrategyId.isEmpty() && fTextInputListener !is null) {
            fSourceViewer.removeTextInputListener(fTextInputListener);
            fTextInputListener= null;
            fInputDocumentAboutToBeChanged= false;
        }
    }

    /**
     * Removes the given annotation type from the list of annotation types whose
     * annotations are highlighted by this painter. If the annotation type is not
     * in this list, this method is without effect.
     *
     * @param annotationType the annotation type
     * @since 3.0
     */
    public void removeHighlightAnnotationType(Object annotationType) {
        removeAnnotationType(annotationType);
    }

    /**
     * Clears the list of annotation types whose annotations are
     * painted by this painter.
     */
    public void removeAllAnnotationTypes() {
        fCachedAnnotationType2PaintingStrategy.clear();
        fAnnotationType2PaintingStrategyId.clear();
        if (fTextInputListener !is null) {
            fSourceViewer.removeTextInputListener(fTextInputListener);
            fTextInputListener= null;
        }
    }

    /**
     * Returns whether the list of annotation types whose annotations are painted
     * by this painter contains at least on element.
     *
     * @return <code>true</code> if there is an annotation type whose annotations are painted
     */
    public bool isPaintingAnnotations() {
        return !fAnnotationType2PaintingStrategyId.isEmpty();
    }

    /*
     * @see dwtx.jface.text.IPainter#dispose()
     */
    public void dispose() {

        if (fAnnotationType2Color !is null) {
            fAnnotationType2Color.clear();
            fAnnotationType2Color= null;
        }

        if (fCachedAnnotationType2Color !is null) {
            fCachedAnnotationType2Color.clear();
            fCachedAnnotationType2Color= null;
        }

        if (fCachedAnnotationType2PaintingStrategy !is null) {
            fCachedAnnotationType2PaintingStrategy.clear();
            fCachedAnnotationType2PaintingStrategy= null;
        }

        if (fAnnotationType2PaintingStrategyId !is null) {
            fAnnotationType2PaintingStrategyId.clear();
            fAnnotationType2PaintingStrategyId= null;
        }

        fTextWidget= null;
        fSourceViewer= null;
        fAnnotationAccess= null;
        fModel= null;
        synchronized (fDecorationMapLock) {
            fDecorationsMap= null;
        }
        synchronized (fHighlightedDecorationsMapLock) {
            fHighlightedDecorationsMap= null;
        }
    }

    /**
     * Returns the document offset of the upper left corner of the source viewer's view port,
     * possibly including partially visible lines.
     *
     * @return the document offset if the upper left corner of the view port
     */
    private int getInclusiveTopIndexStartOffset() {

        if (fTextWidget !is null && !fTextWidget.isDisposed()) {
            int top= JFaceTextUtil.getPartialTopIndex(fSourceViewer);
            try {
                IDocument document= fSourceViewer.getDocument();
                return document.getLineOffset(top);
            } catch (BadLocationException x) {
            }
        }

        return -1;
    }

    /**
     * Returns the first invisible document offset of the lower right corner of the source viewer's view port,
     * possibly including partially visible lines.
     *
     * @return the first invisible document offset of the lower right corner of the view port
     */
    private int getExclusiveBottomIndexEndOffset() {

        if (fTextWidget !is null && !fTextWidget.isDisposed()) {
            int bottom= JFaceTextUtil.getPartialBottomIndex(fSourceViewer);
            try {
                IDocument document= fSourceViewer.getDocument();

                if (bottom >= document.getNumberOfLines())
                    bottom= document.getNumberOfLines() - 1;

                return document.getLineOffset(bottom) + document.getLineLength(bottom);
            } catch (BadLocationException x) {
            }
        }

        return -1;
    }

    /*
     * @see dwt.events.PaintListener#paintControl(dwt.events.PaintEvent)
     */
    public void paintControl(PaintEvent event) {
        if (fTextWidget !is null)
            handleDrawRequest(event);
    }

    /**
     * Handles the request to draw the annotations using the given graphical context.
     *
     * @param event the paint event or <code>null</code>
     */
    private void handleDrawRequest(PaintEvent event) {

        if (fTextWidget is null) {
            // is already disposed
            return;
        }

        IRegion clippingRegion= computeClippingRegion(event, false);
        if (clippingRegion is null)
            return;

        int vOffset= clippingRegion.getOffset();
        int vLength= clippingRegion.getLength();

        final GC gc= event !is null ? event.gc : null;

        // Clone decorations
        Collection decorations;
        synchronized (fDecorationMapLock) {
            decorations= new ArrayList(fDecorationsMap.size());
            decorations.addAll(fDecorationsMap.entrySet());
        }

        /*
         * Create a new list of annotations to be drawn, since removing from decorations is more
         * expensive. One bucket per drawing layer. Use linked lists as addition is cheap here.
         */
        ArrayList toBeDrawn= new ArrayList(10);
        for (Iterator e = decorations.iterator(); e.hasNext();) {
            Map.Entry entry= cast(Map.Entry)e.next();

            Annotation a= cast(Annotation)entry.getKey();
            Decoration pp = cast(Decoration)entry.getValue();
            // prune any annotation that is not drawable or does not need drawing
            if (!(a.isMarkedDeleted() || skip(a) || !pp.fPosition.overlapsWith(vOffset, vLength))) {
                // ensure sized appropriately
                for (int i= toBeDrawn.size(); i <= pp.fLayer; i++)
                    toBeDrawn.add(new LinkedList());
                (cast(List) toBeDrawn.get(pp.fLayer)).add(cast(Object)entry);
            }
        }
        IDocument document= fSourceViewer.getDocument();
        for (Iterator it= toBeDrawn.iterator(); it.hasNext();) {
            List layer= cast(List) it.next();
            for (Iterator e = layer.iterator(); e.hasNext();) {
                Map.Entry entry= cast(Map.Entry)e.next();
                Annotation a= cast(Annotation)entry.getKey();
                Decoration pp = cast(Decoration)entry.getValue();
                drawDecoration(pp, gc, a, clippingRegion, document);
            }
        }
    }

    private void drawDecoration(Decoration pp, GC gc, Annotation annotation, IRegion clippingRegion, IDocument document) {
        if (clippingRegion is null)
            return;

        if (!(cast(IDrawingStrategy)pp.fPaintingStrategy ))
            return;

        IDrawingStrategy drawingStrategy= cast(IDrawingStrategy)pp.fPaintingStrategy;

        int clippingOffset= clippingRegion.getOffset();
        int clippingLength= clippingRegion.getLength();

        Position p= pp.fPosition;
        try {

            int startLine= document.getLineOfOffset(p.getOffset());
            int lastInclusive= Math.max(p.getOffset(), p.getOffset() + p.getLength() - 1);
            int endLine= document.getLineOfOffset(lastInclusive);

            for (int i= startLine; i <= endLine; i++) {
                int lineOffset= document.getLineOffset(i);
                int paintStart= Math.max(lineOffset, p.getOffset());
                String lineDelimiter= document.getLineDelimiter(i);
                int delimiterLength= lineDelimiter !is null ? lineDelimiter.length() : 0;
                int paintLength= Math.min(lineOffset + document.getLineLength(i) - delimiterLength, p.getOffset() + p.getLength()) - paintStart;
                if (paintLength >= 0 && overlapsWith(paintStart, paintLength, clippingOffset, clippingLength)) {
                    // otherwise inside a line delimiter
                    IRegion widgetRange= getWidgetRange(paintStart, paintLength);
                    if (widgetRange !is null) {
                        drawingStrategy.draw(annotation, gc, fTextWidget, widgetRange.getOffset(), widgetRange.getLength(), pp.fColor);
                    }
                }
            }

        } catch (BadLocationException x) {
        }
    }

    /**
     * Computes the model (document) region that is covered by the paint event's clipping region. If
     * <code>event</code> is <code>null</code>, the model range covered by the visible editor
     * area (viewport) is returned.
     *
     * @param event the paint event or <code>null</code> to use the entire viewport
     * @param isClearing tells whether the clipping is need for clearing an annotation
     * @return the model region comprised by either the paint event's clipping region or the
     *         viewport
     * @since 3.2
     */
    private IRegion computeClippingRegion(PaintEvent event, bool isClearing) {
        if (event is null) {

            if (!isClearing && fCurrentDrawRange !is null)
                return new Region(fCurrentDrawRange.offset, fCurrentDrawRange.length);

            // trigger a repaint of the entire viewport
            int vOffset= getInclusiveTopIndexStartOffset();
            if (vOffset is -1)
                return null;

            // http://bugs.eclipse.org/bugs/show_bug.cgi?id=17147
            int vLength= getExclusiveBottomIndexEndOffset() - vOffset;

            return new Region(vOffset, vLength);
        }

        int widgetOffset;
        try {
            int widgetClippingStartOffset= fTextWidget.getOffsetAtLocation(new Point(0, event.y));
            int firstWidgetLine= fTextWidget.getLineAtOffset(widgetClippingStartOffset);
            widgetOffset= fTextWidget.getOffsetAtLine(firstWidgetLine);
        } catch (IllegalArgumentException ex1) {
            try {
                int firstVisibleLine= JFaceTextUtil.getPartialTopIndex(fTextWidget);
                widgetOffset= fTextWidget.getOffsetAtLine(firstVisibleLine);
            } catch (IllegalArgumentException ex2) { // above try code might fail too
                widgetOffset= 0;
            }
        }

        int widgetEndOffset;
        try {
            int widgetClippingEndOffset= fTextWidget.getOffsetAtLocation(new Point(0, event.y + event.height));
            int lastWidgetLine= fTextWidget.getLineAtOffset(widgetClippingEndOffset);
            widgetEndOffset= fTextWidget.getOffsetAtLine(lastWidgetLine + 1);
        } catch (IllegalArgumentException ex1) {
            // happens if the editor is not "full", e.g. the last line of the document is visible in the editor
            try {
                int lastVisibleLine= JFaceTextUtil.getPartialBottomIndex(fTextWidget);
                if (lastVisibleLine is fTextWidget.getLineCount() - 1)
                    // last line
                    widgetEndOffset= fTextWidget.getCharCount();
                else
                    widgetEndOffset= fTextWidget.getOffsetAtLine(lastVisibleLine + 1) - 1;
            } catch (IllegalArgumentException ex2) { // above try code might fail too
                widgetEndOffset= fTextWidget.getCharCount();
            }
        }

        IRegion clippingRegion= getModelRange(widgetOffset, widgetEndOffset - widgetOffset);

        return clippingRegion;
    }

    /**
     * Should the given annotation be skipped when handling draw requests?
     *
     * @param annotation the annotation
     * @return <code>true</code> iff the given annotation should be
     *         skipped when handling draw requests
     * @since 3.0
     */
    protected bool skip(Annotation annotation) {
        return false;
    }

    /**
     * Returns the widget region that corresponds to the
     * given offset and length in the viewer's document.
     *
     * @param modelOffset the model offset
     * @param modelLength the model length
     * @return the corresponding widget region
     */
    private IRegion getWidgetRange(int modelOffset, int modelLength) {
        fReusableRegion.setOffset(modelOffset);
        fReusableRegion.setLength(modelLength);

        if (fReusableRegion is null || fReusableRegion.getOffset() is Integer.MAX_VALUE)
            return null;

        if ( cast(ITextViewerExtension5)fSourceViewer ) {
            ITextViewerExtension5 extension= cast(ITextViewerExtension5) fSourceViewer;
            return extension.modelRange2WidgetRange(fReusableRegion);
        }

        IRegion region= fSourceViewer.getVisibleRegion();
        int offset= region.getOffset();
        int length= region.getLength();

        if (overlapsWith(fReusableRegion, region)) {
            int p1= Math.max(offset, fReusableRegion.getOffset());
            int p2= Math.min(offset + length, fReusableRegion.getOffset() + fReusableRegion.getLength());
            return new Region(p1 - offset, p2 - p1);
        }
        return null;
    }

    /**
     * Returns the model region that corresponds to the given region in the
     * viewer's text widget.
     *
     * @param offset the offset in the viewer's widget
     * @param length the length in the viewer's widget
     * @return the corresponding document region
     * @since 3.2
     */
    private IRegion getModelRange(int offset, int length) {
        if (offset is Integer.MAX_VALUE)
            return null;

        if ( cast(ITextViewerExtension5)fSourceViewer ) {
            ITextViewerExtension5 extension= cast(ITextViewerExtension5) fSourceViewer;
            return extension.widgetRange2ModelRange(new Region(offset, length));
        }

        IRegion region= fSourceViewer.getVisibleRegion();
        return new Region(region.getOffset() + offset, length);
    }

    /**
     * Checks whether the intersection of the given text ranges
     * is empty or not.
     *
     * @param range1 the first range to check
     * @param range2 the second range to check
     * @return <code>true</code> if intersection is not empty
     */
    private bool overlapsWith(IRegion range1, IRegion range2) {
        return overlapsWith(range1.getOffset(), range1.getLength(), range2.getOffset(), range2.getLength());
    }

    /**
     * Checks whether the intersection of the given text ranges
     * is empty or not.
     *
     * @param offset1 offset of the first range
     * @param length1 length of the first range
     * @param offset2 offset of the second range
     * @param length2 length of the second range
     * @return <code>true</code> if intersection is not empty
     */
    private bool overlapsWith(int offset1, int length1, int offset2, int length2) {
        int end= offset2 + length2;
        int thisEnd= offset1 + length1;

        if (length2 > 0) {
            if (length1 > 0)
                return offset1 < end && offset2 < thisEnd;
            return  offset2 <= offset1 && offset1 < end;
        }

        if (length1 > 0)
            return offset1 <= offset2 && offset2 < thisEnd;
        return offset1 is offset2;
    }

    /*
     * @see dwtx.jface.text.IPainter#deactivate(bool)
     */
    public void deactivate(bool redraw) {
        if (fIsActive) {
            fIsActive= false;
            disablePainting(redraw);
            setModel(null);
            catchupWithModel(null);
        }
    }

    /**
     * Returns whether the given reason causes a repaint.
     *
     * @param reason the reason
     * @return <code>true</code> if repaint reason, <code>false</code> otherwise
     * @since 3.0
     */
    protected bool isRepaintReason(int reason) {
        return CONFIGURATION is reason || INTERNAL is reason;
    }

    /**
     * Retrieves the annotation model from the given source viewer.
     *
     * @param sourceViewer the source viewer
     * @return the source viewer's annotation model or <code>null</code> if none can be found
     * @since 3.0
     */
    protected IAnnotationModel findAnnotationModel(ISourceViewer sourceViewer) {
        if(sourceViewer !is null)
            return sourceViewer.getAnnotationModel();
        return null;
    }

    /*
     * @see dwtx.jface.text.IPainter#paint(int)
     */
    public void paint(int reason) {
        if (fSourceViewer.getDocument() is null) {
            deactivate(false);
            return;
        }

        if (!fIsActive) {
            IAnnotationModel model= findAnnotationModel(fSourceViewer);
            if (model !is null) {
                fIsActive= true;
                setModel(model);
            }
        } else if (isRepaintReason(reason))
            updatePainting(null);
    }

    /*
     * @see dwtx.jface.text.IPainter#setPositionManager(dwtx.jface.text.IPaintPositionManager)
     */
    public void setPositionManager(IPaintPositionManager manager) {
    }
}
