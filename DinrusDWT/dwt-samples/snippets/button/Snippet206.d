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
 *     Thomas Demmer <t_demmer AT web DOT de>
 *******************************************************************************/
module button.Snippet206;

/*
 * Button example snippet: a Button with text and image
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 *
 * @since 3.2
 */

import dwt.DWT;
import dwt.graphics.Image;
import dwt.layout.GridLayout;
import dwt.widgets.Button;
import dwt.widgets.Display;
import dwt.widgets.Shell;

import dwt.dwthelper.utils;

void main(String[] args){
    Snippet206.main(args);
}

public class Snippet206 {
    public static void main(String[] args) {
        Display display = new Display();
        Image image = display.getSystemImage(DWT.ICON_QUESTION);
        Shell shell = new Shell(display);
        shell.setLayout (new GridLayout());
        Button button = new Button(shell, DWT.PUSH);
        button.setImage(image);
        button.setText("Button");
        shell.setSize(300, 300);
        shell.open();
        while (!shell.isDisposed ()) {
            if (!display.readAndDispatch ()) display.sleep ();
        }
        display.dispose ();
    }
}
