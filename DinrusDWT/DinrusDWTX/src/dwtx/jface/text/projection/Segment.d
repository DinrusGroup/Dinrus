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
module dwtx.jface.text.projection.Segment;

import dwtx.jface.text.projection.ProjectionMapping; // packageimport
import dwtx.jface.text.projection.ChildDocumentManager; // packageimport
import dwtx.jface.text.projection.SegmentUpdater; // packageimport
import dwtx.jface.text.projection.ProjectionDocument; // packageimport
import dwtx.jface.text.projection.FragmentUpdater; // packageimport
import dwtx.jface.text.projection.ProjectionDocumentEvent; // packageimport
import dwtx.jface.text.projection.ChildDocument; // packageimport
import dwtx.jface.text.projection.IMinimalMapping; // packageimport
import dwtx.jface.text.projection.Fragment; // packageimport
import dwtx.jface.text.projection.ProjectionTextStore; // packageimport
import dwtx.jface.text.projection.ProjectionDocumentManager; // packageimport


import dwt.dwthelper.utils;

import dwtx.jface.text.Position;


/**
 * Internal class. Do not use. Only public for testing purposes.
 * <p>
 * A segment is the image of a master document fragment in a projection
 * document.
 *
 * @since 3.0
 * @noinstantiate This class is not intended to be instantiated by clients.
 * @noextend This class is not intended to be subclassed by clients.
 */
public class Segment : Position {

    /** The corresponding fragment for this segment. */
    public Fragment fragment;
    /** A flag indicating that the segment updater should stretch this segment when a change happens at its boundaries. */
    public bool isMarkedForStretch_;
    /** A flag indicating that the segment updater should shift this segment when a change happens at its boundaries. */
    public bool isMarkedForShift_;

    /**
     * Creates a new segment covering the given range.
     *
     * @param offset the offset of the segment
     * @param length the length of the segment
     */
    public this(int offset, int length) {
        super(offset, length);
    }

    /**
     * Sets the stretching flag.
     */
    public void markForStretch() {
        isMarkedForStretch_= true;
    }

    /**
     * Returns <code>true</code> if the stretching flag is set, <code>false</code> otherwise.
     * @return <code>true</code> if the stretching flag is set, <code>false</code> otherwise
     */
    public bool isMarkedForStretch() {
        return isMarkedForStretch_;
    }
    public bool isMarkedForStretch(bool v) {
        isMarkedForStretch_ = v;
        return isMarkedForStretch();
    }

    /**
     * Sets the shifting flag.
     */
    public void markForShift() {
        isMarkedForShift_= true;
    }

    /**
     * Returns <code>true</code> if the shifting flag is set, <code>false</code> otherwise.
     * @return <code>true</code> if the shifting flag is set, <code>false</code> otherwise
     */
    public bool isMarkedForShift() {
        return isMarkedForShift_;
    }
    public bool isMarkedForShift(bool v) {
        isMarkedForShift_ = v;
        return isMarkedForShift();
    }

    /**
     * Clears the shifting and the stretching flag.
     */
    public void clearMark() {
        isMarkedForStretch_= false;
        isMarkedForShift_= false;
    }
}
