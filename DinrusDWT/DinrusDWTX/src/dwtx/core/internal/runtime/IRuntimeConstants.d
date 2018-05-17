/*******************************************************************************
 * Copyright (c) 2005, 2006 IBM Corporation and others.
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
module dwtx.core.internal.runtime.IRuntimeConstants;

import dwt.dwthelper.utils;

public interface IRuntimeConstants {

    /**
     * The unique identifier constant (value "<code>dwtx.core.runtime</code>")
     * of the Core Runtime (pseudo-) plug-in.
     */
    public static const String PI_RUNTIME = "dwtx.core.runtime"; //$NON-NLS-1$

    /**
     * Name of this bundle.
     */
    public static const String PI_COMMON = "dwtx.equinox.common"; //$NON-NLS-1$

    /**
     * Status code constant (value 2) indicating an error occurred while running a plug-in.
     */
    public static const int PLUGIN_ERROR = 2;

    /**
     * Status code constant (value 5) indicating the platform could not write
     * some of its metadata.
     */
    public static const int FAILED_WRITE_METADATA = 5;

}
