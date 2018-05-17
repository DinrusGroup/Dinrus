/*******************************************************************************
 * Copyright (c) 2000, 2005 IBM Corporation and others.
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
module dwtx.jface.text.contentassist.ICompletionProposalExtension2;

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
import dwtx.jface.text.contentassist.CompletionProposalPopup; // packageimport
import dwtx.jface.text.contentassist.ICompletionProposalExtension; // packageimport
import dwtx.jface.text.contentassist.IContextInformation; // packageimport
import dwtx.jface.text.contentassist.IContentAssistantExtension3; // packageimport
import dwtx.jface.text.contentassist.ContentAssistant; // packageimport
import dwtx.jface.text.contentassist.IContentAssistantExtension; // packageimport
import dwtx.jface.text.contentassist.JFaceTextMessages; // packageimport


import dwt.dwthelper.utils;

import dwtx.jface.text.DocumentEvent;
import dwtx.jface.text.IDocument;
import dwtx.jface.text.ITextViewer;


/**
 * Extends {@link dwtx.jface.text.contentassist.ICompletionProposal}
 * with the following functions:
 * <ul>
 *  <li>handling of trigger characters with modifiers</li>
 *  <li>visual indication for selection of a proposal</li>
 * </ul>
 *
 * @since 2.1
 */
public interface ICompletionProposalExtension2 {

    /**
     * Applies the proposed completion to the given document. The insertion
     * has been triggered by entering the given character with a modifier at the given offset.
     * This method assumes that {@link #validate(IDocument, int, DocumentEvent)}
     * returns <code>true</code> if called for <code>offset</code>.
     *
     * @param viewer the text viewer into which to insert the proposed completion
     * @param trigger the trigger to apply the completion
     * @param stateMask the state mask of the modifiers
     * @param offset the offset at which the trigger has been activated
     */
    void apply(ITextViewer viewer, char trigger, int stateMask, int offset);

    /**
     * Called when the proposal is selected.
     *
     * @param viewer the text viewer.
     * @param smartToggle the smart toggle key was pressed
     */
    void selected(ITextViewer viewer, bool smartToggle);

    /**
     * Called when the proposal is unselected.
     *
     * @param viewer the text viewer.
     */
    void unselected(ITextViewer viewer);

    /**
     * Requests the proposal to be validated with respect to the document event.
     * If the proposal cannot be validated, the methods returns <code>false</code>.
     * If the document event was <code>null</code>, only the caret offset was changed, but not the document.
     *
     * This method replaces {@link ICompletionProposalExtension#isValidFor(IDocument, int)}
     *
     * @param document the document
     * @param offset the caret offset
     * @param event the document event, may be <code>null</code>
     * @return bool
     */
    bool validate(IDocument document, int offset, DocumentEvent event);

}
