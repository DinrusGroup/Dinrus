/*******************************************************************************
 * Copyright (c) 2000, 2008 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *     Sean Montgomery, sean_montgomery@comcast.net - https://bugs.eclipse.org/bugs/show_bug.cgi?id=116454
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/
module dwtx.jface.text.contentassist.CompletionProposalPopup;

import dwtx.jface.text.contentassist.ContentAssistEvent; // packageimport
import dwtx.jface.text.contentassist.Helper; // packageimport
import dwtx.jface.text.contentassist.PopupCloser; // packageimport
import dwtx.jface.text.contentassist.IContentAssistant; // packageimport
import dwtx.jface.text.contentassist.CompletionProposal; // packageimport
import dwtx.jface.text.contentassist.ICompletionProposalExtension5; // packageimport
import dwtx.jface.text.contentassist.IContextInformationValidator; // packageimport
import dwtx.jface.text.contentassist.IContentAssistListener; // packageimport
import dwtx.jface.text.contentassist.ICompletionProposalExtension6; // packageimport
import dwtx.jface.text.contentassist.ICompletionListener; // packageimport
import dwtx.jface.text.contentassist.ICompletionProposalExtension2; // packageimport
import dwtx.jface.text.contentassist.IContentAssistantExtension4; // packageimport
import dwtx.jface.text.contentassist.ContextInformation; // packageimport
import dwtx.jface.text.contentassist.ICompletionProposalExtension3; // packageimport
import dwtx.jface.text.contentassist.ContextInformationValidator; // packageimport
import dwtx.jface.text.contentassist.ICompletionProposal; // packageimport
import dwtx.jface.text.contentassist.IContentAssistProcessor; // packageimport
import dwtx.jface.text.contentassist.AdditionalInfoController; // packageimport
import dwtx.jface.text.contentassist.IContextInformationPresenter; // packageimport
import dwtx.jface.text.contentassist.ICompletionProposalExtension4; // packageimport
import dwtx.jface.text.contentassist.ICompletionListenerExtension; // packageimport
import dwtx.jface.text.contentassist.ContextInformationPopup; // packageimport
import dwtx.jface.text.contentassist.IContextInformationExtension; // packageimport
import dwtx.jface.text.contentassist.IContentAssistantExtension2; // packageimport
import dwtx.jface.text.contentassist.ContentAssistSubjectControlAdapter; // packageimport
import dwtx.jface.text.contentassist.ICompletionProposalExtension; // packageimport
import dwtx.jface.text.contentassist.IContextInformation; // packageimport
import dwtx.jface.text.contentassist.IContentAssistantExtension3; // packageimport
import dwtx.jface.text.contentassist.ContentAssistant; // packageimport
import dwtx.jface.text.contentassist.IContentAssistantExtension; // packageimport
import dwtx.jface.text.contentassist.JFaceTextMessages; // packageimport


import dwt.dwthelper.utils;

import dwtx.dwtxhelper.Collection;


import dwt.DWT;
import dwt.custom.BusyIndicator;
import dwt.custom.StyleRange;
import dwt.events.ControlEvent;
import dwt.events.ControlListener;
import dwt.events.DisposeEvent;
import dwt.events.DisposeListener;
import dwt.events.FocusEvent;
import dwt.events.FocusListener;
import dwt.events.KeyAdapter;
import dwt.events.KeyEvent;
import dwt.events.KeyListener;
import dwt.events.MouseAdapter;
import dwt.events.MouseEvent;
import dwt.events.SelectionEvent;
import dwt.events.SelectionListener;
import dwt.events.TraverseEvent;
import dwt.events.TraverseListener;
import dwt.events.VerifyEvent;
import dwt.graphics.Color;
import dwt.graphics.Font;
import dwt.graphics.FontData;
import dwt.graphics.Image;
import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.widgets.Control;
import dwt.widgets.Display;
import dwt.widgets.Event;
import dwt.widgets.Label;
import dwt.widgets.Listener;
import dwt.widgets.Shell;
import dwt.widgets.Table;
import dwt.widgets.TableItem;
import dwtx.core.commands.AbstractHandler;
import dwtx.core.commands.ExecutionEvent;
import dwtx.core.commands.ExecutionException;
import dwtx.core.commands.IHandler;
import dwtx.core.runtime.Assert;
import dwtx.jface.bindings.keys.KeySequence;
import dwtx.jface.bindings.keys.SWTKeySupport;
import dwtx.jface.contentassist.IContentAssistSubjectControl;
import dwtx.jface.internal.text.InformationControlReplacer;
import dwtx.jface.internal.text.TableOwnerDrawSupport;
import dwtx.jface.preference.JFacePreferences;
import dwtx.jface.resource.JFaceResources;
import dwtx.jface.text.AbstractInformationControlManager;
import dwtx.jface.text.BadLocationException;
import dwtx.jface.text.DocumentEvent;
import dwtx.jface.text.IDocument;
import dwtx.jface.text.IDocumentListener;
import dwtx.jface.text.IEditingSupport;
import dwtx.jface.text.IEditingSupportRegistry;
import dwtx.jface.text.IInformationControl;
import dwtx.jface.text.IRegion;
import dwtx.jface.text.IRewriteTarget;
import dwtx.jface.text.ITextViewer;
import dwtx.jface.text.ITextViewerExtension;
import dwtx.jface.text.TextUtilities;
import dwtx.jface.text.AbstractInformationControlManager;
import dwtx.jface.util.Geometry;
import dwtx.jface.viewers.StyledString;


/**
 * This class is used to present proposals to the user. If additional
 * information exists for a proposal, then selecting that proposal
 * will result in the information being displayed in a secondary
 * window.
 *
 * @see dwtx.jface.text.contentassist.ICompletionProposal
 * @see dwtx.jface.text.contentassist.AdditionalInfoController
 */
class CompletionProposalPopup : IContentAssistListener {
    /**
     * Set to <code>true</code> to use a Table with DWT.VIRTUAL.
     * XXX: This is a workaround for: https://bugs.eclipse.org/bugs/show_bug.cgi?id=90321
     *      More details see also: https://bugs.eclipse.org/bugs/show_bug.cgi?id=98585#c36
     * @since 3.1
     */
    private static bool USE_VIRTUAL_;
    private static bool USE_VIRTUAL_init = false;;
    private static bool USE_VIRTUAL(){
        if( !USE_VIRTUAL_init ){
            USE_VIRTUAL_init = true;
            USE_VIRTUAL_ = !"motif".equals(DWT.getPlatform()); //$NON-NLS-1$
        }
        return USE_VIRTUAL_;
    }

    /**
     * Completion proposal selection handler.
     *
     * @since 3.4
     */
    final class ProposalSelectionHandler : AbstractHandler {

        /**
         * Selection operation codes.
         */
        static const int SELECT_NEXT= 1;
        static const int SELECT_PREVIOUS= 2;


        private int fOperationCode;

        /**
         * Creates a new selection handler.
         *
         * @param operationCode the operation code
         * @since 3.4
         */
        public this(int operationCode) {
            Assert.isLegal(operationCode is SELECT_NEXT || operationCode is SELECT_PREVIOUS);
            fOperationCode= operationCode;
        }

        /*
         * @see dwtx.core.commands.AbstractHandler#execute(dwtx.core.commands.ExecutionEvent)
         * @since 3.4
         */
        public Object execute(ExecutionEvent event)  {
            int itemCount= fProposalTable.getItemCount();
            int selectionIndex= fProposalTable.getSelectionIndex();
            switch (fOperationCode) {
            case SELECT_NEXT:
                selectionIndex+= 1;
                if (selectionIndex > itemCount - 1)
                    selectionIndex= 0;
                break;
            case SELECT_PREVIOUS:
                selectionIndex-= 1;
                if (selectionIndex < 0)
                    selectionIndex= itemCount - 1;
                break;
            default:
            }
            selectProposal(selectionIndex, false);
            return null;
        }

    }


    /**
     * The empty proposal displayed if there is nothing else to show.
     *
     * @since 3.2
     */
    private static final class EmptyProposal : ICompletionProposal, ICompletionProposalExtension {

        String fDisplayString;
        int fOffset;
        /*
         * @see ICompletionProposal#apply(IDocument)
         */
        public void apply(IDocument document) {
        }

        /*
         * @see ICompletionProposal#getSelection(IDocument)
         */
        public Point getSelection(IDocument document) {
            return new Point(fOffset, 0);
        }

        /*
         * @see ICompletionProposal#getContextInformation()
         */
        public IContextInformation getContextInformation() {
            return null;
        }

        /*
         * @see ICompletionProposal#getImage()
         */
        public Image getImage() {
            return null;
        }

        /*
         * @see ICompletionProposal#getDisplayString()
         */
        public String getDisplayString() {
            return fDisplayString;
        }

        /*
         * @see ICompletionProposal#getAdditionalProposalInfo()
         */
        public String getAdditionalProposalInfo() {
            return null;
        }

        /*
         * @see dwtx.jface.text.contentassist.ICompletionProposalExtension#apply(dwtx.jface.text.IDocument, char, int)
         */
        public void apply(IDocument document, char trigger, int offset) {
        }

        /*
         * @see dwtx.jface.text.contentassist.ICompletionProposalExtension#isValidFor(dwtx.jface.text.IDocument, int)
         */
        public bool isValidFor(IDocument document, int offset) {
            return false;
        }

        /*
         * @see dwtx.jface.text.contentassist.ICompletionProposalExtension#getTriggerCharacters()
         */
        public char[] getTriggerCharacters() {
            return null;
        }

        /*
         * @see dwtx.jface.text.contentassist.ICompletionProposalExtension#getContextInformationPosition()
         */
        public int getContextInformationPosition() {
            return -1;
        }
    }

    private final class ProposalSelectionListener : KeyListener {
        public void keyPressed(KeyEvent e) {
            if (!Helper.okToUse(fProposalShell))
                return;

            if (e.character is 0 && e.keyCode is DWT.CTRL) {
                // http://dev.eclipse.org/bugs/show_bug.cgi?id=34754
                int index= fProposalTable.getSelectionIndex();
                if (index >= 0)
                    selectProposal(index, true);
            }
        }

        public void keyReleased(KeyEvent e) {
            if (!Helper.okToUse(fProposalShell))
                return;

            if (e.character is 0 && e.keyCode is DWT.CTRL) {
                // http://dev.eclipse.org/bugs/show_bug.cgi?id=34754
                int index= fProposalTable.getSelectionIndex();
                if (index >= 0)
                    selectProposal(index, false);
            }
        }
    }

    private final class CommandKeyListener : KeyAdapter {
        private KeySequence fCommandSequence;

        private this(KeySequence keySequence) {
            fCommandSequence= keySequence;
        }

        public void keyPressed(KeyEvent e) {
            if (!Helper.okToUse(fProposalShell))
                return;

            int accelerator= SWTKeySupport.convertEventToUnmodifiedAccelerator(e);
            KeySequence sequence= KeySequence.getInstance(SWTKeySupport.convertAcceleratorToKeyStroke(accelerator));
            if (sequence==/++/fCommandSequence)
                if (fContentAssistant.isPrefixCompletionEnabled())
                    incrementalComplete();
                else
                    showProposals(false);

        }
    }


    /** The associated text viewer. */
    private ITextViewer fViewer;
    /** The associated content assistant. */
    private ContentAssistant fContentAssistant;
    /** The used additional info controller. */
    private AdditionalInfoController fAdditionalInfoController;
    /** The closing strategy for this completion proposal popup. */
    private PopupCloser fPopupCloser;
    /** The popup shell. */
    private Shell fProposalShell;
    /** The proposal table. */
    private Table fProposalTable;
    /** Indicates whether a completion proposal is being inserted. */
    private bool fInserting= false;
    /** The key listener to control navigation. */
    private ProposalSelectionListener fKeyListener;
    /** List of document events used for filtering proposals. */
    private List fDocumentEvents;
    /** Listener filling the document event queue. */
    private IDocumentListener fDocumentListener;
    /** The filter list of proposals. */
    private ICompletionProposal[] fFilteredProposals;
    /** The computed list of proposals. */
    private ICompletionProposal[] fComputedProposals;
    /** The offset for which the proposals have been computed. */
    private int fInvocationOffset;
    /** The offset for which the computed proposals have been filtered. */
    private int fFilterOffset;
    /**
     * The most recently selected proposal.
     * @since 3.0
     */
    private ICompletionProposal fLastProposal;
    /**
     * The content assist subject control.
     * This replaces <code>fViewer</code>
     *
     * @since 3.0
     */
    private IContentAssistSubjectControl fContentAssistSubjectControl;
    /**
     * The content assist subject control adapter.
     * This replaces <code>fViewer</code>
     *
     * @since 3.0
     */
    private ContentAssistSubjectControlAdapter fContentAssistSubjectControlAdapter;
    /**
     * Remembers the size for this completion proposal popup.
     * @since 3.0
     */
    private Point fSize;
    /**
     * Editor helper that communicates that the completion proposal popup may
     * have focus while the 'logical focus' is still with the editor.
     * @since 3.1
     */
    private IEditingSupport fFocusHelper;
    /**
     * Set to true by {@link #computeFilteredProposals(int, DocumentEvent)} if
     * the returned proposals are a subset of {@link #fFilteredProposals},
     * <code>false</code> if not.
     * @since 3.1
     */
    private bool fIsFilteredSubset;
    /**
     * The filter runnable.
     *
     * @since 3.1.1
     */
    private Runnable fFilterRunnable;
    private void fFilterRunnableInit(){
        fFilterRunnable = dgRunnable( {
            if (!fIsFilterPending)
                return;

            fIsFilterPending= false;

            if (!Helper.okToUse(fContentAssistSubjectControlAdapter.getControl()))
                return;

            int offset= fContentAssistSubjectControlAdapter.getSelectedRange().x;
            ICompletionProposal[] proposals= null;
            try  {
                if (offset > -1) {
                    DocumentEvent event= TextUtilities.mergeProcessedDocumentEvents(fDocumentEvents);
                    proposals= computeFilteredProposals(offset, event);
                }
            } catch (BadLocationException x)  {
            } finally  {
                fDocumentEvents.clear();
            }
            fFilterOffset= offset;

            if (proposals !is null && proposals.length > 0)
                setProposals(proposals, fIsFilteredSubset);
            else
                hide();
        });
    }

    /**
     * <code>true</code> if <code>fFilterRunnable</code> has been
     * posted, <code>false</code> if not.
     *
     * @since 3.1.1
     */
    private bool fIsFilterPending= false;
    /**
     * The info message at the bottom of the popup, or <code>null</code> for no popup (if
     * ContentAssistant does not provide one).
     *
     * @since 3.2
     */
    private Label fMessageText;
    /**
     * The font used for <code>fMessageText</code> or null; dispose when done.
     *
     * @since 3.2
     */
    private Font fMessageTextFont;
    /**
     * The most recent completion offset (used to determine repeated invocation)
     *
     * @since 3.2
     */
    private int fLastCompletionOffset;
    /**
     * The (reusable) empty proposal.
     *
     * @since 3.2
     */
    private EmptyProposal fEmptyProposal;
    /**
     * The text for the empty proposal, or <code>null</code> to use the default text.
     *
     * @since 3.2
     */
    private String fEmptyMessage= null;
    /**
     * Tells whether colored labels support is enabled.
     * Only valid while the popup is active.
     *
     * @since 3.4
     */
    private bool fIsColoredLabelsSupportEnabled= false;


    /**
     * Creates a new completion proposal popup for the given elements.
     *
     * @param contentAssistant the content assistant feeding this popup
     * @param viewer the viewer on top of which this popup appears
     * @param infoController the information control collaborating with this popup
     * @since 2.0
     */
    public this(ContentAssistant contentAssistant, ITextViewer viewer, AdditionalInfoController infoController) {
        // DWT instance init
        fDocumentEvents= new ArrayList();
        fPopupCloser= new PopupCloser();
        if( fEmptyProposal is null ) fEmptyProposal= new EmptyProposal();
        fFilterRunnableInit();

        fContentAssistant= contentAssistant;
        fViewer= viewer;
        fAdditionalInfoController= infoController;
        fContentAssistSubjectControlAdapter= new ContentAssistSubjectControlAdapter(fViewer);
    }

    /**
     * Creates a new completion proposal popup for the given elements.
     *
     * @param contentAssistant the content assistant feeding this popup
     * @param contentAssistSubjectControl the content assist subject control on top of which this popup appears
     * @param infoController the information control collaborating with this popup
     * @since 3.0
     */
    public this(ContentAssistant contentAssistant, IContentAssistSubjectControl contentAssistSubjectControl, AdditionalInfoController infoController) {
        // DWT instance init
        fDocumentEvents= new ArrayList();
        fPopupCloser= new PopupCloser();
        if( fEmptyProposal is null ) fEmptyProposal= new EmptyProposal();
        fFilterRunnableInit();

        fContentAssistant= contentAssistant;
        fContentAssistSubjectControl= contentAssistSubjectControl;
        fAdditionalInfoController= infoController;
        fContentAssistSubjectControlAdapter= new ContentAssistSubjectControlAdapter(fContentAssistSubjectControl);
    }

    /**
     * Computes and presents completion proposals. The flag indicates whether this call has
     * be made out of an auto activation context.
     *
     * @param autoActivated <code>true</code> if auto activation context
     * @return an error message or <code>null</code> in case of no error
     */
    public String showProposals(bool autoActivated) {

        if (fKeyListener is null)
            fKeyListener= new ProposalSelectionListener();

        final Control control= fContentAssistSubjectControlAdapter.getControl();

        if (!Helper.okToUse(fProposalShell) && control !is null && !control.isDisposed()) {
            // add the listener before computing the proposals so we don't move the caret
            // when the user types fast.
            fContentAssistSubjectControlAdapter.addKeyListener(fKeyListener);

            BusyIndicator.showWhile(control.getDisplay(), dgRunnable((bool autoActivated_) {

                fInvocationOffset= fContentAssistSubjectControlAdapter.getSelectedRange().x;
                fFilterOffset= fInvocationOffset;
                fLastCompletionOffset= fFilterOffset;
                fComputedProposals= computeProposals(fInvocationOffset);

                int count= (fComputedProposals is null ? 0 : fComputedProposals.length);
                if (count is 0 && hideWhenNoProposals(autoActivated_))
                    return;

                if (count is 1 && !autoActivated_ && canAutoInsert(fComputedProposals[0])) {
                    insertProposal(fComputedProposals[0], cast(wchar) 0, 0, fInvocationOffset);
                    hide();
                } else {
                    createProposalSelector();
                    setProposals(fComputedProposals, false);
                    displayProposals();
                }
            }, autoActivated ));
        } else {
            fLastCompletionOffset= fFilterOffset;
            handleRepeatedInvocation();
        }

        return getErrorMessage();
    }

    /**
     * Hides the popup and returns <code>true</code> if the popup is configured
     * to never display an empty list. Returns <code>false</code> otherwise.
     *
     * @param autoActivated whether the invocation was auto-activated
     * @return <code>false</code> if an empty list should be displayed, <code>true</code> otherwise
     * @since 3.2
     */
    private bool hideWhenNoProposals(bool autoActivated) {
        if (autoActivated || !fContentAssistant.isShowEmptyList()) {
            if (!autoActivated) {
                Control control= fContentAssistSubjectControlAdapter.getControl();
                if (control !is null && !control.isDisposed())
                    control.getDisplay().beep();
            }
            hide();
            return true;
        }
        return false;
    }

    /**
     * If content assist is set up to handle cycling, then the proposals are recomputed. Otherwise,
     * nothing happens.
     *
     * @since 3.2
     */
    private void handleRepeatedInvocation() {
        if (fContentAssistant.isRepeatedInvocationMode()) {
            fComputedProposals= computeProposals(fFilterOffset);
            setProposals(fComputedProposals, false);
        }
    }

    /**
     * Returns the completion proposal available at the given offset of the
     * viewer's document. Delegates the work to the content assistant.
     *
     * @param offset the offset
     * @return the completion proposals available at this offset
     */
    private ICompletionProposal[] computeProposals(int offset) {
        if (fContentAssistSubjectControl !is null)
            return fContentAssistant.computeCompletionProposals(fContentAssistSubjectControl, offset);
        return fContentAssistant.computeCompletionProposals(fViewer, offset);
    }

    /**
     * Returns the error message.
     *
     * @return the error message
     */
    private String getErrorMessage() {
        return fContentAssistant.getErrorMessage();
    }

    /**
     * Creates the proposal selector.
     */
    private void createProposalSelector() {
        if (Helper.okToUse(fProposalShell))
            return;

        Control control= fContentAssistSubjectControlAdapter.getControl();
        fProposalShell= new Shell(control.getShell(), DWT.ON_TOP | DWT.RESIZE );
        fProposalShell.setFont(JFaceResources.getDefaultFont());
        if (USE_VIRTUAL) {
            fProposalTable= new Table(fProposalShell, DWT.H_SCROLL | DWT.V_SCROLL | DWT.VIRTUAL);

            Listener listener= new class()  Listener {
                public void handleEvent(Event event) {
                    handleSetData(event);
                }
            };
            fProposalTable.addListener(DWT.SetData, listener);
        } else {
            fProposalTable= new Table(fProposalShell, DWT.H_SCROLL | DWT.V_SCROLL);
        }

        fIsColoredLabelsSupportEnabled= fContentAssistant.isColoredLabelsSupportEnabled();
        if (fIsColoredLabelsSupportEnabled)
            TableOwnerDrawSupport.install(fProposalTable);

        fProposalTable.setLocation(0, 0);
        if (fAdditionalInfoController !is null)
            fAdditionalInfoController.setSizeConstraints(50, 10, true, true);

        GridLayout layout= new GridLayout();
        layout.marginWidth= 0;
        layout.marginHeight= 0;
        layout.verticalSpacing= 1;
        fProposalShell.setLayout(layout);

        if (fContentAssistant.isStatusLineVisible()) {
            createMessageText();
        }

        GridData data= new GridData(GridData.FILL_BOTH);

        Point size= fContentAssistant.restoreCompletionProposalPopupSize_package();
        if (size !is null) {
            fProposalTable.setLayoutData(data);
            fProposalShell.setSize(size);
        } else {
            int height= fProposalTable.getItemHeight() * 10;
            // use golden ratio as default aspect ratio
            double aspectRatio= (1 + Math.sqrt(5.0f)) / 2;
            int width= cast(int) (height * aspectRatio);
            Rectangle trim= fProposalTable.computeTrim(0, 0, width, height);
            data.heightHint= trim.height;
            data.widthHint= trim.width;
            fProposalTable.setLayoutData(data);
            fProposalShell.pack();
        }
        fContentAssistant.addToLayout(this, fProposalShell, ContentAssistant.LayoutManager.LAYOUT_PROPOSAL_SELECTOR, fContentAssistant.getSelectionOffset());

        fProposalShell.addControlListener(new class()  ControlListener {

            public void controlMoved(ControlEvent e) {}

            public void controlResized(ControlEvent e) {
                if (fAdditionalInfoController !is null) {
                    // reset the cached resize constraints
                    fAdditionalInfoController.setSizeConstraints(50, 10, true, false);
                }

                fSize= fProposalShell.getSize();
            }
        });

        fProposalShell.setBackground(control.getDisplay().getSystemColor(DWT.COLOR_GRAY));

        Color c= getBackgroundColor(control);
        fProposalTable.setBackground(c);

        c= getForegroundColor(control);
        fProposalTable.setForeground(c);

        fProposalTable.addSelectionListener(new class()  SelectionListener {

            public void widgetSelected(SelectionEvent e) {}

            public void widgetDefaultSelected(SelectionEvent e) {
                insertSelectedProposalWithMask(e.stateMask);
            }
        });

        fPopupCloser.install(fContentAssistant, fProposalTable, fAdditionalInfoController);

        fProposalShell.addDisposeListener(new class()  DisposeListener {
            public void widgetDisposed(DisposeEvent e) {
                unregister(); // but don't dispose the shell, since we're being called from its disposal event!
            }
        });

        fProposalTable.setHeaderVisible(false);

        addCommandSupport(fProposalTable);
    }

    /**
     * Returns the minimal required height for the proposal, may return 0 if the popup has not been
     * created yet.
     *
     * @return the minimal height
     * @since 3.3
     */
    int getMinimalHeight() {
        int height= 0;
        if (Helper.okToUse(fProposalTable)) {
            int items= fProposalTable.getItemHeight() * 10;
            Rectangle trim= fProposalTable.computeTrim(0, 0, DWT.DEFAULT, items);
            height= trim.height;
        }
        if (Helper.okToUse(fMessageText))
            height+= fMessageText.getSize().y + 1;
        return height;
    }

    /**
     * Adds command support to the given control.
     *
     * @param control the control to watch for focus
     * @since 3.2
     */
    private void addCommandSupport(Control control) {
        final KeySequence commandSequence= fContentAssistant.getRepeatedInvocationKeySequence();
        if (commandSequence !is null && !commandSequence.isEmpty() && fContentAssistant.isRepeatedInvocationMode()) {
            control.addFocusListener(new class(control,commandSequence)  FocusListener {
                Control control_;
                KeySequence commandSequence_;
                this(Control a, KeySequence b){
                    control_=a;
                    commandSequence_=b;
                }
                private CommandKeyListener fCommandKeyListener;
                public void focusGained(FocusEvent e) {
                    if (Helper.okToUse(control_)) {
                        if (fCommandKeyListener is null) {
                            fCommandKeyListener= new CommandKeyListener(commandSequence_);
                            fProposalTable.addKeyListener(fCommandKeyListener);
                        }
                    }
                }
                public void focusLost(FocusEvent e) {
                    if (fCommandKeyListener !is null) {
                        control_.removeKeyListener(fCommandKeyListener);
                        fCommandKeyListener= null;
                    }
                }
            });
        }
        control.addFocusListener(new class(control)  FocusListener {
            Control control_;
            private TraverseListener fTraverseListener;
            this(Control a){
                control_=a;
            }
            public void focusGained(FocusEvent e) {
                if (Helper.okToUse(control_)) {
                    if (fTraverseListener is null) {
                        fTraverseListener= new class()  TraverseListener {
                            public void keyTraversed(TraverseEvent event) {
                                if (event.detail is DWT.TRAVERSE_TAB_NEXT) {
                                    IInformationControl iControl= fAdditionalInfoController.getCurrentInformationControl2();
                                    if (fAdditionalInfoController.getInternalAccessor().canReplace(iControl)) {
                                        fAdditionalInfoController.getInternalAccessor().replaceInformationControl(true);
                                        event.doit= false;
                                    }
                                }
                            }
                        };
                        fProposalTable.addTraverseListener(fTraverseListener);
                    }
                }
            }
            public void focusLost(FocusEvent e) {
                if (fTraverseListener !is null) {
                    control_.removeTraverseListener(fTraverseListener);
                    fTraverseListener= null;
                }
            }
        });
    }

    /**
     * Returns the background color to use.
     *
     * @param control the control to get the display from
     * @return the background color
     * @since 3.2
     */
    private Color getBackgroundColor(Control control) {
        Color c= fContentAssistant.getProposalSelectorBackground();
        if (c is null)
            c= JFaceResources.getColorRegistry().get(JFacePreferences.CONTENT_ASSIST_BACKGROUND_COLOR);
        return c;
    }

    /**
     * Returns the foreground color to use.
     *
     * @param control the control to get the display from
     * @return the foreground color
     * @since 3.2
     */
    private Color getForegroundColor(Control control) {
        Color c= fContentAssistant.getProposalSelectorForeground();
        if (c is null)
            c= JFaceResources.getColorRegistry().get(JFacePreferences.CONTENT_ASSIST_FOREGROUND_COLOR);
        return c;
    }

    /**
     * Creates the caption line under the proposal table.
     *
     * @since 3.2
     */
    private void createMessageText() {
        if (fMessageText is null) {
            fMessageText= new Label(fProposalShell, DWT.RIGHT);
            GridData textData= new GridData(DWT.FILL, DWT.BOTTOM, true, false);
            fMessageText.setLayoutData(textData);
            fMessageText.setText(fContentAssistant.getStatusMessage() ~ " "); //$NON-NLS-1$
            if (fMessageTextFont is null) {
                Font font= fMessageText.getFont();
                Display display= fProposalShell.getDisplay();
                FontData[] fontDatas= font.getFontData();
                for (int i= 0; i < fontDatas.length; i++)
                    fontDatas[i].setHeight(fontDatas[i].getHeight() * 9 / 10);
                fMessageTextFont= new Font(display, fontDatas);
            }
            fMessageText.setFont(fMessageTextFont);
            fMessageText.setBackground(getBackgroundColor(fProposalShell));
            fMessageText.setForeground(getForegroundColor(fProposalShell));

            if (fContentAssistant.isRepeatedInvocationMode()) {
                fMessageText.setCursor(fProposalShell.getDisplay().getSystemCursor(DWT.CURSOR_HAND));
                fMessageText.addMouseListener(new class()  MouseAdapter {
                    public void mouseUp(MouseEvent e) {
                        fLastCompletionOffset= fFilterOffset;
                        fProposalTable.setFocus();
                        handleRepeatedInvocation();
                    }

                    public void mouseDown(MouseEvent e) {
                    }
                });
            }
        }
    }

    /*
     * @since 3.1
     */
    private void handleSetData(Event event) {
        TableItem item= cast(TableItem) event.item;
        int index= fProposalTable.indexOf(item);

        if (0 <= index && index < fFilteredProposals.length) {
            ICompletionProposal current= fFilteredProposals[index];

            String displayString;
            StyleRange[] styleRanges= null;
            if (fIsColoredLabelsSupportEnabled && cast(ICompletionProposalExtension6)current ) {
                StyledString styledString= (cast(ICompletionProposalExtension6)current).getStyledDisplayString();
                displayString= styledString.getString();
                styleRanges= styledString.getStyleRanges();
            } else
                displayString= current.getDisplayString();

            item.setText(displayString);
            if (fIsColoredLabelsSupportEnabled)
                TableOwnerDrawSupport.storeStyleRanges(item, 0, styleRanges);

            item.setImage(current.getImage());
            item.setData(cast(Object)current);
        } else {
            // this should not happen, but does on win32
        }
    }

    /**
     * Returns the proposal selected in the proposal selector.
     *
     * @return the selected proposal
     * @since 2.0
     */
    private ICompletionProposal getSelectedProposal() {
        /* Make sure that there is no filter runnable pending.
         * See https://bugs.eclipse.org/bugs/show_bug.cgi?id=31427
         */
        if (fIsFilterPending)
            fFilterRunnable.run();

        // filter runnable may have hidden the proposals
        if (!Helper.okToUse(fProposalTable))
            return null;

        int i= fProposalTable.getSelectionIndex();
        if (fFilteredProposals is null || i < 0 || i >= fFilteredProposals.length)
            return null;
        return fFilteredProposals[i];
    }

    /**
     * Takes the selected proposal and applies it.
     *
     * @param stateMask the state mask
     * @since 3.2
     */
    private void insertSelectedProposalWithMask(int stateMask) {
        ICompletionProposal p= getSelectedProposal();
        hide();
        if (p !is null)
            insertProposal(p, cast(wchar) 0, stateMask, fContentAssistSubjectControlAdapter.getSelectedRange().x);
    }

    /**
     * Applies the given proposal at the given offset. The given character is the
     * one that triggered the insertion of this proposal.
     *
     * @param p the completion proposal
     * @param trigger the trigger character
     * @param stateMask the state mask
     * @param offset the offset
     * @since 2.1
     */
    private void insertProposal(ICompletionProposal p, char trigger, int stateMask, int offset) {

        fInserting= true;
        IRewriteTarget target= null;
        IEditingSupport helper= new class(offset)  IEditingSupport {
            int offset_;
            this(int a){
                offset_=a;
            }
            public bool isOriginator(DocumentEvent event, IRegion focus) {
                return focus.getOffset() <= offset_ && focus.getOffset() + focus.getLength() >= offset_;
            }

            public bool ownsFocusShell() {
                return false;
            }

        };

        try {

            IDocument document= fContentAssistSubjectControlAdapter.getDocument();

            if ( cast(ITextViewerExtension)fViewer ) {
                ITextViewerExtension extension= cast(ITextViewerExtension) fViewer;
                target= extension.getRewriteTarget();
            }

            if (target !is null)
                target.beginCompoundChange();

            if ( cast(IEditingSupportRegistry)fViewer ) {
                IEditingSupportRegistry registry= cast(IEditingSupportRegistry) fViewer;
                registry.register(helper);
            }


            if (cast(ICompletionProposalExtension2)p && fViewer !is null) {
                ICompletionProposalExtension2 e= cast(ICompletionProposalExtension2) p;
                e.apply(fViewer, trigger, stateMask, offset);
            } else if ( cast(ICompletionProposalExtension)p ) {
                ICompletionProposalExtension e= cast(ICompletionProposalExtension) p;
                e.apply(document, trigger, offset);
            } else {
                p.apply(document);
            }

            Point selection= p.getSelection(document);
            if (selection !is null) {
                fContentAssistSubjectControlAdapter.setSelectedRange(selection.x, selection.y);
                fContentAssistSubjectControlAdapter.revealRange(selection.x, selection.y);
            }

            IContextInformation info= p.getContextInformation();
            if (info !is null) {

                int contextInformationOffset;
                if ( cast(ICompletionProposalExtension)p ) {
                    ICompletionProposalExtension e= cast(ICompletionProposalExtension) p;
                    contextInformationOffset= e.getContextInformationPosition();
                } else {
                    if (selection is null)
                        selection= fContentAssistSubjectControlAdapter.getSelectedRange();
                    contextInformationOffset= selection.x + selection.y;
                }

                fContentAssistant.showContextInformation(info, contextInformationOffset);
            } else
                fContentAssistant.showContextInformation(null, -1);


        } finally {
            if (target !is null)
                target.endCompoundChange();

            if ( cast(IEditingSupportRegistry)fViewer ) {
                IEditingSupportRegistry registry= cast(IEditingSupportRegistry) fViewer;
                registry.unregister(helper);
            }
            fInserting= false;
        }
    }

    /**
     * Returns whether this popup has the focus.
     *
     * @return <code>true</code> if the popup has the focus
     */
    public bool hasFocus() {
        if (Helper.okToUse(fProposalShell)) {
            if ((fProposalShell.isFocusControl() || fProposalTable.isFocusControl()))
                return true;
            /*
             * We have to delegate this query to the additional info controller
             * as well, since the content assistant is the widget token owner
             * and its closer does not know that the additional info control can
             * now also take focus.
             */
            if (fAdditionalInfoController !is null) {
                IInformationControl informationControl= fAdditionalInfoController.getCurrentInformationControl2();
                if (informationControl !is null && informationControl.isFocusControl())
                    return true;
                InformationControlReplacer replacer= fAdditionalInfoController.getInternalAccessor().getInformationControlReplacer();
                if (replacer !is null) {
                    informationControl= replacer.getCurrentInformationControl2();
                    if (informationControl !is null && informationControl.isFocusControl())
                        return true;
                }
            }
        }

        return false;
    }

    /**
     * Hides this popup.
     */
    public void hide() {

        unregister();

        if ( cast(IEditingSupportRegistry)fViewer ) {
            IEditingSupportRegistry registry= cast(IEditingSupportRegistry) fViewer;
            registry.unregister(fFocusHelper);
        }

        if (Helper.okToUse(fProposalShell)) {

            fContentAssistant.removeContentAssistListener(this, ContentAssistant.PROPOSAL_SELECTOR);

            fPopupCloser.uninstall();
            fProposalShell.setVisible(false);
            fProposalShell.dispose();
            fProposalShell= null;
        }

        if (fMessageTextFont !is null) {
            fMessageTextFont.dispose();
            fMessageTextFont= null;
        }

        if (fMessageText !is null) {
            fMessageText= null;
        }

        fEmptyMessage= null;

        fLastCompletionOffset= -1;

        fContentAssistant.fireSessionEndEvent();
    }

    /**
     * Unregister this completion proposal popup.
     *
     * @since 3.0
     */
    private void unregister() {
        if (fDocumentListener !is null) {
            IDocument document= fContentAssistSubjectControlAdapter.getDocument();
            if (document !is null)
                document.removeDocumentListener(fDocumentListener);
            fDocumentListener= null;
        }
        fDocumentEvents.clear();

        if (fKeyListener !is null && fContentAssistSubjectControlAdapter.getControl() !is null && !fContentAssistSubjectControlAdapter.getControl().isDisposed()) {
            fContentAssistSubjectControlAdapter.removeKeyListener(fKeyListener);
            fKeyListener= null;
        }

        if (fLastProposal !is null) {
            if (cast(ICompletionProposalExtension2)fLastProposal  && fViewer !is null) {
                ICompletionProposalExtension2 extension= cast(ICompletionProposalExtension2) fLastProposal;
                extension.unselected(fViewer);
            }
            fLastProposal= null;
        }

        fFilteredProposals= null;
        fComputedProposals= null;

        fContentAssistant.possibleCompletionsClosed_package();
    }

    /**
     *Returns whether this popup is active. It is active if the proposal selector is visible.
     *
     * @return <code>true</code> if this popup is active
     */
    public bool isActive() {
        return fProposalShell !is null && !fProposalShell.isDisposed();
    }

    /**
     * Initializes the proposal selector with these given proposals.
     * @param proposals the proposals
     * @param isFilteredSubset if <code>true</code>, the proposal table is
     *        not cleared, but the proposals that are not in the passed array
     *        are removed from the displayed set
     */
    private void setProposals(ICompletionProposal[] proposals, bool isFilteredSubset) {
        ICompletionProposal[] oldProposals= fFilteredProposals;
        ICompletionProposal oldProposal= getSelectedProposal(); // may trigger filtering and a reentrant call to setProposals()
        if (oldProposals !is fFilteredProposals) // reentrant call was first - abort
            return;

        if (Helper.okToUse(fProposalTable)) {
            if (cast(ICompletionProposalExtension2)oldProposal  && fViewer !is null)
                (cast(ICompletionProposalExtension2) oldProposal).unselected(fViewer);

            if (proposals is null || proposals.length is 0) {
                fEmptyProposal.fOffset= fFilterOffset;
                fEmptyProposal.fDisplayString= fEmptyMessage !is null ? fEmptyMessage : JFaceTextMessages.getString("CompletionProposalPopup.no_proposals"); //$NON-NLS-1$
                proposals= [ fEmptyProposal ];
            }

            fFilteredProposals= proposals;
            final int newLen= proposals.length;
            if (USE_VIRTUAL) {
                fProposalTable.setItemCount(newLen);
                fProposalTable.clearAll();
            } else {
                fProposalTable.setRedraw(false);
                fProposalTable.setItemCount(newLen);
                TableItem[] items= fProposalTable.getItems();
                for (int i= 0; i < items.length; i++) {
                    TableItem item= items[i];
                    ICompletionProposal proposal= proposals[i];
                    item.setText(proposal.getDisplayString());
                    item.setImage(proposal.getImage());
                    item.setData(cast(Object)proposal);
                }
                fProposalTable.setRedraw(true);
            }

            Point currentLocation= fProposalShell.getLocation();
            Point newLocation= getLocation();
            if ((newLocation.x < currentLocation.x && newLocation.y is currentLocation.y) || newLocation.y < currentLocation.y)
                fProposalShell.setLocation(newLocation);

            selectProposal(0, false);
        }
    }

    /**
     * Returns the graphical location at which this popup should be made visible.
     *
     * @return the location of this popup
     */
    private Point getLocation() {
        int caret= fContentAssistSubjectControlAdapter.getCaretOffset();
        Rectangle location= fContentAssistant.getLayoutManager().computeBoundsBelowAbove_package(fProposalShell, fSize is null ? fProposalShell.getSize() : fSize, caret, this);
        return Geometry.getLocation(location);
    }

    /**
     * Returns the size of this completion proposal popup.
     *
     * @return a Point containing the size
     * @since 3.0
     */
    Point getSize() {
        return fSize;
    }

    /**
     * Displays this popup and install the additional info controller, so that additional info
     * is displayed when a proposal is selected and additional info is available.
     */
    private void displayProposals() {

        if (!Helper.okToUse(fProposalShell) ||  !Helper.okToUse(fProposalTable))
            return;

        if (fContentAssistant.addContentAssistListener(this, ContentAssistant.PROPOSAL_SELECTOR)) {

            ensureDocumentListenerInstalled();

            if (fFocusHelper is null) {
                fFocusHelper= new class()  IEditingSupport {

                    public bool isOriginator(DocumentEvent event, IRegion focus) {
                        return false; // this helper just covers the focus change to the proposal shell, no remote editions
                    }

                    public bool ownsFocusShell() {
                        return true;
                    }

                };
            }
            if ( cast(IEditingSupportRegistry)fViewer ) {
                IEditingSupportRegistry registry= cast(IEditingSupportRegistry) fViewer;
                registry.register(fFocusHelper);
            }


            /* https://bugs.eclipse.org/bugs/show_bug.cgi?id=52646
             * on GTK, setVisible and such may run the event loop
             * (see also https://bugs.eclipse.org/bugs/show_bug.cgi?id=47511)
             * Since the user may have already canceled the popup or selected
             * an entry (ESC or RETURN), we have to double check whether
             * the table is still okToUse. See comments below
             */
            fProposalShell.setVisible(true); // may run event loop on GTK
            // transfer focus since no verify key listener can be attached
            if (!fContentAssistSubjectControlAdapter.supportsVerifyKeyListener() && Helper.okToUse(fProposalShell))
                fProposalShell.setFocus(); // may run event loop on GTK ??

            if (fAdditionalInfoController !is null && Helper.okToUse(fProposalTable)) {
                fAdditionalInfoController.install(fProposalTable);
                fAdditionalInfoController.handleTableSelectionChanged();
            }
        } else
            hide();
    }

    /**
     * Installs the document listener if not already done.
     *
     * @since 3.2
     */
    private void ensureDocumentListenerInstalled() {
        if (fDocumentListener is null) {
            fDocumentListener=  new class()   IDocumentListener {
                public void documentAboutToBeChanged(DocumentEvent event) {
                    if (!fInserting)
                        fDocumentEvents.add(event);
                }

                public void documentChanged(DocumentEvent event) {
                    if (!fInserting)
                        filterProposals();
                }
            };
            IDocument document= fContentAssistSubjectControlAdapter.getDocument();
            if (document !is null)
                document.addDocumentListener(fDocumentListener);
        }
    }

    /*
     * @see IContentAssistListener#verifyKey(VerifyEvent)
     */
    public bool verifyKey(VerifyEvent e) {
        if (!Helper.okToUse(fProposalShell))
            return true;

        char key= e.character;
        if (key is 0) {
            int newSelection= fProposalTable.getSelectionIndex();
            int visibleRows= (fProposalTable.getSize().y / fProposalTable.getItemHeight()) - 1;
            int itemCount= fProposalTable.getItemCount();
            bool smartToggle= false;
            switch (e.keyCode) {

                case DWT.ARROW_LEFT :
                case DWT.ARROW_RIGHT :
                    filterProposals();
                    return true;

                case DWT.ARROW_UP :
                    newSelection -= 1;
                    if (newSelection < 0)
                        newSelection= itemCount - 1;
                    break;

                case DWT.ARROW_DOWN :
                    newSelection += 1;
                    if (newSelection > itemCount - 1)
                        newSelection= 0;
                    break;

                case DWT.PAGE_DOWN :
                    newSelection += visibleRows;
                    if (newSelection >= itemCount)
                        newSelection= itemCount - 1;
                    break;

                case DWT.PAGE_UP :
                    newSelection -= visibleRows;
                    if (newSelection < 0)
                        newSelection= 0;
                    break;

                case DWT.HOME :
                    newSelection= 0;
                    break;

                case DWT.END :
                    newSelection= itemCount - 1;
                    break;

                default :
                    if (e.keyCode !is DWT.CAPS_LOCK && e.keyCode !is DWT.MOD1 && e.keyCode !is DWT.MOD2 && e.keyCode !is DWT.MOD3 && e.keyCode !is DWT.MOD4)
                        hide();
                    return true;
            }

            selectProposal(newSelection, smartToggle);

            e.doit= false;
            return false;

        }

        // key !is 0
        switch (key) {
            case 0x1B: // Esc
                e.doit= false;
                hide();
                break;

            case '\n': // Ctrl-Enter on w2k
            case '\r': // Enter
                e.doit= false;
                insertSelectedProposalWithMask(e.stateMask);
                break;

            case '\t':
                e.doit= false;
                fProposalShell.setFocus();
                return false;

            default:
                ICompletionProposal p= getSelectedProposal();
                if ( cast(ICompletionProposalExtension)p ) {
                    ICompletionProposalExtension t= cast(ICompletionProposalExtension) p;
                    char[] triggers= t.getTriggerCharacters();
                    if (contains(triggers, key)) {
                        e.doit= false;
                        hide();
                        insertProposal(p, key, e.stateMask, fContentAssistSubjectControlAdapter.getSelectedRange().x);
                    }
            }
        }

        return true;
    }

    /**
     * Selects the entry with the given index in the proposal selector and feeds
     * the selection to the additional info controller.
     *
     * @param index the index in the list
     * @param smartToggle <code>true</code> if the smart toggle key has been pressed
     * @since 2.1
     */
    private void selectProposal(int index, bool smartToggle) {

        ICompletionProposal oldProposal= getSelectedProposal();
        if (cast(ICompletionProposalExtension2)oldProposal  && fViewer !is null)
            (cast(ICompletionProposalExtension2) oldProposal).unselected(fViewer);

        if (fFilteredProposals is null) {
            fireSelectionEvent(null, smartToggle);
            return;
        }

        ICompletionProposal proposal= fFilteredProposals[index];
        if (cast(ICompletionProposalExtension2)proposal && fViewer !is null)
            (cast(ICompletionProposalExtension2) proposal).selected(fViewer, smartToggle);

        fireSelectionEvent(proposal, smartToggle);

        fLastProposal= proposal;

        fProposalTable.setSelection(index);
        fProposalTable.showSelection();
        if (fAdditionalInfoController !is null)
            fAdditionalInfoController.handleTableSelectionChanged();
    }

    /**
     * Fires a selection event, see {@link ICompletionListener}.
     *
     * @param proposal the selected proposal, possibly <code>null</code>
     * @param smartToggle true if the smart toggle is on
     * @since 3.2
     */
    private void fireSelectionEvent(ICompletionProposal proposal, bool smartToggle) {
        fContentAssistant.fireSelectionEvent(proposal, smartToggle);
    }

    /**
     * Returns whether the given character is contained in the given array of
     * characters.
     *
     * @param characters the list of characters
     * @param c the character to look for in the list
     * @return <code>true</code> if character belongs to the list
     * @since 2.0
     */
    private bool contains(char[] characters, char c) {

        if (characters is null)
            return false;

        for (int i= 0; i < characters.length; i++) {
            if (c is characters[i])
                return true;
        }

        return false;
    }

    /*
     * @see IEventConsumer#processEvent(VerifyEvent)
     */
    public void processEvent(VerifyEvent e) {
    }

    /**
     * Filters the displayed proposal based on the given cursor position and the
     * offset of the original invocation of the content assistant.
     */
    private void filterProposals() {
        if (!fIsFilterPending) {
            fIsFilterPending= true;
            Control control= fContentAssistSubjectControlAdapter.getControl();
            control.getDisplay().asyncExec(fFilterRunnable);
        }
    }

    /**
     * Computes the subset of already computed proposals that are still valid for
     * the given offset.
     *
     * @param offset the offset
     * @param event the merged document event
     * @return the set of filtered proposals
     * @since 3.0
     */
    private ICompletionProposal[] computeFilteredProposals(int offset, DocumentEvent event) {

        if (offset is fInvocationOffset && event is null) {
            fIsFilteredSubset= false;
            return fComputedProposals;
        }

        if (offset < fInvocationOffset) {
            fIsFilteredSubset= false;
            fInvocationOffset= offset;
            fContentAssistant.fireSessionRestartEvent();
            fComputedProposals= computeProposals(fInvocationOffset);
            return fComputedProposals;
        }

        ICompletionProposal[] proposals;
        if (offset < fFilterOffset) {
            proposals= fComputedProposals;
            fIsFilteredSubset= false;
        } else {
            proposals= fFilteredProposals;
            fIsFilteredSubset= true;
        }

        if (proposals is null) {
            fIsFilteredSubset= false;
            return null;
        }

        IDocument document= fContentAssistSubjectControlAdapter.getDocument();
        int length= proposals.length;
        List filtered= new ArrayList(length);
        for (int i= 0; i < length; i++) {

            if (cast(ICompletionProposalExtension2)proposals[i] ) {

                ICompletionProposalExtension2 p= cast(ICompletionProposalExtension2) proposals[i];
                if (p.validate(document, offset, event))
                    filtered.add(cast(Object)p);

            } else if (cast(ICompletionProposalExtension)proposals[i] ) {

                ICompletionProposalExtension p= cast(ICompletionProposalExtension) proposals[i];
                if (p.isValidFor(document, offset))
                    filtered.add(cast(Object)p);

            } else {
                // restore original behavior
                fIsFilteredSubset= false;
                fInvocationOffset= offset;
                fContentAssistant.fireSessionRestartEvent();
                fComputedProposals= computeProposals(fInvocationOffset);
                return fComputedProposals;
            }
        }

        return arraycast!(ICompletionProposal)( filtered.toArray());
    }

    /**
     * Requests the proposal shell to take focus.
     *
     * @since 3.0
     */
    public void setFocus() {
        if (Helper.okToUse(fProposalShell)) {
            fProposalShell.setFocus();
        }
    }

    /**
     * Returns <code>true</code> if <code>proposal</code> should be auto-inserted,
     * <code>false</code> otherwise.
     *
     * @param proposal the single proposal that might be automatically inserted
     * @return <code>true</code> if <code>proposal</code> can be inserted automatically,
     *         <code>false</code> otherwise
     * @since 3.1
     */
    private bool canAutoInsert(ICompletionProposal proposal) {
        if (fContentAssistant.isAutoInserting()) {
            if ( cast(ICompletionProposalExtension4)proposal ) {
                ICompletionProposalExtension4 ext= cast(ICompletionProposalExtension4) proposal;
                return ext.isAutoInsertable();
            }
            return true; // default behavior before ICompletionProposalExtension4 was introduced
        }
        return false;
    }

    /**
     * Completes the common prefix of all proposals directly in the code. If no
     * common prefix can be found, the proposal popup is shown.
     *
     * @return an error message if completion failed.
     * @since 3.0
     */
    public String incrementalComplete() {
        if (Helper.okToUse(fProposalShell) && fFilteredProposals !is null) {
            if (fLastCompletionOffset is fFilterOffset) {
                handleRepeatedInvocation();
            } else {
                fLastCompletionOffset= fFilterOffset;
                completeCommonPrefix();
            }
        } else {
            final Control control= fContentAssistSubjectControlAdapter.getControl();

            if (fKeyListener is null)
                fKeyListener= new ProposalSelectionListener();

            if (!Helper.okToUse(fProposalShell) && !control.isDisposed())
                fContentAssistSubjectControlAdapter.addKeyListener(fKeyListener);

            BusyIndicator.showWhile(control.getDisplay(), new class()  Runnable {
                public void run() {

                    fInvocationOffset= fContentAssistSubjectControlAdapter.getSelectedRange().x;
                    fFilterOffset= fInvocationOffset;
                    fLastCompletionOffset= fFilterOffset;
                    fFilteredProposals= computeProposals(fInvocationOffset);

                    int count= (fFilteredProposals is null ? 0 : fFilteredProposals.length);
                    if (count is 0 && hideWhenNoProposals(false))
                        return;

                    if (count is 1 && canAutoInsert(fFilteredProposals[0])) {
                        insertProposal(fFilteredProposals[0], cast(wchar) 0, 0, fInvocationOffset);
                        hide();
                    } else {
                        ensureDocumentListenerInstalled();
                        if (count > 0 && completeCommonPrefix())
                            hide();
                        else {
                            fComputedProposals= fFilteredProposals;
                            createProposalSelector();
                            setProposals(fComputedProposals, false);
                            displayProposals();
                        }
                    }
                }
            });
        }
        return getErrorMessage();
    }

    /**
     * Acts upon <code>fFilteredProposals</code>: if there is just one valid
     * proposal, it is inserted, otherwise, the common prefix of all proposals
     * is inserted into the document. If there is no common prefix, nothing
     * happens and <code>false</code> is returned.
     *
     * @return <code>true</code> if a single proposal was inserted and the
     *         selector can be closed, <code>false</code> otherwise
     * @since 3.0
     */
    private bool completeCommonPrefix() {

        // 0: insert single proposals
        if (fFilteredProposals.length is 1) {
            if (canAutoInsert(fFilteredProposals[0])) {
                insertProposal(fFilteredProposals[0], cast(wchar) 0, 0, fFilterOffset);
                hide();
                return true;
            }
            return false;
        }

        // 1: extract pre- and postfix from all remaining proposals
        IDocument document= fContentAssistSubjectControlAdapter.getDocument();

        // contains the common postfix in the case that there are any proposals matching our LHS
        StringBuffer rightCasePostfix;
        List rightCase= new ArrayList();

        bool isWrongCaseMatch= false;

        // the prefix of all case insensitive matches. This differs from the document
        // contents and will be replaced.
        CharSequence wrongCasePrefix= null;
        int wrongCasePrefixStart= 0;
        // contains the common postfix of all case-insensitive matches
        StringBuffer wrongCasePostfix;
        List wrongCase= new ArrayList();

        for (int i= 0; i < fFilteredProposals.length; i++) {
            ICompletionProposal proposal= fFilteredProposals[i];

            if (!( cast(ICompletionProposalExtension3)proposal ))
                return false;

            int start= (cast(ICompletionProposalExtension3)proposal).getPrefixCompletionStart(fContentAssistSubjectControlAdapter.getDocument(), fFilterOffset);
            CharSequence insertion= (cast(ICompletionProposalExtension3)proposal).getPrefixCompletionText(fContentAssistSubjectControlAdapter.getDocument(), fFilterOffset);
            if (insertion is null)
                insertion= new StringCharSequence(proposal.getDisplayString());
            try {
                int prefixLength= fFilterOffset - start;
                int relativeCompletionOffset= Math.min(insertion.length(), prefixLength);
                String prefix= document.get(start, prefixLength);
                if (!isWrongCaseMatch && insertion.toString().startsWith(prefix)) {
                    isWrongCaseMatch= false;
                    rightCase.add(cast(Object)proposal);
                    CharSequence newPostfix= insertion.subSequence(relativeCompletionOffset, insertion.length());
                    if (rightCasePostfix is null)
                        rightCasePostfix= new StringBuffer(newPostfix.toString());
                    else
                        truncatePostfix(rightCasePostfix, newPostfix);
                } else if (i is 0 || isWrongCaseMatch) {
                    CharSequence newPrefix= insertion.subSequence(0, relativeCompletionOffset);
                    if (isPrefixCompatible(wrongCasePrefix, wrongCasePrefixStart, newPrefix, start, document)) {
                        isWrongCaseMatch= true;
                        wrongCasePrefix= newPrefix;
                        wrongCasePrefixStart= start;
                        CharSequence newPostfix= insertion.subSequence(relativeCompletionOffset, insertion.length());
                        if (wrongCasePostfix is null)
                            wrongCasePostfix= new StringBuffer(newPostfix.toString());
                        else
                            truncatePostfix(wrongCasePostfix, newPostfix);
                        wrongCase.add(cast(Object)proposal);
                    } else {
                        return false;
                    }
                } else
                    return false;
            } catch (BadLocationException e2) {
                // bail out silently
                return false;
            }

            if (rightCasePostfix !is null && rightCasePostfix.length() is 0 && rightCase.size() > 1)
                return false;
        }

        // 2: replace single proposals

        if (rightCase.size() is 1) {
            ICompletionProposal proposal= cast(ICompletionProposal) rightCase.get(0);
            if (canAutoInsert(proposal) && rightCasePostfix.length() > 0) {
                insertProposal(proposal, cast(wchar) 0, 0, fInvocationOffset);
                hide();
                return true;
            }
            return false;
        } else if (isWrongCaseMatch && wrongCase.size() is 1) {
            ICompletionProposal proposal= cast(ICompletionProposal) wrongCase.get(0);
            if (canAutoInsert(proposal)) {
                insertProposal(proposal, cast(wchar) 0, 0, fInvocationOffset);
                hide();
            return true;
            }
            return false;
        }

        // 3: replace post- / prefixes

        CharSequence prefix;
        if (isWrongCaseMatch)
            prefix= wrongCasePrefix;
        else
            prefix= new StringCharSequence("");  //$NON-NLS-1$

        CharSequence postfix;
        if (isWrongCaseMatch)
            postfix= new StringCharSequence(wrongCasePostfix.toString);
        else
            postfix= new StringCharSequence(rightCasePostfix.toString);

        if (prefix is null || postfix is null)
            return false;

        try {
            // 4: check if parts of the postfix are already in the document
            int to= Math.min(document.getLength(), fFilterOffset + postfix.length());
            StringBuffer inDocument= new StringBuffer(document.get(fFilterOffset, to - fFilterOffset));
            truncatePostfix(inDocument, postfix);

            // 5: replace and reveal
            document.replace(fFilterOffset - prefix.length(), prefix.length() + inDocument.length(), prefix.toString() ~ postfix.toString());

            fContentAssistSubjectControlAdapter.setSelectedRange(fFilterOffset + postfix.length(), 0);
            fContentAssistSubjectControlAdapter.revealRange(fFilterOffset + postfix.length(), 0);
            fFilterOffset+= postfix.length();
            fLastCompletionOffset= fFilterOffset;

            return false;
        } catch (BadLocationException e) {
            // ignore and return false
            return false;
        }
    }

    /*
     * @since 3.1
     */
    private bool isPrefixCompatible(CharSequence oneSequence, int oneOffset, CharSequence twoSequence, int twoOffset, IDocument document)  {
        if (oneSequence is null || twoSequence is null)
            return true;

        int min= Math.min(oneOffset, twoOffset);
        int oneEnd= oneOffset + oneSequence.length();
        int twoEnd= twoOffset + twoSequence.length();

        String one= document.get(oneOffset, min - oneOffset) ~ oneSequence.toString ~ document.get(oneEnd, Math.min(fFilterOffset, fFilterOffset - oneEnd));
        String two= document.get(twoOffset, min - twoOffset) ~ twoSequence.toString ~ document.get(twoEnd, Math.min(fFilterOffset, fFilterOffset - twoEnd));

        return one.equals(two);
    }

    /**
     * Truncates <code>buffer</code> to the common prefix of <code>buffer</code>
     * and <code>sequence</code>.
     *
     * @param buffer the common postfix to truncate
     * @param sequence the characters to truncate with
     */
    private void truncatePostfix(StringBuffer buffer, CharSequence sequence) {
        // find common prefix
        int min= Math.min(buffer.length(), sequence.length());
        for (int c= 0; c < min; c++) {
            if (sequence.charAt(c) !is buffer.slice()[c]) {
                buffer.truncate(c);
                return;
            }
        }

        // all equal up to minimum
        buffer.truncate(min);
    }

    /**
     * Sets the message for the repetition affordance text at the bottom of the proposal. Only has
     * an effect if {@link ContentAssistant#isRepeatedInvocationMode()} returns <code>true</code>.
     *
     * @param message the new caption
     * @since 3.2
     */
    void setMessage(String message) {
        Assert.isNotNull(message);
        if (isActive() && fMessageText !is null)
            fMessageText.setText(message ~ " "); //$NON-NLS-1$
    }

    /**
     * Sets the text to be displayed if no proposals are available. Only has an effect if
     * {@link ContentAssistant#isShowEmptyList()} returns <code>true</code>.
     *
     * @param message the empty message
     * @since 3.2
     */
    void setEmptyMessage(String message) {
        Assert.isNotNull(message);
        fEmptyMessage= message;
    }

    /**
     * Enables or disables showing of the caption line. See also {@link #setMessage(String)}.
     *
     * @param show
     * @since 3.2
     */
    public void setStatusLineVisible(bool show) {
        if (!isActive() || show is (fMessageText !is null))
            return; // nothing to do

        if (show) {
            createMessageText();
        } else {
            fMessageText.dispose();
            fMessageText= null;
        }
        fProposalShell.layout();
    }

    /**
     * Informs the popup that it is being placed above the caret line instead of below.
     *
     * @param above <code>true</code> if the location of the popup is above the caret line, <code>false</code> if it is below
     * @since 3.3
     */
    void switchedPositionToAbove(bool above) {
        if (fAdditionalInfoController !is null) {
            fAdditionalInfoController.setFallbackAnchors([
                    AbstractInformationControlManager.ANCHOR_RIGHT,
                    AbstractInformationControlManager.ANCHOR_LEFT,
                    above ? AbstractInformationControlManager.ANCHOR_TOP : AbstractInformationControlManager.ANCHOR_BOTTOM
            ]);
        }
    }

    /**
     * Returns a new proposal selection handler.
     *
     * @param operationCode the operation code
     * @return the handler
     * @since 3.4
     */
    IHandler createProposalSelectionHandler(int operationCode) {
        return new ProposalSelectionHandler(operationCode);
    }

}
