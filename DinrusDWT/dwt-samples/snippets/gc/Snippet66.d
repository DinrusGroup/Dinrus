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
module gc.Snippet66;

/*
 * GC example snippet: implement a simple scribble program
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 */
import dwt.DWT;
import dwt.graphics.GC;
import dwt.widgets.Display;
import dwt.widgets.Shell;
import dwt.widgets.Listener;
import dwt.widgets.Event;

void main () {
    Display display = new Display ();
    final Shell shell = new Shell (display);
    Listener listener = new class() Listener {
        int lastX = 0, lastY = 0;
        public void handleEvent (Event event) {
            switch (event.type) {
            case DWT.MouseMove:
                if ((event.stateMask & DWT.BUTTON1) == 0) break;
                GC gc = new GC (shell);
                gc.drawLine (lastX, lastY, event.x, event.y);
                gc.dispose ();
                //FALL THROUGH
            case DWT.MouseDown:
                lastX = event.x;
                lastY = event.y;
                break;
            }
        }
    };
    shell.addListener (DWT.MouseDown, listener);
    shell.addListener (DWT.MouseMove, listener);
    shell.open ();
    while (!shell.isDisposed ()) {
        if (!display.readAndDispatch ()) display.sleep ();
    }
    display.dispose ();
}

