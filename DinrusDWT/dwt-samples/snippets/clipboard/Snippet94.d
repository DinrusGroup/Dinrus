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
module clipboard.Snippet94;
/*
 * Clipboard example snippet: copy and paste data with the clipboard
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 */
import dwt.DWT;
import dwt.dnd.Clipboard;
import dwt.dnd.Transfer;
import dwt.dnd.TextTransfer;

import dwt.layout.FormAttachment;
import dwt.layout.FormData;
import dwt.layout.FormLayout;

import dwt.widgets.Button;
import dwt.widgets.Display;
import dwt.widgets.Event;
import dwt.widgets.Listener;
import dwt.widgets.Shell;
import dwt.widgets.Text;

import dwt.dwthelper.utils;


public static void main( String[] args) {
    Display display = new Display ();
    Clipboard cb = new Clipboard(display);
    Shell shell = new Shell (display);
    shell.setLayout(new FormLayout());
    Text text = new Text(shell, DWT.BORDER | DWT.MULTI | DWT.V_SCROLL | DWT.H_SCROLL);

    Button copy = new Button(shell, DWT.PUSH);
    copy.setText("Copy");
    copy.addListener (DWT.Selection, new class() Listener {
        public void handleEvent (Event e) {
            String textData = text.getSelectionText();
            if (textData.length > 0) {
                TextTransfer textTransfer = TextTransfer.getInstance();
                // this is ugly, but works.
                Transfer[] xfer = [ textTransfer];
                Object[] td = [ new ArrayWrapperString(textData) ];
                cb.setContents(td,xfer);
            }
        }
    });

    Button paste = new Button(shell, DWT.PUSH);
    paste.setText("Paste");
    paste.addListener (DWT.Selection, new class() Listener {
        public void handleEvent (Event e) {
            TextTransfer transfer = TextTransfer.getInstance();
            String data = stringcast(cb.getContents(transfer));
            if (data !is null) {
                text.insert(data);
            }
        }
    });

    FormData data = new FormData();
    data.left = new FormAttachment(paste, 0, DWT.LEFT);
    data.right = new FormAttachment(100, -5);
    data.top = new FormAttachment(0, 5);
    copy.setLayoutData(data);

    data = new FormData();
    data.right = new FormAttachment(100, -5);
    data.top = new FormAttachment(copy, 5);
    paste.setLayoutData(data);

    data = new FormData();
    data.left = new FormAttachment(0, 5);
    data.top = new FormAttachment(0, 5);
    data.right = new FormAttachment(paste, -5);
    data.bottom = new FormAttachment(100, -5);
    text.setLayoutData(data);

    shell.setSize(200, 200);
    shell.open();
    while (!shell.isDisposed ()) {
        if (!display.readAndDispatch ()) display.sleep ();
    }
    cb.dispose();
    display.dispose();
}
