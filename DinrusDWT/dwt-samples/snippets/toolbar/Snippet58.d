/*******************************************************************************
 * Copyright (c) 2000, 2004 IBM Corporation and others.
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
module toolbar.Snippet58;

/*
 * ToolBar example snippet: place a combo box in a tool bar
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 */
import dwt.DWT;
import dwt.widgets.Display;
import dwt.widgets.Shell;
import dwt.widgets.ToolBar;
import dwt.widgets.ToolItem;
import dwt.widgets.Combo;

import tango.util.Convert;

void main () {
    Display display = new Display ();
    Shell shell = new Shell (display);
    ToolBar bar = new ToolBar (shell, DWT.BORDER);
    for (int i=0; i<4; i++) {
        ToolItem item = new ToolItem (bar, 0);
        item.setText ("Item " ~ to!(char[])(i));
    }
    ToolItem sep = new ToolItem (bar, DWT.SEPARATOR);
    int start = bar.getItemCount ();
    for (int i=start; i<start+4; i++) {
        ToolItem item = new ToolItem (bar, 0);
        item.setText ("Item " ~ to!(char[])(i));
    }
    Combo combo = new Combo (bar, DWT.READ_ONLY);
    for (int i=0; i<4; i++) {
        combo.add ("Item " ~ to!(char[])(i));
    }
    combo.pack ();
    sep.setWidth (combo.getSize ().x);
    sep.setControl (combo);
    bar.pack ();
    shell.pack ();
    shell.open ();
    while (!shell.isDisposed ()) {
        if (!display.readAndDispatch ()) display.sleep ();
    }
    display.dispose ();
}

