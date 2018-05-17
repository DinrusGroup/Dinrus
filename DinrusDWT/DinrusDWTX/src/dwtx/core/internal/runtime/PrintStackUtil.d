/*******************************************************************************
 * Copyright (c) 2008 IBM Corporation and others.
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
module dwtx.core.internal.runtime.PrintStackUtil;

import dwtx.core.runtime.IStatus;
import tango.io.stream.Format;
import dwt.dwthelper.utils;

public class PrintStackUtil {

    static public void printChildren(IStatus status, FormatOutput!(char) output) {
        IStatus[] children = status.getChildren();
        if (children is null || children.length is 0)
            return;
        for (int i = 0; i < children.length; i++) {
            output.formatln("Contains: {}", children[i].getMessage()); //$NON-NLS-1$
            Exception exception = children[i].getException();
            if (exception !is null)
                ExceptionPrintStackTrace(exception);
            printChildren(children[i], output);
        }
    }

//     static public void printChildren(IStatus status, FormatOutput!(char) output) {
//         IStatus[] children = status.getChildren();
//         if (children is null || children.length is 0)
//             return;
//         for (int i = 0; i < children.length; i++) {
//             output.formatln( "Contains: {}", children[i].getMessage()); //$NON-NLS-1$
//             output.flush(); // call to synchronize output
//             Exception exception = children[i].getException();
//             if (exception !is null)
//                 ExceptionPrintStackTrace(exception);
//             printChildren(children[i], output);
//         }
//     }

}
