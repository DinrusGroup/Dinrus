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
module examples.controlexample.TabFolderTab;



import dwt.DWT;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.widgets.Button;
import dwt.widgets.Group;
import dwt.widgets.Item;
import dwt.widgets.TabFolder;
import dwt.widgets.TabItem;
import dwt.widgets.Text;
import dwt.widgets.Widget;

import examples.controlexample.Tab;
import examples.controlexample.ControlExample;
import tango.text.convert.Format;

class TabFolderTab : Tab {
    /* Example widgets and groups that contain them */
    TabFolder tabFolder1;
    Group tabFolderGroup;

    /* Style widgets added to the "Style" group */
    Button topButton, bottomButton;

    static char[] [] TabItems1;

    /**
     * Creates the Tab within a given instance of ControlExample.
     */
    this(ControlExample instance) {
        super(instance);
        if( TabItems1.length is 0 ){
            TabItems1 = [
                ControlExample.getResourceString("TabItem1_0"),
                ControlExample.getResourceString("TabItem1_1"),
                ControlExample.getResourceString("TabItem1_2")];
        }
    }

    /**
     * Creates the "Example" group.
     */
    void createExampleGroup () {
        super.createExampleGroup ();

        /* Create a group for the TabFolder */
        tabFolderGroup = new Group (exampleGroup, DWT.NONE);
        tabFolderGroup.setLayout (new GridLayout ());
        tabFolderGroup.setLayoutData (new GridData (DWT.FILL, DWT.FILL, true, true));
        tabFolderGroup.setText ("TabFolder");
    }

    /**
     * Creates the "Example" widgets.
     */
    void createExampleWidgets () {

        /* Compute the widget style */
        int style = getDefaultStyle();
        if (topButton.getSelection ()) style |= DWT.TOP;
        if (bottomButton.getSelection ()) style |= DWT.BOTTOM;
        if (borderButton.getSelection ()) style |= DWT.BORDER;

        /* Create the example widgets */
        tabFolder1 = new TabFolder (tabFolderGroup, style);
        for (int i = 0; i < TabItems1.length; i++) {
            TabItem item = new TabItem(tabFolder1, DWT.NONE);
            item.setText(TabItems1[i]);
            item.setToolTipText(Format( ControlExample.getResourceString("Tooltip"), TabItems1[i] ));
            Text content = new Text(tabFolder1, DWT.WRAP | DWT.MULTI);
            content.setText(Format( "{}: {}", ControlExample.getResourceString("TabItem_content"), i));
            item.setControl(content);
        }
    }

    /**
     * Creates the "Style" group.
     */
    void createStyleGroup() {
        super.createStyleGroup ();

        /* Create the extra widgets */
        topButton = new Button (styleGroup, DWT.RADIO);
        topButton.setText ("DWT.TOP");
        topButton.setSelection(true);
        bottomButton = new Button (styleGroup, DWT.RADIO);
        bottomButton.setText ("DWT.BOTTOM");
        borderButton = new Button (styleGroup, DWT.CHECK);
        borderButton.setText ("DWT.BORDER");
    }

    /**
     * Gets the "Example" widget children's items, if any.
     *
     * @return an array containing the example widget children's items
     */
    Item [] getExampleWidgetItems () {
        return tabFolder1.getItems();
    }

    /**
     * Gets the "Example" widget children.
     */
    Widget [] getExampleWidgets () {
        return [cast(Widget) tabFolder1 ];
    }

    /**
     * Returns a list of set/get API method names (without the set/get prefix)
     * that can be used to set/get values in the example control(s).
     */
    char[][] getMethodNames() {
        return ["Selection", "SelectionIndex"];
    }

    char[] setMethodName(char[] methodRoot) {
        /* Override to handle special case of int getSelectionIndex()/setSelection(int) */
        return (methodRoot == "SelectionIndex") ? "setSelection" : "set" ~ methodRoot;
    }

//PROTING_LEFT
/+
    Object[] parameterForType(char[] typeName, char[] value, Widget widget) {
        if (value.length is 0 ) return new Object[] {new TabItem[0]};
        if (typeName.equals("org.eclipse.swt.widgets.TabItem")) {
            TabItem item = findItem(value, ((TabFolder) widget).getItems());
            if (item !is null) return new Object[] {item};
        }
        if (typeName.equals("[Lorg.eclipse.swt.widgets.TabItem;")) {
            char[][] values = split(value, ',');
            TabItem[] items = new TabItem[values.length];
            for (int i = 0; i < values.length; i++) {
                items[i] = findItem(values[i], ((TabFolder) widget).getItems());
            }
            return new Object[] {items};
        }
        return super.parameterForType(typeName, value, widget);
    }
+/
    TabItem findItem(char[] value, TabItem[] items) {
        for (int i = 0; i < items.length; i++) {
            TabItem item = items[i];
            if (item.getText() ==/*eq*/ value) return item;
        }
        return null;
    }

    /**
     * Gets the short text for the tab folder item.
     */
    public char[] getShortTabText() {
        return "TF";
    }

    /**
     * Gets the text for the tab folder item.
     */
    char[] getTabText () {
        return "TabFolder";
    }

    /**
     * Sets the state of the "Example" widgets.
     */
    void setExampleWidgetState () {
        super.setExampleWidgetState ();
        topButton.setSelection ((tabFolder1.getStyle () & DWT.TOP) !is 0);
        bottomButton.setSelection ((tabFolder1.getStyle () & DWT.BOTTOM) !is 0);
        borderButton.setSelection ((tabFolder1.getStyle () & DWT.BORDER) !is 0);
    }
}
