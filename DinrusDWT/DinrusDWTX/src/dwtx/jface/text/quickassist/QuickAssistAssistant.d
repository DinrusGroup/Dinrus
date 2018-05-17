/*******************************************************************************
 * Copyright (c) 2006, 2008 IBM Corporation and others.
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
module dwtx.jface.text.quickassist.QuickAssistAssistant;

import dwtx.jface.text.quickassist.IQuickAssistAssistant; // packageimport
import dwtx.jface.text.quickassist.IQuickAssistAssistantExtension; // packageimport
import dwtx.jface.text.quickassist.IQuickAssistInvocationContext; // packageimport
import dwtx.jface.text.quickassist.IQuickFixableAnnotation; // packageimport
import dwtx.jface.text.quickassist.IQuickAssistProcessor; // packageimport


import dwt.dwthelper.utils;




import dwt.graphics.Color;
import dwtx.core.commands.IHandler;
import dwtx.jface.text.IDocument;
import dwtx.jface.text.IInformationControlCreator;
import dwtx.jface.text.ITextViewer;
import dwtx.jface.text.contentassist.ContentAssistant;
import dwtx.jface.text.contentassist.ICompletionListener;
import dwtx.jface.text.contentassist.ICompletionProposal;
import dwtx.jface.text.contentassist.IContentAssistProcessor;
import dwtx.jface.text.contentassist.IContextInformation;
import dwtx.jface.text.contentassist.IContextInformationValidator;
import dwtx.jface.text.source.Annotation;
import dwtx.jface.text.source.ISourceViewer;
import dwtx.jface.text.source.TextInvocationContext;


/**
 * Default implementation of <code>IQuickAssistAssistant</code>.
 *
 * @since 3.2
 */
public class QuickAssistAssistant : IQuickAssistAssistant, IQuickAssistAssistantExtension {


    private static final class QuickAssistAssistantImpl : ContentAssistant {
        /*
         * @see dwtx.jface.text.contentassist.ContentAssistant#possibleCompletionsClosed()
         */
        public void possibleCompletionsClosed() {
            super.possibleCompletionsClosed();
        }

        /*
         * @see dwtx.jface.text.contentassist.ContentAssistant#hide()
         * @since 3.4
         */
        protected void hide() {
            super.hide();
        }
    }


    private static final class ContentAssistProcessor : IContentAssistProcessor {

        private IQuickAssistProcessor fQuickAssistProcessor;

        this(IQuickAssistProcessor processor) {
            fQuickAssistProcessor= processor;
        }

        /*
         * @see dwtx.jface.text.contentassist.IContentAssistProcessor#computeCompletionProposals(dwtx.jface.text.ITextViewer, int)
         */
        public ICompletionProposal[] computeCompletionProposals(ITextViewer viewer, int offset) {
            // panic code - should not happen
            if (!( cast(ISourceViewer)viewer ))
                return null;

            return fQuickAssistProcessor.computeQuickAssistProposals(new TextInvocationContext(cast(ISourceViewer)viewer, offset, -1));
        }

        /*
         * @see dwtx.jface.text.contentassist.IContentAssistProcessor#computeContextInformation(dwtx.jface.text.ITextViewer, int)
         */
        public IContextInformation[] computeContextInformation(ITextViewer viewer, int offset) {
            return null;
        }

        /*
         * @see dwtx.jface.text.contentassist.IContentAssistProcessor#getCompletionProposalAutoActivationCharacters()
         */
        public char[] getCompletionProposalAutoActivationCharacters() {
            return null;
        }

        /*
         * @see dwtx.jface.text.contentassist.IContentAssistProcessor#getContextInformationAutoActivationCharacters()
         */
        public char[] getContextInformationAutoActivationCharacters() {
            return null;
        }

        /*
         * @see dwtx.jface.text.contentassist.IContentAssistProcessor#getErrorMessage()
         */
        public String getErrorMessage() {
            return null;
        }

        /*
         * @see dwtx.jface.text.contentassist.IContentAssistProcessor#getContextInformationValidator()
         */
        public IContextInformationValidator getContextInformationValidator() {
            return null;
        }

    }

    private QuickAssistAssistantImpl fQuickAssistAssistantImpl;
    private IQuickAssistProcessor fQuickAssistProcessor;

    public this() {
        fQuickAssistAssistantImpl= new QuickAssistAssistantImpl();
        fQuickAssistAssistantImpl.enableAutoActivation(false);
        fQuickAssistAssistantImpl.enableAutoInsert(false);
    }

    /*
     * @see dwtx.jface.text.quickassist.IQuickAssistAssistant#showPossibleQuickAssists()
     */
    public String showPossibleQuickAssists() {
        return fQuickAssistAssistantImpl.showPossibleCompletions();
    }

    /*
     * @see dwtx.jface.text.quickassist.IQuickAssistAssistant#getQuickAssistProcessor(java.lang.String)
     */
    public IQuickAssistProcessor getQuickAssistProcessor() {
        return fQuickAssistProcessor;
    }

    /*
     * @see dwtx.jface.text.quickassist.IQuickAssistAssistant#setQuickAssistProcessor(dwtx.jface.text.quickassist.IQuickAssistProcessor)
     */
    public void setQuickAssistProcessor(IQuickAssistProcessor processor) {
        fQuickAssistProcessor= processor;
        fQuickAssistAssistantImpl.setDocumentPartitioning("__" ~ this.classinfo.name ~ "_partitioning"); //$NON-NLS-1$ //$NON-NLS-2$
        fQuickAssistAssistantImpl.setContentAssistProcessor(new ContentAssistProcessor(processor), IDocument.DEFAULT_CONTENT_TYPE);
    }

    /*
     * @see dwtx.jface.text.quickassist.IQuickAssistAssistant#canFix(dwtx.jface.text.source.Annotation)
     */
    public bool canFix(Annotation annotation) {
        return fQuickAssistProcessor !is null && fQuickAssistProcessor.canFix(annotation);
    }

    /*
     * @see dwtx.jface.text.quickassist.IQuickAssistAssistant#canAssist(dwtx.jface.text.quickassist.IQuickAssistInvocationContext)
     */
    public bool canAssist(IQuickAssistInvocationContext invocationContext) {
        return fQuickAssistProcessor !is null && fQuickAssistProcessor.canAssist(invocationContext);
    }

    /*
     * @see dwtx.jface.text.quickassist.IQuickAssistAssistant#install(dwtx.jface.text.ITextViewer)
     */
    public void install(ISourceViewer sourceViewer) {
        fQuickAssistAssistantImpl.install(sourceViewer);
    }

    /*
     * @see dwtx.jface.text.quickassist.IQuickAssistAssistant#setInformationControlCreator(dwtx.jface.text.IInformationControlCreator)
     */
    public void setInformationControlCreator(IInformationControlCreator creator) {
        fQuickAssistAssistantImpl.setInformationControlCreator(creator);
    }

    /*
     * @see dwtx.jface.text.quickassist.IQuickAssistAssistant#uninstall()
     */
    public void uninstall() {
        fQuickAssistAssistantImpl.uninstall();
    }

    /*
     * @see dwtx.jface.text.quickassist.IQuickAssistAssistant#setProposalSelectorBackground(dwt.graphics.Color)
     */
    public void setProposalSelectorBackground(Color background) {
        fQuickAssistAssistantImpl.setProposalSelectorBackground(background);
    }

    /*
     * @see dwtx.jface.text.quickassist.IQuickAssistAssistant#setProposalSelectorForeground(dwt.graphics.Color)
     */
    public void setProposalSelectorForeground(Color foreground) {
        fQuickAssistAssistantImpl.setProposalSelectorForeground(foreground);
    }

    /**
     * Callback to signal this quick assist assistant that the presentation of the
     * possible completions has been stopped.
     */
    protected void possibleCompletionsClosed() {
        fQuickAssistAssistantImpl.possibleCompletionsClosed();
    }

    /*
     * @see dwtx.jface.text.quickassist.IQuickAssistAssistant#addCompletionListener(dwtx.jface.text.contentassist.ICompletionListener)
     */
    public void addCompletionListener(ICompletionListener listener) {
        fQuickAssistAssistantImpl.addCompletionListener(listener);
    }

    /*
     * @see dwtx.jface.text.quickassist.IQuickAssistAssistant#removeCompletionListener(dwtx.jface.text.contentassist.ICompletionListener)
     */
    public void removeCompletionListener(ICompletionListener listener) {
        fQuickAssistAssistantImpl.removeCompletionListener(listener);
    }

    /*
     * @see dwtx.jface.text.quickassist.IQuickAssistAssistant#setStatusLineVisible(bool)
     */
    public void setStatusLineVisible(bool show) {
        fQuickAssistAssistantImpl.setStatusLineVisible(show);

    }

    /*
     * @see dwtx.jface.text.quickassist.IQuickAssistAssistant#setStatusMessage(java.lang.String)
     */
    public void setStatusMessage(String message) {
        fQuickAssistAssistantImpl.setStatusMessage(message);
    }

    /**
     * {@inheritDoc}
     *
     * @since 3.4
     */
    public final IHandler getHandler(String commandId) {
        return fQuickAssistAssistantImpl.getHandler(commandId);
    }

    /**
     * Hides any open pop-ups.
     *
     * @since 3.4
     */
    protected void hide() {
        fQuickAssistAssistantImpl.hide();
    }

    /**
     * {@inheritDoc}
     *
     * @since 3.4
     */
    public void enableColoredLabels(bool isEnabled) {
        fQuickAssistAssistantImpl.enableColoredLabels(isEnabled);
    }

}
