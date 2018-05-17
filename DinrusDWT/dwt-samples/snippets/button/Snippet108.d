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
module button.Snippet108;
/*
 * Button example snippet: set the default button
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 */
import dwt.DWT;
import dwt.widgets.Button;
import dwt.widgets.Display;
import dwt.widgets.Label;
import dwt.widgets.Shell;
import dwt.widgets.Text;
import dwt.events.SelectionAdapter;
import dwt.events.SelectionEvent;
import dwt.layout.RowLayout;
import dwt.layout.RowData;

import dwt.dwthelper.utils;
import tango.io.Stdout;

void main(String[] args){
    Snippet108.main(args);
}

public class Snippet108 {

    public static void main (String [] args) {
        Display display = new Display ();
        Shell shell = new Shell (display);
        Label label = new Label (shell, DWT.NONE);
        label.setText ("Enter your name:");
        Text text = new Text (shell, DWT.BORDER);
        text.setLayoutData (new RowData (100, DWT.DEFAULT));
        Button ok = new Button (shell, DWT.PUSH);
        ok.setText ("OK");
        ok.addSelectionListener(new class() SelectionAdapter {
            public void widgetSelected(SelectionEvent e) {
                Stdout.formatln("OK");
            }
        });
        Button cancel = new Button (shell, DWT.PUSH);
        cancel.setText ("Cancel");
        cancel.addSelectionListener(new class() SelectionAdapter {
            public void widgetSelected(SelectionEvent e) {
                Stdout.formatln("Cancel");
            }
        });
        shell.setDefaultButton (cancel);
        shell.setLayout (new RowLayout ());
        shell.pack ();
        shell.open ();
        while (!shell.isDisposed ()) {
            if (!display.readAndDispatch ()) display.sleep ();
        }
        display.dispose ();
    }
}

