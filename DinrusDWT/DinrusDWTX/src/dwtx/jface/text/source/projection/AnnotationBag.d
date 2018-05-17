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
module dwtx.jface.text.source.projection.AnnotationBag;

import dwtx.jface.text.source.projection.ProjectionViewer; // packageimport
import dwtx.jface.text.source.projection.ProjectionSupport; // packageimport
import dwtx.jface.text.source.projection.IProjectionPosition; // packageimport
import dwtx.jface.text.source.projection.ProjectionSummary; // packageimport
import dwtx.jface.text.source.projection.ProjectionAnnotationHover; // packageimport
import dwtx.jface.text.source.projection.ProjectionRulerColumn; // packageimport
import dwtx.jface.text.source.projection.ProjectionAnnotationModel; // packageimport
import dwtx.jface.text.source.projection.SourceViewerInformationControl; // packageimport
import dwtx.jface.text.source.projection.IProjectionListener; // packageimport
import dwtx.jface.text.source.projection.ProjectionAnnotation; // packageimport


import dwt.dwthelper.utils;

import dwtx.dwtxhelper.Collection;



import dwtx.jface.text.source.Annotation;

/**
 * A bag of annotations.
 * <p>
 * This class is not intended to be subclassed.
 * </p>
 *
 * @since 3.0
 * @noextend This class is not intended to be subclassed by clients.
 */
public class AnnotationBag : Annotation {

    private Set fAnnotations;

    /**
     * Creates a new annotation bag.
     *
     * @param type the annotation type
     */
    public this(String type) {
        super(type, false, null);
    }

    /**
     * Adds the given annotation to the annotation bag.
     *
     * @param annotation the annotation to add
     */
    public void add(Annotation annotation) {
        if (fAnnotations is null)
            fAnnotations= new HashSet(2);
        fAnnotations.add(annotation);
    }

    /**
     * Removes the given annotation from the annotation bag.
     *
     * @param annotation the annotation to remove
     */
    public void remove(Annotation annotation) {
        if (fAnnotations !is null) {
            fAnnotations.remove(annotation);
            if (fAnnotations.isEmpty())
                fAnnotations= null;
        }
    }

    /**
     * Returns whether the annotation bag is empty.
     *
     * @return <code>true</code> if the annotation bag is empty, <code>false</code> otherwise
     */
    public bool isEmpty() {
        return fAnnotations is null;
    }

    /**
     * Returns an iterator for all annotation inside this
     * annotation bag or <code>null</code> if the bag is empty.
     *
     * @return an iterator for all annotations in the bag or <code>null</code>
     * @since 3.1
     */
    public Iterator iterator() {
        if (!isEmpty())
            return fAnnotations.iterator();
        return null;
    }
}
