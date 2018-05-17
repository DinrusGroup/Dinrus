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
module examples.controlexample.ButtonTab;



import dwt.DWT;
import dwt.events.SelectionAdapter;
import dwt.events.SelectionEvent;
import dwt.events.SelectionListener;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.widgets.Button;
import dwt.widgets.Group;
import dwt.widgets.Widget;

import examples.controlexample.AlignableTab;
import examples.controlexample.ControlExample;

/**
 * <code>ButtonTab</code> is the class that
 * demonstrates DWT buttons.
 */
class ButtonTab : AlignableTab {

    /* Example widgets and groups that contain them */
    Button button1, button2, button3, button4, button5, button6, button7, button8, button9;
    Group textButtonGroup, imageButtonGroup, imagetextButtonGroup;

    /* Alignment widgets added to the "Control" group */
    Button upButton, downButton;

    /* Style widgets added to the "Style" group */
    Button pushButton, checkButton, radioButton, toggleButton, arrowButton, flatButton;

    /**
     * Creates the Tab within a given instance of ControlExample.
     */
    this(ControlExample instance) {
        super(instance);
    }

    /**
     * Creates the "Control" group.
     */
    void createControlGroup () {
        super.createControlGroup ();

        /* Create the controls */
        upButton = new Button (alignmentGroup, DWT.RADIO);
        upButton.setText (ControlExample.getResourceString("Up"));
        downButton = new Button (alignmentGroup, DWT.RADIO);
        downButton.setText (ControlExample.getResourceString("Down"));

        /* Add the listeners */
        SelectionListener selectionListener = new class() SelectionAdapter {
            public void widgetSelected(SelectionEvent event) {
                if (!(cast(Button) event.widget).getSelection()) return;
                setExampleWidgetAlignment ();
            }
        };
        upButton.addSelectionListener(selectionListener);
        downButton.addSelectionListener(selectionListener);
    }

    /**
     * Creates the "Example" group.
     */
    void createExampleGroup () {
        super.createExampleGroup ();

        /* Create a group for text buttons */
        textButtonGroup = new Group(exampleGroup, DWT.NONE);
        GridLayout gridLayout = new GridLayout ();
        textButtonGroup.setLayout(gridLayout);
        gridLayout.numColumns = 3;
        textButtonGroup.setLayoutData (new GridData (DWT.FILL, DWT.FILL, true, true));
        textButtonGroup.setText (ControlExample.getResourceString("Text_Buttons"));

        /* Create a group for the image buttons */
        imageButtonGroup = new Group(exampleGroup, DWT.NONE);
        gridLayout = new GridLayout();
        imageButtonGroup.setLayout(gridLayout);
        gridLayout.numColumns = 3;
        imageButtonGroup.setLayoutData (new GridData (DWT.FILL, DWT.FILL, true, true));
        imageButtonGroup.setText (ControlExample.getResourceString("Image_Buttons"));

        /* Create a group for the image and text buttons */
        imagetextButtonGroup = new Group(exampleGroup, DWT.NONE);
        gridLayout = new GridLayout();
        imagetextButtonGroup.setLayout(gridLayout);
        gridLayout.numColumns = 3;
        imagetextButtonGroup.setLayoutData (new GridData (DWT.FILL, DWT.FILL, true, true));
        imagetextButtonGroup.setText (ControlExample.getResourceString("Image_Text_Buttons"));
    }

    /**
     * Creates the "Example" widgets.
     */
    void createExampleWidgets () {

        /* Compute the widget style */
        int style = getDefaultStyle();
        if (pushButton.getSelection()) style |= DWT.PUSH;
        if (checkButton.getSelection()) style |= DWT.CHECK;
        if (radioButton.getSelection()) style |= DWT.RADIO;
        if (toggleButton.getSelection()) style |= DWT.TOGGLE;
        if (flatButton.getSelection()) style |= DWT.FLAT;
        if (borderButton.getSelection()) style |= DWT.BORDER;
        if (leftButton.getSelection()) style |= DWT.LEFT;
        if (rightButton.getSelection()) style |= DWT.RIGHT;
        if (arrowButton.getSelection()) {
            style |= DWT.ARROW;
            if (upButton.getSelection()) style |= DWT.UP;
            if (downButton.getSelection()) style |= DWT.DOWN;
        } else {
            if (centerButton.getSelection()) style |= DWT.CENTER;
        }

        /* Create the example widgets */
        button1 = new Button(textButtonGroup, style);
        button1.setText(ControlExample.getResourceString("One"));
        button2 = new Button(textButtonGroup, style);
        button2.setText(ControlExample.getResourceString("Two"));
        button3 = new Button(textButtonGroup, style);
        button3.setText(ControlExample.getResourceString("Three"));
        button4 = new Button(imageButtonGroup, style);
        button4.setImage(instance.images[ControlExample.ciClosedFolder]);
        button5 = new Button(imageButtonGroup, style);
        button5.setImage(instance.images[ControlExample.ciOpenFolder]);
        button6 = new Button(imageButtonGroup, style);
        button6.setImage(instance.images[ControlExample.ciTarget]);
        button7 = new Button(imagetextButtonGroup, style);
        button7.setText(ControlExample.getResourceString("One"));
        button7.setImage(instance.images[ControlExample.ciClosedFolder]);
        button8 = new Button(imagetextButtonGroup, style);
        button8.setText(ControlExample.getResourceString("Two"));
        button8.setImage(instance.images[ControlExample.ciOpenFolder]);
        button9 = new Button(imagetextButtonGroup, style);
        button9.setText(ControlExample.getResourceString("Three"));
        button9.setImage(instance.images[ControlExample.ciTarget]);
    }

    /**
     * Creates the "Style" group.
     */
    void createStyleGroup() {
        super.createStyleGroup ();

        /* Create the extra widgets */
        pushButton = new Button (styleGroup, DWT.RADIO);
        pushButton.setText("DWT.PUSH");
        checkButton = new Button (styleGroup, DWT.RADIO);
        checkButton.setText ("DWT.CHECK");
        radioButton = new Button (styleGroup, DWT.RADIO);
        radioButton.setText ("DWT.RADIO");
        toggleButton = new Button (styleGroup, DWT.RADIO);
        toggleButton.setText ("DWT.TOGGLE");
        arrowButton = new Button (styleGroup, DWT.RADIO);
        arrowButton.setText ("DWT.ARROW");
        flatButton = new Button (styleGroup, DWT.CHECK);
        flatButton.setText ("DWT.FLAT");
        borderButton = new Button (styleGroup, DWT.CHECK);
        borderButton.setText ("DWT.BORDER");
    }

    /**
     * Gets the "Example" widget children.
     */
    Widget [] getExampleWidgets () {
        return [ cast(Widget) button1, button2, button3, button4, button5, button6, button7, button8, button9 ];
    }

    /**
     * Returns a list of set/get API method names (without the set/get prefix)
     * that can be used to set/get values in the example control(s).
     */
    char[][] getMethodNames() {
        return [ cast(char[])"Selection", "Text", "ToolTipText" ];
    }

    /**
     * Gets the text for the tab folder item.
     */
    char[] getTabText () {
        return "Button";
    }

    /**
     * Sets the alignment of the "Example" widgets.
     */
    void setExampleWidgetAlignment () {
        int alignment = 0;
        if (leftButton.getSelection ()) alignment = DWT.LEFT;
        if (centerButton.getSelection ()) alignment = DWT.CENTER;
        if (rightButton.getSelection ()) alignment = DWT.RIGHT;
        if (upButton.getSelection ()) alignment = DWT.UP;
        if (downButton.getSelection ()) alignment = DWT.DOWN;
        button1.setAlignment (alignment);
        button2.setAlignment (alignment);
        button3.setAlignment (alignment);
        button4.setAlignment (alignment);
        button5.setAlignment (alignment);
        button6.setAlignment (alignment);
        button7.setAlignment (alignment);
        button8.setAlignment (alignment);
        button9.setAlignment (alignment);
    }

    /**
     * Sets the state of the "Example" widgets.
     */
    void setExampleWidgetState () {
        super.setExampleWidgetState ();
        if (arrowButton.getSelection ()) {
            upButton.setEnabled (true);
            centerButton.setEnabled (false);
            downButton.setEnabled (true);
        } else {
            upButton.setEnabled (false);
            centerButton.setEnabled (true);
            downButton.setEnabled (false);
        }
        upButton.setSelection ((button1.getStyle () & DWT.UP) !is 0);
        downButton.setSelection ((button1.getStyle () & DWT.DOWN) !is 0);
        pushButton.setSelection ((button1.getStyle () & DWT.PUSH) !is 0);
        checkButton.setSelection ((button1.getStyle () & DWT.CHECK) !is 0);
        radioButton.setSelection ((button1.getStyle () & DWT.RADIO) !is 0);
        toggleButton.setSelection ((button1.getStyle () & DWT.TOGGLE) !is 0);
        arrowButton.setSelection ((button1.getStyle () & DWT.ARROW) !is 0);
        flatButton.setSelection ((button1.getStyle () & DWT.FLAT) !is 0);
        borderButton.setSelection ((button1.getStyle () & DWT.BORDER) !is 0);
    }
}
