/*******************************************************************************
 * Copyright (c) 2000, 2006 IBM Corporation and others.
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
module dwtx.jface.text.source.projection.ProjectionRulerColumn;

import dwtx.jface.text.source.projection.ProjectionViewer; // packageimport
import dwtx.jface.text.source.projection.ProjectionSupport; // packageimport
import dwtx.jface.text.source.projection.IProjectionPosition; // packageimport
import dwtx.jface.text.source.projection.AnnotationBag; // packageimport
import dwtx.jface.text.source.projection.ProjectionSummary; // packageimport
import dwtx.jface.text.source.projection.ProjectionAnnotationHover; // packageimport
import dwtx.jface.text.source.projection.ProjectionAnnotationModel; // packageimport
import dwtx.jface.text.source.projection.SourceViewerInformationControl; // packageimport
import dwtx.jface.text.source.projection.IProjectionListener; // packageimport
import dwtx.jface.text.source.projection.ProjectionAnnotation; // packageimport


import dwt.dwthelper.utils;


import dwtx.dwtxhelper.Collection;

import dwt.DWT;
import dwt.events.MouseEvent;
import dwt.events.MouseMoveListener;
import dwt.events.MouseTrackAdapter;
import dwt.graphics.Color;
import dwt.widgets.Composite;
import dwt.widgets.Control;
import dwt.widgets.Display;
import dwtx.jface.text.BadLocationException;
import dwtx.jface.text.IDocument;
import dwtx.jface.text.Position;
import dwtx.jface.text.source.AnnotationRulerColumn;
import dwtx.jface.text.source.CompositeRuler;
import dwtx.jface.text.source.IAnnotationAccess;
import dwtx.jface.text.source.IAnnotationModel;
import dwtx.jface.text.source.IAnnotationModelExtension;


/**
 * A ruler column for controlling the behavior of a
 * {@link dwtx.jface.text.source.projection.ProjectionViewer}.
 *
 * @since 3.0
 */
class ProjectionRulerColumn : AnnotationRulerColumn {

    private ProjectionAnnotation fCurrentAnnotation;

    /**
     * Creates a new projection ruler column.
     *
     * @param model the column's annotation model
     * @param width the width in pixels
     * @param annotationAccess the annotation access
     */
    public this(IAnnotationModel model, int width, IAnnotationAccess annotationAccess) {
        super(model, width, annotationAccess);
    }

    /**
     * Creates a new projection ruler column.
     *
     * @param width the width in pixels
     * @param annotationAccess the annotation access
     */
    public this(int width, IAnnotationAccess annotationAccess) {
        super(width, annotationAccess);
    }

    /*
     * @see dwtx.jface.text.source.AnnotationRulerColumn#mouseClicked(int)
     */
    protected void mouseClicked(int line) {
        clearCurrentAnnotation();
        ProjectionAnnotation annotation= findAnnotation(line, true);
        if (annotation !is null) {
            ProjectionAnnotationModel model= cast(ProjectionAnnotationModel) getModel();
            model.toggleExpansionState(annotation);
        }
    }

    /**
     * Returns the projection annotation of the column's annotation
     * model that contains the given line.
     *
     * @param line the line
     * @param exact <code>true</code> if the annotation range must match exactly
     * @return the projection annotation containing the given line
     */
    private ProjectionAnnotation findAnnotation(int line, bool exact) {

        ProjectionAnnotation previousAnnotation= null;

        IAnnotationModel model= getModel();
        if (model !is null) {
            IDocument document= getCachedTextViewer().getDocument();

            int previousDistance= Integer.MAX_VALUE;

            Iterator e= model.getAnnotationIterator();
            while (e.hasNext()) {
                Object next= e.next();
                if ( cast(ProjectionAnnotation)next ) {
                    ProjectionAnnotation annotation= cast(ProjectionAnnotation) next;
                    Position p= model.getPosition(annotation);
                    if (p is null)
                        continue;

                    int distance= getDistance(annotation, p, document, line);
                    if (distance is -1)
                        continue;

                    if (!exact) {
                        if (distance < previousDistance) {
                            previousAnnotation= annotation;
                            previousDistance= distance;
                        }
                    } else if (distance is 0) {
                        previousAnnotation= annotation;
                    }
                }
            }
        }

        return previousAnnotation;
    }

    /**
     * Returns the distance of the given line to the start line of the given position in the given document. The distance is
     * <code>-1</code> when the line is not included in the given position.
     *
     * @param annotation the annotation
     * @param position the position
     * @param document the document
     * @param line the line
     * @return <code>-1</code> if line is not contained, a position number otherwise
     */
    private int getDistance(ProjectionAnnotation annotation, Position position, IDocument document, int line) {
        if (position.getOffset() > -1 && position.getLength() > -1) {
            try {
                int startLine= document.getLineOfOffset(position.getOffset());
                int endLine= document.getLineOfOffset(position.getOffset() + position.getLength());
                if (startLine <= line && line < endLine) {
                    if (annotation.isCollapsed()) {
                        int captionOffset;
                        if ( cast(IProjectionPosition)position )
                            captionOffset= (cast(IProjectionPosition) position).computeCaptionOffset(document);
                        else
                            captionOffset= 0;

                        int captionLine= document.getLineOfOffset(position.getOffset() + captionOffset);
                        if (startLine <= captionLine && captionLine < endLine)
                            return Math.abs(line - captionLine);
                    }
                    return line - startLine;
                }
            } catch (BadLocationException x) {
            }
        }
        return -1;
    }

    private bool clearCurrentAnnotation() {
        if (fCurrentAnnotation !is null) {
            fCurrentAnnotation.setRangeIndication(false);
            fCurrentAnnotation= null;
            return true;
        }
        return false;
    }

    /*
     * @see dwtx.jface.text.source.IVerticalRulerColumn#createControl(dwtx.jface.text.source.CompositeRuler, dwt.widgets.Composite)
     */
    public Control createControl(CompositeRuler parentRuler, Composite parentControl) {
        Control control= super.createControl(parentRuler, parentControl);

        // set background
        Display display= parentControl.getDisplay();
        Color background= display.getSystemColor(DWT.COLOR_LIST_BACKGROUND);
        control.setBackground(background);

        // install hover listener
        control.addMouseTrackListener(new class()  MouseTrackAdapter {
            public void mouseExit(MouseEvent e) {
                if (clearCurrentAnnotation())
                    redraw();
            }
        });

        // install mouse move listener
        control.addMouseMoveListener(new class()  MouseMoveListener {
            public void mouseMove(MouseEvent e) {
                bool redraw_= false;
                ProjectionAnnotation annotation= findAnnotation(toDocumentLineNumber(e.y), false);
                if (annotation !is fCurrentAnnotation) {
                    if (fCurrentAnnotation !is null) {
                        fCurrentAnnotation.setRangeIndication(false);
                        redraw_= true;
                    }
                    fCurrentAnnotation= annotation;
                    if (fCurrentAnnotation !is null && !fCurrentAnnotation.isCollapsed()) {
                        fCurrentAnnotation.setRangeIndication(true);
                        redraw_= true;
                    }
                }
                if (redraw_)
                    redraw();
            }
        });
        return control;
    }

    /*
     * @see dwtx.jface.text.source.AnnotationRulerColumn#setModel(dwtx.jface.text.source.IAnnotationModel)
     */
    public void setModel(IAnnotationModel model) {
        if ( cast(IAnnotationModelExtension)model ) {
            IAnnotationModelExtension extension= cast(IAnnotationModelExtension) model;
            model= extension.getAnnotationModel(ProjectionSupport.PROJECTION);
        }
        super.setModel(model);
    }

    /*
     * @see dwtx.jface.text.source.AnnotationRulerColumn#isPropagatingMouseListener()
     */
    protected bool isPropagatingMouseListener() {
        return false;
    }

    /*
     * @see dwtx.jface.text.source.AnnotationRulerColumn#hasAnnotation(int)
     */
    protected bool hasAnnotation(int lineNumber) {
        return findAnnotation(lineNumber, true) !is null;
    }
}
