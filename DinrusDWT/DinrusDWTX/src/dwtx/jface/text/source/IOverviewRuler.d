/*******************************************************************************
 * Copyright (c) 2000, 2005 IBM Corporation and others.
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
module dwtx.jface.text.source.IOverviewRuler;

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
import dwtx.jface.text.source.Annotation; // packageimport
import dwtx.jface.text.source.IVerticalRulerListener; // packageimport
import dwtx.jface.text.source.ISourceViewerExtension4; // packageimport
import dwtx.jface.text.source.AnnotationPainter; // packageimport
import dwtx.jface.text.source.IAnnotationHoverExtension2; // packageimport
import dwtx.jface.text.source.OverviewRuler; // packageimport
import dwtx.jface.text.source.OverviewRulerHoverManager; // packageimport


import dwt.dwthelper.utils;

import dwt.graphics.Color;
import dwt.widgets.Control;

/**
 * This interface defines a visual component which may serve
 * text viewers as an overview annotation presentation area.  This means,
 * presentation of annotations is independent from the actual view port of
 * the text viewer. The annotations of the viewer's whole document are
 * visible in the overview ruler.
 * <p>
 * This interfaces embodies three contracts:
 * <ul>
 * <li> The overview ruler retrieves the annotations it presents from an annotation model.
 * <li> The ruler is a visual component which must be integrated in a hierarchy of DWT controls.
 * <li> The ruler provides interested clients with mapping and
 *      interaction information. This covers the mapping between
 *      coordinates of the ruler's control and line numbers based
 *      on the connected text viewer's document (<code>IVerticalRulerInfo</code>).
 * </ul></p>
 * <p>
 * Clients may implement this interface or use the default implementation provided
 * by <code>OverviewlRuler</code>.</p>
 *
 * @see dwtx.jface.text.ITextViewer
 * @since 2.1
 */
public interface IOverviewRuler : IVerticalRuler {

    /**
     * Returns whether there is an annotation an the given vertical coordinate. This
     * method takes the compression factor of the overview ruler into account.
     *
     * @param y the y-coordinate
     * @return <code>true</code> if there is an annotation, <code>false</code> otherwise
     */
    bool hasAnnotation(int y);

    /**
     * Returns the height of the visual presentation of an annotation in this
     * overview ruler. Assumes that all annotations are represented using the
     * same height.
     *
     * @return int the visual height of an annotation
     */
    int getAnnotationHeight();

    /**
     * Sets the color for the given annotation type in this overview ruler.
     *
     * @param annotationType the annotation type
     * @param color the color
     */
    void setAnnotationTypeColor(Object annotationType, Color color);

    /**
     * Sets the drawing layer for the given annotation type in this overview ruler.
     *
     * @param annotationType the annotation type
     * @param layer the drawing layer
     */
    void setAnnotationTypeLayer(Object annotationType, int layer);

    /**
     * Adds the given annotation type to this overview ruler. Starting with this
     * call, annotations of the given type are shown in the overview ruler.
     *
     * @param annotationType the annotation type
     */
    void addAnnotationType(Object annotationType);

    /**
     * Removes the given annotation type from this overview ruler. Annotations
     * of the given type are no longer shown in the overview ruler.
     *
     * @param annotationType the annotation type
     */
    void removeAnnotationType(Object annotationType);

    /**
     * Adds the given annotation type to the header of this ruler. Starting with
     * this call, the presence of annotations is tracked and the header is drawn
     * in the configured color.
     *
     * @param annotationType the annotation type to be tracked
     */
    void addHeaderAnnotationType(Object annotationType);

    /**
     * Removes the given annotation type from the header of this ruler. The
     * presence of annotations of the given type is no longer tracked and the
     * header is drawn in the default color, depending on the other configured
     * configured annotation types.
     *
     * @param annotationType the annotation type to be removed
     */
    void removeHeaderAnnotationType(Object annotationType);

    /**
     * Returns this rulers header control. This is the little area between the
     * top of the text widget and the top of this overview ruler.
     *
     * @return the header control of this overview ruler.
     */
    Control getHeaderControl();
}
