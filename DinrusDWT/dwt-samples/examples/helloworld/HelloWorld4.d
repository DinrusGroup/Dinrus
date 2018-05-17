/*******************************************************************************
 * Copyright (c) 2000, 2003 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *******************************************************************************/
module examples.helloworld.HelloWorld4;

import dwt.DWT;
import dwt.layout.FillLayout;
import dwt.widgets.Display;
import dwt.widgets.Label;
import dwt.widgets.Shell;

/*
 * This example builds on HelloWorld2 and demonstrates how to resize the
 * Label when the Shell resizes using a Layout.
 */
void main () {
    Display display = new Display ();
    Shell shell = new Shell (display);
    shell.setLayout(new FillLayout());
    Label label = new Label (shell, DWT.CENTER);
    label.setText ("Hello_world");
    shell.pack ();
    shell.open ();
    while (!shell.isDisposed ()) {
        if (!display.readAndDispatch ()) display.sleep ();
    }
    display.dispose ();
}
