/*******************************************************************************
 * Copyright (c) 2000, 2003 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *******************************************************************************/
module examples.helloworld.HelloWorld5;


import dwt.events.DisposeEvent;
import dwt.events.DisposeListener;
import dwt.events.PaintEvent;
import dwt.events.PaintListener;
import dwt.graphics.Color;
import dwt.graphics.GC;
import dwt.graphics.Rectangle;
import dwt.widgets.Display;
import dwt.widgets.Shell;

/*
 * This example builds on HelloWorld1 and demonstrates how to draw directly
 * on an DWT Control.
 */

void main () {
    Display display = new Display ();
    final Color red = new Color(display, 0xFF, 0, 0);
    final Shell shell = new Shell (display);
    shell.addPaintListener(new class() PaintListener {
        public void paintControl(PaintEvent event){
            GC gc = event.gc;
            gc.setForeground(red);
            Rectangle rect = shell.getClientArea();
            gc.drawRectangle(rect.x + 10, rect.y + 10, rect.width - 20, rect.height - 20);
            gc.drawString("Hello_world", rect.x + 20, rect.y + 20);
        }
    });
    shell.addDisposeListener (new class() DisposeListener {
        public void widgetDisposed (DisposeEvent e) {
            red.dispose();
        }
    });
    shell.open ();
    while (!shell.isDisposed ()) {
        if (!display.readAndDispatch ()) display.sleep ();
    }
    display.dispose ();
}
