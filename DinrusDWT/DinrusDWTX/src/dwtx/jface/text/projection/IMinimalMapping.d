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
module dwtx.jface.text.projection.IMinimalMapping;

import dwtx.jface.text.projection.ProjectionMapping; // packageimport
import dwtx.jface.text.projection.ChildDocumentManager; // packageimport
import dwtx.jface.text.projection.SegmentUpdater; // packageimport
import dwtx.jface.text.projection.Segment; // packageimport
import dwtx.jface.text.projection.ProjectionDocument; // packageimport
import dwtx.jface.text.projection.FragmentUpdater; // packageimport
import dwtx.jface.text.projection.ProjectionDocumentEvent; // packageimport
import dwtx.jface.text.projection.ChildDocument; // packageimport
import dwtx.jface.text.projection.Fragment; // packageimport
import dwtx.jface.text.projection.ProjectionTextStore; // packageimport
import dwtx.jface.text.projection.ProjectionDocumentManager; // packageimport


import dwt.dwthelper.utils;


import dwtx.jface.text.BadLocationException;
import dwtx.jface.text.IRegion;


/**
 * Internal interface for defining the exact subset of
 * {@link dwtx.jface.text.projection.ProjectionMapping} that the
 * {@link dwtx.jface.text.projection.ProjectionTextStore} is allowed to
 * access.
 *
 * @since 3.0
 */
interface IMinimalMapping {

    /*
     * @see dwtx.jface.text.IDocumentInformationMapping#getCoverage()
     */
    IRegion getCoverage();

    /*
     * @see dwtx.jface.text.IDocumentInformationMapping#toOriginRegion(IRegion)
     */
    IRegion toOriginRegion(IRegion region) ;

    /*
     * @see dwtx.jface.text.IDocumentInformationMapping#toOriginOffset(int)
     */
    int toOriginOffset(int offset) ;

    /*
     * @see dwtx.jface.text.IDocumentInformationMappingExtension#toExactOriginRegions(IRegion)
     */
    IRegion[] toExactOriginRegions(IRegion region) ;

    /*
     * @see dwtx.jface.text.IDocumentInformationMappingExtension#getImageLength()
     */
    int getImageLength();
}
