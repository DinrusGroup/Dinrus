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
module examples.controlexample.SashFormTab;



import dwt.DWT;
import dwt.custom.SashForm;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.widgets.Button;
import dwt.widgets.Group;
import dwt.widgets.List;
import dwt.widgets.Text;
import dwt.widgets.Widget;

import examples.controlexample.Tab;
import examples.controlexample.ControlExample;


class SashFormTab : Tab {
    /* Example widgets and groups that contain them */
    Group sashFormGroup;
    SashForm form;
    List list1, list2;
    Text text;

    /* Style widgets added to the "Style" group */
    Button horizontalButton, verticalButton, smoothButton;

    static char[] [] ListData0;
    static char[] [] ListData1;


    /**
     * Creates the Tab within a given instance of ControlExample.
     */
    this(ControlExample instance) {
        super(instance);
        if( ListData0 is null ){
            ListData0 = [
                ControlExample.getResourceString("ListData0_0"), //$NON-NLS-1$
                ControlExample.getResourceString("ListData0_1"), //$NON-NLS-1$
                ControlExample.getResourceString("ListData0_2"), //$NON-NLS-1$
                ControlExample.getResourceString("ListData0_3"), //$NON-NLS-1$
                ControlExample.getResourceString("ListData0_4"), //$NON-NLS-1$
                ControlExample.getResourceString("ListData0_5"), //$NON-NLS-1$
                ControlExample.getResourceString("ListData0_6"), //$NON-NLS-1$
                ControlExample.getResourceString("ListData0_7")]; //$NON-NLS-1$

        }
        if( ListData1 is null ){
            ListData1 = [
                ControlExample.getResourceString("ListData1_0"), //$NON-NLS-1$
                ControlExample.getResourceString("ListData1_1"), //$NON-NLS-1$
                ControlExample.getResourceString("ListData1_2"), //$NON-NLS-1$
                ControlExample.getResourceString("ListData1_3"), //$NON-NLS-1$
                ControlExample.getResourceString("ListData1_4"), //$NON-NLS-1$
                ControlExample.getResourceString("ListData1_5"), //$NON-NLS-1$
                ControlExample.getResourceString("ListData1_6"), //$NON-NLS-1$
                ControlExample.getResourceString("ListData1_7")]; //$NON-NLS-1$
        }
    }
    void createExampleGroup () {
        super.createExampleGroup ();

        /* Create a group for the sashform widget */
        sashFormGroup = new Group (exampleGroup, DWT.NONE);
        sashFormGroup.setLayout (new GridLayout ());
        sashFormGroup.setLayoutData (new GridData (DWT.FILL, DWT.FILL, true, true));
        sashFormGroup.setText ("SashForm");
    }
    void createExampleWidgets () {

        /* Compute the widget style */
        int style = getDefaultStyle();
        if (horizontalButton.getSelection ()) style |= DWT.H_SCROLL;
        if (verticalButton.getSelection ()) style |= DWT.V_SCROLL;
        if (smoothButton.getSelection ()) style |= DWT.SMOOTH;

        /* Create the example widgets */
        form = new SashForm (sashFormGroup, style);
        list1 = new List (form, DWT.V_SCROLL | DWT.H_SCROLL | DWT.BORDER);
        list1.setItems (ListData0);
        list2 = new List (form, DWT.V_SCROLL | DWT.H_SCROLL | DWT.BORDER);
        list2.setItems (ListData1);
        text = new Text (form, DWT.MULTI | DWT.BORDER);
        text.setText (ControlExample.getResourceString("Multi_line")); //$NON-NLS-1$
        form.setWeights([1, 1, 1]);
    }
    /**
     * Creates the "Style" group.
     */
    void createStyleGroup() {
        super.createStyleGroup();

        /* Create the extra widgets */
        horizontalButton = new Button (styleGroup, DWT.RADIO);
        horizontalButton.setText ("DWT.HORIZONTAL");
        horizontalButton.setSelection(true);
        verticalButton = new Button (styleGroup, DWT.RADIO);
        verticalButton.setText ("DWT.VERTICAL");
        verticalButton.setSelection(false);
        smoothButton = new Button (styleGroup, DWT.CHECK);
        smoothButton.setText ("DWT.SMOOTH");
        smoothButton.setSelection(false);
    }

    /**
     * Gets the "Example" widget children.
     */
    Widget [] getExampleWidgets () {
        return [ cast(Widget) form];
    }

    /**
     * Gets the text for the tab folder item.
     */
    char[] getTabText () {
        return "SashForm"; //$NON-NLS-1$
    }

        /**
     * Sets the state of the "Example" widgets.
     */
    void setExampleWidgetState () {
        super.setExampleWidgetState ();
        horizontalButton.setSelection ((form.getStyle () & DWT.H_SCROLL) !is 0);
        verticalButton.setSelection ((form.getStyle () & DWT.V_SCROLL) !is 0);
        smoothButton.setSelection ((form.getStyle () & DWT.SMOOTH) !is 0);
    }
}
