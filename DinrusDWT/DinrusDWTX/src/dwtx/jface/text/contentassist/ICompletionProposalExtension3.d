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
module dwtx.jface.text.contentassist.ICompletionProposalExtension3;

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

import dwtx.jface.text.IDocument;
import dwtx.jface.text.IInformationControlCreator;


/**
 * Extends {@link dwtx.jface.text.contentassist.ICompletionProposal}
 * with the following functions:
 * <ul>
 *  <li>provision of a custom information control creator</li>
 *  <li>provide a custom completion text and offset for prefix completion</li>
 * </ul>
 *
 * @since 3.0
 */
public interface ICompletionProposalExtension3 {
    /**
     * Returns the information control creator of this completion proposal.
     *
     * @return the information control creator, or <code>null</code> if no custom control creator is available
     */
    IInformationControlCreator getInformationControlCreator();

    /**
     * Returns the string that would be inserted at the position returned from
     * {@link #getPrefixCompletionStart(IDocument, int)} if this proposal was
     * applied. If the replacement string cannot be determined,
     * <code>null</code> may be returned.
     *
     * @param document the document that the receiver applies to
     * @param completionOffset the offset into <code>document</code> where the
     *        completion takes place
     * @return the replacement string or <code>null</code> if it cannot be
     *         determined
     */
    CharSequence getPrefixCompletionText(IDocument document, int completionOffset);

    /**
     * Returns the document offset at which the receiver would insert its
     * proposal.
     *
     * @param document the document that the receiver applies to
     * @param completionOffset the offset into <code>document</code> where the
     *        completion takes place
     * @return the offset at which the proposal would insert its proposal
     */
    int getPrefixCompletionStart(IDocument document, int completionOffset);

}
