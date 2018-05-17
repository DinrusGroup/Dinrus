/*******************************************************************************
 * Copyright (c) 2000, 2006 IBM Corporation and others.
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
module cursor.Snippet242;

/*
 * Cursor snippet: Hide the Cursor over a control.
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 */

import dwt.DWT;
import dwt.events.PaintEvent;
import dwt.events.PaintListener;
import dwt.graphics.Color;
import dwt.graphics.Cursor;
import dwt.graphics.ImageData;
import dwt.graphics.PaletteData;
import dwt.widgets.Canvas;
import dwt.widgets.Display;
import dwt.widgets.Shell;

import dwt.dwthelper.utils;

void main(String [] args) {
    Display display = new Display();
    Shell shell = new Shell(display);
    shell.setBounds(10, 10, 200, 200);
    Canvas canvas = new Canvas(shell, DWT.BORDER);
    canvas.setBounds(10,50,150,100);
    canvas.addPaintListener(new class() PaintListener{
        public void paintControl(PaintEvent e) {
            e.gc.drawString("hide Cursor here", 10, 10);
        }
    });

    // create a cursor with a transparent image
    Color white = display.getSystemColor (DWT.COLOR_WHITE);
    Color black = display.getSystemColor (DWT.COLOR_BLACK);
    PaletteData palette = new PaletteData ([white.getRGB(), black.getRGB()]);
    ImageData sourceData = new ImageData (16, 16, 1, palette);
    sourceData.transparentPixel = 0;
    Cursor cursor = new Cursor(display, sourceData, 0, 0);

    shell.open();
    canvas.setCursor(cursor);
    while (!shell.isDisposed()) {
        if (!display.readAndDispatch()) display.sleep();
    }
    cursor.dispose();
    display.dispose();
}

