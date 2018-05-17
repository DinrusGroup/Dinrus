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
module examples.helloworld.HelloWorld1;


import dwt.widgets.Display;
import dwt.widgets.Shell;

/*
 * This example demonstrates the minimum amount of code required
 * to open an DWT Shell and process the events.
 */
void main(){
    Display display = new Display ();
    Shell shell = new Shell (display);
    shell.open ();
    while (!shell.isDisposed ()) {
        if (!display.readAndDispatch ()) display.sleep ();
    }
    display.dispose ();
}

