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
module dwtx.jface.text.contentassist.ContextInformationPopup;

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
import dwtx.jface.text.contentassist.IContextInformationExtension; // packageimport
import dwtx.jface.text.contentassist.IContentAssistantExtension2; // packageimport
import dwtx.jface.text.contentassist.ContentAssistSubjectControlAdapter; // packageimport
import dwtx.jface.text.contentassist.CompletionProposalPopup; // packageimport
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
import dwt.custom.StyledText;
import dwt.events.KeyEvent;
import dwt.events.SelectionAdapter;
import dwt.events.SelectionEvent;
import dwt.events.SelectionListener;
import dwt.events.VerifyEvent;
import dwt.graphics.Color;
import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.widgets.Control;
import dwt.widgets.Display;
import dwt.widgets.Shell;
import dwt.widgets.Table;
import dwt.widgets.TableItem;
import dwtx.jface.contentassist.IContentAssistSubjectControl;
import dwtx.jface.text.ITextViewer;
import dwtx.jface.text.TextPresentation;

    /**
     * Represents the state necessary for embedding contexts.
     *
     * @since 2.0
     */
    static class ContextFrame {

        final int fBeginOffset;
        final int fOffset;
        final int fVisibleOffset;
        final IContextInformation fInformation;
        final IContextInformationValidator fValidator;
        final IContextInformationPresenter fPresenter;

        /*
         * @since 3.1
         */
        public this(IContextInformation information, int beginOffset, int offset, int visibleOffset, IContextInformationValidator validator, IContextInformationPresenter presenter) {
            fInformation = information;
            fBeginOffset = beginOffset;
            fOffset = offset;
            fVisibleOffset = visibleOffset;
            fValidator = validator;
            fPresenter = presenter;
        }

        /*
         * @see java.lang.Object#equals(java.lang.Object)
         * @since 3.0
         */
        public override int opEquals(Object obj) {
            if ( cast(ContextFrame)obj ) {
                ContextFrame frame= cast(ContextFrame) obj;
                return fInformation==/++/frame.fInformation && fBeginOffset is frame.fBeginOffset;
            }
            return super.opEquals(obj);
        }

        /*
         * @see java.lang.Object#hashCode()
         * @since 3.1
         */
        public override hash_t toHash() {
            return ((cast(Object)fInformation).toHash() << 16) | fBeginOffset;
        }
    }

    alias ContextFrame ContextInformationPopup_ContextFrame;
/**
 * This class is used to present context information to the user.
 * If multiple contexts are valid at the current cursor location,
 * a list is presented from which the user may choose one context.
 * Once the user makes their choice, or if there was only a single
 * possible context, the context information is shown in a tool tip like popup. <p>
 * If the tool tip is visible and the user wants to see context information of
 * a context embedded into the one for which context information is displayed,
 * context information for the embedded context is shown. As soon as the
 * cursor leaves the embedded context area, the context information for
 * the embedding context is shown again.
 *
 * @see IContextInformation
 * @see IContextInformationValidator
 */
class ContextInformationPopup : IContentAssistListener {



    private ITextViewer fViewer;
    private ContentAssistant fContentAssistant;

    private PopupCloser fPopupCloser;
    private Shell fContextSelectorShell;
    private Table fContextSelectorTable;
    private IContextInformation[] fContextSelectorInput;
    private String fLineDelimiter= null;

    private Shell fContextInfoPopup;
    private StyledText fContextInfoText;
    private TextPresentation fTextPresentation;

    private Stack fContextFrameStack;
    /**
     * The content assist subject control.
     *
     * @since 3.0
     */
    private IContentAssistSubjectControl fContentAssistSubjectControl;
    /**
     * The content assist subject control adapter.
     *
     * @since 3.0
     */
    private ContentAssistSubjectControlAdapter fContentAssistSubjectControlAdapter;

    /**
     * Selection listener on the text widget which is active
     * while a context information pop up is shown.
     *
     * @since 3.0
     */
    private SelectionListener fTextWidgetSelectionListener;

    /**
     * The last removed context frame is remembered in order to not re-query the
     * user about which context should be used.
     *
     * @since 3.0
     */
    private ContextFrame fLastContext= null;

    /**
     * Creates a new context information popup.
     *
     * @param contentAssistant the content assist for computing the context information
     * @param viewer the viewer on top of which the context information is shown
     */
    public this(ContentAssistant contentAssistant, ITextViewer viewer) {
        fPopupCloser= new PopupCloser();
        fContextFrameStack= new Stack();

        fContentAssistant= contentAssistant;
        fViewer= viewer;
        fContentAssistSubjectControlAdapter= new ContentAssistSubjectControlAdapter(fViewer);
    }

    /**
     * Creates a new context information popup.
     *
     * @param contentAssistant the content assist for computing the context information
     * @param contentAssistSubjectControl the content assist subject control on top of which the context information is shown
     * @since 3.0
     */
    public this(ContentAssistant contentAssistant, IContentAssistSubjectControl contentAssistSubjectControl) {
        fPopupCloser= new PopupCloser();
        fContextFrameStack= new Stack();

        fContentAssistant= contentAssistant;
        fContentAssistSubjectControl= contentAssistSubjectControl;
        fContentAssistSubjectControlAdapter= new ContentAssistSubjectControlAdapter(fContentAssistSubjectControl);
    }

    /**
     * Shows all possible contexts for the given cursor position of the viewer.
     *
     * @param autoActivated <code>true</code>  if auto activated
     * @return  a potential error message or <code>null</code> in case of no error
     */
    public String showContextProposals(bool autoActivated) {
        final Control control= fContentAssistSubjectControlAdapter.getControl();
        BusyIndicator.showWhile(control.getDisplay(), dgRunnable( {
            int offset= fContentAssistSubjectControlAdapter.getSelectedRange().x;

            IContextInformation[] contexts= computeContextInformation(offset);
            int count = (contexts is null ? 0 : contexts.length);
            if (count is 1) {

                ContextFrame frame= createContextFrame(contexts[0], offset);
                if (isDuplicate(frame))
                    validateContextInformation();
                else
                    // Show context information directly
                    internalShowContextInfo(frame);

            } else if (count > 0) {

                // if any of the proposed context matches any of the contexts on the stack,
                // assume that one (so, if context info is invoked repeatedly, the current
                // info is kept)
                for (int i= 0; i < contexts.length; i++) {
                    IContextInformation info= contexts[i];
                    ContextFrame frame= createContextFrame(info, offset);

                    // check top of stack and stored context
                    if (isDuplicate(frame)) {
                        validateContextInformation();
                        return;
                    }

                    if (isLastFrame(frame)) {
                        internalShowContextInfo(frame);
                        return;
                    }

                    // also check all other contexts
                    for (Iterator it= fContextFrameStack.iterator(); it.hasNext(); ) {
                        ContextFrame stackFrame= cast(ContextFrame) it.next();
                        if (stackFrame==/++/frame) {
                            validateContextInformation();
                            return;
                        }
                    }
                }

                // otherwise:
                // Precise context must be selected

                if (fLineDelimiter is null)
                    fLineDelimiter= fContentAssistSubjectControlAdapter.getLineDelimiter();

                createContextSelector();
                setContexts(contexts);
                displayContextSelector();
            }
        }));

        return getErrorMessage();
    }

    /**
     * Displays the given context information for the given offset.
     *
     * @param info the context information
     * @param offset the offset
     * @since 2.0
     */
    public void showContextInformation(IContextInformation info, int offset) {
        Control control= fContentAssistSubjectControlAdapter.getControl();
        BusyIndicator.showWhile(control.getDisplay(), dgRunnable( (IContextInformation info_, int offset_){
            if (info_ is null)
                validateContextInformation();
            else {
                ContextFrame frame= createContextFrame(info_, offset_);
                if (isDuplicate(frame))
                    validateContextInformation();
                else
                    internalShowContextInfo(frame);
                hideContextSelector();
            }
        }, info, offset ));
    }

    /**
     * Displays the given context information for the given offset.
     *
     * @param frame the context frame to display, or <code>null</code>
     * @since 3.0
     */
    private void internalShowContextInfo(ContextFrame frame) {
        if (frame !is null) {
            fContextFrameStack.push(frame);
            if (fContextFrameStack.size() is 1)
                fLastContext= null;
            internalShowContextFrame(frame, fContextFrameStack.size() is 1);
            validateContextInformation();
        }
    }

    /**
     * Creates a context frame for the given offset.
     *
     * @param information the context information
     * @param offset the offset
     * @return the created context frame
     * @since 3.0
     */
    private ContextFrame createContextFrame(IContextInformation information, int offset) {
        IContextInformationValidator validator= fContentAssistSubjectControlAdapter.getContextInformationValidator(fContentAssistant, offset);

        if (validator !is null) {
            int beginOffset= ( cast(IContextInformationExtension)information ) ? (cast(IContextInformationExtension) information).getContextInformationPosition() : offset;
            if (beginOffset is -1) beginOffset= offset;
            int visibleOffset= fContentAssistSubjectControlAdapter.getWidgetSelectionRange().x - (offset - beginOffset);
            IContextInformationPresenter presenter = fContentAssistSubjectControlAdapter.getContextInformationPresenter(fContentAssistant, offset);
            return new ContextFrame(information, beginOffset, offset, visibleOffset, validator, presenter);
        }

        return null;
    }

    /**
     * Compares <code>frame</code> with the top of the stack, returns <code>true</code>
     * if the frames are the same.
     *
     * @param frame the frame to check
     * @return <code>true</code> if <code>frame</code> matches the top of the stack
     * @since 3.0
     */
    private bool isDuplicate(ContextFrame frame) {
        if (frame is null)
            return false;
        if (fContextFrameStack.isEmpty())
            return false;
        // stack not empty
        ContextFrame top= cast(ContextFrame) fContextFrameStack.peek();
        return cast(bool) frame.opEquals(top);
    }

    /**
     * Compares <code>frame</code> with most recently removed context frame, returns <code>true</code>
     * if the frames are the same.
     *
     * @param frame the frame to check
     * @return <code>true</code> if <code>frame</code> matches the most recently removed
     * @since 3.0
     */
    private bool isLastFrame(ContextFrame frame) {
        return frame !is null && frame.opEquals(fLastContext);
    }

    /**
     * Shows the given context frame.
     *
     * @param frame the frame to display
     * @param initial <code>true</code> if this is the first frame to be displayed
     * @since 2.0
     */
    private void internalShowContextFrame(ContextFrame frame, bool initial) {

        fContentAssistSubjectControlAdapter.installValidator(frame);

        if (frame.fPresenter !is null) {
            if (fTextPresentation is null)
                fTextPresentation= new TextPresentation();
            fContentAssistSubjectControlAdapter.installContextInformationPresenter(frame);
            frame.fPresenter.updatePresentation(frame.fOffset, fTextPresentation);
        }

        createContextInfoPopup();

        fContextInfoText.setText(frame.fInformation.getInformationDisplayString());
        if (fTextPresentation !is null)
            TextPresentation.applyTextPresentation(fTextPresentation, fContextInfoText);
        resize(frame.fVisibleOffset);

        if (initial) {
            if (fContentAssistant.addContentAssistListener(this, ContentAssistant.CONTEXT_INFO_POPUP)) {
                if (fContentAssistSubjectControlAdapter.getControl() !is null) {
                    fTextWidgetSelectionListener= new class()  SelectionAdapter {
                        /*
                         * @see dwt.events.SelectionAdapter#widgetSelected(dwt.events.SelectionEvent)
                         */
                        public void widgetSelected(SelectionEvent e) {
                            validateContextInformation();
                        }};
                    fContentAssistSubjectControlAdapter.addSelectionListener(fTextWidgetSelectionListener);
                }
                fContentAssistant.addToLayout(this, fContextInfoPopup, ContentAssistant.LayoutManager.LAYOUT_CONTEXT_INFO_POPUP, frame.fVisibleOffset);
                fContextInfoPopup.setVisible(true);
            }
        } else {
            fContentAssistant.layout(ContentAssistant.LayoutManager.LAYOUT_CONTEXT_INFO_POPUP, frame.fVisibleOffset);
        }
    }

    /**
     * Computes all possible context information for the given offset.
     *
     * @param offset the offset
     * @return all possible context information for the given offset
     * @since 2.0
     */
    private IContextInformation[] computeContextInformation(int offset) {
        return fContentAssistSubjectControlAdapter.computeContextInformation(fContentAssistant, offset);
    }

    /**
     *Returns the error message generated while computing context information.
     *
     * @return the error message
     */
    private String getErrorMessage() {
        return fContentAssistant.getErrorMessage();
    }

    /**
     * Creates the context information popup. This is the tool tip like overlay window.
     */
    private void createContextInfoPopup() {
        if (Helper.okToUse(fContextInfoPopup))
            return;

        Control control= fContentAssistSubjectControlAdapter.getControl();
        Display display= control.getDisplay();

        fContextInfoPopup= new Shell(control.getShell(), DWT.NO_TRIM | DWT.ON_TOP);
        fContextInfoPopup.setBackground(display.getSystemColor(DWT.COLOR_BLACK));

        fContextInfoText= new StyledText(fContextInfoPopup, DWT.MULTI | DWT.READ_ONLY | DWT.WRAP);

        Color c= fContentAssistant.getContextInformationPopupBackground();
        if (c is null)
            c= display.getSystemColor(DWT.COLOR_INFO_BACKGROUND);
        fContextInfoText.setBackground(c);

        c= fContentAssistant.getContextInformationPopupForeground();
        if (c is null)
            c= display.getSystemColor(DWT.COLOR_INFO_FOREGROUND);
        fContextInfoText.setForeground(c);
    }

    /**
     * Resizes the context information popup.
     *
     * @param offset the caret offset in widget coordinates
     * @since 2.0
     */
    private void resize(int offset) {
        Point size= fContextInfoText.computeSize(DWT.DEFAULT, DWT.DEFAULT, true);
        final int TEXT_PAD= 0;
        final int BORDER_PAD= 2;
        final int PAD= TEXT_PAD + BORDER_PAD;
        size.x += PAD;
        Rectangle bounds= fContentAssistant.getLayoutManager().computeBoundsAboveBelow_package(fContextInfoPopup, size, offset);
        if (bounds.width < size.x)
            // we don't fit on the screen - try again and wrap
            size= fContextInfoText.computeSize(bounds.width - PAD, DWT.DEFAULT, true);

        size.x += TEXT_PAD;
        fContextInfoText.setSize(size);
        fContextInfoText.setLocation(1,1);
        size.x += BORDER_PAD;
        size.y += BORDER_PAD;
        fContextInfoPopup.setSize(size);
    }

    /**
     * Hides the context information popup.
     */
    private void hideContextInfoPopup() {

        if (Helper.okToUse(fContextInfoPopup)) {

            int size= fContextFrameStack.size();
            if (size > 0) {
                fLastContext= cast(ContextFrame) fContextFrameStack.pop();
                -- size;
            }

            if (size > 0) {
                ContextFrame current= cast(ContextFrame) fContextFrameStack.peek();
                internalShowContextFrame(current, false);
            } else {

                fContentAssistant.removeContentAssistListener(this, ContentAssistant.CONTEXT_INFO_POPUP);

                if (fContentAssistSubjectControlAdapter.getControl() !is null)
                    fContentAssistSubjectControlAdapter.removeSelectionListener(fTextWidgetSelectionListener);
                fTextWidgetSelectionListener= null;

                fContextInfoPopup.setVisible(false);
                fContextInfoPopup.dispose();
                fContextInfoPopup= null;

                if (fTextPresentation !is null) {
                    fTextPresentation.clear();
                    fTextPresentation= null;
                }
            }
        }

        if (fContextInfoPopup is null)
            fContentAssistant.contextInformationClosed_package();
    }

    /**
     * Creates the context selector in case the user has the choice between multiple valid contexts
     * at a given offset.
     */
    private void createContextSelector() {
        if (Helper.okToUse(fContextSelectorShell))
            return;

        Control control= fContentAssistSubjectControlAdapter.getControl();
        fContextSelectorShell= new Shell(control.getShell(), DWT.ON_TOP | DWT.RESIZE);
        GridLayout layout= new GridLayout();
        layout.marginWidth= 0;
        layout.marginHeight= 0;
        fContextSelectorShell.setLayout(layout);
        fContextSelectorShell.setBackground(control.getDisplay().getSystemColor(DWT.COLOR_BLACK));


        fContextSelectorTable= new Table(fContextSelectorShell, DWT.H_SCROLL | DWT.V_SCROLL);
        fContextSelectorTable.setLocation(1, 1);
        GridData gd= new GridData(GridData.FILL_BOTH);
        gd.heightHint= fContextSelectorTable.getItemHeight() * 10;
        gd.widthHint= 300;
        fContextSelectorTable.setLayoutData(gd);

        fContextSelectorShell.pack(true);

        Color c= fContentAssistant.getContextSelectorBackground();
        if (c is null)
            c= control.getDisplay().getSystemColor(DWT.COLOR_INFO_BACKGROUND);
        fContextSelectorTable.setBackground(c);

        c= fContentAssistant.getContextSelectorForeground();
        if (c is null)
            c= control.getDisplay().getSystemColor(DWT.COLOR_INFO_FOREGROUND);
        fContextSelectorTable.setForeground(c);

        fContextSelectorTable.addSelectionListener(new class()  SelectionListener {
            public void widgetSelected(SelectionEvent e) {
            }

            public void widgetDefaultSelected(SelectionEvent e) {
                insertSelectedContext();
                hideContextSelector();
            }
        });

        fPopupCloser.install(fContentAssistant, fContextSelectorTable);

        fContextSelectorTable.setHeaderVisible(false);
        fContentAssistant.addToLayout(this, fContextSelectorShell, ContentAssistant.LayoutManager.LAYOUT_CONTEXT_SELECTOR, fContentAssistant.getSelectionOffset());
    }

    /**
     * Returns the minimal required height for the popup, may return 0 if the popup has not been
     * created yet.
     *
     * @return the minimal height
     * @since 3.3
     */
    int getMinimalHeight() {
        int height= 0;
        if (Helper.okToUse(fContextSelectorTable)) {
            int items= fContextSelectorTable.getItemHeight() * 10;
            Rectangle trim= fContextSelectorTable.computeTrim(0, 0, DWT.DEFAULT, items);
            height= trim.height;
        }
        return height;
    }

    /**
     * Causes the context information of the context selected in the context selector
     * to be displayed in the context information popup.
     */
    private void insertSelectedContext() {
        int i= fContextSelectorTable.getSelectionIndex();

        if (i < 0 || i >= fContextSelectorInput.length)
            return;

        int offset= fContentAssistSubjectControlAdapter.getSelectedRange().x;
        internalShowContextInfo(createContextFrame(fContextSelectorInput[i], offset));
    }

    /**
     * Sets the contexts in the context selector to the given set.
     *
     * @param contexts the possible contexts
     */
    private void setContexts(IContextInformation[] contexts) {
        if (Helper.okToUse(fContextSelectorTable)) {

            fContextSelectorInput= contexts;

            fContextSelectorTable.setRedraw(false);
            fContextSelectorTable.removeAll();

            TableItem item;
            IContextInformation t;
            for (int i= 0; i < contexts.length; i++) {
                t= contexts[i];
                item= new TableItem(fContextSelectorTable, DWT.NULL);
                if (t.getImage() !is null)
                    item.setImage(t.getImage());
                item.setText(t.getContextDisplayString());
            }

            fContextSelectorTable.select(0);
            fContextSelectorTable.setRedraw(true);
        }
    }

    /**
     * Displays the context selector.
     */
    private void displayContextSelector() {
        if (fContentAssistant.addContentAssistListener(this, ContentAssistant.CONTEXT_SELECTOR))
            fContextSelectorShell.setVisible(true);
    }

    /**
     * Hides the context selector.
     */
    private void hideContextSelector() {
        if (Helper.okToUse(fContextSelectorShell)) {
            fContentAssistant.removeContentAssistListener(this, ContentAssistant.CONTEXT_SELECTOR);

            fPopupCloser.uninstall();
            fContextSelectorShell.setVisible(false);
            fContextSelectorShell.dispose();
            fContextSelectorShell= null;
        }

        if (!Helper.okToUse(fContextInfoPopup))
            fContentAssistant.contextInformationClosed_package();
    }

    /**
     *Returns whether the context selector has the focus.
     *
     * @return <code>true</code> if the context selector has the focus
     */
    public bool hasFocus() {
        if (Helper.okToUse(fContextSelectorShell))
            return (fContextSelectorShell.isFocusControl() || fContextSelectorTable.isFocusControl());

        return false;
    }

    /**
     * Hides context selector and context information popup.
     */
    public void hide() {
        hideContextSelector();
        hideContextInfoPopup();
    }

    /**
     * Returns whether this context information popup is active. I.e., either
     * a context selector or context information is displayed.
     *
     * @return <code>true</code> if the context selector is active
     */
    public bool isActive() {
        return (Helper.okToUse(fContextInfoPopup) || Helper.okToUse(fContextSelectorShell));
    }

    /*
     * @see IContentAssistListener#verifyKey(VerifyEvent)
     */
    public bool verifyKey(VerifyEvent e) {
        if (Helper.okToUse(fContextSelectorShell))
            return contextSelectorKeyPressed(e);
        if (Helper.okToUse(fContextInfoPopup))
            return contextInfoPopupKeyPressed(e);
        return true;
    }

    /**
     * Processes a key stroke in the context selector.
     *
     * @param e the verify event describing the key stroke
     * @return <code>true</code> if processing can be stopped
     */
    private bool contextSelectorKeyPressed(VerifyEvent e) {

        char key= e.character;
        if (key is 0) {

            int newSelection= fContextSelectorTable.getSelectionIndex();
            int visibleRows= (fContextSelectorTable.getSize().y / fContextSelectorTable.getItemHeight()) - 1;
            int itemCount= fContextSelectorTable.getItemCount();
            switch (e.keyCode) {
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
                        hideContextSelector();
                    return true;
            }

            fContextSelectorTable.setSelection(newSelection);
            fContextSelectorTable.showSelection();
            e.doit= false;
            return false;

        } else if ('\t' is key) {
            // switch focus to selector shell
            e.doit= false;
            fContextSelectorShell.setFocus();
            return false;
        } else if (key is DWT.ESC) {
            e.doit= false;
            hideContextSelector();
        }

        return true;
    }

    /**
     * Processes a key stroke while the info popup is up.
     *
     * @param e the verify event describing the key stroke
     * @return <code>true</code> if processing can be stopped
     */
    private bool contextInfoPopupKeyPressed(KeyEvent e) {

        char key= e.character;
        if (key is 0) {

            switch (e.keyCode) {
                case DWT.ARROW_LEFT:
                case DWT.ARROW_RIGHT:
                    validateContextInformation();
                    break;
                default:
                    if (e.keyCode !is DWT.CAPS_LOCK && e.keyCode !is DWT.MOD1 && e.keyCode !is DWT.MOD2 && e.keyCode !is DWT.MOD3 && e.keyCode !is DWT.MOD4)
                        hideContextInfoPopup();
                    break;
            }

        } else if (key is DWT.ESC) {
            e.doit= false;
            hideContextInfoPopup();
        } else {
            validateContextInformation();
        }
        return true;
    }

    /*
     * @see IEventConsumer#processEvent(VerifyEvent)
     */
    public void processEvent(VerifyEvent event) {
        if (Helper.okToUse(fContextSelectorShell))
            contextSelectorProcessEvent(event);
        if (Helper.okToUse(fContextInfoPopup))
            contextInfoPopupProcessEvent(event);
    }

    /**
     * Processes a key stroke in the context selector.
     *
     * @param e the verify event describing the key stroke
     */
    private void contextSelectorProcessEvent(VerifyEvent e) {

        if (e.start is e.end && e.text !is null && e.text.equals(fLineDelimiter)) {
            e.doit= false;
            insertSelectedContext();
        }

        hideContextSelector();
    }

    /**
     * Processes a key stroke while the info popup is up.
     *
     * @param e the verify event describing the key stroke
     */
    private void contextInfoPopupProcessEvent(VerifyEvent e) {
        if (e.start !is e.end && (e.text is null || e.text.length() is 0))
            validateContextInformation();
    }

    /**
     * Validates the context information for the viewer's actual cursor position.
     */
    private void validateContextInformation() {
        /*
         * Post the code in the event queue in order to ensure that the
         * action described by this verify key event has already been executed.
         * Otherwise, we'd validate the context information based on the
         * pre-key-stroke state.
         */
        if (!Helper.okToUse(fContextInfoPopup))
            return;

        fContextInfoPopup.getDisplay().asyncExec(new class()  Runnable {

            private ContextFrame fFrame;

            this() {
                fFrame= cast(ContextFrame) fContextFrameStack.peek();
            }

            public void run() {
                // only do this if no other frames have been added in between
                if (!fContextFrameStack.isEmpty() && fFrame is fContextFrameStack.peek()) {
                    int offset= fContentAssistSubjectControlAdapter.getSelectedRange().x;

                    // iterate all contexts on the stack
                    while (Helper.okToUse(fContextInfoPopup) && !fContextFrameStack.isEmpty()) {
                        ContextFrame top= cast(ContextFrame) fContextFrameStack.peek();
                        if (top.fValidator is null || !top.fValidator.isContextInformationValid(offset)) {
                            hideContextInfoPopup(); // loop variant: reduces the number of contexts on the stack
                        } else if (top.fPresenter !is null && top.fPresenter.updatePresentation(offset, fTextPresentation)) {
                            int widgetOffset= fContentAssistSubjectControlAdapter.getWidgetSelectionRange().x;
                            TextPresentation.applyTextPresentation(fTextPresentation, fContextInfoText);
                            resize(widgetOffset);
                            break;
                        } else
                            break;
                    }
                }
            }
        });
    }
}
