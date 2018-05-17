/*******************************************************************************
 * Copyright (c) 2000, 2004 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *******************************************************************************/
module scale.Snippet45;

import dwt.DWT;
import dwt.widgets.Display;
import dwt.widgets.Shell;
import dwt.widgets.Scale;

import dwt.dwthelper.utils;


public static void main (String [] args) {
    Display display = new Display ();
    Shell shell = new Shell (display);
    Scale scale = new Scale (shell, DWT.BORDER);
    scale.setSize (200, 64);
    scale.setMaximum (40);
    scale.setPageIncrement (5);
    shell.open ();
    while (!shell.isDisposed ()) {
        if (!display.readAndDispatch ()) display.sleep ();
    }
    display.dispose ();
}

