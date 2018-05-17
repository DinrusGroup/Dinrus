/*******************************************************************************
 * Copyright (c) 2007 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *******************************************************************************/
module menu.Snippet286;

/*
 * use a menu item's armListener to update a status line.
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 */
import dwt.DWT;
import dwt.events.ArmEvent;
import dwt.events.ArmListener;
import dwt.layout.GridLayout;
import dwt.layout.GridData;
import dwt.widgets.Display;
import dwt.widgets.Shell;
import dwt.widgets.Canvas;
import dwt.widgets.Label;
import dwt.widgets.Menu;
import dwt.widgets.MenuItem;

import tango.util.Convert;


void main() {
    Display display = new Display();
    Shell shell = new Shell(display);
    shell.setLayout(new GridLayout());
		
    Canvas blankCanvas = new Canvas(shell, DWT.BORDER);
    blankCanvas.setLayoutData(new GridData(200, 200));
    Label statusLine = new Label(shell, DWT.NONE);
    statusLine.setLayoutData(new GridData(DWT.FILL, DWT.CENTER, true, false));

    Menu bar = new Menu (shell, DWT.BAR);
    shell.setMenuBar (bar);
		
    MenuItem menuItem = new MenuItem (bar, DWT.CASCADE);
    menuItem.setText ("Test");
    Menu menu = new Menu(bar);
    menuItem.setMenu (menu);
		
    for (int i = 0; i < 5; i++) {
        MenuItem item = new MenuItem (menu, DWT.PUSH);
        item.setText ("Item " ~ to!(char[])(i));
        item.addArmListener(new class ArmListener {
            public void widgetArmed(ArmEvent e) {
                statusLine.setText((cast(MenuItem)e.getSource()).getText());
            }
        });
    }
		
    shell.pack();
    shell.open();
		
    while(!shell.isDisposed()) {
        if(!display.readAndDispatch()) display.sleep();
    }
}
