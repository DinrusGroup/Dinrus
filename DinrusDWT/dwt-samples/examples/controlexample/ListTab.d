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
module examples.controlexample.ListTab;



import dwt.DWT;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.widgets.Group;
import dwt.widgets.List;
import dwt.widgets.Widget;

import examples.controlexample.Tab;
import examples.controlexample.ControlExample;
import examples.controlexample.ScrollableTab;

class ListTab : ScrollableTab {

    /* Example widgets and groups that contain them */
    List list1;
    Group listGroup;

    static char[] [] ListData1;

    /**
     * Creates the Tab within a given instance of ControlExample.
     */
    this(ControlExample instance) {
        super(instance);
        if( ListData1.length is 0 ){
            ListData1 = [
                ControlExample.getResourceString("ListData1_0"),
                ControlExample.getResourceString("ListData1_1"),
                ControlExample.getResourceString("ListData1_2"),
                ControlExample.getResourceString("ListData1_3"),
                ControlExample.getResourceString("ListData1_4"),
                ControlExample.getResourceString("ListData1_5"),
                ControlExample.getResourceString("ListData1_6"),
                ControlExample.getResourceString("ListData1_7"),
                ControlExample.getResourceString("ListData1_8")];
        }
    }

    /**
     * Creates the "Example" group.
     */
    void createExampleGroup () {
        super.createExampleGroup ();

        /* Create a group for the list */
        listGroup = new Group (exampleGroup, DWT.NONE);
        listGroup.setLayout (new GridLayout ());
        listGroup.setLayoutData (new GridData (DWT.FILL, DWT.FILL, true, true));
        listGroup.setText ("List");
    }

    /**
     * Creates the "Example" widgets.
     */
    void createExampleWidgets () {

        /* Compute the widget style */
        int style = getDefaultStyle();
        if (singleButton.getSelection ()) style |= DWT.SINGLE;
        if (multiButton.getSelection ()) style |= DWT.MULTI;
        if (horizontalButton.getSelection ()) style |= DWT.H_SCROLL;
        if (verticalButton.getSelection ()) style |= DWT.V_SCROLL;
        if (borderButton.getSelection ()) style |= DWT.BORDER;

        /* Create the example widgets */
        list1 = new List (listGroup, style);
        list1.setItems (ListData1);
    }

    /**
     * Gets the "Example" widget children.
     */
    Widget [] getExampleWidgets () {
        return [cast(Widget) list1];
    }

    /**
     * Returns a list of set/get API method names (without the set/get prefix)
     * that can be used to set/get values in the example control(s).
     */
    char[][] getMethodNames() {
        return ["Items", "Selection", "ToolTipText", "TopIndex" ];
    }

    /**
     * Gets the text for the tab folder item.
     */
    char[] getTabText () {
        return "List";
    }
}
