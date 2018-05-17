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
module tree.Snippet193;

/*
 * Tree example snippet: allow user to reorder columns by dragging and programmatically.
 * 
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 * 
 * @since 3.2
 */
import dwt.DWT;
import dwt.widgets.Display;
import dwt.widgets.Shell;
import dwt.widgets.Tree;
import dwt.widgets.TreeItem;
import dwt.widgets.TreeColumn;
import dwt.widgets.Button;
import dwt.widgets.Listener;
import dwt.widgets.Event;
import dwt.layout.RowLayout;
import dwt.layout.RowData;

import tango.util.Convert;
import tango.io.Stdout;

import dwt.dwthelper.utils;


void main() {
    Display display = new Display();
    Shell shell = new Shell(display);
    shell.setLayout(new RowLayout(DWT.HORIZONTAL));
    final Tree tree = new Tree(shell, DWT.BORDER | DWT.CHECK);
    tree.setLayoutData(new RowData(-1, 300));
    tree.setHeaderVisible(true);
    TreeColumn column = new TreeColumn(tree, DWT.LEFT);
    column.setText("Column 0");
    column = new TreeColumn(tree, DWT.CENTER);
    column.setText("Column 1");
    column = new TreeColumn(tree, DWT.LEFT);
    column.setText("Column 2");
    column = new TreeColumn(tree, DWT.RIGHT);
    column.setText("Column 3");
    column = new TreeColumn(tree, DWT.CENTER);
    column.setText("Column 4");
    for (int i = 0; i < 5; i++) {
        TreeItem item = new TreeItem(tree, DWT.NONE);
        auto istr = to!(String)(i);
        String[] text = [istr~":0",
                         istr~":1",
                         istr~":2",
                         istr~":3",
                         istr~":4"];
        item.setText(text);
        for (int j = 0; j < 5; j++) {
            auto jstr = to!(String)(j);
            TreeItem subItem = new TreeItem(item, DWT.NONE);
            text = [istr~","~jstr~":0",
                    istr~","~jstr~":1", 
                    istr~","~jstr~":2",
                    istr~","~jstr~":3",
                    istr~","~jstr~":4"];
            subItem.setText(text);
            for (int k = 0; k < 5; k++) {
                auto kstr = to!(String)(k);
                TreeItem subsubItem = new TreeItem(subItem, DWT.NONE);
                text = [istr~","~jstr~","~kstr~":0",
                        istr~","~jstr~","~kstr~":1",
                        istr~","~jstr~","~kstr~":2",
                        istr~","~jstr~","~kstr~":3",
                        istr~","~jstr~","~kstr~":4"];
                subsubItem.setText(text);
            }
        }
    }
    Listener listener = new class Listener {
        public void handleEvent(Event e) {
            Stdout.print("Move "~e.widget.toString).newline;
        }
    };
    TreeColumn[] columns = tree.getColumns();
    for (int i = 0; i < columns.length; i++) {
        columns[i].setWidth(100);
        columns[i].setMoveable(true);
        columns[i].addListener(DWT.Move, listener);
    }
    Button b = new Button(shell, DWT.PUSH);
    b.setText("invert column order");
    b.addListener(DWT.Selection, new class Listener {
        public void handleEvent(Event e) {
            int[] order = tree.getColumnOrder();
            for (int i = 0; i < order.length / 2; i++) {
                int temp = order[i];
                order[i] = order[order.length - i - 1];
                order[order.length - i - 1] = temp;
            }
            tree.setColumnOrder(order);
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
