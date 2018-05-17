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
module dwtx.draw2d.AccessibleBase;

import dwt.dwthelper.utils;

/**
 * The base class for accessible objects which provides accesibilty clients with a unique
 * ID.
 */
public class AccessibleBase {

/**
 * Returns the id of this accessible object using {@link Object#toHash()}.  
 * @return the id
 */
public final int getAccessibleID() {
    /* This assumes that the native implementation of toHash in Object is to
     * return the pointer to the Object, which should be U-unique.
     */
    int value = super.toHash();
    /*
     * Values -3, -2, and -1 are reserved by DWT's ACC class to have special meaning.
     * Therefore, a child cannot have this value.
     */
    if (value < 0)
        value -= 4;
    return value;
}

}
