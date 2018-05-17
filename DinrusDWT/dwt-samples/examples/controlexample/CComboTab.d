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
module examples.controlexample.CComboTab;



import dwt.DWT;
import dwt.custom.CCombo;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.widgets.Button;
import dwt.widgets.Group;
import dwt.widgets.Widget;

import examples.controlexample.Tab;
import examples.controlexample.ControlExample;

class CComboTab : Tab {

    /* Example widgets and groups that contain them */
    CCombo combo1;
    Group comboGroup;

    /* Style widgets added to the "Style" group */
    Button flatButton, readOnlyButton;

    static char[] [] ListData;

    /**
     * Creates the Tab within a given instance of ControlExample.
     */
    this(ControlExample instance) {
        super(instance);
        if( ListData is null ){
            ListData = [
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

        /* Create a group for the combo box */
        comboGroup = new Group (exampleGroup, DWT.NONE);
        comboGroup.setLayout (new GridLayout ());
        comboGroup.setLayoutData (new GridData (DWT.FILL, DWT.FILL, true, true));
        comboGroup.setText (ControlExample.getResourceString("Custom_Combo"));
    }

    /**
     * Creates the "Example" widgets.
     */
    void createExampleWidgets () {

        /* Compute the widget style */
        int style = getDefaultStyle();
        if (flatButton.getSelection ()) style |= DWT.FLAT;
        if (readOnlyButton.getSelection ()) style |= DWT.READ_ONLY;
        if (borderButton.getSelection ()) style |= DWT.BORDER;

        /* Create the example widgets */
        combo1 = new CCombo (comboGroup, style);
        combo1.setItems (ListData);
        if (ListData.length >= 3) {
            combo1.setText(ListData [2]);
        }
    }

    /**
     * Creates the "Style" group.
     */
    void createStyleGroup () {
        super.createStyleGroup ();

        /* Create the extra widgets */
        readOnlyButton = new Button (styleGroup, DWT.CHECK);
        readOnlyButton.setText ("DWT.READ_ONLY");
        borderButton = new Button (styleGroup, DWT.CHECK);
        borderButton.setText ("DWT.BORDER");
        flatButton = new Button (styleGroup, DWT.CHECK);
        flatButton.setText ("DWT.FLAT");
    }

    /**
     * Gets the "Example" widget children.
     */
    Widget [] getExampleWidgets () {
        return [cast(Widget) combo1];
    }

    /**
     * Returns a list of set/get API method names (without the set/get prefix)
     * that can be used to set/get values in the example control(s).
     */
    char[][] getMethodNames() {
        return ["Editable", "Items", "Selection", "Text", "TextLimit", "ToolTipText", "VisibleItemCount"];
    }

    /**
     * Gets the text for the tab folder item.
     */
    char[] getTabText () {
        return "CCombo";
    }

    /**
     * Sets the state of the "Example" widgets.
     */
    void setExampleWidgetState () {
        super.setExampleWidgetState ();
        flatButton.setSelection ((combo1.getStyle () & DWT.FLAT) !is 0);
        readOnlyButton.setSelection ((combo1.getStyle () & DWT.READ_ONLY) !is 0);
        borderButton.setSelection ((combo1.getStyle () & DWT.BORDER) !is 0);
    }
}
