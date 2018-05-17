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
 *     Bill Baxter <wbaxter> at gmail com
 *******************************************************************************/
module tabfolder.Snippet76;

/*
 * TabFolder example snippet: create a tab folder (six pages)
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 */
import dwt.DWT;
import dwt.widgets.Display;
import dwt.widgets.Shell;
import dwt.widgets.TabFolder;
import dwt.widgets.TabItem;
import dwt.widgets.Button;

import tango.util.Convert;

void main () {
	Display display = new Display ();
	final Shell shell = new Shell (display);
	final TabFolder tabFolder = new TabFolder (shell, DWT.BORDER);
	for (int i=0; i<6; i++) {
		TabItem item = new TabItem (tabFolder, DWT.NONE);
		item.setText ("TabItem " ~ to!(char[])(i));
		Button button = new Button (tabFolder, DWT.PUSH);
		button.setText ("Page " ~ to!(char[])(i));
		item.setControl (button);
	}
	tabFolder.pack ();
	shell.pack ();
	shell.open ();
	while (!shell.isDisposed ()) {
		if (!display.readAndDispatch ()) display.sleep ();
	}
	display.dispose ();
}

