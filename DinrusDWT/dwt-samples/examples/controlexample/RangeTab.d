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
module examples.controlexample.RangeTab;



import dwt.DWT;
import dwt.events.SelectionAdapter;
import dwt.events.SelectionEvent;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.widgets.Button;
import dwt.widgets.Group;
import dwt.widgets.Spinner;
import dwt.widgets.Widget;

import examples.controlexample.Tab;
import examples.controlexample.ControlExample;

abstract class RangeTab : Tab {
    /* Style widgets added to the "Style" group */
    Button horizontalButton, verticalButton;
    bool orientationButtons = true;

    /* Scale widgets added to the "Control" group */
    Spinner minimumSpinner, selectionSpinner, maximumSpinner;

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
        /* Create controls specific to this example */
        createMinimumGroup ();
        createMaximumGroup ();
        createSelectionGroup ();
    }

    /**
     * Create a group of widgets to control the maximum
     * attribute of the example widget.
     */
    void createMaximumGroup() {

        /* Create the group */
        Group maximumGroup = new Group (controlGroup, DWT.NONE);
        maximumGroup.setLayout (new GridLayout ());
        maximumGroup.setText (ControlExample.getResourceString("Maximum"));
        maximumGroup.setLayoutData (new GridData (GridData.FILL_HORIZONTAL));

        /* Create a Spinner widget */
        maximumSpinner = new Spinner (maximumGroup, DWT.BORDER);
        maximumSpinner.setMaximum (100000);
        maximumSpinner.setSelection (getDefaultMaximum());
        maximumSpinner.setPageIncrement (100);
        maximumSpinner.setIncrement (1);
        maximumSpinner.setLayoutData (new GridData (DWT.FILL, DWT.CENTER, true, false));

        /* Add the listeners */
        maximumSpinner.addSelectionListener(new class() SelectionAdapter {
            public void widgetSelected (SelectionEvent event) {
                setWidgetMaximum ();
            }
        });
    }

    /**
     * Create a group of widgets to control the minimum
     * attribute of the example widget.
     */
    void createMinimumGroup() {

        /* Create the group */
        Group minimumGroup = new Group (controlGroup, DWT.NONE);
        minimumGroup.setLayout (new GridLayout ());
        minimumGroup.setText (ControlExample.getResourceString("Minimum"));
        minimumGroup.setLayoutData (new GridData (GridData.FILL_HORIZONTAL));

        /* Create a Spinner widget */
        minimumSpinner = new Spinner (minimumGroup, DWT.BORDER);
        minimumSpinner.setMaximum (100000);
        minimumSpinner.setSelection(getDefaultMinimum());
        minimumSpinner.setPageIncrement (100);
        minimumSpinner.setIncrement (1);
        minimumSpinner.setLayoutData (new GridData (DWT.FILL, DWT.CENTER, true, false));

        /* Add the listeners */
        minimumSpinner.addSelectionListener (new class() SelectionAdapter {
            public void widgetSelected (SelectionEvent event) {
                setWidgetMinimum ();
            }
        });

    }

    /**
     * Create a group of widgets to control the selection
     * attribute of the example widget.
     */
    void createSelectionGroup() {

        /* Create the group */
        Group selectionGroup = new Group(controlGroup, DWT.NONE);
        selectionGroup.setLayout(new GridLayout());
        GridData gridData = new GridData(DWT.FILL, DWT.BEGINNING, false, false);
        selectionGroup.setLayoutData(gridData);
        selectionGroup.setText(ControlExample.getResourceString("Selection"));

        /* Create a Spinner widget */
        selectionSpinner = new Spinner (selectionGroup, DWT.BORDER);
        selectionSpinner.setMaximum (100000);
        selectionSpinner.setSelection (getDefaultSelection());
        selectionSpinner.setPageIncrement (100);
        selectionSpinner.setIncrement (1);
        selectionSpinner.setLayoutData (new GridData (DWT.FILL, DWT.CENTER, true, false));

        /* Add the listeners */
        selectionSpinner.addSelectionListener(new class() SelectionAdapter {
            public void widgetSelected(SelectionEvent event) {
                setWidgetSelection ();
            }
        });

    }

    /**
     * Creates the "Style" group.
     */
    void createStyleGroup () {
        super.createStyleGroup ();

        /* Create the extra widgets */
        if (orientationButtons) {
            horizontalButton = new Button (styleGroup, DWT.RADIO);
            horizontalButton.setText ("DWT.HORIZONTAL");
            verticalButton = new Button (styleGroup, DWT.RADIO);
            verticalButton.setText ("DWT.VERTICAL");
        }
        borderButton = new Button (styleGroup, DWT.CHECK);
        borderButton.setText ("DWT.BORDER");
    }

    /**
     * Sets the state of the "Example" widgets.
     */
    void setExampleWidgetState () {
        super.setExampleWidgetState ();
        if (!instance.startup) {
            setWidgetMinimum ();
            setWidgetMaximum ();
            setWidgetSelection ();
        }
        Widget [] widgets = getExampleWidgets ();
        if (widgets.length !is 0) {
            if (orientationButtons) {
                horizontalButton.setSelection ((widgets [0].getStyle () & DWT.HORIZONTAL) !is 0);
                verticalButton.setSelection ((widgets [0].getStyle () & DWT.VERTICAL) !is 0);
            }
            borderButton.setSelection ((widgets [0].getStyle () & DWT.BORDER) !is 0);
        }
    }

    /**
     * Gets the default maximum of the "Example" widgets.
     */
    abstract int getDefaultMaximum ();

    /**
     * Gets the default minimim of the "Example" widgets.
     */
    abstract int getDefaultMinimum ();

    /**
     * Gets the default selection of the "Example" widgets.
     */
    abstract int getDefaultSelection ();

    /**
     * Sets the maximum of the "Example" widgets.
     */
    abstract void setWidgetMaximum ();

    /**
     * Sets the minimim of the "Example" widgets.
     */
    abstract void setWidgetMinimum ();

    /**
     * Sets the selection of the "Example" widgets.
     */
    abstract void setWidgetSelection ();
}
