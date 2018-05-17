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
module dwtx.jface.internal.text.link.contentassist.CompletionProposalPopup2;

import dwtx.jface.internal.text.link.contentassist.IProposalListener; // packageimport
import dwtx.jface.internal.text.link.contentassist.LineBreakingReader; // packageimport
import dwtx.jface.internal.text.link.contentassist.ContextInformationPopup2; // packageimport
import dwtx.jface.internal.text.link.contentassist.ContentAssistMessages; // packageimport
import dwtx.jface.internal.text.link.contentassist.Helper2; // packageimport
import dwtx.jface.internal.text.link.contentassist.PopupCloser2; // packageimport
import dwtx.jface.internal.text.link.contentassist.IContentAssistListener2; // packageimport
import dwtx.jface.internal.text.link.contentassist.ContentAssistant2; // packageimport
import dwtx.jface.internal.text.link.contentassist.AdditionalInfoController2; // packageimport


import dwt.dwthelper.utils;


import dwtx.dwtxhelper.Collection;


import dwt.DWT;
import dwt.custom.StyleRange;
import dwt.custom.StyledText;
import dwt.events.ControlEvent;
import dwt.events.ControlListener;
import dwt.events.DisposeEvent;
import dwt.events.DisposeListener;
import dwt.events.KeyEvent;
import dwt.events.KeyListener;
import dwt.events.SelectionEvent;
import dwt.events.SelectionListener;
import dwt.events.VerifyEvent;
import dwt.graphics.Color;
import dwt.graphics.Point;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.widgets.Control;
import dwt.widgets.Shell;
import dwt.widgets.Table;
import dwt.widgets.TableItem;
import dwtx.jface.internal.text.TableOwnerDrawSupport;
import dwtx.jface.resource.JFaceResources;
import dwtx.jface.text.BadLocationException;
import dwtx.jface.text.DocumentEvent;
import dwtx.jface.text.IDocument;
import dwtx.jface.text.IDocumentListener;
import dwtx.jface.text.IEditingSupport;
import dwtx.jface.text.IEditingSupportRegistry;
import dwtx.jface.text.IRegion;
import dwtx.jface.text.IRewriteTarget;
import dwtx.jface.text.ITextViewer;
import dwtx.jface.text.ITextViewerExtension;
import dwtx.jface.text.TextUtilities;
import dwtx.jface.text.contentassist.ICompletionProposal;
import dwtx.jface.text.contentassist.ICompletionProposalExtension;
import dwtx.jface.text.contentassist.ICompletionProposalExtension2;
import dwtx.jface.text.contentassist.ICompletionProposalExtension6;
import dwtx.jface.text.contentassist.IContextInformation;
import dwtx.jface.viewers.StyledString;



/**
 * This class is used to present proposals to the user. If additional
 * information exists for a proposal, then selecting that proposal
 * will result in the information being displayed in a secondary
 * window.
 *
 * @see dwtx.jface.text.contentassist.ICompletionProposal
 * @see dwtx.jface.internal.text.link.contentassist.AdditionalInfoController2
 */
class CompletionProposalPopup2 : IContentAssistListener2 {

    /** The associated text viewer */
    private ITextViewer fViewer;
    /** The associated content assistant */
    private ContentAssistant2 fContentAssistant;
    /** The used additional info controller */
    private AdditionalInfoController2 fAdditionalInfoController;
    /** The closing strategy for this completion proposal popup */
    private PopupCloser2 fPopupCloser;
    /** The popup shell */
    private Shell fProposalShell;
    /** The proposal table */
    private Table fProposalTable;
    /** Indicates whether a completion proposal is being inserted */
    private bool fInserting= false;
    /** The key listener to control navigation */
    private KeyListener fKeyListener;
    /** List of document events used for filtering proposals */
    private List fDocumentEvents;
    /** Listener filling the document event queue */
    private IDocumentListener fDocumentListener;
    /** Reentrance count for <code>filterProposals</code> */
    private long fInvocationCounter= 0;
    /** The filter list of proposals */
    private ICompletionProposal[] fFilteredProposals;
    /** The computed list of proposals */
    private ICompletionProposal[] fComputedProposals;
    /** The offset for which the proposals have been computed */
    private int fInvocationOffset;
    /** The offset for which the computed proposals have been filtered */
    private int fFilterOffset;
    /** The default line delimiter of the viewer's widget */
    private String fLineDelimiter;
    /** The most recently selected proposal. */
    private ICompletionProposal fLastProposal;
    /**
     * Tells whether colored labels support is enabled.
     * Only valid while the popup is active.
     *
     * @since 3.4
     */
    private bool fIsColoredLabelsSupportEnabled= false;

    private IEditingSupport fFocusEditingSupport;
    private void fFocusEditingSupport_init() {
        fFocusEditingSupport = new class() IEditingSupport {

            public bool isOriginator(DocumentEvent event, IRegion focus) {
                return false;
            }

            public bool ownsFocusShell() {
                return Helper2.okToUse(fProposalShell) && fProposalShell.isFocusControl()
                        || Helper2.okToUse(fProposalTable) && fProposalTable.isFocusControl();
            }

        };
    }
    private IEditingSupport fModificationEditingSupport;
    private void fModificationEditingSupport_init() {
        fModificationEditingSupport = new class()  IEditingSupport {

            public bool isOriginator(DocumentEvent event, IRegion focus) {
                if (fViewer !is null) {
                    Point selection= fViewer.getSelectedRange();
                    return selection.x <= focus.getOffset() + focus.getLength() && selection.x + selection.y >= focus.getOffset();
                }
                return false;
            }

            public bool ownsFocusShell() {
                return false;
            }

        };
    }

    /**
     * Creates a new completion proposal popup for the given elements.
     *
     * @param contentAssistant the content assistant feeding this popup
     * @param viewer the viewer on top of which this popup appears
     * @param infoController the info control collaborating with this popup
     * @since 2.0
     */
    public this(ContentAssistant2 contentAssistant, ITextViewer viewer, AdditionalInfoController2 infoController) {
        fPopupCloser= new PopupCloser2();
        fDocumentEvents= new ArrayList();

        fModificationEditingSupport_init();
        fFocusEditingSupport_init();

        fContentAssistant= contentAssistant;
        fViewer= viewer;
        fAdditionalInfoController= infoController;
    }

    /**
     * Computes and presents completion proposals. The flag indicates whether this call has
     * be made out of an auto activation context.
     *
     * @param autoActivated <code>true</code> if auto activation context
     * @return an error message or <code>null</code> in case of no error
     */
    public String showProposals(bool autoActivated) {

        if (fKeyListener is null) {
            fKeyListener= new class()  KeyListener {
                public void keyPressed(KeyEvent e) {
                    if (!Helper2.okToUse(fProposalShell))
                        return;

                    if (e.character is 0 && e.keyCode is DWT.CTRL) {
                        // http://dev.eclipse.org/bugs/show_bug.cgi?id=34754
                        int index= fProposalTable.getSelectionIndex();
                        if (index >= 0)
                            selectProposal(index, true);
                    }
                }

                public void keyReleased(KeyEvent e) {
                    if (!Helper2.okToUse(fProposalShell))
                        return;

                    if (e.character is 0 && e.keyCode is DWT.CTRL) {
                        // http://dev.eclipse.org/bugs/show_bug.cgi?id=34754
                        int index= fProposalTable.getSelectionIndex();
                        if (index >= 0)
                            selectProposal(index, false);
                    }
                }
            };
        }

        final StyledText styledText= fViewer.getTextWidget();
        if (styledText !is null && !styledText.isDisposed())
            styledText.addKeyListener(fKeyListener);

//      BusyIndicator.showWhile(styledText.getDisplay(), new class()  Runnable {
//          public void run() {

                fInvocationOffset= fViewer.getSelectedRange().x;
                // lazily compute proposals
//              if (fComputedProposals is null) fComputedProposals= computeProposals(fContentAssistant.getCompletionPosition());
                fComputedProposals= computeProposals(fInvocationOffset);

                int count= (fComputedProposals is null ? 0 : fComputedProposals.length);
                if (count is 0) {

                    if (!autoActivated)
                        styledText.getDisplay().beep();

                } else {

                    if (count is 1 && !autoActivated && fContentAssistant.isAutoInserting())

                        insertProposal(fComputedProposals[0], cast(wchar) 0, 0, fInvocationOffset);

                    else {

                        if (fLineDelimiter is null)
                            fLineDelimiter= styledText.getLineDelimiter();

                        createProposalSelector();
                        setProposals(fComputedProposals);
                        resizeProposalSelector(true);
                        displayProposals();
                    }
                }
//          }
//      });

        return getErrorMessage();
    }

    /**
     * Returns the completion proposal available at the given offset of the
     * viewer's document. Delegates the work to the content assistant.
     *
     * @param offset the offset
     * @return the completion proposals available at this offset
     */
    private ICompletionProposal[] computeProposals(int offset) {
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
        if (Helper2.okToUse(fProposalShell))
            return;

        Control control= fViewer.getTextWidget();
        fProposalShell= new Shell(control.getShell(), DWT.ON_TOP);
//      fProposalShell= new Shell(control.getShell(), DWT.ON_TOP | DWT.RESIZE );
        fProposalTable= new Table(fProposalShell, DWT.H_SCROLL | DWT.V_SCROLL);
//      fProposalTable= new Table(fProposalShell, DWT.H_SCROLL | DWT.V_SCROLL);


        fIsColoredLabelsSupportEnabled= fContentAssistant.isColoredLabelsSupportEnabled();
        if (fIsColoredLabelsSupportEnabled)
            TableOwnerDrawSupport.install(fProposalTable);

        fProposalTable.setLocation(0, 0);
        if (fAdditionalInfoController !is null)
            fAdditionalInfoController.setSizeConstraints(50, 10, true, false);

        GridLayout layout= new GridLayout();
        layout.marginWidth= 0;
        layout.marginHeight= 0;
        fProposalShell.setLayout(layout);

        GridData data= new GridData(GridData.FILL_BOTH);
        fProposalTable.setLayoutData(data);

        fProposalShell.pack();

        // set location
        Point currentLocation= fProposalShell.getLocation();
        Point newLocation= getLocation();
        if ((newLocation.x < currentLocation.x && newLocation.y is currentLocation.y) || newLocation.y < currentLocation.y)
            fProposalShell.setLocation(newLocation);

        if (fAdditionalInfoController !is null) {
            fProposalShell.addControlListener(new class()  ControlListener {

                public void controlMoved(ControlEvent e) {}

                public void controlResized(ControlEvent e) {
                    // resets the cached resize constraints
                    fAdditionalInfoController.setSizeConstraints(50, 10, true, false);
                }
            });
        }

        fProposalShell.setBackground(control.getDisplay().getSystemColor(DWT.COLOR_BLACK));

        Color c= control.getDisplay().getSystemColor(DWT.COLOR_INFO_BACKGROUND);
        fProposalTable.setBackground(c);

        c= control.getDisplay().getSystemColor(DWT.COLOR_INFO_FOREGROUND);
        fProposalTable.setForeground(c);

        fProposalTable.addSelectionListener(new class()  SelectionListener {

            public void widgetSelected(SelectionEvent e) {}

            public void widgetDefaultSelected(SelectionEvent e) {
                selectProposalWithMask(e.stateMask);
            }
        });

        fPopupCloser.install(fContentAssistant, fProposalTable);

        fProposalShell.addDisposeListener(new class()  DisposeListener {
            public void widgetDisposed(DisposeEvent e) {
                unregister(); // but don't dispose the shell, since we're being called from its disposal event!
            }
        });

        fProposalTable.setHeaderVisible(false);
        fContentAssistant.addToLayout(this, fProposalShell, ContentAssistant2.LayoutManager.LAYOUT_PROPOSAL_SELECTOR, fContentAssistant.getSelectionOffset());
    }

    /**
     * Returns the proposal selected in the proposal selector.
     *
     * @return the selected proposal
     * @since 2.0
     */
    private ICompletionProposal getSelectedProposal() {
        int i= fProposalTable.getSelectionIndex();
        if (i < 0 || i >= fFilteredProposals.length)
            return null;
        return fFilteredProposals[i];
    }

    /**
     * Takes the selected proposal and applies it.
     *
     * @param stateMask the state mask
     * @since 2.1
     */
    private void selectProposalWithMask(int stateMask) {
        ICompletionProposal p= getSelectedProposal();
        hide();
        if (p !is null)
            insertProposal(p, cast(wchar) 0, stateMask, fViewer.getSelectedRange().x);
    }

    /**
     * Applies the given proposal at the given offset. The given character is the
     * one that triggered the insertion of this proposal.
     *
     * @param p the completion proposal
     * @param trigger the trigger character
     * @param stateMask the state mask of the keyboard event triggering the insertion
     * @param offset the offset
     * @since 2.1
     */
    private void insertProposal(ICompletionProposal p, char trigger, int stateMask, int offset) {

        fInserting= true;
        IRewriteTarget target= null;
        IEditingSupportRegistry registry= null;

        try {

            IDocument document= fViewer.getDocument();

            if ( cast(ITextViewerExtension)fViewer ) {
                ITextViewerExtension extension= cast(ITextViewerExtension) fViewer;
                target= extension.getRewriteTarget();
            }

            if (target !is null)
                target.beginCompoundChange();

            if ( cast(IEditingSupportRegistry)fViewer ) {
                registry= cast(IEditingSupportRegistry) fViewer;
                registry.register(fModificationEditingSupport);
            }

            if ( cast(ICompletionProposalExtension2)p ) {
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
                fViewer.setSelectedRange(selection.x, selection.y);
                fViewer.revealRange(selection.x, selection.y);
            }

            IContextInformation info= p.getContextInformation();
            if (info !is null) {

                int position;
                if ( cast(ICompletionProposalExtension)p ) {
                    ICompletionProposalExtension e= cast(ICompletionProposalExtension) p;
                    position= e.getContextInformationPosition();
                } else {
                    if (selection is null)
                        selection= fViewer.getSelectedRange();
                    position= selection.x + selection.y;
                }

                fContentAssistant.showContextInformation(info, position);
            }

            fContentAssistant.fireProposalChosen(p);

        } finally {
            if (target !is null)
                target.endCompoundChange();

            if (registry !is null)
                registry.unregister(fModificationEditingSupport);

            fInserting= false;
        }
    }

    /**
     * Returns whether this popup has the focus.
     *
     * @return <code>true</code> if the popup has the focus
     */
    public bool hasFocus() {
        if (Helper2.okToUse(fProposalShell))
            return (fProposalShell.isFocusControl() || fProposalTable.isFocusControl());

        return false;
    }

    /**
     * Hides this popup.
     */
    public void hide() {

        unregister();

        if ( cast(IEditingSupportRegistry)fViewer ) {
            IEditingSupportRegistry registry= cast(IEditingSupportRegistry) fViewer;
            registry.unregister(fFocusEditingSupport);
        }

        if (Helper2.okToUse(fProposalShell)) {
            fContentAssistant.removeContentAssistListener(this, ContentAssistant2.PROPOSAL_SELECTOR);

            fPopupCloser.uninstall();
            // see bug 47511: setVisible may run the event loop on GTK
            // and trigger a rentrant call - have to make sure we don't
            // dispose another shell that was already brought up in a
            // reentrant call when calling setVisible()
            Shell tempShell= fProposalShell;
            fProposalShell= null;
            tempShell.setVisible(false);
            tempShell.dispose();
        }
    }

    private void unregister() {
        if (fDocumentListener !is null) {
            IDocument document= fViewer.getDocument();
            if (document !is null)
                document.removeDocumentListener(fDocumentListener);
            fDocumentListener= null;
        }
        fDocumentEvents.clear();

        StyledText styledText= fViewer.getTextWidget();
        if (fKeyListener !is null && styledText !is null && !styledText.isDisposed())
            styledText.removeKeyListener(fKeyListener);

        if (fLastProposal !is null) {
            if ( cast(ICompletionProposalExtension2)fLastProposal ) {
                ICompletionProposalExtension2 extension= cast(ICompletionProposalExtension2) fLastProposal;
                extension.unselected(fViewer);
            }

            fLastProposal= null;
        }

        fFilteredProposals= null;

        fContentAssistant.possibleCompletionsClosed_package();
    }

    /**
     *Returns whether this popup is active. It is active if the propsal selector is visible.
     *
     * @return <code>true</code> if this popup is active
     */
    public bool isActive() {
        return fProposalShell !is null && !fProposalShell.isDisposed();
    }

    /**
     * Initializes the proposal selector with these given proposals.
     *
     * @param proposals the proposals
     */
    private void setProposals(ICompletionProposal[] proposals) {
        if (Helper2.okToUse(fProposalTable)) {

            ICompletionProposal oldProposal= getSelectedProposal();
            if ( cast(ICompletionProposalExtension2)oldProposal )
                (cast(ICompletionProposalExtension2) oldProposal).unselected(fViewer);

            fFilteredProposals= proposals;

            fProposalTable.setRedraw(false);
            fProposalTable.removeAll();

            Point selection= fViewer.getSelectedRange();
            int endOffset;
            endOffset= selection.x + selection.y;
            IDocument document= fViewer.getDocument();
            bool validate= false;
            if (selection.y !is 0 && document !is null) validate= true;
            int selectionIndex= 0;

            TableItem item;
            ICompletionProposal p;
            for (int i= 0; i < proposals.length; i++) {
                p= proposals[i];
                item= new TableItem(fProposalTable, DWT.NULL);
                if (p.getImage() !is null)
                    item.setImage(p.getImage());

                String displayString;
                StyleRange[] styleRanges= null;
                if (fIsColoredLabelsSupportEnabled && cast(ICompletionProposalExtension6)p ) {
                    StyledString styledString= (cast(ICompletionProposalExtension6)p).getStyledDisplayString();
                    displayString= styledString.getString();
                    styleRanges= styledString.getStyleRanges();
                } else
                    displayString= p.getDisplayString();

                item.setText(displayString);
                if (fIsColoredLabelsSupportEnabled)
                    TableOwnerDrawSupport.storeStyleRanges(item, 0, styleRanges);

                item.setData(cast(Object)p);

                if (validate && validateProposal(document, p, endOffset, null)) {
                    selectionIndex= i;
                    validate= false;
                }
            }

            resizeProposalSelector(false);

            selectProposal(selectionIndex, false);
            fProposalTable.setRedraw(true);
        }
    }

    private void resizeProposalSelector(bool adjustWidth) {
        // in order to fill in the table items so size computation works correctly
        // will cause flicker, though
        fProposalTable.setRedraw(true);

        int width= adjustWidth ? DWT.DEFAULT : (cast(GridData)fProposalTable.getLayoutData()).widthHint;
        Point size= fProposalTable.computeSize(width, DWT.DEFAULT, true);

        GridData data= new GridData(GridData.FILL_BOTH);
        data.widthHint= adjustWidth ? Math.min(size.x, 300) : width;
        data.heightHint= Math.min(getTableHeightHint(fProposalTable, fProposalTable.getItemCount()), getTableHeightHint(fProposalTable, 10));
        fProposalTable.setLayoutData(data);

        fProposalShell.layout(true);
        fProposalShell.pack();

        if (adjustWidth) {
            fProposalShell.setLocation(getLocation());
        }
    }

    /**
     * Computes the table hight hint for <code>table</code>.
     *
     * @param table the table to compute the height for
     * @param rows the number of rows to compute the height for
     * @return the height hint for <code>table</code>
     */
    private int getTableHeightHint(Table table, int rows) {
        if (table.getFont().opEquals(JFaceResources.getDefaultFont()))
            table.setFont(JFaceResources.getDialogFont());
        int result= table.getItemHeight() * rows;
        if (table.getLinesVisible())
            result+= table.getGridLineWidth() * (rows - 1);

        // TODO adjust to correct size. +4 works on windows, but not others
//      return result + 4;
        return result;
    }

    private bool validateProposal(IDocument document, ICompletionProposal p, int offset, DocumentEvent event) {
        // detect selected
        if ( cast(ICompletionProposalExtension2)p ) {
            ICompletionProposalExtension2 e= cast(ICompletionProposalExtension2) p;
            if (e.validate(document, offset, event))
                return true;
        } else if ( cast(ICompletionProposalExtension)p ) {
            ICompletionProposalExtension e= cast(ICompletionProposalExtension) p;
            if (e.isValidFor(document, offset))
                return true;
        }
        return false;
    }

    /**
     * Returns the graphical location at which this popup should be made visible.
     *
     * @return the location of this popup
     */
    private Point getLocation() {
        StyledText text= fViewer.getTextWidget();
        Point selection= text.getSelection();
        Point p= text.getLocationAtOffset(selection.x);
        p.x -= fProposalShell.getBorderWidth();
        if (p.x < 0) p.x= 0;
        if (p.y < 0) p.y= 0;
        p= new Point(p.x, p.y + text.getLineHeight(selection.x));
        p= text.toDisplay(p);
        return p;
    }

    /**
     *Displays this popup and install the additional info controller, so that additional info
     * is displayed when a proposal is selected and additional info is available.
     */
    private void displayProposals() {
        if (fContentAssistant.addContentAssistListener(this, ContentAssistant2.PROPOSAL_SELECTOR)) {

            if (fDocumentListener is null)
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
            IDocument document= fViewer.getDocument();
            if (document !is null)
                document.addDocumentListener(fDocumentListener);


            if ( cast(IEditingSupportRegistry)fViewer ) {
                IEditingSupportRegistry registry= cast(IEditingSupportRegistry) fViewer;
                registry.register(fFocusEditingSupport);
            }

            fProposalShell.setVisible(true);
            // see bug 47511: setVisible may run the event loop on GTK
            // and trigger a rentrant call - have to check whether we are still
            // visible
            if (!Helper2.okToUse(fProposalShell))
                return;


            if (fAdditionalInfoController !is null) {
                fAdditionalInfoController.install(fProposalTable);
                fAdditionalInfoController.handleTableSelectionChanged();
            }
        }
    }

        /*
         * @see IContentAssistListener#verifyKey(VerifyEvent)
         */
        public bool verifyKey(VerifyEvent e) {
            if (!Helper2.okToUse(fProposalShell))
                return true;

            char key= e.character;
            if (key is 0) {
                int newSelection= fProposalTable.getSelectionIndex();
                int visibleRows= (fProposalTable.getSize().y / fProposalTable.getItemHeight()) - 1;
                bool smartToggle= false;
                switch (e.keyCode) {

                    case DWT.ARROW_LEFT :
                    case DWT.ARROW_RIGHT :
                        filterProposals();
                        return true;

                    case DWT.ARROW_UP :
                        newSelection -= 1;
                        if (newSelection < 0)
                            newSelection= fProposalTable.getItemCount() - 1;
                        break;

                    case DWT.ARROW_DOWN :
                        newSelection += 1;
                        if (newSelection > fProposalTable.getItemCount() - 1)
                            newSelection= 0;
                        break;

                    case DWT.PAGE_DOWN :
                        newSelection += visibleRows;
                        if (newSelection >= fProposalTable.getItemCount())
                            newSelection= fProposalTable.getItemCount() - 1;
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
                        newSelection= fProposalTable.getItemCount() - 1;
                        break;

                    default :
                        if (e.keyCode !is DWT.MOD1 && e.keyCode !is DWT.MOD2 && e.keyCode !is DWT.MOD3 && e.keyCode !is DWT.MOD4)
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
                    if ((e.stateMask & DWT.CTRL) is 0) {
                        e.doit= false;
                        selectProposalWithMask(e.stateMask);
                    }
                    break;

                    // in linked mode: hide popup
                    // plus: don't invalidate the event in order to give LinkedUI a chance to handle it
                case '\t':
//                  hide();
                    break;

                default:
                    ICompletionProposal p= getSelectedProposal();
                if ( cast(ICompletionProposalExtension)p ) {
                    ICompletionProposalExtension t= cast(ICompletionProposalExtension) p;
                    char[] triggers= t.getTriggerCharacters();
                    if (contains(triggers, key)) {
                        hide();
                        if (key is ';') {
                            e.doit= true;
                            insertProposal(p, cast(wchar) 0, e.stateMask, fViewer.getSelectedRange().x);
                        } else {
                            e.doit= false;
                            insertProposal(p, key, e.stateMask, fViewer.getSelectedRange().x);
                        }
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
     * @param smartToggle <code>true</code> if the smart toogle key has been pressed
     * @since 2.1
     */
    private void selectProposal(int index, bool smartToggle) {

        ICompletionProposal oldProposal= getSelectedProposal();
        if ( cast(ICompletionProposalExtension2)oldProposal )
            (cast(ICompletionProposalExtension2) oldProposal).unselected(fViewer);

        ICompletionProposal proposal= fFilteredProposals[index];
        if ( cast(ICompletionProposalExtension2)proposal )
            (cast(ICompletionProposalExtension2) proposal).selected(fViewer, smartToggle);

        fLastProposal= proposal;

        fProposalTable.setSelection(index);
        fProposalTable.showSelection();
        if (fAdditionalInfoController !is null)
            fAdditionalInfoController.handleTableSelectionChanged();
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
        ++ fInvocationCounter;
        Control control= fViewer.getTextWidget();
        control.getDisplay().asyncExec(dgRunnable( (long fInvocationCounter_) {
            long fCounter= fInvocationCounter_;

            if (fCounter !is fInvocationCounter) return;

            int offset= fViewer.getSelectedRange().x;
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
                setProposals(proposals);
            else
                hide();
        }, fInvocationCounter));
    }

    /**
     * Computes the subset of already computed propsals that are still valid for
     * the given offset.
     *
     * @param offset the offset
     * @param event the merged document event
     * @return the set of filtered proposals
     * @since 2.0
     */
    private ICompletionProposal[] computeFilteredProposals(int offset, DocumentEvent event) {

        if (offset is fInvocationOffset && event is null)
            return fComputedProposals;

        if (offset < fInvocationOffset) {
            return null;
        }

        ICompletionProposal[] proposals= fComputedProposals;
        if (offset > fFilterOffset)
            proposals= fFilteredProposals;

        if (proposals is null)
            return null;

        IDocument document= fViewer.getDocument();
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
                fInvocationOffset= offset;
                fComputedProposals= computeProposals(fInvocationOffset);
                return fComputedProposals;
            }
        }

        return arraycast!(ICompletionProposal)(filtered.toArray());
    }

    /**
     * Requests the proposal shell to take focus.
     *
     * @since 3.0
     */
    public void setFocus() {
        if (Helper2.okToUse(fProposalShell))
            fProposalShell.setFocus();
    }
}
