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
module dwtx.jface.text.source.projection.IProjectionPosition;

import dwtx.jface.text.source.projection.ProjectionViewer; // packageimport
import dwtx.jface.text.source.projection.ProjectionSupport; // packageimport
import dwtx.jface.text.source.projection.AnnotationBag; // packageimport
import dwtx.jface.text.source.projection.ProjectionSummary; // packageimport
import dwtx.jface.text.source.projection.ProjectionAnnotationHover; // packageimport
import dwtx.jface.text.source.projection.ProjectionRulerColumn; // packageimport
import dwtx.jface.text.source.projection.ProjectionAnnotationModel; // packageimport
import dwtx.jface.text.source.projection.SourceViewerInformationControl; // packageimport
import dwtx.jface.text.source.projection.IProjectionListener; // packageimport
import dwtx.jface.text.source.projection.ProjectionAnnotation; // packageimport


import dwt.dwthelper.utils;

import dwtx.jface.text.BadLocationException;
import dwtx.jface.text.IDocument;
import dwtx.jface.text.IRegion;


/**
 * An <code>IProjectionPosition</code> is a position that is associated with a
 * <code>ProjectionAnnotation</code> and that is able to compute its collapsed
 * regions. That is, if a <code>Position</code> implements this interface,
 * <code>ProjectionViewer</code> will delegate to the
 * {@link #computeProjectionRegions(IDocument) computeProjectionRegions} method
 * when determining the document regions that should be collapsed for a certain
 * <code>ProjectionAnnotation</code>.
 *
 * @since 3.1
 */
public interface IProjectionPosition {

    /**
     * Returns an array of regions that should be collapsed when the annotation
     * belonging to this position is collapsed. May return null instead of
     * an empty array.
     *
     * @param document the document that this position is attached to
     * @return the foldable regions for this position
     * @throws BadLocationException if accessing the document fails
     */
    IRegion[] computeProjectionRegions(IDocument document) ;

    /**
     * Returns the offset of the caption (the anchor region) of this projection
     * position. The returned offset is relative to the receivers offset into
     * the document.
     *
     * @param document the document that this position is attached to
     * @return the caption offset relative to the position's offset
     * @throws BadLocationException if accessing the document fails
     */
    int computeCaptionOffset(IDocument document) ;

}
