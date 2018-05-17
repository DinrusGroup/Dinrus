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
module dwtx.jface.text.source.IVerticalRuler;

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




import dwt.widgets.Composite;
import dwt.widgets.Control;
import dwtx.jface.text.ITextViewer;


/**
 * This interface defines a visual component which may serve text viewers as an
 * annotation presentation area. Implementers of this interface have to define
 * the presentation modus. This can either depend on the connected viewer's view
 * port or not. If the modus is view port dependent the ruler only shows those
 * annotations that are attached to document regions that are visible in the
 * view port. If independent, the presented annotations can also be attached to
 * invisible document regions.
 *
 * This interfaces comprises three contracts:
 * <ul>
 * <li>The vertical ruler retrieves the annotations it presents from an
 *     annotation model.
 * <li>The ruler is a visual component which must be integrated in a hierarchy
 *     of DWT controls.
 * <li>The ruler provides interested clients with mapping and interaction
 *     information. This covers the mapping between coordinates of the ruler's
 *     control and line numbers based on the connected text viewer's document (see
 *     {@link dwtx.jface.text.source.IVerticalRulerInfo}).
 * </ul>
 * <p>
 * In order to provide backward compatibility for clients of
 * <code>IVerticalRuler</code>, extension interfaces are used as a means of
 * evolution. The following extension interfaces exist:
 * <ul>
 * <li>{@link dwtx.jface.text.source.IVerticalRulerExtension} since
 *     version 2.0 introducing setters for font and mouse button activity location.</li>
 * </ul></p>
 * <p>
 * Clients may implement this interface or use the default implementation
 * provided by {@link dwtx.jface.text.source.CompositeRuler} and
 * {@link dwtx.jface.text.source.VerticalRuler}.</p>
 *
 * @see dwtx.jface.text.source.IVerticalRulerExtension
 * @see dwtx.jface.text.ITextViewer
 */
public interface IVerticalRuler : IVerticalRulerInfo {

    /**
     * Associates an annotation model with this ruler.
     * A value <code>null</code> is acceptable and clears the ruler.
     *
     * @param model the new annotation model, may be <code>null</code>
     */
    void setModel(IAnnotationModel model);

    /**
     * Returns the current annotation model of this ruler or <code>null</code>
     * if the ruler has no model.
     *
     * @return this ruler's annotation model or <code>null</code> if there is no model
     */
    IAnnotationModel getModel();

    /**
     * Forces the vertical ruler to synchronize itself with its
     * annotation model and its viewer's view port.
     */
    void update();

    /**
     * Creates the ruler's DWT control.
     *
     * @param parent the parent control of the ruler's control
     * @param textViewer the text viewer to which this ruler belongs
     * @return the ruler's DWT control
     */
    Control createControl(Composite parent, ITextViewer textViewer);
}
