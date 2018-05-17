/*******************************************************************************
 * Copyright (c) 2005 IBM Corporation and others.
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
module dwtx.core.internal.commands.operations.GlobalUndoContext;

import dwtx.core.commands.operations.IUndoContext;

import dwt.dwthelper.utils;

/**
 * <p>
 * An operation context that matches to any context.  It can be used to
 * get an unfiltered (global) history.
 * </p>
 *
 * @since 3.1
 */
public class GlobalUndoContext : IUndoContext {

    /* (non-Javadoc)
     * @see dwtx.core.commands.operations.IUndoContext#getLabel()
     */
    public String getLabel() {
        return "Global Undo Context"; //$NON-NLS-1$
    }

    /* (non-Javadoc)
     * @see dwtx.core.commands.operations.IUndoContext#matches(IUndoContext context)
     */
    public bool matches(IUndoContext context) {
        return true;
    }
}
