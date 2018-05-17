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
module composite.Snippet98;

/*
 * Composite example snippet: create and dispose children of a composite
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 */
import dwt.DWT;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.widgets.Button;
import dwt.widgets.Composite;
import dwt.widgets.Display;
import dwt.widgets.Event;
import dwt.widgets.Listener;
import dwt.widgets.Shell;
import dwt.widgets.Table;
import dwt.widgets.TableItem;

import dwt.dwthelper.utils;

import tango.util.Convert;

static int pageNum = 0;
static Composite pageComposite;

void main(String args[]) {
    Display display = new Display();
    final Shell shell = new Shell(display);
    shell.setLayout(new GridLayout());
    Button button = new Button(shell, DWT.PUSH);
    button.setText("Push");
    pageComposite = new Composite(shell, DWT.NONE);
    pageComposite.setLayout(new GridLayout());
    pageComposite.setLayoutData(new GridData());

    button.addListener(DWT.Selection, new class() Listener{
        public void handleEvent(Event event) {
            if ((pageComposite !is null) && (!pageComposite.isDisposed())) {
                pageComposite.dispose();
            }
            pageComposite = new Composite(shell, DWT.NONE);
            pageComposite.setLayout(new GridLayout());
            pageComposite.setLayoutData(new GridData());
            if (pageNum++ % 2 == 0) {
                Table table = new Table(pageComposite, DWT.BORDER);
                table.setLayoutData(new GridData());
                for (int i = 0; i < 5; i++) {
                    (new TableItem(table, DWT.NONE)).setText("table item " ~ to!(char[])(i));
                }
            } else {
                (new Button(pageComposite, DWT.RADIO)).setText("radio");
            }
            shell.layout(true);
        }
    });

    shell.open();
    while (!shell.isDisposed()) {
        if (!display.readAndDispatch())
            display.sleep();
    }
    display.dispose();
}
