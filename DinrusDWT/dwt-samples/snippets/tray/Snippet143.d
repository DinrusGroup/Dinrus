/*******************************************************************************
 * Copyright (c) 2000, 2005 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 * Port to the D programming language
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/
module tray.Snippet143;

/*
 * Tray example snippet: place an icon with a popup menu on the system tray
 *
 * For a list of all DWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 *
 * @since 3.0
 */
import dwt.DWT;
import dwt.graphics.Image;
import dwt.widgets.Shell;
import dwt.widgets.Display;
import dwt.widgets.Menu;
import dwt.widgets.MenuItem;
import dwt.widgets.Tray;
import dwt.widgets.TrayItem;
import dwt.widgets.Listener;
import dwt.widgets.Event;
import tango.io.Stdout;
import tango.text.convert.Format;

TrayItem item;
Menu menu;

public static void main(char[][] args) {
    Display display = new Display ();
    Shell shell = new Shell (display);
    Image image = new Image (display, 16, 16);
    final Tray tray = display.getSystemTray ();
    if (tray is null) {
        Stdout.formatln ("The system tray is not available");
    } else {
        item = new TrayItem (tray, DWT.NONE);
        item.setToolTipText("DWT TrayItem");
        item.addListener (DWT.Show, new class() Listener {
            public void handleEvent (Event event) {
                Stdout.formatln("show");
            }
        });
        item.addListener (DWT.Hide, new class() Listener {
            public void handleEvent (Event event) {
                Stdout.formatln("hide");
            }
        });
        item.addListener (DWT.Selection, new class() Listener {
            public void handleEvent (Event event) {
                Stdout.formatln("selection");
            }
        });
        item.addListener (DWT.DefaultSelection, new class() Listener {
            public void handleEvent (Event event) {
                Stdout.formatln("default selection");
            }
        });
        menu = new Menu (shell, DWT.POP_UP);
        for (int i = 0; i < 8; i++) {
            MenuItem mi = new MenuItem (menu, DWT.PUSH);
            mi.setText ( Format( "Item{}", i ));
            mi.addListener (DWT.Selection, new class() Listener {
                public void handleEvent (Event event) {
                    Stdout.formatln("selection {}", event.widget);
                }
            });
            if (i == 0) menu.setDefaultItem(mi);
        }
        item.addListener (DWT.MenuDetect, new class() Listener {
            public void handleEvent (Event event) {
                menu.setVisible (true);
            }
        });
        item.setImage (image);
    }
    shell.setBounds(50, 50, 300, 200);
    shell.open ();
    while (!shell.isDisposed ()) {
        if (!display.readAndDispatch ()) display.sleep ();
    }
    image.dispose ();
    display.dispose ();
}

