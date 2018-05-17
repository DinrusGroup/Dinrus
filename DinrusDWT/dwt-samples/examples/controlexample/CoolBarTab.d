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
module examples.controlexample.CoolBarTab;



import dwt.DWT;
import dwt.events.MenuAdapter;
import dwt.events.MenuEvent;
import dwt.events.SelectionAdapter;
import dwt.events.SelectionEvent;
import dwt.graphics.Image;
import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.widgets.Button;
import dwt.widgets.Control;
import dwt.widgets.CoolBar;
import dwt.widgets.CoolItem;
import dwt.widgets.Event;
import dwt.widgets.Group;
import dwt.widgets.Item;
import dwt.widgets.Listener;
import dwt.widgets.Menu;
import dwt.widgets.MenuItem;
import dwt.widgets.Text;
import dwt.widgets.ToolBar;
import dwt.widgets.ToolItem;
import dwt.widgets.Widget;

import examples.controlexample.Tab;
import examples.controlexample.ControlExample;
import tango.util.Convert;

class CoolBarTab : Tab {
    /* Example widgets and group that contains them */
    CoolBar coolBar;
    CoolItem pushItem, dropDownItem, radioItem, checkItem, textItem;
    Group coolBarGroup;

    /* Style widgets added to the "Style" group */
    Button horizontalButton, verticalButton;
    Button dropDownButton, flatButton;

    /* Other widgets added to the "Other" group */
    Button lockedButton;

    Point[] sizes;
    int[] wrapIndices;
    int[] order;

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

        /* Create display controls specific to this example */
        lockedButton = new Button (otherGroup, DWT.CHECK);
        lockedButton.setText (ControlExample.getResourceString("Locked"));

        /* Add the listeners */
        lockedButton.addSelectionListener (new class() SelectionAdapter {
            public void widgetSelected (SelectionEvent event) {
                setWidgetLocked ();
            }
        });
    }

    /**
     * Creates the "Example" group.
     */
    void createExampleGroup () {
        super.createExampleGroup ();
        coolBarGroup = new Group (exampleGroup, DWT.NONE);
        coolBarGroup.setLayout (new GridLayout ());
        coolBarGroup.setLayoutData (new GridData (DWT.FILL, DWT.FILL, true, true));
        coolBarGroup.setText ("CoolBar");
    }

    /**
     * Creates the "Example" widgets.
     */
    void createExampleWidgets () {
        int style = getDefaultStyle(), itemStyle = 0;

        /* Compute the widget, item, and item toolBar styles */
        int toolBarStyle = DWT.FLAT;
        bool vertical = false;
        if (horizontalButton.getSelection ()) {
            style |= DWT.HORIZONTAL;
            toolBarStyle |= DWT.HORIZONTAL;
        }
        if (verticalButton.getSelection ()) {
            style |= DWT.VERTICAL;
            toolBarStyle |= DWT.VERTICAL;
            vertical = true;
        }
        if (borderButton.getSelection()) style |= DWT.BORDER;
        if (flatButton.getSelection()) style |= DWT.FLAT;
        if (dropDownButton.getSelection()) itemStyle |= DWT.DROP_DOWN;

        /*
        * Create the example widgets.
        */
        coolBar = new CoolBar (coolBarGroup, style);

        /* Create the push button toolbar cool item */
        ToolBar toolBar = new ToolBar (coolBar, toolBarStyle);
        ToolItem item = new ToolItem (toolBar, DWT.PUSH);
        item.setImage (instance.images[ControlExample.ciClosedFolder]);
        item.setToolTipText ("DWT.PUSH");
        item = new ToolItem (toolBar, DWT.PUSH);
        item.setImage (instance.images[ControlExample.ciOpenFolder]);
        item.setToolTipText ("DWT.PUSH");
        item = new ToolItem (toolBar, DWT.PUSH);
        item.setImage (instance.images[ControlExample.ciTarget]);
        item.setToolTipText ("DWT.PUSH");
        item = new ToolItem (toolBar, DWT.SEPARATOR);
        item = new ToolItem (toolBar, DWT.PUSH);
        item.setImage (instance.images[ControlExample.ciClosedFolder]);
        item.setToolTipText ("DWT.PUSH");
        item = new ToolItem (toolBar, DWT.PUSH);
        item.setImage (instance.images[ControlExample.ciOpenFolder]);
        item.setToolTipText ("DWT.PUSH");
        pushItem = new CoolItem (coolBar, itemStyle);
        pushItem.setControl (toolBar);
        pushItem.addSelectionListener (new CoolItemSelectionListener());

        /* Create the dropdown toolbar cool item */
        toolBar = new ToolBar (coolBar, toolBarStyle);
        item = new ToolItem (toolBar, DWT.DROP_DOWN);
        item.setImage (instance.images[ControlExample.ciOpenFolder]);
        item.setToolTipText ("DWT.DROP_DOWN");
        item.addSelectionListener (new DropDownSelectionListener());
        item = new ToolItem (toolBar, DWT.DROP_DOWN);
        item.setImage (instance.images[ControlExample.ciClosedFolder]);
        item.setToolTipText ("DWT.DROP_DOWN");
        item.addSelectionListener (new DropDownSelectionListener());
        dropDownItem = new CoolItem (coolBar, itemStyle);
        dropDownItem.setControl (toolBar);
        dropDownItem.addSelectionListener (new CoolItemSelectionListener());

        /* Create the radio button toolbar cool item */
        toolBar = new ToolBar (coolBar, toolBarStyle);
        item = new ToolItem (toolBar, DWT.RADIO);
        item.setImage (instance.images[ControlExample.ciClosedFolder]);
        item.setToolTipText ("DWT.RADIO");
        item = new ToolItem (toolBar, DWT.RADIO);
        item.setImage (instance.images[ControlExample.ciClosedFolder]);
        item.setToolTipText ("DWT.RADIO");
        item = new ToolItem (toolBar, DWT.RADIO);
        item.setImage (instance.images[ControlExample.ciClosedFolder]);
        item.setToolTipText ("DWT.RADIO");
        radioItem = new CoolItem (coolBar, itemStyle);
        radioItem.setControl (toolBar);
        radioItem.addSelectionListener (new CoolItemSelectionListener());

        /* Create the check button toolbar cool item */
        toolBar = new ToolBar (coolBar, toolBarStyle);
        item = new ToolItem (toolBar, DWT.CHECK);
        item.setImage (instance.images[ControlExample.ciClosedFolder]);
        item.setToolTipText ("DWT.CHECK");
        item = new ToolItem (toolBar, DWT.CHECK);
        item.setImage (instance.images[ControlExample.ciTarget]);
        item.setToolTipText ("DWT.CHECK");
        item = new ToolItem (toolBar, DWT.CHECK);
        item.setImage (instance.images[ControlExample.ciOpenFolder]);
        item.setToolTipText ("DWT.CHECK");
        item = new ToolItem (toolBar, DWT.CHECK);
        item.setImage (instance.images[ControlExample.ciTarget]);
        item.setToolTipText ("DWT.CHECK");
        checkItem = new CoolItem (coolBar, itemStyle);
        checkItem.setControl (toolBar);
        checkItem.addSelectionListener (new CoolItemSelectionListener());

        /* Create the text cool item */
        if (!vertical) {
            Text text = new Text (coolBar, DWT.BORDER | DWT.SINGLE);
            textItem = new CoolItem (coolBar, itemStyle);
            textItem.setControl (text);
            textItem.addSelectionListener (new CoolItemSelectionListener());
            Point textSize = text.computeSize(DWT.DEFAULT, DWT.DEFAULT);
            textSize = textItem.computeSize(textSize.x, textSize.y);
            textItem.setMinimumSize(textSize);
            textItem.setPreferredSize(textSize);
            textItem.setSize(textSize);
        }

        /* Set the sizes after adding all cool items */
        CoolItem[] coolItems = coolBar.getItems();
        for (int i = 0; i < coolItems.length; i++) {
            CoolItem coolItem = coolItems[i];
            Control control = coolItem.getControl();
            Point size = control.computeSize(DWT.DEFAULT, DWT.DEFAULT);
            Point coolSize = coolItem.computeSize(size.x, size.y);
            if ( auto bar = cast(ToolBar)control ) {
                if (bar.getItemCount() > 0) {
                    if (vertical) {
                        size.y = bar.getItem(0).getBounds().height;
                    } else {
                        size.x = bar.getItem(0).getWidth();
                    }
                }
            }
            coolItem.setMinimumSize(size);
            coolItem.setPreferredSize(coolSize);
            coolItem.setSize(coolSize);
        }

        /* If we have saved state, restore it */
        if (order !is null && order.length is coolBar.getItemCount()) {
            coolBar.setItemLayout(order, wrapIndices, sizes);
        } else {
            coolBar.setWrapIndices([1, 3]);
        }

        /* Add a listener to resize the group box to match the coolbar */
        coolBar.addListener(DWT.Resize, new class() Listener {
            public void handleEvent(Event event) {
                exampleGroup.layout();
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
        borderButton = new Button (styleGroup, DWT.CHECK);
        borderButton.setText ("DWT.BORDER");
        flatButton = new Button (styleGroup, DWT.CHECK);
        flatButton.setText ("DWT.FLAT");
        Group itemGroup = new Group(styleGroup, DWT.NONE);
        itemGroup.setLayout (new GridLayout ());
        itemGroup.setLayoutData (new GridData (GridData.HORIZONTAL_ALIGN_FILL | GridData.VERTICAL_ALIGN_FILL));
        itemGroup.setText(ControlExample.getResourceString("Item_Styles"));
        dropDownButton = new Button (itemGroup, DWT.CHECK);
        dropDownButton.setText ("DWT.DROP_DOWN");
    }

    /**
     * Disposes the "Example" widgets.
     */
    void disposeExampleWidgets () {
        /* store the state of the toolbar if applicable */
        if (coolBar !is null) {
            sizes = coolBar.getItemSizes();
            wrapIndices = coolBar.getWrapIndices();
            order = coolBar.getItemOrder();
        }
        super.disposeExampleWidgets();
    }

    /**
     * Gets the "Example" widget children's items, if any.
     *
     * @return an array containing the example widget children's items
     */
    Item [] getExampleWidgetItems () {
        return coolBar.getItems();
    }

    /**
     * Gets the "Example" widget children.
     */
    Widget [] getExampleWidgets () {
        return [ cast(Widget) coolBar];
    }

    /**
     * Returns a list of set/get API method names (without the set/get prefix)
     * that can be used to set/get values in the example control(s).
     */
    char[][] getMethodNames() {
        return ["ToolTipText"];
    }

    /**
     * Gets the short text for the tab folder item.
     */
    public char[] getShortTabText() {
        return "CB";
    }

    /**
     * Gets the text for the tab folder item.
     */
    char[] getTabText () {
        return "CoolBar";
    }

    /**
     * Sets the state of the "Example" widgets.
     */
    void setExampleWidgetState () {
        super.setExampleWidgetState ();
        horizontalButton.setSelection ((coolBar.getStyle () & DWT.HORIZONTAL) !is 0);
        verticalButton.setSelection ((coolBar.getStyle () & DWT.VERTICAL) !is 0);
        borderButton.setSelection ((coolBar.getStyle () & DWT.BORDER) !is 0);
        flatButton.setSelection ((coolBar.getStyle () & DWT.FLAT) !is 0);
        dropDownButton.setSelection ((coolBar.getItem(0).getStyle () & DWT.DROP_DOWN) !is 0);
        lockedButton.setSelection(coolBar.getLocked());
        if (!instance.startup) setWidgetLocked ();
    }

    /**
     * Sets the header visible state of the "Example" widgets.
     */
    void setWidgetLocked () {
        coolBar.setLocked (lockedButton.getSelection ());
    }

    /**
     * Listens to widgetSelected() events on DWT.DROP_DOWN type ToolItems
     * and opens/closes a menu when appropriate.
     */
    class DropDownSelectionListener : SelectionAdapter {
        private Menu menu = null;
        private bool visible = false;

        public void widgetSelected(SelectionEvent event) {
            // Create the menu if it has not already been created
            if (menu is null) {
                // Lazy create the menu.
                menu = new Menu(shell);
                menu.addMenuListener(new class() MenuAdapter {
                    public void menuHidden(MenuEvent e) {
                        visible = false;
                    }
                });
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
                    ToolItem toolItem = cast(ToolItem) event.widget;
                    ToolBar  toolBar = toolItem.getParent();

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

    /**
     * Listens to widgetSelected() events on DWT.DROP_DOWN type CoolItems
     * and opens/closes a menu when appropriate.
     */
    class CoolItemSelectionListener : SelectionAdapter {
        private Menu menu = null;

        public void widgetSelected(SelectionEvent event) {
            /**
             * A selection event will be fired when the cool item
             * is selected by its gripper or if the drop down arrow
             * (or 'chevron') is selected. Examine the event detail
             * to determine where the widget was selected.
             */
            if (event.detail is DWT.ARROW) {
                /* If the popup menu is already up (i.e. user pressed arrow twice),
                 * then dispose it.
                 */
                if (menu !is null) {
                    menu.dispose();
                    menu = null;
                    return;
                }

                /* Get the cool item and convert its bounds to display coordinates. */
                CoolItem coolItem = cast(CoolItem) event.widget;
                Rectangle itemBounds = coolItem.getBounds ();
                itemBounds.width = event.x - itemBounds.x;
                Point pt = coolBar.toDisplay(new Point (itemBounds.x, itemBounds.y));
                itemBounds.x = pt.x;
                itemBounds.y = pt.y;

                /* Get the toolbar from the cool item. */
                ToolBar toolBar = cast(ToolBar) coolItem.getControl ();
                ToolItem[] tools = toolBar.getItems ();
                int toolCount = tools.length;

                /* Convert the bounds of each tool item to display coordinates,
                 * and determine which ones are past the bounds of the cool item.
                 */
                int i = 0;
                while (i < toolCount) {
                    Rectangle toolBounds = tools[i].getBounds ();
                    pt = toolBar.toDisplay(new Point(toolBounds.x, toolBounds.y));
                    toolBounds.x = pt.x;
                    toolBounds.y = pt.y;
                    Rectangle intersection = itemBounds.intersection (toolBounds);
                    if (intersection!=toolBounds) break;
                    i++;
                }

                /* Create a pop-up menu with items for each of the hidden buttons. */
                menu = new Menu (coolBar);
                for (int j = i; j < toolCount; j++) {
                    ToolItem tool = tools[j];
                    Image image = tool.getImage();
                    if (image is null) {
                        new MenuItem (menu, DWT.SEPARATOR);
                    } else {
                        if ((tool.getStyle() & DWT.DROP_DOWN) !is 0) {
                            MenuItem menuItem = new MenuItem (menu, DWT.CASCADE);
                            menuItem.setImage(image);
                            char[] text = tool.getToolTipText();
                            if (text !is null) menuItem.setText(text);
                            Menu m = new Menu(menu);
                            menuItem.setMenu(m);
                            for (int k = 0; k < 9; ++k) {
                                text = ControlExample.getResourceString("DropDownData_" ~ to!(char[])(k));
                                if (text.length !is 0) {
                                    MenuItem mi = new MenuItem(m, DWT.NONE);
                                    mi.setText(text);
                                    /* Application code to perform the action for the submenu item would go here. */
                                } else {
                                    new MenuItem(m, DWT.SEPARATOR);
                                }
                            }
                        } else {
                            MenuItem menuItem = new MenuItem (menu, DWT.NONE);
                            menuItem.setImage(image);
                            char[] text = tool.getToolTipText();
                            if (text !is null) menuItem.setText(text);
                        }
                        /* Application code to perform the action for the menu item would go here. */
                    }
                }

                /* Display the pop-up menu at the lower left corner of the arrow button.
                 * Dispose the menu when the user is done with it.
                 */
                pt = coolBar.toDisplay(new Point(event.x, event.y));
                menu.setLocation (pt.x, pt.y);
                menu.setVisible (true);
                while (menu !is null && !menu.isDisposed() && menu.isVisible ()) {
                    if (!display.readAndDispatch ()) display.sleep ();
                }
                if (menu !is null) {
                    menu.dispose ();
                    menu = null;
                }
            }
        }
    }
}
