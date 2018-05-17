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
module examples.helloworld.HelloWorld3;

import dwt.DWT;
import dwt.events.ControlAdapter;
import dwt.events.ControlEvent;
import dwt.widgets.Display;
import dwt.widgets.Label;
import dwt.widgets.Shell;

/*
 * This example builds on HelloWorld2 and demonstrates how to resize the
 * Label when the Shell resizes using a Listener mechanism.
 */

void main () {
    Display display = new Display ();
    final Shell shell = new Shell (display);
    final Label label = new Label (shell, DWT.CENTER);
    label.setText ("Hello_world");
    label.pack();
    shell.addControlListener(new class() ControlAdapter {
        public void controlResized(ControlEvent e) {
            label.setBounds (shell.getClientArea ());
        }
    });
    shell.pack();
    shell.open ();
    while (!shell.isDisposed ()) {
        if (!display.readAndDispatch ()) display.sleep ();
    }
    display.dispose ();
}
