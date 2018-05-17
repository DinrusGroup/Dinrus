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
module dwtx.jface.text.information.InformationPresenter;

import dwtx.jface.text.information.IInformationProvider; // packageimport
import dwtx.jface.text.information.IInformationProviderExtension; // packageimport
import dwtx.jface.text.information.IInformationPresenterExtension; // packageimport
import dwtx.jface.text.information.IInformationProviderExtension2; // packageimport
import dwtx.jface.text.information.IInformationPresenter; // packageimport


import dwt.dwthelper.utils;

import dwtx.dwtxhelper.Collection;


import dwt.custom.StyledText;
import dwt.events.ControlEvent;
import dwt.events.ControlListener;
import dwt.events.FocusEvent;
import dwt.events.FocusListener;
import dwt.events.KeyEvent;
import dwt.events.KeyListener;
import dwt.events.MouseEvent;
import dwt.events.MouseListener;
import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwt.widgets.Control;
import dwt.widgets.Display;
import dwtx.core.runtime.Assert;
import dwtx.jface.text.AbstractInformationControlManager;
import dwtx.jface.text.BadLocationException;
import dwtx.jface.text.IDocumentExtension3;
import dwtx.jface.text.IInformationControl;
import dwtx.jface.text.IInformationControlCreator;
import dwtx.jface.text.IRegion;
import dwtx.jface.text.ITextViewer;
import dwtx.jface.text.ITextViewerExtension5;
import dwtx.jface.text.IViewportListener;
import dwtx.jface.text.IWidgetTokenKeeper;
import dwtx.jface.text.IWidgetTokenKeeperExtension;
import dwtx.jface.text.IWidgetTokenOwner;
import dwtx.jface.text.IWidgetTokenOwnerExtension;
import dwtx.jface.text.Region;
import dwtx.jface.text.TextUtilities;


/**
 * Standard implementation of <code>IInformationPresenter</code>.
 * This implementation extends <code>AbstractInformationControlManager</code>.
 * The information control is made visible on request by calling
 * {@link #showInformationControl(Rectangle)}.
 * <p>
 * Usually, clients instantiate this class and configure it before using it. The configuration
 * must be consistent: This means the used {@link dwtx.jface.text.IInformationControlCreator}
 * must create an information control expecting information in the same format the configured
 * {@link dwtx.jface.text.information.IInformationProvider}s  use to encode the information they provide.
 * </p>
 *
 * @since 2.0
 */
public class InformationPresenter : AbstractInformationControlManager , IInformationPresenter, IInformationPresenterExtension, IWidgetTokenKeeper, IWidgetTokenKeeperExtension {

    alias AbstractInformationControlManager.install install;
    public override void showInformation(){
        super.showInformation();
    }

    /**
     * Priority of the info controls managed by this information presenter.
     * Default value: <code>5</code>.
     *
     * @since 3.0
     */
    /*
     * 5 as value has been chosen in order to beat the hovers of {@link dwtx.jface.text.TextViewerHoverManager}
     */
    public static const int WIDGET_PRIORITY= 5;


    /**
     * Internal information control closer. Listens to several events issued by its subject control
     * and closes the information control when necessary.
     */
    class Closer : IInformationControlCloser, ControlListener, MouseListener, FocusListener, IViewportListener, KeyListener {

        /** The subject control. */
        private Control fSubjectControl;
        /** The information control. */
        private IInformationControl fInformationControlToClose;
        /** Indicates whether this closer is active. */
        private bool fIsActive= false;

        /*
         * @see IInformationControlCloser#setSubjectControl(Control)
         */
        public void setSubjectControl(Control control) {
            fSubjectControl= control;
        }

        /*
         * @see IInformationControlCloser#setInformationControl(IInformationControl)
         */
        public void setInformationControl(IInformationControl control) {
            fInformationControlToClose= control;
        }

        /*
         * @see IInformationControlCloser#start(Rectangle)
         */
        public void start(Rectangle informationArea) {

            if (fIsActive)
                return;
            fIsActive= true;

            if (fSubjectControl !is null && !fSubjectControl.isDisposed()) {
                fSubjectControl.addControlListener(this);
                fSubjectControl.addMouseListener(this);
                fSubjectControl.addFocusListener(this);
                fSubjectControl.addKeyListener(this);
            }

            if (fInformationControlToClose !is null)
                fInformationControlToClose.addFocusListener(this);

            fTextViewer.addViewportListener(this);
        }

        /*
         * @see IInformationControlCloser#stop()
         */
        public void stop() {

            if (!fIsActive)
                return;
            fIsActive= false;

            fTextViewer.removeViewportListener(this);

            if (fInformationControlToClose !is null)
                fInformationControlToClose.removeFocusListener(this);

            if (fSubjectControl !is null && !fSubjectControl.isDisposed()) {
                fSubjectControl.removeControlListener(this);
                fSubjectControl.removeMouseListener(this);
                fSubjectControl.removeFocusListener(this);
                fSubjectControl.removeKeyListener(this);
            }
        }

        /*
         * @see ControlListener#controlResized(ControlEvent)
         */
         public void controlResized(ControlEvent e) {
             hideInformationControl();
        }

        /*
         * @see ControlListener#controlMoved(ControlEvent)
         */
         public void controlMoved(ControlEvent e) {
             hideInformationControl();
        }

        /*
         * @see MouseListener#mouseDown(MouseEvent)
         */
         public void mouseDown(MouseEvent e) {
             hideInformationControl();
        }

        /*
         * @see MouseListener#mouseUp(MouseEvent)
         */
        public void mouseUp(MouseEvent e) {
        }

        /*
         * @see MouseListener#mouseDoubleClick(MouseEvent)
         */
        public void mouseDoubleClick(MouseEvent e) {
            hideInformationControl();
        }

        /*
         * @see FocusListener#focusGained(FocusEvent)
         */
        public void focusGained(FocusEvent e) {
        }

        /*
         * @see FocusListener#focusLost(FocusEvent)
         */
         public void focusLost(FocusEvent e) {
            Display d= fSubjectControl.getDisplay();
            d.asyncExec(new class()  Runnable {
                // Without the asyncExec, mouse clicks to the workbench window are swallowed.
                public void run() {
                    if (fInformationControlToClose is null || !fInformationControlToClose.isFocusControl())
                        hideInformationControl();
                }
            });
        }

        /*
         * @see IViewportListenerListener#viewportChanged(int)
         */
        public void viewportChanged(int topIndex) {
            hideInformationControl();
        }

        /*
         * @see KeyListener#keyPressed(KeyEvent)
         */
        public void keyPressed(KeyEvent e) {
            hideInformationControl();
        }

        /*
         * @see KeyListener#keyReleased(KeyEvent)
         */
        public void keyReleased(KeyEvent e) {
        }
    }


    /** The text viewer this information presenter works on */
    private ITextViewer fTextViewer;
    /** The map of <code>IInformationProvider</code> objects */
    private Map fProviders;
    /** The offset to override selection. */
    private int fOffset= -1;
    /**
     * The document partitioning for this information presenter.
     * @since 3.0
     */
    private String fPartitioning;

    /**
     * Creates a new information presenter that uses the given information control creator.
     * The presenter is not installed on any text viewer yet. By default, an information
     * control closer is set that closes the information control in the event of key strokes,
     * resizing, moves, focus changes, mouse clicks, and disposal - all of those applied to
     * the information control's parent control. Also, the setup ensures that the information
     * control when made visible will request the focus. By default, the default document
     * partitioning {@link IDocumentExtension3#DEFAULT_PARTITIONING} is used.
     *
     * @param creator the information control creator to be used
     */
    public this(IInformationControlCreator creator) {
        super(creator);
        setCloser(new Closer());
        takesFocusWhenVisible(true);
        fPartitioning= IDocumentExtension3.DEFAULT_PARTITIONING;
    }

    /**
     * Sets the document partitioning to be used by this information presenter.
     *
     * @param partitioning the document partitioning to be used by this information presenter
     * @since 3.0
     */
    public void setDocumentPartitioning(String partitioning) {
        Assert.isNotNull(partitioning);
        fPartitioning= partitioning;
    }

    /*
     * @see dwtx.jface.text.information.IInformationPresenterExtension#getDocumentPartitioning()
     * @since 3.0
     */
    public String getDocumentPartitioning() {
        return fPartitioning;
    }

    /**
     * Registers a given information provider for a particular content type.
     * If there is already a provider registered for this type, the new provider
     * is registered instead of the old one.
     *
     * @param provider the information provider to register, or <code>null</code> to remove an existing one
     * @param contentType the content type under which to register
     */
     public void setInformationProvider(IInformationProvider provider, String contentType) {

        Assert.isNotNull(contentType);

        if (fProviders is null)
            fProviders= new HashMap();

        if (provider is null)
            fProviders.remove(contentType);
        else
            fProviders.put(contentType, cast(Object)provider);
    }

    /*
     * @see IInformationPresenter#getInformationProvider(String)
     */
    public IInformationProvider getInformationProvider(String contentType) {
        if (fProviders is null)
            return null;

        return cast(IInformationProvider) fProviders.get(contentType);
    }

    /**
     * Sets a offset to override the selection. Setting the value to <code>-1</code> will disable
     * overriding.
     *
     * @param offset the offset to override selection or <code>-1</code>
     */
    public void setOffset(int offset) {
        fOffset= offset;
    }

    /*
     * @see AbstractInformationControlManager#computeInformation()
     */
    protected void computeInformation() {

        int offset= fOffset < 0 ? fTextViewer.getSelectedRange().x : fOffset;
        if (offset is -1)
            return;

        fOffset= -1;

        IInformationProvider provider= null;
        try {
            String contentType= TextUtilities.getContentType(fTextViewer.getDocument(), getDocumentPartitioning(), offset, true);
            provider= getInformationProvider(contentType);
        } catch (BadLocationException x) {
        }
        if (provider is null)
            return;

        IRegion subject= provider.getSubject(fTextViewer, offset);
        if (subject is null)
            return;

        Object info;
        if ( cast(IInformationProviderExtension)provider ) {
            IInformationProviderExtension extension= cast(IInformationProviderExtension) provider;
            info= extension.getInformation2(fTextViewer, subject);
        } else {
            // backward compatibility code
            info= stringcast(provider.getInformation(fTextViewer, subject));
        }

        if ( cast(IInformationProviderExtension2)provider )
            setCustomInformationControlCreator((cast(IInformationProviderExtension2) provider).getInformationPresenterControlCreator());
        else
            setCustomInformationControlCreator(null);

        setInformation(info, computeArea(subject));
    }

    /**
     * Determines the graphical area covered by the given text region.
     *
     * @param region the region whose graphical extend must be computed
     * @return the graphical extend of the given region
     */
    private Rectangle computeArea(IRegion region) {

        int start= 0;
        int end= 0;

        IRegion widgetRegion= modelRange2WidgetRange(region);
        if (widgetRegion !is null) {
            start= widgetRegion.getOffset();
            end= widgetRegion.getOffset() + widgetRegion.getLength();
        }

        StyledText styledText= fTextViewer.getTextWidget();
        Rectangle bounds;
        if (end > 0 && start < end)
            bounds= styledText.getTextBounds(start, end - 1);
        else {
            Point loc= styledText.getLocationAtOffset(start);
            bounds= new Rectangle(loc.x, loc.y, 0, styledText.getLineHeight(start));
        }

        return bounds;
    }

    /**
     * Translated the given range in the viewer's document into the corresponding
     * range of the viewer's widget.
     *
     * @param region the range in the viewer's document
     * @return the corresponding widget range
     * @since 2.1
     */
    private IRegion modelRange2WidgetRange(IRegion region) {
        if ( cast(ITextViewerExtension5)fTextViewer ) {
            ITextViewerExtension5 extension= cast(ITextViewerExtension5) fTextViewer;
            return extension.modelRange2WidgetRange(region);
        }

        IRegion visibleRegion= fTextViewer.getVisibleRegion();
        int start= region.getOffset() - visibleRegion.getOffset();
        int end= start + region.getLength();
        if (end > visibleRegion.getLength())
            end= visibleRegion.getLength();

        return new Region(start, end - start);
    }

    /*
     * @see IInformationPresenter#install(ITextViewer)
     */
    public void install(ITextViewer textViewer) {
        fTextViewer= textViewer;
        install(fTextViewer.getTextWidget());
    }

    /*
     * @see IInformationPresenter#uninstall()
     */
    public void uninstall() {
        dispose();
    }

    /*
     * @see AbstractInformationControlManager#showInformationControl(Rectangle)
     */
    protected void showInformationControl(Rectangle subjectArea) {
        if ( cast(IWidgetTokenOwnerExtension)fTextViewer  && cast(IWidgetTokenOwner)fTextViewer ) {
            IWidgetTokenOwnerExtension extension= cast(IWidgetTokenOwnerExtension) fTextViewer;
            if (extension.requestWidgetToken(this, WIDGET_PRIORITY))
                super.showInformationControl(subjectArea);
        } else if ( cast(IWidgetTokenOwner)fTextViewer ) {
            IWidgetTokenOwner owner= cast(IWidgetTokenOwner) fTextViewer;
            if (owner.requestWidgetToken(this))
                super.showInformationControl(subjectArea);

        } else
            super.showInformationControl(subjectArea);
    }

    /*
     * @see AbstractInformationControlManager#hideInformationControl()
     */
    protected void hideInformationControl() {
        try {
            super.hideInformationControl();
        } finally {
            if ( cast(IWidgetTokenOwner)fTextViewer ) {
                IWidgetTokenOwner owner= cast(IWidgetTokenOwner) fTextViewer;
                owner.releaseWidgetToken(this);
            }
        }
    }

    /*
     * @see AbstractInformationControlManager#handleInformationControlDisposed()
     */
    protected void handleInformationControlDisposed() {
        try {
            super.handleInformationControlDisposed();
        } finally {
            if ( cast(IWidgetTokenOwner)fTextViewer ) {
                IWidgetTokenOwner owner= cast(IWidgetTokenOwner) fTextViewer;
                owner.releaseWidgetToken(this);
            }
        }
    }

    /*
     * @see dwtx.jface.text.IWidgetTokenKeeper#requestWidgetToken(IWidgetTokenOwner)
     */
    public bool requestWidgetToken(IWidgetTokenOwner owner) {
        return false;
    }

    /*
     * @see dwtx.jface.text.IWidgetTokenKeeperExtension#requestWidgetToken(dwtx.jface.text.IWidgetTokenOwner, int)
     * @since 3.0
     */
    public bool requestWidgetToken(IWidgetTokenOwner owner, int priority) {
        return false;
    }

    /*
     * @see dwtx.jface.text.IWidgetTokenKeeperExtension#setFocus(dwtx.jface.text.IWidgetTokenOwner)
     * @since 3.0
     */
    public bool setFocus(IWidgetTokenOwner owner) {
        return false;
    }
}

