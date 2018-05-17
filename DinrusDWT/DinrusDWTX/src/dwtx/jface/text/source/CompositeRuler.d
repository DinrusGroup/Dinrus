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
module dwtx.jface.text.source.CompositeRuler;

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
import dwt.events.ControlListener;
import dwt.events.DisposeEvent;
import dwt.events.DisposeListener;
import dwt.events.FocusListener;
import dwt.events.HelpListener;
import dwt.events.KeyListener;
import dwt.events.MouseListener;
import dwt.events.MouseMoveListener;
import dwt.events.MouseTrackListener;
import dwt.events.PaintListener;
import dwt.events.TraverseListener;
import dwt.graphics.Font;
import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwt.widgets.Canvas;
import dwt.widgets.Composite;
import dwt.widgets.Control;
import dwt.widgets.Display;
import dwt.widgets.Event;
import dwt.widgets.Layout;
import dwt.widgets.Listener;
import dwt.widgets.Menu;
import dwtx.core.runtime.Assert;
import dwtx.jface.text.BadLocationException;
import dwtx.jface.text.IDocument;
import dwtx.jface.text.IRegion;
import dwtx.jface.text.ITextViewer;
import dwtx.jface.text.ITextViewerExtension;
import dwtx.jface.text.ITextViewerExtension5;


/**
 * Standard implementation of
 * {@link dwtx.jface.text.source.IVerticalRuler}.
 * <p>
 * This ruler does not have a a visual representation of its own. The
 * presentation comes from the configurable list of vertical ruler columns. Such
 * columns must implement the
 * {@link dwtx.jface.text.source.IVerticalRulerColumn}. interface.</p>
 * <p>
 * Clients may instantiate and configure this class.</p>
 *
 * @see dwtx.jface.text.source.IVerticalRulerColumn
 * @see dwtx.jface.text.ITextViewer
 * @since 2.0
 */
public class CompositeRuler : IVerticalRuler, IVerticalRulerExtension, IVerticalRulerInfoExtension {


    /**
     * Layout of the composite vertical ruler. Arranges the list of columns.
     */
    class RulerLayout : Layout {

        /**
         * Creates the new ruler layout.
         */
        protected this() {
        }

        /*
         * @see Layout#computeSize(Composite, int, int, bool)
         */
        protected Point computeSize(Composite composite, int wHint, int hHint, bool flushCache) {
            Control[] children= composite.getChildren();
            Point size= new Point(0, 0);
            for (int i= 0; i < children.length; i++) {
                Point s= children[i].computeSize(DWT.DEFAULT, DWT.DEFAULT, flushCache);
                size.x += s.x;
                size.y= Math.max(size.y, s.y);
            }
            size.x += (Math.max(0, children.length -1) * fGap);
            return size;
        }

        /*
         * @see Layout#layout(Composite, bool)
         */
        protected void layout(Composite composite, bool flushCache) {
            Rectangle clArea= composite.getClientArea();
            int rulerHeight= clArea.height;

            int x= 0;
            Iterator e= fDecorators.iterator();
            while (e.hasNext()) {
                IVerticalRulerColumn column= cast(IVerticalRulerColumn) e.next();
                int columnWidth= column.getWidth();
                column.getControl().setBounds(x, 0, columnWidth, rulerHeight);
                x += (columnWidth + fGap);
            }
        }
    }

    /**
     * A canvas that adds listeners to all its children. Used by the implementation of the
     * vertical ruler to propagate listener additions and removals to the ruler's columns.
     */
    static class CompositeRulerCanvas : Canvas {

        /**
         * Keeps the information for which event type a listener object has been added.
         */
        static class ListenerInfo {
            ClassInfo fClass;
            EventListener fListener;
        }

        /** The list of listeners added to this canvas. */
        private List fCachedListeners;
        /**
         * Internal listener for opening the context menu.
         * @since 3.0
         */
        private Listener fMenuDetectListener;

        /**
         * Creates a new composite ruler canvas.
         *
         * @param parent the parent composite
         * @param style the DWT styles
         */
        public this(Composite parent, int style) {
            fCachedListeners= new ArrayList();

            super(parent, style);
            fMenuDetectListener= new class()  Listener {
                public void handleEvent(Event event) {
                    if (event.type is DWT.MenuDetect) {
                        Menu menu= getMenu();
                        if (menu !is null) {
                            menu.setLocation(event.x, event.y);
                            menu.setVisible(true);
                        }
                    }
                }
            };
            super.addDisposeListener(new class()  DisposeListener {
                public void widgetDisposed(DisposeEvent e) {
                    if (fCachedListeners !is null) {
                        fCachedListeners.clear();
                        fCachedListeners= null;
                    }
                }
            });
        }

        /**
         * Adds the given listener object as listener of the given type (<code>clazz</code>) to
         * the given control.
         *
         * @param clazz the listener type
         * @param control the control to add the listener to
         * @param listener the listener to be added
         */
        private void addListener(ClassInfo clazz, Control control, EventListener listener) {
            if (ControlListener.classinfo.opEquals(clazz)) {
                control. addControlListener(cast(ControlListener) listener);
                return;
            }
            if (FocusListener.classinfo.opEquals(clazz)) {
                control. addFocusListener(cast(FocusListener) listener);
                return;
            }
            if (HelpListener.classinfo.opEquals(clazz)) {
                control. addHelpListener(cast(HelpListener) listener);
                return;
            }
            if (KeyListener.classinfo.opEquals(clazz)) {
                control. addKeyListener(cast(KeyListener) listener);
                return;
            }
            if (MouseListener.classinfo.opEquals(clazz)) {
                control. addMouseListener(cast(MouseListener) listener);
                return;
            }
            if (MouseMoveListener.classinfo.opEquals(clazz)) {
                control. addMouseMoveListener(cast(MouseMoveListener) listener);
                return;
            }
            if (MouseTrackListener.classinfo.opEquals(clazz)) {
                control. addMouseTrackListener(cast(MouseTrackListener) listener);
                return;
            }
            if (PaintListener.classinfo.opEquals(clazz)) {
                control. addPaintListener(cast(PaintListener) listener);
                return;
            }
            if (TraverseListener.classinfo.opEquals(clazz)) {
                control. addTraverseListener(cast(TraverseListener) listener);
                return;
            }
            if (DisposeListener.classinfo.opEquals(clazz)) {
                control. addDisposeListener(cast(DisposeListener) listener);
                return;
            }
        }

        /**
         * Removes the given listener object as listener of the given type (<code>clazz</code>) from
         * the given control.
         *
         * @param clazz the listener type
         * @param control the control to remove the listener from
         * @param listener the listener to be removed
         */
        private void removeListener(ClassInfo clazz, Control control, EventListener listener) {
            if (ControlListener.classinfo.opEquals(clazz)) {
                control. removeControlListener(cast(ControlListener) listener);
                return;
            }
            if (FocusListener.classinfo.opEquals(clazz)) {
                control. removeFocusListener(cast(FocusListener) listener);
                return;
            }
            if (HelpListener.classinfo.opEquals(clazz)) {
                control. removeHelpListener(cast(HelpListener) listener);
                return;
            }
            if (KeyListener.classinfo.opEquals(clazz)) {
                control. removeKeyListener(cast(KeyListener) listener);
                return;
            }
            if (MouseListener.classinfo.opEquals(clazz)) {
                control. removeMouseListener(cast(MouseListener) listener);
                return;
            }
            if (MouseMoveListener.classinfo.opEquals(clazz)) {
                control. removeMouseMoveListener(cast(MouseMoveListener) listener);
                return;
            }
            if (MouseTrackListener.classinfo.opEquals(clazz)) {
                control. removeMouseTrackListener(cast(MouseTrackListener) listener);
                return;
            }
            if (PaintListener.classinfo.opEquals(clazz)) {
                control. removePaintListener(cast(PaintListener) listener);
                return;
            }
            if (TraverseListener.classinfo.opEquals(clazz)) {
                control. removeTraverseListener(cast(TraverseListener) listener);
                return;
            }
            if (DisposeListener.classinfo.opEquals(clazz)) {
                control. removeDisposeListener(cast(DisposeListener) listener);
                return;
            }
        }

        /**
         * Adds the given listener object to the internal book keeping under
         * the given listener type (<code>clazz</code>).
         *
         * @param clazz the listener type
         * @param listener the listener object
         */
        private void addListener(ClassInfo clazz, EventListener listener) {
            Control[] children= getChildren();
            for (int i= 0; i < children.length; i++) {
                if (children[i] !is null && !children[i].isDisposed())
                    addListener(clazz, children[i], listener);
            }

            ListenerInfo info= new ListenerInfo();
            info.fClass= clazz;
            info.fListener= listener;
            fCachedListeners.add(info);
        }

        /**
         * Removes the given listener object from the internal book keeping under
         * the given listener type (<code>clazz</code>).
         *
         * @param clazz the listener type
         * @param listener the listener object
         */
        private void removeListener(ClassInfo clazz, EventListener listener) {
            int length= fCachedListeners.size();
            for (int i= 0; i < length; i++) {
                ListenerInfo info= cast(ListenerInfo) fCachedListeners.get(i);
                if (listener is info.fListener && clazz.opEquals(info.fClass)) {
                    fCachedListeners.remove(i);
                    break;
                }
            }

            Control[] children= getChildren();
            for (int i= 0; i < children.length; i++) {
                if (children[i] !is null && !children[i].isDisposed())
                    removeListener(clazz, children[i], listener);
            }
        }

        /**
         * Tells this canvas that a child has been added.
         *
         * @param child the child
         */
        public void childAdded(Control child) {
            if (child !is null && !child.isDisposed()) {
                int length= fCachedListeners.size();
                for (int i= 0; i < length; i++) {
                    ListenerInfo info= cast(ListenerInfo) fCachedListeners.get(i);
                    addListener(info.fClass, child, info.fListener);
                }
                child.addListener(DWT.MenuDetect, fMenuDetectListener);
            }
        }

        /**
         * Tells this canvas that a child has been removed.
         *
         * @param child the child
         */
        public void childRemoved(Control child) {
            if (child !is null && !child.isDisposed()) {
                int length= fCachedListeners.size();
                for (int i= 0; i < length; i++) {
                    ListenerInfo info= cast(ListenerInfo) fCachedListeners.get(i);
                    removeListener(info.fClass, child, info.fListener);
                }
                child.removeListener(DWT.MenuDetect, fMenuDetectListener);
            }
        }

        /*
         * @see Control#removeControlListener(ControlListener)
         */
        public void removeControlListener(ControlListener listener) {
            removeListener(ControlListener.classinfo, listener);
            super.removeControlListener(listener);
        }

        /*
         * @see Control#removeFocusListener(FocusListener)
         */
        public void removeFocusListener(FocusListener listener) {
            removeListener(FocusListener.classinfo, listener);
            super.removeFocusListener(listener);
        }

        /*
         * @see Control#removeHelpListener(HelpListener)
         */
        public void removeHelpListener(HelpListener listener) {
            removeListener(HelpListener.classinfo, listener);
            super.removeHelpListener(listener);
        }

        /*
         * @see Control#removeKeyListener(KeyListener)
         */
        public void removeKeyListener(KeyListener listener) {
            removeListener(KeyListener.classinfo, listener);
            super.removeKeyListener(listener);
        }

        /*
         * @see Control#removeMouseListener(MouseListener)
         */
        public void removeMouseListener(MouseListener listener) {
            removeListener(MouseListener.classinfo, listener);
            super.removeMouseListener(listener);
        }

        /*
         * @see Control#removeMouseMoveListener(MouseMoveListener)
         */
        public void removeMouseMoveListener(MouseMoveListener listener) {
            removeListener(MouseMoveListener.classinfo, listener);
            super.removeMouseMoveListener(listener);
        }

        /*
         * @see Control#removeMouseTrackListener(MouseTrackListener)
         */
        public void removeMouseTrackListener(MouseTrackListener listener) {
            removeListener(MouseTrackListener.classinfo, listener);
            super.removeMouseTrackListener(listener);
        }

        /*
         * @see Control#removePaintListener(PaintListener)
         */
        public void removePaintListener(PaintListener listener) {
            removeListener(PaintListener.classinfo, listener);
            super.removePaintListener(listener);
        }

        /*
         * @see Control#removeTraverseListener(TraverseListener)
         */
        public void removeTraverseListener(TraverseListener listener) {
            removeListener(TraverseListener.classinfo, listener);
            super.removeTraverseListener(listener);
        }

        /*
         * @see Widget#removeDisposeListener(DisposeListener)
         */
        public void removeDisposeListener(DisposeListener listener) {
            removeListener(DisposeListener.classinfo, listener);
            super.removeDisposeListener(listener);
        }

        /*
         * @seeControl#addControlListener(ControlListener)
         */
        public void addControlListener(ControlListener listener) {
            super.addControlListener(listener);
            addListener(ControlListener.classinfo, listener);
        }

        /*
         * @see Control#addFocusListener(FocusListener)
         */
        public void addFocusListener(FocusListener listener) {
            super.addFocusListener(listener);
            addListener(FocusListener.classinfo, listener);
        }

        /*
         * @see Control#addHelpListener(HelpListener)
         */
        public void addHelpListener(HelpListener listener) {
            super.addHelpListener(listener);
            addListener(HelpListener.classinfo, listener);
        }

        /*
         * @see Control#addKeyListener(KeyListener)
         */
        public void addKeyListener(KeyListener listener) {
            super.addKeyListener(listener);
            addListener(KeyListener.classinfo, listener);
        }

        /*
         * @see Control#addMouseListener(MouseListener)
         */
        public void addMouseListener(MouseListener listener) {
            super.addMouseListener(listener);
            addListener(MouseListener.classinfo, listener);
        }

        /*
         * @see Control#addMouseMoveListener(MouseMoveListener)
         */
        public void addMouseMoveListener(MouseMoveListener listener) {
            super.addMouseMoveListener(listener);
            addListener(MouseMoveListener.classinfo, listener);
        }

        /*
         * @see Control#addMouseTrackListener(MouseTrackListener)
         */
        public void addMouseTrackListener(MouseTrackListener listener) {
            super.addMouseTrackListener(listener);
            addListener(MouseTrackListener.classinfo, listener);
        }

        /*
         * @seeControl#addPaintListener(PaintListener)
         */
        public void addPaintListener(PaintListener listener) {
            super.addPaintListener(listener);
            addListener(PaintListener.classinfo, listener);
        }

        /*
         * @see Control#addTraverseListener(TraverseListener)
         */
        public void addTraverseListener(TraverseListener listener) {
            super.addTraverseListener(listener);
            addListener(TraverseListener.classinfo, listener);
        }

        /*
         * @see Widget#addDisposeListener(DisposeListener)
         */
        public void addDisposeListener(DisposeListener listener) {
            super.addDisposeListener(listener);
            addListener(DisposeListener.classinfo, listener);
        }
    }

    /** The ruler's viewer */
    private ITextViewer fTextViewer;
    /** The ruler's canvas to which to add the ruler columns */
    private CompositeRulerCanvas fComposite;
    /** The ruler's annotation model */
    private IAnnotationModel fModel;
    /** The list of columns */
    private List fDecorators;
    /** The cached location of the last mouse button activity */
    private Point fLocation;
    /** The cached line of the list mouse button activity */
    private int fLastMouseButtonActivityLine= -1;
    /** The gap between the individual columns of this composite ruler */
    private int fGap;
    /**
     * The set of annotation listeners.
     * @since 3.0
     */
    private Set fAnnotationListeners;


    /**
     * Constructs a new composite vertical ruler.
     */
    public this() {
        this(0);
    }

    /**
     * Constructs a new composite ruler with the given gap between its columns.
     *
     * @param gap
     */
    public this(int gap) {
        fDecorators= new ArrayList(2);
        fLocation= new Point(-1, -1);
        fAnnotationListeners= new HashSet();

        fGap= gap;
    }

    /**
     * Inserts the given column at the specified slot to this composite ruler.
     * Columns are counted from left to right.
     *
     * @param index the index
     * @param rulerColumn the decorator to be inserted
     */
    public void addDecorator(int index, IVerticalRulerColumn rulerColumn) {
        rulerColumn.setModel(getModel());

        if (index > fDecorators.size())
            fDecorators.add(cast(Object)rulerColumn);
        else
            fDecorators.add(index, cast(Object)rulerColumn);

        if (fComposite !is null && !fComposite.isDisposed()) {
            rulerColumn.createControl(this, fComposite);
            fComposite.childAdded(rulerColumn.getControl());
            layoutTextViewer();
        }
    }

    /**
     * Removes the decorator in the specified slot from this composite ruler.
     *
     * @param index the index
     */
    public void removeDecorator(int index) {
        IVerticalRulerColumn rulerColumn= cast(IVerticalRulerColumn) fDecorators.get(index);
        removeDecorator(rulerColumn);
    }

    /**
     * Removes the given decorator from the composite ruler.
     *
     * @param rulerColumn the ruler column to be removed
     * @since 3.0
     */
    public void removeDecorator(IVerticalRulerColumn rulerColumn) {
        fDecorators.remove(cast(Object)rulerColumn);
        if (rulerColumn !is null) {
            Control cc= rulerColumn.getControl();
            if (cc !is null && !cc.isDisposed()) {
                fComposite.childRemoved(cc);
                cc.dispose();
            }
        }
        layoutTextViewer();
    }

    /**
     * Layouts the text viewer. This also causes this ruler to get
     * be layouted.
     */
    private void layoutTextViewer() {

        Control parent= fTextViewer.getTextWidget();

        if ( cast(ITextViewerExtension)fTextViewer ) {
            ITextViewerExtension extension= cast(ITextViewerExtension) fTextViewer;
            parent= extension.getControl();
        }

        if ( cast(Composite)parent  && !parent.isDisposed())
            (cast(Composite) parent).layout(true);
    }

    /*
     * @see IVerticalRuler#getControl()
     */
    public Control getControl() {
        return fComposite;
    }

    /*
     * @see IVerticalRuler#createControl(Composite, ITextViewer)
     */
    public Control createControl(Composite parent, ITextViewer textViewer) {

        fTextViewer= textViewer;

        fComposite= new CompositeRulerCanvas(parent, DWT.NONE);
        fComposite.setLayout(new RulerLayout());

        Iterator iter= fDecorators.iterator();
        while (iter.hasNext()) {
            IVerticalRulerColumn column= cast(IVerticalRulerColumn) iter.next();
            column.createControl(this, fComposite);
            fComposite.childAdded(column.getControl());
        }

        return fComposite;
    }

    /*
     * @see IVerticalRuler#setModel(IAnnotationModel)
     */
    public void setModel(IAnnotationModel model) {

        fModel= model;

        Iterator e= fDecorators.iterator();
        while (e.hasNext()) {
            IVerticalRulerColumn column= cast(IVerticalRulerColumn) e.next();
            column.setModel(model);
        }
    }

    /*
     * @see IVerticalRuler#getModel()
     */
    public IAnnotationModel getModel() {
        return fModel;
    }

    /*
     * @see IVerticalRuler#update()
     */
    public void update() {
        if (fComposite !is null && !fComposite.isDisposed()) {
            Display d= fComposite.getDisplay();
            if (d !is null) {
                d.asyncExec(new class()  Runnable {
                    public void run() {
                        immediateUpdate();
                    }
                });
            }
        }
    }

    /**
     * Immediately redraws the entire ruler (without asynchronous posting).
     *
     * @since 3.2
     */
    public void immediateUpdate() {
        Iterator e= fDecorators.iterator();
        while (e.hasNext()) {
            IVerticalRulerColumn column= cast(IVerticalRulerColumn) e.next();
            column.redraw();
        }
    }

    /*
     * @see IVerticalRulerExtension#setFont(Font)
     */
    public void setFont(Font font) {
        Iterator e= fDecorators.iterator();
        while (e.hasNext()) {
            IVerticalRulerColumn column= cast(IVerticalRulerColumn) e.next();
            column.setFont(font);
        }
    }

    /*
     * @see IVerticalRulerInfo#getWidth()
     */
    public int getWidth() {
        int width= 0;
        Iterator e= fDecorators.iterator();
        while (e.hasNext()) {
            IVerticalRulerColumn column= cast(IVerticalRulerColumn) e.next();
            width += (column.getWidth() + fGap);
        }
        return Math.max(0, width - fGap);
    }

    /*
     * @see IVerticalRulerInfo#getLineOfLastMouseButtonActivity()
     */
    public int getLineOfLastMouseButtonActivity() {
        if (fLastMouseButtonActivityLine is -1)
            fLastMouseButtonActivityLine= toDocumentLineNumber(fLocation.y);
        else if (fTextViewer.getDocument() is null || fLastMouseButtonActivityLine >= fTextViewer.getDocument().getNumberOfLines())
            fLastMouseButtonActivityLine= -1;
        return fLastMouseButtonActivityLine;
    }

    /*
     * @see IVerticalRulerInfo#toDocumentLineNumber(int)
     */
    public int toDocumentLineNumber(int y_coordinate) {
        if (fTextViewer is null || y_coordinate is -1)
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
     * Returns the line in the given viewer's document that correspond to the given
     * line of the viewer's widget.
     *
     * @param viewer the viewer
     * @param widgetLine the widget line
     * @return the corresponding line the viewer's document
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

    /**
     * Returns this ruler's text viewer.
     *
     * @return this ruler's text viewer
     */
    public ITextViewer getTextViewer() {
        return fTextViewer;
    }

    /*
     * @see IVerticalRulerExtension#setLocationOfLastMouseButtonActivity(int, int)
     */
    public void setLocationOfLastMouseButtonActivity(int x, int y) {
        fLocation.x= x;
        fLocation.y= y;
        fLastMouseButtonActivityLine= -1;
    }

    /**
     * Returns an iterator over the <code>IVerticalRulerColumns</code> that make up this
     * composite column.
     *
     * @return an iterator over the contained columns.
     * @since 3.0
     */
    public Iterator getDecoratorIterator() {
        Assert.isNotNull(cast(Object)fDecorators, "fDecorators must be initialized"); //$NON-NLS-1$
        return fDecorators.iterator();
    }

    /*
     * @see dwtx.jface.text.source.IVerticalRulerInfoExtension#getHover()
     * @since 3.0
     */
    public IAnnotationHover getHover() {
        return null;
    }

    /*
     * @see dwtx.jface.text.source.IVerticalRulerInfoExtension#addVerticalRulerListener(dwtx.jface.text.source.IVerticalRulerListener)
     * @since 3.0
     */
    public void addVerticalRulerListener(IVerticalRulerListener listener) {
        fAnnotationListeners.add(cast(Object)listener);
    }

    /*
     * @see dwtx.jface.text.source.IVerticalRulerInfoExtension#removeVerticalRulerListener(dwtx.jface.text.source.IVerticalRulerListener)
     * @since 3.0
     */
    public void removeVerticalRulerListener(IVerticalRulerListener listener) {
        fAnnotationListeners.remove(cast(Object)listener);
    }

    /**
     * Fires the annotation selected event to all registered vertical ruler
     * listeners.
     * TODO use robust iterators
     *
     * @param event the event to fire
     * @since 3.0
     */
    public void fireAnnotationSelected(VerticalRulerEvent event) {
        // forward to listeners
        for (Iterator it= fAnnotationListeners.iterator(); it.hasNext();) {
            IVerticalRulerListener listener= cast(IVerticalRulerListener) it.next();
            listener.annotationSelected(event);
        }
    }

    /**
     * Fires the annotation default selected event to all registered vertical
     * ruler listeners.
     * TODO use robust iterators
     *
     * @param event the event to fire
     * @since 3.0
     */
    public void fireAnnotationDefaultSelected(VerticalRulerEvent event) {
        // forward to listeners
        for (Iterator it= fAnnotationListeners.iterator(); it.hasNext();) {
            IVerticalRulerListener listener= cast(IVerticalRulerListener) it.next();
            listener.annotationDefaultSelected(event);
        }
    }

    /**
     * Informs all registered vertical ruler listeners that the content menu on a selected annotation\
     * is about to be shown.
     * TODO use robust iterators
     *
     * @param event the event to fire
     * @param menu the menu that is about to be shown
     * @since 3.0
     */
    public void fireAnnotationContextMenuAboutToShow(VerticalRulerEvent event, Menu menu) {
        // forward to listeners
        for (Iterator it= fAnnotationListeners.iterator(); it.hasNext();) {
            IVerticalRulerListener listener= cast(IVerticalRulerListener) it.next();
            listener.annotationContextMenuAboutToShow(event, menu);
        }
    }

    /**
     * Relayouts the receiver.
     *
     * @since 3.3
     */
    public void relayout() {
        layoutTextViewer();
    }
}
