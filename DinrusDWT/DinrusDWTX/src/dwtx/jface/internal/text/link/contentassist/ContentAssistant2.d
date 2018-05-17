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
module dwtx.jface.internal.text.link.contentassist.ContentAssistant2;

import dwtx.jface.internal.text.link.contentassist.IProposalListener; // packageimport
import dwtx.jface.internal.text.link.contentassist.LineBreakingReader; // packageimport
import dwtx.jface.internal.text.link.contentassist.CompletionProposalPopup2; // packageimport
import dwtx.jface.internal.text.link.contentassist.ContextInformationPopup2; // packageimport
import dwtx.jface.internal.text.link.contentassist.ContentAssistMessages; // packageimport
import dwtx.jface.internal.text.link.contentassist.Helper2; // packageimport
import dwtx.jface.internal.text.link.contentassist.PopupCloser2; // packageimport
import dwtx.jface.internal.text.link.contentassist.IContentAssistListener2; // packageimport
import dwtx.jface.internal.text.link.contentassist.AdditionalInfoController2; // packageimport

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;
import dwtx.dwtxhelper.JThread;
import tango.core.sync.Mutex;
import tango.core.sync.Condition;

import dwt.DWT;
import dwt.DWTError;
import dwt.custom.StyledText;
import dwt.custom.VerifyKeyListener;
import dwt.events.ControlEvent;
import dwt.events.ControlListener;
import dwt.events.DisposeEvent;
import dwt.events.DisposeListener;
import dwt.events.FocusEvent;
import dwt.events.FocusListener;
import dwt.events.MouseEvent;
import dwt.events.MouseListener;
import dwt.events.VerifyEvent;
import dwt.graphics.Color;
import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwt.widgets.Control;
import dwt.widgets.Display;
import dwt.widgets.Event;
import dwt.widgets.Listener;
import dwt.widgets.Shell;
import dwt.widgets.Widget;
import dwtx.core.runtime.Assert;
import dwtx.jface.text.BadLocationException;
import dwtx.jface.text.DefaultInformationControl;
import dwtx.jface.text.IEventConsumer;
import dwtx.jface.text.IInformationControl;
import dwtx.jface.text.IInformationControlCreator;
import dwtx.jface.text.ITextViewer;
import dwtx.jface.text.ITextViewerExtension;
import dwtx.jface.text.IViewportListener;
import dwtx.jface.text.IWidgetTokenKeeper;
import dwtx.jface.text.IWidgetTokenKeeperExtension;
import dwtx.jface.text.IWidgetTokenOwner;
import dwtx.jface.text.IWidgetTokenOwnerExtension;
import dwtx.jface.text.TextUtilities;
import dwtx.jface.text.contentassist.CompletionProposal;
import dwtx.jface.text.contentassist.ICompletionProposal;
import dwtx.jface.text.contentassist.ICompletionProposalExtension6;
import dwtx.jface.text.contentassist.IContentAssistProcessor;
import dwtx.jface.text.contentassist.IContentAssistant;
import dwtx.jface.text.contentassist.IContentAssistantExtension;
import dwtx.jface.text.contentassist.IContextInformation;
import dwtx.jface.text.contentassist.IContextInformationPresenter;
import dwtx.jface.text.contentassist.IContextInformationValidator;


/**
 * A custom implementation of the <code>IContentAssistant</code> interface.
 * This implementation is used by the linked mode UI. This is internal and subject
 * to change without notice.
 */
public class ContentAssistant2 : IContentAssistant, IContentAssistantExtension, IWidgetTokenKeeper, IWidgetTokenKeeperExtension {

    /**
     * A generic closer class used to monitor various
     * interface events in order to determine whether
     * content-assist should be terminated and all
     * associated windows closed.
     */
    class Closer : ControlListener, MouseListener, FocusListener, DisposeListener, IViewportListener {

        /** The shell on which we add listeners. */
        private Shell fShell;
        private long fViewportListenerStartTime;

        /**
         * Installs this closer on it's viewer's text widget.
         */
        protected void install() {
            Control w= fViewer.getTextWidget();
            if (Helper2.okToUse(w)) {

                Shell shell= w.getShell();
                fShell= shell;
                shell.addControlListener(this);

                w.addMouseListener(this);
                w.addFocusListener(this);

                /*
                 * 1GGYYWK: ITPJUI:ALL - Dismissing editor with code assist up causes lots of Internal Errors
                 */
                w.addDisposeListener(this);
            }

            fViewer.addViewportListener(this);
            fViewportListenerStartTime= System.currentTimeMillis() + 500;
        }

        /**
         * Uninstalls this closer from the viewer's text widget.
         */
        protected void uninstall() {
            Shell shell= fShell;
            fShell= null;
            if (Helper2.okToUse(shell))
                shell.removeControlListener(this);

            Control w= fViewer.getTextWidget();
            if (Helper2.okToUse(w)) {

                w.removeMouseListener(this);
                w.removeFocusListener(this);

                /*
                 * 1GGYYWK: ITPJUI:ALL - Dismissing editor with code assist up causes lots of Internal Errors
                 */
                w.removeDisposeListener(this);
            }

            fViewer.removeViewportListener(this);
        }

        /*
         * @see ControlListener#controlResized(ControlEvent)
         */
        public void controlResized(ControlEvent e) {
            hide();
        }

        /*
         * @see ControlListener#controlMoved(ControlEvent)
         */
        public void controlMoved(ControlEvent e) {
            hide();
        }

        /*
         * @see MouseListener#mouseDown(MouseEvent)
         */
        public void mouseDown(MouseEvent e) {
            hide();
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
            hide();
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
            if (fViewer !is null) {
                Control control= fViewer.getTextWidget();
                if (control !is null) {
                    Display d= control.getDisplay();
                    if (d !is null) {
                        d.asyncExec(new class()  Runnable {
                            public void run() {
                                if (!hasFocus())
                                    hide();
                            }
                        });
                    }
                }
            }
        }

        /*
         * @seeDisposeListener#widgetDisposed(DisposeEvent)
         */
        public void widgetDisposed(DisposeEvent e) {
            /*
             * 1GGYYWK: ITPJUI:ALL - Dismissing editor with code assist up causes lots of Internal Errors
             */
            hide();
        }

        /*
         * @see IViewportListener#viewportChanged(int)
         */
        public void viewportChanged(int topIndex) {
            if (System.currentTimeMillis() > fViewportListenerStartTime)
                hide();
        }
    }

    /**
     * An implementation of <code>IContentAssistListener</code>, this class is
     * used to monitor key events in support of automatic activation
     * of the content assistant. If enabled, the implementation utilizes a
     * thread to watch for input characters matching the activation
     * characters specified by the content assist processor, and if
     * detected, will wait the indicated delay interval before
     * activating the content assistant.
     */
    class AutoAssistListener : VerifyKeyListener, Runnable {

        private JThread fThread;
        private bool fIsReset= false;
        private Mutex     fMutex;
        private Condition fMutex_cond;
        private int fShowStyle;

        private const static int SHOW_PROPOSALS= 1;
        private const static int SHOW_CONTEXT_INFO= 2;

        protected this() {
            fMutex = new Mutex();
            fMutex_cond = new Condition(fMutex);
        }

        protected void start(int showStyle) {
            fShowStyle= showStyle;
            fThread= new JThread(this);
            fThread.setName( ContentAssistMessages.getString("ContentAssistant.assist_delay_timer_name")); //$NON-NLS-1$
            fThread.start();
        }

        public override void run() {
            try {
                while (true) {
                    synchronized (fMutex) {
                        if (fAutoActivationDelay !is 0)
                            fMutex_cond.wait(fAutoActivationDelay);
                        if (fIsReset) {
                            fIsReset= false;
                            continue;
                        }
                    }
                    showAssist(fShowStyle);
                    break;
                }
            } catch (InterruptedException e) {
            }
            fThread= null;
        }

        protected void reset(int showStyle) {
            synchronized (fMutex) {
                fShowStyle= showStyle;
                fIsReset= true;
                fMutex_cond.notifyAll();
            }
        }

        protected void stop() {
            JThread threadToStop= fThread;
            if (threadToStop !is null)
                threadToStop.interrupt();
        }

        private bool contains(char[] characters, char character) {
            if (characters !is null) {
                for (int i= 0; i < characters.length; i++) {
                    if (character is characters[i])
                        return true;
                }
            }
            return false;
        }

        public void verifyKey(VerifyEvent e) {
            // Only act on typed characters and ignore modifier-only events
            if (e.character is 0 && (e.keyCode & DWT.KEYCODE_BIT) is 0)
                return;

            if (e.character !is 0 && (e.stateMask is DWT.ALT))
                return;

            int showStyle;
            int pos= fViewer.getSelectedRange().x;
            char[] activation= getCompletionProposalAutoActivationCharacters(fViewer, pos);

            if (contains(activation, e.character) && !fProposalPopup.isActive())
                showStyle= SHOW_PROPOSALS;
            else {
                activation= getContextInformationAutoActivationCharacters(fViewer, pos);
                if (contains(activation, e.character) && !fContextInfoPopup.isActive())
                    showStyle= SHOW_CONTEXT_INFO;
                else {
                    if (fThread !is null && fThread.isAlive())
                        stop();
                    return;
                }
            }

            if (fThread !is null && fThread.isAlive())
                reset(showStyle);
            else
                start(showStyle);
        }

        protected void showAssist(int showStyle) {
            Control control= fViewer.getTextWidget();
            Display d= control.getDisplay();
            if (d !is null) {
                try {
                    d.syncExec(new class()  Runnable {
                        public void run() {
                            if (showStyle is SHOW_PROPOSALS)
                                fProposalPopup.showProposals(true);
                            else if (showStyle is SHOW_CONTEXT_INFO)
                                fContextInfoPopup.showContextProposals(true);
                        }
                    });
                } catch (DWTError e) {
                }
            }
        }
    }

    /**
     * The layout manager layouts the various
     * windows associated with the content assistant based on the
     * settings of the content assistant.
     */
    class LayoutManager : Listener {

        // Presentation types.
        /** proposal selector */
        public const static int LAYOUT_PROPOSAL_SELECTOR= 0;
        /** context selector */
        public const static int LAYOUT_CONTEXT_SELECTOR= 1;
        /** context info */
        public const static int LAYOUT_CONTEXT_INFO_POPUP= 2;

        int fContextType= LAYOUT_CONTEXT_SELECTOR;
        Shell[] fShells;
        Object[] fPopups;

        this(){
            fShells= new Shell[3];
            fPopups= new Object[3];
        }

        protected void add(Object popup, Shell shell, int type, int offset) {
            Assert.isNotNull(popup);
            Assert.isTrue(shell !is null && !shell.isDisposed());
            checkType(type);

            if (fShells[type] !is shell) {
                if (fShells[type] !is null)
                    fShells[type].removeListener(DWT.Dispose, this);
                shell.addListener(DWT.Dispose, this);
                fShells[type]= shell;
            }

            fPopups[type]= popup;
            if (type is LAYOUT_CONTEXT_SELECTOR || type is LAYOUT_CONTEXT_INFO_POPUP)
                fContextType= type;

            layout(type, offset);
            adjustListeners(type);
        }

        protected void checkType(int type) {
            Assert.isTrue(type is LAYOUT_PROPOSAL_SELECTOR ||
                type is LAYOUT_CONTEXT_SELECTOR || type is LAYOUT_CONTEXT_INFO_POPUP);
        }

        public void handleEvent(Event event) {
            Widget source= event.widget;
            source.removeListener(DWT.Dispose, this);

            int type= getShellType(source);
            checkType(type);
            fShells[type]= null;

            switch (type) {
                case LAYOUT_PROPOSAL_SELECTOR:
                    if (fContextType is LAYOUT_CONTEXT_SELECTOR &&
                            Helper2.okToUse(fShells[LAYOUT_CONTEXT_SELECTOR])) {
                        // Restore event notification to the tip popup.
                        addContentAssistListener(cast(IContentAssistListener2) fPopups[LAYOUT_CONTEXT_SELECTOR], CONTEXT_SELECTOR);
                    }
                    break;

                case LAYOUT_CONTEXT_SELECTOR:
                    if (Helper2.okToUse(fShells[LAYOUT_PROPOSAL_SELECTOR])) {
                        if (fProposalPopupOrientation is PROPOSAL_STACKED)
                            layout(LAYOUT_PROPOSAL_SELECTOR, getSelectionOffset());
                        // Restore event notification to the proposal popup.
                        addContentAssistListener(cast(IContentAssistListener2) fPopups[LAYOUT_PROPOSAL_SELECTOR], PROPOSAL_SELECTOR);
                    }
                    fContextType= LAYOUT_CONTEXT_INFO_POPUP;
                    break;

                case LAYOUT_CONTEXT_INFO_POPUP:
                    if (Helper2.okToUse(fShells[LAYOUT_PROPOSAL_SELECTOR])) {
                        if (fContextInfoPopupOrientation is CONTEXT_INFO_BELOW)
                            layout(LAYOUT_PROPOSAL_SELECTOR, getSelectionOffset());
                    }
                    fContextType= LAYOUT_CONTEXT_SELECTOR;
                    break;
                default:
            }
        }

        protected int getShellType(Widget shell) {
            for (int i=0; i<fShells.length; i++) {
                if (fShells[i] is shell)
                    return i;
            }
            return -1;
        }

        protected void layout(int type, int offset) {
            switch (type) {
                case LAYOUT_PROPOSAL_SELECTOR:
                    layoutProposalSelector(offset);
                    break;
                case LAYOUT_CONTEXT_SELECTOR:
                    layoutContextSelector(offset);
                    break;
                case LAYOUT_CONTEXT_INFO_POPUP:
                    layoutContextInfoPopup(offset);
                    break;
                default:
            }
        }

        protected void layoutProposalSelector(int offset) {
            if (fContextType is LAYOUT_CONTEXT_INFO_POPUP &&
                    fContextInfoPopupOrientation is CONTEXT_INFO_BELOW &&
                    Helper2.okToUse(fShells[LAYOUT_CONTEXT_INFO_POPUP])) {
                // Stack proposal selector beneath the tip box.
                Shell shell= fShells[LAYOUT_PROPOSAL_SELECTOR];
                Shell parent= fShells[LAYOUT_CONTEXT_INFO_POPUP];
                shell.setLocation(getStackedLocation(shell, parent));
            } else if (fContextType !is LAYOUT_CONTEXT_SELECTOR ||
                        !Helper2.okToUse(fShells[LAYOUT_CONTEXT_SELECTOR])) {
                // There are no other presentations to be concerned with,
                // so place the proposal selector beneath the cursor line.
                Shell shell= fShells[LAYOUT_PROPOSAL_SELECTOR];
                shell.setLocation(getBelowLocation(shell, offset));
            } else {
                switch (fProposalPopupOrientation) {
                    case PROPOSAL_REMOVE: {
                        // Remove the tip selector and place the
                        // proposal selector beneath the cursor line.
                        fShells[LAYOUT_CONTEXT_SELECTOR].dispose();
                        Shell shell= fShells[LAYOUT_PROPOSAL_SELECTOR];
                        shell.setLocation(getBelowLocation(shell, offset));
                        break;
                    }
                    case PROPOSAL_OVERLAY: {
                        // Overlay the tip selector with the proposal selector.
                        Shell shell= fShells[LAYOUT_PROPOSAL_SELECTOR];
                        shell.setLocation(getBelowLocation(shell, offset));
                        break;
                    }
                    case PROPOSAL_STACKED: {
                        // Stack the proposal selector beneath the tip selector.
                        Shell shell= fShells[LAYOUT_PROPOSAL_SELECTOR];
                        Shell parent= fShells[LAYOUT_CONTEXT_SELECTOR];
                        shell.setLocation(getStackedLocation(shell, parent));
                        break;
                    }
                    default:
                }
            }
        }

        protected void layoutContextSelector(int offset) {
            // Always place the context selector beneath the cursor line.
            Shell shell= fShells[LAYOUT_CONTEXT_SELECTOR];
            shell.setLocation(getBelowLocation(shell, offset));

            if (Helper2.okToUse(fShells[LAYOUT_PROPOSAL_SELECTOR])) {
                switch (fProposalPopupOrientation) {
                    case PROPOSAL_REMOVE:
                        // Remove the proposal selector.
                        fShells[LAYOUT_PROPOSAL_SELECTOR].dispose();
                        break;

                    case PROPOSAL_OVERLAY:
                        // The proposal selector has been overlaid by the tip selector.
                        break;

                    case PROPOSAL_STACKED: {
                        // Stack the proposal selector beneath the tip selector.
                        shell= fShells[LAYOUT_PROPOSAL_SELECTOR];
                        Shell parent= fShells[LAYOUT_CONTEXT_SELECTOR];
                        shell.setLocation(getStackedLocation(shell, parent));
                        break;
                    }
                    default:
                }
            }
        }

        protected void layoutContextInfoPopup(int offset) {
            switch (fContextInfoPopupOrientation) {
                case CONTEXT_INFO_ABOVE: {
                    // Place the popup above the cursor line.
                    Shell shell= fShells[LAYOUT_CONTEXT_INFO_POPUP];
                    shell.setLocation(getAboveLocation(shell, offset));
                    break;
                }
                case CONTEXT_INFO_BELOW: {
                    // Place the popup beneath the cursor line.
                    Shell parent= fShells[LAYOUT_CONTEXT_INFO_POPUP];
                    parent.setLocation(getBelowLocation(parent, offset));
                    if (Helper2.okToUse(fShells[LAYOUT_PROPOSAL_SELECTOR])) {
                        // Stack the proposal selector beneath the context info popup.
                        Shell shell= fShells[LAYOUT_PROPOSAL_SELECTOR];
                        shell.setLocation(getStackedLocation(shell, parent));
                    }
                    break;
                }
                default:
            }
        }

        protected void shiftHorizontalLocation(Point location, Rectangle shellBounds, Rectangle displayBounds) {
            if (location.x + shellBounds.width > displayBounds.width)
                location.x= displayBounds.width - shellBounds.width;

            if (location.x < displayBounds.x)
                location.x= displayBounds.x;
        }

        protected void shiftVerticalLocation(Point location, Rectangle shellBounds, Rectangle displayBounds) {
            if (location.y + shellBounds.height > displayBounds.height)
                location.y= displayBounds.height - shellBounds.height;

            if (location.y < displayBounds.y)
                location.y= displayBounds.y;
        }

        protected Point getAboveLocation(Shell shell, int offset) {
            StyledText text= fViewer.getTextWidget();
            Point location= text.getLocationAtOffset(offset);
            location= text.toDisplay(location);

            Rectangle shellBounds= shell.getBounds();
            Rectangle displayBounds= shell.getDisplay().getClientArea();

            location.y=location.y - shellBounds.height;

            shiftHorizontalLocation(location, shellBounds, displayBounds);
            shiftVerticalLocation(location, shellBounds, displayBounds);

            return location;
        }

        protected Point getBelowLocation(Shell shell, int offset) {
            StyledText text= fViewer.getTextWidget();
            Point location= text.getLocationAtOffset(offset);
            if (location.x < 0) location.x= 0;
            if (location.y < 0) location.y= 0;
            location= text.toDisplay(location);

            Rectangle shellBounds= shell.getBounds();
            Rectangle displayBounds= shell.getDisplay().getClientArea();

            location.y= location.y + text.getLineHeight(offset);
            shiftHorizontalLocation(location, shellBounds, displayBounds);
            shiftVerticalLocation(location, shellBounds, displayBounds);

            return location;
        }

        protected Point getStackedLocation(Shell shell, Shell parent) {
            Point p= parent.getLocation();
            Point size= parent.getSize();
            p.x += size.x / 4;
            p.y += size.y;

            p= parent.toDisplay(p);

            Rectangle shellBounds= shell.getBounds();
            Rectangle displayBounds= shell.getDisplay().getClientArea();
            shiftHorizontalLocation(p, shellBounds, displayBounds);
            shiftVerticalLocation(p, shellBounds, displayBounds);

            return p;
        }

        protected void adjustListeners(int type) {
            switch (type) {
                case LAYOUT_PROPOSAL_SELECTOR:
                    if (fContextType is LAYOUT_CONTEXT_SELECTOR &&
                            Helper2.okToUse(fShells[LAYOUT_CONTEXT_SELECTOR]))
                        // Disable event notification to the tip selector.
                        removeContentAssistListener(cast(IContentAssistListener2) fPopups[LAYOUT_CONTEXT_SELECTOR], CONTEXT_SELECTOR);
                    break;
                case LAYOUT_CONTEXT_SELECTOR:
                    if (Helper2.okToUse(fShells[LAYOUT_PROPOSAL_SELECTOR]))
                        // Disable event notification to the proposal selector.
                        removeContentAssistListener(cast(IContentAssistListener2) fPopups[LAYOUT_PROPOSAL_SELECTOR], PROPOSAL_SELECTOR);
                    break;
                case LAYOUT_CONTEXT_INFO_POPUP:
                    break;
                default:
            }
        }
    }

    /**
     * Internal key listener and event consumer.
     */
    class InternalListener : VerifyKeyListener, IEventConsumer {

        /**
         * Verifies key events by notifying the registered listeners.
         * Each listener is allowed to indicate that the event has been
         * handled and should not be further processed.
         *
         * @param e the verify event
         * @see VerifyKeyListener#verifyKey(dwt.events.VerifyEvent)
         */
        public void verifyKey(VerifyEvent e) {
            IContentAssistListener2[] listeners= arraycast!(IContentAssistListener2)( fListeners.dup );
            for (int i= 0; i < listeners.length; i++) {
                if (listeners[i] !is null) {
                    if (!listeners[i].verifyKey(e) || !e.doit)
                        return;
                }
            }
        }

        /*
         * @see IEventConsumer#processEvent
         */
        public void processEvent(VerifyEvent event) {

            installKeyListener();

            IContentAssistListener2[] listeners= arraycast!(IContentAssistListener2)( fListeners.dup );
            for (int i= 0; i < listeners.length; i++) {
                if (listeners[i] !is null) {
                    listeners[i].processEvent(event);
                    if (!event.doit)
                        return;
                }
            }
        }
    }


    // Content-Assist Listener types
    const static int CONTEXT_SELECTOR= 0;
    const static int PROPOSAL_SELECTOR= 1;
    const static int CONTEXT_INFO_POPUP= 2;

    /**
     * The popup priority: &gt; info pop-ups, &lt; standard content assist.
     * Default value: <code>10</code>.
     *
     * @since 3.0
     */
    public static const int WIDGET_PRIORITY= 10;


    private static const int DEFAULT_AUTO_ACTIVATION_DELAY= 500;

    private IInformationControlCreator fInformationControlCreator;
    private int fAutoActivationDelay= DEFAULT_AUTO_ACTIVATION_DELAY;
    private bool fIsAutoActivated= false;
    private bool fIsAutoInserting= false;
    private int fProposalPopupOrientation= PROPOSAL_OVERLAY;
    private int fContextInfoPopupOrientation= CONTEXT_INFO_ABOVE;
    private Map fProcessors;
    private String fPartitioning;

    private Color fContextInfoPopupBackground;
    private Color fContextInfoPopupForeground;
    private Color fContextSelectorBackground;
    private Color fContextSelectorForeground;

    private ITextViewer fViewer;
    private String fLastErrorMessage;

    private Closer fCloser;
    private LayoutManager fLayoutManager;
    private AutoAssistListener fAutoAssistListener;
    private InternalListener fInternalListener;
    private CompletionProposalPopup2 fProposalPopup;
    private ContextInformationPopup2 fContextInfoPopup;

    private bool fKeyListenerHooked= false;
    private IContentAssistListener2[] fListeners;
    private int fCompletionPosition;
    private String[] fProposalStrings;
    private ICompletionProposal[] fProposals;
    private const List fProposalListeners;

    /**
     * Tells whether colored label support is enabled.
     * @since 3.4
     */
    private bool fIsColoredLabelsSupportEnabled= false;


    /**
     * Creates a new content assistant. The content assistant is not automatically activated,
     * overlays the completion proposals with context information list if necessary, and
     * shows the context information above the location at which it was activated. If auto
     * activation will be enabled, without further configuration steps, this content assistant
     * is activated after a 500 ms delay. It uses the default partitioning.
     */
    public this() {
        fListeners= new IContentAssistListener2[4];
        fProposalListeners= new ArrayList();

        setContextInformationPopupOrientation(CONTEXT_INFO_ABOVE);
        setInformationControlCreator(getInformationControlCreator());

//      JavaTextTools textTools= JavaPlugin.getDefault().getJavaTextTools();
//      IColorManager manager= textTools.getColorManager();
//
//      IPreferenceStore store=  JavaPlugin.getDefault().getPreferenceStore();
//
//      Color c= getColor(store, PreferenceConstants.CODEASSIST_PROPOSALS_FOREGROUND, manager);
//      setProposalSelectorForeground(c);
//
//      c= getColor(store, PreferenceConstants.CODEASSIST_PROPOSALS_BACKGROUND, manager);
//      setProposalSelectorBackground(c);
    }

    /**
     * Creates an <code>IInformationControlCreator</code> to be used to display context information.
     *
     * @return an <code>IInformationControlCreator</code> to be used to display context information
     */
    private IInformationControlCreator getInformationControlCreator() {
        return new class()  IInformationControlCreator {
            public IInformationControl createInformationControl(Shell parent) {
                return new DefaultInformationControl(parent, false);
            }
        };
    }

    /**
     * Sets the document partitioning this content assistant is using.
     *
     * @param partitioning the document partitioning for this content assistant
     */
    public void setDocumentPartitioning(String partitioning) {
        Assert.isNotNull(partitioning);
        fPartitioning= partitioning;
    }

    /*
     * @see dwtx.jface.text.contentassist.IContentAssistantExtension#getDocumentPartitioning()
     * @since 3.0
     */
    public String getDocumentPartitioning() {
        return fPartitioning;
    }

    /**
     * Registers a given content assist processor for a particular content type.
     * If there is already a processor registered for this type, the new processor
     * is registered instead of the old one.
     *
     * @param processor the content assist processor to register, or <code>null</code> to remove an existing one
     * @param contentType the content type under which to register
     */
     public void setContentAssistProcessor(IContentAssistProcessor processor, String contentType) {

        Assert.isNotNull(contentType);

        if (fProcessors is null)
            fProcessors= new HashMap();

        if (processor is null)
            fProcessors.remove(contentType);
        else
            fProcessors.put(contentType, cast(Object)processor);
    }

    /*
     * @see IContentAssistant#getContentAssistProcessor
     */
    public IContentAssistProcessor getContentAssistProcessor(String contentType) {
        if (fProcessors is null)
            return null;

        return cast(IContentAssistProcessor) fProcessors.get(contentType);
    }

    /**
     * Enables the content assistant's auto activation mode.
     *
     * @param enabled indicates whether auto activation is enabled or not
     */
    public void enableAutoActivation(bool enabled) {
        fIsAutoActivated= enabled;
        manageAutoActivation(fIsAutoActivated);
    }

    /**
     * Enables the content assistant's auto insertion mode. If enabled,
     * the content assistant inserts a proposal automatically if it is
     * the only proposal. In the case of ambiguities, the user must
     * make the choice.
     *
     * @param enabled indicates whether auto insertion is enabled or not
     * @since 2.0
     */
    public void enableAutoInsert(bool enabled) {
        fIsAutoInserting= enabled;
    }

    /**
     * Returns whether this content assistant is in the auto insertion
     * mode or not.
     *
     * @return <code>true</code> if in auto insertion mode
     * @since 2.0
     */
    bool isAutoInserting() {
        return fIsAutoInserting;
    }

    /**
     * Installs and uninstall the listeners needed for auto-activation.
     * @param start <code>true</code> if listeners must be installed,
     *  <code>false</code> if they must be removed
     * @since 2.0
     */
    private void manageAutoActivation(bool start) {
        if (start) {

            if (fViewer !is null && fAutoAssistListener is null) {
                fAutoAssistListener= new AutoAssistListener();
                if ( cast(ITextViewerExtension)fViewer ) {
                    ITextViewerExtension extension= cast(ITextViewerExtension) fViewer;
                    extension.appendVerifyKeyListener(fAutoAssistListener);
                } else {
                    StyledText textWidget= fViewer.getTextWidget();
                    if (Helper2.okToUse(textWidget))
                        textWidget.addVerifyKeyListener(fAutoAssistListener);
                }
            }

        } else if (fAutoAssistListener !is null) {

            if ( cast(ITextViewerExtension)fViewer ) {
                ITextViewerExtension extension= cast(ITextViewerExtension) fViewer;
                extension.removeVerifyKeyListener(fAutoAssistListener);
            } else {
                StyledText textWidget= fViewer.getTextWidget();
                if (Helper2.okToUse(textWidget))
                    textWidget.removeVerifyKeyListener(fAutoAssistListener);
            }

            fAutoAssistListener= null;
        }
    }

    /**
     * Sets the delay after which the content assistant is automatically invoked
     * if the cursor is behind an auto activation character.
     *
     * @param delay the auto activation delay
     */
    public void setAutoActivationDelay(int delay) {
        fAutoActivationDelay= delay;
    }

    /**
     * Sets the proposal pop-ups' orientation.
     * The following values may be used:
     * <ul>
     *   <li>PROPOSAL_OVERLAY<p>
     *     proposal popup windows should overlay each other
     *   </li>
     *   <li>PROPOSAL_REMOVE<p>
     *     any currently shown proposal popup should be closed
     *   </li>
     *   <li>PROPOSAL_STACKED<p>
     *     proposal popup windows should be vertical stacked, with no overlap,
     *     beneath the line containing the current cursor location
     *   </li>
     * </ul>
     *
     * @param orientation the popup's orientation
     */
    public void setProposalPopupOrientation(int orientation) {
        fProposalPopupOrientation= orientation;
    }

    /**
     * Sets the context information popup's orientation.
     * The following values may be used:
     * <ul>
     *   <li>CONTEXT_ABOVE<p>
     *     context information popup should always appear above the line containing
     *     the current cursor location
     *   </li>
     *   <li>CONTEXT_BELOW<p>
     *     context information popup should always appear below the line containing
     *     the current cursor location
     *   </li>
     * </ul>
     *
     * @param orientation the popup's orientation
     */
    public void setContextInformationPopupOrientation(int orientation) {
        fContextInfoPopupOrientation= orientation;
    }

    /**
     * Sets the context information popup's background color.
     *
     * @param background the background color
     */
    public void setContextInformationPopupBackground(Color background) {
        fContextInfoPopupBackground= background;
    }

    /**
     * Returns the background of the context information popup.
     *
     * @return the background of the context information popup
     * @since 2.0
     */
    Color getContextInformationPopupBackground() {
        return fContextInfoPopupBackground;
    }

    /**
     * Sets the context information popup's foreground color.
     *
     * @param foreground the foreground color
     * @since 2.0
     */
    public void setContextInformationPopupForeground(Color foreground) {
        fContextInfoPopupForeground= foreground;
    }

    /**
     * Returns the foreground of the context information popup.
     *
     * @return the foreground of the context information popup
     * @since 2.0
     */
    Color getContextInformationPopupForeground() {
        return fContextInfoPopupForeground;
    }

    /**
     * Sets the context selector's background color.
     *
     * @param background the background color
     * @since 2.0
     */
    public void setContextSelectorBackground(Color background) {
        fContextSelectorBackground= background;
    }

    /**
     * Returns the background of the context selector.
     *
     * @return the background of the context selector
     * @since 2.0
     */
    Color getContextSelectorBackground() {
        return fContextSelectorBackground;
    }

    /**
     * Sets the context selector's foreground color.
     *
     * @param foreground the foreground color
     * @since 2.0
     */
    public void setContextSelectorForeground(Color foreground) {
        fContextSelectorForeground= foreground;
    }

    /**
     * Returns the foreground of the context selector.
     *
     * @return the foreground of the context selector
     * @since 2.0
     */
    Color getContextSelectorForeground() {
        return fContextSelectorForeground;
    }

    /**
     * Sets the information control creator for the additional information control.
     *
     * @param creator the information control creator for the additional information control
     * @since 2.0
     */
    public void setInformationControlCreator(IInformationControlCreator creator) {
        fInformationControlCreator= creator;
    }

    /*
     * @see IContentAssist#install
     */
    public void install(ITextViewer textViewer) {
        Assert.isNotNull(cast(Object)textViewer);

        fViewer= textViewer;

        fLayoutManager= new LayoutManager();
        fInternalListener= new InternalListener();

        AdditionalInfoController2 controller= null;
        if (fInformationControlCreator !is null) {
            int delay= fAutoActivationDelay;
            if (delay is 0)
                delay= DEFAULT_AUTO_ACTIVATION_DELAY;
            delay= cast(int)Math.round(delay * 1.5f);
            controller= new AdditionalInfoController2(fInformationControlCreator, delay);
        }
        fContextInfoPopup= new ContextInformationPopup2(this, fViewer);
        fProposalPopup= new CompletionProposalPopup2(this, fViewer, controller);

        manageAutoActivation(fIsAutoActivated);
    }

    /*
     * @see IContentAssist#uninstall
     */
    public void uninstall() {

        if (fProposalPopup !is null)
            fProposalPopup.hide();

        if (fContextInfoPopup !is null)
            fContextInfoPopup.hide();

        manageAutoActivation(false);

        if (fCloser !is null) {
            fCloser.uninstall();
            fCloser= null;
        }

        fViewer= null;
    }

    /**
     * Adds the given shell of the specified type to the layout.
     * Valid types are defined by <code>LayoutManager</code>.
     *
     * @param popup a content assist popup
     * @param shell the shell of the content-assist popup
     * @param type the type of popup
     * @param visibleOffset the offset at which to layout the popup relative to the offset of the viewer's visible region
     * @since 2.0
     */
    void addToLayout(Object popup, Shell shell, int type, int visibleOffset) {
        fLayoutManager.add(popup, shell, type, visibleOffset);
    }

    /**
     * Layouts the registered popup of the given type relative to the
     * given offset. The offset is relative to the offset of the viewer's visible region.
     * Valid types are defined by <code>LayoutManager</code>.
     *
     * @param type the type of popup to layout
     * @param visibleOffset the offset at which to layout relative to the offset of the viewer's visible region
     * @since 2.0
     */
    void layout(int type, int visibleOffset) {
        fLayoutManager.layout(type, visibleOffset);
    }

    /**
     * Notifies the controller that a popup has lost focus.
     *
     * @param e the focus event
     */
    void popupFocusLost(FocusEvent e) {
        fCloser.focusLost(e);
    }

    /**
     * Returns the offset of the selection relative to the offset of the visible region.
     *
     * @return the offset of the selection relative to the offset of the visible region
     * @since 2.0
     */
    int getSelectionOffset() {
        StyledText text= fViewer.getTextWidget();
        return text.getSelectionRange().x;
    }

    /**
     * Returns whether the widget token could be acquired.
     * The following are valid listener types:
     * <ul>
     *   <li>AUTO_ASSIST
     *   <li>CONTEXT_SELECTOR
     *   <li>PROPOSAL_SELECTOR
     *   <li>CONTEXT_INFO_POPUP
     * <ul>
     * @param type the listener type for which to acquire
     * @return <code>true</code> if the widget token could be acquired
     * @since 2.0
     */
    private bool acquireWidgetToken(int type) {
        switch (type) {
            case CONTEXT_SELECTOR:
            case PROPOSAL_SELECTOR:
                if ( cast(IWidgetTokenOwner)fViewer ) {
                    IWidgetTokenOwner owner= cast(IWidgetTokenOwner) fViewer;
                    return owner.requestWidgetToken(this);
                } else if ( cast(IWidgetTokenOwnerExtension)fViewer )  {
                    IWidgetTokenOwnerExtension extension= cast(IWidgetTokenOwnerExtension) fViewer;
                    return extension.requestWidgetToken(this, WIDGET_PRIORITY);
                }
            default:
        }
        return true;
    }

    /**
     * Registers a content assist listener.
     * The following are valid listener types:
     * <ul>
     *   <li>AUTO_ASSIST
     *   <li>CONTEXT_SELECTOR
     *   <li>PROPOSAL_SELECTOR
     *   <li>CONTEXT_INFO_POPUP
     * <ul>
     * Returns whether the listener could be added successfully. A listener
     * can not be added if the widget token could not be acquired.
     *
     * @param listener the listener to register
     * @param type the type of listener
     * @return <code>true</code> if the listener could be added
     */
    bool addContentAssistListener(IContentAssistListener2 listener, int type) {

        if (acquireWidgetToken(type)) {

            fListeners[type]= listener;

            if (getNumberOfListeners() is 1) {
                fCloser= new Closer();
                fCloser.install();
                fViewer.setEventConsumer(fInternalListener);
                installKeyListener();
            }
            return true;
        }

        return false;
    }

    /**
     * Installs a key listener on the text viewer's widget.
     */
    private void installKeyListener() {
        if (!fKeyListenerHooked) {
            StyledText text= fViewer.getTextWidget();
            if (Helper2.okToUse(text)) {

                if ( cast(ITextViewerExtension)fViewer ) {
                    ITextViewerExtension e= cast(ITextViewerExtension) fViewer;
                    e.prependVerifyKeyListener(fInternalListener);
                } else {
                    text.addVerifyKeyListener(fInternalListener);
                }

                fKeyListenerHooked= true;
            }
        }
    }

    /**
     * Releases the previously acquired widget token if the token
     * is no longer necessary.
     * The following are valid listener types:
     * <ul>
     *   <li>AUTO_ASSIST
     *   <li>CONTEXT_SELECTOR
     *   <li>PROPOSAL_SELECTOR
     *   <li>CONTEXT_INFO_POPUP
     * <ul>
     *
     * @param type the listener type
     * @since 2.0
     */
    private void releaseWidgetToken(int type) {
        if (fListeners[CONTEXT_SELECTOR] is null && fListeners[PROPOSAL_SELECTOR] is null) {
            if ( cast(IWidgetTokenOwner)fViewer ) {
                IWidgetTokenOwner owner= cast(IWidgetTokenOwner) fViewer;
                owner.releaseWidgetToken(this);
            }
        }
    }

    /**
     * Unregisters a content assist listener.
     *
     * @param listener the listener to unregister
     * @param type the type of listener
     *
     * @see #addContentAssistListener
     */
    void removeContentAssistListener(IContentAssistListener2 listener, int type) {
        fListeners[type]= null;

        if (getNumberOfListeners() is 0) {

            if (fCloser !is null) {
                fCloser.uninstall();
                fCloser= null;
            }

            uninstallKeyListener();
            fViewer.setEventConsumer(null);
        }

        releaseWidgetToken(type);
    }

    /**
     * Uninstall the key listener from the text viewer's widget.
     */
    private void uninstallKeyListener() {
        if (fKeyListenerHooked) {
            StyledText text= fViewer.getTextWidget();
            if (Helper2.okToUse(text)) {

                if ( cast(ITextViewerExtension)fViewer ) {
                    ITextViewerExtension e= cast(ITextViewerExtension) fViewer;
                    e.removeVerifyKeyListener(fInternalListener);
                } else {
                    text.removeVerifyKeyListener(fInternalListener);
                }

                fKeyListenerHooked= false;
            }
        }
    }

    /**
     * Returns the number of listeners.
     *
     * @return the number of listeners
     * @since 2.0
     */
    private int getNumberOfListeners() {
        int count= 0;
        for (int i= 0; i <= CONTEXT_INFO_POPUP; i++) {
            if (fListeners[i] !is null)
                ++ count;
        }
        return count;
    }

    /*
     * @see IContentAssist#showPossibleCompletions
     */
    public String showPossibleCompletions() {
        return fProposalPopup.showProposals(false);
    }

    /**
     * Hides the proposal popup.
     */
    public void hidePossibleCompletions() {
        if (fProposalPopup !is null)
            fProposalPopup.hide();
    }

    /**
     * Hides any open pop-ups.
     */
    protected void hide() {
        if (fProposalPopup !is null)
            fProposalPopup.hide();
        if (fContextInfoPopup !is null)
            fContextInfoPopup.hide();
    }
    package void hide_package() {
        hide();
    }

    /**
     * Callback to signal this content assistant that the presentation of the possible completions has been stopped.
     * @since 2.1
     */
    protected void possibleCompletionsClosed() {
    }
    package void possibleCompletionsClosed_package(){
        possibleCompletionsClosed();
    }
    /*
     * @see IContentAssist#showContextInformation
     */
    public String showContextInformation() {
        return fContextInfoPopup.showContextProposals(false);
    }


    /**
     * Callback to signal this content assistant that the presentation of the context information has been stopped.
     * @since 2.1
     */
    protected void contextInformationClosed() {
    }
    package void contextInformationClosed_package() {
        contextInformationClosed();
    }

    /**
     * Requests that the specified context information to be shown.
     *
     * @param contextInformation the context information to be shown
     * @param position the position to which the context information refers to
     * @since 2.0
     */
    void showContextInformation(IContextInformation contextInformation, int position) {
        fContextInfoPopup.showContextInformation(contextInformation, position);
    }

    /**
     * Returns the current content assist error message.
     *
     * @return an error message or <code>null</code> if no error has occurred
     */
    String getErrorMessage() {
        return fLastErrorMessage;
    }

    /**
     * Returns the content assist processor for the content
     * type of the specified document position.
     *
     * @param viewer the text viewer
     * @param offset a offset within the document
     * @return a content-assist processor or <code>null</code> if none exists
     */
    private IContentAssistProcessor getProcessor(ITextViewer viewer, int offset) {
        try {
            String type= TextUtilities.getContentType(viewer.getDocument(), getDocumentPartitioning(), offset, true);
            return getContentAssistProcessor(type);
        } catch (BadLocationException x) {
        }
        return null;
    }

    /**
     * Returns an array of completion proposals computed based on
     * the specified document position. The position is used to
     * determine the appropriate content assist processor to invoke.
     *
     * @param viewer the viewer for which to compute the proposals
     * @param position a document position
     * @return an array of completion proposals
     *
     * @see IContentAssistProcessor#computeCompletionProposals
     */
    ICompletionProposal[] computeCompletionProposals(ITextViewer viewer, int position) {
        if (fProposals !is null) {
            return fProposals;
        } else if (fProposalStrings !is null) {
            ICompletionProposal[] result= new ICompletionProposal[fProposalStrings.length];
            for (int i= 0; i < fProposalStrings.length; i++) {
                result[i]= new CompletionProposal(fProposalStrings[i], position, fProposalStrings[i].length(), fProposalStrings[i].length());
            }
            return result;
        } else return null;
    }

    /**
     * Returns an array of context information objects computed based
     * on the specified document position. The position is used to determine
     * the appropriate content assist processor to invoke.
     *
     * @param viewer the viewer for which to compute the context information
     * @param position a document position
     * @return an array of context information objects
     *
     * @see IContentAssistProcessor#computeContextInformation
     */
    IContextInformation[] computeContextInformation(ITextViewer viewer, int position) {
        fLastErrorMessage= null;

        IContextInformation[] result= null;

        IContentAssistProcessor p= getProcessor(viewer, position);
        if (p !is null) {
            result= p.computeContextInformation(viewer, position);
            fLastErrorMessage= p.getErrorMessage();
        }

        return result;
    }

    /**
     * Returns the context information validator that should be used to
     * determine when the currently displayed context information should
     * be dismissed. The position is used to determine the appropriate
     * content assist processor to invoke.
     *
     * @param textViewer the text viewer
     * @param offset a document offset
     * @return an validator
     *
     * @see IContentAssistProcessor#getContextInformationValidator
     */
    IContextInformationValidator getContextInformationValidator(ITextViewer textViewer, int offset) {
        IContentAssistProcessor p= getProcessor(textViewer, offset);
        return p !is null ? p.getContextInformationValidator() : null;
    }

    /**
     * Returns the context information presenter that should be used to
     * display context information. The position is used to determine the appropriate
     * content assist processor to invoke.
     *
     * @param textViewer the text viewer
     * @param offset a document offset
     * @return a presenter
     * @since 2.0
     */
    IContextInformationPresenter getContextInformationPresenter(ITextViewer textViewer, int offset) {
        IContextInformationValidator validator= getContextInformationValidator(textViewer, offset);
        if ( cast(IContextInformationPresenter)validator )
            return cast(IContextInformationPresenter) validator;
        return null;
    }

    /**
     * Returns the characters which when typed by the user should automatically
     * initiate proposing completions. The position is used to determine the
     * appropriate content assist processor to invoke.
     *
     * @param textViewer the text viewer
     * @param offset a document offset
     * @return the auto activation characters
     *
     * @see IContentAssistProcessor#getCompletionProposalAutoActivationCharacters
     */
    private char[] getCompletionProposalAutoActivationCharacters(ITextViewer textViewer, int offset) {
        IContentAssistProcessor p= getProcessor(textViewer, offset);
        return p !is null ? p.getCompletionProposalAutoActivationCharacters() : null;
    }

    /**
     * Returns the characters which when typed by the user should automatically
     * initiate the presentation of context information. The position is used
     * to determine the appropriate content assist processor to invoke.
     *
     * @param textViewer the text viewer
     * @param offset a document offset
     * @return the auto activation characters
     *
     * @see IContentAssistProcessor#getContextInformationAutoActivationCharacters
     */
    private char[] getContextInformationAutoActivationCharacters(ITextViewer textViewer, int offset) {
        IContentAssistProcessor p= getProcessor(textViewer, offset);
        return p !is null ? p.getContextInformationAutoActivationCharacters() : null;
    }

    /*
     * @see dwtx.jface.text.IWidgetTokenKeeper#requestWidgetToken(IWidgetTokenOwner)
     * @since 2.0
     */
    public bool requestWidgetToken(IWidgetTokenOwner owner) {
        hidePossibleCompletions();
        return true;
    }

    /**
     * @param completionPosition
     */
    public void setCompletionPosition(int completionPosition) {
        fCompletionPosition= completionPosition;
    }

    /**
     * @return the completion position
     */
    public int getCompletionPosition() {
        return fCompletionPosition;
    }

    /**
     * @param proposals
     */
    public void setCompletions(String[] proposals) {
        fProposalStrings= proposals;
    }

    /**
     * @param proposals
     */
    public void setCompletions(ICompletionProposal[] proposals) {
        fProposals= proposals;
    }

    /*
     * @see dwtx.jface.text.IWidgetTokenKeeperExtension#requestWidgetToken(dwtx.jface.text.IWidgetTokenOwner, int)
     * @since 3.0
     */
    public bool requestWidgetToken(IWidgetTokenOwner owner, int priority) {
        if (priority > WIDGET_PRIORITY) {
            hidePossibleCompletions();
            return true;
        }
        return false;
    }

    /*
     * @see dwtx.jface.text.IWidgetTokenKeeperExtension#setFocus(dwtx.jface.text.IWidgetTokenOwner)
     * @since 3.0
     */
    public bool setFocus(IWidgetTokenOwner owner) {
        if (fProposalPopup !is null) {
            fProposalPopup.setFocus();
            return fProposalPopup.hasFocus();
        }
        return false;
    }

    /**
     * Returns whether any popups controlled by the receiver have the input focus.
     *
     * @return <code>true</code> if any of the managed popups have the focus, <code>false</code> otherwise
     */
    public bool hasFocus() {
        return (fProposalPopup !is null && fProposalPopup.hasFocus())
                || (fContextInfoPopup !is null && fContextInfoPopup.hasFocus());
    }

    /*
     * @see dwtx.jface.text.contentassist.IContentAssistantExtension#completePrefix()
     */
    public String completePrefix() {
        return null;
    }

    /**
     * @param proposal
     */
    public void fireProposalChosen(ICompletionProposal proposal) {
        List list= new ArrayList(fProposalListeners);
        for (Iterator it= list.iterator(); it.hasNext();) {
            IProposalListener listener= cast(IProposalListener) it.next();
            listener.proposalChosen(proposal);
        }

    }

    /**
     * @param listener
     */
    public void removeProposalListener(IProposalListener listener) {
        fProposalListeners.remove(cast(Object)listener);
    }

    /**
     * @param listener
     */
    public void addProposalListener(IProposalListener listener) {
        fProposalListeners.add(cast(Object)listener);
    }

    /**
     * Tells whether the support for colored labels is enabled.
     *
     * @return <code>true</code> if the support for colored labels is enabled, <code>false</code> otherwise
     * @since 3.4
     */
    bool isColoredLabelsSupportEnabled() {
        return fIsColoredLabelsSupportEnabled;
    }

    /**
     * Enables the support for colored labels in the proposal popup.
     * <p>Completion proposals can implement {@link ICompletionProposalExtension6}
     * to provide colored proposal labels.</p>
     *
     * @param isEnabled if <code>true</code> the support for colored labels is enabled in the proposal popup
     * @since 3.4
     */
    public void enableColoredLabels(bool isEnabled) {
        fIsColoredLabelsSupportEnabled= isEnabled;
    }
}

