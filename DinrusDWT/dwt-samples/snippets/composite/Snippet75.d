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
 *     Thomas Demmer <t_demmer AT web DOT de>
 *******************************************************************************/
module composite.Snippet75;

/*
 * Composite example snippet: set the tab traversal order of children
 * In this example, composite1 (i.e. c1) tab order is set to: B2, B1, B3, and
 * shell tab order is set to: c1, B7, toolBar1, (c4: no focusable children), c2, L2
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 */
import dwt.DWT;
import dwt.widgets.Button;
import dwt.widgets.Combo;
import dwt.widgets.Composite;
import dwt.widgets.Control;
import dwt.widgets.Display;
import dwt.widgets.Label;
import dwt.widgets.List;
import dwt.widgets.Shell;
import dwt.widgets.ToolBar;
import dwt.widgets.ToolItem;
import dwt.layout.FillLayout;
import dwt.layout.RowLayout;

import dwt.dwthelper.utils;


void main (String [] args) {
    Display display = new Display ();
    Shell shell = new Shell (display);
    shell.setLayout (new RowLayout ());

    Composite c1 = new Composite (shell, DWT.BORDER);
    c1.setLayout (new RowLayout ());
    Button b1 = new Button (c1, DWT.PUSH);
    b1.setText ("B&1");
    Button r1 = new Button (c1, DWT.RADIO);
    r1.setText ("R1");
    Button r2 = new Button (c1, DWT.RADIO);
    r2.setText ("R&2");
    Button r3 = new Button (c1, DWT.RADIO);
    r3.setText ("R3");
    Button b2 = new Button (c1, DWT.PUSH);
    b2.setText ("B2");
    List l1 = new List (c1, DWT.SINGLE | DWT.BORDER);
    l1.setItems (["L1"]);
    Button b3 = new Button (c1, DWT.PUSH);
    b3.setText ("B&3");
    Button b4 = new Button (c1, DWT.PUSH);
    b4.setText ("B&4");

    Composite c2 = new Composite (shell, DWT.BORDER);
    c2.setLayout (new RowLayout ());
    Button b5 = new Button (c2, DWT.PUSH);
    b5.setText ("B&5");
    Button b6 = new Button (c2, DWT.PUSH);
    b6.setText ("B&6");

    List l2 = new List (shell, DWT.SINGLE | DWT.BORDER);
    l2.setItems ( ["L2"] );

    ToolBar tb1 = new ToolBar (shell, DWT.FLAT | DWT.BORDER);
    ToolItem i1 = new ToolItem (tb1, DWT.RADIO);
    i1.setText ("I1");
    ToolItem i2 = new ToolItem (tb1, DWT.RADIO);
    i2.setText ("I2");
    Combo combo1 = new Combo (tb1, DWT.READ_ONLY | DWT.BORDER);
    combo1.setItems (["C1"]);
    combo1.setText ("C1");
    combo1.pack ();
    ToolItem i3 = new ToolItem (tb1, DWT.SEPARATOR);
    i3.setWidth (combo1.getSize ().x);
    i3.setControl (combo1);
    ToolItem i4 = new ToolItem (tb1, DWT.PUSH);
    i4.setText ("I&4");
    ToolItem i5 = new ToolItem (tb1, DWT.CHECK);
    i5.setText ("I5");

    Button b7 = new Button (shell, DWT.PUSH);
    b7.setText ("B&7");

    Composite c4 = new Composite (shell, DWT.BORDER);
    Composite c5 = new Composite (c4, DWT.BORDER);
    c5.setLayout(new FillLayout());
    (new Label(c5, DWT.NONE)).setText("No");
    c5.pack();


    Control [] tabList1 = [cast(Control)b2, b1, b3];
    c1.setTabList (tabList1);
    Control [] tabList2 = [cast(Control)c1, b7, tb1, c4, c2, l2];
    shell.setTabList (tabList2);
    shell.pack ();
    shell.open ();

    while (!shell.isDisposed ()) {
        if (!display.readAndDispatch ()) display.sleep ();
    }
    display.dispose ();
}
