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
module examples.controlexample.CLabelTab;



import dwt.DWT;
import dwt.custom.CLabel;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.widgets.Button;
import dwt.widgets.Group;
import dwt.widgets.Widget;


import examples.controlexample.AlignableTab;
import examples.controlexample.ControlExample;

import tango.text.convert.Format;

class CLabelTab : AlignableTab {
    /* Example widgets and groups that contain them */
    CLabel label1, label2, label3;
    Group textLabelGroup;

    /* Style widgets added to the "Style" group */
    Button shadowInButton, shadowOutButton, shadowNoneButton;

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

        /* Create a group for the text labels */
        textLabelGroup = new Group(exampleGroup, DWT.NONE);
        GridLayout gridLayout = new GridLayout ();
        textLabelGroup.setLayout (gridLayout);
        gridLayout.numColumns = 3;
        textLabelGroup.setLayoutData (new GridData (DWT.FILL, DWT.FILL, true, true));
        textLabelGroup.setText (ControlExample.getResourceString("Custom_Labels"));
    }

    /**
     * Creates the "Example" widgets.
     */
    void createExampleWidgets () {

        /* Compute the widget style */
        int style = getDefaultStyle();
        if (shadowInButton.getSelection ()) style |= DWT.SHADOW_IN;
        if (shadowNoneButton.getSelection ()) style |= DWT.SHADOW_NONE;
        if (shadowOutButton.getSelection ()) style |= DWT.SHADOW_OUT;
        if (leftButton.getSelection ()) style |= DWT.LEFT;
        if (centerButton.getSelection ()) style |= DWT.CENTER;
        if (rightButton.getSelection ()) style |= DWT.RIGHT;

        /* Create the example widgets */
        label1 = new CLabel (textLabelGroup, style);
        label1.setText(ControlExample.getResourceString("One"));
        label1.setImage (instance.images[ControlExample.ciClosedFolder]);
        label2 = new CLabel (textLabelGroup, style);
        label2.setImage (instance.images[ControlExample.ciTarget]);
        label3 = new CLabel (textLabelGroup, style);
        label3.setText(Format( "{}\n{}", ControlExample.getResourceString("Example_string"), ControlExample.getResourceString("One_Two_Three")));
    }

    /**
     * Creates the "Style" group.
     */
    void createStyleGroup() {
        super.createStyleGroup ();

        /* Create the extra widgets */
        shadowNoneButton = new Button (styleGroup, DWT.RADIO);
        shadowNoneButton.setText ("DWT.SHADOW_NONE");
        shadowInButton = new Button (styleGroup, DWT.RADIO);
        shadowInButton.setText ("DWT.SHADOW_IN");
        shadowOutButton = new Button (styleGroup, DWT.RADIO);
        shadowOutButton.setText ("DWT.SHADOW_OUT");
    }

    /**
     * Gets the "Example" widget children.
     */
    Widget [] getExampleWidgets () {
        return [ cast(Widget) label1, label2, label3];
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
        return "CLabel";
    }

    /**
     * Sets the alignment of the "Example" widgets.
     */
    void setExampleWidgetAlignment () {
        int alignment = 0;
        if (leftButton.getSelection ()) alignment = DWT.LEFT;
        if (centerButton.getSelection ()) alignment = DWT.CENTER;
        if (rightButton.getSelection ()) alignment = DWT.RIGHT;
        label1.setAlignment (alignment);
        label2.setAlignment (alignment);
        label3.setAlignment (alignment);
    }

    /**
     * Sets the state of the "Example" widgets.
     */
    void setExampleWidgetState () {
        super.setExampleWidgetState ();
        leftButton.setSelection ((label1.getStyle () & DWT.LEFT) !is 0);
        centerButton.setSelection ((label1.getStyle () & DWT.CENTER) !is 0);
        rightButton.setSelection ((label1.getStyle () & DWT.RIGHT) !is 0);
        shadowInButton.setSelection ((label1.getStyle () & DWT.SHADOW_IN) !is 0);
        shadowOutButton.setSelection ((label1.getStyle () & DWT.SHADOW_OUT) !is 0);
        shadowNoneButton.setSelection ((label1.getStyle () & (DWT.SHADOW_IN | DWT.SHADOW_OUT)) is 0);
    }
}
