/*******************************************************************************
 * Copyright (c) 2000, 2007 IBM Corporation and others.
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
module dwtx.jface.text.templates.TemplateProposal;

import dwtx.jface.text.templates.SimpleTemplateVariableResolver; // packageimport
import dwtx.jface.text.templates.TemplateBuffer; // packageimport
import dwtx.jface.text.templates.TemplateContext; // packageimport
import dwtx.jface.text.templates.TemplateContextType; // packageimport
import dwtx.jface.text.templates.Template; // packageimport
import dwtx.jface.text.templates.TemplateVariable; // packageimport
import dwtx.jface.text.templates.PositionBasedCompletionProposal; // packageimport
import dwtx.jface.text.templates.TemplateException; // packageimport
import dwtx.jface.text.templates.TemplateTranslator; // packageimport
import dwtx.jface.text.templates.DocumentTemplateContext; // packageimport
import dwtx.jface.text.templates.GlobalTemplateVariables; // packageimport
import dwtx.jface.text.templates.InclusivePositionUpdater; // packageimport
import dwtx.jface.text.templates.ContextTypeRegistry; // packageimport
import dwtx.jface.text.templates.JFaceTextTemplateMessages; // packageimport
import dwtx.jface.text.templates.TemplateCompletionProcessor; // packageimport
import dwtx.jface.text.templates.TextTemplateMessages; // packageimport
import dwtx.jface.text.templates.TemplateVariableType; // packageimport
import dwtx.jface.text.templates.TemplateVariableResolver; // packageimport


import dwt.dwthelper.utils;


import dwt.graphics.Image;
import dwt.graphics.Point;
import dwt.widgets.Shell;
import dwtx.core.runtime.Assert;
import dwtx.jface.dialogs.MessageDialog;
import dwtx.jface.text.BadLocationException;
import dwtx.jface.text.BadPositionCategoryException;
import dwtx.jface.text.DocumentEvent;
import dwtx.jface.text.IDocument;
import dwtx.jface.text.IInformationControlCreator;
import dwtx.jface.text.IRegion;
import dwtx.jface.text.ITextViewer;
import dwtx.jface.text.Position;
import dwtx.jface.text.Region;
import dwtx.jface.text.contentassist.ICompletionProposal;
import dwtx.jface.text.contentassist.ICompletionProposalExtension;
import dwtx.jface.text.contentassist.ICompletionProposalExtension2;
import dwtx.jface.text.contentassist.ICompletionProposalExtension3;
import dwtx.jface.text.contentassist.IContextInformation;
import dwtx.jface.text.link.ILinkedModeListener;
import dwtx.jface.text.link.LinkedModeModel;
import dwtx.jface.text.link.LinkedModeUI;
import dwtx.jface.text.link.LinkedPosition;
import dwtx.jface.text.link.LinkedPositionGroup;
import dwtx.jface.text.link.ProposalPosition;


/**
 * A template completion proposal.
 * <p>
 * Clients may subclass.</p>
 *
 * @since 3.0
 */
public class TemplateProposal : ICompletionProposal, ICompletionProposalExtension, ICompletionProposalExtension2, ICompletionProposalExtension3 {

    private const Template fTemplate;
    private const TemplateContext fContext;
    private const Image fImage;
    private const IRegion fRegion;
    private int fRelevance;

    private IRegion fSelectedRegion; // initialized by apply()
    private String fDisplayString;
    private InclusivePositionUpdater fUpdater;
    private IInformationControlCreator fInformationControlCreator;

    /**
     * Creates a template proposal with a template and its context.
     *
     * @param template  the template
     * @param context   the context in which the template was requested.
     * @param region    the region this proposal is applied to
     * @param image     the icon of the proposal.
     */
    public this(Template template_, TemplateContext context, IRegion region, Image image) {
        this(template_, context, region, image, 0);
    }

    /**
     * Creates a template proposal with a template and its context.
     *
     * @param template  the template
     * @param context   the context in which the template was requested.
     * @param image     the icon of the proposal.
     * @param region    the region this proposal is applied to
     * @param relevance the relevance of the proposal
     */
    public this(Template template_, TemplateContext context, IRegion region, Image image, int relevance) {
        Assert.isNotNull(template_);
        Assert.isNotNull(context);
        Assert.isNotNull(cast(Object)region);

        fTemplate= template_;
        fContext= context;
        fImage= image;
        fRegion= region;

        fDisplayString= null;

        fRelevance= relevance;
    }

    /**
     * Sets the information control creator for this completion proposal.
     *
     * @param informationControlCreator the information control creator
     * @since 3.1
     */
    public final void setInformationControlCreator(IInformationControlCreator informationControlCreator) {
        fInformationControlCreator= informationControlCreator;
    }

    /**
     * Returns the template of this proposal.
     *
     * @return the template of this proposal
     * @since 3.1
     */
    protected final Template getTemplate() {
        return fTemplate;
    }

    /**
     * Returns the context in which the template was requested.
     *
     * @return the context in which the template was requested
     * @since 3.1
     */
    protected final TemplateContext getContext() {
        return fContext;
    }

    /*
     * @see ICompletionProposal#apply(IDocument)
     */
    public final void apply(IDocument document) {
        // not called anymore
    }

    /**
     * Inserts the template offered by this proposal into the viewer's document
     * and sets up a <code>LinkedModeUI</code> on the viewer to edit any of
     * the template's unresolved variables.
     *
     * @param viewer {@inheritDoc}
     * @param trigger {@inheritDoc}
     * @param stateMask {@inheritDoc}
     * @param offset {@inheritDoc}
     */
    public void apply(ITextViewer viewer, char trigger, int stateMask, int offset) {

        IDocument document= viewer.getDocument();
        try {
            fContext.setReadOnly(false);
            int start;
            TemplateBuffer templateBuffer;
            {
                int oldReplaceOffset= getReplaceOffset();
                try {
                    // this may already modify the document (e.g. add imports)
                    templateBuffer= fContext.evaluate(fTemplate);
                } catch (TemplateException e1) {
                    fSelectedRegion= fRegion;
                    return;
                }

                start= getReplaceOffset();
                int shift= start - oldReplaceOffset;
                int end= Math.max(getReplaceEndOffset(), offset + shift);

                // insert template string
                String templateString= templateBuffer.getString();
                document.replace(start, end - start, templateString);
            }

            // translate positions
            LinkedModeModel model= new LinkedModeModel();
            TemplateVariable[] variables= templateBuffer.getVariables();
            bool hasPositions= false;
            for (int i= 0; i !is variables.length; i++) {
                TemplateVariable variable= variables[i];

                if (variable.isUnambiguous())
                    continue;

                LinkedPositionGroup group= new LinkedPositionGroup();

                int[] offsets= variable.getOffsets();
                int length= variable.getLength();

                LinkedPosition first;
                {
                    String[] values= variable.getValues();
                    ICompletionProposal[] proposals= new ICompletionProposal[values.length];
                    for (int j= 0; j < values.length; j++) {
                        ensurePositionCategoryInstalled(document, model);
                        Position pos= new Position(offsets[0] + start, length);
                        document.addPosition(getCategory(), pos);
                        proposals[j]= new PositionBasedCompletionProposal(values[j], pos, length);
                    }

                    if (proposals.length > 1)
                        first= new ProposalPosition(document, offsets[0] + start, length, proposals);
                    else
                        first= new LinkedPosition(document, offsets[0] + start, length);
                }

                for (int j= 0; j !is offsets.length; j++)
                    if (j is 0)
                        group.addPosition(first);
                    else
                        group.addPosition(new LinkedPosition(document, offsets[j] + start, length));

                model.addGroup(group);
                hasPositions= true;
            }

            if (hasPositions) {
                model.forceInstall();
                LinkedModeUI ui= new LinkedModeUI(model, viewer);
                ui.setExitPosition(viewer, getCaretOffset(templateBuffer) + start, 0, Integer.MAX_VALUE);
                ui.enter();

                fSelectedRegion= ui.getSelectedRegion();
            } else {
                ensurePositionCategoryRemoved(document);
                fSelectedRegion= new Region(getCaretOffset(templateBuffer) + start, 0);
            }

        } catch (BadLocationException e) {
            openErrorDialog(viewer.getTextWidget().getShell(), e);
            ensurePositionCategoryRemoved(document);
            fSelectedRegion= fRegion;
        } catch (BadPositionCategoryException e) {
            openErrorDialog(viewer.getTextWidget().getShell(), e);
            fSelectedRegion= fRegion;
        }

    }

    private void ensurePositionCategoryInstalled(IDocument document, LinkedModeModel model) {
        if (!document.containsPositionCategory(getCategory())) {
            document.addPositionCategory(getCategory());
            fUpdater= new InclusivePositionUpdater(getCategory());
            document.addPositionUpdater(fUpdater);

            model.addLinkingListener(new class(document)  ILinkedModeListener {
                IDocument document_;
                this( IDocument a ){
                    document_=a;
                }
                /*
                 * @see dwtx.jface.text.link.ILinkedModeListener#left(dwtx.jface.text.link.LinkedModeModel, int)
                 */
                public void left(LinkedModeModel environment, int flags) {
                    ensurePositionCategoryRemoved(document_);
                }

                public void suspend(LinkedModeModel environment) {}
                public void resume(LinkedModeModel environment, int flags) {}
            });
        }
    }

    private void ensurePositionCategoryRemoved(IDocument document) {
        if (document.containsPositionCategory(getCategory())) {
            try {
                document.removePositionCategory(getCategory());
            } catch (BadPositionCategoryException e) {
                // ignore
            }
            document.removePositionUpdater(fUpdater);
        }
    }

    private String getCategory() {
        return "TemplateProposalCategory_" ~ toString(); //$NON-NLS-1$
    }

    private int getCaretOffset(TemplateBuffer buffer) {

        TemplateVariable[] variables= buffer.getVariables();
        for (int i= 0; i !is variables.length; i++) {
            TemplateVariable variable= variables[i];
            if (variable.getType().equals(GlobalTemplateVariables.Cursor.NAME))
                return variable.getOffsets()[0];
        }

        return buffer.getString().length();
    }

    /**
     * Returns the offset of the range in the document that will be replaced by
     * applying this template.
     *
     * @return the offset of the range in the document that will be replaced by
     *         applying this template
     * @since 3.1
     */
    protected final int getReplaceOffset() {
        int start;
        if ( cast(DocumentTemplateContext)fContext ) {
            DocumentTemplateContext docContext = cast(DocumentTemplateContext)fContext;
            start= docContext.getStart();
        } else {
            start= fRegion.getOffset();
        }
        return start;
    }

    /**
     * Returns the end offset of the range in the document that will be replaced
     * by applying this template.
     *
     * @return the end offset of the range in the document that will be replaced
     *         by applying this template
     * @since 3.1
     */
    protected final int getReplaceEndOffset() {
        int end;
        if ( cast(DocumentTemplateContext)fContext ) {
            DocumentTemplateContext docContext = cast(DocumentTemplateContext)fContext;
            end= docContext.getEnd();
        } else {
            end= fRegion.getOffset() + fRegion.getLength();
        }
        return end;
    }

    /*
     * @see ICompletionProposal#getSelection(IDocument)
     */
    public Point getSelection(IDocument document) {
        return new Point(fSelectedRegion.getOffset(), fSelectedRegion.getLength());
    }

    /*
     * @see ICompletionProposal#getAdditionalProposalInfo()
     */
    public String getAdditionalProposalInfo() {
        try {
            fContext.setReadOnly(true);
            TemplateBuffer templateBuffer;
            try {
                templateBuffer= fContext.evaluate(fTemplate);
            } catch (TemplateException e) {
                return null;
            }

            return templateBuffer.getString();

        } catch (BadLocationException e) {
            return null;
        }
    }

    /*
     * @see ICompletionProposal#getDisplayString()
     */
    public String getDisplayString() {
        if (fDisplayString is null) {
            String[] arguments= [ fTemplate.getName(), fTemplate.getDescription() ];
            fDisplayString= JFaceTextTemplateMessages.getFormattedString("TemplateProposal.displayString", stringcast(arguments)); //$NON-NLS-1$
        }
        return fDisplayString;
    }

    /*
     * @see ICompletionProposal#getImage()
     */
    public Image getImage() {
        return fImage;
    }

    /*
     * @see ICompletionProposal#getContextInformation()
     */
    public IContextInformation getContextInformation() {
        return null;
    }

    private void openErrorDialog(Shell shell, Exception e) {
        MessageDialog.openError(shell, JFaceTextTemplateMessages.getString("TemplateProposal.errorDialog.title"), e.msg); //$NON-NLS-1$
    }

    /**
     * Returns the relevance.
     *
     * @return the relevance
     */
    public int getRelevance() {
        return fRelevance;
    }

    /*
     * @see dwtx.jface.text.contentassist.ICompletionProposalExtension3#getInformationControlCreator()
     */
    public IInformationControlCreator getInformationControlCreator() {
        return fInformationControlCreator;
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
            int replaceOffset= getReplaceOffset();
            if (offset >= replaceOffset) {
                String content= document.get(replaceOffset, offset - replaceOffset);
                return fTemplate.getName().toLowerCase().startsWith(content.toLowerCase());
            }
        } catch (BadLocationException e) {
            // concurrent modification - ignore
        }
        return false;
    }

    /*
     * @see dwtx.jface.text.contentassist.ICompletionProposalExtension3#getPrefixCompletionText(dwtx.jface.text.IDocument, int)
     */
    public CharSequence getPrefixCompletionText(IDocument document, int completionOffset) {
        return new StringCharSequence( fTemplate.getName() );
    }

    /*
     * @see dwtx.jface.text.contentassist.ICompletionProposalExtension3#getPrefixCompletionStart(dwtx.jface.text.IDocument, int)
     */
    public int getPrefixCompletionStart(IDocument document, int completionOffset) {
        return getReplaceOffset();
    }

    /*
     * @see dwtx.jface.text.contentassist.ICompletionProposalExtension#apply(dwtx.jface.text.IDocument, char, int)
     */
    public void apply(IDocument document, char trigger, int offset) {
        // not called any longer
    }

    /*
     * @see dwtx.jface.text.contentassist.ICompletionProposalExtension#isValidFor(dwtx.jface.text.IDocument, int)
     */
    public bool isValidFor(IDocument document, int offset) {
        // not called any longer
        return false;
    }

    /*
     * @see dwtx.jface.text.contentassist.ICompletionProposalExtension#getTriggerCharacters()
     */
    public char[] getTriggerCharacters() {
        // no triggers
        return new char[0];
    }

    /*
     * @see dwtx.jface.text.contentassist.ICompletionProposalExtension#getContextInformationPosition()
     */
    public int getContextInformationPosition() {
        return fRegion.getOffset();
    }
}
