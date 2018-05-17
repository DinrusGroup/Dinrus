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
 *     Bill Baxter <wbaxter@gmail.com>
 *******************************************************************************/
module tree.Snippet170;

/*
 * Tree example snippet: Create a Tree with columns
 * 
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 * 
 * @since 3.1
 */

import dwt.DWT;
import dwt.widgets.Display;
import dwt.widgets.Shell;
import dwt.widgets.Tree;
import dwt.widgets.TreeItem;
import dwt.widgets.TreeColumn;
import dwt.layout.FillLayout;

import tango.util.Convert;

import dwt.dwthelper.utils;

void main() {
    Display display = new Display();
    final Shell shell = new Shell(display);
    shell.setLayout(new FillLayout());
    Tree tree = new Tree(shell, DWT.BORDER | DWT.H_SCROLL | DWT.V_SCROLL);
    tree.setHeaderVisible(true);
    TreeColumn column1 = new TreeColumn(tree, DWT.LEFT);
    column1.setText("Column 1");
    column1.setWidth(200);
    TreeColumn column2 = new TreeColumn(tree, DWT.CENTER);
    column2.setText("Column 2");
    column2.setWidth(200);
    TreeColumn column3 = new TreeColumn(tree, DWT.RIGHT);
    column3.setText("Column 3");
    column3.setWidth(200);
    for (int i = 0; i < 4; i++) {
        TreeItem item = new TreeItem(tree, DWT.NONE);
        item.setText([ "item " ~ to!(String)(i), "abc", "defghi" ]);
        for (int j = 0; j < 4; j++) {
            TreeItem subItem = new TreeItem(item, DWT.NONE);
            subItem.setText([ "subitem " ~ to!(String)(j), "jklmnop", "qrs" ]);
            for (int k = 0; k < 4; k++) {
                TreeItem subsubItem = new TreeItem(subItem, DWT.NONE);
                subsubItem.setText([ "subsubitem " ~ to!(String)(k), "tuv", "wxyz" ]);
            }
        }
    }
    shell.pack();
    shell.open();
    while (!shell.isDisposed()) {
        if (!display.readAndDispatch()) {
            display.sleep();
        }
    }
    display.dispose();
}
