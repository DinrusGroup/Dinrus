/*******************************************************************************
 * Copyright (c) 2000, 2008 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *     Steffen Pingel <steffen.pingel@tasktop.com> (Tasktop Technologies Inc.) - [navigation] hyperlink decoration is not erased when mouse is moved out of Text widget - https://bugs.eclipse.org/bugs/show_bug.cgi?id=100278
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/
module dwtx.jface.text.hyperlink.HyperlinkManager;

import dwtx.jface.text.hyperlink.IHyperlinkPresenterExtension; // packageimport
import dwtx.jface.text.hyperlink.MultipleHyperlinkPresenter; // packageimport
import dwtx.jface.text.hyperlink.URLHyperlink; // packageimport
import dwtx.jface.text.hyperlink.IHyperlinkDetectorExtension2; // packageimport
import dwtx.jface.text.hyperlink.IHyperlinkDetector; // packageimport
import dwtx.jface.text.hyperlink.IHyperlinkPresenter; // packageimport
import dwtx.jface.text.hyperlink.URLHyperlinkDetector; // packageimport
import dwtx.jface.text.hyperlink.DefaultHyperlinkPresenter; // packageimport
import dwtx.jface.text.hyperlink.AbstractHyperlinkDetector; // packageimport
import dwtx.jface.text.hyperlink.IHyperlinkDetectorExtension; // packageimport
import dwtx.jface.text.hyperlink.HyperlinkMessages; // packageimport
import dwtx.jface.text.hyperlink.IHyperlink; // packageimport


import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;

import dwt.DWT;
import dwt.custom.StyledText;
import dwt.events.FocusEvent;
import dwt.events.FocusListener;
import dwt.events.KeyEvent;
import dwt.events.KeyListener;
import dwt.events.MouseEvent;
import dwt.events.MouseListener;
import dwt.events.MouseMoveListener;
import dwt.events.MouseTrackListener;
import dwt.graphics.Point;
import dwt.widgets.Display;
import dwt.widgets.Event;
import dwt.widgets.Listener;
import dwtx.core.runtime.Assert;
import dwtx.jface.text.IRegion;
import dwtx.jface.text.ITextListener;
import dwtx.jface.text.ITextViewer;
import dwtx.jface.text.ITextViewerExtension5;
import dwtx.jface.text.Region;
import dwtx.jface.text.TextEvent;


/**
 * Default implementation of a hyperlink manager.
 *
 * @since 3.1
 */
public class HyperlinkManager : ITextListener, Listener, KeyListener, MouseListener, MouseMoveListener, FocusListener, MouseTrackListener {

    /**
     * Detection strategy.
     */
    public static final class DETECTION_STRATEGY {

        String fName;

        private this(String name) {
            fName= name;
        }

        /*
         * @see java.lang.Object#toString()
         */
        public override String toString() {
            return fName;
        }
    }


    /**
     * The first detected hyperlink is passed to the
     * hyperlink presenter and no further detector
     * is consulted.
     */
    private static DETECTION_STRATEGY FIRST_;
    public static DETECTION_STRATEGY FIRST(){
        if( FIRST_ is null ){
            synchronized( HyperlinkManager.classinfo ){
                if( FIRST_ is null ){
                    FIRST_ = new DETECTION_STRATEGY("first"); //$NON-NLS-1$
                }
            }
        }
        return FIRST_;
    }

    /**
     * All detected hyperlinks from all detectors are collected
     * and passed to the hyperlink presenter.
     * <p>
     * This strategy is only allowed if {@link IHyperlinkPresenter#canShowMultipleHyperlinks()}
     * returns <code>true</code>.
     * </p>
     */
    private static DETECTION_STRATEGY ALL_;
    public static DETECTION_STRATEGY ALL(){
        if( ALL_ is null ){
            synchronized( HyperlinkManager.classinfo ){
                if( ALL_ is null ){
                    ALL_ = new DETECTION_STRATEGY("all"); //$NON-NLS-1$
                }
            }
        }
        return ALL_;
    }

    /**
     * All detected hyperlinks from all detectors are collected
     * and all those with the longest region are passed to the
     * hyperlink presenter.
     * <p>
     * This strategy is only allowed if {@link IHyperlinkPresenter#canShowMultipleHyperlinks()}
     * returns <code>true</code>.
     * </p>
     */
    private static DETECTION_STRATEGY LONGEST_REGION_ALL_;
    public static DETECTION_STRATEGY LONGEST_REGION_ALL(){
        if( LONGEST_REGION_ALL_ is null ){
            synchronized( HyperlinkManager.classinfo ){
                if( LONGEST_REGION_ALL_ is null ){
                    LONGEST_REGION_ALL_ = new DETECTION_STRATEGY("all with same longest region"); //$NON-NLS-1$
                }
            }
        }
        return LONGEST_REGION_ALL_;
    }

    /**
     * All detected hyperlinks from all detectors are collected
     * and form all those with the longest region only the first
     * one is passed to the hyperlink presenter.
     */
    private static DETECTION_STRATEGY LONGEST_REGION_FIRST_;
    public static DETECTION_STRATEGY LONGEST_REGION_FIRST(){
        if( LONGEST_REGION_FIRST_ is null ){
            synchronized( HyperlinkManager.classinfo ){
                if( LONGEST_REGION_FIRST_ is null ){
                    LONGEST_REGION_FIRST_ = new DETECTION_STRATEGY("first with longest region"); //$NON-NLS-1$
                }
            }
        }
        return LONGEST_REGION_FIRST_;
    }


    /** The text viewer on which this hyperlink manager works. */
    private ITextViewer fTextViewer;
    /** The session is active. */
    private bool fActive;
    /** The key modifier mask. */
    private int fHyperlinkStateMask;
    /**
     * The active key modifier mask.
     * @since 3.3
     */
    private int fActiveHyperlinkStateMask;
    /** The active hyperlinks. */
    private IHyperlink[] fActiveHyperlinks;
    /** The hyperlink detectors. */
    private IHyperlinkDetector[] fHyperlinkDetectors;
    /** The hyperlink presenter. */
    private IHyperlinkPresenter fHyperlinkPresenter;
    /** The detection strategy. */
    private const DETECTION_STRATEGY fDetectionStrategy;


    /**
     * Creates a new hyperlink manager.
     *
     * @param detectionStrategy the detection strategy one of {{@link #ALL}, {@link #FIRST}, {@link #LONGEST_REGION_ALL}, {@link #LONGEST_REGION_FIRST}}
     */
    public this(DETECTION_STRATEGY detectionStrategy) {
        Assert.isNotNull(detectionStrategy);
        fDetectionStrategy= detectionStrategy;
    }

    /**
     * Installs this hyperlink manager with the given arguments.
     *
     * @param textViewer the text viewer
     * @param hyperlinkPresenter the hyperlink presenter
     * @param hyperlinkDetectors the array of hyperlink detectors, must not be empty
     * @param eventStateMask the DWT event state mask to activate hyperlink mode
     */
    public void install(ITextViewer textViewer, IHyperlinkPresenter hyperlinkPresenter, IHyperlinkDetector[] hyperlinkDetectors, int eventStateMask) {
        Assert.isNotNull(cast(Object)textViewer);
        Assert.isNotNull(cast(Object)hyperlinkPresenter);
        fTextViewer= textViewer;
        fHyperlinkPresenter= hyperlinkPresenter;
        Assert.isLegal(fHyperlinkPresenter.canShowMultipleHyperlinks() || fDetectionStrategy is FIRST || fDetectionStrategy is LONGEST_REGION_FIRST);
        setHyperlinkDetectors(hyperlinkDetectors);
        setHyperlinkStateMask(eventStateMask);

        StyledText text= fTextViewer.getTextWidget();
        if (text is null || text.isDisposed())
            return;

        text.getDisplay().addFilter(DWT.KeyUp, this);
        text.addKeyListener(this);
        text.addMouseListener(this);
        text.addMouseMoveListener(this);
        text.addFocusListener(this);
        text.addMouseTrackListener(this);

        fTextViewer.addTextListener(this);

        fHyperlinkPresenter.install(fTextViewer);
    }

    /**
     * Sets the hyperlink detectors for this hyperlink manager.
     * <p>
     * It is allowed to call this method after this
     * hyperlink manger has been installed.
     * </p>
     *
     * @param hyperlinkDetectors and array of hyperlink detectors, must not be empty
     */
    public void setHyperlinkDetectors(IHyperlinkDetector[] hyperlinkDetectors) {
        Assert.isTrue(hyperlinkDetectors !is null && hyperlinkDetectors.length > 0);
        if (fHyperlinkDetectors is null){
            fHyperlinkDetectors= hyperlinkDetectors;
        }
        else {
            synchronized (/+fHyperlinkDetectors+/this) {
                fHyperlinkDetectors= hyperlinkDetectors;
            }
        }
    }

    /**
     * Sets the DWT event state mask which in combination
     * with the left mouse button triggers the hyperlink mode.
     * <p>
     * It is allowed to call this method after this
     * hyperlink manger has been installed.
     * </p>
     *
     * @param eventStateMask the DWT event state mask to activate hyperlink mode
     */
    public void setHyperlinkStateMask(int eventStateMask) {
        fHyperlinkStateMask= eventStateMask;
    }

    /**
     * Uninstalls this hyperlink manager.
     */
    public void uninstall() {
        deactivate();

        StyledText text= fTextViewer.getTextWidget();
        if (text !is null && !text.isDisposed()) {
            text.removeKeyListener(this);
            text.getDisplay().removeFilter(DWT.KeyUp, this);
            text.removeMouseListener(this);
            text.removeMouseMoveListener(this);
            text.removeFocusListener(this);
            text.removeMouseTrackListener(this);
        }
        fTextViewer.removeTextListener(this);

        fHyperlinkPresenter.uninstall();

        fHyperlinkPresenter= null;
        fTextViewer= null;
        fHyperlinkDetectors= null;
    }

    /**
     * Deactivates the currently shown hyperlinks.
     */
    protected void deactivate() {
        fHyperlinkPresenter.hideHyperlinks();
        fActive= false;
    }

    /**
     * Finds hyperlinks at the current offset.
     *
     * @return the hyperlinks or <code>null</code> if none.
     */
    protected IHyperlink[] findHyperlinks() {
        int offset= getCurrentTextOffset();
        if (offset is -1)
            return null;

        bool canShowMultipleHyperlinks= fHyperlinkPresenter.canShowMultipleHyperlinks();
        IRegion region= new Region(offset, 0);
        List allHyperlinks= new ArrayList(fHyperlinkDetectors.length * 2);
        synchronized (/+fHyperlinkDetectors+/this) {
            for (int i= 0, length= fHyperlinkDetectors.length; i < length; i++) {
                IHyperlinkDetector detector= fHyperlinkDetectors[i];
                if (detector is null)
                    continue;

                if ( cast(IHyperlinkDetectorExtension2)detector ) {
                    int stateMask= (cast(IHyperlinkDetectorExtension2)detector).getStateMask();
                    if (stateMask !is -1 && stateMask !is fActiveHyperlinkStateMask)
                        continue;
                    else if (stateMask is -1 && fActiveHyperlinkStateMask !is fHyperlinkStateMask)
                    continue;
                } else if (fActiveHyperlinkStateMask !is fHyperlinkStateMask)
                    continue;

                IHyperlink[] hyperlinks= detector.detectHyperlinks(fTextViewer, region, canShowMultipleHyperlinks);
                if (hyperlinks is null)
                    continue;

                Assert.isLegal(hyperlinks.length > 0);

                if (fDetectionStrategy is FIRST) {
                    if (hyperlinks.length is 1)
                        return hyperlinks;
                    return [hyperlinks[0]];
                }
                allHyperlinks.addAll(Arrays.asList(arraycast!(Object)(hyperlinks)));
            }
        }

        if (allHyperlinks.isEmpty())
            return null;

        if (fDetectionStrategy !is ALL) {
            int maxLength= computeLongestHyperlinkLength(allHyperlinks);
            Iterator iter= (new ArrayList(allHyperlinks)).iterator();
            while (iter.hasNext()) {
                IHyperlink hyperlink= cast(IHyperlink)iter.next();
                if (hyperlink.getHyperlinkRegion().getLength() < maxLength)
                    allHyperlinks.remove(cast(Object)hyperlink);
            }
        }

        if (fDetectionStrategy is LONGEST_REGION_FIRST)
            return [cast(IHyperlink)allHyperlinks.get(0)];

        return arraycast!(IHyperlink)(allHyperlinks.toArray());

    }

    /**
     * Computes the length of the longest detected
     * hyperlink.
     *
     * @param hyperlinks
     * @return the length of the longest detected
     */
    protected int computeLongestHyperlinkLength(List hyperlinks) {
        Assert.isLegal(hyperlinks !is null && !hyperlinks.isEmpty());
        Iterator iter= hyperlinks.iterator();
        int length= Integer.MIN_VALUE;
        while (iter.hasNext()) {
            IRegion region= (cast(IHyperlink)iter.next()).getHyperlinkRegion();
            if (region.getLength() < length)
                continue;
            length= region.getLength();
        }
        return length;
    }

    /**
     * Returns the current text offset.
     *
     * @return the current text offset
     */
    protected int getCurrentTextOffset() {

        try {
            StyledText text= fTextViewer.getTextWidget();
            if (text is null || text.isDisposed())
                return -1;

            Display display= text.getDisplay();
            Point absolutePosition= display.getCursorLocation();
            Point relativePosition= text.toControl(absolutePosition);

            int widgetOffset= text.getOffsetAtLocation(relativePosition);
            Point p= text.getLocationAtOffset(widgetOffset);
            if (p.x > relativePosition.x)
                widgetOffset--;

            if ( cast(ITextViewerExtension5)fTextViewer ) {
                ITextViewerExtension5 extension= cast(ITextViewerExtension5)fTextViewer;
                return extension.widgetOffset2ModelOffset(widgetOffset);
            }

            return widgetOffset + fTextViewer.getVisibleRegion().getOffset();

        } catch (IllegalArgumentException e) {
            return -1;
        }
    }

    /*
     * @see dwt.events.KeyListener#keyPressed(dwt.events.KeyEvent)
     */
    public void keyPressed(KeyEvent event) {

        if (fActive) {
            deactivate();
            return;
        }

        if (!isRegisteredStateMask(event.keyCode)) {
            deactivate();
            return;
        }

        fActive= true;
        fActiveHyperlinkStateMask= event.keyCode;

//          removed for #25871 (hyperlinks could interact with typing)
//
//          ITextViewer viewer= getSourceViewer();
//          if (viewer is null)
//              return;
//
//          IRegion region= getCurrentTextRegion(viewer);
//          if (region is null)
//              return;
//
//          highlightRegion(viewer, region);
//          activateCursor(viewer);
    }

    /*
     * @see dwt.events.KeyListener#keyReleased(dwt.events.KeyEvent)
     */
    public void keyReleased(KeyEvent event) {
    }

    /*
     * @see dwt.events.MouseListener#mouseDoubleClick(dwt.events.MouseEvent)
     */
    public void mouseDoubleClick(MouseEvent e) {

    }

    /*
     * @see dwt.events.MouseListener#mouseDown(dwt.events.MouseEvent)
     */
    public void mouseDown(MouseEvent event) {

        if (!fActive)
            return;

        if (event.stateMask !is fActiveHyperlinkStateMask) {
            deactivate();
            return;
        }

        if (event.button !is 1) {
            deactivate();
            return;
        }
    }

    /*
     * @see dwt.events.MouseListener#mouseUp(dwt.events.MouseEvent)
     */
    public void mouseUp(MouseEvent e) {

        if (!fActive) {
            fActiveHyperlinks= null;
            return;
        }

        if (e.button !is 1)
            fActiveHyperlinks= null;

        deactivate();

        if (fActiveHyperlinks !is null)
            fActiveHyperlinks[0].open();
    }

    /*
     * @see dwt.events.MouseMoveListener#mouseMove(dwt.events.MouseEvent)
     */
    public void mouseMove(MouseEvent event) {
        if ( cast(IHyperlinkPresenterExtension)fHyperlinkPresenter ) {
            if (!(cast(IHyperlinkPresenterExtension)fHyperlinkPresenter).canHideHyperlinks())
                return;
        }

        if (!isRegisteredStateMask(event.stateMask)) {
            if (fActive)
                deactivate();

            return;
        }

        fActive= true;
        fActiveHyperlinkStateMask= event.stateMask;

        StyledText text= fTextViewer.getTextWidget();
        if (text is null || text.isDisposed()) {
            deactivate();
            return;
        }

        if ((event.stateMask & DWT.BUTTON1) !is 0 && text.getSelectionCount() !is 0) {
            deactivate();
            return;
        }

        fActiveHyperlinks= findHyperlinks();
        if (fActiveHyperlinks is null || fActiveHyperlinks.length is 0) {
            fHyperlinkPresenter.hideHyperlinks();
            return;
        }

        fHyperlinkPresenter.showHyperlinks(fActiveHyperlinks);

    }

    /**
     * Checks whether the given state mask is registered.
     *
     * @param stateMask
     * @return <code>true</code> if a detector is registered for the given state mask
     * @since 3.3
     */
    private bool isRegisteredStateMask(int stateMask) {
        if (stateMask is fHyperlinkStateMask)
            return true;

        synchronized (/+fHyperlinkDetectors+/this) {
            for (int i= 0; i < fHyperlinkDetectors.length; i++) {
                if (cast(IHyperlinkDetectorExtension2)fHyperlinkDetectors[i] ) {
                    if (stateMask is (cast(IHyperlinkDetectorExtension2)fHyperlinkDetectors[i]).getStateMask())
                        return true;
                }
            }
        }
        return false;
    }

    /*
     * @see dwt.events.FocusListener#focusGained(dwt.events.FocusEvent)
     */
    public void focusGained(FocusEvent e) {}

    /*
     * @see dwt.events.FocusListener#focusLost(dwt.events.FocusEvent)
     */
    public void focusLost(FocusEvent event) {
        deactivate();
    }

    /*
     * @see dwt.widgets.Listener#handleEvent(dwt.widgets.Event)
     * @since 3.2
     */
    public void handleEvent(Event event) {
        //key up
        deactivate();
    }

    /*
     * @see dwtx.jface.text.ITextListener#textChanged(TextEvent)
     * @since 3.2
     */
    public void textChanged(TextEvent event) {
        if (event.getDocumentEvent() !is null)
            deactivate();
    }

    /**
     * {@inheritDoc}
     *
     * @since 3.4
     */
    public void mouseExit(MouseEvent e) {
        if ( cast(IHyperlinkPresenterExtension)fHyperlinkPresenter ) {
            if (!(cast(IHyperlinkPresenterExtension)fHyperlinkPresenter).canHideHyperlinks())
                return;
        }
        deactivate();
    }

    /**
     * {@inheritDoc}
     *
     * @since 3.4
     */
    public void mouseEnter(MouseEvent e) {
    }

    /**
     * {@inheritDoc}
     *
     * @since 3.4
     */
    public void mouseHover(MouseEvent e) {
    }

}
