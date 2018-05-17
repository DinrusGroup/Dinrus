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
module examples.controlexample.AlignableTab;



import dwt.DWT;
import dwt.events.SelectionAdapter;
import dwt.events.SelectionEvent;
import dwt.events.SelectionListener;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.widgets.Button;
import dwt.widgets.Group;
import dwt.widgets.Widget;

import examples.controlexample.Tab;
import examples.controlexample.ControlExample;

/**
 * <code>AlignableTab</code> is the abstract
 * superclass of example controls that can be
 * aligned.
 */
abstract class AlignableTab : Tab {

    /* Alignment Controls */
    Button leftButton, rightButton, centerButton;

    /* Alignment Group */
    Group alignmentGroup;

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

        /* Create the group */
        alignmentGroup = new Group (otherGroup, DWT.NONE);
        alignmentGroup.setLayout (new GridLayout ());
        alignmentGroup.setLayoutData (new GridData(GridData.HORIZONTAL_ALIGN_FILL |
            GridData.VERTICAL_ALIGN_FILL));
        alignmentGroup.setText (ControlExample.getResourceString("Alignment"));

        /* Create the controls */
        leftButton = new Button (alignmentGroup, DWT.RADIO);
        leftButton.setText (ControlExample.getResourceString("Left"));
        centerButton = new Button (alignmentGroup, DWT.RADIO);
        centerButton.setText(ControlExample.getResourceString("Center"));
        rightButton = new Button (alignmentGroup, DWT.RADIO);
        rightButton.setText (ControlExample.getResourceString("Right"));

        /* Add the listeners */
        SelectionListener selectionListener = new class() SelectionAdapter {
            public void widgetSelected(SelectionEvent event) {
                if (!(cast(Button) event.widget).getSelection ()) return;
                setExampleWidgetAlignment ();
            }
        };
        leftButton.addSelectionListener (selectionListener);
        centerButton.addSelectionListener (selectionListener);
        rightButton.addSelectionListener (selectionListener);
    }

    /**
     * Sets the alignment of the "Example" widgets.
     */
    abstract void setExampleWidgetAlignment ();

    /**
     * Sets the state of the "Example" widgets.
     */
    void setExampleWidgetState () {
        super.setExampleWidgetState ();
        Widget [] widgets = getExampleWidgets ();
        if (widgets.length !is 0) {
            leftButton.setSelection ((widgets [0].getStyle () & DWT.LEFT) !is 0);
            centerButton.setSelection ((widgets [0].getStyle () & DWT.CENTER) !is 0);
            rightButton.setSelection ((widgets [0].getStyle () & DWT.RIGHT) !is 0);
        }
    }
}
