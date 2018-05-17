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
module examples.controlexample.Tab;



import dwt.DWT;
import dwt.events.ArmEvent;
import dwt.events.ControlEvent;
import dwt.events.DisposeEvent;
import dwt.events.DisposeListener;
import dwt.events.FocusEvent;
import dwt.events.HelpEvent;
import dwt.events.KeyAdapter;
import dwt.events.KeyEvent;
import dwt.events.MenuEvent;
import dwt.events.ModifyEvent;
import dwt.events.MouseEvent;
import dwt.events.PaintEvent;
import dwt.events.SelectionAdapter;
import dwt.events.SelectionEvent;
import dwt.events.SelectionListener;
import dwt.events.ShellEvent;
import dwt.events.TraverseEvent;
import dwt.events.TreeEvent;
import dwt.events.TypedEvent;
import dwt.events.VerifyEvent;
import dwt.graphics.Color;
import dwt.graphics.Font;
import dwt.graphics.FontData;
import dwt.graphics.GC;
import dwt.graphics.Image;
import dwt.graphics.Point;
import dwt.graphics.RGB;
import dwt.graphics.Rectangle;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.widgets.Button;
import dwt.widgets.ColorDialog;
import dwt.widgets.Combo;
import dwt.widgets.Composite;
import dwt.widgets.Control;
import dwt.widgets.Display;
import dwt.widgets.Event;
import dwt.widgets.FontDialog;
import dwt.widgets.Group;
import dwt.widgets.Item;
import dwt.widgets.Label;
import dwt.widgets.Link;
import dwt.widgets.List;
import dwt.widgets.Listener;
import dwt.widgets.Menu;
import dwt.widgets.MenuItem;
import dwt.widgets.ProgressBar;
import dwt.widgets.Sash;
import dwt.widgets.Scale;
import dwt.widgets.Shell;
import dwt.widgets.Slider;
import dwt.widgets.Spinner;
import dwt.widgets.TabFolder;
import dwt.widgets.Table;
import dwt.widgets.TableItem;
import dwt.widgets.Text;
import dwt.widgets.Tree;
import dwt.widgets.TreeItem;
import dwt.widgets.ToolTip;
import dwt.widgets.Widget;
import dwt.widgets.Canvas;
import dwt.widgets.CoolBar;
import dwt.widgets.ExpandBar;

import dwt.dwthelper.utils;

import examples.controlexample.ControlExample;
import tango.text.convert.Format;

import tango.io.Stdout;

/**
 * <code>Tab</code> is the abstract superclass of every page
 * in the example's tab folder.  Each page in the tab folder
 * describes a control.
 *
 * A Tab itself is not a control but instead provides a
 * hierarchy with which to share code that is common to
 * every page in the folder.
 *
 * A typical page in a Tab contains a two column composite.
 * The left column contains the "Example" group.  The right
 * column contains "Control" group.  The "Control" group
 * contains controls that allow the user to interact with
 * the example control.  The "Control" group typically
 * contains a "Style", "Other" and "Size" group.  Subclasses
 * can override these defaults to augment a group or stop
 * a group from being created.
 */
    struct EventName {
        char[] name;
        int id;
    }
abstract class Tab {
    Shell shell;
    Display display;

    /* Common control buttons */
    Button borderButton, enabledButton, visibleButton, backgroundImageButton, popupMenuButton;
    Button preferredButton, tooSmallButton, smallButton, largeButton, fillHButton, fillVButton;

    /* Common groups and composites */
    Composite tabFolderPage;
    Group exampleGroup, controlGroup, listenersGroup, otherGroup, sizeGroup, styleGroup, colorGroup, backgroundModeGroup;

    /* Controlling instance */
    const ControlExample instance;

    /* Sizing constants for the "Size" group */
    static const int TOO_SMALL_SIZE = 10;
    static const int SMALL_SIZE     = 50;
    static const int LARGE_SIZE     = 100;

    /* Right-to-left support */
    static const bool RTL_SUPPORT_ENABLE = false;
    Group orientationGroup;
    Button rtlButton, ltrButton, defaultOrietationButton;

    /* Controls and resources for the "Colors & Fonts" group */
    static const int IMAGE_SIZE = 12;
    static const int FOREGROUND_COLOR = 0;
    static const int BACKGROUND_COLOR = 1;
    static const int FONT = 2;
    Table colorAndFontTable;
    ColorDialog colorDialog;
    FontDialog fontDialog;
    Color foregroundColor, backgroundColor;
    Font font;

    /* Controls and resources for the "Background Mode" group */
    Combo backgroundModeCombo;
    Button backgroundModeImageButton, backgroundModeColorButton;

    /* Event logging variables and controls */
    Text eventConsole;
    bool logging = false;
    bool [] eventsFilter;

    /* Set/Get API controls */
    Combo nameCombo;
    Label returnTypeLabel;
    Button getButton, setButton;
    Text setText, getText;

    static EventName[] EVENT_NAMES = [
        {"Activate"[], DWT.Activate},
        {"Arm", DWT.Arm},
        {"Close", DWT.Close},
        {"Collapse", DWT.Collapse},
        {"Deactivate", DWT.Deactivate},
        {"DefaultSelection", DWT.DefaultSelection},
        {"Deiconify", DWT.Deiconify},
        {"Dispose", DWT.Dispose},
        {"DragDetect", DWT.DragDetect},
        {"EraseItem", DWT.EraseItem},
        {"Expand", DWT.Expand},
        {"FocusIn", DWT.FocusIn},
        {"FocusOut", DWT.FocusOut},
        {"HardKeyDown", DWT.HardKeyDown},
        {"HardKeyUp", DWT.HardKeyUp},
        {"Help", DWT.Help},
        {"Hide", DWT.Hide},
        {"Iconify", DWT.Iconify},
        {"KeyDown", DWT.KeyDown},
        {"KeyUp", DWT.KeyUp},
        {"MeasureItem", DWT.MeasureItem},
        {"MenuDetect", DWT.MenuDetect},
        {"Modify", DWT.Modify},
        {"MouseDoubleClick", DWT.MouseDoubleClick},
        {"MouseDown", DWT.MouseDown},
        {"MouseEnter", DWT.MouseEnter},
        {"MouseExit", DWT.MouseExit},
        {"MouseHover", DWT.MouseHover},
        {"MouseMove", DWT.MouseMove},
        {"MouseUp", DWT.MouseUp},
        {"MouseWheel", DWT.MouseWheel},
        {"Move", DWT.Move},
        {"Paint", DWT.Paint},
        {"PaintItem", DWT.PaintItem},
        {"Resize", DWT.Resize},
        {"Selection", DWT.Selection},
        {"SetData", DWT.SetData},
//      {"Settings", DWT.Settings},  // note: this event only goes to Display
        {"Show", DWT.Show},
        {"Traverse", DWT.Traverse},
        {"Verify", DWT.Verify}
    ];

    bool samplePopup = false;


    struct ReflectTypeInfo{
        ReflectMethodInfo[ char[] ] methods;
    }
    struct ReflectMethodInfo{
        TypeInfo returnType;
        TypeInfo[] argumentTypes;
    }
    static ReflectTypeInfo[ ClassInfo ] reflectTypeInfos;

    static ReflectMethodInfo createMethodInfo( TypeInfo ret, TypeInfo[] args ... ){
        ReflectMethodInfo res;
        res.returnType = ret;
        foreach( arg; args ){
            res.argumentTypes ~= arg;
        }
        return res;
    }
    static void createSetterGetter( ref ReflectTypeInfo ti, char[] name,  TypeInfo type ){
        ti.methods[ "get" ~ name ] = createMethodInfo( type );
        ti.methods[ "set" ~ name ] = createMethodInfo( typeid(void), type );
    }

    static void registerTypes(){
        if( reflectTypeInfos.length > 0 ){
            return;
        }

        {
            ReflectTypeInfo ti;
            createSetterGetter( ti, "Selection",   typeid(bool) );
            createSetterGetter( ti, "Text",        typeid(char[]) );
            createSetterGetter( ti, "ToolTipText", typeid(char[]) );
            reflectTypeInfos[ Button.classinfo ] = ti;
        }
        {
            ReflectTypeInfo ti;
            createSetterGetter( ti, "ToolTipText", typeid(char[]) );
            reflectTypeInfos[ Canvas.classinfo ] = ti;
        }
        {
            ReflectTypeInfo ti;
            createSetterGetter( ti, "Orientation", typeid(int) );
            createSetterGetter( ti, "Items", typeid(char[]) );
            createSetterGetter( ti, "Selection", typeid(Point) );
            createSetterGetter( ti, "Text", typeid(char[]) );
            createSetterGetter( ti, "TextLimit", typeid(int) );
            createSetterGetter( ti, "ToolTipText", typeid(char[]) );
            createSetterGetter( ti, "VisibleItemCount", typeid(int) );
            reflectTypeInfos[ Combo.classinfo ] = ti;
        }
        {
            ReflectTypeInfo ti;
            createSetterGetter( ti, "ToolTipText", typeid(char[]) );
            reflectTypeInfos[ CoolBar.classinfo ] = ti;
        }
        {
            ReflectTypeInfo ti;
            createSetterGetter( ti, "Spacing", typeid(int) );
            reflectTypeInfos[ ExpandBar.classinfo ] = ti;
        }
        {
            ReflectTypeInfo ti;
            createSetterGetter( ti, "ToolTipText", typeid(char[]) );
            reflectTypeInfos[ Group.classinfo ] = ti;
        }
        {
            ReflectTypeInfo ti;
            createSetterGetter( ti, "Text", typeid(char[]) );
            createSetterGetter( ti, "ToolTipText", typeid(char[]) );
            reflectTypeInfos[ Label.classinfo ] = ti;
        }
        {
            ReflectTypeInfo ti;
            createSetterGetter( ti, "Text", typeid(char[]) );
            createSetterGetter( ti, "ToolTipText", typeid(char[]) );
            reflectTypeInfos[ Link.classinfo ] = ti;
        }
        {
            ReflectTypeInfo ti;
            createSetterGetter( ti, "Items", typeid(char[][]) );
            createSetterGetter( ti, "Selection", typeid(char[]) );
            createSetterGetter( ti, "TopIndex", typeid(int) );
            createSetterGetter( ti, "ToolTipText", typeid(char[]) );
            reflectTypeInfos[ List.classinfo ] = ti;
        }
        {
            ReflectTypeInfo ti;
            createSetterGetter( ti, "Selection", typeid(char[]) );
            createSetterGetter( ti, "ToolTipText", typeid(char[]) );
            reflectTypeInfos[ ProgressBar.classinfo ] = ti;
        }
        {
            ReflectTypeInfo ti;
            createSetterGetter( ti, "ToolTipText", typeid(char[]) );
            reflectTypeInfos[ Sash.classinfo ] = ti;
        }
        {
            ReflectTypeInfo ti;
            createSetterGetter( ti, "Selection", typeid(int) );
            createSetterGetter( ti, "ToolTipText", typeid(char[]) );
            reflectTypeInfos[ Scale.classinfo ] = ti;
        }
        {
            ReflectTypeInfo ti;
            createSetterGetter( ti, "Selection", typeid(int) );
            createSetterGetter( ti, "ToolTipText", typeid(char[]) );
            reflectTypeInfos[ Slider.classinfo ] = ti;
        }
        {
            ReflectTypeInfo ti;
            createSetterGetter( ti, "Selection", typeid(int) );
            createSetterGetter( ti, "ToolTipText", typeid(char[]) );
            reflectTypeInfos[ Spinner.classinfo ] = ti;
        }
        {
            ReflectTypeInfo ti;
            createSetterGetter( ti, "DoubleClickEnabled", typeid(bool) );
            createSetterGetter( ti, "EchoChar", typeid(wchar) );
            createSetterGetter( ti, "Editable", typeid(bool) );
            createSetterGetter( ti, "Orientation", typeid(int) );
            createSetterGetter( ti, "Selection", typeid(Point) );
            createSetterGetter( ti, "Tabs", typeid(int) );
            createSetterGetter( ti, "Text", typeid(char[]) );
            createSetterGetter( ti, "TextLimit", typeid(int) );
            createSetterGetter( ti, "ToolTipText", typeid(char[]) );
            createSetterGetter( ti, "TopIndex", typeid(int) );
            reflectTypeInfos[ Text.classinfo ] = ti;
        }
        {
            ReflectTypeInfo ti;
            createSetterGetter( ti, "Message", typeid(int) );
            createSetterGetter( ti, "Text", typeid(char[]) );
            reflectTypeInfos[ ToolTip.classinfo ] = ti;
        }
        {
            ReflectTypeInfo ti;
            createSetterGetter( ti, "ColumnOrder", typeid(int[]) );
            createSetterGetter( ti, "Selection", typeid(TreeItem[]) );
            createSetterGetter( ti, "ToolTipText", typeid(char[]) );
            createSetterGetter( ti, "TopItem", typeid(int) );
            reflectTypeInfos[ Tree.classinfo ] = ti;
        }

        /+{
            ReflectTypeInfo ti;
            createSetterGetter( ti, "Editable", typeid(bool) );
            createSetterGetter( ti, "Items", typeid(char[]) );
            createSetterGetter( ti, "Selection", typeid(Point) );
            createSetterGetter( ti, "Text", typeid(char[]) );
            createSetterGetter( ti, "TextLimit", typeid(int) );
            createSetterGetter( ti, "ToolTipText", typeid(char[]) );
            createSetterGetter( ti, "VisibleItemCount", typeid(int) );
            reflectTypeInfos[ CCombo.classinfo ] = ti;
        }+/
    }
    /**
     * Creates the Tab within a given instance of ControlExample.
     */
    this(ControlExample instance) {
        this.instance = instance;
        registerTypes();
    }

    /**
     * Creates the "Control" group.  The "Control" group
     * is typically the right hand column in the tab.
     */
    void createControlGroup () {

        /*
         * Create the "Control" group.  This is the group on the
         * right half of each example tab.  It consists of the
         * "Style" group, the "Other" group and the "Size" group.
         */
        controlGroup = new Group (tabFolderPage, DWT.NONE);
        controlGroup.setLayout (new GridLayout (2, true));
        controlGroup.setLayoutData (new GridData(DWT.FILL, DWT.FILL, false, false));
        controlGroup.setText (ControlExample.getResourceString("Parameters"));

        /* Create individual groups inside the "Control" group */
        createStyleGroup ();
        createOtherGroup ();
        createSetGetGroup();
        createSizeGroup ();
        createColorAndFontGroup ();
        if (RTL_SUPPORT_ENABLE) {
            createOrientationGroup ();
        }

        /*
         * For each Button child in the style group, add a selection
         * listener that will recreate the example controls.  If the
         * style group button is a RADIO button, ensure that the radio
         * button is selected before recreating the example controls.
         * When the user selects a RADIO button, the current RADIO
         * button in the group is deselected and the new RADIO button
         * is selected automatically.  The listeners are notified for
         * both these operations but typically only do work when a RADIO
         * button is selected.
         */
        SelectionListener selectionListener = new class() SelectionAdapter {
            public void widgetSelected (SelectionEvent event) {
                if ((event.widget.getStyle () & DWT.RADIO) !is 0) {
                    if (!(cast(Button) event.widget).getSelection ()) return;
                }
                recreateExampleWidgets ();
            }
        };
        Control [] children = styleGroup.getChildren ();
        for (int i=0; i<children.length; i++) {
            if ( auto button = cast(Button)children [i]) {
                button.addSelectionListener (selectionListener);
            } else {
                if ( auto composite = cast(Composite)children [i]) {
                    /* Look down one more level of children in the style group. */
                    Control [] grandchildren = composite.getChildren ();
                    for (int j=0; j<grandchildren.length; j++) {
                        if ( auto button = cast(Button)grandchildren [j]) {
                            button.addSelectionListener (selectionListener);
                        }
                    }
                }
            }
        }
        if (RTL_SUPPORT_ENABLE) {
            rtlButton.addSelectionListener (selectionListener);
            ltrButton.addSelectionListener (selectionListener);
            defaultOrietationButton.addSelectionListener (selectionListener);
        }
    }

    /**
     * Append the Set/Get API controls to the "Other" group.
     */
    void createSetGetGroup() {
        /*
         * Create the button to access set/get API functionality.
         */
        char[] [] methodNames = getMethodNames ();
        if (methodNames !is null) {
            Button setGetButton = new Button (otherGroup, DWT.PUSH);
            setGetButton.setText (ControlExample.getResourceString ("Set_Get"));
            setGetButton.setLayoutData(new GridData(DWT.FILL, DWT.CENTER, false, false));
            setGetButton.addSelectionListener (new class(methodNames) SelectionAdapter {
                char[][] mths;
                this( char[][] mths ){ this.mths = mths; }
                public void widgetSelected (SelectionEvent e) {
                    Button button = cast(Button)e.widget;
                    Point pt = button.getLocation();
                    pt = e.display.map(button, null, pt);
                    createSetGetDialog(pt.x, pt.y, mths);
                }
            });
        }
    }

    /**
     * Creates the "Control" widget children.
     * Subclasses override this method to augment
     * the standard controls created in the "Style",
     * "Other" and "Size" groups.
     */
    void createControlWidgets () {
    }

    /**
     * Creates the "Colors and Fonts" group. This is typically
     * a child of the "Control" group. Subclasses override
     * this method to customize color and font settings.
     */
    void createColorAndFontGroup () {
        /* Create the group. */
        colorGroup = new Group(controlGroup, DWT.NONE);
        colorGroup.setLayout (new GridLayout (2, true));
        colorGroup.setLayoutData (new GridData (DWT.FILL, DWT.FILL, false, false));
        colorGroup.setText (ControlExample.getResourceString ("Colors"));
        colorAndFontTable = new Table(colorGroup, DWT.BORDER | DWT.V_SCROLL);
        colorAndFontTable.setLayoutData(new GridData(DWT.FILL, DWT.BEGINNING, true, false, 2, 1));
        TableItem item = new TableItem(colorAndFontTable, DWT.None);
        item.setText(ControlExample.getResourceString ("Foreground_Color"));
        colorAndFontTable.setSelection(0);
        item = new TableItem(colorAndFontTable, DWT.None);
        item.setText(ControlExample.getResourceString ("Background_Color"));
        item = new TableItem(colorAndFontTable, DWT.None);
        item.setText(ControlExample.getResourceString ("Font"));
        Button changeButton = new Button (colorGroup, DWT.PUSH);
        changeButton.setText(ControlExample.getResourceString("Change"));
        changeButton.setLayoutData(new GridData(DWT.FILL, DWT.CENTER, false, false));
        Button defaultsButton = new Button (colorGroup, DWT.PUSH);
        defaultsButton.setText(ControlExample.getResourceString("Defaults"));
        defaultsButton.setLayoutData(new GridData(DWT.FILL, DWT.CENTER, false, false));

        /* Add listeners to set/reset colors and fonts. */
        colorDialog = new ColorDialog (shell);
        fontDialog = new FontDialog (shell);
        colorAndFontTable.addSelectionListener(new class() SelectionAdapter {
            public void widgetDefaultSelected(SelectionEvent event) {
                changeFontOrColor (colorAndFontTable.getSelectionIndex());
            }
        });
        changeButton.addSelectionListener(new class() SelectionAdapter {
            public void widgetSelected(SelectionEvent event) {
                changeFontOrColor (colorAndFontTable.getSelectionIndex());
            }
        });
        defaultsButton.addSelectionListener(new class() SelectionAdapter {
            public void widgetSelected (SelectionEvent e) {
                resetColorsAndFonts ();
            }
        });
        shell.addDisposeListener(new class() DisposeListener {
            public void widgetDisposed(DisposeEvent event) {
                if (foregroundColor !is null) foregroundColor.dispose();
                if (backgroundColor !is null) backgroundColor.dispose();
                if (font !is null) font.dispose();
                foregroundColor = null;
                backgroundColor = null;
                font = null;
                if (colorAndFontTable !is null && !colorAndFontTable.isDisposed()) {
                    TableItem [] items = colorAndFontTable.getItems();
                    for (int i = 0; i < items.length; i++) {
                        Image image = items[i].getImage();
                        if (image !is null) image.dispose();
                    }
                }
            }
        });
    }

    void changeFontOrColor(int index) {
        switch (index) {
            case FOREGROUND_COLOR: {
                Color oldColor = foregroundColor;
                if (oldColor is null) {
                    Control [] controls = getExampleControls ();
                    if (controls.length > 0) oldColor = controls [0].getForeground ();
                }
                if (oldColor !is null) colorDialog.setRGB(oldColor.getRGB()); // seed dialog with current color
                RGB rgb = colorDialog.open();
                if (rgb is null) return;
                oldColor = foregroundColor; // save old foreground color to dispose when done
                foregroundColor = new Color (display, rgb);
                setExampleWidgetForeground ();
                if (oldColor !is null) oldColor.dispose ();
            }
            break;
            case BACKGROUND_COLOR: {
                Color oldColor = backgroundColor;
                if (oldColor is null) {
                    Control [] controls = getExampleControls ();
                    if (controls.length > 0) oldColor = controls [0].getBackground (); // seed dialog with current color
                }
                if (oldColor !is null) colorDialog.setRGB(oldColor.getRGB());
                RGB rgb = colorDialog.open();
                if (rgb is null) return;
                oldColor = backgroundColor; // save old background color to dispose when done
                backgroundColor = new Color (display, rgb);
                setExampleWidgetBackground ();
                if (oldColor !is null) oldColor.dispose ();
            }
            break;
            case FONT: {
                Font oldFont = font;
                if (oldFont is null) {
                    Control [] controls = getExampleControls ();
                    if (controls.length > 0) oldFont = controls [0].getFont ();
                }
                if (oldFont !is null) fontDialog.setFontList(oldFont.getFontData()); // seed dialog with current font
                FontData fontData = fontDialog.open ();
                if (fontData is null) return;
                oldFont = font; // dispose old font when done
                font = new Font (display, fontData);
                setExampleWidgetFont ();
                setExampleWidgetSize ();
                if (oldFont !is null) oldFont.dispose ();
            }
            break;
            default:
        }
    }

    /**
     * Creates the "Other" group.  This is typically
     * a child of the "Control" group.
     */
    void createOtherGroup () {
        /* Create the group */
        otherGroup = new Group (controlGroup, DWT.NONE);
        otherGroup.setLayout (new GridLayout ());
        otherGroup.setLayoutData (new GridData (DWT.FILL, DWT.FILL, false, false));
        otherGroup.setText (ControlExample.getResourceString("Other"));

        /* Create the controls */
        enabledButton = new Button(otherGroup, DWT.CHECK);
        enabledButton.setText(ControlExample.getResourceString("Enabled"));
        visibleButton = new Button(otherGroup, DWT.CHECK);
        visibleButton.setText(ControlExample.getResourceString("Visible"));
        backgroundImageButton = new Button(otherGroup, DWT.CHECK);
        backgroundImageButton.setText(ControlExample.getResourceString("BackgroundImage"));
        popupMenuButton = new Button(otherGroup, DWT.CHECK);
        popupMenuButton.setText(ControlExample.getResourceString("Popup_Menu"));

        /* Add the listeners */
        enabledButton.addSelectionListener (new class() SelectionAdapter {
            public void widgetSelected (SelectionEvent event) {
                setExampleWidgetEnabled ();
            }
        });
        visibleButton.addSelectionListener (new class() SelectionAdapter {
            public void widgetSelected (SelectionEvent event) {
                setExampleWidgetVisibility ();
            }
        });
        backgroundImageButton.addSelectionListener (new class() SelectionAdapter {
            public void widgetSelected (SelectionEvent event) {
                setExampleWidgetBackgroundImage ();
            }
        });
        popupMenuButton.addSelectionListener (new class() SelectionAdapter {
            public void widgetSelected (SelectionEvent event) {
                setExampleWidgetPopupMenu ();
            }
        });

        /* Set the default state */
        enabledButton.setSelection(true);
        visibleButton.setSelection(true);
        backgroundImageButton.setSelection(false);
        popupMenuButton.setSelection(false);
    }

    /**
     * Creates the "Background Mode" group.
     */
    void createBackgroundModeGroup () {
        // note that this method must be called after createExampleWidgets
        if (getExampleControls ().length is 0) return;

        /* Create the group */
        backgroundModeGroup = new Group (controlGroup, DWT.NONE);
        backgroundModeGroup.setLayout (new GridLayout ());
        backgroundModeGroup.setLayoutData (new GridData (DWT.FILL, DWT.FILL, false, false));
        backgroundModeGroup.setText (ControlExample.getResourceString("Background_Mode"));

        /* Create the controls */
        backgroundModeCombo = new Combo(backgroundModeGroup, DWT.READ_ONLY);
        backgroundModeCombo.setItems(["DWT.INHERIT_NONE", "DWT.INHERIT_DEFAULT", "DWT.INHERIT_FORCE"]);
        backgroundModeImageButton = new Button(backgroundModeGroup, DWT.CHECK);
        backgroundModeImageButton.setText(ControlExample.getResourceString("BackgroundImage"));
        backgroundModeColorButton = new Button(backgroundModeGroup, DWT.CHECK);
        backgroundModeColorButton.setText(ControlExample.getResourceString("Background_Color"));

        /* Add the listeners */
        backgroundModeCombo.addSelectionListener (new class() SelectionAdapter {
            public void widgetSelected (SelectionEvent event) {
                setExampleGroupBackgroundMode ();
            }
        });
        backgroundModeImageButton.addSelectionListener (new class() SelectionAdapter {
            public void widgetSelected (SelectionEvent event) {
                setExampleGroupBackgroundImage ();
            }
        });
        backgroundModeColorButton.addSelectionListener (new class() SelectionAdapter {
            public void widgetSelected (SelectionEvent event) {
                setExampleGroupBackgroundColor ();
            }
        });

        /* Set the default state */
        backgroundModeCombo.setText(backgroundModeCombo.getItem(0));
        backgroundModeImageButton.setSelection(false);
        backgroundModeColorButton.setSelection(false);
    }

    /**
     * Create the event console popup menu.
     */
    void createEventConsolePopup () {
        Menu popup = new Menu (shell, DWT.POP_UP);
        eventConsole.setMenu (popup);

        MenuItem cut = new MenuItem (popup, DWT.PUSH);
        cut.setText (ControlExample.getResourceString("MenuItem_Cut"));
        cut.addListener (DWT.Selection, new class() Listener {
            public void handleEvent (Event event) {
                eventConsole.cut ();
            }
        });
        MenuItem copy = new MenuItem (popup, DWT.PUSH);
        copy.setText (ControlExample.getResourceString("MenuItem_Copy"));
        copy.addListener (DWT.Selection, new class() Listener {
            public void handleEvent (Event event) {
                eventConsole.copy ();
            }
        });
        MenuItem paste = new MenuItem (popup, DWT.PUSH);
        paste.setText (ControlExample.getResourceString("MenuItem_Paste"));
        paste.addListener (DWT.Selection, new class() Listener {
            public void handleEvent (Event event) {
                eventConsole.paste ();
            }
        });
        new MenuItem (popup, DWT.SEPARATOR);
        MenuItem selectAll = new MenuItem (popup, DWT.PUSH);
        selectAll.setText(ControlExample.getResourceString("MenuItem_SelectAll"));
        selectAll.addListener (DWT.Selection, new class() Listener {
            public void handleEvent (Event event) {
                eventConsole.selectAll ();
            }
        });
    }

    /**
     * Creates the "Example" group.  The "Example" group
     * is typically the left hand column in the tab.
     */
    void createExampleGroup () {
        exampleGroup = new Group (tabFolderPage, DWT.NONE);
        exampleGroup.setLayout (new GridLayout ());
        exampleGroup.setLayoutData (new GridData (DWT.FILL, DWT.FILL, true, true));
    }

    /**
     * Creates the "Example" widget children of the "Example" group.
     * Subclasses override this method to create the particular
     * example control.
     */
    void createExampleWidgets () {
        /* Do nothing */
    }

    /**
     * Creates and opens the "Listener selection" dialog.
     */
    void createListenerSelectionDialog () {
        Shell dialog = new Shell (shell, DWT.DIALOG_TRIM | DWT.APPLICATION_MODAL);
        dialog.setText (ControlExample.getResourceString ("Select_Listeners"));
        dialog.setLayout (new GridLayout (2, false));
        Table table = new Table (dialog, DWT.BORDER | DWT.V_SCROLL | DWT.CHECK);
        GridData data = new GridData(GridData.FILL_BOTH);
        data.verticalSpan = 2;
        table.setLayoutData(data);
        for (int i = 0; i < EVENT_NAMES.length; i++) {
            TableItem item = new TableItem (table, DWT.NONE);
            item.setText( EVENT_NAMES[i].name );
            item.setChecked (eventsFilter[i]);
        }
        char[] [] customNames = getCustomEventNames ();
        for (int i = 0; i < customNames.length; i++) {
            TableItem item = new TableItem (table, DWT.NONE);
            item.setText (customNames[i]);
            item.setChecked (eventsFilter[EVENT_NAMES.length + i]);
        }
        Button selectAll = new Button (dialog, DWT.PUSH);
        selectAll.setText(ControlExample.getResourceString ("Select_All"));
        selectAll.setLayoutData(new GridData(GridData.HORIZONTAL_ALIGN_FILL));
        selectAll.addSelectionListener (new class(table, customNames) SelectionAdapter {
            Table tbl;
            char[][] cn;
            this( Table tbl, char[][] cn ){ this.tbl = tbl; this.cn = cn; }
            public void widgetSelected(SelectionEvent e) {
                TableItem [] items = tbl.getItems();
                for (int i = 0; i < EVENT_NAMES.length; i++) {
                    items[i].setChecked(true);
                }
                for (int i = 0; i < cn.length; i++) {
                    items[EVENT_NAMES.length + i].setChecked(true);
                }
            }
        });
        Button deselectAll = new Button (dialog, DWT.PUSH);
        deselectAll.setText(ControlExample.getResourceString ("Deselect_All"));
        deselectAll.setLayoutData(new GridData(GridData.HORIZONTAL_ALIGN_FILL | GridData.VERTICAL_ALIGN_BEGINNING));
        deselectAll.addSelectionListener (new class(table, customNames) SelectionAdapter {
            Table tbl;
            char[][] cn;
            this( Table tbl, char[][] cn ){ this.tbl = tbl; this.cn = cn; }
            public void widgetSelected(SelectionEvent e) {
                TableItem [] items = tbl.getItems();
                for (int i = 0; i < EVENT_NAMES.length; i++) {
                    items[i].setChecked(false);
                }
                for (int i = 0; i < cn.length; i++) {
                    items[EVENT_NAMES.length + i].setChecked(false);
                }
            }
        });
        new Label(dialog, DWT.NONE); /* Filler */
        Button ok = new Button (dialog, DWT.PUSH);
        ok.setText(ControlExample.getResourceString ("OK"));
        dialog.setDefaultButton(ok);
        ok.setLayoutData(new GridData(GridData.HORIZONTAL_ALIGN_FILL));
        ok.addSelectionListener (new class(dialog, table, customNames ) SelectionAdapter {
            Shell dlg;
            Table tbl;
            char[][] cn;
            this( Shell dlg, Table tbl, char[][] cn ){ this.tbl = tbl; this.dlg = dlg; this.cn = cn; }
            public void widgetSelected(SelectionEvent e) {
                TableItem [] items = tbl.getItems();
                for (int i = 0; i < EVENT_NAMES.length; i++) {
                    eventsFilter[i] = items[i].getChecked();
                }
                for (int i = 0; i < cn.length; i++) {
                    eventsFilter[EVENT_NAMES.length + i] = items[EVENT_NAMES.length + i].getChecked();
                }
                dlg.dispose();
            }
        });
        dialog.pack ();
        dialog.open ();
        while (! dialog.isDisposed()) {
            if (! display.readAndDispatch()) display.sleep();
        }
    }

    /**
     * Creates the "Listeners" group.  The "Listeners" group
     * goes below the "Example" and "Control" groups.
     */
    void createListenersGroup () {
        listenersGroup = new Group (tabFolderPage, DWT.NONE);
        listenersGroup.setLayout (new GridLayout (3, false));
        listenersGroup.setLayoutData (new GridData (DWT.FILL, DWT.FILL, true, true, 2, 1));
        listenersGroup.setText (ControlExample.getResourceString ("Listeners"));

        /*
         * Create the button to access the 'Listeners' dialog.
         */
        Button listenersButton = new Button (listenersGroup, DWT.PUSH);
        listenersButton.setText (ControlExample.getResourceString ("Select_Listeners"));
        listenersButton.addSelectionListener (new class() SelectionAdapter {
            public void widgetSelected (SelectionEvent e) {
                createListenerSelectionDialog ();
                recreateExampleWidgets ();
            }
        });

        /*
         * Create the checkbox to add/remove listeners to/from the example widgets.
         */
        Button listenCheckbox = new Button (listenersGroup, DWT.CHECK);
        listenCheckbox.setText (ControlExample.getResourceString ("Listen"));
        listenCheckbox.addSelectionListener (new class(listenCheckbox) SelectionAdapter {
            Button lcb;
            this( Button lcb ){ this.lcb = lcb; }
            public void widgetSelected(SelectionEvent e) {
                logging = lcb.getSelection ();
                recreateExampleWidgets ();
            }
        });

        /*
         * Create the button to clear the text.
         */
        Button clearButton = new Button (listenersGroup, DWT.PUSH);
        clearButton.setText (ControlExample.getResourceString ("Clear"));
        clearButton.setLayoutData(new GridData(GridData.HORIZONTAL_ALIGN_END));
        clearButton.addSelectionListener (new class() SelectionAdapter {
            public void widgetSelected (SelectionEvent e) {
                eventConsole.setText ("");
            }
        });

        /* Initialize the eventsFilter to log all events. */
        int customEventCount = getCustomEventNames ().length;
        eventsFilter = new bool [EVENT_NAMES.length + customEventCount];
        for (int i = 0; i < EVENT_NAMES.length + customEventCount; i++) {
            eventsFilter [i] = true;
        }

        /* Create the event console Text. */
        eventConsole = new Text (listenersGroup, DWT.BORDER | DWT.MULTI | DWT.V_SCROLL | DWT.H_SCROLL);
        GridData data = new GridData (GridData.FILL_BOTH);
        data.horizontalSpan = 3;
        data.heightHint = 80;
        eventConsole.setLayoutData (data);
        createEventConsolePopup ();
        eventConsole.addKeyListener (new class() KeyAdapter {
            public void keyPressed (KeyEvent e) {
                if ((e.keyCode is 'A' || e.keyCode is 'a') && (e.stateMask & DWT.MOD1) !is 0) {
                    eventConsole.selectAll ();
                    e.doit = false;
                }
            }
        });
    }

    /**
     * Returns a list of set/get API method names (without the set/get prefix)
     * that can be used to set/get values in the example control(s).
     */
    char[][] getMethodNames() {
        return null;
    }

    void createSetGetDialog(int x, int y, char[][] methodNames) {
        Shell dialog = new Shell(shell, DWT.DIALOG_TRIM | DWT.RESIZE | DWT.MODELESS);
        dialog.setLayout(new GridLayout(2, false));
        dialog.setText(getTabText() ~ " " ~ ControlExample.getResourceString ("Set_Get"));
        nameCombo = new Combo(dialog, DWT.READ_ONLY);
        nameCombo.setItems(methodNames);
        nameCombo.setText(methodNames[0]);
        nameCombo.setVisibleItemCount(methodNames.length);
        nameCombo.setLayoutData(new GridData(DWT.FILL, DWT.CENTER, false, false));
        nameCombo.addSelectionListener(new class() SelectionAdapter {
            public void widgetSelected(SelectionEvent e) {
                resetLabels();
            }
        });
        returnTypeLabel = new Label(dialog, DWT.NONE);
        returnTypeLabel.setLayoutData(new GridData(DWT.FILL, DWT.BEGINNING, false, false));
        setButton = new Button(dialog, DWT.PUSH);
        setButton.setLayoutData(new GridData(DWT.FILL, DWT.BEGINNING, false, false));
        setButton.addSelectionListener(new class() SelectionAdapter {
            public void widgetSelected(SelectionEvent e) {
                setValue();
                setText.selectAll();
                setText.setFocus();
            }
        });
        setText = new Text(dialog, DWT.SINGLE | DWT.BORDER);
        setText.setLayoutData(new GridData(DWT.FILL, DWT.CENTER, false, false));
        getButton = new Button(dialog, DWT.PUSH);
        getButton.setLayoutData(new GridData(DWT.FILL, DWT.BEGINNING, false, false));
        getButton.addSelectionListener(new class() SelectionAdapter {
            public void widgetSelected(SelectionEvent e) {
                getValue();
            }
        });
        getText = new Text(dialog, DWT.MULTI | DWT.BORDER | DWT.READ_ONLY | DWT.H_SCROLL | DWT.V_SCROLL);
        GridData data = new GridData(DWT.FILL, DWT.FILL, true, true);
        data.widthHint = 240;
        data.heightHint = 200;
        getText.setLayoutData(data);
        resetLabels();
        dialog.setDefaultButton(setButton);
        dialog.pack();
        dialog.setLocation(x, y);
        dialog.open();
    }

    void resetLabels() {
        char[] methodRoot = nameCombo.getText();
        returnTypeLabel.setText(parameterInfo(methodRoot));
        setButton.setText(setMethodName(methodRoot));
        getButton.setText("get" ~ methodRoot);
        setText.setText("");
        getText.setText("");
        getValue();
        setText.setFocus();
    }

    char[] setMethodName(char[] methodRoot) {
        return "set" ~ methodRoot;
    }

    char[] parameterInfo(char[] methodRoot) {
        char[] methodName = "get" ~ methodRoot;
        auto mthi = getMethodInfo( methodName );
        char[] typeNameString = mthi.returnType.toString;
//PORTING_LEFT

//        char[] typeName = null;
//         ClassInfo returnType = getReturnType(methodRoot);
         bool isArray = false;
         TypeInfo ti = mthi.returnType;

         if ( auto tia = cast(TypeInfo_Array) mthi.returnType ) {
             ti = tia.value;
             isArray = true;
         }
         if ( auto tia = cast(TypeInfo_Class ) ti ) {
         } else if ( auto tia = cast(TypeInfo_Interface ) ti ) {
         } else {
         }
         //char[] typeNameString = typeName;
         char[] info;
//         int index = typeName.lastIndexOf('.');
//         if (index !is -1 && index+1 < typeName.length()) typeNameString = typeName.substring(index+1);
//         char[] info = ControlExample.getResourceString("Info_" + typeNameString + (isArray ? "A" : ""));
//         if (isArray) {
//             typeNameString += "[]";
//         }
//         return ControlExample.getResourceString("Parameter_Info", [typeNameString, info]);

        return Format( ControlExample.getResourceString("Parameter_Info"), typeNameString, info );
    }

    void getValue() {
//PORTING_LEFT
/+
        char[] methodName = "get" + nameCombo.getText();
        getText.setText("");
        Widget[] widgets = getExampleWidgets();
        for (int i = 0; i < widgets.length; i++) {
            try {
                java.lang.reflect.Method method = widgets[i].getClass().getMethod(methodName, null);
                Object result = method.invoke(widgets[i], null);
                if (result is null) {
                    getText.append("null");
                } else if (result.getClass().isArray()) {
                    int length = java.lang.reflect.Array.getLength(result);
                    if (length is 0) {
                        getText.append(result.getClass().getComponentType() + "[0]");
                    }
                    for (int j = 0; j < length; j++) {
                        getText.append(java.lang.reflect.Array.get(result,j).toString() + "\n");
                    }
                } else {
                    getText.append(result.toString());
                }
            } catch (Exception e) {
                getText.append(e.toString());
            }
            if (i + 1 < widgets.length) {
                getText.append("\n\n");
            }
        }
+/
    }

    private ReflectMethodInfo getMethodInfo( char[] methodName ){
        Widget[] widgets = getExampleWidgets();
        if( widgets.length is 0 ){
            Stdout.formatln( "getWidgets returns null in {}", this.classinfo.name );
        }
        if( auto rti = widgets[0].classinfo in reflectTypeInfos ){
            if( auto mthi = methodName in rti.methods ){
                return *mthi;
            }
            else{
                Stdout.formatln( "method unknown {} in type {} in {}", methodName, widgets[0].classinfo.name, this.classinfo.name );
            }
        }
        else{
            Stdout.formatln( "type unknown {} in {}", widgets[0].classinfo.name, this.classinfo.name );
        }
    }

    TypeInfo getReturnType(char[] methodRoot) {
        char[] methodName = "get" ~ methodRoot;
        auto mthi = getMethodInfo( methodName );
        return mthi.returnType;
    }

    void setValue() {
//PORTING_LEFT
/+
        /* The parameter type must be the same as the get method's return type */
        char[] methodRoot = nameCombo.getText();
        Class returnType = getReturnType(methodRoot);
        char[] methodName = setMethodName(methodRoot);
        char[] value = setText.getText();
        Widget[] widgets = getExampleWidgets();
        for (int i = 0; i < widgets.length; i++) {
            try {
                java.lang.reflect.Method method = widgets[i].getClass().getMethod(methodName, [returnType]);
                char[] typeName = returnType.getName();
                Object[] parameter = null;
                if (typeName.equals("int")) {
                    parameter = [new Integer(value)];
                } else if (typeName.equals("long")) {
                    parameter = [new Long(value)];
                } else if (typeName.equals("char")) {
                    parameter = [value.length() is 1 ? new Character(value.charAt(0)) : new Character('\0')];
                } else if (typeName.equals("bool")) {
                    parameter = [new bool(value)];
                } else if (typeName.equals("java.lang.char[]")) {
                    parameter = [value];
                } else if (typeName.equals("org.eclipse.swt.graphics.Point")) {
                    char[] xy[] = split(value, ',');
                    parameter = [new Point((new Integer(xy[0])).intValue(),(new Integer(xy[1])).intValue())];
                } else if (typeName.equals("[I")) {
                    char[] strings[] = split(value, ',');
                    int[] ints = new int[strings.length];
                    for (int j = 0; j < strings.length; j++) {
                        ints[j] = (new Integer(strings[j])).intValue();
                    }
                    parameter = [ints];
                } else if (typeName.equals("[Ljava.lang.char[];")) {
                    parameter = [split(value, ',')];
                } else {
                    parameter = parameterForType(typeName, value, widgets[i]);
                }
                method.invoke(widgets[i], parameter);
            } catch (Exception e) {
                getText.setText(e.toString());
            }
        }
+/
return null;
    }

    Object[] parameterForType(char[] typeName, char[] value, Widget widget) {
//PORTING_LEFT
return null;
        //return [value];
    }

    void createOrientationGroup () {
        /* Create Orientation group*/
        orientationGroup = new Group (controlGroup, DWT.NONE);
        orientationGroup.setLayout (new GridLayout());
        orientationGroup.setLayoutData (new GridData (DWT.FILL, DWT.FILL, false, false));
        orientationGroup.setText (ControlExample.getResourceString("Orientation"));
        defaultOrietationButton = new Button (orientationGroup, DWT.RADIO);
        defaultOrietationButton.setText (ControlExample.getResourceString("Default"));
        defaultOrietationButton.setSelection (true);
        ltrButton = new Button (orientationGroup, DWT.RADIO);
        ltrButton.setText ("DWT.LEFT_TO_RIGHT");
        rtlButton = new Button (orientationGroup, DWT.RADIO);
        rtlButton.setText ("DWT.RIGHT_TO_LEFT");
    }

    /**
     * Creates the "Size" group.  The "Size" group contains
     * controls that allow the user to change the size of
     * the example widgets.
     */
    void createSizeGroup () {
        /* Create the group */
        sizeGroup = new Group (controlGroup, DWT.NONE);
        sizeGroup.setLayout (new GridLayout());
        sizeGroup.setLayoutData (new GridData (DWT.FILL, DWT.FILL, false, false));
        sizeGroup.setText (ControlExample.getResourceString("Size"));

        /* Create the controls */

        /*
         * The preferred size of a widget is the size returned
         * by widget.computeSize (DWT.DEFAULT, DWT.DEFAULT).
         * This size is defined on a widget by widget basis.
         * Many widgets will attempt to display their contents.
         */
        preferredButton = new Button (sizeGroup, DWT.RADIO);
        preferredButton.setText (ControlExample.getResourceString("Preferred"));
        tooSmallButton = new Button (sizeGroup, DWT.RADIO);
        tooSmallButton.setText ( Format( "{} X {}", TOO_SMALL_SIZE, TOO_SMALL_SIZE));
        smallButton = new Button(sizeGroup, DWT.RADIO);
        smallButton.setText (Format( "{} X {}", SMALL_SIZE, SMALL_SIZE));
        largeButton = new Button (sizeGroup, DWT.RADIO);
        largeButton.setText (Format( "{} X {}", LARGE_SIZE, LARGE_SIZE));
        fillHButton = new Button (sizeGroup, DWT.CHECK);
        fillHButton.setText (ControlExample.getResourceString("Fill_X"));
        fillVButton = new Button (sizeGroup, DWT.CHECK);
        fillVButton.setText (ControlExample.getResourceString("Fill_Y"));

        /* Add the listeners */
        SelectionAdapter selectionListener = new class() SelectionAdapter {
            public void widgetSelected (SelectionEvent event) {
                setExampleWidgetSize ();
            }
        };
        preferredButton.addSelectionListener(selectionListener);
        tooSmallButton.addSelectionListener(selectionListener);
        smallButton.addSelectionListener(selectionListener);
        largeButton.addSelectionListener(selectionListener);
        fillHButton.addSelectionListener(selectionListener);
        fillVButton.addSelectionListener(selectionListener);

        /* Set the default state */
        preferredButton.setSelection (true);
    }

    /**
     * Creates the "Style" group.  The "Style" group contains
     * controls that allow the user to change the style of
     * the example widgets.  Changing a widget "Style" causes
     * the widget to be destroyed and recreated.
     */
    void createStyleGroup () {
        styleGroup = new Group (controlGroup, DWT.NONE);
        styleGroup.setLayout (new GridLayout ());
        styleGroup.setLayoutData (new GridData (DWT.FILL, DWT.FILL, false, false));
        styleGroup.setText (ControlExample.getResourceString("Styles"));
    }

    /**
     * Creates the tab folder page.
     *
     * @param tabFolder org.eclipse.swt.widgets.TabFolder
     * @return the new page for the tab folder
     */
    Composite createTabFolderPage (TabFolder tabFolder) {
        /* Cache the shell and display. */
        shell = tabFolder.getShell ();
        display = shell.getDisplay ();

        /* Create a two column page. */
        tabFolderPage = new Composite (tabFolder, DWT.NONE);
        tabFolderPage.setLayout (new GridLayout (2, false));

        /* Create the "Example" and "Control" groups. */
        createExampleGroup ();
        createControlGroup ();

        /* Create the "Listeners" group under the "Control" group. */
        createListenersGroup ();

        /* Create and initialize the example and control widgets. */
        createExampleWidgets ();
        hookExampleWidgetListeners ();
        createControlWidgets ();
        createBackgroundModeGroup ();
        setExampleWidgetState ();

        return tabFolderPage;
    }

    void setExampleWidgetPopupMenu() {
        Control[] controls = getExampleControls();
        for (int i = 0; i < controls.length; i++) {
            Control control = controls [i];
            control.addListener(DWT.MenuDetect, new class(control) Listener {
                Control ctrl;
                this( Control ctrl ){ this.ctrl = ctrl; }
                public void handleEvent(Event event) {
                    Menu menu = ctrl.getMenu();
                    if (menu !is null && samplePopup) {
                        menu.dispose();
                        menu = null;
                    }
                    if (menu is null && popupMenuButton.getSelection()) {
                        menu = new Menu(shell, DWT.POP_UP);
                        MenuItem item = new MenuItem(menu, DWT.PUSH);
                        item.setText("Sample popup menu item");
                        specialPopupMenuItems(menu, event);
                        ctrl.setMenu(menu);
                        samplePopup = true;
                    }
                }
            });
        }
    }

    protected void specialPopupMenuItems(Menu menu, Event event) {
    }

    /**
     * Disposes the "Example" widgets.
     */
    void disposeExampleWidgets () {
        Widget [] widgets = getExampleWidgets ();
        for (int i=0; i<widgets.length; i++) {
            widgets [i].dispose ();
        }
    }

    Image colorImage (Color color) {
        Image image = new Image (display, IMAGE_SIZE, IMAGE_SIZE);
        GC gc = new GC(image);
        gc.setBackground(color);
        Rectangle bounds = image.getBounds();
        gc.fillRectangle(0, 0, bounds.width, bounds.height);
        gc.setBackground(display.getSystemColor(DWT.COLOR_BLACK));
        gc.drawRectangle(0, 0, bounds.width - 1, bounds.height - 1);
        gc.dispose();
        return image;
    }

    Image fontImage (Font font) {
        Image image = new Image (display, IMAGE_SIZE, IMAGE_SIZE);
        GC gc = new GC(image);
        Rectangle bounds = image.getBounds();
        gc.setBackground(display.getSystemColor(DWT.COLOR_WHITE));
        gc.fillRectangle(0, 0, bounds.width, bounds.height);
        gc.setBackground(display.getSystemColor(DWT.COLOR_BLACK));
        gc.drawRectangle(0, 0, bounds.width - 1, bounds.height - 1);
        FontData data[] = font.getFontData();
        int style = data[0].getStyle();
        switch (style) {
        case DWT.NORMAL:
            gc.drawLine(3, 3, 3, 8);
            gc.drawLine(4, 3, 7, 8);
            gc.drawLine(8, 3, 8, 8);
            break;
        case DWT.BOLD:
            gc.drawLine(3, 2, 3, 9);
            gc.drawLine(4, 2, 4, 9);
            gc.drawLine(5, 2, 7, 2);
            gc.drawLine(5, 3, 8, 3);
            gc.drawLine(5, 5, 7, 5);
            gc.drawLine(5, 6, 7, 6);
            gc.drawLine(5, 8, 8, 8);
            gc.drawLine(5, 9, 7, 9);
            gc.drawLine(7, 4, 8, 4);
            gc.drawLine(7, 7, 8, 7);
            break;
        case DWT.ITALIC:
            gc.drawLine(6, 2, 8, 2);
            gc.drawLine(7, 3, 4, 8);
            gc.drawLine(3, 9, 5, 9);
            break;
        case DWT.BOLD | DWT.ITALIC:
            gc.drawLine(5, 2, 8, 2);
            gc.drawLine(5, 3, 8, 3);
            gc.drawLine(6, 4, 4, 7);
            gc.drawLine(7, 4, 5, 7);
            gc.drawLine(3, 8, 6, 8);
            gc.drawLine(3, 9, 6, 9);
            break;
        }
        gc.dispose();
        return image;
    }

    /**
     * Gets the list of custom event names.
     *
     * @return an array containing custom event names
     */
    char[] [] getCustomEventNames () {
        return null;
    }

    /**
     * Gets the default style for a widget
     *
     * @return the default style bit
     */
    int getDefaultStyle () {
        if (ltrButton !is null && ltrButton.getSelection()) {
            return DWT.LEFT_TO_RIGHT;
        }
        if (rtlButton !is null && rtlButton.getSelection()) {
            return DWT.RIGHT_TO_LEFT;
        }
        return DWT.NONE;
    }

    /**
     * Gets the "Example" widgets.
     *
     * @return an array containing the example widgets
     */
    Widget [] getExampleWidgets () {
        return null;
    }

    /**
     * Gets the "Example" controls.
     * This is the subset of "Example" widgets that are controls.
     *
     * @return an array containing the example controls
     */
    Control [] getExampleControls () {
        Widget [] widgets = getExampleWidgets ();
        Control [] controls = new Control [0];
        for (int i = 0; i < widgets.length; i++) {
            if ( auto ctrl = cast(Control)widgets[i]) {
                Control[] newControls = new Control[controls.length + 1];
                System.arraycopy(controls, 0, newControls, 0, controls.length);
                controls = newControls;
                controls[controls.length - 1] = ctrl;
            }
        }
        return controls;
    }

    /**
     * Gets the "Example" widget children's items, if any.
     *
     * @return an array containing the example widget children's items
     */
    Item [] getExampleWidgetItems () {
        return new Item [0];
    }

    /**
     * Gets the short text for the tab folder item.
     *
     * @return the short text for the tab item
     */
    char[] getShortTabText() {
        return getTabText();
    }

    /**
     * Gets the text for the tab folder item.
     *
     * @return the text for the tab item
     */
    char[] getTabText () {
        return "";
    }

    /**
     * Hooks all listeners to all example controls
     * and example control items.
     */
    void hookExampleWidgetListeners () {
        if (logging) {
            Widget[] widgets = getExampleWidgets ();
            for (int i = 0; i < widgets.length; i++) {
                hookListeners (widgets [i]);
            }
            Item[] exampleItems = getExampleWidgetItems ();
            for (int i = 0; i < exampleItems.length; i++) {
                hookListeners (exampleItems [i]);
            }
            char[] [] customNames = getCustomEventNames ();
            for (int i = 0; i < customNames.length; i++) {
                if (eventsFilter [EVENT_NAMES.length + i]) hookCustomListener (customNames[i]);
            }
        }
    }

    /**
     * Hooks the custom listener specified by eventName.
     */
    void hookCustomListener (char[] eventName) {
    }

    /**
     * Hooks all listeners to the specified widget.
     */
    void hookListeners (Widget widget) {
        if (logging) {
            Listener listener = new class() Listener {
                public void handleEvent (Event event) {
                    log (event);
                }
            };
            for (int i = 0; i < EVENT_NAMES.length; i++) {
                if (eventsFilter [i]) widget.addListener ( EVENT_NAMES[i].id, listener);
            }
        }
    }

    /**
     * Logs an untyped event to the event console.
     */
    void log(Event event) {
        int i = 0;
        while (i < EVENT_NAMES.length) {
            if (EVENT_NAMES[i].id is event.type) break;
            i++;
        }
        char[] str = Format( "{} [{}]: ", EVENT_NAMES[i].name, event.type );
        switch (event.type) {
            case DWT.KeyDown:
            case DWT.KeyUp: str ~= (new KeyEvent (event)).toString (); break;
            case DWT.MouseDown:
            case DWT.MouseUp:
            case DWT.MouseMove:
            case DWT.MouseEnter:
            case DWT.MouseExit:
            case DWT.MouseDoubleClick:
            case DWT.MouseWheel:
            case DWT.MouseHover: str ~= (new MouseEvent (event)).toString (); break;
            case DWT.Paint: str ~= (new PaintEvent (event)).toString (); break;
            case DWT.Move:
            case DWT.Resize: str ~= (new ControlEvent (event)).toString (); break;
            case DWT.Dispose: str ~= (new DisposeEvent (event)).toString (); break;
            case DWT.Selection:
            case DWT.DefaultSelection: str ~= (new SelectionEvent (event)).toString (); break;
            case DWT.FocusIn:
            case DWT.FocusOut: str ~= (new FocusEvent (event)).toString (); break;
            case DWT.Expand:
            case DWT.Collapse: str ~= (new TreeEvent (event)).toString (); break;
            case DWT.Iconify:
            case DWT.Deiconify:
            case DWT.Close:
            case DWT.Activate:
            case DWT.Deactivate: str ~=( new ShellEvent (event)).toString (); break;
            case DWT.Show:
            case DWT.Hide: str ~= ( null !is cast(Menu)event.widget) ? (new MenuEvent (event)).toString () : event.toString(); break;
            case DWT.Modify: str ~= (new ModifyEvent (event)).toString (); break;
            case DWT.Verify: str ~= (new VerifyEvent (event)).toString (); break;
            case DWT.Help: str ~= (new HelpEvent (event)).toString (); break;
            case DWT.Arm: str ~= (new ArmEvent (event)).toString (); break;
            case DWT.Traverse: str ~= (new TraverseEvent (event)).toString (); break;
            case DWT.HardKeyDown:
            case DWT.HardKeyUp:
            case DWT.DragDetect:
            case DWT.MenuDetect:
            case DWT.SetData:
            default: str ~= event.toString ();
        }
        eventConsole.append (str);
        eventConsole.append ("\n");
    }

    /**
     * Logs a string to the event console.
     */
    void log (char[] string) {
        eventConsole.append (string);
        eventConsole.append ("\n");
    }

    /**
     * Logs a typed event to the event console.
     */
    void log (char[] eventName, TypedEvent event) {
        eventConsole.append (eventName ~ ": ");
        eventConsole.append (event.toString ());
        eventConsole.append ("\n");
    }

    /**
     * Recreates the "Example" widgets.
     */
    void recreateExampleWidgets () {
        disposeExampleWidgets ();
        createExampleWidgets ();
        hookExampleWidgetListeners ();
        setExampleWidgetState ();
    }

    /**
     * Sets the foreground color, background color, and font
     * of the "Example" widgets to their default settings.
     * Subclasses may extend in order to reset other colors
     * and fonts to default settings as well.
     */
    void resetColorsAndFonts () {
        Color oldColor = foregroundColor;
        foregroundColor = null;
        setExampleWidgetForeground ();
        if (oldColor !is null) oldColor.dispose();
        oldColor = backgroundColor;
        backgroundColor = null;
        setExampleWidgetBackground ();
        if (oldColor !is null) oldColor.dispose();
        Font oldFont = font;
        font = null;
        setExampleWidgetFont ();
        setExampleWidgetSize ();
        if (oldFont !is null) oldFont.dispose();
    }

    /**
     * Sets the background color of the "Example" widgets' parent.
     */
    void setExampleGroupBackgroundColor () {
        if (backgroundModeGroup is null) return;
        exampleGroup.setBackground (backgroundModeColorButton.getSelection () ? display.getSystemColor(DWT.COLOR_BLUE) : null);
    }
    /**
     * Sets the background image of the "Example" widgets' parent.
     */
    void setExampleGroupBackgroundImage () {
        if (backgroundModeGroup is null) return;
        exampleGroup.setBackgroundImage (backgroundModeImageButton.getSelection () ? instance.images[ControlExample.ciParentBackground] : null);
    }

    /**
     * Sets the background mode of the "Example" widgets' parent.
     */
    void setExampleGroupBackgroundMode () {
        if (backgroundModeGroup is null) return;
        char[] modeString = backgroundModeCombo.getText ();
        int mode = DWT.INHERIT_NONE;
        if (modeString=="DWT.INHERIT_DEFAULT") mode = DWT.INHERIT_DEFAULT;
        if (modeString=="DWT.INHERIT_FORCE") mode = DWT.INHERIT_FORCE;
        exampleGroup.setBackgroundMode (mode);
    }

    /**
     * Sets the background color of the "Example" widgets.
     */
    void setExampleWidgetBackground () {
        if (colorAndFontTable is null) return; // user cannot change color/font on this tab
        Control [] controls = getExampleControls ();
        if (!instance.startup) {
            for (int i = 0; i < controls.length; i++) {
                controls[i].setBackground (backgroundColor);
            }
        }
        // Set the background color item's image to match the background color of the example widget(s).
        Color color = backgroundColor;
        if (controls.length is 0) return;
        if (color is null) color = controls [0].getBackground ();
        TableItem item = colorAndFontTable.getItem(BACKGROUND_COLOR);
        Image oldImage = item.getImage();
        if (oldImage !is null) oldImage.dispose();
        item.setImage (colorImage (color));
    }

    /**
     * Sets the enabled state of the "Example" widgets.
     */
    void setExampleWidgetEnabled () {
        Control [] controls = getExampleControls ();
        for (int i=0; i<controls.length; i++) {
            controls [i].setEnabled (enabledButton.getSelection ());
        }
    }

    /**
     * Sets the font of the "Example" widgets.
     */
    void setExampleWidgetFont () {
        if (colorAndFontTable is null) return; // user cannot change color/font on this tab
        Control [] controls = getExampleControls ();
        if (!instance.startup) {
            for (int i = 0; i < controls.length; i++) {
                controls[i].setFont(font);
            }
        }
        /* Set the font item's image and font to match the font of the example widget(s). */
        Font ft = font;
        if (controls.length is 0) return;
        if (ft is null) ft = controls [0].getFont ();
        TableItem item = colorAndFontTable.getItem(FONT);
        Image oldImage = item.getImage();
        if (oldImage !is null) oldImage.dispose();
        item.setImage (fontImage (ft));
        item.setFont(ft);
        colorAndFontTable.layout ();
    }

    /**
     * Sets the foreground color of the "Example" widgets.
     */
    void setExampleWidgetForeground () {
        if (colorAndFontTable is null) return; // user cannot change color/font on this tab
        Control [] controls = getExampleControls ();
        if (!instance.startup) {
            for (int i = 0; i < controls.length; i++) {
                controls[i].setForeground (foregroundColor);
            }
        }
        /* Set the foreground color item's image to match the foreground color of the example widget(s). */
        Color color = foregroundColor;
        if (controls.length is 0) return;
        if (color is null) color = controls [0].getForeground ();
        TableItem item = colorAndFontTable.getItem(FOREGROUND_COLOR);
        Image oldImage = item.getImage();
        if (oldImage !is null) oldImage.dispose();
        item.setImage (colorImage(color));
    }

    /**
     * Sets the size of the "Example" widgets.
     */
    void setExampleWidgetSize () {
        int size = DWT.DEFAULT;
        if (preferredButton is null) return;
        if (preferredButton.getSelection()) size = DWT.DEFAULT;
        if (tooSmallButton.getSelection()) size = TOO_SMALL_SIZE;
        if (smallButton.getSelection()) size = SMALL_SIZE;
        if (largeButton.getSelection()) size = LARGE_SIZE;
        Control [] controls = getExampleControls ();
        for (int i=0; i<controls.length; i++) {
            GridData gridData = new GridData(size, size);
            gridData.grabExcessHorizontalSpace = fillHButton.getSelection();
            gridData.grabExcessVerticalSpace = fillVButton.getSelection();
            gridData.horizontalAlignment = fillHButton.getSelection() ? DWT.FILL : DWT.LEFT;
            gridData.verticalAlignment = fillVButton.getSelection() ? DWT.FILL : DWT.TOP;
            controls [i].setLayoutData (gridData);
        }
        tabFolderPage.layout (controls);
    }

    /**
     * Sets the state of the "Example" widgets.  Subclasses
     * reimplement this method to set "Example" widget state
     * that is specific to the widget.
     */
    void setExampleWidgetState () {
        setExampleWidgetBackground ();
        setExampleWidgetForeground ();
        setExampleWidgetFont ();
        if (!instance.startup) {
            setExampleWidgetEnabled ();
            setExampleWidgetVisibility ();
            setExampleGroupBackgroundMode ();
            setExampleGroupBackgroundColor ();
            setExampleGroupBackgroundImage ();
            setExampleWidgetBackgroundImage ();
            setExampleWidgetPopupMenu ();
            setExampleWidgetSize ();
        }
        //TEMPORARY CODE
//      Control [] controls = getExampleControls ();
//      for (int i=0; i<controls.length; i++) {
//          log ("Control=" + controls [i] + ", border width=" + controls [i].getBorderWidth ());
//      }
    }

    /**
     * Sets the visibility of the "Example" widgets.
     */
    void setExampleWidgetVisibility () {
        Control [] controls = getExampleControls ();
        for (int i=0; i<controls.length; i++) {
            controls [i].setVisible (visibleButton.getSelection ());
        }
    }

    /**
     * Sets the background image of the "Example" widgets.
     */
    void setExampleWidgetBackgroundImage () {
        Control [] controls = getExampleControls ();
        for (int i=0; i<controls.length; i++) {
            controls [i].setBackgroundImage (backgroundImageButton.getSelection () ? instance.images[ControlExample.ciBackground] : null);
        }
    }

    /**
     * Splits the given string around matches of the given character.
     *
     * This subset of java.lang.String.split(String regex)
     * uses only code that can be run on CLDC platforms.
     */
    char[] [] split (char[] string, char ch) {
        char[] [] result = new char[][0];
        int start = 0;
        int length = string.length;
        while (start < length) {
            int end = tango.text.Util.locate( string, ch, start);
            if (end is string.length ) end = length;
            char[] substr = string[start .. end];
            char[] [] newResult = new char[][result.length + 1];
            System.arraycopy(result, 0, newResult, 0, result.length);
            newResult [result.length] = substr;
            result = newResult;
            start = end + 1;
        }
        return result;
    }
}
