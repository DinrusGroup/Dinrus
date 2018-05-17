/*******************************************************************************
 * Copyright (c) 2000, 2004 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 * D Port:
 *     Thomas Demmer <t_demmer AT web DOT de>
 *******************************************************************************/
module caret.Snippet74;

/*
 * Caret example snippet: create a caret
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 */
import dwt.DWT;
import dwt.widgets.Caret;
import dwt.widgets.Display;
import dwt.widgets.Shell;

import dwt.dwthelper.utils;

void main (String [] args) {
    Display display = new Display ();
    Shell shell = new Shell (display);
    Caret caret = new Caret (shell, DWT.NONE);
    caret.setBounds (10, 10, 2, 32);
    shell.open ();
    while (!shell.isDisposed ()) {
        if (!display.readAndDispatch ()) display.sleep ();
    }
    display.dispose ();
}

