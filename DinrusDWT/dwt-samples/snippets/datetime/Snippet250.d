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
module datetime.Snippet250;

/*
 * DateTime example snippet: create a DateTime calendar and a DateTime time.
 *
 * For a list of all DWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 */
import dwt.DWT;
import dwt.events.SelectionAdapter;
import dwt.events.SelectionEvent;
import dwt.layout.RowLayout;
import dwt.widgets.DateTime;
import dwt.widgets.Display;
import dwt.widgets.Shell;

import dwt.dwthelper.utils;

import tango.io.Stdout;

void main (String [] args) {
    Display display = new Display ();
    Shell shell = new Shell (display);
    shell.setLayout (new RowLayout ());

    DateTime calendar = new DateTime (shell, DWT.CALENDAR);
    calendar.addSelectionListener (new class() SelectionAdapter{
        void widgetSelected (SelectionEvent e) {
            Stdout("calendar date changed\n");
            Stdout.flush();
        }
    });

    DateTime time = new DateTime (shell, DWT.TIME);
    time.addSelectionListener (new class() SelectionAdapter{
        void widgetSelected (SelectionEvent e) {
            Stdout("time changed\n");
            Stdout.flush();
        }
    });

    shell.pack ();
    shell.open ();
    while (!shell.isDisposed ()) {
        if (!display.readAndDispatch ()) display.sleep ();
    }
    display.dispose ();
}

