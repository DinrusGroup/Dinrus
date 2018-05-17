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
module dwtx.jface.text.source.ContentAssistantFacade;

import dwtx.jface.text.source.ISharedTextColors; // packageimport
import dwtx.jface.text.source.ILineRange; // packageimport
import dwtx.jface.text.source.IAnnotationPresentation; // packageimport
import dwtx.jface.text.source.IVerticalRulerInfoExtension; // packageimport
import dwtx.jface.text.source.ICharacterPairMatcher; // packageimport
import dwtx.jface.text.source.TextInvocationContext; // packageimport
import dwtx.jface.text.source.LineChangeHover; // packageimport
import dwtx.jface.text.source.IChangeRulerColumn; // packageimport
import dwtx.jface.text.source.IAnnotationMap; // packageimport
import dwtx.jface.text.source.IAnnotationModelListenerExtension; // packageimport
import dwtx.jface.text.source.ISourceViewerExtension2; // packageimport
import dwtx.jface.text.source.IAnnotationHover; // packageimport
import dwtx.jface.text.source.IAnnotationAccess; // packageimport
import dwtx.jface.text.source.IVerticalRulerExtension; // packageimport
import dwtx.jface.text.source.IVerticalRulerColumn; // packageimport
import dwtx.jface.text.source.LineNumberRulerColumn; // packageimport
import dwtx.jface.text.source.MatchingCharacterPainter; // packageimport
import dwtx.jface.text.source.IAnnotationModelExtension; // packageimport
import dwtx.jface.text.source.ILineDifferExtension; // packageimport
import dwtx.jface.text.source.DefaultCharacterPairMatcher; // packageimport
import dwtx.jface.text.source.LineNumberChangeRulerColumn; // packageimport
import dwtx.jface.text.source.IAnnotationAccessExtension; // packageimport
import dwtx.jface.text.source.ISourceViewer; // packageimport
import dwtx.jface.text.source.AnnotationModel; // packageimport
import dwtx.jface.text.source.ILineDifferExtension2; // packageimport
import dwtx.jface.text.source.IAnnotationModelListener; // packageimport
import dwtx.jface.text.source.IVerticalRuler; // packageimport
import dwtx.jface.text.source.DefaultAnnotationHover; // packageimport
import dwtx.jface.text.source.SourceViewer; // packageimport
import dwtx.jface.text.source.SourceViewerConfiguration; // packageimport
import dwtx.jface.text.source.AnnotationBarHoverManager; // packageimport
import dwtx.jface.text.source.CompositeRuler; // packageimport
import dwtx.jface.text.source.ImageUtilities; // packageimport
import dwtx.jface.text.source.VisualAnnotationModel; // packageimport
import dwtx.jface.text.source.IAnnotationModel; // packageimport
import dwtx.jface.text.source.ISourceViewerExtension3; // packageimport
import dwtx.jface.text.source.ILineDiffInfo; // packageimport
import dwtx.jface.text.source.VerticalRulerEvent; // packageimport
import dwtx.jface.text.source.ChangeRulerColumn; // packageimport
import dwtx.jface.text.source.ILineDiffer; // packageimport
import dwtx.jface.text.source.AnnotationModelEvent; // packageimport
import dwtx.jface.text.source.AnnotationColumn; // packageimport
import dwtx.jface.text.source.AnnotationRulerColumn; // packageimport
import dwtx.jface.text.source.IAnnotationHoverExtension; // packageimport
import dwtx.jface.text.source.AbstractRulerColumn; // packageimport
import dwtx.jface.text.source.ISourceViewerExtension; // packageimport
import dwtx.jface.text.source.AnnotationMap; // packageimport
import dwtx.jface.text.source.IVerticalRulerInfo; // packageimport
import dwtx.jface.text.source.IAnnotationModelExtension2; // packageimport
import dwtx.jface.text.source.LineRange; // packageimport
import dwtx.jface.text.source.IAnnotationAccessExtension2; // packageimport
import dwtx.jface.text.source.VerticalRuler; // packageimport
import dwtx.jface.text.source.JFaceTextMessages; // packageimport
import dwtx.jface.text.source.IOverviewRuler; // packageimport
import dwtx.jface.text.source.Annotation; // packageimport
import dwtx.jface.text.source.IVerticalRulerListener; // packageimport
import dwtx.jface.text.source.ISourceViewerExtension4; // packageimport
import dwtx.jface.text.source.AnnotationPainter; // packageimport
import dwtx.jface.text.source.IAnnotationHoverExtension2; // packageimport
import dwtx.jface.text.source.OverviewRuler; // packageimport
import dwtx.jface.text.source.OverviewRulerHoverManager; // packageimport


import dwt.dwthelper.utils;



import dwtx.core.commands.IHandler;
import dwtx.core.runtime.Assert;
import dwtx.jface.text.contentassist.ICompletionListener;
import dwtx.jface.text.contentassist.IContentAssistant;
import dwtx.jface.text.contentassist.IContentAssistantExtension2;
import dwtx.jface.text.contentassist.IContentAssistantExtension4;


/**
 * Facade to allow minimal access to the given content assistant.
 * <p>
 * The offered API access can grow over time.
 * </p>
 *
 * @since 3.4
 */
public final class ContentAssistantFacade {

    private IContentAssistant fContentAssistant;

    /**
     * Creates a new facade.
     *
     * @param contentAssistant the content assistant which implements {@link IContentAssistantExtension2} and {@link IContentAssistantExtension4}
     */
    public this(IContentAssistant contentAssistant) {
        Assert.isLegal(cast(IContentAssistantExtension4)contentAssistant && cast(IContentAssistantExtension4)contentAssistant );
        fContentAssistant= contentAssistant;
    }

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
     * @throws IllegalStateException if called when the content assistant is
     *             uninstalled
     */
    public IHandler getHandler(String commandId) {
        if (fContentAssistant is null)
            throw new IllegalStateException();
        return (cast(IContentAssistantExtension4)fContentAssistant).getHandler(commandId);
    }

    /**
     * Adds a completion listener that will be informed before proposals are
     * computed.
     *
     * @param listener the listener
     * @throws IllegalStateException if called when the content assistant is
     *             uninstalled
     */
    public void addCompletionListener(ICompletionListener listener) {
        if (fContentAssistant is null)
            throw new IllegalStateException();
        (cast(IContentAssistantExtension2)fContentAssistant).addCompletionListener(listener);
    }

    /**
     * Removes a completion listener.
     *
     * @param listener the listener to remove
     * @throws IllegalStateException if called when the content assistant is
     *             uninstalled
     */
    public void removeCompletionListener(ICompletionListener listener) {
        (cast(IContentAssistantExtension2)fContentAssistant).removeCompletionListener(listener);
    }

}
