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
module menu.Snippet97;
 
/*
 * Menu example snippet: fill a menu dynamically (when menu shown)
 * Select items then right click to show menu.
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
import dwt.widgets.Tree;
import dwt.widgets.TreeItem;

import tango.util.Convert;

void main () {
    auto display = new Display ();
    auto shell = new Shell (display);
    auto tree = new Tree (shell, DWT.BORDER | DWT.MULTI);
    auto menu = new Menu (shell, DWT.POP_UP);
    tree.setMenu (menu);
    for (int i=0; i<12; i++) {
        auto item = new TreeItem (tree, DWT.NONE);
        item.setText ("Item " ~ to!(char[])(i));
    }
    menu.addListener (DWT.Show, new class Listener {
        public void handleEvent (Event event) {
            auto menuItems = menu.getItems ();
            foreach (item; menuItems) {
                item.dispose ();
            }
            auto treeItems = tree.getSelection ();
            foreach (item; treeItems) {
                auto menuItem = new MenuItem (menu, DWT.PUSH);
                menuItem.setText (item.getText ());
            }
        }
    });
    tree.setSize (200, 200);
    shell.setSize (300, 300);
    shell.open ();
    while (!shell.isDisposed ()) {
        if (!display.readAndDispatch ()) display.sleep ();
    }
    display.dispose ();
}
