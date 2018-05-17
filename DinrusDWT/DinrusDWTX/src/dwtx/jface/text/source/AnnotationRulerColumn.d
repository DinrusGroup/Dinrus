/*******************************************************************************
 * Copyright (c) 2000, 2008 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *     Nikolay Botev <bono8106@hotmail.com> - [projection] Editor loses keyboard focus when expanding folded region - https://bugs.eclipse.org/bugs/show_bug.cgi?id=184255
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/
module dwtx.jface.text.source.AnnotationRulerColumn;

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

import dwtx.dwtxhelper.Collection;









import dwt.DWT;
import dwt.custom.StyledText;
import dwt.events.DisposeEvent;
import dwt.events.DisposeListener;
import dwt.events.MouseEvent;
import dwt.events.MouseListener;
import dwt.events.MouseMoveListener;
import dwt.events.PaintEvent;
import dwt.events.PaintListener;
import dwt.graphics.Cursor;
import dwt.graphics.Font;
import dwt.graphics.GC;
import dwt.graphics.Image;
import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwt.widgets.Canvas;
import dwt.widgets.Composite;
import dwt.widgets.Control;
import dwt.widgets.Display;
import dwtx.jface.text.BadLocationException;
import dwtx.jface.text.IDocument;
import dwtx.jface.text.IRegion;
import dwtx.jface.text.ITextListener;
import dwtx.jface.text.ITextViewer;
import dwtx.jface.text.ITextViewerExtension5;
import dwtx.jface.text.IViewportListener;
import dwtx.jface.text.JFaceTextUtil;
import dwtx.jface.text.Position;
import dwtx.jface.text.TextEvent;


/**
 * A vertical ruler column showing graphical representations of annotations.
 * Will become final.
 * <p>
 * Do not subclass.
 * </p>
 *
 * @since 2.0
 */
public class AnnotationRulerColumn : IVerticalRulerColumn, IVerticalRulerInfo, IVerticalRulerInfoExtension {

    /**
     * Internal listener class.
     */
    class InternalListener : IViewportListener, IAnnotationModelListener, ITextListener {

        /*
         * @see IViewportListener#viewportChanged(int)
         */
        public void viewportChanged(int verticalPosition) {
            if (verticalPosition !is fScrollPos)
                redraw();
        }

        /*
         * @see IAnnotationModelListener#modelChanged(IAnnotationModel)
         */
        public void modelChanged(IAnnotationModel model) {
            postRedraw();
        }

        /*
         * @see ITextListener#textChanged(TextEvent)
         */
        public void textChanged(TextEvent e) {
            if (e.getViewerRedrawState())
                postRedraw();
        }
    }

    /**
     * Implementation of <code>IRegion</code> that can be reused
     * by setting the offset and the length.
     */
    private static class ReusableRegion : Position , IRegion {
        public override int getLength(){
            return super.getLength();
        }
        public override int getOffset(){
            return super.getOffset();
        }
    }

    /**
     * Pair of an annotation and their associated position. Used inside the paint method
     * for sorting annotations based on the offset of their position.
     * @since 3.0
     */
    private static class Tuple {
        Annotation annotation;
        Position position;

        this(Annotation annotation, Position position) {
            this.annotation= annotation;
            this.position= position;
        }
    }

    /**
     * Comparator for <code>Tuple</code>s.
     * @since 3.0
     */
    private static class TupleComparator : Comparator {
        /*
         * @see java.util.Comparator#compare(java.lang.Object, java.lang.Object)
         */
        public int compare(Object o1, Object o2) {
            Position p1= (cast(Tuple) o1).position;
            Position p2= (cast(Tuple) o2).position;
            return p1.getOffset() - p2.getOffset();
        }
    }

    /** This column's parent ruler */
    private CompositeRuler fParentRuler;
    /** The cached text viewer */
    private ITextViewer fCachedTextViewer;
    /** The cached text widget */
    private StyledText fCachedTextWidget;
    /** The ruler's canvas */
    private Canvas fCanvas;
    /** The vertical ruler's model */
    private IAnnotationModel fModel;
    /** Cache for the actual scroll position in pixels */
    private int fScrollPos;
    /** The buffer for double buffering */
    private Image fBuffer;
    /** The internal listener */
    private InternalListener fInternalListener;
    /** The width of this vertical ruler */
    private int fWidth;
    /** Switch for enabling/disabling the setModel method. */
    private bool fAllowSetModel= true;
    /**
     * The list of annotation types to be shown in this ruler.
     * @since 3.0
     */
    private Set fConfiguredAnnotationTypes;
    /**
     * The list of allowed annotation types to be shown in this ruler.
     * An allowed annotation type maps to <code>true</code>, a disallowed
     * to <code>false</code>.
     * @since 3.0
     */
    private Map fAllowedAnnotationTypes;
    /**
     * The annotation access extension.
     * @since 3.0
     */
    private IAnnotationAccessExtension fAnnotationAccessExtension;
    /**
     * The hover for this column.
     * @since 3.0
     */
    private IAnnotationHover fHover;
    /**
     * The cached annotations.
     * @since 3.0
     */
    private List fCachedAnnotations;
    /**
     * The comparator for sorting annotations according to the offset of their position.
     * @since 3.0
     */
    private Comparator fTupleComparator;
    /**
     * The hit detection cursor.
     * @since 3.0
     */
    private Cursor fHitDetectionCursor;
    /**
     * The last cursor.
     * @since 3.0
     */
    private Cursor fLastCursor;
    /**
     * This ruler's mouse listener.
     * @since 3.0
     */
    private MouseListener fMouseListener;

    private void instanceInit(){
        fInternalListener= new InternalListener();
        fConfiguredAnnotationTypes= new HashSet();
        fAllowedAnnotationTypes= new HashMap();
        fCachedAnnotations= new ArrayList();
        fTupleComparator= new TupleComparator();
    }
    /**
     * Constructs this column with the given arguments.
     *
     * @param model the annotation model to get the annotations from
     * @param width the width of the vertical ruler
     * @param annotationAccess the annotation access
     * @since 3.0
     */
    public this(IAnnotationModel model, int width, IAnnotationAccess annotationAccess) {
        this(width, annotationAccess);
        fAllowSetModel= false;
        fModel= model;
        fModel.addAnnotationModelListener(fInternalListener);
    }

    /**
     * Constructs this column with the given arguments.
     *
     * @param width the width of the vertical ruler
     * @param annotationAccess the annotation access
     * @since 3.0
     */
    public this(int width, IAnnotationAccess annotationAccess) {
        instanceInit();
        fWidth= width;
        if ( cast(IAnnotationAccessExtension)annotationAccess )
            fAnnotationAccessExtension= cast(IAnnotationAccessExtension) annotationAccess;
    }

    /**
     * Constructs this column with the given arguments.
     *
     * @param model the annotation model to get the annotations from
     * @param width the width of the vertical ruler
     */
    public this(IAnnotationModel model, int width) {
        instanceInit();
        fWidth= width;
        fAllowSetModel= false;
        fModel= model;
        fModel.addAnnotationModelListener(fInternalListener);
    }

    /**
     * Constructs this column with the given width.
     *
     * @param width the width of the vertical ruler
     */
    public this(int width) {
        instanceInit();
        fWidth= width;
    }

    /*
     * @see IVerticalRulerColumn#getControl()
     */
    public Control getControl() {
        return fCanvas;
    }

    /*
     * @see IVerticalRulerColumn#getWidth()
     */
    public int getWidth() {
        return fWidth;
    }

    /*
     * @see IVerticalRulerColumn#createControl(CompositeRuler, Composite)
     */
    public Control createControl(CompositeRuler parentRuler, Composite parentControl) {

        fParentRuler= parentRuler;
        fCachedTextViewer= parentRuler.getTextViewer();
        fCachedTextWidget= fCachedTextViewer.getTextWidget();

        fHitDetectionCursor= new Cursor(parentControl.getDisplay(), DWT.CURSOR_HAND);

        fCanvas= createCanvas(parentControl);

        fCanvas.addPaintListener(new class()  PaintListener {
            public void paintControl(PaintEvent event) {
                if (fCachedTextViewer !is null)
                    doubleBufferPaint(event.gc);
            }
        });

        fCanvas.addDisposeListener(new class()  DisposeListener {
            public void widgetDisposed(DisposeEvent e) {
                handleDispose();
                fCachedTextViewer= null;
                fCachedTextWidget= null;
            }
        });

        fMouseListener= new class()  MouseListener {
            public void mouseUp(MouseEvent event) {
                int lineNumber;
                if (isPropagatingMouseListener()) {
                    fParentRuler.setLocationOfLastMouseButtonActivity(event.x, event.y);
                    lineNumber= fParentRuler.getLineOfLastMouseButtonActivity();
                } else
                    lineNumber= fParentRuler.toDocumentLineNumber(event.y);

                if (1 is event.button)
                    mouseClicked(lineNumber);
            }

            public void mouseDown(MouseEvent event) {
                if (isPropagatingMouseListener())
                    fParentRuler.setLocationOfLastMouseButtonActivity(event.x, event.y);
            }

            public void mouseDoubleClick(MouseEvent event) {
                int lineNumber;
                if (isPropagatingMouseListener()) {
                    fParentRuler.setLocationOfLastMouseButtonActivity(event.x, event.y);
                    lineNumber= fParentRuler.getLineOfLastMouseButtonActivity();
                } else
                    lineNumber= fParentRuler.toDocumentLineNumber(event.y);

                if (1 is event.button)
                    mouseDoubleClicked(lineNumber);
            }
        };
        fCanvas.addMouseListener(fMouseListener);

        fCanvas.addMouseMoveListener(new class()  MouseMoveListener {
            /*
             * @see dwt.events.MouseMoveListener#mouseMove(dwt.events.MouseEvent)
             * @since 3.0
             */
            public void mouseMove(MouseEvent e) {
                handleMouseMove(e);
            }
        });

        if (fCachedTextViewer !is null) {
            fCachedTextViewer.addViewportListener(fInternalListener);
            fCachedTextViewer.addTextListener(fInternalListener);
        }

        return fCanvas;
    }

    /**
     * Creates a canvas with the given parent.
     *
     * @param parent the parent
     * @return the created canvas
     */
    private Canvas createCanvas(Composite parent) {
        return new class(parent, DWT.NO_BACKGROUND | DWT.NO_FOCUS)  Canvas {
            this( Composite p, int s ){
                super(p,s);
            }
            /*
             * @see dwt.widgets.Control#addMouseListener(dwt.events.MouseListener)
             * @since 3.0
             */
            public void addMouseListener(MouseListener listener) {
                if (isPropagatingMouseListener() || listener is fMouseListener)
                    super.addMouseListener(listener);
            }
        };
    }

    /**
     * Tells whether this ruler column propagates mouse listener
     * events to its parent.
     *
     * @return <code>true</code> if propagating to parent
     * @since 3.0
     */
    protected bool isPropagatingMouseListener() {
        return true;
    }

    /**
     * Hook method for a mouse double click event on the given ruler line.
     *
     * @param rulerLine the ruler line
     */
    protected void mouseDoubleClicked(int rulerLine) {
    }

    /**
     * Hook method for a mouse click event on the given ruler line.
     *
     * @param rulerLine the ruler line
     * @since 3.0
     */
    protected void mouseClicked(int rulerLine) {
    }

    /**
     * Handles mouse moves.
     *
     * @param event the mouse move event
     */
    private void handleMouseMove(MouseEvent event) {
        fParentRuler.setLocationOfLastMouseButtonActivity(event.x, event.y);
        if (fCachedTextViewer !is null) {
            int line= toDocumentLineNumber(event.y);
            Cursor cursor= (hasAnnotation(line) ? fHitDetectionCursor : null);
            if (cursor !is fLastCursor) {
                fCanvas.setCursor(cursor);
                fLastCursor= cursor;
            }
        }
    }

    /**
     * Tells whether the given line contains an annotation.
     *
     * @param lineNumber the line number
     * @return <code>true</code> if the given line contains an annotation
     */
    protected bool hasAnnotation(int lineNumber) {

        IAnnotationModel model= fModel;
        if ( cast(IAnnotationModelExtension)fModel )
            model= (cast(IAnnotationModelExtension)fModel).getAnnotationModel(SourceViewer.MODEL_ANNOTATION_MODEL);

        if (model is null)
            return false;

        IRegion line;
        try {
            IDocument d= fCachedTextViewer.getDocument();
            if (d is null)
                return false;

            line= d.getLineInformation(lineNumber);
        }  catch (BadLocationException ex) {
            return false;
        }

        int lineStart= line.getOffset();
        int lineLength= line.getLength();

        Iterator e;
        if ( cast(IAnnotationModelExtension2)fModel )
            e= (cast(IAnnotationModelExtension2)fModel).getAnnotationIterator(lineStart, lineLength + 1, true, true);
        else
            e= model.getAnnotationIterator();

        while (e.hasNext()) {
            Annotation a= cast(Annotation) e.next();

            if (a.isMarkedDeleted())
                continue;

            if (skip(a))
                continue;

            Position p= model.getPosition(a);
            if (p is null || p.isDeleted())
                continue;

            if (p.overlapsWith(lineStart, lineLength) || p.length is 0 && p.offset is lineStart + lineLength)
                return true;
        }

        return false;
    }

    /**
     * Disposes the ruler's resources.
     */
    private void handleDispose() {

        if (fCachedTextViewer !is null) {
            fCachedTextViewer.removeViewportListener(fInternalListener);
            fCachedTextViewer.removeTextListener(fInternalListener);
        }

        if (fModel !is null)
            fModel.removeAnnotationModelListener(fInternalListener);

        if (fBuffer !is null) {
            fBuffer.dispose();
            fBuffer= null;
        }

        if (fHitDetectionCursor !is null) {
            fHitDetectionCursor.dispose();
            fHitDetectionCursor= null;
        }

        fConfiguredAnnotationTypes.clear();
        fAllowedAnnotationTypes.clear();
        fAnnotationAccessExtension= null;
    }

    /**
     * Double buffer drawing.
     *
     * @param dest the GC to draw into
     */
    private void doubleBufferPaint(GC dest) {

        Point size= fCanvas.getSize();

        if (size.x <= 0 || size.y <= 0)
            return;

        if (fBuffer !is null) {
            Rectangle r= fBuffer.getBounds();
            if (r.width !is size.x || r.height !is size.y) {
                fBuffer.dispose();
                fBuffer= null;
            }
        }
        if (fBuffer is null)
            fBuffer= new Image(fCanvas.getDisplay(), size.x, size.y);

        GC gc= new GC(fBuffer);
        gc.setFont(fCachedTextWidget.getFont());
        try {
            gc.setBackground(fCanvas.getBackground());
            gc.fillRectangle(0, 0, size.x, size.y);

            if ( cast(ITextViewerExtension5)fCachedTextViewer )
                doPaint1(gc);
            else
                doPaint(gc);
        } finally {
            gc.dispose();
        }

        dest.drawImage(fBuffer, 0, 0);
    }

    /**
     * Returns the document offset of the upper left corner of the source viewer's
     * view port, possibly including partially visible lines.
     *
     * @return document offset of the upper left corner including partially visible lines
     */
    protected int getInclusiveTopIndexStartOffset() {
        if (fCachedTextWidget is null || fCachedTextWidget.isDisposed())
            return -1;

        IDocument document= fCachedTextViewer.getDocument();
        if (document is null)
            return -1;

        int top= JFaceTextUtil.getPartialTopIndex(fCachedTextViewer);
        try {
            return document.getLineOffset(top);
        } catch (BadLocationException x) {
            return -1;
        }
    }

    /**
     * Returns the first invisible document offset of the lower right corner of the source viewer's view port,
     * possibly including partially visible lines.
     *
     * @return the first invisible document offset of the lower right corner of the view port
     */
    private int getExclusiveBottomIndexEndOffset() {
        if (fCachedTextWidget is null || fCachedTextWidget.isDisposed())
            return -1;

        IDocument document= fCachedTextViewer.getDocument();
        if (document is null)
            return -1;

        int bottom= JFaceTextUtil.getPartialBottomIndex(fCachedTextViewer);
        try {
            if (bottom >= document.getNumberOfLines())
                bottom= document.getNumberOfLines() - 1;
            return document.getLineOffset(bottom) + document.getLineLength(bottom);
        } catch (BadLocationException x) {
            return -1;
        }
    }

    /**
     * Draws the vertical ruler w/o drawing the Canvas background.
     *
     * @param gc the GC to draw into
     */
    protected void doPaint(GC gc) {

        if (fModel is null || fCachedTextViewer is null)
            return;

        int topLeft= getInclusiveTopIndexStartOffset();
        // http://dev.eclipse.org/bugs/show_bug.cgi?id=14938
        // http://dev.eclipse.org/bugs/show_bug.cgi?id=22487
        // we want the exclusive offset (right after the last character)
        int bottomRight= getExclusiveBottomIndexEndOffset();
        int viewPort= bottomRight - topLeft;

        fScrollPos= fCachedTextWidget.getTopPixel();
        Point dimension= fCanvas.getSize();

        IDocument doc= fCachedTextViewer.getDocument();
        if (doc is null)
            return;

        int topLine= -1, bottomLine= -1;
        try {
            IRegion region= fCachedTextViewer.getVisibleRegion();
            topLine= doc.getLineOfOffset(region.getOffset());
            bottomLine= doc.getLineOfOffset(region.getOffset() + region.getLength());
        } catch (BadLocationException x) {
            return;
        }

        // draw Annotations
        Rectangle r= new Rectangle(0, 0, 0, 0);
        int maxLayer= 1;    // loop at least once through layers.

        for (int layer= 0; layer < maxLayer; layer++) {
            Iterator iter;
            if ( cast(IAnnotationModelExtension2)fModel )
                iter= (cast(IAnnotationModelExtension2)fModel).getAnnotationIterator(topLeft, viewPort + 1, true, true);
            else
                iter= fModel.getAnnotationIterator();

            while (iter.hasNext()) {
                Annotation annotation= cast(Annotation) iter.next();

                int lay= IAnnotationAccessExtension.DEFAULT_LAYER;
                if (fAnnotationAccessExtension !is null)
                    lay= fAnnotationAccessExtension.getLayer(annotation);
                maxLayer= Math.max(maxLayer, lay+1);    // dynamically update layer maximum
                if (lay !is layer)   // wrong layer: skip annotation
                    continue;

                if (skip(annotation))
                    continue;

                Position position= fModel.getPosition(annotation);
                if (position is null)
                    continue;

                // https://bugs.eclipse.org/bugs/show_bug.cgi?id=20284
                // Position.overlapsWith returns false if the position just starts at the end
                // of the specified range. If the position has zero length, we want to include it anyhow
                int viewPortSize= position.getLength() is 0 ? viewPort + 1 : viewPort;
                if (!position.overlapsWith(topLeft, viewPortSize))
                    continue;

                try {

                    int offset= position.getOffset();
                    int length= position.getLength();

                    int startLine= doc.getLineOfOffset(offset);
                    if (startLine < topLine)
                        startLine= topLine;

                    int endLine= startLine;
                    if (length > 0)
                        endLine= doc.getLineOfOffset(offset + length - 1);
                    if (endLine > bottomLine)
                        endLine= bottomLine;

                    startLine -= topLine;
                    endLine -= topLine;

                    r.x= 0;
                    r.y= JFaceTextUtil.computeLineHeight(fCachedTextWidget, 0, startLine, startLine)  - fScrollPos;

                    r.width= dimension.x;
                    int lines= endLine - startLine;

                    r.height= JFaceTextUtil.computeLineHeight(fCachedTextWidget, startLine, endLine + 1, lines + 1);

                    if (r.y < dimension.y && fAnnotationAccessExtension !is null)  // annotation within visible area
                        fAnnotationAccessExtension.paint(annotation, gc, fCanvas, r);

                } catch (BadLocationException x) {
                }
            }
        }
    }

    /**
     * Draws the vertical ruler w/o drawing the Canvas background. Implementation based
     * on <code>ITextViewerExtension5</code>. Will replace <code>doPaint(GC)</code>.
     *
     * @param gc the GC to draw into
     */
    protected void doPaint1(GC gc) {

        if (fModel is null || fCachedTextViewer is null)
            return;

        ITextViewerExtension5 extension= cast(ITextViewerExtension5) fCachedTextViewer;

        fScrollPos= fCachedTextWidget.getTopPixel();
        Point dimension= fCanvas.getSize();

        int vOffset= getInclusiveTopIndexStartOffset();
        int vLength= getExclusiveBottomIndexEndOffset() - vOffset;

        // draw Annotations
        Rectangle r= new Rectangle(0, 0, 0, 0);
        ReusableRegion range= new ReusableRegion();

        int minLayer= Integer.MAX_VALUE, maxLayer= Integer.MIN_VALUE;
        fCachedAnnotations.clear();
        Iterator iter;
        if ( cast(IAnnotationModelExtension2)fModel )
            iter= (cast(IAnnotationModelExtension2)fModel).getAnnotationIterator(vOffset, vLength + 1, true, true);
        else
            iter= fModel.getAnnotationIterator();

        while (iter.hasNext()) {
            Annotation annotation= cast(Annotation) iter.next();

            if (skip(annotation))
                continue;

            Position position= fModel.getPosition(annotation);
            if (position is null)
                continue;

            // https://bugs.eclipse.org/bugs/show_bug.cgi?id=217710
            int extendedVLength= position.getLength() is 0 ? vLength + 1 : vLength;
            if (!position.overlapsWith(vOffset, extendedVLength))
                continue;

            int lay= IAnnotationAccessExtension.DEFAULT_LAYER;
            if (fAnnotationAccessExtension !is null)
                lay= fAnnotationAccessExtension.getLayer(annotation);

            minLayer= Math.min(minLayer, lay);
            maxLayer= Math.max(maxLayer, lay);
            fCachedAnnotations.add(new Tuple(annotation, position));
        }
        Collections.sort(fCachedAnnotations, fTupleComparator);

        for (int layer= minLayer; layer <= maxLayer; layer++) {
            for (int i= 0, n= fCachedAnnotations.size(); i < n; i++) {
                Tuple tuple= cast(Tuple) fCachedAnnotations.get(i);
                Annotation annotation= tuple.annotation;
                Position position= tuple.position;

                int lay= IAnnotationAccessExtension.DEFAULT_LAYER;
                if (fAnnotationAccessExtension !is null)
                    lay= fAnnotationAccessExtension.getLayer(annotation);
                if (lay !is layer)   // wrong layer: skip annotation
                    continue;

                range.setOffset(position.getOffset());
                range.setLength(position.getLength());
                IRegion widgetRegion= extension.modelRange2WidgetRange(range);
                if (widgetRegion is null)
                    continue;

                int startLine= extension.widgetLineOfWidgetOffset(widgetRegion.getOffset());
                if (startLine is -1)
                    continue;

                int endLine= extension.widgetLineOfWidgetOffset(widgetRegion.getOffset() + Math.max(widgetRegion.getLength() -1, 0));
                if (endLine is -1)
                    continue;

                r.x= 0;
                r.y= JFaceTextUtil.computeLineHeight(fCachedTextWidget, 0, startLine, startLine)  - fScrollPos;

                r.width= dimension.x;
                int lines= endLine - startLine;
                r.height= JFaceTextUtil.computeLineHeight(fCachedTextWidget, startLine, endLine + 1, lines + 1);

                if (r.y < dimension.y && fAnnotationAccessExtension !is null)  // annotation within visible area
                    fAnnotationAccessExtension.paint(annotation, gc, fCanvas, r);
            }
        }

        fCachedAnnotations.clear();
    }


    /**
     * Post a redraw request for this column into the UI thread.
     */
    private void postRedraw() {
        if (fCanvas !is null && !fCanvas.isDisposed()) {
            Display d= fCanvas.getDisplay();
            if (d !is null) {
                d.asyncExec(new class()  Runnable {
                    public void run() {
                        redraw();
                    }
                });
            }
        }
    }

    /*
     * @see IVerticalRulerColumn#redraw()
     */
    public void redraw() {
        if (fCanvas !is null && !fCanvas.isDisposed()) {
            GC gc= new GC(fCanvas);
            doubleBufferPaint(gc);
            gc.dispose();
        }
    }

    /*
     * @see IVerticalRulerColumn#setModel
     */
    public void setModel(IAnnotationModel model) {
        if (fAllowSetModel && model !is fModel) {

            if (fModel !is null)
                fModel.removeAnnotationModelListener(fInternalListener);

            fModel= model;

            if (fModel !is null)
                fModel.addAnnotationModelListener(fInternalListener);

            postRedraw();
        }
    }

    /*
     * @see IVerticalRulerColumn#setFont(Font)
     */
    public void setFont(Font font) {
    }

    /**
     * Returns the cached text viewer.
     *
     * @return the cached text viewer
     */
    protected ITextViewer getCachedTextViewer() {
        return fCachedTextViewer;
    }

    /*
     * @see dwtx.jface.text.source.IVerticalRulerInfoExtension#getModel()
     */
    public IAnnotationModel getModel() {
        return fModel;
    }

    /**
     * Adds the given annotation type to this annotation ruler column. Starting
     * with this call, annotations of the given type are shown in this annotation
     * ruler column.
     *
     * @param annotationType the annotation type
     * @since 3.0
     */
    public void addAnnotationType(Object annotationType) {
        fConfiguredAnnotationTypes.add(annotationType);
        fAllowedAnnotationTypes.clear();
    }

    /*
     * @see dwtx.jface.text.source.IVerticalRulerInfo#getLineOfLastMouseButtonActivity()
     * @since 3.0
     */
    public int getLineOfLastMouseButtonActivity() {
        return fParentRuler.getLineOfLastMouseButtonActivity();
    }

    /*
     * @see dwtx.jface.text.source.IVerticalRulerInfo#toDocumentLineNumber(int)
     * @since 3.0
     */
    public int toDocumentLineNumber(int y_coordinate) {
        return fParentRuler.toDocumentLineNumber(y_coordinate);
    }

    /**
     * Removes the given annotation type from this annotation ruler column.
     * Annotations of the given type are no longer shown in this annotation
     * ruler column.
     *
     * @param annotationType the annotation type
     * @since 3.0
     */
    public void removeAnnotationType(Object annotationType) {
        fConfiguredAnnotationTypes.remove(annotationType);
        fAllowedAnnotationTypes.clear();
    }

    /**
     * Returns whether the given annotation should be skipped by the drawing
     * routine.
     *
     * @param annotation the annotation
     * @return <code>true</code> if annotation of the given type should be
     *         skipped, <code>false</code> otherwise
     * @since 3.0
     */
    private bool skip(Annotation annotation) {
        Object annotationType= stringcast(annotation.getType());
        Boolean allowed= cast(Boolean) fAllowedAnnotationTypes.get(annotationType);
        if (allowed !is null)
            return !allowed.booleanValue();

        bool skip= skip(annotationType);
        fAllowedAnnotationTypes.put(annotationType, !skip ? Boolean.TRUE : Boolean.FALSE);
        return skip;
    }

    /**
     * Computes whether the annotation of the given type should be skipped or
     * not.
     *
     * @param annotationType the annotation type
     * @return <code>true</code> if annotation should be skipped, <code>false</code>
     *         otherwise
     * @since 3.0
     */
    private bool skip(Object annotationType) {
        if (fAnnotationAccessExtension !is null) {
            Iterator e= fConfiguredAnnotationTypes.iterator();
            while (e.hasNext()) {
                if (fAnnotationAccessExtension.isSubtype(annotationType, e.next()))
                    return false;
            }
            return true;
        }
        return !fConfiguredAnnotationTypes.contains(annotationType);
    }

    /*
     * @see dwtx.jface.text.source.IVerticalRulerInfoExtension#getHover()
     * @since 3.0
     */
    public IAnnotationHover getHover() {
        return fHover;
    }

    /**
     * @param hover The hover to set.
     * @since 3.0
     */
    public void setHover(IAnnotationHover hover) {
        fHover= hover;
    }

    /*
     * @see dwtx.jface.text.source.IVerticalRulerInfoExtension#addVerticalRulerListener(dwtx.jface.text.source.IVerticalRulerListener)
     * @since 3.0
     */
    public void addVerticalRulerListener(IVerticalRulerListener listener) {
        throw new UnsupportedOperationException();
    }

    /*
     * @see dwtx.jface.text.source.IVerticalRulerInfoExtension#removeVerticalRulerListener(dwtx.jface.text.source.IVerticalRulerListener)
     * @since 3.0
     */
    public void removeVerticalRulerListener(IVerticalRulerListener listener) {
        throw new UnsupportedOperationException();
    }
}
