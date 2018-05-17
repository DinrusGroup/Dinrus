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
module examples.helloworld.HelloWorld2;

import dwt.DWT;
import dwt.widgets.Display;
import dwt.widgets.Label;
import dwt.widgets.Shell;

/*
 * This example builds on HelloWorld1 and demonstrates the minimum amount
 * of code required to open an DWT Shell with a Label and process the events.
 */

void main(){
    Display display = new Display ();
    Shell shell = new Shell (display);
    Label label = new Label (shell, DWT.CENTER);
    label.setText ("Hello_world");
    label.setBounds (shell.getClientArea ());
    shell.open ();
    while (!shell.isDisposed ()) {
        if (!display.readAndDispatch ()) display.sleep ();
    }
    display.dispose ();
}
