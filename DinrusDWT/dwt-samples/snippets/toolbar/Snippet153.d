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
module toolbar.Snippet153;

/*
 * ToolBar example snippet: update a status line when the pointer enters a ToolItem
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 */
import dwt.DWT;
import dwt.events.MouseEvent;
import dwt.events.MouseMoveListener;
import dwt.graphics.Point;
import dwt.widgets.Display;
import dwt.widgets.Shell;
import dwt.widgets.ToolBar;
import dwt.widgets.ToolItem;
import dwt.widgets.Label;

static char[] statusText = "";
void main() {
    Display display = new Display();
    Shell shell = new Shell(display);
    shell.setBounds(10, 10, 200, 200);
    ToolBar bar = new ToolBar(shell, DWT.BORDER);
    bar.setBounds(10, 10, 150, 50);
    Label statusLine = new Label(shell, DWT.BORDER);
    statusLine.setBounds(10, 90, 150, 30);
    (new ToolItem(bar, DWT.NONE)).setText("item 1");
    (new ToolItem(bar, DWT.NONE)).setText("item 2");
    (new ToolItem(bar, DWT.NONE)).setText("item 3");
    bar.addMouseMoveListener(new class MouseMoveListener {
        void mouseMove(MouseEvent e) {
            ToolItem item = bar.getItem(new Point(e.x, e.y));
            char[] name = "";
            if (item !is null) {
                name = item.getText();
            }
            if (statusText != name) {
                statusLine.setText(name);
                statusText = name;
            }
        }
    });
    shell.open();
    while (!shell.isDisposed()) {
        if (!display.readAndDispatch()) display.sleep();
    }
    display.dispose();
}

