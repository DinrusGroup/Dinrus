/*******************************************************************************
 * Copyright (c) 2007 IBM Corporation and others.
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
module clipboard.Snippets282;

/*
 * Copy/paste image to/from clipboard.
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 */

import dwt.DWT;
import dwt.dnd.Clipboard;
import dwt.dnd.ImageTransfer;
import dwt.dnd.Transfer;
import dwt.graphics.Image;
import dwt.graphics.ImageData;
import dwt.layout.GridLayout;
import dwt.layout.GridData;

import dwt.widgets.Button;
import dwt.widgets.Composite;
import dwt.widgets.Display;
import dwt.widgets.Event;
import dwt.widgets.FileDialog;
import dwt.widgets.Listener;
import dwt.widgets.Shell;

import dwt.dwthelper.utils;

public static void main(String[] args) {
    Display display = new Display();
    Clipboard clipboard = new Clipboard(display);
    Shell shell = new Shell(display, DWT.SHELL_TRIM);
    shell.setLayout(new GridLayout());
    shell.setText("Clipboard ImageTransfer");

    Button imageButton = new Button(shell, DWT.NONE );
    GridData gd = new GridData(DWT.FILL, DWT.FILL, true, true);
    gd.minimumHeight = 400;
    gd.minimumWidth = 600;
    imageButton.setLayoutData(gd);

    Composite buttons = new Composite(shell, DWT.NONE);
    buttons.setLayout(new GridLayout(4, true));
    Button button = new Button(buttons, DWT.PUSH);
    button.setText("Open");
    button.addListener(DWT.Selection, new class() Listener {
            public void handleEvent(Event event) {
            FileDialog dialog = new FileDialog (shell, DWT.OPEN);
            dialog.setText("Open an image file or cancel");
            String string = dialog.open ();
            if (string !is null) {
            Image image = imageButton.getImage();
            if (image !is null) image.dispose();
            image = new Image(display, string);
            imageButton.setImage(image);
            }
            }
            });

    button = new Button(buttons, DWT.PUSH);
    button.setText("Copy");
    button.addListener(DWT.Selection, new class() Listener {
            public void handleEvent(Event event) {
            Image image = imageButton.getImage();
            if (image !is null) {
            ImageTransfer transfer = ImageTransfer.getInstance();

            Transfer[] xfer = [ transfer ];
            Object[] td = [ image.getImageData ];

            clipboard.setContents(td,xfer);
            }
            }
            });
    button = new Button(buttons, DWT.PUSH);
    button.setText("Paste");
    button.addListener(DWT.Selection, new class() Listener {
            public void handleEvent(Event event) {
            ImageTransfer transfer = ImageTransfer.getInstance();
            ImageData imageData = cast(ImageData)clipboard.getContents(transfer);
            if (imageData !is null) {
            imageButton.setText("");
            Image image = imageButton.getImage();
            if (image !is null) image.dispose();
            image = new Image(display, imageData);
            imageButton.setImage(image);
            } else {
            imageButton.setText("No image");
            }
            }
            });

    button = new Button(buttons, DWT.PUSH);
    button.setText("Clear");
    button.addListener(DWT.Selection, new class() Listener {
            public void handleEvent(Event event) {
            imageButton.setText("");
            Image image = imageButton.getImage();
            if (image !is null) image.dispose();
            imageButton.setImage(null);
            }
            });
    shell.pack();
    shell.open();
    while (!shell.isDisposed()) {
        if (!display.readAndDispatch())
            display.sleep();
    }
    display.dispose();
}

