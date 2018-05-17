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
module combo.Snippet24;

/*
 * example snippet: detect CR in a text or combo control (default selection)
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 */
import dwt.DWT;
import dwt.widgets.Combo;
import dwt.widgets.Display;
import dwt.widgets.Event;
import dwt.widgets.Listener;
import dwt.widgets.Shell;
import dwt.widgets.Text;
import dwt.layout.RowLayout;

import dwt.dwthelper.utils;
import tango.io.Stdout;

void main (String [] args) {
    Display display = new Display ();
    Shell shell = new Shell (display);
    shell.setLayout (new RowLayout ());
    Combo combo = new Combo (shell, DWT.NONE);
    combo.setItems (["A-1", "B-1", "C-1"]);
    Text text = new Text (shell, DWT.SINGLE | DWT.BORDER);
    text.setText ("some text");
    combo.addListener (DWT.DefaultSelection, new class() Listener{
        public void handleEvent (Event e) {
            Stdout(e.widget.toString() ~ " - Default Selection\n");
        }
    });
    text.addListener (DWT.DefaultSelection, new class() Listener{
        public void handleEvent (Event e) {
            Stdout(e.widget.toString() ~ " - Default Selection\n");
        }
    });
    shell.pack ();
    shell.open ();
    while (!shell.isDisposed()) {
        if (!display.readAndDispatch ()) display.sleep ();
    }
    display.dispose ();
}
