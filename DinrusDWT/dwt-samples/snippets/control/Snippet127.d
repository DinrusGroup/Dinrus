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
module control.Snippet127;

/*
 * Control example snippet: prevent Tab from traversing out of a control
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 */
import dwt.DWT;
import dwt.events.TraverseEvent;
import dwt.events.TraverseListener;
import dwt.widgets.Button;
import dwt.widgets.Display;
import dwt.widgets.Event;
import dwt.widgets.Listener;
import dwt.widgets.Shell;
import dwt.layout.RowLayout;

import dwt.dwthelper.utils;

void main (String [] args) {
    Display display = new Display ();
    Shell shell = new Shell (display);
    shell.setLayout(new RowLayout ());
    Button button1 = new Button(shell, DWT.PUSH);
    button1.setText("Can't Traverse");
    button1.addTraverseListener(new class() TraverseListener{
        public void keyTraversed(TraverseEvent e) {
            switch (e.detail) {
            case DWT.TRAVERSE_TAB_NEXT:
            case DWT.TRAVERSE_TAB_PREVIOUS: {
                    e.doit = false;
                }
            }
        }
    });
    Button button2 = new Button (shell, DWT.PUSH);
    button2.setText("Can Traverse");
    shell.pack ();
    shell.open();
    while (!shell.isDisposed ()) {
        if (!display.readAndDispatch ()) display.sleep ();
    }
    display.dispose ();
}

