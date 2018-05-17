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


module dwtx.jface.internal.text.link.contentassist.ContextInformationPopup2;

import dwtx.jface.internal.text.link.contentassist.IProposalListener; // packageimport
import dwtx.jface.internal.text.link.contentassist.LineBreakingReader; // packageimport
import dwtx.jface.internal.text.link.contentassist.CompletionProposalPopup2; // packageimport
import dwtx.jface.internal.text.link.contentassist.ContentAssistMessages; // packageimport
import dwtx.jface.internal.text.link.contentassist.Helper2; // packageimport
import dwtx.jface.internal.text.link.contentassist.PopupCloser2; // packageimport
import dwtx.jface.internal.text.link.contentassist.IContentAssistListener2; // packageimport
import dwtx.jface.internal.text.link.contentassist.ContentAssistant2; // packageimport
import dwtx.jface.internal.text.link.contentassist.AdditionalInfoController2; // packageimport

import dwt.dwthelper.utils;


import dwtx.dwtxhelper.Collection;

import dwt.DWT;
import dwt.custom.BusyIndicator;
import dwt.custom.StyledText;
import dwt.events.KeyEvent;
import dwt.events.SelectionEvent;
import dwt.events.SelectionListener;
import dwt.events.VerifyEvent;
import dwt.graphics.Color;
import dwt.graphics.Point;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.widgets.Control;
import dwt.widgets.Display;
import dwt.widgets.Shell;
import dwt.widgets.Table;
import dwt.widgets.TableItem;
import dwtx.jface.text.ITextViewer;
import dwtx.jface.text.TextPresentation;
import dwtx.jface.text.contentassist.IContextInformation;
import dwtx.jface.text.contentassist.IContextInformationExtension;
import dwtx.jface.text.contentassist.IContextInformationPresenter;
import dwtx.jface.text.contentassist.IContextInformationValidator;


/**
 * This class is used to present context information to the user.
 * If multiple contexts are valid at the current cursor location,
 * a list is presented from which the user may choose one context.
 * Once the user makes their choice, or if there was only a single
 * possible context, the context information is shown in a tooltip like popup. <p>
 * If the tooltip is visible and the user wants to see context information of
 * a context embedded into the one for which context information is displayed,
 * context information for the embedded context is shown. As soon as the
 * cursor leaves the embedded context area, the context information for
 * the embedding context is shown again.
 *
 * @see IContextInformation
 * @see IContextInformationValidator
 */
class ContextInformationPopup2 : IContentAssistListener2 {



    /**
     * Represents the state necessary for embedding contexts.
     * @since 2.0
     */
    static class ContextFrame {
        public int fBeginOffset;
        public int fOffset;
        public int fVisibleOffset;
        public IContextInformation fInformation;
        public IContextInformationValidator fValidator;
        public IContextInformationPresenter fPresenter;
    }

    private ITextViewer fViewer;
    private ContentAssistant2 fContentAssistant;

    private PopupCloser2 fPopupCloser;
    private Shell fContextSelectorShell;
    private Table fContextSelectorTable;
    private IContextInformation[] fContextSelectorInput;
    private String fLineDelimiter= null;

    private Shell fContextInfoPopup;
    private StyledText fContextInfoText;
    private TextPresentation fTextPresentation;

    private Stack fContextFrameStack;


    /**
     * Creates a new context information popup.
     *
     * @param contentAssistant the content assist for computing the context information
     * @param viewer the viewer on top of which the context information is shown
     */
    public this(ContentAssistant2 contentAssistant, ITextViewer viewer) {
        fPopupCloser= new PopupCloser2();
        fContextFrameStack= new Stack();
        fContentAssistant= contentAssistant;
        fViewer= viewer;
    }

    /**
     * Shows all possible contexts for the given cursor position of the viewer.
     *
     * @param autoActivated <code>true</code>  if auto activated
     * @return  a potential error message or <code>null</code> in case of no error
     */
    public String showContextProposals(bool autoActivated) {
        final StyledText styledText= fViewer.getTextWidget();
        BusyIndicator.showWhile(styledText.getDisplay(), dgRunnable( (bool autoActivated_, StyledText styledText_ ) {
            int position= fViewer.getSelectedRange().x;

            IContextInformation[] contexts= computeContextInformation(position);
            int count = (contexts is null ? 0 : contexts.length);
            if (count is 1) {

                // Show context information directly
                internalShowContextInfo(contexts[0], position);

            } else if (count > 0) {
                // Precise context must be selected

                if (fLineDelimiter is null)
                    fLineDelimiter= styledText_.getLineDelimiter();

                createContextSelector();
                setContexts(contexts);
                displayContextSelector();
                hideContextInfoPopup();

            } else if (!autoActivated_) {
                styledText_.getDisplay().beep();
            }
        }, autoActivated, styledText ));

        return getErrorMessage();
    }

    /**
     * Displays the given context information for the given offset.
     *
     * @param info the context information
     * @param position the offset
     * @since 2.0
     */
    public void showContextInformation(IContextInformation info, int position) {
        Control control= fViewer.getTextWidget();
        BusyIndicator.showWhile(control.getDisplay(), dgRunnable( (IContextInformation info_, int position_) {
            internalShowContextInfo(info_, position_);
            hideContextSelector();
        }, info, position));
    }

    /**
     * Displays the given context information for the given offset.
     *
     * @param information the context information
     * @param offset the offset
     * @since 2.0
     */

    private void internalShowContextInfo(IContextInformation information, int offset) {

        IContextInformationValidator validator= fContentAssistant.getContextInformationValidator(fViewer, offset);

        if (validator !is null) {
            ContextFrame current= new ContextFrame();
            current.fInformation= information;
            current.fBeginOffset= ( cast(IContextInformationExtension)information ) ? (cast(IContextInformationExtension) information).getContextInformationPosition() : offset;
            if (current.fBeginOffset is -1) current.fBeginOffset= offset;
            current.fOffset= offset;
            current.fVisibleOffset= fViewer.getTextWidget().getSelectionRange().x - (offset - current.fBeginOffset);
            current.fValidator= validator;
            current.fPresenter= fContentAssistant.getContextInformationPresenter(fViewer, offset);

            fContextFrameStack.push(current);

            internalShowContextFrame(current, fContextFrameStack.size() is 1);
        }
    }

    /**
     * Shows the given context frame.
     *
     * @param frame the frane to display
     * @param initial <code>true</code> if this is the first frame to be displayed
     * @since 2.0
     */
    private void internalShowContextFrame(ContextFrame frame, bool initial) {

        frame.fValidator.install(frame.fInformation, fViewer, frame.fOffset);

        if (frame.fPresenter !is null) {
            if (fTextPresentation is null)
                fTextPresentation= new TextPresentation();
            frame.fPresenter.install(frame.fInformation, fViewer, frame.fBeginOffset);
            frame.fPresenter.updatePresentation(frame.fOffset, fTextPresentation);
        }

        createContextInfoPopup();

        fContextInfoText.setText(frame.fInformation.getInformationDisplayString());
        if (fTextPresentation !is null)
            TextPresentation.applyTextPresentation(fTextPresentation, fContextInfoText);
        resize();

        if (initial) {
            if (fContentAssistant.addContentAssistListener(this, ContentAssistant2.CONTEXT_INFO_POPUP)) {
                fContentAssistant.addToLayout(this, fContextInfoPopup, ContentAssistant2.LayoutManager.LAYOUT_CONTEXT_INFO_POPUP, frame.fVisibleOffset);
                fContextInfoPopup.setVisible(true);
            }
        } else {
            fContentAssistant.layout(ContentAssistant2.LayoutManager.LAYOUT_CONTEXT_INFO_POPUP, frame.fVisibleOffset);
        }
    }

    /**
     * Computes all possible context information for the given offset.
     *
     * @param position the offset
     * @return all possible context information for the given offset
     * @since 2.0
     */
    private IContextInformation[] computeContextInformation(int position) {
        return fContentAssistant.computeContextInformation(fViewer, position);
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
     * Creates the context information popup. This is the tooltip like overlay window.
     */
    private void createContextInfoPopup() {
        if (Helper2.okToUse(fContextInfoPopup))
            return;

        Control control= fViewer.getTextWidget();
        Display display= control.getDisplay();

        fContextInfoPopup= new Shell(control.getShell(), DWT.NO_TRIM | DWT.ON_TOP);
        fContextInfoPopup.setBackground(display.getSystemColor(DWT.COLOR_BLACK));

        fContextInfoText= new StyledText(fContextInfoPopup, DWT.MULTI | DWT.READ_ONLY);

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
     * @since 2.0
     */
    private void resize() {
        Point size= fContextInfoText.computeSize(DWT.DEFAULT, DWT.DEFAULT, true);
        size.x += 3;
        fContextInfoText.setSize(size);
        fContextInfoText.setLocation(1,1);
        size.x += 2;
        size.y += 2;
        fContextInfoPopup.setSize(size);
    }

    /**
     *Hides the context information popup.
     */
    private void hideContextInfoPopup() {

        if (Helper2.okToUse(fContextInfoPopup)) {

            int size= fContextFrameStack.size();
            if (size > 0) {
                fContextFrameStack.pop();
                -- size;
            }

            if (size > 0) {
                ContextFrame current= cast(ContextFrame) fContextFrameStack.peek();
                internalShowContextFrame(current, false);
            } else {

                fContentAssistant.removeContentAssistListener(this, ContentAssistant2.CONTEXT_INFO_POPUP);

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
        if (Helper2.okToUse(fContextSelectorShell))
            return;

        Control control= fViewer.getTextWidget();
        fContextSelectorShell= new Shell(control.getShell(), DWT.NO_TRIM | DWT.ON_TOP);
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
        fContentAssistant.addToLayout(this, fContextSelectorShell, ContentAssistant2.LayoutManager.LAYOUT_CONTEXT_SELECTOR, fContentAssistant.getSelectionOffset());
    }

    /**
     * Causes the context information of the context selected in the context selector
     * to be displayed in the context information popup.
     */
    private void insertSelectedContext() {
        int i= fContextSelectorTable.getSelectionIndex();

        if (i < 0 || i >= fContextSelectorInput.length)
            return;

        int position= fViewer.getSelectedRange().x;
        internalShowContextInfo(fContextSelectorInput[i], position);
    }

    /**
     * Sets the contexts in the context selector to the given set.
     *
     * @param contexts the possible contexts
     */
    private void setContexts(IContextInformation[] contexts) {
        if (Helper2.okToUse(fContextSelectorTable)) {

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
        if (fContentAssistant.addContentAssistListener(this, ContentAssistant2.CONTEXT_SELECTOR))
            fContextSelectorShell.setVisible(true);
    }

    /**
     * Hodes the context selector.
     */
    private void hideContextSelector() {
        if (Helper2.okToUse(fContextSelectorShell)) {
            fContentAssistant.removeContentAssistListener(this, ContentAssistant2.CONTEXT_SELECTOR);

            fPopupCloser.uninstall();
            fContextSelectorShell.setVisible(false);
            fContextSelectorShell.dispose();
            fContextSelectorShell= null;
        }

        if (!Helper2.okToUse(fContextInfoPopup))
            fContentAssistant.contextInformationClosed_package();
    }

    /**
     *Returns whether the context selector has the focus.
     *
     * @return <code>true</code> if teh context selector has the focus
     */
    public bool hasFocus() {
        if (Helper2.okToUse(fContextSelectorShell))
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
        return (Helper2.okToUse(fContextInfoPopup) || Helper2.okToUse(fContextSelectorShell));
    }

    /*
     * @see IContentAssistListener#verifyKey(VerifyEvent)
     */
    public bool verifyKey(VerifyEvent e) {
        if (Helper2.okToUse(fContextSelectorShell))
            return contextSelectorKeyPressed(e);
        if (Helper2.okToUse(fContextInfoPopup))
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

            int change;
            int visibleRows= (fContextSelectorTable.getSize().y / fContextSelectorTable.getItemHeight()) - 1;
            int selection= fContextSelectorTable.getSelectionIndex();

            switch (e.keyCode) {

                case DWT.ARROW_UP:
                    change= (fContextSelectorTable.getSelectionIndex() > 0 ? -1 : 0);
                    break;

                case DWT.ARROW_DOWN:
                    change= (fContextSelectorTable.getSelectionIndex() < fContextSelectorTable.getItemCount() - 1 ? 1 : 0);
                    break;

                case DWT.PAGE_DOWN :
                    change= visibleRows;
                    if (selection + change >= fContextSelectorTable.getItemCount())
                        change= fContextSelectorTable.getItemCount() - selection;
                    break;

                case DWT.PAGE_UP :
                    change= -visibleRows;
                    if (selection + change < 0)
                        change= -selection;
                    break;

                case DWT.HOME :
                    change= -selection;
                    break;

                case DWT.END :
                    change= fContextSelectorTable.getItemCount() - selection;
                    break;

                default:
                    if (e.keyCode !is DWT.MOD1 && e.keyCode !is DWT.MOD2 && e.keyCode !is DWT.MOD3 && e.keyCode !is DWT.MOD4)
                        hideContextSelector();
                    return true;
            }

            fContextSelectorTable.setSelection(selection + change);
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
                    if (e.keyCode !is DWT.MOD1 && e.keyCode !is DWT.MOD2 && e.keyCode !is DWT.MOD3 && e.keyCode !is DWT.MOD4)
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
        if (Helper2.okToUse(fContextSelectorShell))
            contextSelectorProcessEvent(event);
        if (Helper2.okToUse(fContextInfoPopup))
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
         * action described by this verify key event has already beed executed.
         * Otherwise, we'd validate the context information based on the
         * pre-key-stroke state.
         */
        fContextInfoPopup.getDisplay().asyncExec(dgRunnable( (ContextFrame fFrame_) {

            ContextFrame fFrame= fFrame_;

            if (Helper2.okToUse(fContextInfoPopup) && fFrame is fContextFrameStack.peek()) {
                int offset= fViewer.getSelectedRange().x;
                if (fFrame.fValidator is null || !fFrame.fValidator.isContextInformationValid(offset)) {
                    hideContextInfoPopup();
                } else if (fFrame.fPresenter !is null && fFrame.fPresenter.updatePresentation(offset, fTextPresentation)) {
                    TextPresentation.applyTextPresentation(fTextPresentation, fContextInfoText);
                    resize();
                }
            }
        }, cast(ContextFrame) fContextFrameStack.peek()));
    }
}
