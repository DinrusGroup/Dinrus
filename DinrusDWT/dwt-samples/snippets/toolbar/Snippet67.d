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
module toolbar.Snippet67;

/*
 * ToolBar example snippet: place a drop down menu in a tool bar
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
import dwt.widgets.Menu;
import dwt.widgets.MenuItem;
import dwt.widgets.Listener;
import dwt.widgets.Event;

import tango.util.Convert;

void main () {
    Display display = new Display ();
    Shell shell = new Shell (display);
    ToolBar toolBar = new ToolBar (shell, DWT.NONE);
    Menu menu = new Menu (shell, DWT.POP_UP);
    for (int i=0; i<8; i++) {
        MenuItem item = new MenuItem (menu, DWT.PUSH);
        item.setText ("Item " ~ to!(char[])(i));
    }
    ToolItem item = new ToolItem (toolBar, DWT.DROP_DOWN);
    item.addListener (DWT.Selection, new class Listener {
        void handleEvent (Event event) {
            if (event.detail == DWT.ARROW) {
                Rectangle rect = item.getBounds ();
                Point pt = new Point (rect.x, rect.y + rect.height);
                pt = toolBar.toDisplay (pt);
                menu.setLocation (pt.x, pt.y);
                menu.setVisible (true);
            }
        }
    });
    toolBar.pack ();
    shell.pack ();
    shell.open ();
    while (!shell.isDisposed ()) {
        if (!display.readAndDispatch ()) display.sleep ();
    }
    menu.dispose ();
    display.dispose ();
}
