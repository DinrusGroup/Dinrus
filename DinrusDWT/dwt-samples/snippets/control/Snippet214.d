/*******************************************************************************
 * Copyright (c) 2000, 2005 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 * D Port:
 *     Thomas Demmer <t_demmer AT web DOT de>
 *******************************************************************************/
module control.Snippet214;

/*
 * Control example snippet: set a background image (a dynamic gradient)
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 *
 * @since 3.2
 */
import dwt.DWT;

import dwt.graphics.GC;
import dwt.graphics.Image;
import dwt.graphics.Rectangle;
import dwt.layout.FillLayout;
import dwt.layout.RowLayout;
import dwt.widgets.Button;
import dwt.widgets.Display;
import dwt.widgets.Event;
import dwt.widgets.Group;
import dwt.widgets.Listener;
import dwt.widgets.Shell;
import dwt.layout.RowLayout;

import dwt.dwthelper.utils;

import tango.util.Convert;

static Image oldImage;
void main(String [] args) {
    Display display = new Display ();
    Shell shell = new Shell (display);
    shell.setBackgroundMode (DWT.INHERIT_DEFAULT);
    FillLayout layout1 = new FillLayout (DWT.VERTICAL);
    layout1.marginWidth = layout1.marginHeight = 10;
    shell.setLayout (layout1);
    Group group = new Group (shell, DWT.NONE);
    group.setText ("Group ");
    RowLayout layout2 = new RowLayout (DWT.VERTICAL);
    layout2.marginWidth = layout2.marginHeight = layout2.spacing = 10;
    group.setLayout (layout2);
    for (int i=0; i<8; i++) {
        Button button = new Button (group, DWT.RADIO);
        button.setText ("Button " ~ to!(char[])(i));
    }
    shell.addListener (DWT.Resize, new class() Listener {
       public void handleEvent (Event event) {
           Rectangle rect = shell.getClientArea ();
           Image newImage = new Image (display, Math.max (1, rect.width), 1);
           GC gc = new GC (newImage);
           gc.setForeground (display.getSystemColor (DWT.COLOR_WHITE));
           gc.setBackground (display.getSystemColor (DWT.COLOR_BLUE));
           gc.fillGradientRectangle (rect.x, rect.y, rect.width, 1, false);
           gc.dispose ();
           shell.setBackgroundImage (newImage);
           if (oldImage !is null) oldImage.dispose ();
           oldImage = newImage;
       }
    });
    shell.pack ();
    shell.open ();
    while (!shell.isDisposed ()) {
        if (!display.readAndDispatch ()) display.sleep ();
    }
    if (oldImage !is null) oldImage.dispose ();
    display.dispose ();
}

