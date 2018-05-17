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
module combo.Snippet147;
/*
 * Combo example snippet: stop CR from going to the default button
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 */
import dwt.DWT;
import dwt.events.SelectionAdapter;
import dwt.events.SelectionEvent;
import dwt.events.TraverseListener;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.widgets.Button;
import dwt.widgets.Combo;
import dwt.widgets.Display;
import dwt.widgets.Shell;
import dwt.dwthelper.utils;

import tango.io.Stdout;

void main(String[] args) {
    Display display = new Display();
    Shell shell = new Shell(display);
    shell.setLayout(new GridLayout());
    Combo combo = new Combo(shell, DWT.NONE);
    combo.setLayoutData(new GridData(GridData.FILL_HORIZONTAL));
    combo.setText("Here is some text");
    combo.addSelectionListener(new class() SelectionAdapter{
        public void widgetDefaultSelected(SelectionEvent e) {
            Stdout("Combo default selected (overrides default button)\n");
        }
    });
    combo.addTraverseListener(new class() TraverseListener{
        public void keyTraversed(TraverseEvent e) {
            if (e.detail == DWT.TRAVERSE_RETURN) {
                e.doit = false;
                e.detail = DWT.TRAVERSE_NONE;
            }
        }
    });
    Button button = new Button(shell, DWT.PUSH);
    button.setText("Ok");
    button.addSelectionListener(new class() SelectionAdapter{
        public void widgetSelected(SelectionEvent e) {
            Stdout("Button selected\n");
        }
    });
    shell.setDefaultButton(button);
    shell.pack();
    shell.open();
    while (!shell.isDisposed()) {
        if (!display.readAndDispatch())
            display.sleep();
    }
    display.dispose();
}

