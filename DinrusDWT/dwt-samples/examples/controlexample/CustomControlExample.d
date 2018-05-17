/*******************************************************************************
 * Copyright (c) 2000, 2006 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/
module examples.controlexample.CustomControlExample;

import dwt.layout.FillLayout;
import dwt.widgets.Composite;
import dwt.widgets.Display;
import dwt.widgets.Shell;

import tango.io.Stdout;

import examples.controlexample.ControlExample;
import examples.controlexample.CComboTab;
import examples.controlexample.CLabelTab;
import examples.controlexample.CTabFolderTab;
import examples.controlexample.SashFormTab;
import examples.controlexample.StyledTextTab;
import examples.controlexample.Tab;

public class CustomControlExampleFactory : IControlExampleFactory {
    CustomControlExample create(Shell shell, char[] title) {

        Stdout.formatln( "The CustomControlExample: still work left" );
        Stdout.formatln( "warning in Control:setBounds() line=695 gtk_widget_size_allocate()" );
        Stdout.formatln( "Gtk-WARNING **: gtk_widget_size_allocate(): attempt to allocate widget with width -5 and height 15" );
        Stdout.formatln( "for the CTabFolder widget. Params are OK. Further bugtracking needed." );
        Stdout.formatln( "please report problems" );

        auto res = new CustomControlExample( shell );
        shell.setText(ControlExample.getResourceString("custom.window.title"));
        return res;
    }
}


public class CustomControlExample : ControlExample {

    /**
     * Creates an instance of a CustomControlExample embedded
     * inside the supplied parent Composite.
     *
     * @param parent the container of the example
     */
    public this(Composite parent) {
        super (parent);
    }

    /**
     * Answers the set of example Tabs
     */
    Tab[] createTabs() {
        return [ cast(Tab)
            new CComboTab (this),
            new CLabelTab (this),
            new CTabFolderTab (this),
            new SashFormTab (this),
            new StyledTextTab (this)
        ];
    }
}
