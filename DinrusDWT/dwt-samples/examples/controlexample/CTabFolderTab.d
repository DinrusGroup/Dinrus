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
module examples.controlexample.CTabFolderTab;



import dwt.DWT;
import dwt.custom.CTabFolder;
import dwt.custom.CTabFolder2Adapter;
import dwt.custom.CTabFolderEvent;
import dwt.custom.CTabItem;
import dwt.events.DisposeEvent;
import dwt.events.DisposeListener;
import dwt.events.SelectionAdapter;
import dwt.events.SelectionEvent;
import dwt.graphics.Color;
import dwt.graphics.Font;
import dwt.graphics.FontData;
import dwt.graphics.Image;
import dwt.graphics.RGB;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.widgets.Button;
import dwt.widgets.Event;
import dwt.widgets.Group;
import dwt.widgets.Item;
import dwt.widgets.Listener;
import dwt.widgets.TableItem;
import dwt.widgets.Text;
import dwt.widgets.Widget;

import examples.controlexample.Tab;
import examples.controlexample.ControlExample;

import tango.text.convert.Format;

class CTabFolderTab : Tab {
    int lastSelectedTab = 0;

    /* Example widgets and groups that contain them */
    CTabFolder tabFolder1;
    Group tabFolderGroup, itemGroup;

    /* Style widgets added to the "Style" group */
    Button topButton, bottomButton, flatButton, closeButton;

    static char[] [] CTabItems1;

    /* Controls and resources added to the "Fonts" group */
    static const int SELECTION_FOREGROUND_COLOR = 3;
    static const int SELECTION_BACKGROUND_COLOR = 4;
    static const int ITEM_FONT = 5;
    Color selectionForegroundColor, selectionBackgroundColor;
    Font itemFont;

    /* Other widgets added to the "Other" group */
    Button simpleTabButton, singleTabButton, imageButton, showMinButton, showMaxButton, unselectedCloseButton, unselectedImageButton;

    /**
     * Creates the Tab within a given instance of ControlExample.
     */
    this(ControlExample instance) {
        super(instance);
        if( CTabItems1 is null ){
            CTabItems1 = [
                ControlExample.getResourceString("CTabItem1_0"),
                ControlExample.getResourceString("CTabItem1_1"),
                ControlExample.getResourceString("CTabItem1_2")];
        }
    }

    /**
     * Creates the "Colors and Fonts" group.
     */
    void createColorAndFontGroup () {
        super.createColorAndFontGroup();

        TableItem item = new TableItem(colorAndFontTable, DWT.None);
        item.setText(ControlExample.getResourceString ("Selection_Foreground_Color"));
        item = new TableItem(colorAndFontTable, DWT.None);
        item.setText(ControlExample.getResourceString ("Selection_Background_Color"));
        item = new TableItem(colorAndFontTable, DWT.None);
        item.setText(ControlExample.getResourceString ("Item_Font"));

        shell.addDisposeListener(new class() DisposeListener {
            public void widgetDisposed(DisposeEvent event) {
                if (selectionBackgroundColor !is null) selectionBackgroundColor.dispose();
                if (selectionForegroundColor !is null) selectionForegroundColor.dispose();
                if (itemFont !is null) itemFont.dispose();
                selectionBackgroundColor = null;
                selectionForegroundColor = null;
                itemFont = null;
            }
        });
    }

    void changeFontOrColor(int index) {
        switch (index) {
            case SELECTION_FOREGROUND_COLOR: {
                Color oldColor = selectionForegroundColor;
                if (oldColor is null) oldColor = tabFolder1.getSelectionForeground();
                colorDialog.setRGB(oldColor.getRGB());
                RGB rgb = colorDialog.open();
                if (rgb is null) return;
                oldColor = selectionForegroundColor;
                selectionForegroundColor = new Color (display, rgb);
                setSelectionForeground ();
                if (oldColor !is null) oldColor.dispose ();
            }
            break;
            case SELECTION_BACKGROUND_COLOR: {
                Color oldColor = selectionBackgroundColor;
                if (oldColor is null) oldColor = tabFolder1.getSelectionBackground();
                colorDialog.setRGB(oldColor.getRGB());
                RGB rgb = colorDialog.open();
                if (rgb is null) return;
                oldColor = selectionBackgroundColor;
                selectionBackgroundColor = new Color (display, rgb);
                setSelectionBackground ();
                if (oldColor !is null) oldColor.dispose ();
            }
            break;
            case ITEM_FONT: {
                Font oldFont = itemFont;
                if (oldFont is null) oldFont = tabFolder1.getItem (0).getFont ();
                fontDialog.setFontList(oldFont.getFontData());
                FontData fontData = fontDialog.open ();
                if (fontData is null) return;
                oldFont = itemFont;
                itemFont = new Font (display, fontData);
                setItemFont ();
                setExampleWidgetSize ();
                if (oldFont !is null) oldFont.dispose ();
            }
            break;
            default:
                super.changeFontOrColor(index);
        }
    }

    /**
     * Creates the "Other" group.
     */
    void createOtherGroup () {
        super.createOtherGroup ();

        /* Create display controls specific to this example */
        simpleTabButton = new Button (otherGroup, DWT.CHECK);
        simpleTabButton.setText (ControlExample.getResourceString("Set_Simple_Tabs"));
        simpleTabButton.setSelection(true);
        simpleTabButton.addSelectionListener (new class() SelectionAdapter {
            public void widgetSelected (SelectionEvent event) {
                setSimpleTabs();
            }
        });

        singleTabButton = new Button (otherGroup, DWT.CHECK);
        singleTabButton.setText (ControlExample.getResourceString("Set_Single_Tabs"));
        singleTabButton.setSelection(false);
        singleTabButton.addSelectionListener (new class() SelectionAdapter {
            public void widgetSelected (SelectionEvent event) {
                setSingleTabs();
            }
        });

        showMinButton = new Button (otherGroup, DWT.CHECK);
        showMinButton.setText (ControlExample.getResourceString("Set_Min_Visible"));
        showMinButton.setSelection(false);
        showMinButton.addSelectionListener (new class() SelectionAdapter {
            public void widgetSelected (SelectionEvent event) {
                setMinimizeVisible();
            }
        });

        showMaxButton = new Button (otherGroup, DWT.CHECK);
        showMaxButton.setText (ControlExample.getResourceString("Set_Max_Visible"));
        showMaxButton.setSelection(false);
        showMaxButton.addSelectionListener (new class() SelectionAdapter {
            public void widgetSelected (SelectionEvent event) {
                setMaximizeVisible();
            }
        });

        imageButton = new Button (otherGroup, DWT.CHECK);
        imageButton.setText (ControlExample.getResourceString("Set_Image"));
        imageButton.addSelectionListener (new class() SelectionAdapter {
            public void widgetSelected (SelectionEvent event) {
                setImages();
            }
        });

        unselectedImageButton = new Button (otherGroup, DWT.CHECK);
        unselectedImageButton.setText (ControlExample.getResourceString("Set_Unselected_Image_Visible"));
        unselectedImageButton.setSelection(true);
        unselectedImageButton.addSelectionListener (new class() SelectionAdapter {
            public void widgetSelected (SelectionEvent event) {
                setUnselectedImageVisible();
            }
        });
        unselectedCloseButton = new Button (otherGroup, DWT.CHECK);
        unselectedCloseButton.setText (ControlExample.getResourceString("Set_Unselected_Close_Visible"));
        unselectedCloseButton.setSelection(true);
        unselectedCloseButton.addSelectionListener (new class() SelectionAdapter {
            public void widgetSelected (SelectionEvent event) {
                setUnselectedCloseVisible();
            }
        });
    }

    /**
     * Creates the "Example" group.
     */
    void createExampleGroup () {
        super.createExampleGroup ();

        /* Create a group for the CTabFolder */
        tabFolderGroup = new Group (exampleGroup, DWT.NONE);
        tabFolderGroup.setLayout (new GridLayout ());
        tabFolderGroup.setLayoutData (new GridData (DWT.FILL, DWT.FILL, true, true));
        tabFolderGroup.setText ("CTabFolder");
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
        if (flatButton.getSelection ()) style |= DWT.FLAT;
        if (closeButton.getSelection ()) style |= DWT.CLOSE;

        /* Create the example widgets */
        tabFolder1 = new CTabFolder (tabFolderGroup, style);
        for (int i = 0; i < CTabItems1.length; i++) {
            CTabItem item = new CTabItem(tabFolder1, DWT.NONE);
            item.setText(CTabItems1[i]);
            Text text = new Text(tabFolder1, DWT.READ_ONLY);
            text.setText(Format( "{}: {}", ControlExample.getResourceString("CTabItem_content"), i));
            item.setControl(text);
        }
        tabFolder1.addListener(DWT.Selection, new class() Listener {
            public void handleEvent(Event event) {
                lastSelectedTab = tabFolder1.getSelectionIndex();
            }
        });
        tabFolder1.setSelection(lastSelectedTab);
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
        flatButton = new Button (styleGroup, DWT.CHECK);
        flatButton.setText ("DWT.FLAT");
        closeButton = new Button (styleGroup, DWT.CHECK);
        closeButton.setText ("DWT.CLOSE");
    }

    /**
     * Gets the list of custom event names.
     *
     * @return an array containing custom event names
     */
    char[] [] getCustomEventNames () {
        return ["CTabFolderEvent"];
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
        return [ cast(Widget) tabFolder1];
    }

    /**
     * Gets the text for the tab folder item.
     */
    char[] getTabText () {
        return "CTabFolder";
    }

    /**
     * Hooks the custom listener specified by eventName.
     */
    void hookCustomListener (char[] eventName) {
        if (eventName is "CTabFolderEvent") {
            tabFolder1.addCTabFolder2Listener (new class(eventName) CTabFolder2Adapter {
                char[] name;
                this( char[] name ){ this.name = name; }
                public void close (CTabFolderEvent event) {
                    log (name, event);
                }
            });
        }
    }

    /**
     * Sets the foreground color, background color, and font
     * of the "Example" widgets to their default settings.
     * Also sets foreground and background color of the Node 1
     * TreeItems to default settings.
     */
    void resetColorsAndFonts () {
        super.resetColorsAndFonts ();
        Color oldColor = selectionForegroundColor;
        selectionForegroundColor = null;
        setSelectionForeground ();
        if (oldColor !is null) oldColor.dispose();
        oldColor = selectionBackgroundColor;
        selectionBackgroundColor = null;
        setSelectionBackground ();
        if (oldColor !is null) oldColor.dispose();
        Font oldFont = itemFont;
        itemFont = null;
        setItemFont ();
        if (oldFont !is null) oldFont.dispose();
    }

    /**
     * Sets the state of the "Example" widgets.
     */
    void setExampleWidgetState () {
        super.setExampleWidgetState();
        setSimpleTabs();
        setSingleTabs();
        setImages();
        setMinimizeVisible();
        setMaximizeVisible();
        setUnselectedCloseVisible();
        setUnselectedImageVisible();
        setSelectionBackground ();
        setSelectionForeground ();
        setItemFont ();
        setExampleWidgetSize();
    }

    /**
     * Sets the shape that the CTabFolder will use to render itself.
     */
    void setSimpleTabs () {
        tabFolder1.setSimple (simpleTabButton.getSelection ());
        setExampleWidgetSize();
    }

    /**
     * Sets the number of tabs that the CTabFolder should display.
     */
    void setSingleTabs () {
        tabFolder1.setSingle (singleTabButton.getSelection ());
        setExampleWidgetSize();
    }
    /**
     * Sets an image into each item of the "Example" widgets.
     */
    void setImages () {
        bool setImage = imageButton.getSelection ();
        CTabItem items[] = tabFolder1.getItems ();
        for (int i = 0; i < items.length; i++) {
            if (setImage) {
                items[i].setImage (instance.images[ControlExample.ciClosedFolder]);
            } else {
                items[i].setImage (null);
            }
        }
        setExampleWidgetSize ();
    }
    /**
     * Sets the visibility of the minimize button
     */
    void setMinimizeVisible () {
        tabFolder1.setMinimizeVisible(showMinButton.getSelection ());
        setExampleWidgetSize();
    }
    /**
     * Sets the visibility of the maximize button
     */
    void setMaximizeVisible () {
        tabFolder1.setMaximizeVisible(showMaxButton.getSelection ());
        setExampleWidgetSize();
    }
    /**
     * Sets the visibility of the close button on unselected tabs
     */
    void setUnselectedCloseVisible () {
        tabFolder1.setUnselectedCloseVisible(unselectedCloseButton.getSelection ());
        setExampleWidgetSize();
    }
    /**
     * Sets the visibility of the image on unselected tabs
     */
    void setUnselectedImageVisible () {
        tabFolder1.setUnselectedImageVisible(unselectedImageButton.getSelection ());
        setExampleWidgetSize();
    }
    /**
     * Sets the background color of CTabItem 0.
     */
    void setSelectionBackground () {
        if (!instance.startup) {
            tabFolder1.setSelectionBackground(selectionBackgroundColor);
        }
        // Set the selection background item's image to match the background color of the selection.
        Color color = selectionBackgroundColor;
        if (color is null) color = tabFolder1.getSelectionBackground ();
        TableItem item = colorAndFontTable.getItem(SELECTION_BACKGROUND_COLOR);
        Image oldImage = item.getImage();
        if (oldImage !is null) oldImage.dispose();
        item.setImage (colorImage(color));
    }

    /**
     * Sets the foreground color of CTabItem 0.
     */
    void setSelectionForeground () {
        if (!instance.startup) {
            tabFolder1.setSelectionForeground(selectionForegroundColor);
        }
        // Set the selection foreground item's image to match the foreground color of the selection.
        Color color = selectionForegroundColor;
        if (color is null) color = tabFolder1.getSelectionForeground ();
        TableItem item = colorAndFontTable.getItem(SELECTION_FOREGROUND_COLOR);
        Image oldImage = item.getImage();
        if (oldImage !is null) oldImage.dispose();
        item.setImage (colorImage(color));
    }

    /**
     * Sets the font of CTabItem 0.
     */
    void setItemFont () {
        if (!instance.startup) {
            tabFolder1.getItem (0).setFont (itemFont);
            setExampleWidgetSize();
        }
        /* Set the font item's image to match the font of the item. */
        Font ft = itemFont;
        if (ft is null) ft = tabFolder1.getItem (0).getFont ();
        TableItem item = colorAndFontTable.getItem(ITEM_FONT);
        Image oldImage = item.getImage();
        if (oldImage !is null) oldImage.dispose();
        item.setImage (fontImage(ft));
        item.setFont(ft);
        colorAndFontTable.layout ();
    }
}
