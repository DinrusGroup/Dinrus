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
module examples.controlexample.TextTab;



import dwt.DWT;
import dwt.events.ControlAdapter;
import dwt.events.ControlEvent;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.widgets.Button;
import dwt.widgets.Composite;
import dwt.widgets.Group;
import dwt.widgets.TabFolder;
import dwt.widgets.Text;
import dwt.widgets.Widget;

import examples.controlexample.Tab;
import examples.controlexample.ControlExample;
import examples.controlexample.ScrollableTab;

class TextTab : ScrollableTab {
    /* Example widgets and groups that contain them */
    Text text;
    Group textGroup;

    /* Style widgets added to the "Style" group */
    Button wrapButton, readOnlyButton, passwordButton, searchButton, cancelButton;
    Button leftButton, centerButton, rightButton;

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

        /* Create a group for the text widget */
        textGroup = new Group (exampleGroup, DWT.NONE);
        textGroup.setLayout (new GridLayout ());
        textGroup.setLayoutData (new GridData (DWT.FILL, DWT.FILL, true, true));
        textGroup.setText ("Text");
    }

    /**
     * Creates the "Example" widgets.
     */
    void createExampleWidgets () {

        /* Compute the widget style */
        int style = getDefaultStyle();
        if (singleButton.getSelection ()) style |= DWT.SINGLE;
        if (multiButton.getSelection ()) style |= DWT.MULTI;
        if (horizontalButton.getSelection ()) style |= DWT.H_SCROLL;
        if (verticalButton.getSelection ()) style |= DWT.V_SCROLL;
        if (wrapButton.getSelection ()) style |= DWT.WRAP;
        if (readOnlyButton.getSelection ()) style |= DWT.READ_ONLY;
        if (passwordButton.getSelection ()) style |= DWT.PASSWORD;
        if (searchButton.getSelection ()) style |= DWT.SEARCH;
        if (cancelButton.getSelection ()) style |= DWT.CANCEL;
        if (borderButton.getSelection ()) style |= DWT.BORDER;
        if (leftButton.getSelection ()) style |= DWT.LEFT;
        if (centerButton.getSelection ()) style |= DWT.CENTER;
        if (rightButton.getSelection ()) style |= DWT.RIGHT;

        /* Create the example widgets */
        text = new Text (textGroup, style);
        text.setText (ControlExample.getResourceString("Example_string") ~ Text.DELIMITER ~ ControlExample.getResourceString("One_Two_Three"));
    }

    /**
     * Creates the "Style" group.
     */
    void createStyleGroup() {
        super.createStyleGroup();

        /* Create the extra widgets */
        wrapButton = new Button (styleGroup, DWT.CHECK);
        wrapButton.setText ("DWT.WRAP");
        readOnlyButton = new Button (styleGroup, DWT.CHECK);
        readOnlyButton.setText ("DWT.READ_ONLY");
        passwordButton = new Button (styleGroup, DWT.CHECK);
        passwordButton.setText ("DWT.PASSWORD");
        searchButton = new Button (styleGroup, DWT.CHECK);
        searchButton.setText ("DWT.SEARCH");
        cancelButton = new Button (styleGroup, DWT.CHECK);
        cancelButton.setText ("DWT.CANCEL");

        Composite alignmentGroup = new Composite (styleGroup, DWT.NONE);
        GridLayout layout = new GridLayout ();
        layout.marginWidth = layout.marginHeight = 0;
        alignmentGroup.setLayout (layout);
        alignmentGroup.setLayoutData (new GridData (GridData.FILL_BOTH));
        leftButton = new Button (alignmentGroup, DWT.RADIO);
        leftButton.setText ("DWT.LEFT");
        centerButton = new Button (alignmentGroup, DWT.RADIO);
        centerButton.setText ("DWT.CENTER");
        rightButton = new Button (alignmentGroup, DWT.RADIO);
        rightButton.setText ("DWT.RIGHT");
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
     * Gets the "Example" widget children.
     */
    Widget [] getExampleWidgets () {
        return [ cast(Widget) text];
    }

    /**
     * Returns a list of set/get API method names (without the set/get prefix)
     * that can be used to set/get values in the example control(s).
     */
    char[][] getMethodNames() {
        return ["DoubleClickEnabled", "EchoChar", "Editable", "Orientation", "Selection", "Tabs", "Text", "TextLimit", "ToolTipText", "TopIndex"];
    }

    /**
     * Gets the text for the tab folder item.
     */
    char[] getTabText () {
        return "Text";
    }

    /**
     * Sets the state of the "Example" widgets.
     */
    void setExampleWidgetState () {
        super.setExampleWidgetState ();
        wrapButton.setSelection ((text.getStyle () & DWT.WRAP) !is 0);
        readOnlyButton.setSelection ((text.getStyle () & DWT.READ_ONLY) !is 0);
        passwordButton.setSelection ((text.getStyle () & DWT.PASSWORD) !is 0);
        searchButton.setSelection ((text.getStyle () & DWT.SEARCH) !is 0);
        leftButton.setSelection ((text.getStyle () & DWT.LEFT) !is 0);
        centerButton.setSelection ((text.getStyle () & DWT.CENTER) !is 0);
        rightButton.setSelection ((text.getStyle () & DWT.RIGHT) !is 0);

        /* Special case: CANCEL and H_SCROLL have the same value,
         * so to avoid confusion, only set CANCEL if SEARCH is set. */
        if ((text.getStyle () & DWT.SEARCH) !is 0) {
            cancelButton.setSelection ((text.getStyle () & DWT.CANCEL) !is 0);
            horizontalButton.setSelection (false);
        } else {
            cancelButton.setSelection (false);
            horizontalButton.setSelection ((text.getStyle () & DWT.H_SCROLL) !is 0);
        }

        passwordButton.setEnabled ((text.getStyle () & DWT.SINGLE) !is 0);
        searchButton.setEnabled ((text.getStyle () & DWT.SINGLE) !is 0);
        cancelButton.setEnabled ((text.getStyle () & DWT.SEARCH) !is 0);
        wrapButton.setEnabled ((text.getStyle () & DWT.MULTI) !is 0);
        horizontalButton.setEnabled ((text.getStyle () & DWT.MULTI) !is 0);
        verticalButton.setEnabled ((text.getStyle () & DWT.MULTI) !is 0);
    }
}
