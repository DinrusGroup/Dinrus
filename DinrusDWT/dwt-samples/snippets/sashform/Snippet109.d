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
 *     Bill Baxter
 *******************************************************************************/
module sashform.Snippet109;
 
/*
 * SashForm example snippet: create a sash form with three children
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 */
import dwt.DWT;
import dwt.custom.SashForm;
import dwt.layout.FillLayout;
import dwt.widgets.Display;
import dwt.widgets.Shell;
import dwt.widgets.Label;
import dwt.widgets.Button;
import dwt.widgets.Composite;

void main () {
    final Display display = new Display ();
    Shell shell = new Shell(display);
    shell.setLayout (new FillLayout());

    SashForm form = new SashForm(shell,DWT.HORIZONTAL);
    form.setLayout(new FillLayout());
    
    Composite child1 = new Composite(form,DWT.NONE);
    child1.setLayout(new FillLayout());
    (new Label(child1,DWT.NONE)).setText("Label in pane 1");
    
    Composite child2 = new Composite(form,DWT.NONE);
    child2.setLayout(new FillLayout());
    (new Button(child2,DWT.PUSH)).setText("Button in pane2");

    Composite child3 = new Composite(form,DWT.NONE);
    child3.setLayout(new FillLayout());
    (new Label(child3,DWT.PUSH)).setText("Label in pane3");
    
    form.setWeights([30,40,30]);
    shell.open ();
    while (!shell.isDisposed ()) {
        if (!display.readAndDispatch ()) display.sleep ();
    }
    display.dispose ();
}

