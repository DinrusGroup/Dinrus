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
module datetime.Snippet251;

/*
 * DateTime example snippet: create a DateTime calendar, date, and time in a dialog.
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 */
import dwt.DWT;
import dwt.events.SelectionAdapter;
import dwt.events.SelectionEvent;
import dwt.layout.FillLayout;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.widgets.Button;
import dwt.widgets.DateTime;
import dwt.widgets.Dialog;
import dwt.widgets.Display;
import dwt.widgets.Label;
import dwt.widgets.Shell;

import dwt.dwthelper.utils;

import tango.io.Stdout;

void main (String [] args) {
    /* These cannot be local in the
     * listener, hence we put it here and not at the
     * constructor. (THD)
     * (dmd.1.028)
     */
    DateTime calendar, date, time;
    Shell dialog;

    Display display = new Display ();
    Shell shell = new Shell (display);
    shell.setLayout(new FillLayout());

    Button open = new Button (shell, DWT.PUSH);
    open.setText ("Open Dialog");
    open.addSelectionListener (new class() SelectionAdapter{
        public void widgetSelected (SelectionEvent e) {
            dialog = new Shell (shell, DWT.DIALOG_TRIM);
            dialog.setLayout (new GridLayout (3, false));

            calendar = new DateTime (dialog, DWT.CALENDAR | DWT.BORDER);
            date = new DateTime (dialog, DWT.DATE | DWT.SHORT);
            time = new DateTime (dialog, DWT.TIME | DWT.SHORT);

            new Label (dialog, DWT.NONE);
            new Label (dialog, DWT.NONE);
            Button ok = new Button (dialog, DWT.PUSH);
            ok.setText ("OK");
            ok.setLayoutData(new GridData (DWT.FILL, DWT.CENTER, false, false));
            ok.addSelectionListener (new class() SelectionAdapter{
                void widgetSelected (SelectionEvent e) {
                    Stdout.formatln("Calendar date selected (MM/DD/YYYY) = {:d02}/{:d02}/{:d04}",
                                    (calendar.getMonth () + 1),calendar.getDay (),calendar.getYear ());
                    Stdout.formatln("Date selected (MM/YYYY)= {:d02}/{:d04}",
                                    (date.getMonth () + 1), date.getYear ());
                    Stdout.formatln("Time selected (HH:MM) = {:d02}:{:d02}",
                                    time.getHours(), time.getMinutes());
                    Stdout.flush();
                    dialog.close ();
                }
            });
            dialog.setDefaultButton (ok);
            dialog.pack ();
            dialog.open ();
        }
    });
    shell.pack ();
    shell.open ();

    while (!shell.isDisposed ()) {
        if (!display.readAndDispatch ()) display.sleep ();
    }
    display.dispose ();
}

