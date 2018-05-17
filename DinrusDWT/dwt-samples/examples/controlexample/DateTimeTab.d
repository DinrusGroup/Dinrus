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
module examples.controlexample.DateTimeTab;



import dwt.DWT;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.widgets.Button;
import dwt.widgets.DateTime;
import dwt.widgets.Group;
import dwt.widgets.Widget;

import examples.controlexample.Tab;
import examples.controlexample.ControlExample;

class DateTimeTab : Tab {
    /* Example widgets and groups that contain them */
    DateTime dateTime1;
    Group dateTimeGroup;

    /* Style widgets added to the "Style" group */
    Button dateButton, timeButton, calendarButton, shortButton, mediumButton, longButton;

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
        dateTimeGroup = new Group (exampleGroup, DWT.NONE);
        dateTimeGroup.setLayout (new GridLayout ());
        dateTimeGroup.setLayoutData (new GridData (DWT.FILL, DWT.FILL, true, true));
        dateTimeGroup.setText ("DateTime");
    }

    /**
     * Creates the "Example" widgets.
     */
    void createExampleWidgets () {

        /* Compute the widget style */
        int style = getDefaultStyle();
        if (dateButton.getSelection ()) style |= DWT.DATE;
        if (timeButton.getSelection ()) style |= DWT.TIME;
        if (calendarButton.getSelection ()) style |= DWT.CALENDAR;
        if (shortButton.getSelection ()) style |= DWT.SHORT;
        if (mediumButton.getSelection ()) style |= DWT.MEDIUM;
        if (longButton.getSelection ()) style |= DWT.LONG;
        if (borderButton.getSelection ()) style |= DWT.BORDER;

        /* Create the example widgets */
        dateTime1 = new DateTime (dateTimeGroup, style);
    }

    /**
     * Creates the "Style" group.
     */
    void createStyleGroup() {
        super.createStyleGroup ();

        /* Create the extra widgets */
        dateButton = new Button(styleGroup, DWT.RADIO);
        dateButton.setText("DWT.DATE");
        timeButton = new Button(styleGroup, DWT.RADIO);
        timeButton.setText("DWT.TIME");
        calendarButton = new Button(styleGroup, DWT.RADIO);
        calendarButton.setText("DWT.CALENDAR");
        Group formatGroup = new Group(styleGroup, DWT.NONE);
        formatGroup.setLayout(new GridLayout());
        shortButton = new Button(formatGroup, DWT.RADIO);
        shortButton.setText("DWT.SHORT");
        mediumButton = new Button(formatGroup, DWT.RADIO);
        mediumButton.setText("DWT.MEDIUM");
        longButton = new Button(formatGroup, DWT.RADIO);
        longButton.setText("DWT.LONG");
        borderButton = new Button(styleGroup, DWT.CHECK);
        borderButton.setText("DWT.BORDER");
    }

    /**
     * Gets the "Example" widget children.
     */
    Widget [] getExampleWidgets () {
        return [dateTime1];
    }

    /**
     * Returns a list of set/get API method names (without the set/get prefix)
     * that can be used to set/get values in the example control(s).
     */
    char[][] getMethodNames() {
        return ["Day", "Hours", "Minutes", "Month", "Seconds", "Year"];
    }

    /**
     * Gets the text for the tab folder item.
     */
    char[] getTabText () {
        return "DateTime";
    }

    /**
     * Sets the state of the "Example" widgets.
     */
    void setExampleWidgetState () {
        super.setExampleWidgetState ();
        dateButton.setSelection ((dateTime1.getStyle () & DWT.DATE) !is 0);
        timeButton.setSelection ((dateTime1.getStyle () & DWT.TIME) !is 0);
        calendarButton.setSelection ((dateTime1.getStyle () & DWT.CALENDAR) !is 0);
        shortButton.setSelection ((dateTime1.getStyle () & DWT.SHORT) !is 0);
        mediumButton.setSelection ((dateTime1.getStyle () & DWT.MEDIUM) !is 0);
        longButton.setSelection ((dateTime1.getStyle () & DWT.LONG) !is 0);
        borderButton.setSelection ((dateTime1.getStyle () & DWT.BORDER) !is 0);
    }
}
