/*******************************************************************************
 * Copyright (c) 2000, 2005 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 * Port to the D programming language:
 *     Bill Baxter <bill@billbaxter.com>
 *******************************************************************************/
module spinner.Snippet184;

/*
 * Spinner example snippet: create and initialize a spinner widget
 * 
 * For a list of all DWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 * 
 * @since 3.1
 */
import dwt.DWT;
import dwt.widgets.Display;
import dwt.widgets.Shell;
import dwt.widgets.Spinner;

void main() {
    Display display = new Display();
    Shell shell = new Shell(display);
    Spinner spinner = new Spinner (shell, DWT.BORDER);
    spinner.setMinimum(0);
    spinner.setMaximum(1000);
    spinner.setSelection(500);
    spinner.setIncrement(1);
    spinner.setPageIncrement(100);
    spinner.pack();
    shell.pack();
    shell.open();
    while (!shell.isDisposed()) {
        if (!display.readAndDispatch())
            display.sleep();
    }
    display.dispose();
}

