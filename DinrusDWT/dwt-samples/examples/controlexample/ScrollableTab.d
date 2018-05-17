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
module examples.controlexample.ScrollableTab;



import dwt.DWT;
import dwt.widgets.Button;
import dwt.widgets.Widget;

import examples.controlexample.Tab;
import examples.controlexample.ControlExample;

abstract class ScrollableTab : Tab {
    /* Style widgets added to the "Style" group */
    Button singleButton, multiButton, horizontalButton, verticalButton;

    /**
     * Creates the Tab within a given instance of ControlExample.
     */
    this(ControlExample instance) {
        super(instance);
    }

    /**
     * Creates the "Style" group.
     */
    void createStyleGroup () {
        super.createStyleGroup ();

        /* Create the extra widgets */
        singleButton = new Button (styleGroup, DWT.RADIO);
        singleButton.setText ("DWT.SINGLE");
        multiButton = new Button (styleGroup, DWT.RADIO);
        multiButton.setText ("DWT.MULTI");
        horizontalButton = new Button (styleGroup, DWT.CHECK);
        horizontalButton.setText ("DWT.H_SCROLL");
        horizontalButton.setSelection(true);
        verticalButton = new Button (styleGroup, DWT.CHECK);
        verticalButton.setText ("DWT.V_SCROLL");
        verticalButton.setSelection(true);
        borderButton = new Button (styleGroup, DWT.CHECK);
        borderButton.setText ("DWT.BORDER");
    }

    /**
     * Sets the state of the "Example" widgets.
     */
    void setExampleWidgetState () {
        super.setExampleWidgetState ();
        Widget [] widgets = getExampleWidgets ();
        if (widgets.length !is 0){
            singleButton.setSelection ((widgets [0].getStyle () & DWT.SINGLE) !is 0);
            multiButton.setSelection ((widgets [0].getStyle () & DWT.MULTI) !is 0);
            horizontalButton.setSelection ((widgets [0].getStyle () & DWT.H_SCROLL) !is 0);
            verticalButton.setSelection ((widgets [0].getStyle () & DWT.V_SCROLL) !is 0);
            borderButton.setSelection ((widgets [0].getStyle () & DWT.BORDER) !is 0);
        }
    }
}
