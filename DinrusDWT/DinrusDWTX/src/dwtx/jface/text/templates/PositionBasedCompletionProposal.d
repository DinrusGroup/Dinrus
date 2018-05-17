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


module dwtx.jface.text.templates.PositionBasedCompletionProposal;

import dwtx.jface.text.templates.SimpleTemplateVariableResolver; // packageimport
import dwtx.jface.text.templates.TemplateBuffer; // packageimport
import dwtx.jface.text.templates.TemplateContext; // packageimport
import dwtx.jface.text.templates.TemplateContextType; // packageimport
import dwtx.jface.text.templates.Template; // packageimport
import dwtx.jface.text.templates.TemplateVariable; // packageimport
import dwtx.jface.text.templates.TemplateException; // packageimport
import dwtx.jface.text.templates.TemplateTranslator; // packageimport
import dwtx.jface.text.templates.DocumentTemplateContext; // packageimport
import dwtx.jface.text.templates.GlobalTemplateVariables; // packageimport
import dwtx.jface.text.templates.InclusivePositionUpdater; // packageimport
import dwtx.jface.text.templates.TemplateProposal; // packageimport
import dwtx.jface.text.templates.ContextTypeRegistry; // packageimport
import dwtx.jface.text.templates.JFaceTextTemplateMessages; // packageimport
import dwtx.jface.text.templates.TemplateCompletionProcessor; // packageimport
import dwtx.jface.text.templates.TextTemplateMessages; // packageimport
import dwtx.jface.text.templates.TemplateVariableType; // packageimport
import dwtx.jface.text.templates.TemplateVariableResolver; // packageimport

import dwt.dwthelper.utils;





import dwt.graphics.Image;
import dwt.graphics.Point;
import dwtx.core.runtime.Assert;
import dwtx.jface.text.BadLocationException;
import dwtx.jface.text.DocumentEvent;
import dwtx.jface.text.IDocument;
import dwtx.jface.text.ITextViewer;
import dwtx.jface.text.Position;
import dwtx.jface.text.contentassist.ICompletionProposal;
import dwtx.jface.text.contentassist.ICompletionProposalExtension2;
import dwtx.jface.text.contentassist.IContextInformation;


/**
 * A position based completion proposal.
 * 
 * @since 3.0
 */
final class PositionBasedCompletionProposal : ICompletionProposal, ICompletionProposalExtension2 {

    /** The string to be displayed in the completion proposal popup */
    private String fDisplayString;
    /** The replacement string */
    private String fReplacementString;
    /** The replacement position. */
    private Position fReplacementPosition;
    /** The cursor position after this proposal has been applied */
    private int fCursorPosition;
    /** The image to be displayed in the completion proposal popup */
    private Image fImage;
    /** The context information of this proposal */
    private IContextInformation fContextInformation;
    /** The additional info of this proposal */
    private String fAdditionalProposalInfo;

    /**
     * Creates a new completion proposal based on the provided information.  The replacement string is
     * considered being the display string too. All remaining fields are set to <code>null</code>.
     *
     * @param replacementString the actual string to be inserted into the document
     * @param replacementPosition the position of the text to be replaced
     * @param cursorPosition the position of the cursor following the insert relative to replacementOffset
     */
    public this(String replacementString, Position replacementPosition, int cursorPosition) {
        this(replacementString, replacementPosition, cursorPosition, null, null, null, null);
    }

    /**
     * Creates a new completion proposal. All fields are initialized based on the provided information.
     *
     * @param replacementString the actual string to be inserted into the document
     * @param replacementPosition the position of the text to be replaced
     * @param cursorPosition the position of the cursor following the insert relative to replacementOffset
     * @param image the image to display for this proposal
     * @param displayString the string to be displayed for the proposal
     * @param contextInformation the context information associated with this proposal
     * @param additionalProposalInfo the additional information associated with this proposal
     */
    public this(String replacementString, Position replacementPosition, int cursorPosition, Image image, String displayString, IContextInformation contextInformation, String additionalProposalInfo) {
        Assert.isNotNull(replacementString);
        Assert.isTrue(replacementPosition !is null);

        fReplacementString= replacementString;
        fReplacementPosition= replacementPosition;
        fCursorPosition= cursorPosition;
        fImage= image;
        fDisplayString= displayString;
        fContextInformation= contextInformation;
        fAdditionalProposalInfo= additionalProposalInfo;
    }

    /*
     * @see ICompletionProposal#apply(IDocument)
     */
    public void apply(IDocument document) {
        try {
            document.replace(fReplacementPosition.getOffset(), fReplacementPosition.getLength(), fReplacementString);
        } catch (BadLocationException x) {
            // ignore
        }
    }

    /*
     * @see ICompletionProposal#getSelection(IDocument)
     */
    public Point getSelection(IDocument document) {
        return new Point(fReplacementPosition.getOffset() + fCursorPosition, 0);
    }

    /*
     * @see ICompletionProposal#getContextInformation()
     */
    public IContextInformation getContextInformation() {
        return fContextInformation;
    }

    /*
     * @see ICompletionProposal#getImage()
     */
    public Image getImage() {
        return fImage;
    }

    /*
     * @see dwtx.jface.text.contentassist.ICompletionProposal#getDisplayString()
     */
    public String getDisplayString() {
        if (fDisplayString !is null)
            return fDisplayString;
        return fReplacementString;
    }

    /*
     * @see ICompletionProposal#getAdditionalProposalInfo()
     */
    public String getAdditionalProposalInfo() {
        return fAdditionalProposalInfo;
    }

    /*
     * @see dwtx.jface.text.contentassist.ICompletionProposalExtension2#apply(dwtx.jface.text.ITextViewer, char, int, int)
     */
    public void apply(ITextViewer viewer, char trigger, int stateMask, int offset) {
        apply(viewer.getDocument());
    }

    /*
     * @see dwtx.jface.text.contentassist.ICompletionProposalExtension2#selected(dwtx.jface.text.ITextViewer, bool)
     */
    public void selected(ITextViewer viewer, bool smartToggle) {
    }

    /*
     * @see dwtx.jface.text.contentassist.ICompletionProposalExtension2#unselected(dwtx.jface.text.ITextViewer)
     */
    public void unselected(ITextViewer viewer) {
    }

    /*
     * @see dwtx.jface.text.contentassist.ICompletionProposalExtension2#validate(dwtx.jface.text.IDocument, int, dwtx.jface.text.DocumentEvent)
     */
    public bool validate(IDocument document, int offset, DocumentEvent event) {
        try {
            String content= document.get(fReplacementPosition.getOffset(), offset - fReplacementPosition.getOffset());
            if (fReplacementString.startsWith(content))
                return true;
        } catch (BadLocationException e) {
            // ignore concurrently modified document
        }
        return false;
    }

}
