/*******************************************************************************
 * Copyright (c) 2000, 2006 IBM Corporation and others.
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
module button.Snippet224;

/*
 * implement radio behavior for setSelection()
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 *
 * @since 3.2
 */

import dwt.DWT;
import dwt.widgets.Button;
import dwt.widgets.Control;
import dwt.widgets.Display;
import dwt.widgets.Event;
import dwt.widgets.Listener;
import dwt.widgets.Shell;
import dwt.layout.RowLayout;

import dwt.dwthelper.utils;
import tango.util.Convert;

void main(String[] args){
    Snippet224.main(args);
}


public class Snippet224 {
    public static void main (String [] args) {
        Display display = new Display ();
        Shell shell = new Shell (display);
        shell.setLayout (new RowLayout (DWT.VERTICAL));
        for (int i=0; i<8; i++) {
            Button button = new Button (shell, DWT.RADIO);
            button.setText ("B" ~ to!(char[])(i));
            if (i == 0) button.setSelection (true);
        }
        Button button = new Button (shell, DWT.PUSH);
        button.setText ("Set Selection to B4");
        button.addListener (DWT.Selection, new class() Listener{
            public void handleEvent (Event event) {
                Control [] children = shell.getChildren ();
                Button newButton = cast(Button) children [4];
                for (int i=0; i<children.length; i++) {
                    Control child = children [i];
                    if ( cast(Button)child !is null && (child.getStyle () & DWT.RADIO) != 0) {
                        (cast(Button)child).setSelection (false);
                    }
                }
                newButton.setSelection (true);
            }
        });
        shell.pack ();
        shell.open ();
        while (!shell.isDisposed ()) {
            if (!display.readAndDispatch ()) display.sleep ();
        }
        display.dispose ();
    }
}
