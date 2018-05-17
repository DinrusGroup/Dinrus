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
module control.Snippet247;

/*
 * Control example snippet: allow a multi-line text to process the default button
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 */
import dwt.DWT;
import dwt.events.SelectionAdapter;
import dwt.events.SelectionEvent;
import dwt.events.SelectionListener;
import dwt.events.TraverseEvent;
import dwt.events.TraverseListener;
import dwt.widgets.Button;
import dwt.widgets.Display;
import dwt.widgets.Shell;
import dwt.widgets.Text;
import dwt.layout.RowLayout;

import dwt.dwthelper.utils;

import tango.io.Stdout;

void main (String [] args) {
    Display display = new Display ();
    Shell shell = new Shell (display);
    shell.setLayout(new RowLayout());
    Text text = new Text(shell, DWT.MULTI | DWT.BORDER);
    String modifier = DWT.MOD1 == DWT.CTRL ? "Ctrl" : "Command";
    text.setText("Hit " ~ modifier ~ "+Return\nto see\nthe default button\nrun");
    text.addTraverseListener(new class() TraverseListener{
        public void keyTraversed(TraverseEvent e) {
          switch (e.detail) {
          case DWT.TRAVERSE_RETURN:
              if ((e.stateMask & DWT.MOD1) != 0) e.doit = true;
          default:
          }
        }
    });
    Button button = new Button (shell, DWT.PUSH);
    button.pack();
    button.setText("OK");
    button.addSelectionListener(new class() SelectionAdapter{
        public void widgetSelected(SelectionEvent e) {
            Stdout("OK selected\n");
            Stdout.flush();
        }
    });
    shell.setDefaultButton(button);
    shell.pack ();
    shell.open();
    while (!shell.isDisposed ()) {
        if (!display.readAndDispatch ()) display.sleep ();
    }
    display.dispose ();
}
