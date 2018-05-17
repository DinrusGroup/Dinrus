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
module dwtx.jface.text.source.IAnnotationAccessExtension;

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
import dwtx.jface.text.source.ContentAssistantFacade; // packageimport
import dwtx.jface.text.source.IAnnotationAccess; // packageimport
import dwtx.jface.text.source.IVerticalRulerExtension; // packageimport
import dwtx.jface.text.source.IVerticalRulerColumn; // packageimport
import dwtx.jface.text.source.LineNumberRulerColumn; // packageimport
import dwtx.jface.text.source.MatchingCharacterPainter; // packageimport
import dwtx.jface.text.source.IAnnotationModelExtension; // packageimport
import dwtx.jface.text.source.ILineDifferExtension; // packageimport
import dwtx.jface.text.source.DefaultCharacterPairMatcher; // packageimport
import dwtx.jface.text.source.LineNumberChangeRulerColumn; // packageimport
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

import dwt.graphics.GC;
import dwt.graphics.Rectangle;
import dwt.widgets.Canvas;

/**
 * Extension interface for {@link dwtx.jface.text.source.IAnnotationAccess}.<p>
 * This interface replaces the methods of <code>IAnnotationAccess</code>.<p>
 * This interface provides
 * <ul>
 * <li> a label for the annotation type of a given annotation</li>
 * <li> the paint layer of a given annotation</li>
 * <li> means to paint a given annotation</li>
 * <li> information about the type hierarchy of the annotation type of a given annotation</li>
 * <ul>.
 *
 * @see dwtx.jface.text.source.IAnnotationAccess
 * @since 3.0
 */
public interface IAnnotationAccessExtension {

    /**
     * The default annotation layer.
     */
    static const int DEFAULT_LAYER= IAnnotationPresentation.DEFAULT_LAYER;

    /**
     * Returns the label for the given annotation's type.
     *
     * @param annotation the annotation
     * @return the label the given annotation's type or <code>null</code> if no such label exists
     */
    String getTypeLabel(Annotation annotation);

    /**
     * Returns the layer for given annotation. Annotations are considered
     * being located at layers and are considered being painted starting with
     * layer 0 upwards. Thus an annotation at layer 5 will be drawn on top of
     * all co-located annotations at the layers 4 - 0.
     *
     * @param annotation the annotation
     * @return the layer of the given annotation
     */
    int getLayer(Annotation annotation);

    /**
     * Draws a graphical representation of the given annotation within the given bounds.
     * <p>
     * <em>Note that this method is not used when drawing annotations on the editor's
     * text widget. This is handled trough a {@link dwtx.jface.text.source.AnnotationPainter.IDrawingStrategy}.</em>
     * </p>
     * @param annotation the given annotation
     * @param gc the drawing GC
     * @param canvas the canvas to draw on
     * @param bounds the bounds inside the canvas to draw on
     */
    void paint(Annotation annotation, GC gc, Canvas canvas, Rectangle bounds);

    /**
     * Returns <code>true</code> if painting <code>annotation</code> will produce something
     * meaningful, <code>false</code> if not. E.g. if no image is available.
     * <p>
     * <em>Note that this method is not used when drawing annotations on the editor's
     * text widget. This is handled trough a {@link dwtx.jface.text.source.AnnotationPainter.IDrawingStrategy}.</em>
     * </p>
     * @param annotation the annotation to check whether it can be painted
     * @return <code>true</code> if painting <code>annotation</code> will succeed
     */
    bool isPaintable(Annotation annotation);

    /**
     * Returns <code>true</code> if the given annotation is of the given type
     * or <code>false</code> otherwise.
     *
     * @param annotationType the annotation type
     * @param potentialSupertype the potential super annotation type
     * @return <code>true</code> if annotation type is a sub-type of the potential annotation super type
     */
    bool isSubtype(Object annotationType, Object potentialSupertype);

    /**
     * Returns the list of super types for the given annotation type. This does not include the type
     * itself. The index in the array of super types indicates the length of the path in the hierarchy
     * graph to the given annotation type.
     *
     * @param annotationType the annotation type to check
     * @return the super types for the given annotation type
     */
    Object[] getSupertypes(Object annotationType);
}
