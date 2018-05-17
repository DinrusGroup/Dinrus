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
module gc.Snippet215;

/*
 * GC example snippet: take a screen shot with a GC
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 */
import dwt.DWT;
import dwt.graphics.GC;
import dwt.graphics.Image;
import dwt.widgets.Display;
import dwt.widgets.Shell;
import dwt.widgets.Listener;
import dwt.widgets.Event;
import dwt.widgets.Button;
import dwt.widgets.Canvas;
import dwt.custom.ScrolledComposite;
import dwt.layout.FillLayout;
import dwt.events.PaintListener;

Image image;

void main() {
    final Display display = new Display();
    final Shell shell = new Shell(display);
    shell.setLayout(new FillLayout());
    Button button = new Button(shell, DWT.PUSH);
    button.setText("Capture");
    button.addListener(DWT.Selection, new class() Listener {
        public void handleEvent(Event event) {

            /* Take the screen shot */
            GC gc = new GC(display);
            image = new Image(display, display.getBounds());
            gc.copyArea(image, 0, 0);
            gc.dispose();

            Shell popup = new Shell(shell, DWT.SHELL_TRIM);
            popup.setLayout(new FillLayout());
            popup.setText("Image");
            popup.setBounds(50, 50, 200, 200);
            popup.addListener(DWT.Close, new class() Listener {
                    public void handleEvent(Event e) {
                        image.dispose();
                    }
                });

            ScrolledComposite sc = new ScrolledComposite (popup, DWT.V_SCROLL | DWT.H_SCROLL);
            Canvas canvas = new Canvas(sc, DWT.NONE);
            sc.setContent(canvas);
            canvas.setBounds(display.getBounds ());
            canvas.addPaintListener(new class() PaintListener {
                    public void paintControl(PaintEvent e) {
                        e.gc.drawImage(image, 0, 0);
                    }
                });
            popup.open();
        }
    });
    shell.pack();
    shell.open();
    while (!shell.isDisposed()) {
        if (!display.readAndDispatch()) display.sleep();
    }
    display.dispose();
}

