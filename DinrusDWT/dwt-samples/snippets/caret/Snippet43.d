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
 *     Thomas Demmer <t_demmer AT web DOT de>
 *******************************************************************************/
module caret.Snippet43;
/*
 * Caret example snippet: create a caret (using an image)
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 */
import dwt.DWT;
import dwt.graphics.Color;
import dwt.graphics.GC;
import dwt.graphics.Image;

import dwt.widgets.Caret;
import dwt.widgets.Display;
import dwt.widgets.Shell;

import dwt.dwthelper.utils;

void main (String [] args) {
    Display display = new Display ();
    Shell shell = new Shell (display);
    shell.open ();
    Caret caret = new Caret (shell, DWT.NONE);
    Color white = display.getSystemColor (DWT.COLOR_WHITE);
    Color black = display.getSystemColor (DWT.COLOR_BLACK);
    Image image = new Image (display, 20, 20);
    GC gc = new GC (image);
    gc.setBackground (black);
    gc.fillRectangle (0, 0, 20, 20);
    gc.setForeground (white);
    gc.drawLine (0, 0, 19, 19);
    gc.drawLine (19, 0, 0, 19);
    gc.dispose ();
    caret.setLocation (10, 10);
    caret.setImage (image);
    gc = new GC (shell);
    gc.drawImage (image, 10, 64);
    caret.setVisible (false);
    gc.drawString ("Test", 12, 12);
    caret.setVisible (true);
    gc.dispose ();
    while (!shell.isDisposed ()) {
        if (!display.readAndDispatch ()) display.sleep ();
    }
    image.dispose ();
    display.dispose ();
}
