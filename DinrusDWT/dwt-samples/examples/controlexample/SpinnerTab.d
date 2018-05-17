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
module examples.controlexample.SpinnerTab;



import dwt.DWT;
import dwt.events.ControlAdapter;
import dwt.events.ControlEvent;
import dwt.events.SelectionAdapter;
import dwt.events.SelectionEvent;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.widgets.Button;
import dwt.widgets.Composite;
import dwt.widgets.Group;
import dwt.widgets.Spinner;
import dwt.widgets.TabFolder;
import dwt.widgets.Widget;

import examples.controlexample.Tab;
import examples.controlexample.ControlExample;
import examples.controlexample.RangeTab;

class SpinnerTab : RangeTab {

    /* Example widgets and groups that contain them */
    Spinner spinner1;
    Group spinnerGroup;

    /* Style widgets added to the "Style" group */
    Button readOnlyButton, wrapButton;

    /* Spinner widgets added to the "Control" group */
    Spinner incrementSpinner, pageIncrementSpinner, digitsSpinner;

    /**
     * Creates the Tab within a given instance of ControlExample.
     */
    this(ControlExample instance) {
        super(instance);
    }

    /**
     * Creates the "Control" widget children.
     */
    void createControlWidgets () {
        super.createControlWidgets ();
        createIncrementGroup ();
        createPageIncrementGroup ();
        createDigitsGroup ();
    }

    /**
     * Creates the "Example" group.
     */
    void createExampleGroup () {
        super.createExampleGroup ();

        /* Create a group for the spinner */
        spinnerGroup = new Group (exampleGroup, DWT.NONE);
        spinnerGroup.setLayout (new GridLayout ());
        spinnerGroup.setLayoutData (new GridData (DWT.FILL, DWT.FILL, true, true));
        spinnerGroup.setText ("Spinner");
    }

    /**
     * Creates the "Example" widgets.
     */
    void createExampleWidgets () {

        /* Compute the widget style */
        int style = getDefaultStyle();
        if (readOnlyButton.getSelection ()) style |= DWT.READ_ONLY;
        if (borderButton.getSelection ()) style |= DWT.BORDER;
        if (wrapButton.getSelection ()) style |= DWT.WRAP;

        /* Create the example widgets */
        spinner1 = new Spinner (spinnerGroup, style);
    }

    /**
     * Create a group of widgets to control the increment
     * attribute of the example widget.
     */
    void createIncrementGroup() {

        /* Create the group */
        Group incrementGroup = new Group (controlGroup, DWT.NONE);
        incrementGroup.setLayout (new GridLayout ());
        incrementGroup.setText (ControlExample.getResourceString("Increment"));
        incrementGroup.setLayoutData (new GridData (GridData.FILL_HORIZONTAL));

        /* Create the Spinner widget */
        incrementSpinner = new Spinner (incrementGroup, DWT.BORDER);
        incrementSpinner.setMaximum (100000);
        incrementSpinner.setSelection (getDefaultIncrement());
        incrementSpinner.setPageIncrement (100);
        incrementSpinner.setIncrement (1);
        incrementSpinner.setLayoutData (new GridData (DWT.FILL, DWT.CENTER, true, false));

        /* Add the listeners */
        incrementSpinner.addSelectionListener (new class() SelectionAdapter {
            public void widgetSelected (SelectionEvent e) {
                setWidgetIncrement ();
            }
        });
    }

    /**
     * Create a group of widgets to control the page increment
     * attribute of the example widget.
     */
    void createPageIncrementGroup() {

        /* Create the group */
        Group pageIncrementGroup = new Group (controlGroup, DWT.NONE);
        pageIncrementGroup.setLayout (new GridLayout ());
        pageIncrementGroup.setText (ControlExample.getResourceString("Page_Increment"));
        pageIncrementGroup.setLayoutData (new GridData (GridData.FILL_HORIZONTAL));

        /* Create the Spinner widget */
        pageIncrementSpinner = new Spinner (pageIncrementGroup, DWT.BORDER);
        pageIncrementSpinner.setMaximum (100000);
        pageIncrementSpinner.setSelection (getDefaultPageIncrement());
        pageIncrementSpinner.setPageIncrement (100);
        pageIncrementSpinner.setIncrement (1);
        pageIncrementSpinner.setLayoutData (new GridData (DWT.FILL, DWT.CENTER, true, false));

        /* Add the listeners */
        pageIncrementSpinner.addSelectionListener (new class() SelectionAdapter {
            public void widgetSelected (SelectionEvent event) {
                setWidgetPageIncrement ();
            }
        });
    }

    /**
     * Create a group of widgets to control the digits
     * attribute of the example widget.
     */
    void createDigitsGroup() {

        /* Create the group */
        Group digitsGroup = new Group (controlGroup, DWT.NONE);
        digitsGroup.setLayout (new GridLayout ());
        digitsGroup.setText (ControlExample.getResourceString("Digits"));
        digitsGroup.setLayoutData (new GridData (GridData.FILL_HORIZONTAL));

        /* Create the Spinner widget */
        digitsSpinner = new Spinner (digitsGroup, DWT.BORDER);
        digitsSpinner.setMaximum (100000);
        digitsSpinner.setSelection (getDefaultDigits());
        digitsSpinner.setPageIncrement (100);
        digitsSpinner.setIncrement (1);
        digitsSpinner.setLayoutData (new GridData (DWT.FILL, DWT.CENTER, true, false));

        /* Add the listeners */
        digitsSpinner.addSelectionListener (new class() SelectionAdapter {
            public void widgetSelected (SelectionEvent e) {
                setWidgetDigits ();
            }
        });
    }

    /**
     * Creates the tab folder page.
     *
     * @param tabFolder org.eclipse.swt.widgets.TabFolder
     * @return the new page for the tab folder
     */
    Composite createTabFolderPage (TabFolder tabFolder) {
        super.createTabFolderPage (tabFolder);

        /*
         * Add a resize listener to the tabFolderPage so that
         * if the user types into the example widget to change
         * its preferred size, and then resizes the shell, we
         * recalculate the preferred size correctly.
         */
        tabFolderPage.addControlListener(new class() ControlAdapter {
            public void controlResized(ControlEvent e) {
                setExampleWidgetSize ();
            }
        });

        return tabFolderPage;
    }

    /**
     * Creates the "Style" group.
     */
    void createStyleGroup () {
        orientationButtons = false;
        super.createStyleGroup ();

        /* Create the extra widgets */
        readOnlyButton = new Button (styleGroup, DWT.CHECK);
        readOnlyButton.setText ("DWT.READ_ONLY");
        wrapButton = new Button (styleGroup, DWT.CHECK);
        wrapButton.setText ("DWT.WRAP");
    }

    /**
     * Gets the "Example" widget children.
     */
    Widget [] getExampleWidgets () {
        return [ cast(Widget) spinner1 ];
    }

    /**
     * Returns a list of set/get API method names (without the set/get prefix)
     * that can be used to set/get values in the example control(s).
     */
    char[][] getMethodNames() {
        return ["Selection", "ToolTipText"];
    }

    /**
     * Gets the text for the tab folder item.
     */
    char[] getTabText () {
        return "Spinner";
    }

    /**
     * Sets the state of the "Example" widgets.
     */
    void setExampleWidgetState () {
        super.setExampleWidgetState ();
        readOnlyButton.setSelection ((spinner1.getStyle () & DWT.READ_ONLY) !is 0);
        wrapButton.setSelection ((spinner1.getStyle () & DWT.WRAP) !is 0);
        if (!instance.startup) {
            setWidgetIncrement ();
            setWidgetPageIncrement ();
            setWidgetDigits ();
        }
    }

    /**
     * Gets the default maximum of the "Example" widgets.
     */
    int getDefaultMaximum () {
        return spinner1.getMaximum();
    }

    /**
     * Gets the default minimim of the "Example" widgets.
     */
    int getDefaultMinimum () {
        return spinner1.getMinimum();
    }

    /**
     * Gets the default selection of the "Example" widgets.
     */
    int getDefaultSelection () {
        return spinner1.getSelection();
    }

    /**
     * Gets the default increment of the "Example" widgets.
     */
    int getDefaultIncrement () {
        return spinner1.getIncrement();
    }

    /**
     * Gets the default page increment of the "Example" widgets.
     */
    int getDefaultPageIncrement () {
        return spinner1.getPageIncrement();
    }

    /**
     * Gets the default digits of the "Example" widgets.
     */
    int getDefaultDigits () {
        return spinner1.getDigits();
    }

    /**
     * Sets the increment of the "Example" widgets.
     */
    void setWidgetIncrement () {
        spinner1.setIncrement (incrementSpinner.getSelection ());
    }

    /**
     * Sets the minimim of the "Example" widgets.
     */
    void setWidgetMaximum () {
        spinner1.setMaximum (maximumSpinner.getSelection ());
    }

    /**
     * Sets the minimim of the "Example" widgets.
     */
    void setWidgetMinimum () {
        spinner1.setMinimum (minimumSpinner.getSelection ());
    }

    /**
     * Sets the page increment of the "Example" widgets.
     */
    void setWidgetPageIncrement () {
        spinner1.setPageIncrement (pageIncrementSpinner.getSelection ());
    }

    /**
     * Sets the digits of the "Example" widgets.
     */
    void setWidgetDigits () {
        spinner1.setDigits (digitsSpinner.getSelection ());
    }

    /**
     * Sets the selection of the "Example" widgets.
     */
    void setWidgetSelection () {
        spinner1.setSelection (selectionSpinner.getSelection ());
    }
}
