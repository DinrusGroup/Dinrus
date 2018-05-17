/*******************************************************************************
 * Copyright (c) 2007 IBM Corporation and others.
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
module dwtx.jface.text.contentassist.IContentAssistantExtension4;

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

import dwtx.core.commands.IHandler;


/**
 * Extends {@link dwtx.jface.text.contentassist.IContentAssistant} with
 * the following function:
 * <ul>
 * <li>allows to get a handler for the given command identifier</li>
 * </ul>
 * 
 * @since 3.4
 */
public interface IContentAssistantExtension4 {

    /**
     * Returns the handler for the given command identifier.
     * <p>
     * The same handler instance will be returned when called a more than once
     * with the same command identifier.
     * </p>
     * 
     * @param commandId the command identifier
     * @return the handler for the given command identifier
     * @throws IllegalArgumentException if the command is not supported by this
     *             content assistant
     * @throws IllegalStateException if called when this content assistant is
     *             uninstalled
     */
    IHandler getHandler(String commandId);

}
