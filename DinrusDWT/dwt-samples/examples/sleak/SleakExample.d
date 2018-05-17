/*
 * Copyright (c) 2000, 2002 IBM Corp.  All rights reserved.
 * This file is made available under the terms of the Common Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/cpl-v10.html
 *
 * Port to the D programming language
 *   Frank Benoit <benoit@tionex.de>
 */
module examples.sleak.SleakExample;

import dwt.DWT;
import dwt.graphics.DeviceData;
import dwt.widgets.Display;
import dwt.widgets.Shell;
import dwt.widgets.Canvas;
import dwt.widgets.List;
import dwt.program.Program;
import dwt.graphics.ImageData;
import dwt.graphics.Image;
import dwt.layout.FillLayout;
import dwt.events.PaintListener;
import dwt.events.PaintEvent;
import dwt.events.SelectionAdapter;
import dwt.events.SelectionEvent;

import dwtx.sleak.Sleak;

import tango.io.Stdout;
version(JIVE){
    import jive.stacktrace;
}

void main() {
    Display display;
    Shell shell;
    List list;
    Canvas canvas;
    Image image;

    version( all ){
        DeviceData data = new DeviceData();
        data.tracking = true;
        display = new Display(data);
        Sleak sleak = new Sleak();
        sleak.open();
    }
    else{
        display = new Display();
    }

    shell = new Shell(display);
    shell.setLayout(new FillLayout());
    list = new List(shell, DWT.BORDER | DWT.SINGLE | DWT.V_SCROLL | DWT.H_SCROLL);
    list.setItems(Program.getExtensions());
    canvas = new Canvas(shell, DWT.BORDER);
    canvas.addPaintListener(new class() PaintListener {
        public void paintControl(PaintEvent e) {
            if (image !is null) {
                e.gc.drawImage(image, 0, 0);
            }
        }
    });
    list.addSelectionListener(new class() SelectionAdapter {
        public void widgetSelected(SelectionEvent e) {
            image = null; // potentially leak one image
            char[][] selection = list.getSelection();
            if (selection.length !is 0) {
                Program program = Program.findProgram(selection[0]);
                if (program !is null) {
                    ImageData imageData = program.getImageData();
                    if (imageData !is null) {
                        if (image !is null) image.dispose();
                        image = new Image(display, imageData);
                    }
                }
            }
            canvas.redraw();
        }
    });
    shell.setSize(shell.computeSize(DWT.DEFAULT, 200));
    shell.open();
    while (!shell.isDisposed()) {
        if (!display.readAndDispatch())
            display.sleep();
    }
}
