/*******************************************************************************
 * Copyright (c) 2000, 2007 IBM Corporation and others.
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
module examples.controlexample.LinkTab;



import dwt.DWT;
import dwt.DWTError;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.widgets.Button;
import dwt.widgets.Group;
import dwt.widgets.Label;
import dwt.widgets.Link;
import dwt.widgets.Widget;

import examples.controlexample.Tab;
import examples.controlexample.ControlExample;

class LinkTab : Tab {
    /* Example widgets and groups that contain them */
    Link link1;
    Group linkGroup;

    /**
     * Creates the Tab within a given instance of ControlExample.
     */
    this(ControlExample instance) {
        super(instance);
    }

    /**
     * Creates the "Example" group.
     */
    override void createExampleGroup () {
        super.createExampleGroup ();

        /* Create a group for the list */
        linkGroup = new Group (exampleGroup, DWT.NONE);
        linkGroup.setLayout (new GridLayout ());
        linkGroup.setLayoutData (new GridData (DWT.FILL, DWT.FILL, true, true));
        linkGroup.setText ("Link");
    }

    /**
     * Creates the "Example" widgets.
     */
    override void createExampleWidgets () {

        /* Compute the widget style */
        int style = getDefaultStyle();
        if (borderButton.getSelection ()) style |= DWT.BORDER;

        /* Create the example widgets */
        try {
            link1 = new Link (linkGroup, style);
            link1.setText (ControlExample.getResourceString("LinkText"));
        } catch (DWTError e) {
            // temporary code for photon
            Label label = new Label (linkGroup, DWT.CENTER | DWT.WRAP);
            label.setText ("Link widget not suported");
        }
    }

    /**
     * Creates the "Style" group.
     */
    void createStyleGroup() {
        super.createStyleGroup ();

        /* Create the extra widgets */
        borderButton = new Button(styleGroup, DWT.CHECK);
        borderButton.setText("DWT.BORDER");
    }

    /**
     * Gets the "Example" widget children.
     */
    Widget [] getExampleWidgets () {
//       temporary code for photon
        if (link1 !is null) return [ cast(Widget) link1 ];
        return null;
    }

    /**
     * Returns a list of set/get API method names (without the set/get prefix)
     * that can be used to set/get values in the example control(s).
     */
    char[][] getMethodNames() {
        return ["Text", "ToolTipText"];
    }

    /**
     * Gets the text for the tab folder item.
     */
    char[] getTabText () {
        return "Link";
    }

}
