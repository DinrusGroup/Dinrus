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
module ctabfolder.Snippet82;

/*
 * CTabFolder example snippet: prevent an item from closing
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 *
 * @since 3.0
 */
import dwt.DWT;
import dwt.custom.CTabFolder;
import dwt.custom.CTabFolder2Adapter;
import dwt.custom.CTabFolderEvent;
import dwt.custom.CTabItem;
import dwt.layout.FillLayout;
import dwt.widgets.Button;
import dwt.widgets.Display;
import dwt.widgets.Item;
import dwt.widgets.Shell;
import dwt.widgets.Text;

import dwt.dwthelper.utils;

import tango.util.Convert;

void main(String[] args) {
    Display display = new Display();
    Shell shell = new Shell(display);
    shell.setLayout(new FillLayout());
    CTabFolder folder = new CTabFolder(shell, DWT.BORDER);
    for (int i = 0; i < 4; i++) {
        CTabItem item = new CTabItem(folder, DWT.CLOSE);
        item.setText("Item " ~ to!(String)(i) );
        Text text = new Text(folder, DWT.MULTI);
        text.setText("Content for Item "~ to!(String)(i));
        item.setControl(text);
    }

    CTabItem specialItem = new CTabItem(folder, DWT.CLOSE);
    specialItem.setText("Don't Close Me");
    Text text = new Text(folder, DWT.MULTI);
    text.setText("This tab can never be closed");
    specialItem.setControl(text);

    folder.addCTabFolder2Listener(new class() CTabFolder2Adapter {
        public void close(CTabFolderEvent event) {
            if (event.item == specialItem) {
                event.doit = false;
            }
        }
    });

    CTabItem noCloseItem = new CTabItem(folder, DWT.NONE);
    noCloseItem.setText("No Close Button");
    Text text2 = new Text(folder, DWT.MULTI);
    text2.setText("This tab does not have a close button");
    noCloseItem.setControl(text2);

    shell.pack();
    shell.open();
    while (!shell.isDisposed()) {
        if (!display.readAndDispatch())
            display.sleep();
    }
    display.dispose();
}

