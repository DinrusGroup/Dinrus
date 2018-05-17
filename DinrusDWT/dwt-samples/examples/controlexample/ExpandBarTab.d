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
module examples.controlexample.ExpandBarTab;



import dwt.DWT;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.widgets.Button;
import dwt.widgets.Composite;
import dwt.widgets.ExpandBar;
import dwt.widgets.ExpandItem;
import dwt.widgets.Group;
import dwt.widgets.Label;
import dwt.widgets.Widget;

import examples.controlexample.Tab;
import examples.controlexample.ControlExample;

class ExpandBarTab : Tab {
    /* Example widgets and groups that contain them */
    ExpandBar expandBar1;
    Group expandBarGroup;

    /* Style widgets added to the "Style" group */
    Button verticalButton;

    /**
     * Creates the Tab within a given instance of ControlExample.
     */
    this(ControlExample instance) {
        super(instance);
    }

    /**
     * Creates the "Example" group.
     */
    void createExampleGroup () {
        super.createExampleGroup ();

        /* Create a group for the list */
        expandBarGroup = new Group (exampleGroup, DWT.NONE);
        expandBarGroup.setLayout (new GridLayout ());
        expandBarGroup.setLayoutData (new GridData (DWT.FILL, DWT.FILL, true, true));
        expandBarGroup.setText ("ExpandBar");
    }

    /**
     * Creates the "Example" widgets.
     */
    void createExampleWidgets () {

        /* Compute the widget style */
        int style = getDefaultStyle();
        if (borderButton.getSelection ()) style |= DWT.BORDER;
        if (verticalButton.getSelection()) style |= DWT.V_SCROLL;

        /* Create the example widgets */
        expandBar1 = new ExpandBar (expandBarGroup, style);

        // First item
        Composite composite = new Composite (expandBar1, DWT.NONE);
        composite.setLayout(new GridLayout ());
        (new Button (composite, DWT.PUSH)).setText("DWT.PUSH");
        (new Button (composite, DWT.RADIO)).setText("DWT.RADIO");
        (new Button (composite, DWT.CHECK)).setText("DWT.CHECK");
        (new Button (composite, DWT.TOGGLE)).setText("DWT.TOGGLE");
        ExpandItem item = new ExpandItem (expandBar1, DWT.NONE, 0);
        item.setText(ControlExample.getResourceString("Item1_Text"));
        item.setHeight(composite.computeSize(DWT.DEFAULT, DWT.DEFAULT).y);
        item.setControl(composite);
        item.setImage(instance.images[ControlExample.ciClosedFolder]);

        // Second item
        composite = new Composite (expandBar1, DWT.NONE);
        composite.setLayout(new GridLayout (2, false));
        (new Label (composite, DWT.NONE)).setImage(display.getSystemImage(DWT.ICON_ERROR));
        (new Label (composite, DWT.NONE)).setText("DWT.ICON_ERROR");
        (new Label (composite, DWT.NONE)).setImage(display.getSystemImage(DWT.ICON_INFORMATION));
        (new Label (composite, DWT.NONE)).setText("DWT.ICON_INFORMATION");
        (new Label (composite, DWT.NONE)).setImage(display.getSystemImage(DWT.ICON_WARNING));
        (new Label (composite, DWT.NONE)).setText("DWT.ICON_WARNING");
        (new Label (composite, DWT.NONE)).setImage(display.getSystemImage(DWT.ICON_QUESTION));
        (new Label (composite, DWT.NONE)).setText("DWT.ICON_QUESTION");
        item = new ExpandItem (expandBar1, DWT.NONE, 1);
        item.setText(ControlExample.getResourceString("Item2_Text"));
        item.setHeight(composite.computeSize(DWT.DEFAULT, DWT.DEFAULT).y);
        item.setControl(composite);
        item.setImage(instance.images[ControlExample.ciOpenFolder]);
        item.setExpanded(true);
    }

    /**
     * Creates the "Style" group.
     */
    void createStyleGroup() {
        super.createStyleGroup ();

        /* Create the extra widgets */
        verticalButton = new Button (styleGroup, DWT.CHECK);
        verticalButton.setText ("DWT.V_SCROLL");
        verticalButton.setSelection(true);
        borderButton = new Button(styleGroup, DWT.CHECK);
        borderButton.setText("DWT.BORDER");
    }

    /**
     * Gets the "Example" widget children.
     */
    Widget [] getExampleWidgets () {
        return [ cast(Widget) expandBar1];
    }

    /**
     * Returns a list of set/get API method names (without the set/get prefix)
     * that can be used to set/get values in the example control(s).
     */
    char[][] getMethodNames() {
        return ["Spacing"];
    }

    /**
     * Gets the short text for the tab folder item.
     */
    public char[] getShortTabText() {
        return "EB";
    }

    /**
     * Gets the text for the tab folder item.
     */
    char[] getTabText () {
        return "ExpandBar";
    }

    /**
     * Sets the state of the "Example" widgets.
     */
    void setExampleWidgetState () {
        super.setExampleWidgetState ();
        Widget [] widgets = getExampleWidgets ();
        if (widgets.length !is 0){
            verticalButton.setSelection ((widgets [0].getStyle () & DWT.V_SCROLL) !is 0);
            borderButton.setSelection ((widgets [0].getStyle () & DWT.BORDER) !is 0);
        }
    }
}
