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
module examples.controlexample.StyledTextTab;


import dwt.dwthelper.ByteArrayInputStream;


import dwt.DWT;
import dwt.custom.StyleRange;
import dwt.custom.StyledText;
import dwt.events.ControlAdapter;
import dwt.events.ControlEvent;
import dwt.events.DisposeEvent;
import dwt.events.DisposeListener;
import dwt.events.SelectionAdapter;
import dwt.events.SelectionEvent;
import dwt.events.SelectionListener;
import dwt.graphics.Color;
import dwt.graphics.Image;
import dwt.graphics.ImageData;
import dwt.graphics.Point;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.widgets.Button;
import dwt.widgets.Composite;
import dwt.widgets.Display;
import dwt.widgets.Group;
import dwt.widgets.Label;
import dwt.widgets.TabFolder;
import dwt.widgets.Widget;

import examples.controlexample.ScrollableTab;
import examples.controlexample.ControlExample;
import tango.core.Exception;
import tango.io.Stdout;

class StyledTextTab : ScrollableTab {
    /* Example widgets and groups that contain them */
    StyledText styledText;
    Group styledTextGroup, styledTextStyleGroup;

    /* Style widgets added to the "Style" group */
    Button wrapButton, readOnlyButton, fullSelectionButton;

    /* Buttons for adding StyleRanges to StyledText */
    Button boldButton, italicButton, redButton, yellowButton, underlineButton, strikeoutButton;
    Image boldImage, italicImage, redImage, yellowImage, underlineImage, strikeoutImage;

    /* Variables for saving state. */
    char[] text;
    StyleRange[] styleRanges;

    /**
     * Creates the Tab within a given instance of ControlExample.
     */
    this(ControlExample instance) {
        super(instance);
    }

    /**
     * Creates a bitmap image.
     */
    Image createBitmapImage (Display display, void[] sourceData, void[] maskData ) {
        InputStream sourceStream = new ByteArrayInputStream ( cast(byte[])sourceData );
        InputStream maskStream = new ByteArrayInputStream ( cast(byte[])maskData );
        ImageData source = new ImageData (sourceStream);
        ImageData mask = new ImageData (maskStream);
        Image result = new Image (display, source, mask);
        try {
            sourceStream.close ();
            maskStream.close ();
        } catch (IOException e) {
            Stderr.formatln( "Stacktrace: {}", e );
        }
        return result;
    }

    /**
     * Creates the "Control" widget children.
     */
    void createControlWidgets () {
        super.createControlWidgets ();

        /* Add a group for modifying the StyledText widget */
        createStyledTextStyleGroup ();
    }

    /**
     * Creates the "Example" group.
     */
    void createExampleGroup () {
        super.createExampleGroup ();

        /* Create a group for the styled text widget */
        styledTextGroup = new Group (exampleGroup, DWT.NONE);
        styledTextGroup.setLayout (new GridLayout ());
        styledTextGroup.setLayoutData (new GridData (DWT.FILL, DWT.FILL, true, true));
        styledTextGroup.setText ("StyledText");
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
        if (borderButton.getSelection ()) style |= DWT.BORDER;
        if (fullSelectionButton.getSelection ()) style |= DWT.FULL_SELECTION;

        /* Create the example widgets */
        styledText = new StyledText (styledTextGroup, style);
        styledText.setText (ControlExample.getResourceString("Example_string"));
        styledText.append ("\n");
        styledText.append (ControlExample.getResourceString("One_Two_Three"));

        if (text !is null) {
            styledText.setText(text);
            text = null;
        }
        if (styleRanges !is null) {
            styledText.setStyleRanges(styleRanges);
            styleRanges = null;
        }
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
        fullSelectionButton = new Button (styleGroup, DWT.CHECK);
        fullSelectionButton.setText ("DWT.FULL_SELECTION");
    }

    /**
     * Creates the "StyledText Style" group.
     */
    void createStyledTextStyleGroup () {
        styledTextStyleGroup = new Group (controlGroup, DWT.NONE);
        styledTextStyleGroup.setText (ControlExample.getResourceString ("StyledText_Styles"));
        styledTextStyleGroup.setLayout (new GridLayout(6, false));
        GridData data = new GridData (GridData.HORIZONTAL_ALIGN_FILL);
        data.horizontalSpan = 2;
        styledTextStyleGroup.setLayoutData (data);

        /* Get images */
        boldImage = createBitmapImage (display, import("examples.controlexample.bold.bmp"), import("examples.controlexample.bold_mask.bmp"));
        italicImage = createBitmapImage (display, import("examples.controlexample.italic.bmp"), import("examples.controlexample.italic_mask.bmp"));
        redImage = createBitmapImage (display, import("examples.controlexample.red.bmp"), import("examples.controlexample.red_mask.bmp"));
        yellowImage = createBitmapImage (display, import("examples.controlexample.yellow.bmp"), import("examples.controlexample.yellow_mask.bmp"));
        underlineImage = createBitmapImage (display, import("examples.controlexample.underline.bmp"), import("examples.controlexample.underline_mask.bmp"));
        strikeoutImage = createBitmapImage (display, import("examples.controlexample.strikeout.bmp"), import("examples.controlexample.strikeout_mask.bmp"));

        /* Create controls to modify the StyledText */
        Label label = new Label (styledTextStyleGroup, DWT.NONE);
        label.setText (ControlExample.getResourceString ("StyledText_Style_Instructions"));
        label.setLayoutData(new GridData(DWT.FILL, DWT.CENTER, false, false, 6, 1));
        label = new Label (styledTextStyleGroup, DWT.NONE);
        label.setText (ControlExample.getResourceString ("Bold"));
        label.setLayoutData(new GridData(DWT.END, DWT.CENTER, true, false));
        boldButton = new Button (styledTextStyleGroup, DWT.PUSH);
        boldButton.setImage (boldImage);
        label = new Label (styledTextStyleGroup, DWT.NONE);
        label.setText (ControlExample.getResourceString ("Underline"));
        label.setLayoutData(new GridData(DWT.END, DWT.CENTER, true, false));
        underlineButton = new Button (styledTextStyleGroup, DWT.PUSH);
        underlineButton.setImage (underlineImage);
        label = new Label (styledTextStyleGroup, DWT.NONE);
        label.setText (ControlExample.getResourceString ("Foreground_Style"));
        label.setLayoutData(new GridData(DWT.END, DWT.CENTER, true, false));
        redButton = new Button (styledTextStyleGroup, DWT.PUSH);
        redButton.setImage (redImage);
        label = new Label (styledTextStyleGroup, DWT.NONE);
        label.setText (ControlExample.getResourceString ("Italic"));
        label.setLayoutData(new GridData(DWT.END, DWT.CENTER, true, false));
        italicButton = new Button (styledTextStyleGroup, DWT.PUSH);
        italicButton.setImage (italicImage);
        label = new Label (styledTextStyleGroup, DWT.NONE);
        label.setText (ControlExample.getResourceString ("Strikeout"));
        label.setLayoutData(new GridData(DWT.END, DWT.CENTER, true, false));
        strikeoutButton = new Button (styledTextStyleGroup, DWT.PUSH);
        strikeoutButton.setImage (strikeoutImage);
        label = new Label (styledTextStyleGroup, DWT.NONE);
        label.setText (ControlExample.getResourceString ("Background_Style"));
        label.setLayoutData(new GridData(DWT.END, DWT.CENTER, true, false));
        yellowButton = new Button (styledTextStyleGroup, DWT.PUSH);
        yellowButton.setImage (yellowImage);
        SelectionListener styleListener = new class() SelectionAdapter {
            public void widgetSelected (SelectionEvent e) {
                Point sel = styledText.getSelectionRange();
                if ((sel is null) || (sel.y is 0)) return;
                StyleRange style;
                for (int i = sel.x; i<sel.x+sel.y; i++) {
                    StyleRange range = styledText.getStyleRangeAtOffset(i);
                    if (range !is null) {
                        style = cast(StyleRange)range.clone();
                        style.start = i;
                        style.length = 1;
                    } else {
                        style = new StyleRange(i, 1, null, null, DWT.NORMAL);
                    }
                    if (e.widget is boldButton) {
                        style.fontStyle ^= DWT.BOLD;
                    } else if (e.widget is italicButton) {
                        style.fontStyle ^= DWT.ITALIC;
                    } else if (e.widget is underlineButton) {
                        style.underline = !style.underline;
                    } else if (e.widget is strikeoutButton) {
                        style.strikeout = !style.strikeout;
                    }
                    styledText.setStyleRange(style);
                }
                styledText.setSelectionRange(sel.x + sel.y, 0);
            }
        };
        SelectionListener colorListener = new class() SelectionAdapter {
            public void widgetSelected (SelectionEvent e) {
                Point sel = styledText.getSelectionRange();
                if ((sel is null) || (sel.y is 0)) return;
                Color fg = null, bg = null;
                if (e.widget is redButton) {
                    fg = display.getSystemColor (DWT.COLOR_RED);
                } else if (e.widget is yellowButton) {
                    bg = display.getSystemColor (DWT.COLOR_YELLOW);
                }
                StyleRange style;
                for (int i = sel.x; i<sel.x+sel.y; i++) {
                    StyleRange range = styledText.getStyleRangeAtOffset(i);
                    if (range !is null) {
                        style = cast(StyleRange)range.clone();
                        style.start = i;
                        style.length = 1;
                        style.foreground = style.foreground !is null ? null : fg;
                        style.background = style.background !is null ? null : bg;
                    } else {
                        style = new StyleRange (i, 1, fg, bg, DWT.NORMAL);
                    }
                    styledText.setStyleRange(style);
                }
                styledText.setSelectionRange(sel.x + sel.y, 0);
            }
        };
        boldButton.addSelectionListener(styleListener);
        italicButton.addSelectionListener(styleListener);
        underlineButton.addSelectionListener(styleListener);
        strikeoutButton.addSelectionListener(styleListener);
        redButton.addSelectionListener(colorListener);
        yellowButton.addSelectionListener(colorListener);
        yellowButton.addDisposeListener(new class() DisposeListener {
            public void widgetDisposed (DisposeEvent e) {
                boldImage.dispose();
                italicImage.dispose();
                redImage.dispose();
                yellowImage.dispose();
                underlineImage.dispose();
                strikeoutImage.dispose();
            }
        });
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
     * Disposes the "Example" widgets.
     */
    void disposeExampleWidgets () {
        /* store the state of the styledText if applicable */
        if (styledText !is null) {
            styleRanges = styledText.getStyleRanges();
            text = styledText.getText();
        }
        super.disposeExampleWidgets();
    }

    /**
     * Gets the "Example" widget children.
     */
    Widget [] getExampleWidgets () {
        return [ cast(Widget) styledText];
    }

    /**
     * Returns a list of set/get API method names (without the set/get prefix)
     * that can be used to set/get values in the example control(s).
     */
    char[][] getMethodNames() {
        return ["CaretOffset", "DoubleClickEnabled", "Editable", "HorizontalIndex", "HorizontalPixel", "Orientation", "Selection", "Tabs", "Text", "TextLimit", "ToolTipText", "TopIndex", "TopPixel", "WordWrap"];
    }


    /**
     * Gets the text for the tab folder item.
     */
    char[] getTabText () {
        return "StyledText";
    }

    /**
     * Sets the state of the "Example" widgets.
     */
    void setExampleWidgetState () {
        super.setExampleWidgetState ();
        wrapButton.setSelection ((styledText.getStyle () & DWT.WRAP) !is 0);
        readOnlyButton.setSelection ((styledText.getStyle () & DWT.READ_ONLY) !is 0);
        fullSelectionButton.setSelection ((styledText.getStyle () & DWT.FULL_SELECTION) !is 0);
        horizontalButton.setEnabled ((styledText.getStyle () & DWT.MULTI) !is 0);
        verticalButton.setEnabled ((styledText.getStyle () & DWT.MULTI) !is 0);
        wrapButton.setEnabled ((styledText.getStyle () & DWT.MULTI) !is 0);
    }
}
