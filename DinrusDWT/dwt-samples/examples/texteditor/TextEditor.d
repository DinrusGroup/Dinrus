/*******************************************************************************
 * Copyright (c) 2000, 2006 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 * Port to the D programming language:
 *     Thomas Graber <d4rkdragon@gmail.com>
 *******************************************************************************/
module examples.texteditor.TextEditor;

import dwt.DWT;
import dwt.custom.ExtendedModifyEvent;
import dwt.custom.ExtendedModifyListener;
import dwt.custom.StyleRange;
import dwt.custom.StyledText;
import dwt.events.DisposeEvent;
import dwt.events.DisposeListener;
import dwt.events.SelectionAdapter;
import dwt.events.SelectionEvent;
import dwt.graphics.Color;
import dwt.graphics.Font;
import dwt.graphics.FontData;
import dwt.graphics.Point;
import dwt.graphics.RGB;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.widgets.Display;
import dwt.widgets.FontDialog;
import dwt.widgets.Menu;
import dwt.widgets.MenuItem;
import dwt.widgets.Shell;
import dwt.widgets.ToolBar;
import dwt.widgets.ToolItem;
import dwt.widgets.Widget;
import dwt.dwthelper.ResourceBundle;
import dwt.dwthelper.utils;

import tango.util.collection.ArraySeq;

import examples.texteditor.Images;

version( JIVE ){
    import jive.stacktrace;
}

/**
 */
public class TextEditor {
    Shell shell;
    ToolBar toolBar;
    StyledText text;
    Images images;
    alias ArraySeq!(StyleRange) StyleCache;
    StyleCache cachedStyles;

    Color RED = null;
    Color BLUE = null;
    Color GREEN = null;
    Font font = null;
    ToolItem boldButton, italicButton, underlineButton, strikeoutButton;

    //string resources
    static ResourceBundle resources;
    private static const char[] resourceData = import( "examples.texteditor.examples_texteditor.properties" );

    /*
     * static ctor
     */
    static this()
    {
        resources = ResourceBundle.getBundleFromData( resourceData );
    }

    /*
     * ctor
     */
    this() {
        images = new Images();
    }

    /*
     * creates edit menu
     */
    Menu createEditMenu() {
        Menu bar = shell.getMenuBar ();
        Menu menu = new Menu (bar);

        MenuItem item = new MenuItem (menu, DWT.PUSH);
        item.setText (resources.getString("Cut_menuitem"));
        item.setAccelerator(DWT.MOD1 + 'X');
        item.addSelectionListener(new class() SelectionAdapter {
            public void widgetSelected(SelectionEvent event) {
                handleCutCopy();
                text.cut();
            }
        });
        item = new MenuItem (menu, DWT.PUSH);
        item.setText (resources.getString("Copy_menuitem"));
        item.setAccelerator(DWT.MOD1 + 'C');
        item.addSelectionListener(new class() SelectionAdapter {
            public void widgetSelected(SelectionEvent event) {
                handleCutCopy();
                text.copy();
            }
        });
        item = new MenuItem (menu, DWT.PUSH);
        item.setText (resources.getString("Paste_menuitem"));
        item.setAccelerator(DWT.MOD1 + 'V');
        item.addSelectionListener(new class() SelectionAdapter {
            public void widgetSelected(SelectionEvent event) {
                text.paste();
            }
        });
        new MenuItem (menu, DWT.SEPARATOR);
        item = new MenuItem (menu, DWT.PUSH);
        item.setText (resources.getString("Font_menuitem"));
        item.addSelectionListener(new class() SelectionAdapter {
            public void widgetSelected(SelectionEvent event) {
                setFont();
            }
        });
        return menu;
    }

    /*
     * creates file menu
     */
    Menu createFileMenu() {
        Menu bar = shell.getMenuBar ();
        Menu menu = new Menu (bar);

        MenuItem item = new MenuItem (menu, DWT.PUSH);
        item.setText (resources.getString("Exit_menuitem"));
        item.addSelectionListener(new class() SelectionAdapter {
            public void widgetSelected(SelectionEvent event) {
                shell.close ();
            }
        });

        return menu;
    }

    /*
     * Set a style
     */
    void setStyle(Widget widget) {
        Point sel = text.getSelectionRange();
        if ((sel is null) || (sel.y is 0)) return;
        StyleRange style;
        for (int i = sel.x; i<sel.x+sel.y; i++) {
            StyleRange range = text.getStyleRangeAtOffset(i);
            if (range !is null) {
                style = cast(StyleRange)range.clone();
                style.start = i;
                style.length = 1;
            } else {
                style = new StyleRange(i, 1, null, null, DWT.NORMAL);
            }
            if (widget is boldButton) {
                style.fontStyle ^= DWT.BOLD;
            } else if (widget is italicButton) {
                style.fontStyle ^= DWT.ITALIC;
            } else if (widget is underlineButton) {
                style.underline = !style.underline;
            } else if (widget is strikeoutButton) {
                style.strikeout = !style.strikeout;
            }
            text.setStyleRange(style);
        }
        text.setSelectionRange(sel.x + sel.y, 0);
    }

    /*
     * Clear all style data for the selected text.
     */
    void clear() {
        Point sel = text.getSelectionRange();
        if (sel.y !is 0) {
            StyleRange style;
            style = new StyleRange(sel.x, sel.y, null, null, DWT.NORMAL);
            text.setStyleRange(style);
        }
        text.setSelectionRange(sel.x + sel.y, 0);
    }

    /*
     * Set the foreground color for the selected text.
     */
    void fgColor(Color fg) {
        Point sel = text.getSelectionRange();
        if ((sel is null) || (sel.y is 0)) return;
        StyleRange style, range;
        for (int i = sel.x; i<sel.x+sel.y; i++) {
            range = text.getStyleRangeAtOffset(i);
            if (range !is null) {
                style = cast(StyleRange)range.clone();
                style.start = i;
                style.length = 1;
                style.foreground = fg;
            } else {
                style = new StyleRange (i, 1, fg, null, DWT.NORMAL);
            }
            text.setStyleRange(style);
        }
        text.setSelectionRange(sel.x + sel.y, 0);
    }

    /*
     * creates menu bar
     */
    void createMenuBar () {
        Menu bar = new Menu (shell, DWT.BAR);
        shell.setMenuBar (bar);

        MenuItem fileItem = new MenuItem (bar, DWT.CASCADE);
        fileItem.setText (resources.getString("File_menuitem"));
        fileItem.setMenu (createFileMenu ());

        MenuItem editItem = new MenuItem (bar, DWT.CASCADE);
        editItem.setText (resources.getString("Edit_menuitem"));
        editItem.setMenu (createEditMenu ());
    }

    /*
     * creates shell
     */
    void createShell (Display display) {
        shell = new Shell (display);
        shell.setText (resources.getString("Window_title"));
        images.loadAll (display);
        GridLayout layout = new GridLayout();
        layout.numColumns = 1;
        shell.setLayout(layout);
        shell.addDisposeListener (new class() DisposeListener {
            public void widgetDisposed (DisposeEvent e) {
                if (font !is null) font.dispose();
                images.freeAll ();
                RED.dispose();
                GREEN.dispose();
                BLUE.dispose();
            }
        });
    }

    /*
     * creates styled text widget
     */
    void createStyledText() {
        initializeColors();
        text = new StyledText (shell, DWT.BORDER | DWT.MULTI | DWT.V_SCROLL | DWT.H_SCROLL);
        GridData spec = new GridData();
        spec.horizontalAlignment = GridData.FILL;
        spec.grabExcessHorizontalSpace = true;
        spec.verticalAlignment = GridData.FILL;
        spec.grabExcessVerticalSpace = true;
        text.setLayoutData(spec);
        text.addExtendedModifyListener(new class() ExtendedModifyListener {
            public void modifyText(ExtendedModifyEvent e) {
                handleExtendedModify(e);
            }
        });
    }

    /*
     * creates tool bar
     */
    void createToolBar() {
        toolBar = new ToolBar(shell, DWT.NONE);
        SelectionAdapter listener = new class() SelectionAdapter {
            public void widgetSelected(SelectionEvent event) {
                setStyle (event.widget);
            }
        };
        boldButton = new ToolItem(toolBar, DWT.CHECK);
        boldButton.setImage(images.Bold);
        boldButton.setToolTipText(resources.getString("Bold"));
        boldButton.addSelectionListener(listener);
        italicButton = new ToolItem(toolBar, DWT.CHECK);
        italicButton.setImage(images.Italic);
        italicButton.setToolTipText(resources.getString("Italic"));
        italicButton.addSelectionListener(listener);
        underlineButton = new ToolItem(toolBar, DWT.CHECK);
        underlineButton.setImage(images.Underline);
        underlineButton.setToolTipText(resources.getString("Underline"));
        underlineButton.addSelectionListener(listener);
        strikeoutButton = new ToolItem(toolBar, DWT.CHECK);
        strikeoutButton.setImage(images.Strikeout);
        strikeoutButton.setToolTipText(resources.getString("Strikeout"));
        strikeoutButton.addSelectionListener(listener);

        ToolItem item = new ToolItem(toolBar, DWT.SEPARATOR);
        item = new ToolItem(toolBar, DWT.PUSH);
        item.setImage(images.Red);
        item.addSelectionListener(new class() SelectionAdapter {
            public void widgetSelected(SelectionEvent event) {
                fgColor(RED);
            }
        });
        item = new ToolItem(toolBar, DWT.PUSH);
        item.setImage(images.Green);
        item.addSelectionListener(new class() SelectionAdapter {
            public void widgetSelected(SelectionEvent event) {
                fgColor(GREEN);
            }
        });
        item = new ToolItem(toolBar, DWT.PUSH);
        item.setImage(images.Blue);
        item.addSelectionListener(new class() SelectionAdapter {
            public void widgetSelected(SelectionEvent event) {
                fgColor(BLUE);
            }
        });
        item = new ToolItem(toolBar, DWT.SEPARATOR);
        item = new ToolItem(toolBar, DWT.PUSH);
        item.setImage(images.Erase);
        item.addSelectionListener(new class() SelectionAdapter {
            public void widgetSelected(SelectionEvent event) {
                clear();
            }
        });
    }

    /*
     * Cache the style information for text that has been cut or copied.
     */
    void handleCutCopy() {
        // Save the cut/copied style info so that during paste we will maintain
        // the style information.  Cut/copied text is put in the clipboard in
        // RTF format, but is not pasted in RTF format.  The other way to
        // handle the pasting of styles would be to access the Clipboard directly and
        // parse the RTF text.
        cachedStyles = new StyleCache();
        Point sel = text.getSelectionRange();
        int startX = sel.x;
        for (int i=sel.x; i<=sel.x+sel.y-1; i++) {
            StyleRange style = text.getStyleRangeAtOffset(i);
            if (style !is null) {
                style.start = style.start - startX;
                if (cachedStyles.toArray().length > 0) {
                    StyleRange lastStyle = cachedStyles.tail();
                    if (lastStyle.similarTo(style) && lastStyle.start + lastStyle.length is style.start) {
                        lastStyle.length++;
                    } else {
                        cachedStyles.append(style);
                    }
                } else {
                    cachedStyles.append(style);
                }
            }
        }
    }

    /*
     * handle modify
     */
    void handleExtendedModify(ExtendedModifyEvent event) {
        if (event.length is 0) return;
        StyleRange style;
        //PORTING event.length is char count, but it needs to decide on codepoint count
        auto cont = text.getTextRange(event.start, event.length);
        if ( codepointCount(cont) is 1 || cont == text.getLineDelimiter()) {
            // Have the new text take on the style of the text to its right (during
            // typing) if no style information is active.
            int caretOffset = text.getCaretOffset();
            style = null;
            if (caretOffset < text.getCharCount()) style = text.getStyleRangeAtOffset(caretOffset);
            if (style !is null) {
                style = cast(StyleRange) style.clone ();
                style.start = event.start;
                style.length = event.length;
            } else {
                style = new StyleRange(event.start, event.length, null, null, DWT.NORMAL);
            }
            if (boldButton.getSelection()) style.fontStyle |= DWT.BOLD;
            if (italicButton.getSelection()) style.fontStyle |= DWT.ITALIC;
            style.underline = underlineButton.getSelection();
            style.strikeout = strikeoutButton.getSelection();
            if (!style.isUnstyled()) text.setStyleRange(style);
        } else {
            // paste occurring, have text take on the styles it had when it was
            // cut/copied
            if( cachedStyles !is null ){
                foreach (style; cachedStyles) {
                    StyleRange newStyle = cast(StyleRange)style.clone();
                    newStyle.start = style.start + event.start;
                    text.setStyleRange(newStyle);
                }
            }
        }
    }

    /*
     * opens the shell
     */
    public Shell open (Display display) {
        createShell (display);
        createMenuBar ();
        createToolBar ();
        createStyledText ();
        shell.setSize(500, 300);
        shell.open ();
        return shell;
    }

    /*
     * set the font for styled text widget
     */
    void setFont() {
        FontDialog fontDialog = new FontDialog(shell);
        fontDialog.setFontList((text.getFont()).getFontData());
        FontData fontData = fontDialog.open();
        if (fontData !is null) {
            Font newFont = new Font(shell.getDisplay(), fontData);
            text.setFont(newFont);
            if (font !is null) font.dispose();
            font = newFont;
        }
    }

    /*
     * initialize the colors
     */
    void initializeColors() {
        Display display = Display.getDefault();
        RED = new Color (display, new RGB(255,0,0));
        BLUE = new Color (display, new RGB(0,0,255));
        GREEN = new Color (display, new RGB(0,255,0));
    }
}

/*
 * main function
 */
public void main (char[][] args) {
    Display display = new Display ();
    TextEditor example = new TextEditor ();
    Shell shell = example.open (display);
    while (!shell.isDisposed ())
        if (!display.readAndDispatch ()) display.sleep ();
    display.dispose ();
}
