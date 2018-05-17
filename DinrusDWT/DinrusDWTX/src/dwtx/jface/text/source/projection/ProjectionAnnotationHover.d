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
module dwtx.jface.text.source.projection.ProjectionAnnotationHover;

import dwtx.jface.text.source.projection.ProjectionViewer; // packageimport
import dwtx.jface.text.source.projection.ProjectionSupport; // packageimport
import dwtx.jface.text.source.projection.IProjectionPosition; // packageimport
import dwtx.jface.text.source.projection.AnnotationBag; // packageimport
import dwtx.jface.text.source.projection.ProjectionSummary; // packageimport
import dwtx.jface.text.source.projection.ProjectionRulerColumn; // packageimport
import dwtx.jface.text.source.projection.ProjectionAnnotationModel; // packageimport
import dwtx.jface.text.source.projection.SourceViewerInformationControl; // packageimport
import dwtx.jface.text.source.projection.IProjectionListener; // packageimport
import dwtx.jface.text.source.projection.ProjectionAnnotation; // packageimport


import dwt.dwthelper.utils;

import dwtx.dwtxhelper.Collection;

import dwt.widgets.Shell;
import dwtx.jface.resource.JFaceResources;
import dwtx.jface.text.BadLocationException;
import dwtx.jface.text.IDocument;
import dwtx.jface.text.IInformationControl;
import dwtx.jface.text.IInformationControlCreator;
import dwtx.jface.text.IRegion;
import dwtx.jface.text.Position;
import dwtx.jface.text.information.IInformationProviderExtension2;
import dwtx.jface.text.source.IAnnotationHover;
import dwtx.jface.text.source.IAnnotationHoverExtension;
import dwtx.jface.text.source.IAnnotationModel;
import dwtx.jface.text.source.IAnnotationModelExtension;
import dwtx.jface.text.source.ILineRange;
import dwtx.jface.text.source.ISourceViewer;
import dwtx.jface.text.source.ISourceViewerExtension2;
import dwtx.jface.text.source.LineRange;

/**
 * Annotation hover for projection annotations.
 *
 * @since 3.0
 */
class ProjectionAnnotationHover : IAnnotationHover, IAnnotationHoverExtension, IInformationProviderExtension2 {


    private IInformationControlCreator fInformationControlCreator;
    private IInformationControlCreator fInformationPresenterControlCreator;

    /**
     * Sets the hover control creator for this projection annotation hover.
     *
     * @param creator the creator
     */
    public void setHoverControlCreator(IInformationControlCreator creator) {
        fInformationControlCreator= creator;
    }

    /**
     * Sets the information presenter control creator for this projection annotation hover.
     *
     * @param creator the creator
     * @since 3.3
     */
    public void setInformationPresenterControlCreator(IInformationControlCreator creator) {
        fInformationPresenterControlCreator= creator;
    }

    /*
     * @see dwtx.jface.text.source.IAnnotationHover#getHoverInfo(dwtx.jface.text.source.ISourceViewer, int)
     */
    public String getHoverInfo(ISourceViewer sourceViewer, int lineNumber) {
        // this is a no-op as semantics is defined by the implementation of the annotation hover extension
        return null;
    }

    /*
     * @since 3.1
     */
    private bool isCaptionLine(ProjectionAnnotation annotation, Position position, IDocument document, int line) {
        if (position.getOffset() > -1 && position.getLength() > -1) {
            try {
                int captionOffset;
                if ( cast(IProjectionPosition)position )
                    captionOffset= (cast(IProjectionPosition) position).computeCaptionOffset(document);
                else
                    captionOffset= 0;
                int startLine= document.getLineOfOffset(position.getOffset() + captionOffset);
                return line is startLine;
            } catch (BadLocationException x) {
            }
        }
        return false;
    }

    private String getProjectionTextAtLine(ISourceViewer viewer, int line, int numberOfLines) {

        IAnnotationModel model= null;
        if ( cast(ISourceViewerExtension2)viewer ) {
            ISourceViewerExtension2 viewerExtension= cast(ISourceViewerExtension2) viewer;
            IAnnotationModel visual= viewerExtension.getVisualAnnotationModel();
            if ( cast(IAnnotationModelExtension)visual ) {
                IAnnotationModelExtension modelExtension= cast(IAnnotationModelExtension) visual;
                model= modelExtension.getAnnotationModel(ProjectionSupport.PROJECTION);
            }
        }

        if (model !is null) {
            try {
                IDocument document= viewer.getDocument();
                Iterator e= model.getAnnotationIterator();
                while (e.hasNext()) {
                    ProjectionAnnotation annotation= cast(ProjectionAnnotation) e.next();
                    if (!annotation.isCollapsed())
                        continue;

                    Position position= model.getPosition(annotation);
                    if (position is null)
                        continue;

                    if (isCaptionLine(annotation, position, document, line))
                        return getText(document, position.getOffset(), position.getLength(), numberOfLines);

                }
            } catch (BadLocationException x) {
            }
        }

        return null;
    }

    private String getText(IDocument document, int offset, int length, int numberOfLines)  {
        int endOffset= offset + length;

        try {
            int endLine= document.getLineOfOffset(offset) + Math.max(0, numberOfLines -1);
            IRegion lineInfo= document.getLineInformation(endLine);
            endOffset= Math.min(endOffset, lineInfo.getOffset() + lineInfo.getLength());
        } catch (BadLocationException x) {
        }

        return document.get(offset, endOffset - offset);
    }

    /*
     * @see dwtx.jface.text.source.IAnnotationHoverExtension#getHoverInfo(dwtx.jface.text.source.ISourceViewer, dwtx.jface.text.source.ILineRange, int)
     */
    public Object getHoverInfo(ISourceViewer sourceViewer, ILineRange lineRange, int visibleLines) {
        return stringcast(getProjectionTextAtLine(sourceViewer, lineRange.getStartLine(), visibleLines));
    }

    /*
     * @see dwtx.jface.text.source.IAnnotationHoverExtension#getHoverLineRange(dwtx.jface.text.source.ISourceViewer, int)
     */
    public ILineRange getHoverLineRange(ISourceViewer viewer, int lineNumber) {
        return new LineRange(lineNumber, 1);
    }

    /*
     * @see dwtx.jface.text.source.IAnnotationHoverExtension#canHandleMouseCursor()
     */
    public bool canHandleMouseCursor() {
        return false;
    }

    /*
     * @see dwtx.jface.text.source.IAnnotationHoverExtension#getHoverControlCreator()
     */
    public IInformationControlCreator getHoverControlCreator() {
        if (fInformationControlCreator is null) {
            fInformationControlCreator= new class()  IInformationControlCreator {
                public IInformationControl createInformationControl(Shell parent) {
                    return new SourceViewerInformationControl(parent, false, JFaceResources.TEXT_FONT, null);
                }
            };
        }
        return fInformationControlCreator;
    }

    /*
     * @see dwtx.jface.text.information.IInformationProviderExtension2#getInformationPresenterControlCreator()
     * @since 3.3
     */
    public IInformationControlCreator getInformationPresenterControlCreator() {
        if (fInformationPresenterControlCreator is null) {
            fInformationPresenterControlCreator= new class()  IInformationControlCreator {
                public IInformationControl createInformationControl(Shell parent) {
                    return new SourceViewerInformationControl(parent, true, JFaceResources.TEXT_FONT, null);
                }
            };
        }
        return fInformationPresenterControlCreator;
    }
}
