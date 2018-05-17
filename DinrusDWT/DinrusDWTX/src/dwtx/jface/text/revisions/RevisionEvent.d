/*******************************************************************************
 * Copyright (c) 2006, 2008 IBM Corporation and others.
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
module dwtx.jface.text.revisions.RevisionEvent;

import dwtx.jface.text.revisions.IRevisionListener; // packageimport
import dwtx.jface.text.revisions.IRevisionRulerColumnExtension; // packageimport
import dwtx.jface.text.revisions.RevisionRange; // packageimport
import dwtx.jface.text.revisions.IRevisionRulerColumn; // packageimport
import dwtx.jface.text.revisions.RevisionInformation; // packageimport
import dwtx.jface.text.revisions.Revision; // packageimport


import dwt.dwthelper.utils;

import dwtx.core.runtime.Assert;


/**
 * Informs about a change of revision information.
 * <p>
 * Clients may use but not instantiate this class.
 * </p>
 * 
 * @since 3.3
 * @noinstantiate This class is not intended to be instantiated by clients.
 */
public final class RevisionEvent {
    
    private const RevisionInformation fInformation;

    /**
     * Creates a new event.
     * 
     * @param information the revision info
     */
    public this(RevisionInformation information) {
        Assert.isLegal(information !is null);
        fInformation= information;
    }

    /**
     * Returns the revision information that has changed.
     * 
     * @return the revision information that has changed
     */
    public RevisionInformation getRevisionInformation() {
        return fInformation;
    }
}
