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
 *     Bill Baxter
 *******************************************************************************/
module coolbar.Snippet150;

/*
 * CoolBar example snippet: create a coolbar (relayout when resized)
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 *
 * @since 3.0
 */
import dwt.DWT;
import dwt.graphics.Point;
import dwt.widgets.Button;
import dwt.widgets.Display;
import dwt.widgets.CoolBar;
import dwt.widgets.CoolItem;
import dwt.widgets.ToolBar;
import dwt.widgets.ToolItem;
import dwt.widgets.Shell;
import dwt.widgets.Text;
import dwt.widgets.Event;
import dwt.widgets.Listener;
import dwt.layout.FormLayout;
import dwt.layout.FormData;
import dwt.layout.FormAttachment;

import tango.util.Convert;

int itemCount;
CoolItem createItem(CoolBar coolBar, int count) {
    ToolBar toolBar = new ToolBar(coolBar, DWT.FLAT);
    for (int i = 0; i < count; i++) {
        ToolItem item = new ToolItem(toolBar, DWT.PUSH);
        item.setText(to!(char[])(itemCount++) ~"");
    }
    toolBar.pack();
    Point size = toolBar.getSize();
    CoolItem item = new CoolItem(coolBar, DWT.NONE);
    item.setControl(toolBar);
    Point preferred = item.computeSize(size.x, size.y);
    item.setPreferredSize(preferred);
    return item;
}

void main () {

    Display display = new Display();
    final Shell shell = new Shell(display);
    CoolBar coolBar = new CoolBar(shell, DWT.NONE);
    createItem(coolBar, 3);
    createItem(coolBar, 2);
    createItem(coolBar, 3);
    createItem(coolBar, 4);
    int style = DWT.BORDER | DWT.H_SCROLL | DWT.V_SCROLL;
    Text text = new Text(shell, style);
    FormLayout layout = new FormLayout();
    shell.setLayout(layout);
    FormData coolData = new FormData();
    coolData.left = new FormAttachment(0);
    coolData.right = new FormAttachment(100);
    coolData.top = new FormAttachment(0);
    coolBar.setLayoutData(coolData);
    coolBar.addListener(DWT.Resize, new class() Listener {
        void handleEvent(Event event) {
            shell.layout();
        }
    });
    FormData textData = new FormData();
    textData.left = new FormAttachment(0);
    textData.right = new FormAttachment(100);
    textData.top = new FormAttachment(coolBar);
    textData.bottom = new FormAttachment(100);
    text.setLayoutData(textData);
    shell.open();
    while (!shell.isDisposed()) {
        if (!display.readAndDispatch()) display.sleep();
    }
    display.dispose();

}
