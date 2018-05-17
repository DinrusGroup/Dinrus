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
module dwtx.jface.text.contentassist.ICompletionProposalExtension;

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
import dwtx.jface.text.contentassist.CompletionProposalPopup; // packageimport
import dwtx.jface.text.contentassist.IContextInformation; // packageimport
import dwtx.jface.text.contentassist.IContentAssistantExtension3; // packageimport
import dwtx.jface.text.contentassist.ContentAssistant; // packageimport
import dwtx.jface.text.contentassist.IContentAssistantExtension; // packageimport
import dwtx.jface.text.contentassist.JFaceTextMessages; // packageimport


import dwt.dwthelper.utils;

import dwtx.jface.text.IDocument;


/**
 * Extends {@link dwtx.jface.text.contentassist.ICompletionProposal}
 * with the following functions:
 * <ul>
 *  <li>handling of trigger characters other than ENTER</li>
 *  <li>completion proposal validation for a given offset</li>
 *  <li>context information can be freely positioned</li>
 * </ul>
 *
 * @since 2.0
 */
public interface ICompletionProposalExtension {

    /**
     * Applies the proposed completion to the given document. The insertion
     * has been triggered by entering the given character at the given offset.
     * This method assumes that {@link #isValidFor(IDocument, int)} returns
     * <code>true</code> if called for <code>offset</code>.
     *
     * @param document the document into which to insert the proposed completion
     * @param trigger the trigger to apply the completion
     * @param offset the offset at which the trigger has been activated
     */
    void apply(IDocument document, char trigger, int offset);

    /**
     * Returns whether this completion proposal is valid for the given
     * position in the given document.
     *
     * @param document the document for which the proposal is tested
     * @param offset the offset for which the proposal is tested
     * @return <code>true</code> iff valid
     */
    bool isValidFor(IDocument document, int offset);

    /**
     * Returns the characters which trigger the application of this completion proposal.
     *
     * @return the completion characters for this completion proposal or <code>null</code>
     *      if no completion other than the new line character is possible
     */
    char[] getTriggerCharacters();

    /**
     * Returns the position to which the computed context information refers to or
     * <code>-1</code> if no context information can be provided by this completion proposal.
     *
     * @return the position to which the context information refers to or <code>-1</code> for no information
     */
    int getContextInformationPosition();
}
