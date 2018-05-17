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
module examples.controlexample.GroupTab;



import dwt.DWT;
import dwt.events.SelectionAdapter;
import dwt.events.SelectionEvent;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.widgets.Button;
import dwt.widgets.Group;
import dwt.widgets.Widget;

import examples.controlexample.Tab;
import examples.controlexample.ControlExample;

class GroupTab : Tab {
    Button titleButton;

    /* Example widgets and groups that contain them */
    Group group1;
    Group groupGroup;

    /* Style widgets added to the "Style" group */
    Button shadowEtchedInButton, shadowEtchedOutButton, shadowInButton, shadowOutButton, shadowNoneButton;

    /**
     * Creates the Tab within a given instance of ControlExample.
     */
    this(ControlExample instance) {
        super(instance);
    }

    /**
     * Creates the "Other" group.
     */
    void createOtherGroup () {
        super.createOtherGroup ();

        /* Create display controls specific to this example */
        titleButton = new Button (otherGroup, DWT.CHECK);
        titleButton.setText (ControlExample.getResourceString("Title_Text"));

        /* Add the listeners */
        titleButton.addSelectionListener (new class() SelectionAdapter {
            public void widgetSelected (SelectionEvent event) {
                setTitleText ();
            }
        });
    }

    /**
     * Creates the "Example" group.
     */
    void createExampleGroup () {
        super.createExampleGroup ();

        /* Create a group for the Group */
        groupGroup = new Group (exampleGroup, DWT.NONE);
        groupGroup.setLayout (new GridLayout ());
        groupGroup.setLayoutData (new GridData (DWT.FILL, DWT.FILL, true, true));
        groupGroup.setText ("Group");
    }

    /**
     * Creates the "Example" widgets.
     */
    void createExampleWidgets () {

        /* Compute the widget style */
        int style = getDefaultStyle();
        if (shadowEtchedInButton.getSelection ()) style |= DWT.SHADOW_ETCHED_IN;
        if (shadowEtchedOutButton.getSelection ()) style |= DWT.SHADOW_ETCHED_OUT;
        if (shadowInButton.getSelection ()) style |= DWT.SHADOW_IN;
        if (shadowOutButton.getSelection ()) style |= DWT.SHADOW_OUT;
        if (shadowNoneButton.getSelection ()) style |= DWT.SHADOW_NONE;
        if (borderButton.getSelection ()) style |= DWT.BORDER;

        /* Create the example widgets */
        group1 = new Group (groupGroup, style);
    }

    /**
     * Creates the "Style" group.
     */
    void createStyleGroup() {
        super.createStyleGroup ();

        /* Create the extra widgets */
        shadowEtchedInButton = new Button (styleGroup, DWT.RADIO);
        shadowEtchedInButton.setText ("DWT.SHADOW_ETCHED_IN");
        shadowEtchedInButton.setSelection(true);
        shadowEtchedOutButton = new Button (styleGroup, DWT.RADIO);
        shadowEtchedOutButton.setText ("DWT.SHADOW_ETCHED_OUT");
        shadowInButton = new Button (styleGroup, DWT.RADIO);
        shadowInButton.setText ("DWT.SHADOW_IN");
        shadowOutButton = new Button (styleGroup, DWT.RADIO);
        shadowOutButton.setText ("DWT.SHADOW_OUT");
        shadowNoneButton = new Button (styleGroup, DWT.RADIO);
        shadowNoneButton.setText ("DWT.SHADOW_NONE");
        borderButton = new Button (styleGroup, DWT.CHECK);
        borderButton.setText ("DWT.BORDER");
    }

    /**
     * Gets the "Example" widget children.
     */
    Widget [] getExampleWidgets () {
        return [ cast(Widget) group1];
    }

    /**
     * Returns a list of set/get API method names (without the set/get prefix)
     * that can be used to set/get values in the example control(s).
     */
    char[][] getMethodNames() {
        return ["ToolTipText"];
    }

    /**
     * Gets the text for the tab folder item.
     */
    char[] getTabText () {
        return "Group";
    }

    /**
     * Sets the title text of the "Example" widgets.
     */
    void setTitleText () {
        if (titleButton.getSelection ()) {
            group1.setText (ControlExample.getResourceString("Title_Text"));
        } else {
            group1.setText ("");
        }
        setExampleWidgetSize ();
    }

    /**
     * Sets the state of the "Example" widgets.
     */
    void setExampleWidgetState () {
        super.setExampleWidgetState ();
        shadowEtchedInButton.setSelection ((group1.getStyle () & DWT.SHADOW_ETCHED_IN) !is 0);
        shadowEtchedOutButton.setSelection ((group1.getStyle () & DWT.SHADOW_ETCHED_OUT) !is 0);
        shadowInButton.setSelection ((group1.getStyle () & DWT.SHADOW_IN) !is 0);
        shadowOutButton.setSelection ((group1.getStyle () & DWT.SHADOW_OUT) !is 0);
        shadowNoneButton.setSelection ((group1.getStyle () & DWT.SHADOW_NONE) !is 0);
        borderButton.setSelection ((group1.getStyle () & DWT.BORDER) !is 0);
        if (!instance.startup) setTitleText ();
    }
}
