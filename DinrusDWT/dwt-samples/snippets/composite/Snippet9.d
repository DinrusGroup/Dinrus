/*******************************************************************************
 * Copyright (c) 2000, 2004 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 * D Port
 *     Jesse Phillips <Jesse.K.Phillips+D> gmail.com
 *******************************************************************************/
module composite.Snippit9;

/*
 * Composite example snippet: scroll a child control automatically
 *
 * For a list of all DWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 */
import dwt.DWT;
import dwt.events.PaintListener;
import dwt.graphics.Color;
import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwt.widgets.Composite;
import dwt.widgets.Display;
import dwt.widgets.Event;
import dwt.widgets.Listener;
import dwt.widgets.ScrollBar;
import dwt.widgets.Shell;
import dwt.dwthelper.utils;

void main () {
    auto display = new Display ();
    auto shell = new Shell
       (display, DWT.SHELL_TRIM | DWT.H_SCROLL | DWT.V_SCROLL);
    auto composite = new Composite (shell, DWT.BORDER);
    composite.setSize (700, 600);
    auto red = display.getSystemColor (DWT.COLOR_RED);
    composite.addPaintListener (new class PaintListener {
        public void paintControl (PaintEvent e) {
            e.gc.setBackground (red);
            e.gc.fillOval (5, 5, 690, 590);
        }
    });
    auto hBar = shell.getHorizontalBar ();
    hBar.addListener (DWT.Selection, new class Listener {
        public void handleEvent (Event e) {
            auto location = composite.getLocation ();
            location.x = -hBar.getSelection ();
            composite.setLocation (location);
        }
    });
    ScrollBar vBar = shell.getVerticalBar ();
    vBar.addListener (DWT.Selection, new class Listener {
        public void handleEvent (Event e) {
            Point location = composite.getLocation ();
            location.y = -vBar.getSelection ();
            composite.setLocation (location);
        }
    });
    shell.addListener (DWT.Resize,  new class Listener {
        public void handleEvent (Event e) {
            Point size = composite.getSize ();
            Rectangle rect = shell.getClientArea ();
            hBar.setMaximum (size.x);
            vBar.setMaximum (size.y);
            hBar.setThumb (Math.min (size.x, rect.width));
            vBar.setThumb (Math.min (size.y, rect.height));
            int hPage = size.x - rect.width;
            int vPage = size.y - rect.height;
            int hSelection = hBar.getSelection ();
            int vSelection = vBar.getSelection ();
            Point location = composite.getLocation ();
            if (hSelection >= hPage) {
                if (hPage <= 0) hSelection = 0;
                location.x = -hSelection;
            }
            if (vSelection >= vPage) {
                if (vPage <= 0) vSelection = 0;
                location.y = -vSelection;
            }
            composite.setLocation (location);
        }
    });
    shell.open ();
    while (!shell.isDisposed()) {
        if (!display.readAndDispatch ()) display.sleep ();
    }
    display.dispose ();
}
