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
module dwtx.jface.text.source.IAnnotationModel;

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

import dwtx.dwtxhelper.Collection;

import dwtx.jface.text.IDocument;
import dwtx.jface.text.Position;


/**
 * This interface defines the model for managing annotations attached to a document.
 * The model maintains a set of annotations for a given document and notifies registered annotation
 * model listeners about annotation model changes. It also provides methods
 * for querying the current position of an annotation managed
 * by this model.
 * <p>
 * In order to provide backward compatibility for clients of <code>IAnnotationModel</code>, extension
 * interfaces are used to provide a means of evolution. The following extension interfaces
 * exist:
 * <ul>
 * <li> {@link dwtx.jface.text.source.IAnnotationModelExtension} since version 3.0 introducing the concept
 *      of model piggybacking annotation models, modification time stamps, and enhanced manipulation methods.
 * </li>
 * <li> {@link dwtx.jface.text.source.IAnnotationModelExtension2} since version 3.4 allows to retrieve
 *      annotations within a given region.
 * </li>
 * </ul>
 * </p>
 *
 * Clients may implement this interface or use the default implementation provided
 * by <code>AnnotationModel</code>.
 *
 * @see dwtx.jface.text.source.IAnnotationModelExtension
 * @see dwtx.jface.text.source.IAnnotationModelExtension2
 * @see dwtx.jface.text.source.Annotation
 * @see dwtx.jface.text.source.IAnnotationModelListener
 */
public interface IAnnotationModel {

    /**
     * Registers the annotation model listener with this annotation model.
     * After registration listener is informed about each change of this model.
     * If the listener is already registered nothing happens.
     *
     * @param listener the listener to be registered, may not be <code>null</code>
     */
    void addAnnotationModelListener(IAnnotationModelListener listener);

    /**
     * Removes the listener from the model's list of annotation model listeners.
     * If the listener is not registered with the model nothing happens.
     *
     * @param listener the listener to be removed, may not be <code>null</code>
     */
    void removeAnnotationModelListener(IAnnotationModelListener listener);

    /**
     * Connects the annotation model to a document. The annotations managed
     * by this model must subsequently update according to the changes applied
     * to the document. Once an annotation model is connected to a document,
     * all further <code>connect</code> calls must mention the document the
     * model is already connected to. An annotation model primarily uses
     * <code>connect</code> and <code>disconnect</code> for reference counting
     * the document. Reference counting frees the clients from keeping tracker
     * whether a model has already been connected to a document.
     *
     * @param document the document the model gets connected to,
     *      may not be <code>null</code>
     *
     * @see #disconnect(IDocument)
     */
    void connect(IDocument document);

    /**
     * Disconnects this model from a document. After that, document changes no longer matter.
     * An annotation model may only be disconnected from a document to which it has been
     * connected before. If the model reference counts the connections to a document,
     * the connection to the document may only be terminated if the reference count does
     * down to 0.
     *
     * @param document the document the model gets disconnected from,
     *      may not be <code>null</code>
     *
     * @see #connect(IDocument) for further specification details
     */
    void disconnect(IDocument document);

    /**
     * Adds a annotation to this annotation model. The annotation is associated with
     * with the given position which describes the range covered by the annotation.
     * All registered annotation model listeners are informed about the change.
     * If the model is connected to a document, the position is automatically
     * updated on document changes. If the annotation is already managed by
     * this annotation model or is not a valid position in the connected document
     * nothing happens.
     * <p>
     * <strong>Performance hint:</strong> Use {@link IAnnotationModelExtension#replaceAnnotations(Annotation[], java.util.Map)}
     * if several annotations are added and/or removed.
     * </p>
     *
     * @param annotation the annotation to add, may not be <code>null</code>
     * @param position the position describing the range covered by this annotation,
     *      may not be <code>null</code>
     */
    void addAnnotation(Annotation annotation, Position position);

    /**
     * Removes the given annotation from the model. I.e. the annotation is no
     * longer managed by this model. The position associated with the annotation
     * is no longer updated on document changes. If the annotation is not
     * managed by this model, nothing happens.
     * <p>
     * <strong>Performance hint:</strong> Use {@link IAnnotationModelExtension#replaceAnnotations(Annotation[], java.util.Map)}
     * if several annotations are removed and/or added.
     * </p>
     *
     * @param annotation the annotation to be removed from this model,
     *      may not be <code>null</code>
     */
    void removeAnnotation(Annotation annotation);

    /**
     * Returns all annotations managed by this model.
     *
     * @return all annotations managed by this model (element type: {@link Annotation})
     */
    Iterator getAnnotationIterator();

    /**
     * Returns the position associated with the given annotation.
     *
     * @param annotation the annotation whose position should be returned
     * @return the position of the given annotation or <code>null</code> if no
     *      associated annotation exists
     */
    Position getPosition(Annotation annotation);
}

