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
module dwtx.jface.text.ITypedRegion;

import dwtx.jface.text.IRegion; // packageimport

import dwt.dwthelper.utils;



/**
 * Describes a region of an indexed text store such as a document or a string.
 * The region consists of offset, length, and type. The region type is defined
 * as a string.
 * <p>
 * A typed region can, e.g., be used to described document partitions.</p>
 * <p>
 * Clients may implement this interface or use the standard implementation
 * {@link dwtx.jface.text.TypedRegion}.</p>
 */
public interface ITypedRegion : IRegion {

    /**
     * Returns the content type of the region.
     *
     * @return the content type of the region
     */
    String getType();
}
