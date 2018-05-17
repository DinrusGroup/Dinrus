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
module examples.controlexample.LabelTab;



import dwt.DWT;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.widgets.Button;
import dwt.widgets.Group;
import dwt.widgets.Label;
import dwt.widgets.Widget;

import examples.controlexample.Tab;
import examples.controlexample.ControlExample;
import examples.controlexample.AlignableTab;

class LabelTab : AlignableTab {
    /* Example widgets and groups that contain them */
    Label label1, label2, label3, label4, label5, label6;
    Group textLabelGroup, imageLabelGroup;

    /* Style widgets added to the "Style" group */
    Button wrapButton, separatorButton, horizontalButton, verticalButton, shadowInButton, shadowOutButton, shadowNoneButton;

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
        textLabelGroup.setText (ControlExample.getResourceString("Text_Labels"));

        /* Create a group for the image labels */
        imageLabelGroup = new Group (exampleGroup, DWT.SHADOW_NONE);
        gridLayout = new GridLayout ();
        imageLabelGroup.setLayout (gridLayout);
        gridLayout.numColumns = 3;
        imageLabelGroup.setLayoutData (new GridData (DWT.FILL, DWT.FILL, true, true));
        imageLabelGroup.setText (ControlExample.getResourceString("Image_Labels"));
    }

    /**
     * Creates the "Example" widgets.
     */
    void createExampleWidgets () {

        /* Compute the widget style */
        int style = getDefaultStyle();
        if (wrapButton.getSelection ()) style |= DWT.WRAP;
        if (separatorButton.getSelection ()) style |= DWT.SEPARATOR;
        if (horizontalButton.getSelection ()) style |= DWT.HORIZONTAL;
        if (verticalButton.getSelection ()) style |= DWT.VERTICAL;
        if (shadowInButton.getSelection ()) style |= DWT.SHADOW_IN;
        if (shadowOutButton.getSelection ()) style |= DWT.SHADOW_OUT;
        if (shadowNoneButton.getSelection ()) style |= DWT.SHADOW_NONE;
        if (borderButton.getSelection ()) style |= DWT.BORDER;
        if (leftButton.getSelection ()) style |= DWT.LEFT;
        if (centerButton.getSelection ()) style |= DWT.CENTER;
        if (rightButton.getSelection ()) style |= DWT.RIGHT;

        /* Create the example widgets */
        label1 = new Label (textLabelGroup, style);
        label1.setText(ControlExample.getResourceString("One"));
        label2 = new Label (textLabelGroup, style);
        label2.setText(ControlExample.getResourceString("Two"));
        label3 = new Label (textLabelGroup, style);
        if (wrapButton.getSelection ()) {
            label3.setText (ControlExample.getResourceString("Wrap_Text"));
        } else {
            label3.setText (ControlExample.getResourceString("Three"));
        }
        label4 = new Label (imageLabelGroup, style);
        label4.setImage (instance.images[ControlExample.ciClosedFolder]);
        label5 = new Label (imageLabelGroup, style);
        label5.setImage (instance.images[ControlExample.ciOpenFolder]);
        label6 = new Label(imageLabelGroup, style);
        label6.setImage (instance.images[ControlExample.ciTarget]);
    }

    /**
     * Creates the "Style" group.
     */
    void createStyleGroup() {
        super.createStyleGroup ();

        /* Create the extra widgets */
        wrapButton = new Button (styleGroup, DWT.CHECK);
        wrapButton.setText ("DWT.WRAP");
        separatorButton = new Button (styleGroup, DWT.CHECK);
        separatorButton.setText ("DWT.SEPARATOR");
        horizontalButton = new Button (styleGroup, DWT.RADIO);
        horizontalButton.setText ("DWT.HORIZONTAL");
        verticalButton = new Button (styleGroup, DWT.RADIO);
        verticalButton.setText ("DWT.VERTICAL");
        Group styleSubGroup = new Group (styleGroup, DWT.NONE);
        styleSubGroup.setLayout (new GridLayout ());
        shadowInButton = new Button (styleSubGroup, DWT.RADIO);
        shadowInButton.setText ("DWT.SHADOW_IN");
        shadowOutButton = new Button (styleSubGroup, DWT.RADIO);
        shadowOutButton.setText ("DWT.SHADOW_OUT");
        shadowNoneButton = new Button (styleSubGroup, DWT.RADIO);
        shadowNoneButton.setText ("DWT.SHADOW_NONE");
        borderButton = new Button(styleGroup, DWT.CHECK);
        borderButton.setText("DWT.BORDER");
    }

    /**
     * Gets the "Example" widget children.
     */
    Widget [] getExampleWidgets () {
        return [ cast(Widget) label1, label2, label3, label4, label5, label6 ];
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
        return "Label";
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
        label4.setAlignment (alignment);
        label5.setAlignment (alignment);
        label6.setAlignment (alignment);
    }

    /**
     * Sets the state of the "Example" widgets.
     */
    void setExampleWidgetState () {
        super.setExampleWidgetState ();
        bool isSeparator = (label1.getStyle () & DWT.SEPARATOR) !is 0;
        wrapButton.setSelection (!isSeparator && (label1.getStyle () & DWT.WRAP) !is 0);
        leftButton.setSelection (!isSeparator && (label1.getStyle () & DWT.LEFT) !is 0);
        centerButton.setSelection (!isSeparator && (label1.getStyle () & DWT.CENTER) !is 0);
        rightButton.setSelection (!isSeparator && (label1.getStyle () & DWT.RIGHT) !is 0);
        shadowInButton.setSelection (isSeparator && (label1.getStyle () & DWT.SHADOW_IN) !is 0);
        shadowOutButton.setSelection (isSeparator && (label1.getStyle () & DWT.SHADOW_OUT) !is 0);
        shadowNoneButton.setSelection (isSeparator && (label1.getStyle () & DWT.SHADOW_NONE) !is 0);
        horizontalButton.setSelection (isSeparator && (label1.getStyle () & DWT.HORIZONTAL) !is 0);
        verticalButton.setSelection (isSeparator && (label1.getStyle () & DWT.VERTICAL) !is 0);
        wrapButton.setEnabled (!isSeparator);
        leftButton.setEnabled (!isSeparator);
        centerButton.setEnabled (!isSeparator);
        rightButton.setEnabled (!isSeparator);
        shadowInButton.setEnabled (isSeparator);
        shadowOutButton.setEnabled (isSeparator);
        shadowNoneButton.setEnabled (isSeparator);
        horizontalButton.setEnabled (isSeparator);
        verticalButton.setEnabled (isSeparator);
    }
}
