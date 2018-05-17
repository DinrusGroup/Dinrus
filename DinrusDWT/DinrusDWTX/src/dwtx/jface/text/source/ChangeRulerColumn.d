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
module dwtx.jface.text.source.ChangeRulerColumn;

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





import dwt.DWT;
import dwt.custom.StyledText;
import dwt.events.DisposeEvent;
import dwt.events.DisposeListener;
import dwt.events.MouseEvent;
import dwt.events.MouseListener;
import dwt.events.MouseMoveListener;
import dwt.events.PaintEvent;
import dwt.events.PaintListener;
import dwt.graphics.Color;
import dwt.graphics.Font;
import dwt.graphics.GC;
import dwt.graphics.Image;
import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwt.widgets.Canvas;
import dwt.widgets.Composite;
import dwt.widgets.Control;
import dwt.widgets.Display;
import dwtx.core.runtime.Assert;
import dwtx.jface.internal.text.revisions.RevisionPainter;
import dwtx.jface.internal.text.source.DiffPainter;
import dwtx.jface.text.BadLocationException;
import dwtx.jface.text.IDocument;
import dwtx.jface.text.IRegion;
import dwtx.jface.text.ITextListener;
import dwtx.jface.text.ITextViewer;
import dwtx.jface.text.ITextViewerExtension5;
import dwtx.jface.text.IViewportListener;
import dwtx.jface.text.JFaceTextUtil;
import dwtx.jface.text.TextEvent;
import dwtx.jface.text.revisions.IRevisionRulerColumn;
import dwtx.jface.text.revisions.RevisionInformation;
import dwtx.jface.viewers.ISelectionProvider;

/**
 * A vertical ruler column displaying line numbers and serving as a UI for quick diff.
 * Clients instantiate and configure object of this class.
 *
 * @since 3.0
 */
public final class ChangeRulerColumn : IVerticalRulerColumn, IVerticalRulerInfo, IVerticalRulerInfoExtension, IChangeRulerColumn, IRevisionRulerColumn {
    /**
     * Handles all the mouse interaction in this line number ruler column.
     */
    private class MouseHandler : MouseListener, MouseMoveListener {

        /*
         * @see dwt.events.MouseListener#mouseUp(dwt.events.MouseEvent)
         */
        public void mouseUp(MouseEvent event) {
        }

        /*
         * @see dwt.events.MouseListener#mouseDown(dwt.events.MouseEvent)
         */
        public void mouseDown(MouseEvent event) {
            fParentRuler.setLocationOfLastMouseButtonActivity(event.x, event.y);
        }

        /*
         * @see dwt.events.MouseListener#mouseDoubleClick(dwt.events.MouseEvent)
         */
        public void mouseDoubleClick(MouseEvent event) {
            fParentRuler.setLocationOfLastMouseButtonActivity(event.x, event.y);
        }

        /*
         * @see dwt.events.MouseMoveListener#mouseMove(dwt.events.MouseEvent)
         */
        public void mouseMove(MouseEvent event) {
            fParentRuler.setLocationOfLastMouseButtonActivity(event.x, event.y);
        }
    }

    /**
     * Internal listener class.
     */
    private class InternalListener : IViewportListener, ITextListener {

        /*
         * @see IViewportListener#viewportChanged(int)
         */
        public void viewportChanged(int verticalPosition) {
            if (verticalPosition !is fScrollPos)
                redraw();
        }

        /*
         * @see ITextListener#textChanged(TextEvent)
         */
        public void textChanged(TextEvent event) {

            if (!event.getViewerRedrawState())
                return;

            if (fSensitiveToTextChanges || event.getDocumentEvent() is null)
                postRedraw();

        }
    }

    /**
     * The view(port) listener.
     */
    private /+const+/ InternalListener fInternalListener;
    /**
     * The mouse handler.
     * @since 3.2
     */
    private /+const+/ MouseHandler fMouseHandler;
    /**
     * The revision painter.
     * @since 3.2
     */
    private const RevisionPainter fRevisionPainter;
    /**
     * The diff info painter.
     * @since 3.2
     */
    private const DiffPainter fDiffPainter;

    /** This column's parent ruler */
    private CompositeRuler fParentRuler;
    /** Cached text viewer */
    private ITextViewer fCachedTextViewer;
    /** Cached text widget */
    private StyledText fCachedTextWidget;
    /** The columns canvas */
    private Canvas fCanvas;
    /** The background color */
    private Color fBackground;
    /** The ruler's annotation model. */
    private IAnnotationModel fAnnotationModel;
    /** The width of the change ruler column. */
    private const int fWidth= 5;

    /** Cache for the actual scroll position in pixels */
    private int fScrollPos;
    /** The buffer for double buffering */
    private Image fBuffer;
    /** Indicates whether this column reacts on text change events */
    private bool fSensitiveToTextChanges= false;

    private void instanceInit(){
        fInternalListener= new InternalListener();
        fMouseHandler= new MouseHandler();
    }
    /**
     * Creates a new ruler column.
     *
     * @deprecated since 3.2 use {@link #ChangeRulerColumn(ISharedTextColors)} instead
     */
    public this() {
        instanceInit();
        fRevisionPainter= null;
        fDiffPainter= new DiffPainter(this, null);
    }

    /**
     * Creates a new revision ruler column.
     *
     * @param sharedColors the colors to look up RGBs
     * @since 3.2
     */
    public this(ISharedTextColors sharedColors) {
        instanceInit();
        Assert.isNotNull(cast(Object)sharedColors);
        fRevisionPainter= new RevisionPainter(this, sharedColors);
        fDiffPainter= new DiffPainter(this, null); // no shading
    }

    /**
     * Returns the System background color for list widgets.
     *
     * @return the System background color for list widgets
     */
    private Color getBackground() {
        if (fBackground is null)
            return fCachedTextWidget.getDisplay().getSystemColor(DWT.COLOR_LIST_BACKGROUND);
        return fBackground;
    }

    /*
     * @see IVerticalRulerColumn#createControl(CompositeRuler, Composite)
     */
    public Control createControl(CompositeRuler parentRuler, Composite parentControl) {

        fParentRuler= parentRuler;
        fCachedTextViewer= parentRuler.getTextViewer();
        fCachedTextWidget= fCachedTextViewer.getTextWidget();

        fCanvas= new Canvas(parentControl, DWT.NONE);
        fCanvas.setBackground(getBackground());

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

        fCanvas.addMouseListener(fMouseHandler);
        fCanvas.addMouseMoveListener(fMouseHandler);

        if (fCachedTextViewer !is null) {

            fCachedTextViewer.addViewportListener(fInternalListener);
            fCachedTextViewer.addTextListener(fInternalListener);
        }

        fRevisionPainter.setParentRuler(parentRuler);
        fDiffPainter.setParentRuler(parentRuler);

        return fCanvas;
    }

    /**
     * Disposes the column's resources.
     */
    protected void handleDispose() {

        if (fCachedTextViewer !is null) {
            fCachedTextViewer.removeViewportListener(fInternalListener);
            fCachedTextViewer.removeTextListener(fInternalListener);
        }

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
        gc.setFont(fCanvas.getFont());

        try {
            gc.setBackground(getBackground());
            gc.fillRectangle(0, 0, size.x, size.y);

            doPaint(gc);
        } finally {
            gc.dispose();
        }

        dest.drawImage(fBuffer, 0, 0);
    }

    /**
     * Returns the view port height in lines.
     *
     * @return the view port height in lines
     * @deprecated as of 3.2 the number of lines in the viewport cannot be computed because
     *             StyledText supports variable line heights
     */
    protected int getVisibleLinesInViewport() {
        // Hack to reduce amount of copied code.
        return LineNumberRulerColumn.getVisibleLinesInViewport(fCachedTextWidget);
    }

    /**
     * Returns <code>true</code> if the viewport displays the entire viewer contents, i.e. the
     * viewer is not vertically scrollable.
     *
     * @return <code>true</code> if the viewport displays the entire contents, <code>false</code> otherwise
     * @since 3.2
     */
    protected final bool isViewerCompletelyShown() {
        return JFaceTextUtil.isShowingEntireContents(fCachedTextWidget);
    }

    /**
     * Draws the ruler column.
     *
     * @param gc the GC to draw into
     */
    private void doPaint(GC gc) {
        ILineRange visibleModelLines= computeVisibleModelLines();
        if (visibleModelLines is null)
            return;

        fSensitiveToTextChanges= isViewerCompletelyShown();

        fScrollPos= fCachedTextWidget.getTopPixel();

        fRevisionPainter.paint(gc, visibleModelLines);
        if (!fRevisionPainter.hasInformation()) // don't paint quick diff colors if revisions are painted
            fDiffPainter.paint(gc, visibleModelLines);
    }

    /*
     * @see IVerticalRulerColumn#redraw()
     */
    public void redraw() {

        if (fCachedTextViewer !is null && fCanvas !is null && !fCanvas.isDisposed()) {
            GC gc= new GC(fCanvas);
            doubleBufferPaint(gc);
            gc.dispose();
        }
    }

    /*
     * @see IVerticalRulerColumn#setFont(Font)
     */
    public void setFont(Font font) {
    }

    /**
     * Returns the parent (composite) ruler of this ruler column.
     *
     * @return the parent ruler
     * @since 3.0
     */
    private CompositeRuler getParentRuler() {
        return fParentRuler;
    }

    /*
     * @see dwtx.jface.text.source.IVerticalRulerInfo#getLineOfLastMouseButtonActivity()
     */
    public int getLineOfLastMouseButtonActivity() {
        return getParentRuler().getLineOfLastMouseButtonActivity();
    }

    /*
     * @see dwtx.jface.text.source.IVerticalRulerInfo#toDocumentLineNumber(int)
     */
    public int toDocumentLineNumber(int y_coordinate) {
        return getParentRuler().toDocumentLineNumber(y_coordinate);
    }

    /*
     * @see dwtx.jface.text.source.IVerticalRulerInfoExtension#getHover()
     */
    public IAnnotationHover getHover() {
        int activeLine= getParentRuler().getLineOfLastMouseButtonActivity();
        if (fRevisionPainter.hasHover(activeLine))
            return fRevisionPainter.getHover();
        if (fDiffPainter.hasHover(activeLine))
            return fDiffPainter.getHover();
        return null;
    }

    /*
     * @see dwtx.jface.text.source.IChangeRulerColumn#setHover(dwtx.jface.text.source.IAnnotationHover)
     */
    public void setHover(IAnnotationHover hover) {
        fRevisionPainter.setHover(hover);
        fDiffPainter.setHover(hover);
    }

    /*
     * @see IVerticalRulerColumn#setModel(IAnnotationModel)
     */
    public void setModel(IAnnotationModel model) {
        setAnnotationModel(model);
        fRevisionPainter.setModel(model);
        fDiffPainter.setModel(model);
    }

    private void setAnnotationModel(IAnnotationModel model) {
        if (fAnnotationModel !is model)
            fAnnotationModel= model;
    }

    /*
     * @see dwtx.jface.text.source.IChangeRulerColumn#setBackground(dwt.graphics.Color)
     */
    public void setBackground(Color background) {
        fBackground= background;
        if (fCanvas !is null && !fCanvas.isDisposed())
            fCanvas.setBackground(getBackground());
        fRevisionPainter.setBackground(background);
        fDiffPainter.setBackground(background);
    }

    /*
     * @see dwtx.jface.text.source.IChangeRulerColumn#setAddedColor(dwt.graphics.Color)
     */
    public void setAddedColor(Color addedColor) {
        fDiffPainter.setAddedColor(addedColor);
    }

    /*
     * @see dwtx.jface.text.source.IChangeRulerColumn#setChangedColor(dwt.graphics.Color)
     */
    public void setChangedColor(Color changedColor) {
        fDiffPainter.setChangedColor(changedColor);
    }

    /*
     * @see dwtx.jface.text.source.IChangeRulerColumn#setDeletedColor(dwt.graphics.Color)
     */
    public void setDeletedColor(Color deletedColor) {
        fDiffPainter.setDeletedColor(deletedColor);
    }

    /*
     * @see dwtx.jface.text.source.IVerticalRulerInfoExtension#getModel()
     */
    public IAnnotationModel getModel() {
        return fAnnotationModel;
    }

    /*
     * @see IVerticalRulerColumn#getControl()
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

    /**
     * Triggers a redraw in the display thread.
     */
    protected final void postRedraw() {
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
     * @see dwtx.jface.text.source.IVerticalRulerInfoExtension#addVerticalRulerListener(dwtx.jface.text.source.IVerticalRulerListener)
     */
    public void addVerticalRulerListener(IVerticalRulerListener listener) {
        throw new UnsupportedOperationException();
    }

    /*
     * @see dwtx.jface.text.source.IVerticalRulerInfoExtension#removeVerticalRulerListener(dwtx.jface.text.source.IVerticalRulerListener)
     */
    public void removeVerticalRulerListener(IVerticalRulerListener listener) {
        throw new UnsupportedOperationException();
    }

    /**
     * Computes the document based line range visible in the text widget.
     *
     * @return the document based line range visible in the text widget
     * @since 3.2
     */
    private final ILineRange computeVisibleModelLines() {
        IDocument doc= fCachedTextViewer.getDocument();
        if (doc is null)
            return null;

        int topLine;
        IRegion coverage;

        if ( cast(ITextViewerExtension5)fCachedTextViewer ) {
            ITextViewerExtension5 extension= cast(ITextViewerExtension5) fCachedTextViewer;

            // ITextViewer.getTopIndex returns the fully visible line, but we want the partially
            // visible one
            int widgetTopLine= JFaceTextUtil.getPartialTopIndex(fCachedTextWidget);
            topLine= extension.widgetLine2ModelLine(widgetTopLine);

            coverage= extension.getModelCoverage();

        } else {
            topLine= JFaceTextUtil.getPartialTopIndex(fCachedTextViewer);
            coverage= fCachedTextViewer.getVisibleRegion();
        }

        int bottomLine= fCachedTextViewer.getBottomIndex();
        if (bottomLine !is -1)
            ++ bottomLine;

        // clip by coverage window
        try {
            int firstLine= doc.getLineOfOffset(coverage.getOffset());
            if (firstLine > topLine)
                topLine= firstLine;

            int lastLine= doc.getLineOfOffset(coverage.getOffset() + coverage.getLength());
            if (lastLine < bottomLine || bottomLine is -1)
                bottomLine= lastLine;
        } catch (BadLocationException x) {
            ExceptionPrintStackTrace(x);
            return null;
        }

        ILineRange visibleModelLines= new LineRange(topLine, bottomLine - topLine + 1);
        return visibleModelLines;
    }

    /*
     * @see dwtx.jface.text.revisions.IRevisionRulerColumn#setRevisionInformation(dwtx.jface.text.revisions.RevisionInformation)
     */
    public void setRevisionInformation(RevisionInformation info) {
        fRevisionPainter.setRevisionInformation(info);
        fRevisionPainter.setBackground(getBackground());
    }

    /**
     * Returns the revision selection provider.
     *
     * @return the revision selection provider
     * @since 3.2
     */
    public ISelectionProvider getRevisionSelectionProvider() {
        return fRevisionPainter.getRevisionSelectionProvider();
    }
}
