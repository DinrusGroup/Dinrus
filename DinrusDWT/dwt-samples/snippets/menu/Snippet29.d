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
 *     Jesse Phillips <Jesse.K.Phillips+D> gmail.com
 *******************************************************************************/
module menu.Snippet29;

/*
 * Menu example snippet: create a bar and pull down menu (accelerators, mnemonics)
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 */
import dwt.DWT;
import dwt.widgets.Display;
import dwt.widgets.Event;
import dwt.widgets.Listener;
import dwt.widgets.Menu;
import dwt.widgets.MenuItem;
import dwt.widgets.Shell;

import tango.io.Stdout;

void main () {
    auto display = new Display ();
    auto shell = new Shell (display);
    auto bar = new Menu (shell, DWT.BAR);
    shell.setMenuBar (bar);
    auto fileItem = new MenuItem (bar, DWT.CASCADE);
    fileItem.setText ("&File");
    auto submenu = new Menu (shell, DWT.DROP_DOWN);
    fileItem.setMenu (submenu);
    auto item = new MenuItem (submenu, DWT.PUSH);
    item.addListener (DWT.Selection, new class Listener {
        public void handleEvent (Event e) {
            Stdout("Select All").newline;
        }
    });
    item.setText ("Select &All\tCtrl+A");
    item.setAccelerator (DWT.CTRL + 'A');
    shell.setSize (200, 200);
    shell.open ();
    while (!shell.isDisposed()) {
        if (!display.readAndDispatch ()) display.sleep ();
    }
    display.dispose ();
}
