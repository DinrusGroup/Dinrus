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
module composite.Snippet115;

/*
 * Composite example snippet: force radio behavior on two different composites
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 */
import dwt.DWT;
import dwt.widgets.Button;
import dwt.widgets.Composite;
import dwt.widgets.Control;
import dwt.widgets.Display;
import dwt.widgets.Event;
import dwt.widgets.Listener;
import dwt.widgets.Shell;
import dwt.layout.RowLayout;

import dwt.dwthelper.utils;
import tango.util.Convert;

void main (String [] args) {
    Display display = new Display ();
    Shell shell = new Shell (display);
    shell.setLayout (new RowLayout (DWT.VERTICAL));
    Composite c1 = new Composite (shell, DWT.BORDER | DWT.NO_RADIO_GROUP);
    c1.setLayout (new RowLayout ());
    Composite c2 = new Composite (shell, DWT.BORDER | DWT.NO_RADIO_GROUP);
    c2.setLayout (new RowLayout ());
    Composite [] composites = [c1, c2];
    Listener radioGroup = new class() Listener{
        public void handleEvent (Event event) {
            for (int i=0; i<composites.length; i++) {
                Composite composite = composites [i];
                Control [] children = composite.getChildren ();
                for (int j=0; j<children.length; j++) {
                    Control child = children [j];
                    if (cast(Button)child !is  null) {
                        Button button = cast(Button) child;
                        if ((button.getStyle () & DWT.RADIO) != 0) button.setSelection (false);
                    }
                }
            }
            Button button = cast(Button) event.widget;
            button.setSelection (true);
        }
    };
    for (int i=0; i<4; i++) {
        Button button = new Button (c1, DWT.RADIO);
        button.setText ("Button " ~ to!(char[])(i));
        button.addListener (DWT.Selection, radioGroup);
    }
    for (int i=0; i<4; i++) {
        Button button = new Button (c2, DWT.RADIO);
        button.setText ("Button " ~to!(char[])(i + 4));
        button.addListener (DWT.Selection, radioGroup);
    }
    shell.pack ();
    shell.open ();
    while (!shell.isDisposed()) {
        if (!display.readAndDispatch ()) display.sleep ();
    }
    display.dispose ();
}
