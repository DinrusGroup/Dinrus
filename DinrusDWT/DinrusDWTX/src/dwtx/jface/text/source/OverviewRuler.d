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
module dwtx.jface.text.source.OverviewRuler;

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
import dwtx.jface.text.source.AnnotationPainter; // packageimport
import dwtx.jface.text.source.IAnnotationHoverExtension2; // packageimport
import dwtx.jface.text.source.OverviewRulerHoverManager; // packageimport


import dwt.dwthelper.utils;

import dwtx.dwtxhelper.Collection;







import dwt.DWT;
import dwt.custom.StyledText;
import dwt.events.DisposeEvent;
import dwt.events.DisposeListener;
import dwt.events.MouseAdapter;
import dwt.events.MouseEvent;
import dwt.events.MouseMoveListener;
import dwt.events.MouseTrackAdapter;
import dwt.events.PaintEvent;
import dwt.events.PaintListener;
import dwt.graphics.Color;
import dwt.graphics.Cursor;
import dwt.graphics.GC;
import dwt.graphics.Image;
import dwt.graphics.Point;
import dwt.graphics.RGB;
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
import dwtx.jface.text.JFaceTextUtil;
import dwtx.jface.text.Position;
import dwtx.jface.text.Region;
import dwtx.jface.text.TextEvent;
import dwtx.jface.text.source.projection.AnnotationBag;


/**
 * Ruler presented next to a source viewer showing all annotations of the
 * viewer's annotation model in a compact format. The ruler has the same height
 * as the source viewer.
 * <p>
 * Clients usually instantiate and configure objects of this class.</p>
 *
 * @since 2.1
 */
public class OverviewRuler : IOverviewRuler {

    /**
     * Internal listener class.
     */
    class InternalListener : ITextListener, IAnnotationModelListener, IAnnotationModelListenerExtension {

        /*
         * @see ITextListener#textChanged
         */
        public void textChanged(TextEvent e) {
            if (fTextViewer !is null && e.getDocumentEvent() is null && e.getViewerRedrawState()) {
                // handle only changes of visible document
                redraw();
            }
        }

        /*
         * @see IAnnotationModelListener#modelChanged(IAnnotationModel)
         */
        public void modelChanged(IAnnotationModel model) {
            update();
        }

        /*
         * @see dwtx.jface.text.source.IAnnotationModelListenerExtension#modelChanged(dwtx.jface.text.source.AnnotationModelEvent)
         * @since 3.3
         */
        public void modelChanged(AnnotationModelEvent event) {
            if (!event.isValid())
                return;

            if (event.isWorldChange()) {
                update();
                return;
            }

            Annotation[] annotations= event.getAddedAnnotations();
            int length= annotations.length;
            for (int i= 0; i < length; i++) {
                if (!skip(annotations[i].getType())) {
                    update();
                    return;
                }
            }

            annotations= event.getRemovedAnnotations();
            length= annotations.length;
            for (int i= 0; i < length; i++) {
                if (!skip(annotations[i].getType())) {
                    update();
                    return;
                }
            }

            annotations= event.getChangedAnnotations();
            length= annotations.length;
            for (int i= 0; i < length; i++) {
                if (!skip(annotations[i].getType())) {
                    update();
                    return;
                }
            }

        }
    }

    /**
     * Enumerates the annotations of a specified type and characteristics
     * of the associated annotation model.
     */
    class FilterIterator : Iterator {

        final static int TEMPORARY= 1 << 1;
        final static int PERSISTENT= 1 << 2;
        final static int IGNORE_BAGS= 1 << 3;

        private Iterator fIterator;
        private Object fType;
        private Annotation fNext;
        private int fStyle;

        /**
         * Creates a new filter iterator with the given specification.
         *
         * @param annotationType the annotation type
         * @param style the style
         */
        public this(Object annotationType, int style) {
            fType= annotationType;
            fStyle= style;
            if (fModel !is null) {
                fIterator= fModel.getAnnotationIterator();
                skip();
            }
        }

        /**
         * Creates a new filter iterator with the given specification.
         *
         * @param annotationType the annotation type
         * @param style the style
         * @param iterator the iterator
         */
        public this(Object annotationType, int style, Iterator iterator) {
            fType= annotationType;
            fStyle= style;
            fIterator= iterator;
            skip();
        }

        private void skip() {

            bool temp= (fStyle & TEMPORARY) !is 0;
            bool pers= (fStyle & PERSISTENT) !is 0;
            bool ignr= (fStyle & IGNORE_BAGS) !is 0;

            while (fIterator.hasNext()) {
                Annotation next= cast(Annotation) fIterator.next();

                if (next.isMarkedDeleted())
                    continue;

                if (ignr && ( cast(AnnotationBag)next ))
                    continue;

                fNext= next;
                Object annotationType= stringcast(next.getType());
                if (fType is null || fType.opEquals(annotationType) || !fConfiguredAnnotationTypes.contains(annotationType) && isSubtype(annotationType)) {
                    if (temp && pers) return;
                    if (pers && next.isPersistent()) return;
                    if (temp && !next.isPersistent()) return;
                }
            }
            fNext= null;
        }

        private bool isSubtype(Object annotationType) {
            if ( cast(IAnnotationAccessExtension)fAnnotationAccess ) {
                IAnnotationAccessExtension extension= cast(IAnnotationAccessExtension) fAnnotationAccess;
                return extension.isSubtype(annotationType, fType);
            }
            return cast(bool) fType.opEquals(annotationType);
        }

        /*
         * @see Iterator#hasNext()
         */
        public bool hasNext() {
            return fNext !is null;
        }
        /*
         * @see Iterator#next()
         */
        public Object next() {
            try {
                return fNext;
            } finally {
                if (fIterator !is null)
                    skip();
            }
        }
        /*
         * @see Iterator#remove()
         */
        public void remove() {
            throw new UnsupportedOperationException();
        }
    }

    /**
     * The painter of the overview ruler's header.
     */
    class HeaderPainter : PaintListener {

        private Color fIndicatorColor;
        private Color fSeparatorColor;

        /**
         * Creates a new header painter.
         */
        public this() {
            fSeparatorColor= fHeader.getDisplay().getSystemColor(DWT.COLOR_WIDGET_NORMAL_SHADOW);
        }

        /**
         * Sets the header color.
         *
         * @param color the header color
         */
        public void setColor(Color color) {
            fIndicatorColor= color;
        }

        private void drawBevelRect(GC gc, int x, int y, int w, int h, Color topLeft, Color bottomRight) {
            gc.setForeground(topLeft is null ? fSeparatorColor : topLeft);
            gc.drawLine(x, y, x + w -1, y);
            gc.drawLine(x, y, x, y + h -1);

            gc.setForeground(bottomRight is null ? fSeparatorColor : bottomRight);
            gc.drawLine(x + w, y, x + w, y + h);
            gc.drawLine(x, y + h, x + w, y + h);
        }

        public void paintControl(PaintEvent e) {
            if (fIndicatorColor is null)
                return;

            Point s= fHeader.getSize();

            e.gc.setBackground(fIndicatorColor);
            Rectangle r= new Rectangle(INSET, (s.y - (2*ANNOTATION_HEIGHT)) / 2, s.x - (2*INSET), 2*ANNOTATION_HEIGHT);
            e.gc.fillRectangle(r);
            Display d= fHeader.getDisplay();
            if (d !is null)
//              drawBevelRect(e.gc, r.x, r.y, r.width -1, r.height -1, d.getSystemColor(DWT.COLOR_WIDGET_NORMAL_SHADOW), d.getSystemColor(DWT.COLOR_WIDGET_HIGHLIGHT_SHADOW));
                drawBevelRect(e.gc, r.x, r.y, r.width -1, r.height -1, null, null);

            e.gc.setForeground(fSeparatorColor);
            e.gc.setLineWidth(0); // NOTE: 0 means width is 1 but with optimized performance
            e.gc.drawLine(0, s.y -1, s.x -1, s.y -1);
        }
    }

    private static const int INSET= 2;
    private static const int ANNOTATION_HEIGHT= 4;
    private static bool ANNOTATION_HEIGHT_SCALABLE= true;


    /** The model of the overview ruler */
    private IAnnotationModel fModel;
    /** The view to which this ruler is connected */
    private ITextViewer fTextViewer;
    /** The ruler's canvas */
    private Canvas fCanvas;
    /** The ruler's header */
    private Canvas fHeader;
    /** The buffer for double buffering */
    private Image fBuffer;
    /** The internal listener */
    private InternalListener fInternalListener;
    /** The width of this vertical ruler */
    private int fWidth;
    /** The hit detection cursor */
    private Cursor fHitDetectionCursor;
    /** The last cursor */
    private Cursor fLastCursor;
    /** The line of the last mouse button activity */
    private int fLastMouseButtonActivityLine= -1;
    /** The actual annotation height */
    private int fAnnotationHeight= -1;
    /** The annotation access */
    private IAnnotationAccess fAnnotationAccess;
    /** The header painter */
    private HeaderPainter fHeaderPainter;
    /**
     * The list of annotation types to be shown in this ruler.
     * @since 3.0
     */
    private Set fConfiguredAnnotationTypes;
    /**
     * The list of annotation types to be shown in the header of this ruler.
     * @since 3.0
     */
    private Set fConfiguredHeaderAnnotationTypes;
    /** The mapping between annotation types and colors */
    private Map fAnnotationTypes2Colors;
    /** The color manager */
    private ISharedTextColors fSharedTextColors;
    /**
     * All available annotation types sorted by layer.
     *
     * @since 3.0
     */
    private List fAnnotationsSortedByLayer;
    /**
     * All available layers sorted by layer.
     * This list may contain duplicates.
     * @since 3.0
     */
    private List fLayersSortedByLayer;
    /**
     * Map of allowed annotation types.
     * An allowed annotation type maps to <code>true</code>, a disallowed
     * to <code>false</code>.
     * @since 3.0
     */
    private Map fAllowedAnnotationTypes;
    /**
     * Map of allowed header annotation types.
     * An allowed annotation type maps to <code>true</code>, a disallowed
     * to <code>false</code>.
     * @since 3.0
     */
    private Map fAllowedHeaderAnnotationTypes;
    /**
     * The cached annotations.
     * @since 3.0
     */
    private List fCachedAnnotations;

    /**
     * Redraw runnable lock
     * @since 3.3
     */
    private Object fRunnableLock;
    /**
     * Redraw runnable state
     * @since 3.3
     */
    private bool fIsRunnablePosted= false;
    /**
     * Redraw runnable
     * @since 3.3
     */
    private Runnable fRunnable;
    /**
     * Tells whether temporary annotations are drawn with
     * a separate color. This color will be computed by
     * discoloring the original annotation color.
     *
     * @since 3.4
     */
    private bool fIsTemporaryAnnotationDiscolored;


    /**
     * Constructs a overview ruler of the given width using the given annotation access and the given
     * color manager.
     * <p><strong>Note:</strong> As of 3.4, temporary annotations are no longer discolored.
     * Use {@link #OverviewRuler(IAnnotationAccess, int, ISharedTextColors, bool)} if you
     * want to keep the old behavior.</p>
     *
     * @param annotationAccess the annotation access
     * @param width the width of the vertical ruler
     * @param sharedColors the color manager
     */
    public this(IAnnotationAccess annotationAccess, int width, ISharedTextColors sharedColors) {
        this(annotationAccess, width, sharedColors, false);
    }

    /**
     * Constructs a overview ruler of the given width using the given annotation
     * access and the given color manager.
     *
     * @param annotationAccess the annotation access
     * @param width the width of the vertical ruler
     * @param sharedColors the color manager
     * @param discolorTemporaryAnnotation <code>true</code> if temporary annotations should be discolored
     * @since 3.4
     */
    public this(IAnnotationAccess annotationAccess, int width, ISharedTextColors sharedColors, bool discolorTemporaryAnnotation) {
        // DWT instance init
        fInternalListener= new InternalListener();
        fConfiguredAnnotationTypes= new HashSet();
        fConfiguredHeaderAnnotationTypes= new HashSet();
        fAnnotationTypes2Colors= new HashMap();
        fAnnotationsSortedByLayer= new ArrayList();
        fLayersSortedByLayer= new ArrayList();
        fAllowedAnnotationTypes= new HashMap();
        fAllowedHeaderAnnotationTypes= new HashMap();
        fCachedAnnotations= new ArrayList();
        fRunnableLock= new Object();
        fRunnable= dgRunnable( {
            synchronized (fRunnableLock) {
                fIsRunnablePosted= false;
            }
            redraw();
            updateHeader();
        });

        fAnnotationAccess= annotationAccess;
        fWidth= width;
        fSharedTextColors= sharedColors;
        fIsTemporaryAnnotationDiscolored= discolorTemporaryAnnotation;
    }

    /*
     * @see dwtx.jface.text.source.IVerticalRulerInfo#getControl()
     */
    public Control getControl() {
        return fCanvas;
    }

    /*
     * @see dwtx.jface.text.source.IVerticalRulerInfo#getWidth()
     */
    public int getWidth() {
        return fWidth;
    }

    /*
     * @see dwtx.jface.text.source.IVerticalRuler#setModel(dwtx.jface.text.source.IAnnotationModel)
     */
    public void setModel(IAnnotationModel model) {
        if (model !is fModel || model !is null) {

            if (fModel !is null)
                fModel.removeAnnotationModelListener(fInternalListener);

            fModel= model;

            if (fModel !is null)
                fModel.addAnnotationModelListener(fInternalListener);

            update();
        }
    }

    /*
     * @see dwtx.jface.text.source.IVerticalRuler#createControl(dwt.widgets.Composite, dwtx.jface.text.ITextViewer)
     */
    public Control createControl(Composite parent, ITextViewer textViewer) {

        fTextViewer= textViewer;

        fHitDetectionCursor= new Cursor(parent.getDisplay(), DWT.CURSOR_HAND);

        fHeader= new Canvas(parent, DWT.NONE);

        if ( cast(IAnnotationAccessExtension)fAnnotationAccess ) {
            fHeader.addMouseTrackListener(new class()  MouseTrackAdapter {
                /*
                 * @see dwt.events.MouseTrackAdapter#mouseHover(dwt.events.MouseEvent)
                 * @since 3.3
                 */
                public void mouseEnter(MouseEvent e) {
                    updateHeaderToolTipText();
                }
            });
        }

        fCanvas= new Canvas(parent, DWT.NO_BACKGROUND);

        fCanvas.addPaintListener(new class()  PaintListener {
            public void paintControl(PaintEvent event) {
                if (fTextViewer !is null)
                    doubleBufferPaint(event.gc);
            }
        });

        fCanvas.addDisposeListener(new class()  DisposeListener {
            public void widgetDisposed(DisposeEvent event) {
                handleDispose();
                fTextViewer= null;
            }
        });

        fCanvas.addMouseListener(new class()  MouseAdapter {
            public void mouseDown(MouseEvent event) {
                handleMouseDown(event);
            }
        });

        fCanvas.addMouseMoveListener(new class()  MouseMoveListener {
            public void mouseMove(MouseEvent event) {
                handleMouseMove(event);
            }
        });

        if (fTextViewer !is null)
            fTextViewer.addTextListener(fInternalListener);

        return fCanvas;
    }

    /**
     * Disposes the ruler's resources.
     */
    private void handleDispose() {

        if (fTextViewer !is null) {
            fTextViewer.removeTextListener(fInternalListener);
            fTextViewer= null;
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
        fConfiguredHeaderAnnotationTypes.clear();
        fAllowedHeaderAnnotationTypes.clear();
        fAnnotationTypes2Colors.clear();
        fAnnotationsSortedByLayer.clear();
        fLayersSortedByLayer.clear();
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
        try {
            gc.setBackground(fCanvas.getBackground());
            gc.fillRectangle(0, 0, size.x, size.y);

            cacheAnnotations();

            if ( cast(ITextViewerExtension5)fTextViewer )
                doPaint1(gc);
            else
                doPaint(gc);

        } finally {
            gc.dispose();
        }

        dest.drawImage(fBuffer, 0, 0);
    }

    /**
     * Draws this overview ruler.
     *
     * @param gc the GC to draw into
     */
    private void doPaint(GC gc) {

        Rectangle r= new Rectangle(0, 0, 0, 0);
        int yy, hh= ANNOTATION_HEIGHT;

        IDocument document= fTextViewer.getDocument();
        IRegion visible= fTextViewer.getVisibleRegion();

        StyledText textWidget= fTextViewer.getTextWidget();
        int maxLines= textWidget.getLineCount();

        Point size= fCanvas.getSize();
        int writable= JFaceTextUtil.computeLineHeight(textWidget, 0, maxLines, maxLines);

        if (size.y > writable)
            size.y= Math.max(writable - fHeader.getSize().y, 0);

        for (Iterator iterator= fAnnotationsSortedByLayer.iterator(); iterator.hasNext();) {
            Object annotationType= iterator.next();

            if (skip(annotationType))
                continue;

            int[] style= [ FilterIterator.PERSISTENT, FilterIterator.TEMPORARY ];
            for (int t=0; t < style.length; t++) {

                Iterator e= new FilterIterator(annotationType, style[t], fCachedAnnotations.iterator());
                Color fill= getFillColor(annotationType, style[t] is FilterIterator.TEMPORARY);
                Color stroke= getStrokeColor(annotationType, style[t] is FilterIterator.TEMPORARY);

                for (int i= 0; e.hasNext(); i++) {

                    Annotation a= cast(Annotation) e.next();
                    Position p= fModel.getPosition(a);

                    if (p is null || !p.overlapsWith(visible.getOffset(), visible.getLength()))
                        continue;

                    int annotationOffset= Math.max(p.getOffset(), visible.getOffset());
                    int annotationEnd= Math.min(p.getOffset() + p.getLength(), visible.getOffset() + visible.getLength());
                    int annotationLength= annotationEnd - annotationOffset;

                    try {
                        if (ANNOTATION_HEIGHT_SCALABLE) {
                            int numbersOfLines= document.getNumberOfLines(annotationOffset, annotationLength);
                            // don't count empty trailing lines
                            IRegion lastLine= document.getLineInformationOfOffset(annotationOffset + annotationLength);
                            if (lastLine.getOffset() is annotationOffset + annotationLength) {
                                numbersOfLines -= 2;
                                hh= (numbersOfLines * size.y) / maxLines + ANNOTATION_HEIGHT;
                                if (hh < ANNOTATION_HEIGHT)
                                    hh= ANNOTATION_HEIGHT;
                            } else
                                hh= ANNOTATION_HEIGHT;
                        }
                        fAnnotationHeight= hh;

                        int startLine= textWidget.getLineAtOffset(annotationOffset - visible.getOffset());
                        yy= Math.min((startLine * size.y) / maxLines, size.y - hh);

                        if (fill !is null) {
                            gc.setBackground(fill);
                            gc.fillRectangle(INSET, yy, size.x-(2*INSET), hh);
                        }

                        if (stroke !is null) {
                            gc.setForeground(stroke);
                            r.x= INSET;
                            r.y= yy;
                            r.width= size.x - (2 * INSET);
                            r.height= hh;
                            gc.setLineWidth(0); // NOTE: 0 means width is 1 but with optimized performance
                            gc.drawRectangle(r);
                        }
                    } catch (BadLocationException x) {
                    }
                }
            }
        }
    }

    private void cacheAnnotations() {
        fCachedAnnotations.clear();
        if (fModel !is null) {
            Iterator iter= fModel.getAnnotationIterator();
            while (iter.hasNext()) {
                Annotation annotation= cast(Annotation) iter.next();

                if (annotation.isMarkedDeleted())
                    continue;

                if (skip(annotation.getType()))
                    continue;

                fCachedAnnotations.add(annotation);
            }
        }
    }

    /**
     * Draws this overview ruler. Uses <code>ITextViewerExtension5</code> for
     * its implementation. Will replace <code>doPaint(GC)</code>.
     *
     * @param gc the GC to draw into
     */
    private void doPaint1(GC gc) {

        Rectangle r= new Rectangle(0, 0, 0, 0);
        int yy, hh= ANNOTATION_HEIGHT;

        ITextViewerExtension5 extension= cast(ITextViewerExtension5) fTextViewer;
        IDocument document= fTextViewer.getDocument();
        StyledText textWidget= fTextViewer.getTextWidget();

        int maxLines= textWidget.getLineCount();
        Point size= fCanvas.getSize();
        int writable= JFaceTextUtil.computeLineHeight(textWidget, 0, maxLines, maxLines);
        if (size.y > writable)
            size.y= Math.max(writable - fHeader.getSize().y, 0);

        for (Iterator iterator= fAnnotationsSortedByLayer.iterator(); iterator.hasNext();) {
            Object annotationType= iterator.next();

            if (skip(annotationType))
                continue;

            int[] style= [ FilterIterator.PERSISTENT, FilterIterator.TEMPORARY ];
            for (int t=0; t < style.length; t++) {

                Iterator e= new FilterIterator(annotationType, style[t], fCachedAnnotations.iterator());
                Color fill= getFillColor(annotationType, style[t] is FilterIterator.TEMPORARY);
                Color stroke= getStrokeColor(annotationType, style[t] is FilterIterator.TEMPORARY);

                for (int i= 0; e.hasNext(); i++) {

                    Annotation a= cast(Annotation) e.next();
                    Position p= fModel.getPosition(a);

                    if (p is null)
                        continue;

                    IRegion widgetRegion= extension.modelRange2WidgetRange(new Region(p.getOffset(), p.getLength()));
                    if (widgetRegion is null)
                        continue;

                    try {
                        if (ANNOTATION_HEIGHT_SCALABLE) {
                            int numbersOfLines= document.getNumberOfLines(p.getOffset(), p.getLength());
                            // don't count empty trailing lines
                            IRegion lastLine= document.getLineInformationOfOffset(p.getOffset() + p.getLength());
                            if (lastLine.getOffset() is p.getOffset() + p.getLength()) {
                                numbersOfLines -= 2;
                                hh= (numbersOfLines * size.y) / maxLines + ANNOTATION_HEIGHT;
                                if (hh < ANNOTATION_HEIGHT)
                                    hh= ANNOTATION_HEIGHT;
                            } else
                                hh= ANNOTATION_HEIGHT;
                        }
                        fAnnotationHeight= hh;

                        int startLine= textWidget.getLineAtOffset(widgetRegion.getOffset());
                        yy= Math.min((startLine * size.y) / maxLines, size.y - hh);

                        if (fill !is null) {
                            gc.setBackground(fill);
                            gc.fillRectangle(INSET, yy, size.x-(2*INSET), hh);
                        }

                        if (stroke !is null) {
                            gc.setForeground(stroke);
                            r.x= INSET;
                            r.y= yy;
                            r.width= size.x - (2 * INSET);
                            r.height= hh;
                            gc.setLineWidth(0); // NOTE: 0 means width is 1 but with optimized performance
                            gc.drawRectangle(r);
                        }
                    } catch (BadLocationException x) {
                    }
                }
            }
        }
    }

    /*
     * @see dwtx.jface.text.source.IVerticalRuler#update()
     */
     public void update() {
        if (fCanvas !is null && !fCanvas.isDisposed()) {
            Display d= fCanvas.getDisplay();
            if (d !is null) {
                synchronized (fRunnableLock) {
                    if (fIsRunnablePosted)
                        return;
                    fIsRunnablePosted= true;
                }
                d.asyncExec(fRunnable);
            }
        }
    }

    /**
     * Redraws the overview ruler.
     */
    private void redraw() {
        if (fTextViewer is null || fModel is null)
            return;

        if (fCanvas !is null && !fCanvas.isDisposed()) {
            GC gc= new GC(fCanvas);
            doubleBufferPaint(gc);
            gc.dispose();
        }
    }

    /**
     * Translates a given y-coordinate of this ruler into the corresponding
     * document lines. The number of lines depends on the concrete scaling
     * given as the ration between the height of this ruler and the length
     * of the document.
     *
     * @param y_coordinate the y-coordinate
     * @return the corresponding document lines
     */
    private int[] toLineNumbers(int y_coordinate) {

        StyledText textWidget=  fTextViewer.getTextWidget();
        int maxLines= textWidget.getContent().getLineCount();

        int rulerLength= fCanvas.getSize().y;
        int writable= JFaceTextUtil.computeLineHeight(textWidget, 0, maxLines, maxLines);

        if (rulerLength > writable)
            rulerLength= Math.max(writable - fHeader.getSize().y, 0);

        if (y_coordinate >= writable || y_coordinate >= rulerLength)
            return [-1, -1];

        int[] lines= new int[2];

        int pixel0= Math.max(y_coordinate - 1, 0);
        int pixel1= Math.min(rulerLength, y_coordinate + 1);
        rulerLength= Math.max(rulerLength, 1);

        lines[0]= (pixel0 * maxLines) / rulerLength;
        lines[1]= (pixel1 * maxLines) / rulerLength;

        if ( cast(ITextViewerExtension5)fTextViewer ) {
            ITextViewerExtension5 extension= cast(ITextViewerExtension5) fTextViewer;
            lines[0]= extension.widgetLine2ModelLine(lines[0]);
            lines[1]= extension.widgetLine2ModelLine(lines[1]);
        } else {
            try {
                IRegion visible= fTextViewer.getVisibleRegion();
                int lineNumber= fTextViewer.getDocument().getLineOfOffset(visible.getOffset());
                lines[0] += lineNumber;
                lines[1] += lineNumber;
            } catch (BadLocationException x) {
            }
        }

        return lines;
    }

    /**
     * Returns the position of the first annotation found in the given line range.
     *
     * @param lineNumbers the line range
     * @return the position of the first found annotation
     */
    private Position getAnnotationPosition(int[] lineNumbers) {
        if (lineNumbers[0] is -1)
            return null;

        Position found= null;

        try {
            IDocument d= fTextViewer.getDocument();
            IRegion line= d.getLineInformation(lineNumbers[0]);

            int start= line.getOffset();

            line= d.getLineInformation(lineNumbers[lineNumbers.length - 1]);
            int end= line.getOffset() + line.getLength();

            for (int i= fAnnotationsSortedByLayer.size() -1; i >= 0; i--) {

                Object annotationType= fAnnotationsSortedByLayer.get(i);

                Iterator e= new FilterIterator(annotationType, FilterIterator.PERSISTENT | FilterIterator.TEMPORARY);
                while (e.hasNext() && found is null) {
                    Annotation a= cast(Annotation) e.next();
                    if (a.isMarkedDeleted())
                        continue;

                    if (skip(a.getType()))
                        continue;

                    Position p= fModel.getPosition(a);
                    if (p is null)
                        continue;

                    int posOffset= p.getOffset();
                    int posEnd= posOffset + p.getLength();
                    IRegion region= d.getLineInformationOfOffset(posEnd);
                    // trailing empty lines don't count
                    if (posEnd > posOffset && region.getOffset() is posEnd) {
                        posEnd--;
                        region= d.getLineInformationOfOffset(posEnd);
                    }

                    if (posOffset <= end && posEnd >= start)
                            found= p;
                }
            }
        } catch (BadLocationException x) {
        }

        return found;
    }

    /**
     * Returns the line which  corresponds best to one of
     * the underlying annotations at the given y-coordinate.
     *
     * @param lineNumbers the line numbers
     * @return the best matching line or <code>-1</code> if no such line can be found
     */
    private int findBestMatchingLineNumber(int[] lineNumbers) {
        if (lineNumbers is null || lineNumbers.length < 1)
            return -1;

        try {
            Position pos= getAnnotationPosition(lineNumbers);
            if (pos is null)
                return -1;
            return fTextViewer.getDocument().getLineOfOffset(pos.getOffset());
        } catch (BadLocationException ex) {
            return -1;
        }
    }

    /**
     * Handles mouse clicks.
     *
     * @param event the mouse button down event
     */
    private void handleMouseDown(MouseEvent event) {
        if (fTextViewer !is null) {
            int[] lines= toLineNumbers(event.y);
            Position p= getAnnotationPosition(lines);
            if (p is null && event.button is 1) {
                try {
                    p= new Position(fTextViewer.getDocument().getLineInformation(lines[0]).getOffset(), 0);
                } catch (BadLocationException e) {
                    // do nothing
                }
            }
            if (p !is null) {
                fTextViewer.revealRange(p.getOffset(), p.getLength());
                fTextViewer.setSelectedRange(p.getOffset(), p.getLength());
            }
            fTextViewer.getTextWidget().setFocus();
        }
        fLastMouseButtonActivityLine= toDocumentLineNumber(event.y);
    }

    /**
     * Handles mouse moves.
     *
     * @param event the mouse move event
     */
    private void handleMouseMove(MouseEvent event) {
        if (fTextViewer !is null) {
            int[] lines= toLineNumbers(event.y);
            Position p= getAnnotationPosition(lines);
            Cursor cursor= (p !is null ? fHitDetectionCursor : null);
            if (cursor !is fLastCursor) {
                fCanvas.setCursor(cursor);
                fLastCursor= cursor;
            }
        }
    }

    /*
     * @see dwtx.jface.text.source.IOverviewRuler#addAnnotationType(java.lang.Object)
     */
    public void addAnnotationType(Object annotationType) {
        fConfiguredAnnotationTypes.add(annotationType);
        fAllowedAnnotationTypes.clear();
    }

    /*
     * @see dwtx.jface.text.source.IOverviewRuler#removeAnnotationType(java.lang.Object)
     */
    public void removeAnnotationType(Object annotationType) {
        fConfiguredAnnotationTypes.remove(annotationType);
        fAllowedAnnotationTypes.clear();
    }

    /*
     * @see dwtx.jface.text.source.IOverviewRuler#setAnnotationTypeLayer(java.lang.Object, int)
     */
    public void setAnnotationTypeLayer(Object annotationType, int layer) {
        int j= fAnnotationsSortedByLayer.indexOf(annotationType);
        if (j !is -1) {
            fAnnotationsSortedByLayer.remove(j);
            fLayersSortedByLayer.remove(j);
        }

        if (layer >= 0) {
            int i= 0;
            int size= fLayersSortedByLayer.size();
            while (i < size && layer >= (cast(Integer)fLayersSortedByLayer.get(i)).intValue())
                i++;
            Integer layerObj= new Integer(layer);
            fLayersSortedByLayer.add(i, layerObj);
            fAnnotationsSortedByLayer.add(i, annotationType);
        }
    }

    /*
     * @see dwtx.jface.text.source.IOverviewRuler#setAnnotationTypeColor(java.lang.Object, dwt.graphics.Color)
     */
    public void setAnnotationTypeColor(Object annotationType, Color color) {
        if (color !is null)
            fAnnotationTypes2Colors.put(annotationType, color);
        else
            fAnnotationTypes2Colors.remove(annotationType);
    }

    /**
     * Returns whether the given annotation type should be skipped by the drawing routine.
     *
     * @param annotationType the annotation type
     * @return <code>true</code> if annotation of the given type should be skipped
     */
    private bool skip(Object annotationType) {
        return !contains(annotationType, fAllowedAnnotationTypes, fConfiguredAnnotationTypes);
    }
    private bool skip(String annotationType) {
        return !contains(stringcast(annotationType), fAllowedAnnotationTypes, fConfiguredAnnotationTypes);
    }

    /**
     * Returns whether the given annotation type should be skipped by the drawing routine of the header.
     *
     * @param annotationType the annotation type
     * @return <code>true</code> if annotation of the given type should be skipped
     * @since 3.0
     */
    private bool skipInHeader(Object annotationType) {
        return !contains(annotationType, fAllowedHeaderAnnotationTypes, fConfiguredHeaderAnnotationTypes);
    }

    /**
     * Returns whether the given annotation type is mapped to <code>true</code>
     * in the given <code>allowed</code> map or covered by the <code>configured</code>
     * set.
     *
     * @param annotationType the annotation type
     * @param allowed the map with allowed annotation types mapped to booleans
     * @param configured the set with configured annotation types
     * @return <code>true</code> if annotation is contained, <code>false</code>
     *         otherwise
     * @since 3.0
     */
    private bool contains(Object annotationType, Map allowed, Set configured) {
        Boolean cached= cast(Boolean) allowed.get(annotationType);
        if (cached !is null)
            return cached.booleanValue();

        bool covered= isCovered(annotationType, configured);
        allowed.put(annotationType, covered ? Boolean.TRUE : Boolean.FALSE);
        return covered;
    }

    /**
     * Computes whether the annotations of the given type are covered by the given <code>configured</code>
     * set. This is the case if either the type of the annotation or any of its
     * super types is contained in the <code>configured</code> set.
     *
     * @param annotationType the annotation type
     * @param configured the set with configured annotation types
     * @return <code>true</code> if annotation is covered, <code>false</code>
     *         otherwise
     * @since 3.0
     */
    private bool isCovered(Object annotationType, Set configured) {
        if ( cast(IAnnotationAccessExtension)fAnnotationAccess ) {
            IAnnotationAccessExtension extension= cast(IAnnotationAccessExtension) fAnnotationAccess;
            Iterator e= configured.iterator();
            while (e.hasNext()) {
                if (extension.isSubtype(annotationType,e.next()))
                    return true;
            }
            return false;
        }
        return configured.contains(annotationType);
    }

    /**
     * Returns a specification of a color that lies between the given
     * foreground and background color using the given scale factor.
     *
     * @param fg the foreground color
     * @param bg the background color
     * @param scale the scale factor
     * @return the interpolated color
     */
    private static RGB interpolate(RGB fg, RGB bg, double scale) {
        return new RGB(
            cast(int) ((1.0-scale) * fg.red + scale * bg.red),
            cast(int) ((1.0-scale) * fg.green + scale * bg.green),
            cast(int) ((1.0-scale) * fg.blue + scale * bg.blue)
        );
    }

    /**
     * Returns the grey value in which the given color would be drawn in grey-scale.
     *
     * @param rgb the color
     * @return the grey-scale value
     */
    private static double greyLevel(RGB rgb) {
        if (rgb.red is rgb.green && rgb.green is rgb.blue)
            return rgb.red;
        return  (0.299 * rgb.red + 0.587 * rgb.green + 0.114 * rgb.blue + 0.5);
    }

    /**
     * Returns whether the given color is dark or light depending on the colors grey-scale level.
     *
     * @param rgb the color
     * @return <code>true</code> if the color is dark, <code>false</code> if it is light
     */
    private static bool isDark(RGB rgb) {
        return greyLevel(rgb) > 128;
    }

    /**
     * Returns a color based on the color configured for the given annotation type and the given scale factor.
     *
     * @param annotationType the annotation type
     * @param scale the scale factor
     * @return the computed color
     */
    private Color getColor(Object annotationType, double scale) {
        Color base= findColor(annotationType);
        if (base is null)
            return null;

        RGB baseRGB= base.getRGB();
        RGB background= fCanvas.getBackground().getRGB();

        bool darkBase= isDark(baseRGB);
        bool darkBackground= isDark(background);
        if (darkBase && darkBackground)
            background= new RGB(255, 255, 255);
        else if (!darkBase && !darkBackground)
            background= new RGB(0, 0, 0);

        return fSharedTextColors.getColor(interpolate(baseRGB, background, scale));
    }

    /**
     * Returns the color for the given annotation type
     *
     * @param annotationType the annotation type
     * @return the color
     * @since 3.0
     */
    private Color findColor(Object annotationType) {
        Color color= cast(Color) fAnnotationTypes2Colors.get(annotationType);
        if (color !is null)
            return color;

        if ( cast(IAnnotationAccessExtension)fAnnotationAccess ) {
            IAnnotationAccessExtension extension= cast(IAnnotationAccessExtension) fAnnotationAccess;
            Object[] superTypes= extension.getSupertypes(annotationType);
            if (superTypes !is null) {
                for (int i= 0; i < superTypes.length; i++) {
                    color= cast(Color) fAnnotationTypes2Colors.get(superTypes[i]);
                    if (color !is null)
                        return color;
                }
            }
        }

        return null;
    }

    /**
     * Returns the stroke color for the given annotation type and characteristics.
     *
     * @param annotationType the annotation type
     * @param temporary <code>true</code> if for temporary annotations
     * @return the stroke color
     */
    private Color getStrokeColor(Object annotationType, bool temporary) {
        return getColor(annotationType, temporary && fIsTemporaryAnnotationDiscolored ? 0.5 : 0.2);
    }

    /**
     * Returns the fill color for the given annotation type and characteristics.
     *
     * @param annotationType the annotation type
     * @param temporary <code>true</code> if for temporary annotations
     * @return the fill color
     */
    private Color getFillColor(Object annotationType, bool temporary) {
        return getColor(annotationType, temporary && fIsTemporaryAnnotationDiscolored ? 0.9 : 0.75);
    }

    /*
     * @see IVerticalRulerInfo#getLineOfLastMouseButtonActivity()
     */
    public int getLineOfLastMouseButtonActivity() {
        if (fLastMouseButtonActivityLine >= fTextViewer.getDocument().getNumberOfLines())
            fLastMouseButtonActivityLine= -1;
        return fLastMouseButtonActivityLine;
    }

    /*
     * @see IVerticalRulerInfo#toDocumentLineNumber(int)
     */
    public int toDocumentLineNumber(int y_coordinate) {

        if (fTextViewer is null || y_coordinate is -1)
            return -1;

        int[] lineNumbers= toLineNumbers(y_coordinate);
        int bestLine= findBestMatchingLineNumber(lineNumbers);
        if (bestLine is -1 && lineNumbers.length > 0)
            return lineNumbers[0];
        return  bestLine;
    }

    /*
     * @see dwtx.jface.text.source.IVerticalRuler#getModel()
     */
    public IAnnotationModel getModel() {
        return fModel;
    }

    /*
     * @see dwtx.jface.text.source.IOverviewRuler#getAnnotationHeight()
     */
    public int getAnnotationHeight() {
        return fAnnotationHeight;
    }

    /*
     * @see dwtx.jface.text.source.IOverviewRuler#hasAnnotation(int)
     */
    public bool hasAnnotation(int y) {
        return findBestMatchingLineNumber(toLineNumbers(y)) !is -1;
    }

    /*
     * @see dwtx.jface.text.source.IOverviewRuler#getHeaderControl()
     */
    public Control getHeaderControl() {
        return fHeader;
    }

    /*
     * @see dwtx.jface.text.source.IOverviewRuler#addHeaderAnnotationType(java.lang.Object)
     */
    public void addHeaderAnnotationType(Object annotationType) {
        fConfiguredHeaderAnnotationTypes.add(annotationType);
        fAllowedHeaderAnnotationTypes.clear();
    }

    /*
     * @see dwtx.jface.text.source.IOverviewRuler#removeHeaderAnnotationType(java.lang.Object)
     */
    public void removeHeaderAnnotationType(Object annotationType) {
        fConfiguredHeaderAnnotationTypes.remove(annotationType);
        fAllowedHeaderAnnotationTypes.clear();
    }

    /**
     * Updates the header of this ruler.
     */
    private void updateHeader() {
        if (fHeader is null || fHeader.isDisposed())
            return;

        fHeader.setToolTipText(null);

        Object colorType= null;
        outer: for (int i= fAnnotationsSortedByLayer.size() -1; i >= 0; i--) {
            Object annotationType= fAnnotationsSortedByLayer.get(i);
            if (skipInHeader(annotationType) || skip(annotationType))
                continue;

            Iterator e= new FilterIterator(annotationType, FilterIterator.PERSISTENT | FilterIterator.TEMPORARY | FilterIterator.IGNORE_BAGS, fCachedAnnotations.iterator());
            while (e.hasNext()) {
                if (e.next() !is null) {
                    colorType= annotationType;
                    break outer;
                }
            }
        }

        Color color= null;
        if (colorType !is null)
            color= findColor(colorType);

        if (color is null) {
            if (fHeaderPainter !is null)
                fHeaderPainter.setColor(null);
        }   else {
            if (fHeaderPainter is null) {
                fHeaderPainter= new HeaderPainter();
                fHeader.addPaintListener(fHeaderPainter);
            }
            fHeaderPainter.setColor(color);
        }

        fHeader.redraw();

    }

    /**
     * Updates the header tool tip text of this ruler.
     */
    private void updateHeaderToolTipText() {
        if (fHeader is null || fHeader.isDisposed())
            return;

        if (fHeader.getToolTipText() !is null)
            return;

        String overview= ""; //$NON-NLS-1$

        for (int i= fAnnotationsSortedByLayer.size() -1; i >= 0; i--) {

            Object annotationType= fAnnotationsSortedByLayer.get(i);

            if (skipInHeader(annotationType) || skip(annotationType))
                continue;

            int count= 0;
            String annotationTypeLabel= null;

            Iterator e= new FilterIterator(annotationType, FilterIterator.PERSISTENT | FilterIterator.TEMPORARY | FilterIterator.IGNORE_BAGS, fCachedAnnotations.iterator());
            while (e.hasNext()) {
                Annotation annotation= cast(Annotation)e.next();
                if (annotation !is null) {
                    if (annotationTypeLabel is null)
                        annotationTypeLabel= (cast(IAnnotationAccessExtension)fAnnotationAccess).getTypeLabel(annotation);
                    count++;
                }
            }

            if (annotationTypeLabel !is null) {
                if (overview.length() > 0)
                    overview ~= "\n"; //$NON-NLS-1$
                overview ~= JFaceTextMessages.getFormattedString("OverviewRulerHeader.toolTipTextEntry", stringcast(annotationTypeLabel), new Integer(count) ); //$NON-NLS-1$
            }
        }

        if (overview.length() > 0)
            fHeader.setToolTipText(overview);
    }
}
