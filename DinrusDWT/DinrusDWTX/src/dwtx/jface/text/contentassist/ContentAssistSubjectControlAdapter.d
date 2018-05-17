/*******************************************************************************
 * Copyright (c) 2000, 2006 IBM Corporation and others.
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
module dwtx.jface.text.contentassist.ContentAssistSubjectControlAdapter;

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
import dwtx.jface.text.contentassist.CompletionProposalPopup; // packageimport
import dwtx.jface.text.contentassist.ICompletionProposalExtension; // packageimport
import dwtx.jface.text.contentassist.IContextInformation; // packageimport
import dwtx.jface.text.contentassist.IContentAssistantExtension3; // packageimport
import dwtx.jface.text.contentassist.ContentAssistant; // packageimport
import dwtx.jface.text.contentassist.IContentAssistantExtension; // packageimport
import dwtx.jface.text.contentassist.JFaceTextMessages; // packageimport


import dwt.dwthelper.utils;





import dwt.custom.StyledText;
import dwt.custom.VerifyKeyListener;
import dwt.events.KeyListener;
import dwt.events.SelectionListener;
import dwt.graphics.Point;
import dwt.widgets.Control;
import dwtx.core.runtime.Assert;
import dwtx.jface.contentassist.IContentAssistSubjectControl;
import dwtx.jface.contentassist.ISubjectControlContextInformationPresenter;
import dwtx.jface.contentassist.ISubjectControlContextInformationValidator;
import dwtx.jface.text.IDocument;
import dwtx.jface.text.IEventConsumer;
import dwtx.jface.text.ITextViewer;
import dwtx.jface.text.ITextViewerExtension;
import dwtx.jface.text.contentassist.ContextInformationPopup;


/**
 * This content assist adapter delegates the calls either to
 * a text viewer or to a content assist subject control.
 *
 * @since 3.0
 */
final class ContentAssistSubjectControlAdapter : IContentAssistSubjectControl {

    /**
     * The text viewer which is used as content assist subject control.
     */
    private ITextViewer fViewer;

    /**
     * The content assist subject control.
     */
    private IContentAssistSubjectControl fContentAssistSubjectControl;


    /**
     * Creates an adapter for the given content assist subject control.
     *
     * @param contentAssistSubjectControl the content assist subject control
     */
    this(IContentAssistSubjectControl contentAssistSubjectControl) {
        Assert.isNotNull(cast(Object)contentAssistSubjectControl);
        fContentAssistSubjectControl= contentAssistSubjectControl;
    }

    /**
     * Creates an adapter for the given text viewer.
     *
     * @param viewer the text viewer
     */
    public this(ITextViewer viewer) {
        Assert.isNotNull(cast(Object)viewer);
        fViewer= viewer;
    }

    /*
     * @see IContentAssistSubjectControl#getLineHeight()
     */
    public int getLineHeight() {
        if (fContentAssistSubjectControl !is null)
            return fContentAssistSubjectControl.getLineHeight();

        return fViewer.getTextWidget().getLineHeight(getCaretOffset());
    }

    /*
     * @see IContentAssistSubjectControl#getControl()
     */
    public Control getControl() {
        if (fContentAssistSubjectControl !is null)
            return fContentAssistSubjectControl.getControl();
        return fViewer.getTextWidget();
    }

    /*
     * @see IContentAssistSubjectControl#getLocationAtOffset(int)
     */
    public Point getLocationAtOffset(int offset) {
        if (fContentAssistSubjectControl !is null)
            return fContentAssistSubjectControl.getLocationAtOffset(offset);
        return fViewer.getTextWidget().getLocationAtOffset(offset);
    }

    /*
     * @see IContentAssistSubjectControl#getWidgetSelectionRange()
     */
    public Point getWidgetSelectionRange() {
        if (fContentAssistSubjectControl !is null)
            return fContentAssistSubjectControl.getWidgetSelectionRange();
        return fViewer.getTextWidget().getSelectionRange();
    }

    /*
     * @see IContentAssistSubjectControl#getSelectedRange()
     */
    public Point getSelectedRange() {
        if (fContentAssistSubjectControl !is null)
            return fContentAssistSubjectControl.getSelectedRange();
        return fViewer.getSelectedRange();
    }

    /*
     * @see dwtx.jface.text.contentassist.IContentAssistSubjectControl#getCaretOffset()
     */
    public int getCaretOffset() {
        if (fContentAssistSubjectControl !is null)
            return fContentAssistSubjectControl.getCaretOffset();
        return fViewer.getTextWidget().getCaretOffset();
    }

    /*
     * @see dwtx.jface.text.contentassist.IContentAssistSubjectControl#getLineDelimiter()
     */
    public String getLineDelimiter() {
        if (fContentAssistSubjectControl !is null)
            return fContentAssistSubjectControl.getLineDelimiter();
        return fViewer.getTextWidget().getLineDelimiter();
    }

    /*
     * @see dwtx.jface.text.contentassist.IContentAssistSubjectControl#addKeyListener(dwt.events.KeyListener)
     */
    public void addKeyListener(KeyListener keyListener) {
        if (fContentAssistSubjectControl !is null)
            fContentAssistSubjectControl.addKeyListener(keyListener);
        else
            fViewer.getTextWidget().addKeyListener(keyListener);
    }

    /*
     * @see dwtx.jface.text.contentassist.IContentAssistSubjectControl#removeKeyListener(dwt.events.KeyListener)
     */
    public void removeKeyListener(KeyListener keyListener) {
        if (fContentAssistSubjectControl !is null)
            fContentAssistSubjectControl.removeKeyListener(keyListener);
        else
            fViewer.getTextWidget().removeKeyListener(keyListener);
    }

    /*
     * @see dwtx.jface.text.contentassist.IContentAssistSubjectControl#getDocument()
     */
    public IDocument getDocument() {
        if (fContentAssistSubjectControl !is null)
            return fContentAssistSubjectControl.getDocument();
        return fViewer.getDocument();
    }

    /*
     * @see dwtx.jface.text.contentassist.IContentAssistSubjectControl#prependVerifyKeyListener(VerifyKeyListener)
     */
    public bool prependVerifyKeyListener(VerifyKeyListener verifyKeyListener) {
        if (fContentAssistSubjectControl !is null) {
            return fContentAssistSubjectControl.prependVerifyKeyListener(verifyKeyListener);
        } else if ( cast(ITextViewerExtension)fViewer ) {
            ITextViewerExtension e= cast(ITextViewerExtension) fViewer;
            e.prependVerifyKeyListener(verifyKeyListener);
            return true;
        } else {

            StyledText textWidget= fViewer.getTextWidget();
            if (Helper.okToUse(textWidget)) {
                textWidget.addVerifyKeyListener(verifyKeyListener);
                return true;
            }
        }
        return false;
    }

    /*
     * @see dwtx.jface.text.contentassist.IContentAssistSubjectControl#appendVerifyKeyListener(dwt.custom.VerifyKeyListener)
     */
    public bool appendVerifyKeyListener(VerifyKeyListener verifyKeyListener) {
        if (fContentAssistSubjectControl !is null)
            return fContentAssistSubjectControl.appendVerifyKeyListener(verifyKeyListener);
        else if ( cast(ITextViewerExtension)fViewer ) {
            ITextViewerExtension extension= cast(ITextViewerExtension)fViewer;
            extension.appendVerifyKeyListener(verifyKeyListener);
            return true;
        } else {
            StyledText textWidget= fViewer.getTextWidget();
            if (Helper.okToUse(textWidget)) {
                textWidget.addVerifyKeyListener(verifyKeyListener);
                return true;
            }
        }
        return false;
    }

    /*
     * @see dwtx.jface.text.contentassist.IContentAssistSubjectControl#removeVerifyKeyListener(dwt.custom.VerifyKeyListener)
     */
    public void removeVerifyKeyListener(VerifyKeyListener verifyKeyListener) {
        if (fContentAssistSubjectControl !is null) {
            fContentAssistSubjectControl.removeVerifyKeyListener(verifyKeyListener);
        } else if ( cast(ITextViewerExtension)fViewer ) {
            ITextViewerExtension extension= cast(ITextViewerExtension) fViewer;
            extension.removeVerifyKeyListener(verifyKeyListener);
        } else {
            StyledText textWidget= fViewer.getTextWidget();
            if (Helper.okToUse(textWidget))
                textWidget.removeVerifyKeyListener(verifyKeyListener);
        }
    }

    /*
     * @see dwtx.jface.text.contentassist.IContentAssistSubjectControl#setEventConsumer(dwtx.jface.text.contentassist.ContentAssistant.InternalListener)
     */
    public void setEventConsumer(IEventConsumer eventConsumer) {
        if (fContentAssistSubjectControl !is null)
            fContentAssistSubjectControl.setEventConsumer(eventConsumer);
        else
            fViewer.setEventConsumer(eventConsumer);
    }

    /*
     * @see dwtx.jface.text.contentassist.IContentAssistSubjectControl#setSelectedRange(int, int)
     */
    public void setSelectedRange(int i, int j) {
        if (fContentAssistSubjectControl !is null)
            fContentAssistSubjectControl.setSelectedRange(i, j);
        else
            fViewer.setSelectedRange(i, j);
    }

    /*
     * @see dwtx.jface.text.contentassist.IContentAssistSubjectControl#revealRange(int, int)
     */
    public void revealRange(int i, int j) {
        if (fContentAssistSubjectControl !is null)
            fContentAssistSubjectControl.revealRange(i, j);
        else
            fViewer.revealRange(i, j);
    }

    /*
     * @see dwtx.jface.text.contentassist.IContentAssistSubjectControl#canAddVerifyKeyListener()
     */
    public bool supportsVerifyKeyListener() {
        if (fContentAssistSubjectControl !is null)
            return fContentAssistSubjectControl.supportsVerifyKeyListener();
        return true;
    }
    /**
     * Returns the characters which when typed by the user should automatically
     * initiate proposing completions. The position is used to determine the
     * appropriate content assist processor to invoke.
     *
     * @param contentAssistant the content assistant
     * @param offset a document offset
     * @return the auto activation characters
     * @see IContentAssistProcessor#getCompletionProposalAutoActivationCharacters()
     */
    public char[] getCompletionProposalAutoActivationCharacters(ContentAssistant contentAssistant, int offset) {
        if (fContentAssistSubjectControl !is null)
            return contentAssistant.getCompletionProposalAutoActivationCharacters(fContentAssistSubjectControl, offset);
        return contentAssistant.getCompletionProposalAutoActivationCharacters(fViewer, offset);
    }

    /**
     * Returns the characters which when typed by the user should automatically
     * initiate the presentation of context information. The position is used
     * to determine the appropriate content assist processor to invoke.
     *
     * @param contentAssistant the content assistant
     * @param offset a document offset
     * @return the auto activation characters
     *
     * @see IContentAssistProcessor#getContextInformationAutoActivationCharacters()
     */
    char[] getContextInformationAutoActivationCharacters(ContentAssistant contentAssistant, int offset) {
        if (fContentAssistSubjectControl !is null)
            return contentAssistant.getContextInformationAutoActivationCharacters(fContentAssistSubjectControl, offset);
        return contentAssistant.getContextInformationAutoActivationCharacters(fViewer, offset);
    }

    /**
    * Creates and returns a completion proposal popup for the given content assistant.
    *
    * @param contentAssistant the content assistant
    * @param controller the additional info controller
    * @return the completion proposal popup
    */
    CompletionProposalPopup createCompletionProposalPopup(ContentAssistant contentAssistant, AdditionalInfoController controller) {
        if (fContentAssistSubjectControl !is null)
            return new CompletionProposalPopup(contentAssistant, fContentAssistSubjectControl, controller);
        return new CompletionProposalPopup(contentAssistant, fViewer, controller);

    }

    /**
     * Creates and returns a context info popup for the given content assistant.
     *
     * @param contentAssistant the content assistant
     * @return the context info popup or <code>null</code>
     */
    ContextInformationPopup createContextInfoPopup(ContentAssistant contentAssistant) {
        if (fContentAssistSubjectControl !is null)
            return new ContextInformationPopup(contentAssistant, fContentAssistSubjectControl);
        return new ContextInformationPopup(contentAssistant, fViewer);

    }

    /**
     * Returns the context information validator that should be used to
     * determine when the currently displayed context information should
     * be dismissed. The position is used to determine the appropriate
     * content assist processor to invoke.
     *
     * @param contentAssistant the content assistant
     * @param offset a document offset
     * @return an validator
     */
    public IContextInformationValidator getContextInformationValidator(ContentAssistant contentAssistant, int offset) {
        if (fContentAssistSubjectControl !is null)
            return contentAssistant.getContextInformationValidator(fContentAssistSubjectControl, offset);
        return contentAssistant.getContextInformationValidator(fViewer, offset);
    }

    /**
     * Returns the context information presenter that should be used to
     * display context information. The position is used to determine the
     * appropriate content assist processor to invoke.
     *
     * @param contentAssistant the content assistant
     * @param offset a document offset
     * @return a presenter
     */
    public IContextInformationPresenter getContextInformationPresenter(ContentAssistant contentAssistant, int offset) {
        if (fContentAssistSubjectControl !is null)
            return contentAssistant.getContextInformationPresenter(fContentAssistSubjectControl, offset);
        return contentAssistant.getContextInformationPresenter(fViewer, offset);
    }

    /**
     * Installs this adapter's information validator on the given context frame.
     *
     * @param frame the context frame
     */
    public void installValidator(ContextInformationPopup_ContextFrame frame) {
        if (fContentAssistSubjectControl !is null) {
            if (cast(ISubjectControlContextInformationValidator)frame.fValidator )
                (cast(ISubjectControlContextInformationValidator)frame.fValidator).install(frame.fInformation, fContentAssistSubjectControl, frame.fOffset);
        } else
            frame.fValidator.install(frame.fInformation, fViewer, frame.fOffset);
    }

    /**
     * Installs this adapter's information presenter on the given context frame.
     *
     * @param frame the context frame
     */
    public void installContextInformationPresenter(ContextInformationPopup_ContextFrame frame) {
        if (fContentAssistSubjectControl !is null) {
            if (cast(ISubjectControlContextInformationPresenter)frame.fPresenter )
                (cast(ISubjectControlContextInformationPresenter)frame.fValidator).install(frame.fInformation, fContentAssistSubjectControl, frame.fBeginOffset);
        } else
            frame.fPresenter.install(frame.fInformation, fViewer, frame.fBeginOffset);
    }

    /**
     * Returns an array of context information objects computed based
     * on the specified document position. The position is used to determine
     * the appropriate content assist processor to invoke.
     *
     * @param contentAssistant the content assistant
     * @param offset a document offset
     * @return an array of context information objects
     * @see IContentAssistProcessor#computeContextInformation(ITextViewer, int)
     */
    public IContextInformation[] computeContextInformation(ContentAssistant contentAssistant, int offset) {
        if (fContentAssistSubjectControl !is null)
            return contentAssistant.computeContextInformation(fContentAssistSubjectControl, offset);
        return contentAssistant.computeContextInformation(fViewer, offset);
    }

    /*
     * @see IContentAssistSubjectControl#addSelectionListener(SelectionListener)
     */
    public bool addSelectionListener(SelectionListener selectionListener) {
        if (fContentAssistSubjectControl !is null)
            return fContentAssistSubjectControl.addSelectionListener(selectionListener);
        fViewer.getTextWidget().addSelectionListener(selectionListener);
        return true;
    }

    /*
     * @see IContentAssistSubjectControl#removeSelectionListener(SelectionListener)
     */
    public void removeSelectionListener(SelectionListener selectionListener) {
        if (fContentAssistSubjectControl !is null)
            fContentAssistSubjectControl.removeSelectionListener(selectionListener);
        else
            fViewer.getTextWidget().removeSelectionListener(selectionListener);
    }
}
