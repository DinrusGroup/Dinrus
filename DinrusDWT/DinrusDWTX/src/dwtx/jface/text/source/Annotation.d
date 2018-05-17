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
module dwtx.jface.text.source.Annotation;

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
import dwtx.jface.text.source.IOverviewRuler; // packageimport
import dwtx.jface.text.source.IVerticalRulerListener; // packageimport
import dwtx.jface.text.source.ISourceViewerExtension4; // packageimport
import dwtx.jface.text.source.AnnotationPainter; // packageimport
import dwtx.jface.text.source.IAnnotationHoverExtension2; // packageimport
import dwtx.jface.text.source.OverviewRuler; // packageimport
import dwtx.jface.text.source.OverviewRulerHoverManager; // packageimport


import dwt.dwthelper.utils;


/**
 * Annotation managed by an
 * {@link dwtx.jface.text.source.IAnnotationModel}.
 * <p>
 * Annotations are typed, can have an associated text and can be marked as persistent and
 * deleted. Annotations which are not explicitly initialized with an annotation
 * type are of type <code>"dwtx.text.annotation.unknown"</code>.
 */
public class Annotation {

    /**
     * Constant for unknown annotation types.<p>
     * Value: <code>"dwtx.text.annotation.unknown"</code>
     * @since 3.0
     */
    public const static String TYPE_UNKNOWN= "dwtx.text.annotation.unknown";  //$NON-NLS-1$


    /**
     * The type of this annotation.
     * @since 3.0
     */
    private String fType;
    /**
     * Indicates whether this annotation is persistent or not.
     * @since 3.0
     */
    private bool fIsPersistent= false;
    /**
     * Indicates whether this annotation is marked as deleted or not.
     * @since 3.0
     */
    private bool fMarkedAsDeleted= false;
    /**
     * The text associated with this annotation.
     * @since 3.0
     */
    private String fText;


    /**
     * Creates a new annotation that is not persistent and type less.
     */
    protected this() {
        this(null, false, null);
    }

    /**
     * Creates a new annotation with the given properties.
     *
     * @param type the unique name of this annotation type
     * @param isPersistent <code>true</code> if this annotation is
     *            persistent, <code>false</code> otherwise
     * @param text the text associated with this annotation
     * @since 3.0
     */
    public this(String type, bool isPersistent, String text) {
        fType= type;
        fIsPersistent= isPersistent;
        fText= text;
    }

    /**
     * Creates a new annotation with the given persistence state.
     *
     * @param isPersistent <code>true</code> if persistent, <code>false</code> otherwise
     * @since 3.0
     */
    public this(bool isPersistent) {
        this(null, isPersistent, null);
    }

    /**
     * Returns whether this annotation is persistent.
     *
     * @return <code>true</code> if this annotation is persistent, <code>false</code>
     *         otherwise
     * @since 3.0
     */
    public bool isPersistent() {
        return fIsPersistent;
    }

    /**
     * Sets the type of this annotation.
     *
     * @param type the annotation type
     * @since 3.0
     */
    public void setType(String type) {
        fType= type;
    }

    /**
     * Returns the type of the annotation.
     *
     * @return the type of the annotation
     * @since 3.0
     */
    public String getType() {
        return fType is null ? TYPE_UNKNOWN : fType;
    }

    /**
     * Marks this annotation deleted according to the value of the
     * <code>deleted</code> parameter.
     *
     * @param deleted <code>true</code> if annotation should be marked as deleted
     * @since 3.0
     */
    public void markDeleted(bool deleted) {
        fMarkedAsDeleted= deleted;
    }

    /**
     * Returns whether this annotation is marked as deleted.
     *
     * @return <code>true</code> if annotation is marked as deleted, <code>false</code>
     *         otherwise
     * @since 3.0
     */
    public bool isMarkedDeleted() {
        return fMarkedAsDeleted;
    }

    /**
     * Sets the text associated with this annotation.
     *
     * @param text the text associated with this annotation
     * @since 3.0
     */
    public void setText(String text) {
        fText= text;
    }

    /**
     * Returns the text associated with this annotation.
     *
     * @return the text associated with this annotation or <code>null</code>
     * @since 3.0
     */
    public String getText() {
        return fText;
    }
}
