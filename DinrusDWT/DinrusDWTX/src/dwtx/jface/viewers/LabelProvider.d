/*******************************************************************************
 * Copyright (c) 2000, 2006 IBM Corporation and others.
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
module dwtx.jface.viewers.LabelProvider;

import dwtx.jface.viewers.BaseLabelProvider;
import dwtx.jface.viewers.ILabelProvider;

import dwt.graphics.Image;

import dwt.dwthelper.utils;

/**
 * A label provider implementation which, by default, uses an element's
 * <code>toString</code> value for its text and <code>null</code> for its
 * image.
 * <p>
 * This class may be used as is, or subclassed to provide richer labels.
 * Subclasses may override any of the following methods:
 * <ul>
 * <li><code>isLabelProperty</code></li>
 * <li><code>getImage</code></li>
 * <li><code>getText</code></li>
 * <li><code>dispose</code></li>
 * </ul>
 * </p>
 */
public class LabelProvider : BaseLabelProvider, ILabelProvider {

    /**
     * Creates a new label provider.
     */
    public this() {
    }


    /**
     * The <code>LabelProvider</code> implementation of this
     * <code>ILabelProvider</code> method returns <code>null</code>.
     * Subclasses may override.
     */
    public Image getImage(Object element) {
        return null;
    }

    /**
     * The <code>LabelProvider</code> implementation of this
     * <code>ILabelProvider</code> method returns the element's
     * <code>toString</code> string. Subclasses may override.
     */
    public String getText(Object element) {
        return element is null ? "" : element.toString();//$NON-NLS-1$
    }
}
