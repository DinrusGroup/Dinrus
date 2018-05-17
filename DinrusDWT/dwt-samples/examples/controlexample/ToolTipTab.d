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
module examples.controlexample.ToolTipTab;



import dwt.DWT;
import dwt.events.ControlAdapter;
import dwt.events.ControlEvent;
import dwt.events.DisposeEvent;
import dwt.events.DisposeListener;
import dwt.events.SelectionAdapter;
import dwt.events.SelectionEvent;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.widgets.Button;
import dwt.widgets.Composite;
import dwt.widgets.Group;
import dwt.widgets.TabFolder;
import dwt.widgets.ToolTip;
import dwt.widgets.Tray;
import dwt.widgets.TrayItem;
import dwt.widgets.Widget;

import examples.controlexample.Tab;
import examples.controlexample.ControlExample;

class ToolTipTab : Tab {

    /* Example widgets and groups that contain them */
    ToolTip toolTip1;
    Group toolTipGroup;

    /* Style widgets added to the "Style" group */
    Button balloonButton, iconErrorButton, iconInformationButton, iconWarningButton, noIconButton;

    /* Other widgets added to the "Other" group */
    Button autoHideButton, showInTrayButton;

    Tray tray;
    TrayItem trayItem;

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

        /* Create a group for the tooltip visibility check box */
        toolTipGroup = new Group (exampleGroup, DWT.NONE);
        toolTipGroup.setLayout (new GridLayout ());
        toolTipGroup.setLayoutData (new GridData (DWT.FILL, DWT.FILL, true, true));
        toolTipGroup.setText ("ToolTip");
        visibleButton = new Button(toolTipGroup, DWT.CHECK);
        visibleButton.setText(ControlExample.getResourceString("Visible"));
        visibleButton.addSelectionListener (new class() SelectionAdapter {
            public void widgetSelected (SelectionEvent event) {
                setExampleWidgetVisibility ();
            }
        });
    }

    /**
     * Creates the "Example" widgets.
     */
    void createExampleWidgets () {

        /* Compute the widget style */
        int style = getDefaultStyle();
        if (balloonButton.getSelection ()) style |= DWT.BALLOON;
        if (iconErrorButton.getSelection ()) style |= DWT.ICON_ERROR;
        if (iconInformationButton.getSelection ()) style |= DWT.ICON_INFORMATION;
        if (iconWarningButton.getSelection ()) style |= DWT.ICON_WARNING;

        /* Create the example widgets */
        toolTip1 = new ToolTip (shell, style);
        toolTip1.setText(ControlExample.getResourceString("ToolTip_Title"));
        toolTip1.setMessage(ControlExample.getResourceString("Example_string"));
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
        super.createStyleGroup ();

        /* Create the extra widgets */
        balloonButton = new Button (styleGroup, DWT.CHECK);
        balloonButton.setText ("DWT.BALLOON");
        iconErrorButton = new Button (styleGroup, DWT.RADIO);
        iconErrorButton.setText("DWT.ICON_ERROR");
        iconInformationButton = new Button (styleGroup, DWT.RADIO);
        iconInformationButton.setText("DWT.ICON_INFORMATION");
        iconWarningButton = new Button (styleGroup, DWT.RADIO);
        iconWarningButton.setText("DWT.ICON_WARNING");
        noIconButton = new Button (styleGroup, DWT.RADIO);
        noIconButton.setText(ControlExample.getResourceString("No_Icon"));
    }

    void createColorAndFontGroup () {
        // ToolTip does not need a color and font group.
    }

    void createOtherGroup () {
        /* Create the group */
        otherGroup = new Group (controlGroup, DWT.NONE);
        otherGroup.setLayout (new GridLayout ());
        otherGroup.setLayoutData (new GridData (DWT.FILL, DWT.FILL, false, false));
        otherGroup.setText (ControlExample.getResourceString("Other"));

        /* Create the controls */
        autoHideButton = new Button(otherGroup, DWT.CHECK);
        autoHideButton.setText(ControlExample.getResourceString("AutoHide"));
        showInTrayButton = new Button(otherGroup, DWT.CHECK);
        showInTrayButton.setText(ControlExample.getResourceString("Show_In_Tray"));
        tray = display.getSystemTray();
        showInTrayButton.setEnabled(tray !is null);

        /* Add the listeners */
        autoHideButton.addSelectionListener (new class() SelectionAdapter {
            public void widgetSelected (SelectionEvent event) {
                setExampleWidgetAutoHide ();
            }
        });
        showInTrayButton.addSelectionListener (new class() SelectionAdapter {
            public void widgetSelected (SelectionEvent event) {
                showExampleWidgetInTray ();
            }
        });
        shell.addDisposeListener(new class() DisposeListener {
            public void widgetDisposed(DisposeEvent event) {
                disposeTrayItem();
            }
        });

        /* Set the default state */
        autoHideButton.setSelection(true);
    }

    void createSizeGroup () {
        // ToolTip does not need a size group.
    }

    /**
     * Disposes the "Example" widgets.
     */
    void disposeExampleWidgets () {
        disposeTrayItem();
        super.disposeExampleWidgets();
    }

    /**
     * Gets the "Example" widget children.
     */
    // Tab uses this for many things - widgets would only get set/get, listeners, and dispose.
    Widget[] getExampleWidgets () {
        return [ cast(Widget) toolTip1 ];
    }

    /**
     * Returns a list of set/get API method names (without the set/get prefix)
     * that can be used to set/get values in the example control(s).
     */
    char[][] getMethodNames() {
        return ["Message", "Text"];
    }

    /**
     * Gets the text for the tab folder item.
     */
    char[] getTabText () {
        return "ToolTip";
    }

    /**
     * Sets the state of the "Example" widgets.
     */
    void setExampleWidgetState () {
        showExampleWidgetInTray ();
        setExampleWidgetAutoHide ();
        super.setExampleWidgetState ();
        balloonButton.setSelection ((toolTip1.getStyle () & DWT.BALLOON) !is 0);
        iconErrorButton.setSelection ((toolTip1.getStyle () & DWT.ICON_ERROR) !is 0);
        iconInformationButton.setSelection ((toolTip1.getStyle () & DWT.ICON_INFORMATION) !is 0);
        iconWarningButton.setSelection ((toolTip1.getStyle () & DWT.ICON_WARNING) !is 0);
        noIconButton.setSelection ((toolTip1.getStyle () & (DWT.ICON_ERROR | DWT.ICON_INFORMATION | DWT.ICON_WARNING)) is 0);
        autoHideButton.setSelection(toolTip1.getAutoHide());
    }

    /**
     * Sets the visibility of the "Example" widgets.
     */
    void setExampleWidgetVisibility () {
        toolTip1.setVisible (visibleButton.getSelection ());
    }

    /**
     * Sets the autoHide state of the "Example" widgets.
     */
    void setExampleWidgetAutoHide () {
        toolTip1.setAutoHide(autoHideButton.getSelection ());
    }

    void showExampleWidgetInTray () {
        if (showInTrayButton.getSelection ()) {
            createTrayItem();
            trayItem.setToolTip(toolTip1);
        } else {
            disposeTrayItem();
        }
    }

    void createTrayItem() {
        if (trayItem is null) {
            trayItem = new TrayItem(tray, DWT.NONE);
            trayItem.setImage(instance.images[ControlExample.ciTarget]);
        }
    }

    void disposeTrayItem() {
        if (trayItem !is null) {
            trayItem.setToolTip(null);
            trayItem.dispose();
            trayItem = null;
        }
    }
}
