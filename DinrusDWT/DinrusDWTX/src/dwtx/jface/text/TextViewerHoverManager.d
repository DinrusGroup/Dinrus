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
module dwtx.jface.text.TextViewerHoverManager;

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
import dwtx.dwtxhelper.JThread;

import dwt.custom.StyledText;
import dwt.events.MouseEvent;
import dwt.events.MouseMoveListener;
import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwt.widgets.Display;
import dwtx.core.runtime.ILog;
import dwtx.core.runtime.IStatus;
import dwtx.core.runtime.Platform;
import dwtx.core.runtime.Status;


/**
 * This manager controls the layout, content, and visibility of an information
 * control in reaction to mouse hover events issued by the text widget of a
 * text viewer. It overrides <code>computeInformation</code>, so that the
 * computation is performed in a dedicated background thread. This implies
 * that the used <code>ITextHover</code> objects must be capable of
 * operating in a non-UI thread.
 *
 * @since 2.0
 */
class TextViewerHoverManager : AbstractHoverInformationControlManager , IWidgetTokenKeeper, IWidgetTokenKeeperExtension {


    /**
     * Priority of the hovers managed by this manager.
     * Default value: <code>0</code>;
     * @since 3.0
     */
    public const static int WIDGET_PRIORITY= 0;


    /** The text viewer */
    private TextViewer fTextViewer;
    /** The hover information computation thread */
    private JThread fThread;
    /** The stopper of the computation thread */
    private ITextListener fStopper;
    /** Internal monitor */
    private Object fMutex;
    /** The currently shown text hover. */
    private /+volatile+/ ITextHover fTextHover;
    /**
     * Tells whether the next mouse hover event
     * should be processed.
     * @since 3.0
     */
    private bool fProcessMouseHoverEvent= true;
    /**
     * Internal mouse move listener.
     * @since 3.0
     */
    private MouseMoveListener fMouseMoveListener;
    /**
     * Internal view port listener.
     * @since 3.0
     */
    private IViewportListener fViewportListener;


    /**
     * Creates a new text viewer hover manager specific for the given text viewer.
     * The manager uses the given information control creator.
     *
     * @param textViewer the viewer for which the controller is created
     * @param creator the information control creator
     */
    public this(TextViewer textViewer, IInformationControlCreator creator) {
        fMutex= new Object();
        super(creator);
        fTextViewer= textViewer;
        fStopper= new class() ITextListener {
            public void textChanged(TextEvent event) {
                synchronized (fMutex) {
                    if (fThread !is null) {
implMissing(__FILE__,__LINE__);
// DWT FIXME: how to handle Thread.interrupt?
//                         fThread.interrupt();
                        fThread= null;
                    }
                }
            }
        };
        fViewportListener= new class()  IViewportListener {
            /*
             * @see dwtx.jface.text.IViewportListener#viewportChanged(int)
             */
            public void viewportChanged(int verticalOffset) {
                fProcessMouseHoverEvent= false;
            }
        };
        fTextViewer.addViewportListener(fViewportListener);
        fMouseMoveListener= new class()  MouseMoveListener {
            /*
             * @see MouseMoveListener#mouseMove(MouseEvent)
             */
            public void mouseMove(MouseEvent event) {
                fProcessMouseHoverEvent= true;
            }
        };
        fTextViewer.getTextWidget().addMouseMoveListener(fMouseMoveListener);
    }

    /**
     * Determines all necessary details and delegates the computation into
     * a background thread.
     */
    protected void computeInformation() {

        if (!fProcessMouseHoverEvent) {
            setInformation(cast(Object)null, null);
            return;
        }

        Point location= getHoverEventLocation();
        int offset= computeOffsetAtLocation(location.x, location.y);
        if (offset is -1) {
            setInformation(cast(Object)null, null);
            return;
        }

        ITextHover hover= fTextViewer.getTextHover_package(offset, getHoverEventStateMask());
        if (hover is null) {
            setInformation(cast(Object)null, null);
            return;
        }

        IRegion region= hover.getHoverRegion(fTextViewer, offset);
        if (region is null) {
            setInformation(cast(Object)null, null);
            return;
        }

        Rectangle area= JFaceTextUtil.computeArea(region, fTextViewer);
        if (area is null || area.isEmpty()) {
            setInformation(cast(Object)null, null);
            return;
        }

        if (fThread !is null) {
            setInformation(cast(Object)null, null);
            return;
        }
        fThread= new JThread( dgRunnable( (ITextHover hover_, IRegion region_, Rectangle area_){
            // http://bugs.eclipse.org/bugs/show_bug.cgi?id=17693
            bool hasFinished= false;
            try {
                if (fThread !is null) {
                    Object information;
                    try {
                        if ( cast(ITextHoverExtension2)hover_ )
                            information= (cast(ITextHoverExtension2)hover_).getHoverInfo2(fTextViewer, region_);
                        else
                            information= stringcast(hover_.getHoverInfo(fTextViewer, region_));
                    } catch (ArrayIndexOutOfBoundsException x) {
                        /*
                            * This code runs in a separate thread which can
                            * lead to text offsets being out of bounds when
                            * computing the hover info (see bug 32848).
                            */
                        information= null;
                    }

                    if ( cast(ITextHoverExtension)hover_ )
                        setCustomInformationControlCreator((cast(ITextHoverExtension) hover_).getHoverControlCreator());
                    else
                        setCustomInformationControlCreator(null);

                    setInformation(information, area_);
                    if (information !is null)
                        fTextHover= hover_;
                } else {
                    setInformation(cast(Object)null, null);
                }
                hasFinished= true;
            } catch (RuntimeException ex) {
                String PLUGIN_ID= "dwtx.jface.text"; //$NON-NLS-1$
                ILog log= Platform.getLog(Platform.getBundle(PLUGIN_ID));
                log.log(new Status(IStatus.ERROR, PLUGIN_ID, IStatus.OK, "Unexpected runtime error while computing a text hover", ex)); //$NON-NLS-1$
            } finally {
                synchronized (fMutex) {
                    if (fTextViewer !is null)
                        fTextViewer.removeTextListener(fStopper);
                    fThread= null;
                    // https://bugs.eclipse.org/bugs/show_bug.cgi?id=44756
                    if (!hasFinished)
                        setInformation(cast(Object)null, null);
                }
            }
        }, hover, region, area ) );

        fThread.setName( "Text Viewer Hover Presenter" ); //$NON-NLS-1$

        fThread.setDaemon(true);
        fThread.setPriority(JThread.MIN_PRIORITY);
        synchronized (fMutex) {
            fTextViewer.addTextListener(fStopper);
            fThread.start();
        }
    }

    /**
     * As computation is done in the background, this method is
     * also called in the background thread. Delegates the control
     * flow back into the UI thread, in order to allow displaying the
     * information in the information control.
     */
    protected void presentInformation() {
        if (fTextViewer is null)
            return;

        StyledText textWidget= fTextViewer.getTextWidget();
        if (textWidget !is null && !textWidget.isDisposed()) {
            Display display= textWidget.getDisplay();
            if (display is null)
                return;

            display.asyncExec(new class()  Runnable {
                public void run() {
                    doPresentInformation();
                }
            });
        }
    }

    /*
     * @see AbstractInformationControlManager#presentInformation()
     */
    protected void doPresentInformation() {
        super.presentInformation();
    }

    /**
     * Computes the document offset underlying the given text widget coordinates.
     * This method uses a linear search as it cannot make any assumption about
     * how the document is actually presented in the widget. (Covers cases such
     * as bidirectional text.)
     *
     * @param x the horizontal coordinate inside the text widget
     * @param y the vertical coordinate inside the text widget
     * @return the document offset corresponding to the given point
     */
    private int computeOffsetAtLocation(int x, int y) {

        try {

            StyledText styledText= fTextViewer.getTextWidget();
            int widgetOffset= styledText.getOffsetAtLocation(new Point(x, y));
            Point p= styledText.getLocationAtOffset(widgetOffset);
            if (p.x > x)
                widgetOffset--;

            if ( cast(ITextViewerExtension5)fTextViewer ) {
                ITextViewerExtension5 extension= cast(ITextViewerExtension5) fTextViewer;
                return extension.widgetOffset2ModelOffset(widgetOffset);
            }

            return widgetOffset + fTextViewer._getVisibleRegionOffset_package();

        } catch (IllegalArgumentException e) {
            return -1;
        }
    }

    /*
     * @see dwtx.jface.text.AbstractInformationControlManager#showInformationControl(dwt.graphics.Rectangle)
     */
    protected void showInformationControl(Rectangle subjectArea) {
        if (fTextViewer !is null && fTextViewer.requestWidgetToken(this, WIDGET_PRIORITY))
            super.showInformationControl(subjectArea);
        else
            if (DEBUG)
                System.out_.println("TextViewerHoverManager#showInformationControl(..) did not get widget token"); //$NON-NLS-1$
    }

    /*
     * @see dwtx.jface.text.AbstractInformationControlManager#hideInformationControl()
     */
    protected void hideInformationControl() {
        try {
            fTextHover= null;
            super.hideInformationControl();
        } finally {
            if (fTextViewer !is null)
                fTextViewer.releaseWidgetToken(this);
        }
    }

    /*
     * @see dwtx.jface.text.AbstractInformationControlManager#replaceInformationControl(bool)
     * @since 3.4
     */
    void replaceInformationControl(bool takeFocus) {
        if (fTextViewer !is null)
            fTextViewer.releaseWidgetToken(this);
        super.replaceInformationControl(takeFocus);
    }

    /*
     * @see dwtx.jface.text.AbstractInformationControlManager#handleInformationControlDisposed()
     */
    protected void handleInformationControlDisposed() {
        try {
            super.handleInformationControlDisposed();
        } finally {
            if (fTextViewer !is null)
                fTextViewer.releaseWidgetToken(this);
        }
    }

    /*
     * @see dwtx.jface.text.IWidgetTokenKeeper#requestWidgetToken(dwtx.jface.text.IWidgetTokenOwner)
     */
    public bool requestWidgetToken(IWidgetTokenOwner owner) {
        fTextHover= null;
        super.hideInformationControl();
        return true;
    }

    /*
     * @see dwtx.jface.text.IWidgetTokenKeeperExtension#requestWidgetToken(dwtx.jface.text.IWidgetTokenOwner, int)
     * @since 3.0
     */
    public bool requestWidgetToken(IWidgetTokenOwner owner, int priority) {
        if (priority > WIDGET_PRIORITY) {
            fTextHover= null;
            super.hideInformationControl();
            return true;
        }
        return false;
    }

    /*
     * @see dwtx.jface.text.IWidgetTokenKeeperExtension#setFocus(dwtx.jface.text.IWidgetTokenOwner)
     * @since 3.0
     */
    public bool setFocus(IWidgetTokenOwner owner) {
        if (! hasInformationControlReplacer())
            return false;

        IInformationControl iControl= getCurrentInformationControl();
        if (canReplace(iControl)) {
            if (cancelReplacingDelay())
                replaceInformationControl(true);

            return true;
        }

        return false;
    }

    /**
     * Returns the currently shown text hover or <code>null</code> if no text
     * hover is shown.
     *
     * @return the currently shown text hover or <code>null</code>
     */
    protected ITextHover getCurrentTextHover() {
        return fTextHover;
    }
    package ITextHover getCurrentTextHover_package() {
        return getCurrentTextHover();
    }

    /*
     * @see dwtx.jface.text.AbstractHoverInformationControlManager#dispose()
     * @since 3.0
     */
    public void dispose() {
        if (fTextViewer !is null) {
            fTextViewer.removeViewportListener(fViewportListener);
            fViewportListener= null;

            StyledText st= fTextViewer.getTextWidget();
            if (st !is null && !st.isDisposed())
                st.removeMouseMoveListener(fMouseMoveListener);
            fMouseMoveListener= null;
        }
        super.dispose();
    }
}
