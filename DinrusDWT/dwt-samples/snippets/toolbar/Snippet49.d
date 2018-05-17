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
module toolbar.Snippet49;

/*
 * ToolBar example snippet: create tool bar (wrap on resize)
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 */
import dwt.DWT;
import dwt.graphics.Rectangle;
import dwt.graphics.Point;
import dwt.widgets.Display;
import dwt.widgets.Shell;
import dwt.widgets.ToolBar;
import dwt.widgets.ToolItem;
import dwt.widgets.Event;
import dwt.widgets.Listener;

import tango.util.Convert;

void main () {
	Display display = new Display ();
	Shell shell = new Shell (display);
	ToolBar toolBar = new ToolBar (shell, DWT.WRAP);
	for (int i=0; i<12; i++) {
		ToolItem item = new ToolItem (toolBar, DWT.PUSH);
		item.setText ("Item " ~ to!(char[])(i));
	}
	shell.addListener (DWT.Resize, new class Listener {
		void handleEvent (Event e) {
			Rectangle rect = shell.getClientArea ();
			Point size = toolBar.computeSize (rect.width, DWT.DEFAULT);
			toolBar.setSize (size);
		}
	});
	toolBar.pack ();
	shell.pack ();
	shell.open ();
	while (!shell.isDisposed ()) {
		if (!display.readAndDispatch ()) display.sleep ();
	}
	display.dispose ();
}

