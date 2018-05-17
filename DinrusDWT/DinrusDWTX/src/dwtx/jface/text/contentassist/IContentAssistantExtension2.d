/*******************************************************************************
 * Copyright (c) 2006 IBM Corporation and others.
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
module dwtx.jface.text.contentassist.IContentAssistantExtension2;

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
import dwtx.jface.text.contentassist.ContentAssistSubjectControlAdapter; // packageimport
import dwtx.jface.text.contentassist.CompletionProposalPopup; // packageimport
import dwtx.jface.text.contentassist.ICompletionProposalExtension; // packageimport
import dwtx.jface.text.contentassist.IContextInformation; // packageimport
import dwtx.jface.text.contentassist.IContentAssistantExtension3; // packageimport
import dwtx.jface.text.contentassist.ContentAssistant; // packageimport
import dwtx.jface.text.contentassist.IContentAssistantExtension; // packageimport
import dwtx.jface.text.contentassist.JFaceTextMessages; // packageimport


import dwt.dwthelper.utils;

/**
 * Extends {@link dwtx.jface.text.contentassist.IContentAssistant} with the following
 * functions:
 * <ul>
 * <li>completion listeners</li>
 * <li>repeated invocation mode</li>
 * <li>a local status line for the completion popup</li>
 * <li>control over the behavior when no proposals are available</li>
 * </ul>
 * 
 * @since 3.2
 */
public interface IContentAssistantExtension2 {

    /**
     * Adds a completion listener that will be informed before proposals are computed.
     * 
     * @param listener the listener
     */
    public void addCompletionListener(ICompletionListener listener);

    /**
     * Removes a completion listener.
     * 
     * @param listener the listener to remove
     */
    public void removeCompletionListener(ICompletionListener listener);

    /**
     * Enables repeated invocation mode, which will trigger re-computation of the proposals when
     * code assist is executed repeatedly. The default is no <code>false</code>.
     * 
     * @param cycling <code>true</code> to enable repetition mode, <code>false</code> to disable
     */
    public void setRepeatedInvocationMode(bool cycling);

    /**
     * Enables displaying an empty completion proposal pop-up. The default is not to show an empty
     * list.
     * 
     * @param showEmpty <code>true</code> to show empty lists
     */
    public void setShowEmptyList(bool showEmpty);

    /**
     * Enables displaying a status line below the proposal popup. The default is not to show the
     * status line. The contents of the status line may be set via {@link #setStatusMessage(String)}.
     * 
     * @param show <code>true</code> to show a message line, <code>false</code> to not show one.
     */
    public void setStatusLineVisible(bool show);

    /**
     * Sets the caption message displayed at the bottom of the completion proposal popup.
     * 
     * @param message the message
     */
    public void setStatusMessage(String message);

    /**
     * Sets the text to be shown if no proposals are available and
     * {@link #setShowEmptyList(bool) empty lists} are displayed.
     * 
     * @param message the text for the empty list
     */
    public void setEmptyMessage(String message);
}
