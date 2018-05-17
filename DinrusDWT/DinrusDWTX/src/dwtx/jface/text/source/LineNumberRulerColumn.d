/*******************************************************************************
 * Copyright (c) 2000, 2008 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *     Nikolay Botev <bono8106@hotmail.com> - [rulers] Shift clicking in line number column doesn't select range - https://bugs.eclipse.org/bugs/show_bug.cgi?id=32166
 *     Nikolay Botev <bono8106@hotmail.com> - [rulers] Clicking in line number ruler should not trigger annotation ruler - https://bugs.eclipse.org/bugs/show_bug.cgi?id=40889
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/
module dwtx.jface.text.source.LineNumberRulerColumn;

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
import dwt.graphics.Color;
import dwt.graphics.Font;
import dwt.graphics.FontMetrics;
import dwt.graphics.GC;
import dwt.graphics.Image;
import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwt.widgets.Canvas;
import dwt.widgets.Composite;
import dwt.widgets.Control;
import dwt.widgets.Display;
import dwt.widgets.TypedListener;
import dwtx.jface.text.BadLocationException;
import dwtx.jface.text.IDocument;
import dwtx.jface.text.IRegion;
import dwtx.jface.text.ITextListener;
import dwtx.jface.text.ITextViewer;
import dwtx.jface.text.ITextViewerExtension;
import dwtx.jface.text.ITextViewerExtension5;
import dwtx.jface.text.IViewportListener;
import dwtx.jface.text.JFaceTextUtil;
import dwtx.jface.text.TextEvent;


/**
 * A vertical ruler column displaying line numbers.
 * Clients usually instantiate and configure object of this class.
 *
 * @since 2.0
 */
public class LineNumberRulerColumn : IVerticalRulerColumn {

    /**
     * Internal listener class.
     */
    class InternalListener : IViewportListener, ITextListener {

        /**
         * @since 3.1
         */
        private bool fCachedRedrawState= true;

        /*
         * @see IViewportListener#viewportChanged(int)
         */
        public void viewportChanged(int verticalPosition) {
            if (fCachedRedrawState && verticalPosition !is fScrollPos)
                redraw();
        }

        /*
         * @see ITextListener#textChanged(TextEvent)
         */
        public void textChanged(TextEvent event) {

            fCachedRedrawState= event.getViewerRedrawState();
            if (!fCachedRedrawState)
                return;

            if (updateNumberOfDigits()) {
                computeIndentations();
                layout(event.getViewerRedrawState());
                return;
            }

            bool viewerCompletelyShown= isViewerCompletelyShown();
            if (viewerCompletelyShown || fSensitiveToTextChanges || event.getDocumentEvent() is null)
                postRedraw();
            fSensitiveToTextChanges= viewerCompletelyShown;
        }
    }

    /**
     * Handles all the mouse interaction in this line number ruler column.
     */
    class MouseHandler : MouseListener, MouseMoveListener {

        /** The cached view port size. */
        private int fCachedViewportSize;
        /** The area of the line at which line selection started. */
        private int fStartLineOffset;
        /** The number of the line at which line selection started. */
        private int fStartLineNumber;
        /** The auto scroll direction. */
        private int fAutoScrollDirection;
        /* @since 3.2 */
        private bool fIsListeningForMove= false;

        /*
         * @see dwt.events.MouseListener#mouseUp(dwt.events.MouseEvent)
         */
        public void mouseUp(MouseEvent event) {
            // see bug 45700
            if (event.button is 1) {
                stopSelecting();
                stopAutoScroll();
            }
        }

        /*
         * @see dwt.events.MouseListener#mouseDown(dwt.events.MouseEvent)
         */
        public void mouseDown(MouseEvent event) {
            fParentRuler.setLocationOfLastMouseButtonActivity(event.x, event.y);
            // see bug 45700
            if (event.button is 1) {
                startSelecting((event.stateMask & DWT.SHIFT) !is 0);
            }
        }

        /*
         * @see dwt.events.MouseListener#mouseDoubleClick(dwt.events.MouseEvent)
         */
        public void mouseDoubleClick(MouseEvent event) {
            fParentRuler.setLocationOfLastMouseButtonActivity(event.x, event.y);
            stopSelecting();
            stopAutoScroll();
        }

        /*
         * @see dwt.events.MouseMoveListener#mouseMove(dwt.events.MouseEvent)
         */
        public void mouseMove(MouseEvent event) {
            if (fIsListeningForMove && !autoScroll(event)) {
                int newLine= fParentRuler.toDocumentLineNumber(event.y);
                expandSelection(newLine);
            }
            fParentRuler.setLocationOfLastMouseButtonActivity(event.x, event.y);
        }

        /**
         * Called when line drag selection started. Adds mouse move and track
         * listeners to this column's control.
         *
         * @param expandExistingSelection if <code>true</code> the existing selection will be expanded,
         *          otherwise a new selection is started
         */
        private void startSelecting(bool expandExistingSelection) {
            try {

                // select line
                IDocument document= fCachedTextViewer.getDocument();
                int lineNumber= fParentRuler.getLineOfLastMouseButtonActivity();
                if (expandExistingSelection && cast(ITextViewerExtension5)fCachedTextViewer
                        && fCachedTextViewer.getTextWidget() !is null) {
                    ITextViewerExtension5 extension5= (cast(ITextViewerExtension5)fCachedTextViewer);
                    // Find model curosr position
                    int widgetCaret= fCachedTextViewer.getTextWidget().getCaretOffset();
                    int modelCaret= extension5.widgetOffset2ModelOffset(widgetCaret);
                    // Find model selection range
                    Point selection= fCachedTextViewer.getSelectedRange();
                    // Start from tail of selection range (opposite of cursor position)
                    int startOffset= modelCaret is selection.x ? selection.x + selection.y : selection.x;

                    fStartLineNumber= document.getLineOfOffset(startOffset);
                    fStartLineOffset= startOffset;

                    expandSelection(lineNumber);
                } else {
                    fStartLineNumber= lineNumber;
                    fStartLineOffset= document.getLineInformation(fStartLineNumber).getOffset();
                    fCachedTextViewer.setSelectedRange(fStartLineOffset, 0);
                }
                fCachedViewportSize= getVisibleLinesInViewport();

                // prepare for drag selection
                fIsListeningForMove= true;

            } catch (BadLocationException x) {
            }
        }

        /**
         * Called when line drag selection stopped. Removes all previously
         * installed listeners from this column's control.
         */
        private void stopSelecting() {
            // drag selection stopped
            fIsListeningForMove= false;
        }

        /**
         * Expands the line selection from the remembered start line to the
         * given line.
         *
         * @param lineNumber the line to which to expand the selection
         */
        private void expandSelection(int lineNumber) {
            try {

                IDocument document= fCachedTextViewer.getDocument();
                IRegion lineInfo= document.getLineInformation(lineNumber);

                Display display= fCachedTextWidget.getDisplay();
                Point absolutePosition= display.getCursorLocation();
                Point relativePosition= fCachedTextWidget.toControl(absolutePosition);

                int offset;

                if (relativePosition.x < 0)
                    offset= lineInfo.getOffset();
                else {
                    try {
                        int widgetOffset= fCachedTextWidget.getOffsetAtLocation(relativePosition);
                        Point p= fCachedTextWidget.getLocationAtOffset(widgetOffset);
                        if (p.x > relativePosition.x)
                            widgetOffset--;

                        // Convert to model offset
                        if ( cast(ITextViewerExtension5)fCachedTextViewer ) {
                            ITextViewerExtension5 extension= cast(ITextViewerExtension5)fCachedTextViewer;
                            offset= extension.widgetOffset2ModelOffset(widgetOffset);
                        } else
                            offset= widgetOffset + fCachedTextViewer.getVisibleRegion().getOffset();

                    } catch (IllegalArgumentException ex) {
                        int lineEndOffset= lineInfo.getOffset() + lineInfo.getLength();

                        // Convert to widget offset
                        int lineEndWidgetOffset;
                        if ( cast(ITextViewerExtension5)fCachedTextViewer ) {
                            ITextViewerExtension5 extension= cast(ITextViewerExtension5)fCachedTextViewer;
                            lineEndWidgetOffset= extension.modelOffset2WidgetOffset(lineEndOffset);
                        } else
                            lineEndWidgetOffset= lineEndOffset - fCachedTextViewer.getVisibleRegion().getOffset();

                        Point p= fCachedTextWidget.getLocationAtOffset(lineEndWidgetOffset);
                        if (p.x < relativePosition.x)
                            offset= lineEndOffset;
                        else
                            offset= lineInfo.getOffset();
                    }
                }

                int start= Math.min(fStartLineOffset, offset);
                int end= Math.max(fStartLineOffset, offset);

                if (lineNumber < fStartLineNumber)
                    fCachedTextViewer.setSelectedRange(end, start - end);
                else
                    fCachedTextViewer.setSelectedRange(start, end - start);

            } catch (BadLocationException x) {
            }
        }

        /**
         * Called when auto scrolling stopped. Clears the auto scroll direction.
         */
        private void stopAutoScroll() {
            fAutoScrollDirection= DWT.NULL;
        }

        /**
         * Called on drag selection.
         *
         * @param event the mouse event caught by the mouse move listener
         * @return <code>true</code> if scrolling happened, <code>false</code> otherwise
         */
        private bool autoScroll(MouseEvent event) {
            Rectangle area= fCanvas.getClientArea();

            if (event.y > area.height) {
                autoScroll(DWT.DOWN);
                return true;
            }

            if (event.y < 0) {
                autoScroll(DWT.UP);
                return true;
            }

            stopAutoScroll();
            return false;
        }

        /**
         * Scrolls the viewer into the given direction.
         *
         * @param direction the scroll direction
         */
        private void autoScroll(int direction) {

            if (fAutoScrollDirection is direction)
                return;

            final int TIMER_INTERVAL= 5;
            final Display display= fCanvas.getDisplay();
            Runnable timer= null;
            switch (direction) {
                case DWT.UP:
                    timer= new class()  Runnable {
                        public void run() {
                            if (fAutoScrollDirection is DWT.UP) {
                                int top= getInclusiveTopIndex();
                                if (top > 0) {
                                    fCachedTextViewer.setTopIndex(top -1);
                                    expandSelection(top -1);
                                    display.timerExec(TIMER_INTERVAL, this);
                                }
                            }
                        }
                    };
                    break;
                case  DWT.DOWN:
                    timer= new class()  Runnable {
                        public void run() {
                            if (fAutoScrollDirection is DWT.DOWN) {
                                int top= getInclusiveTopIndex();
                                fCachedTextViewer.setTopIndex(top +1);
                                expandSelection(top +1 + fCachedViewportSize);
                                display.timerExec(TIMER_INTERVAL, this);
                            }
                        }
                    };
                    break;
                default:
            }

            if (timer !is null) {
                fAutoScrollDirection= direction;
                display.timerExec(TIMER_INTERVAL, timer);
            }
        }

        /**
         * Returns the viewer's first visible line, even if only partially visible.
         *
         * @return the viewer's first visible line
         */
        private int getInclusiveTopIndex() {
            if (fCachedTextWidget !is null && !fCachedTextWidget.isDisposed()) {
                return JFaceTextUtil.getPartialTopIndex(fCachedTextViewer);
            }
            return -1;
        }
    }

    /** This column's parent ruler */
    private CompositeRuler fParentRuler;
    /** Cached text viewer */
    private ITextViewer fCachedTextViewer;
    /** Cached text widget */
    private StyledText fCachedTextWidget;
    /** The columns canvas */
    private Canvas fCanvas;
    /** Cache for the actual scroll position in pixels */
    private int fScrollPos;
    /** The drawable for double buffering */
    private Image fBuffer;
    /** The internal listener */
    private InternalListener fInternalListener;
    /** The font of this column */
    private Font fFont;
    /** The indentation cache */
    private int[] fIndentation;
    /** Indicates whether this column reacts on text change events */
    private bool fSensitiveToTextChanges= false;
    /** The foreground color */
    private Color fForeground;
    /** The background color */
    private Color fBackground;
    /** Cached number of displayed digits */
    private int fCachedNumberOfDigits= -1;
    /** Flag indicating whether a relayout is required */
    private bool fRelayoutRequired= false;
    /**
     * Redraw runnable lock
     * @since 3.0
     */
    private Object fRunnableLock;
    /**
     * Redraw runnable state
     * @since 3.0
     */
    private bool fIsRunnablePosted= false;
    /**
     * Redraw runnable
     * @since 3.0
     */
    private Runnable fRunnable;
    private void fRunnable_init() {
        fRunnable = new class() Runnable {
            public void run() {
                synchronized (fRunnableLock) {
                    fIsRunnablePosted= false;
                }
                redraw();
            }
        };
    }
    /* @since 3.2 */
    private MouseHandler fMouseHandler;


    /**
     * Constructs a new vertical ruler column.
     */
    public this() {
        fInternalListener= new InternalListener();
        fRunnableLock= new Object();
        fRunnable_init();
    }

    /**
     * Sets the foreground color of this column.
     *
     * @param foreground the foreground color
     */
    public void setForeground(Color foreground) {
        fForeground= foreground;
    }

    /**
     * Returns the foreground color being used to print the line numbers.
     *
     * @return the configured foreground color
     * @since 3.0
     */
    protected Color getForeground() {
        return fForeground;
    }

    /**
     * Sets the background color of this column.
     *
     * @param background the background color
     */
    public void setBackground(Color background) {
        fBackground= background;
        if (fCanvas !is null && !fCanvas.isDisposed())
            fCanvas.setBackground(getBackground(fCanvas.getDisplay()));
    }

    /**
     * Returns the System background color for list widgets.
     *
     * @param display the display
     * @return the System background color for list widgets
     */
    protected Color getBackground(Display display) {
        if (fBackground is null)
            return display.getSystemColor(DWT.COLOR_LIST_BACKGROUND);
        return fBackground;
    }

    /*
     * @see IVerticalRulerColumn#getControl()
     */
    public Control getControl() {
        return fCanvas;
    }

    /*
     * @see IVerticalRuleColumnr#getWidth
     */
    public int getWidth() {
        return fIndentation[0];
    }

    /**
     * Computes the number of digits to be displayed. Returns
     * <code>true</code> if the number of digits changed compared
     * to the previous call of this method. If the method is called
     * for the first time, the return value is also <code>true</code>.
     *
     * @return whether the number of digits has been changed
     * @since 3.0
     */
    protected bool updateNumberOfDigits() {
        if (fCachedTextViewer is null)
            return false;

        int digits= computeNumberOfDigits();

        if (fCachedNumberOfDigits !is digits) {
            fCachedNumberOfDigits= digits;
            return true;
        }

        return false;
    }

    /**
     * Does the real computation of the number of digits. Subclasses may override this method if
     * they need extra space on the line number ruler.
     *
     * @return the number of digits to be displayed on the line number ruler.
     */
    protected int computeNumberOfDigits() {
        IDocument document= fCachedTextViewer.getDocument();
        int lines= document is null ? 0 : document.getNumberOfLines();

        int digits= 2;
        while (lines > Math.pow(cast(real)10.0, cast(uint)digits) -1) {
            ++digits;
        }
        return digits;
    }

    /**
     * Layouts the enclosing viewer to adapt the layout to changes of the
     * size of the individual components.
     *
     * @param redraw <code>true</code> if this column can be redrawn
     */
    protected void layout(bool redraw) {
        if (!redraw) {
            fRelayoutRequired= true;
            return;
        }

        fRelayoutRequired= false;
        if ( cast(ITextViewerExtension)fCachedTextViewer ) {
            ITextViewerExtension extension= cast(ITextViewerExtension) fCachedTextViewer;
            Control control= extension.getControl();
            if ( cast(Composite)control  && !control.isDisposed()) {
                Composite composite= cast(Composite) control;
                composite.layout(true);
            }
        }
    }

    /**
     * Computes the indentations for the given font and stores them in
     * <code>fIndentation</code>.
     */
    protected void computeIndentations() {
        if (fCanvas is null || fCanvas.isDisposed())
            return;

        GC gc= new GC(fCanvas);
        try {

            gc.setFont(fCanvas.getFont());

            fIndentation= new int[fCachedNumberOfDigits + 1];

            char[] nines= new char[fCachedNumberOfDigits];
            Arrays.fill(nines, '9');
            String nineString= new_String(nines);
            Point p= gc.stringExtent(nineString);
            fIndentation[0]= p.x;

            for (int i= 1; i <= fCachedNumberOfDigits; i++) {
                p= gc.stringExtent(nineString.substring(0, i));
                fIndentation[i]= fIndentation[0] - p.x;
            }

        } finally {
            gc.dispose();
        }
    }

    /*
     * @see IVerticalRulerColumn#createControl(CompositeRuler, Composite)
     */
    public Control createControl(CompositeRuler parentRuler, Composite parentControl) {

        fParentRuler= parentRuler;
        fCachedTextViewer= parentRuler.getTextViewer();
        fCachedTextWidget= fCachedTextViewer.getTextWidget();

        fCanvas= new class(parentControl, DWT.NO_FOCUS )  Canvas {
            this(Composite c, int s ){
                super(c,s);
            }
            /*
             * @see dwt.widgets.Control#addMouseListener(dwt.events.MouseListener)
             * @since 3.4
             */
            public void addMouseListener(MouseListener listener) {
                // see bug 40889, bug 230073 and AnnotationRulerColumn#isPropagatingMouseListener()
                if (listener is fMouseHandler)
                    super.addMouseListener(listener);
                else {
                    TypedListener typedListener= null;
                    if (listener !is null)
                        typedListener= new TypedListener(listener);
                    addListener(DWT.MouseDoubleClick, typedListener);
                }
            }
        };
        fCanvas.setBackground(getBackground(fCanvas.getDisplay()));
        fCanvas.setForeground(fForeground);

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

        fMouseHandler= new MouseHandler();
        fCanvas.addMouseListener(fMouseHandler);
        fCanvas.addMouseMoveListener(fMouseHandler);

        if (fCachedTextViewer !is null) {

            fCachedTextViewer.addViewportListener(fInternalListener);
            fCachedTextViewer.addTextListener(fInternalListener);

            if (fFont is null) {
                if (fCachedTextWidget !is null && !fCachedTextWidget.isDisposed())
                    fFont= fCachedTextWidget.getFont();
            }
        }

        if (fFont !is null)
            fCanvas.setFont(fFont);

        updateNumberOfDigits();
        computeIndentations();
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
        if (fForeground !is null)
            gc.setForeground(fForeground);

        try {
            gc.setBackground(getBackground(fCanvas.getDisplay()));
            gc.fillRectangle(0, 0, size.x, size.y);

            ILineRange visibleLines= JFaceTextUtil.getVisibleModelLines(fCachedTextViewer);
            if (visibleLines is null)
                return;
            fScrollPos= fCachedTextWidget.getTopPixel();
            doPaint(gc, visibleLines);
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
        return getVisibleLinesInViewport(fCachedTextWidget);
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
     * @param visibleLines the visible model lines
     * @since 3.2
     */
    void doPaint(GC gc, ILineRange visibleLines) {
        Display display= fCachedTextWidget.getDisplay();

        // draw diff info
        int y= -JFaceTextUtil.getHiddenTopLinePixels(fCachedTextWidget);

        int lastLine= end(visibleLines);
        for (int line= visibleLines.getStartLine(); line < lastLine; line++) {
            int widgetLine= JFaceTextUtil.modelLineToWidgetLine(fCachedTextViewer, line);
            if (widgetLine is -1)
                continue;

            int lineHeight= fCachedTextWidget.getLineHeight(fCachedTextWidget.getOffsetAtLine(widgetLine));
            paintLine(line, y, lineHeight, gc, display);
            y += lineHeight;
        }
    }

    /* @since 3.2 */
    private static int end(ILineRange range) {
        return range.getStartLine() + range.getNumberOfLines();
    }

    /**
     * Computes the string to be printed for <code>line</code>. The default implementation returns
     * <code>Integer.toString(line + 1)</code>.
     *
     * @param line the line number for which the line number string is generated
     * @return the string to be printed on the line number bar for <code>line</code>
     * @since 3.0
     */
    protected String createDisplayString(int line) {
        return Integer.toString(line + 1);
    }

    /**
     * Returns the difference between the baseline of the widget and the
     * baseline as specified by the font for <code>gc</code>. When drawing
     * line numbers, the returned bias should be added to obtain text lined up
     * on the correct base line of the text widget.
     *
     * @param gc the <code>GC</code> to get the font metrics from
     * @param widgetLine the widget line
     * @return the baseline bias to use when drawing text that is lined up with
     *         <code>fCachedTextWidget</code>
     * @since 3.2
     */
    private int getBaselineBias(GC gc, int widgetLine) {
        /*
         * https://bugs.eclipse.org/bugs/show_bug.cgi?id=62951
         * widget line height may be more than the font height used for the
         * line numbers, since font styles (bold, italics...) can have larger
         * font metrics than the simple font used for the numbers.
         */
        int offset= fCachedTextWidget.getOffsetAtLine(widgetLine);
        int widgetBaseline= fCachedTextWidget.getBaseline(offset);

        FontMetrics fm= gc.getFontMetrics();
        int fontBaseline= fm.getAscent() + fm.getLeading();
        int baselineBias= widgetBaseline - fontBaseline;
        return Math.max(0, baselineBias);
    }

    /**
     * Paints the line. After this method is called the line numbers are painted on top
     * of the result of this method.
     *
     * @param line the line of the document which the ruler is painted for
     * @param y the y-coordinate of the box being painted for <code>line</code>, relative to <code>gc</code>
     * @param lineheight the height of one line (and therefore of the box being painted)
     * @param gc the drawing context the client may choose to draw on.
     * @param display the display the drawing occurs on
     * @since 3.0
     */
    protected void paintLine(int line, int y, int lineheight, GC gc, Display display) {
        int widgetLine= JFaceTextUtil.modelLineToWidgetLine(fCachedTextViewer, line);

        String s= createDisplayString(line);
        int indentation= fIndentation[s.length];
        int baselineBias= getBaselineBias(gc, widgetLine);
        gc.drawString(s, indentation, y + baselineBias, true);
    }

    /**
     * Triggers a redraw in the display thread.
     *
     * @since 3.0
     */
    protected final void postRedraw() {
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

    /*
     * @see IVerticalRulerColumn#redraw()
     */
    public void redraw() {

        if (fRelayoutRequired) {
            layout(true);
            return;
        }

        if (fCachedTextViewer !is null && fCanvas !is null && !fCanvas.isDisposed()) {
            GC gc= new GC(fCanvas);
            doubleBufferPaint(gc);
            gc.dispose();
        }
    }

    /*
     * @see IVerticalRulerColumn#setModel(IAnnotationModel)
     */
    public void setModel(IAnnotationModel model) {
    }

    /*
     * @see IVerticalRulerColumn#setFont(Font)
     */
    public void setFont(Font font) {
        fFont= font;
        if (fCanvas !is null && !fCanvas.isDisposed()) {
            fCanvas.setFont(fFont);
            updateNumberOfDigits();
            computeIndentations();
        }
    }

    /**
     * Returns the parent (composite) ruler of this ruler column.
     *
     * @return the parent ruler
     * @since 3.0
     */
    protected CompositeRuler getParentRuler() {
        return fParentRuler;
    }


    /**
     * Returns the number of lines in the view port.
     *
     * @param textWidget
     * @return the number of lines visible in the view port <code>-1</code> if there's no client area
     * @deprecated this method should not be used - it relies on the widget using a uniform line height
     */
    static int getVisibleLinesInViewport(StyledText textWidget) {
        if (textWidget !is null) {
            Rectangle clArea= textWidget.getClientArea();
            if (!clArea.isEmpty()) {
                int firstPixel= 0;
                int lastPixel= clArea.height - 1; // XXX what about margins? don't take trims as they include scrollbars
                int first= JFaceTextUtil.getLineIndex(textWidget, firstPixel);
                int last= JFaceTextUtil.getLineIndex(textWidget, lastPixel);
                return last - first;
            }
        }
        return -1;
    }

}
