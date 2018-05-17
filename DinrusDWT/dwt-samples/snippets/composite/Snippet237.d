/*******************************************************************************
 * Copyright (c) 2000, 2006 IBM Corporation and others.
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
module composite.Snippet237;
/*
 * Composite Snippet: inherit a background color or image
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 *
 * @since 3.2
 */

import dwt.DWT;
import dwt.graphics.Color;
import dwt.layout.RowLayout;
import dwt.widgets.Display;
import dwt.widgets.Button;
import dwt.widgets.Composite;
import dwt.widgets.Group;
import dwt.widgets.Label;
import dwt.widgets.List;
import dwt.widgets.Shell;
import dwt.widgets.Text;

import dwt.dwthelper.utils;

void main(String[] args){
    Snippet237.main(args);
}
public class Snippet237 {

    public static void main(String[] args) {
        Display display = new Display();
        Shell shell = new Shell(display);
        shell.setText("Composite.setBackgroundMode()");
        shell.setLayout(new RowLayout(DWT.VERTICAL));

        Color color = display.getSystemColor(DWT.COLOR_CYAN);

        Group group = new Group(shell, DWT.NONE);
        group.setText("DWT.INHERIT_NONE");
        group.setBackground(color);
        group.setBackgroundMode(DWT.INHERIT_NONE);
        createChildren(group);

        group = new Group(shell, DWT.NONE);
        group.setBackground(color);
        group.setText("DWT.INHERIT_DEFAULT");
        group.setBackgroundMode(DWT.INHERIT_DEFAULT);
        createChildren(group);

        group = new Group(shell, DWT.NONE);
        group.setBackground(color);
        group.setText("DWT.INHERIT_FORCE");
        group.setBackgroundMode(DWT.INHERIT_FORCE);
        createChildren(group);

        shell.pack();
        shell.open();
        while(!shell.isDisposed()) {
            if(!display.readAndDispatch()) display.sleep();
        }
        display.dispose();
    }
    static void createChildren(Composite parent) {
        parent.setLayout(new RowLayout());
        List list = new List(parent, DWT.BORDER | DWT.MULTI);
        list.add("List item 1");
        list.add("List item 2");
        Label label = new Label(parent, DWT.NONE);
        label.setText("Label");
        Button button = new Button(parent, DWT.RADIO);
        button.setText("Radio Button");
        button = new Button(parent, DWT.CHECK);
        button.setText("Check box Button");
        button = new Button(parent, DWT.PUSH);
        button.setText("Push Button");
        Text text = new Text(parent, DWT.BORDER);
        text.setText("Text");
    }
}
