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
module examples.controlexample.ToolBarTab;



import dwt.DWT;
import dwt.events.SelectionAdapter;
import dwt.events.SelectionEvent;
import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.widgets.Button;
import dwt.widgets.Combo;
import dwt.widgets.Group;
import dwt.widgets.Item;
import dwt.widgets.Menu;
import dwt.widgets.MenuItem;
import dwt.widgets.ToolBar;
import dwt.widgets.ToolItem;
import dwt.widgets.Widget;

import examples.controlexample.Tab;
import examples.controlexample.ControlExample;

import dwt.dwthelper.utils;

import tango.util.Convert;

class ToolBarTab : Tab {
    /* Example widgets and groups that contain them */
    ToolBar imageToolBar, textToolBar, imageTextToolBar;
    Group imageToolBarGroup, textToolBarGroup, imageTextToolBarGroup;

    /* Style widgets added to the "Style" group */
    Button horizontalButton, verticalButton, flatButton, shadowOutButton, wrapButton, rightButton;

    /* Other widgets added to the "Other" group */
    Button comboChildButton;

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

        /* Create a group for the image tool bar */
        imageToolBarGroup = new Group (exampleGroup, DWT.NONE);
        imageToolBarGroup.setLayout (new GridLayout ());
        imageToolBarGroup.setLayoutData (new GridData (DWT.FILL, DWT.FILL, true, true));
        imageToolBarGroup.setText (ControlExample.getResourceString("Image_ToolBar"));

        /* Create a group for the text tool bar */
        textToolBarGroup = new Group (exampleGroup, DWT.NONE);
        textToolBarGroup.setLayout (new GridLayout ());
        textToolBarGroup.setLayoutData (new GridData (DWT.FILL, DWT.FILL, true, true));
        textToolBarGroup.setText (ControlExample.getResourceString("Text_ToolBar"));

        /* Create a group for the image and text tool bar */
        imageTextToolBarGroup = new Group (exampleGroup, DWT.NONE);
        imageTextToolBarGroup.setLayout (new GridLayout ());
        imageTextToolBarGroup.setLayoutData (new GridData (DWT.FILL, DWT.FILL, true, true));
        imageTextToolBarGroup.setText (ControlExample.getResourceString("ImageText_ToolBar"));
    }

    /**
     * Creates the "Example" widgets.
     */
    void createExampleWidgets () {

        /* Compute the widget style */
        int style = getDefaultStyle();
        if (horizontalButton.getSelection()) style |= DWT.HORIZONTAL;
        if (verticalButton.getSelection()) style |= DWT.VERTICAL;
        if (flatButton.getSelection()) style |= DWT.FLAT;
        if (wrapButton.getSelection()) style |= DWT.WRAP;
        if (borderButton.getSelection()) style |= DWT.BORDER;
        if (shadowOutButton.getSelection()) style |= DWT.SHADOW_OUT;
        if (rightButton.getSelection()) style |= DWT.RIGHT;

        /*
        * Create the example widgets.
        *
        * A tool bar must consist of all image tool
        * items or all text tool items but not both.
        */

        /* Create the image tool bar */
        imageToolBar = new ToolBar (imageToolBarGroup, style);
        ToolItem item = new ToolItem (imageToolBar, DWT.PUSH);
        item.setImage (instance.images[ControlExample.ciClosedFolder]);
        item.setToolTipText("DWT.PUSH");
        item = new ToolItem (imageToolBar, DWT.PUSH);
        item.setImage (instance.images[ControlExample.ciClosedFolder]);
        item.setToolTipText ("DWT.PUSH");
        item = new ToolItem (imageToolBar, DWT.RADIO);
        item.setImage (instance.images[ControlExample.ciOpenFolder]);
        item.setToolTipText ("DWT.RADIO");
        item = new ToolItem (imageToolBar, DWT.RADIO);
        item.setImage (instance.images[ControlExample.ciOpenFolder]);
        item.setToolTipText ("DWT.RADIO");
        item = new ToolItem (imageToolBar, DWT.CHECK);
        item.setImage (instance.images[ControlExample.ciTarget]);
        item.setToolTipText ("DWT.CHECK");
        item = new ToolItem (imageToolBar, DWT.RADIO);
        item.setImage (instance.images[ControlExample.ciClosedFolder]);
        item.setToolTipText ("DWT.RADIO");
        item = new ToolItem (imageToolBar, DWT.RADIO);
        item.setImage (instance.images[ControlExample.ciClosedFolder]);
        item.setToolTipText ("DWT.RADIO");
        item = new ToolItem (imageToolBar, DWT.SEPARATOR);
        item.setToolTipText("DWT.SEPARATOR");
        if (comboChildButton.getSelection ()) {
            Combo combo = new Combo (imageToolBar, DWT.NONE);
            combo.setItems (["250", "500", "750"]);
            combo.setText (combo.getItem (0));
            combo.pack ();
            item.setWidth (combo.getSize ().x);
            item.setControl (combo);
        }
        item = new ToolItem (imageToolBar, DWT.DROP_DOWN);
        item.setImage (instance.images[ControlExample.ciTarget]);
        item.setToolTipText ("DWT.DROP_DOWN");
        item.addSelectionListener(new DropDownSelectionListener());

        /* Create the text tool bar */
        textToolBar = new ToolBar (textToolBarGroup, style);
        item = new ToolItem (textToolBar, DWT.PUSH);
        item.setText (ControlExample.getResourceString("Push"));
        item.setToolTipText("DWT.PUSH");
        item = new ToolItem (textToolBar, DWT.PUSH);
        item.setText (ControlExample.getResourceString("Push"));
        item.setToolTipText("DWT.PUSH");
        item = new ToolItem (textToolBar, DWT.RADIO);
        item.setText (ControlExample.getResourceString("Radio"));
        item.setToolTipText("DWT.RADIO");
        item = new ToolItem (textToolBar, DWT.RADIO);
        item.setText (ControlExample.getResourceString("Radio"));
        item.setToolTipText("DWT.RADIO");
        item = new ToolItem (textToolBar, DWT.CHECK);
        item.setText (ControlExample.getResourceString("Check"));
        item.setToolTipText("DWT.CHECK");
        item = new ToolItem (textToolBar, DWT.RADIO);
        item.setText (ControlExample.getResourceString("Radio"));
        item.setToolTipText("DWT.RADIO");
        item = new ToolItem (textToolBar, DWT.RADIO);
        item.setText (ControlExample.getResourceString("Radio"));
        item.setToolTipText("DWT.RADIO");
        item = new ToolItem (textToolBar, DWT.SEPARATOR);
        item.setToolTipText("DWT.SEPARATOR");
        if (comboChildButton.getSelection ()) {
            Combo combo = new Combo (textToolBar, DWT.NONE);
            combo.setItems (["250", "500", "750"]);
            combo.setText (combo.getItem (0));
            combo.pack ();
            item.setWidth (combo.getSize ().x);
            item.setControl (combo);
        }
        item = new ToolItem (textToolBar, DWT.DROP_DOWN);
        item.setText (ControlExample.getResourceString("Drop_Down"));
        item.setToolTipText("DWT.DROP_DOWN");
        item.addSelectionListener(new DropDownSelectionListener());

        /* Create the image and text tool bar */
        imageTextToolBar = new ToolBar (imageTextToolBarGroup, style);
        item = new ToolItem (imageTextToolBar, DWT.PUSH);
        item.setImage (instance.images[ControlExample.ciClosedFolder]);
        item.setText (ControlExample.getResourceString("Push"));
        item.setToolTipText("DWT.PUSH");
        item = new ToolItem (imageTextToolBar, DWT.PUSH);
        item.setImage (instance.images[ControlExample.ciClosedFolder]);
        item.setText (ControlExample.getResourceString("Push"));
        item.setToolTipText("DWT.PUSH");
        item = new ToolItem (imageTextToolBar, DWT.RADIO);
        item.setImage (instance.images[ControlExample.ciOpenFolder]);
        item.setText (ControlExample.getResourceString("Radio"));
        item.setToolTipText("DWT.RADIO");
        item = new ToolItem (imageTextToolBar, DWT.RADIO);
        item.setImage (instance.images[ControlExample.ciOpenFolder]);
        item.setText (ControlExample.getResourceString("Radio"));
        item.setToolTipText("DWT.RADIO");
        item = new ToolItem (imageTextToolBar, DWT.CHECK);
        item.setImage (instance.images[ControlExample.ciTarget]);
        item.setText (ControlExample.getResourceString("Check"));
        item.setToolTipText("DWT.CHECK");
        item = new ToolItem (imageTextToolBar, DWT.RADIO);
        item.setImage (instance.images[ControlExample.ciClosedFolder]);
        item.setText (ControlExample.getResourceString("Radio"));
        item.setToolTipText("DWT.RADIO");
        item = new ToolItem (imageTextToolBar, DWT.RADIO);
        item.setImage (instance.images[ControlExample.ciClosedFolder]);
        item.setText (ControlExample.getResourceString("Radio"));
        item.setToolTipText("DWT.RADIO");
        item = new ToolItem (imageTextToolBar, DWT.SEPARATOR);
        item.setToolTipText("DWT.SEPARATOR");
        if (comboChildButton.getSelection ()) {
            Combo combo = new Combo (imageTextToolBar, DWT.NONE);
            combo.setItems (["250", "500", "750"]);
            combo.setText (combo.getItem (0));
            combo.pack ();
            item.setWidth (combo.getSize ().x);
            item.setControl (combo);
        }
        item = new ToolItem (imageTextToolBar, DWT.DROP_DOWN);
        item.setImage (instance.images[ControlExample.ciTarget]);
        item.setText (ControlExample.getResourceString("Drop_Down"));
        item.setToolTipText("DWT.DROP_DOWN");
        item.addSelectionListener(new DropDownSelectionListener());

        /*
        * Do not add the selection event for this drop down
        * tool item.  Without hooking the event, the drop down
        * widget does nothing special when the drop down area
        * is selected.
        */
    }

    /**
     * Creates the "Other" group.
     */
    void createOtherGroup () {
        super.createOtherGroup ();

        /* Create display controls specific to this example */
        comboChildButton = new Button (otherGroup, DWT.CHECK);
        comboChildButton.setText (ControlExample.getResourceString("Combo_child"));

        /* Add the listeners */
        comboChildButton.addSelectionListener (new class() SelectionAdapter {
            public void widgetSelected (SelectionEvent event) {
                recreateExampleWidgets ();
            }
        });
    }

    /**
     * Creates the "Style" group.
     */
    void createStyleGroup() {
        super.createStyleGroup();

        /* Create the extra widgets */
        horizontalButton = new Button (styleGroup, DWT.RADIO);
        horizontalButton.setText ("DWT.HORIZONTAL");
        verticalButton = new Button (styleGroup, DWT.RADIO);
        verticalButton.setText ("DWT.VERTICAL");
        flatButton = new Button (styleGroup, DWT.CHECK);
        flatButton.setText ("DWT.FLAT");
        shadowOutButton = new Button (styleGroup, DWT.CHECK);
        shadowOutButton.setText ("DWT.SHADOW_OUT");
        wrapButton = new Button (styleGroup, DWT.CHECK);
        wrapButton.setText ("DWT.WRAP");
        rightButton = new Button (styleGroup, DWT.CHECK);
        rightButton.setText ("DWT.RIGHT");
        borderButton = new Button (styleGroup, DWT.CHECK);
        borderButton.setText ("DWT.BORDER");
    }

    void disposeExampleWidgets () {
        super.disposeExampleWidgets ();
    }

    /**
     * Gets the "Example" widget children's items, if any.
     *
     * @return an array containing the example widget children's items
     */
    Item [] getExampleWidgetItems () {
        Item [] imageToolBarItems = imageToolBar.getItems();
        Item [] textToolBarItems = textToolBar.getItems();
        Item [] imageTextToolBarItems = imageTextToolBar.getItems();
        Item [] allItems = new Item [imageToolBarItems.length + textToolBarItems.length + imageTextToolBarItems.length];
        System.arraycopy(imageToolBarItems, 0, allItems, 0, imageToolBarItems.length);
        System.arraycopy(textToolBarItems, 0, allItems, imageToolBarItems.length, textToolBarItems.length);
        System.arraycopy(imageTextToolBarItems, 0, allItems, imageToolBarItems.length + textToolBarItems.length, imageTextToolBarItems.length);
        return allItems;
    }

    /**
     * Gets the "Example" widget children.
     */
    Widget [] getExampleWidgets () {
        return [ cast(Widget) imageToolBar, textToolBar, imageTextToolBar ];
    }

    /**
     * Gets the short text for the tab folder item.
     */
    public char[] getShortTabText() {
        return "TB";
    }

    /**
     * Gets the text for the tab folder item.
     */
    char[] getTabText () {
        return "ToolBar";
    }

    /**
     * Sets the state of the "Example" widgets.
     */
    void setExampleWidgetState () {
        super.setExampleWidgetState ();
        horizontalButton.setSelection ((imageToolBar.getStyle () & DWT.HORIZONTAL) !is 0);
        verticalButton.setSelection ((imageToolBar.getStyle () & DWT.VERTICAL) !is 0);
        flatButton.setSelection ((imageToolBar.getStyle () & DWT.FLAT) !is 0);
        wrapButton.setSelection ((imageToolBar.getStyle () & DWT.WRAP) !is 0);
        shadowOutButton.setSelection ((imageToolBar.getStyle () & DWT.SHADOW_OUT) !is 0);
        borderButton.setSelection ((imageToolBar.getStyle () & DWT.BORDER) !is 0);
        rightButton.setSelection ((imageToolBar.getStyle () & DWT.RIGHT) !is 0);
    }

    /**
     * Listens to widgetSelected() events on DWT.DROP_DOWN type ToolItems
     * and opens/closes a menu when appropriate.
     */
    class DropDownSelectionListener : SelectionAdapter {
        private Menu    menu = null;
        private bool visible = false;

        public void widgetSelected(SelectionEvent event) {
            // Create the menu if it has not already been created
            if (menu is null) {
                // Lazy create the menu.
                menu = new Menu(shell);
                for (int i = 0; i < 9; ++i) {
                    final char[] text = ControlExample.getResourceString("DropDownData_" ~ to!(char[])(i));
                    if (text.length !is 0) {
                        MenuItem menuItem = new MenuItem(menu, DWT.NONE);
                        menuItem.setText(text);
                        /*
                         * Add a menu selection listener so that the menu is hidden
                         * when the user selects an item from the drop down menu.
                         */
                        menuItem.addSelectionListener(new class() SelectionAdapter {
                            public void widgetSelected(SelectionEvent e) {
                                setMenuVisible(false);
                            }
                        });
                    } else {
                        new MenuItem(menu, DWT.SEPARATOR);
                    }
                }
            }

            /**
             * A selection event will be fired when a drop down tool
             * item is selected in the main area and in the drop
             * down arrow.  Examine the event detail to determine
             * where the widget was selected.
             */
            if (event.detail is DWT.ARROW) {
                /*
                 * The drop down arrow was selected.
                 */
                if (visible) {
                    // Hide the menu to give the Arrow the appearance of being a toggle button.
                    setMenuVisible(false);
                } else {
                    // Position the menu below and vertically aligned with the the drop down tool button.
                    final ToolItem toolItem = cast(ToolItem) event.widget;
                    final ToolBar  toolBar = toolItem.getParent();

                    Rectangle toolItemBounds = toolItem.getBounds();
                    Point point = toolBar.toDisplay(new Point(toolItemBounds.x, toolItemBounds.y));
                    menu.setLocation(point.x, point.y + toolItemBounds.height);
                    setMenuVisible(true);
                }
            } else {
                /*
                 * Main area of drop down tool item selected.
                 * An application would invoke the code to perform the action for the tool item.
                 */
            }
        }
        private void setMenuVisible(bool visible) {
            menu.setVisible(visible);
            this.visible = visible;
        }
    }
}
