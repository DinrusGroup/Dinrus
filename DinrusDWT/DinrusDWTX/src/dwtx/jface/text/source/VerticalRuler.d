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
module dwtx.jface.text.source.VerticalRuler;

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
import dwt.events.PaintEvent;
import dwt.events.PaintListener;
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
import dwtx.jface.text.Region;
import dwtx.jface.text.TextEvent;


/**
 * A vertical ruler which is connected to a text viewer. Single column standard
 * implementation of {@link dwtx.jface.text.source.IVerticalRuler}.
 * <p>
 * The same can be achieved by using <code>CompositeRuler</code> configured
 * with an <code>AnnotationRulerColumn</code>. Clients may use this class as
 * is.
 *
 * @see dwtx.jface.text.ITextViewer
 */
public final class VerticalRuler : IVerticalRuler, IVerticalRulerExtension {

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
            update();
        }

        /*
         * @see ITextListener#textChanged(TextEvent)
         */
        public void textChanged(TextEvent e) {
            if (fTextViewer !is null && e.getViewerRedrawState())
                redraw();
        }
    }

    /** The vertical ruler's text viewer */
    private ITextViewer fTextViewer;
    /** The ruler's canvas */
    private Canvas fCanvas;
    /** The vertical ruler's model */
    private IAnnotationModel fModel;
    /** Cache for the actual scroll position in pixels */
    private int fScrollPos;
    /** The buffer for double buffering */
    private Image fBuffer;
    /** The line of the last mouse button activity */
    private int fLastMouseButtonActivityLine= -1;
    /** The internal listener */
    private InternalListener fInternalListener;
    /** The width of this vertical ruler */
    private int fWidth;
    /**
     * The annotation access of this vertical ruler
     * @since 3.0
     */
    private IAnnotationAccess fAnnotationAccess;

    /**
     * Constructs a vertical ruler with the given width.
     *
     * @param width the width of the vertical ruler
     */
    public this(int width) {
        this(width, null);
    }

    /**
     * Constructs a vertical ruler with the given width and the given annotation
     * access.
     *
     * @param width the width of the vertical ruler
     * @param annotationAcccess the annotation access
     * @since 3.0
     */
    public this(int width, IAnnotationAccess annotationAcccess) {

        fInternalListener= new InternalListener();

        fWidth= width;
        fAnnotationAccess= annotationAcccess;
    }

    /*
     * @see IVerticalRuler#getControl()
     */
    public Control getControl() {
        return fCanvas;
    }

    /*
     * @see IVerticalRuler#createControl(Composite, ITextViewer)
     */
    public Control createControl(Composite parent, ITextViewer textViewer) {

        fTextViewer= textViewer;

        fCanvas= new Canvas(parent, DWT.NO_BACKGROUND);

        fCanvas.addPaintListener(new class()  PaintListener {
            public void paintControl(PaintEvent event) {
                if (fTextViewer !is null)
                    doubleBufferPaint(event.gc);
            }
        });

        fCanvas.addDisposeListener(new class()  DisposeListener {
            public void widgetDisposed(DisposeEvent e) {
                handleDispose();
                fTextViewer= null;
            }
        });

        fCanvas.addMouseListener(new class()  MouseListener {
            public void mouseUp(MouseEvent event) {
            }

            public void mouseDown(MouseEvent event) {
                fLastMouseButtonActivityLine= toDocumentLineNumber(event.y);
            }

            public void mouseDoubleClick(MouseEvent event) {
                fLastMouseButtonActivityLine= toDocumentLineNumber(event.y);
            }
        });

        if (fTextViewer !is null) {
            fTextViewer.addViewportListener(fInternalListener);
            fTextViewer.addTextListener(fInternalListener);
        }

        return fCanvas;
    }

    /**
     * Disposes the ruler's resources.
     */
    private void handleDispose() {

        if (fTextViewer !is null) {
            fTextViewer.removeViewportListener(fInternalListener);
            fTextViewer.removeTextListener(fInternalListener);
            fTextViewer= null;
        }

        if (fModel !is null)
            fModel.removeAnnotationModelListener(fInternalListener);

        if (fBuffer !is null) {
            fBuffer.dispose();
            fBuffer= null;
        }
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
        gc.setFont(fTextViewer.getTextWidget().getFont());
        try {
            gc.setBackground(fCanvas.getBackground());
            gc.fillRectangle(0, 0, size.x, size.y);

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
     * Returns the document offset of the upper left corner of the
     * widgets view port, possibly including partially visible lines.
     *
     * @return the document offset of the upper left corner including partially visible lines
     * @since 2.0
     */
    private int getInclusiveTopIndexStartOffset() {

        StyledText textWidget= fTextViewer.getTextWidget();
        if (textWidget !is null && !textWidget.isDisposed()) {
            int top= JFaceTextUtil.getPartialTopIndex(fTextViewer);
            try {
                IDocument document= fTextViewer.getDocument();
                return document.getLineOffset(top);
            } catch (BadLocationException x) {
            }
        }

        return -1;
    }



    /**
     * Draws the vertical ruler w/o drawing the Canvas background.
     *
     * @param gc  the GC to draw into
     */
    protected void doPaint(GC gc) {

        if (fModel is null || fTextViewer is null)
            return;

        IAnnotationAccessExtension annotationAccessExtension= null;
        if ( cast(IAnnotationAccessExtension)fAnnotationAccess )
            annotationAccessExtension= cast(IAnnotationAccessExtension) fAnnotationAccess;

        StyledText styledText= fTextViewer.getTextWidget();
        IDocument doc= fTextViewer.getDocument();

        int topLeft= getInclusiveTopIndexStartOffset();
        int bottomRight= fTextViewer.getBottomIndexEndOffset();
        int viewPort= bottomRight - topLeft;

        Point d= fCanvas.getSize();
        fScrollPos= styledText.getTopPixel();

        int topLine= -1, bottomLine= -1;
        try {
            IRegion region= fTextViewer.getVisibleRegion();
            topLine= doc.getLineOfOffset(region.getOffset());
            bottomLine= doc.getLineOfOffset(region.getOffset() + region.getLength());
        } catch (BadLocationException x) {
            return;
        }

        // draw Annotations
        Rectangle r= new Rectangle(0, 0, 0, 0);
        int maxLayer= 1;    // loop at least once though layers.

        for (int layer= 0; layer < maxLayer; layer++) {
            Iterator iter= fModel.getAnnotationIterator();
            while (iter.hasNext()) {
                IAnnotationPresentation annotationPresentation= null;
                Annotation annotation= cast(Annotation) iter.next();

                int lay= IAnnotationAccessExtension.DEFAULT_LAYER;
                if (annotationAccessExtension !is null)
                    lay= annotationAccessExtension.getLayer(annotation);
                else if ( cast(IAnnotationPresentation)annotation ) {
                    annotationPresentation= cast(IAnnotationPresentation)annotation;
                    lay= annotationPresentation.getLayer();
                }
                maxLayer= Math.max(maxLayer, lay+1);    // dynamically update layer maximum
                if (lay !is layer)   // wrong layer: skip annotation
                    continue;

                Position position= fModel.getPosition(annotation);
                if (position is null)
                    continue;

                if (!position.overlapsWith(topLeft, viewPort))
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
                    r.y= JFaceTextUtil.computeLineHeight(styledText, 0, startLine, startLine)  - fScrollPos;

                    r.width= d.x;
                    int lines= endLine - startLine;

                    r.height= JFaceTextUtil.computeLineHeight(styledText, startLine, endLine + 1, (lines+1));

                    if (r.y < d.y && annotationAccessExtension !is null)  // annotation within visible area
                        annotationAccessExtension.paint(annotation, gc, fCanvas, r);
                    else if (annotationPresentation !is null)
                        annotationPresentation.paint(gc, fCanvas, r);

                } catch (BadLocationException e) {
                }
            }
        }
    }

    /**
     * Draws the vertical ruler w/o drawing the Canvas background. Uses
     * <code>ITextViewerExtension5</code> for its implementation. Will replace
     * <code>doPaint(GC)</code>.
     *
     * @param gc  the GC to draw into
     */
    protected void doPaint1(GC gc) {

        if (fModel is null || fTextViewer is null)
            return;

        IAnnotationAccessExtension annotationAccessExtension= null;
        if ( cast(IAnnotationAccessExtension)fAnnotationAccess )
            annotationAccessExtension= cast(IAnnotationAccessExtension) fAnnotationAccess;

        ITextViewerExtension5 extension= cast(ITextViewerExtension5) fTextViewer;
        StyledText textWidget= fTextViewer.getTextWidget();

        fScrollPos= textWidget.getTopPixel();
        Point dimension= fCanvas.getSize();

        // draw Annotations
        Rectangle r= new Rectangle(0, 0, 0, 0);
        int maxLayer= 1;    // loop at least once through layers.

        for (int layer= 0; layer < maxLayer; layer++) {
            Iterator iter= fModel.getAnnotationIterator();
            while (iter.hasNext()) {
                IAnnotationPresentation annotationPresentation= null;
                Annotation annotation= cast(Annotation) iter.next();

                int lay= IAnnotationAccessExtension.DEFAULT_LAYER;
                if (annotationAccessExtension !is null)
                    lay= annotationAccessExtension.getLayer(annotation);
                else if ( cast(IAnnotationPresentation)annotation ) {
                    annotationPresentation= cast(IAnnotationPresentation)annotation;
                    lay= annotationPresentation.getLayer();
                }
                maxLayer= Math.max(maxLayer, lay+1);    // dynamically update layer maximum
                if (lay !is layer)   // wrong layer: skip annotation
                    continue;

                Position position= fModel.getPosition(annotation);
                if (position is null)
                    continue;

                IRegion widgetRegion= extension.modelRange2WidgetRange(new Region(position.getOffset(), position.getLength()));
                if (widgetRegion is null)
                    continue;

                int startLine= extension.widgetLineOfWidgetOffset(widgetRegion.getOffset());
                if (startLine is -1)
                    continue;

                int endLine= extension.widgetLineOfWidgetOffset(widgetRegion.getOffset() + Math.max(widgetRegion.getLength() -1, 0));
                if (endLine is -1)
                    continue;

                r.x= 0;
                r.y= JFaceTextUtil.computeLineHeight(textWidget, 0, startLine, startLine)  - fScrollPos;

                r.width= dimension.x;
                int lines= endLine - startLine;

                r.height= JFaceTextUtil.computeLineHeight(textWidget, startLine, endLine + 1, lines+1);

                if (r.y < dimension.y && annotationAccessExtension !is null)  // annotation within visible area
                    annotationAccessExtension.paint(annotation, gc, fCanvas, r);
                else if (annotationPresentation !is null)
                    annotationPresentation.paint(gc, fCanvas, r);
            }
        }
    }

    /**
     * Thread-safe implementation.
     * Can be called from any thread.
     */
    /*
     * @see IVerticalRuler#update()
     */
    public void update() {
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

    /**
     * Redraws the vertical ruler.
     */
    private void redraw() {
        if (fCanvas !is null && !fCanvas.isDisposed()) {
            GC gc= new GC(fCanvas);
            doubleBufferPaint(gc);
            gc.dispose();
        }
    }

    /*
     * @see IVerticalRuler#setModel(IAnnotationModel)
     */
    public void setModel(IAnnotationModel model) {
        if (model !is fModel) {

            if (fModel !is null)
                fModel.removeAnnotationModelListener(fInternalListener);

            fModel= model;

            if (fModel !is null)
                fModel.addAnnotationModelListener(fInternalListener);

            update();
        }
    }

    /*
     * @see IVerticalRuler#getModel()
     */
    public IAnnotationModel getModel() {
        return fModel;
    }

    /*
     * @see IVerticalRulerInfo#getWidth()
     */
    public int getWidth() {
        return fWidth;
    }

    /*
     * @see IVerticalRulerInfo#getLineOfLastMouseButtonActivity()
     */
    public int getLineOfLastMouseButtonActivity() {
        IDocument doc= fTextViewer.getDocument();
        if (doc is null || fLastMouseButtonActivityLine >= fTextViewer.getDocument().getNumberOfLines())
            fLastMouseButtonActivityLine= -1;
        return fLastMouseButtonActivityLine;
    }

    /*
     * @see IVerticalRulerInfo#toDocumentLineNumber(int)
     */
    public int toDocumentLineNumber(int y_coordinate) {
        if (fTextViewer is null  || y_coordinate is -1)
            return -1;

        StyledText text= fTextViewer.getTextWidget();
        int line= text.getLineIndex(y_coordinate);

        if (line is text.getLineCount() - 1) {
            // check whether y_coordinate exceeds last line
            if (y_coordinate > text.getLinePixel(line + 1))
                return -1;
        }

        return widgetLine2ModelLine(fTextViewer, line);
    }

    /**
     * Returns the line of the viewer's document that corresponds to the given widget line.
     *
     * @param viewer the viewer
     * @param widgetLine the widget line
     * @return the corresponding line of the viewer's document
     * @since 2.1
     */
    protected final static int widgetLine2ModelLine(ITextViewer viewer, int widgetLine) {

        if ( cast(ITextViewerExtension5)viewer ) {
            ITextViewerExtension5 extension= cast(ITextViewerExtension5) viewer;
            return extension.widgetLine2ModelLine(widgetLine);
        }

        try {
            IRegion r= viewer.getVisibleRegion();
            IDocument d= viewer.getDocument();
            return widgetLine += d.getLineOfOffset(r.getOffset());
        } catch (BadLocationException x) {
        }
        return widgetLine;
    }

    /*
     * @see IVerticalRulerExtension#setFont(Font)
     * @since 2.0
     */
    public void setFont(Font font) {
    }

    /*
     * @see IVerticalRulerExtension#setLocationOfLastMouseButtonActivity(int, int)
     * @since 2.0
     */
    public void setLocationOfLastMouseButtonActivity(int x, int y) {
        fLastMouseButtonActivityLine= toDocumentLineNumber(y);
    }

    /**
     * Adds the given mouse listener.
     *
     * @param listener the listener to be added
     * @deprecated will be removed
     * @since 2.0
     */
    public void addMouseListener(MouseListener listener) {
        if (fCanvas !is null && !fCanvas.isDisposed())
            fCanvas.addMouseListener(listener);
    }

    /**
     * Removes the given mouse listener.
     *
     * @param listener the listener to be removed
     * @deprecated will be removed
     * @since 2.0
     */
    public void removeMouseListener(MouseListener listener) {
        if (fCanvas !is null && !fCanvas.isDisposed())
            fCanvas.removeMouseListener(listener);
    }
}
