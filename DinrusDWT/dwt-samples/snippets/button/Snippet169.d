/*******************************************************************************
 * Copyright (c) 2000, 2005 IBM Corporation and others.
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
module button.Snippet169;

/*
 * Make a toggle button have radio behavior
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 *
 * Port OK.
 */

import dwt.DWT;
import dwt.widgets.Button;
import dwt.widgets.Control;
import dwt.widgets.Display;
import dwt.widgets.Event;
import dwt.widgets.Shell;
import dwt.widgets.Listener;
import dwt.layout.FillLayout;

import dwt.dwthelper.utils;
import tango.util.Convert;

void main(String[] args){
    Snippet169.main(args);
}


public class Snippet169 {
    public static void main (String [] args) {
        Display display = new Display ();
        final Shell shell = new Shell (display);
        shell.setLayout (new FillLayout ());
        Listener listener = new class() Listener {
            public void handleEvent (Event e) {
                Control [] children = shell.getChildren ();
                for (int i=0; i<children.length; i++) {
                    Control child = children [i];
                    if (e.widget !is child && cast(Button)child !is null && (child.getStyle () & DWT.TOGGLE) != 0) {
                        (cast(Button) child).setSelection (false);
                    }
                }
                (cast(Button) e.widget).setSelection (true);
            }
        };
        for (int i=0; i<20; i++) {
            Button button = new Button (shell, DWT.TOGGLE);
            button.setText ("B" ~to!(char[])(i));
            button.addListener (DWT.Selection, listener);
            if (i == 0) button.setSelection (true);
        }
        shell.pack ();
        shell.open ();
        while (!shell.isDisposed ()) {
            if (!display.readAndDispatch ()) display.sleep ();
        }
        display.dispose ();
    }
}
