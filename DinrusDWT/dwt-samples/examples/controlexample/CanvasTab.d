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
module examples.controlexample.CanvasTab;



import dwt.DWT;
import dwt.events.ControlAdapter;
import dwt.events.ControlEvent;
import dwt.events.PaintEvent;
import dwt.events.PaintListener;
import dwt.events.SelectionAdapter;
import dwt.events.SelectionEvent;
import dwt.graphics.Color;
import dwt.graphics.Font;
import dwt.graphics.GC;
import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.widgets.Button;
import dwt.widgets.Canvas;
import dwt.widgets.Caret;
import dwt.widgets.Composite;
import dwt.widgets.Group;
import dwt.widgets.ScrollBar;
import dwt.widgets.TabFolder;
import dwt.widgets.Widget;

import examples.controlexample.Tab;
import examples.controlexample.ControlExample;

class CanvasTab : Tab {
    static const int colors [] = [
        DWT.COLOR_RED,
        DWT.COLOR_GREEN,
        DWT.COLOR_BLUE,
        DWT.COLOR_MAGENTA,
        DWT.COLOR_YELLOW,
        DWT.COLOR_CYAN,
        DWT.COLOR_DARK_RED,
        DWT.COLOR_DARK_GREEN,
        DWT.COLOR_DARK_BLUE,
        DWT.COLOR_DARK_MAGENTA,
        DWT.COLOR_DARK_YELLOW,
        DWT.COLOR_DARK_CYAN
    ];
    static final char[] canvasString = "Canvas"; //$NON-NLS-1$

    /* Example widgets and groups that contain them */
    Canvas canvas;
    Group canvasGroup;

    /* Style widgets added to the "Style" group */
    Button horizontalButton, verticalButton, noBackgroundButton, noFocusButton,
    noMergePaintsButton, noRedrawResizeButton, doubleBufferedButton;

    /* Other widgets added to the "Other" group */
    Button caretButton, fillDamageButton;

    int paintCount;
    int cx, cy;
    int maxX, maxY;

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
        caretButton = new Button (otherGroup, DWT.CHECK);
        caretButton.setText (ControlExample.getResourceString("Caret"));
        fillDamageButton = new Button (otherGroup, DWT.CHECK);
        fillDamageButton.setText (ControlExample.getResourceString("FillDamage"));

        /* Add the listeners */
        caretButton.addSelectionListener (new class() SelectionAdapter {
            public void widgetSelected (SelectionEvent event) {
                setCaret ();
            }
        });
    }

    /**
     * Creates the "Example" group.
     */
    void createExampleGroup () {
        super.createExampleGroup ();

        /* Create a group for the canvas widget */
        canvasGroup = new Group (exampleGroup, DWT.NONE);
        canvasGroup.setLayout (new GridLayout ());
        canvasGroup.setLayoutData (new GridData (DWT.FILL, DWT.FILL, true, true));
        canvasGroup.setText ("Canvas");
    }

    /**
     * Creates the "Example" widgets.
     */
    void createExampleWidgets () {

        /* Compute the widget style */
        int style = getDefaultStyle();
        if (horizontalButton.getSelection ()) style |= DWT.H_SCROLL;
        if (verticalButton.getSelection ()) style |= DWT.V_SCROLL;
        if (borderButton.getSelection ()) style |= DWT.BORDER;
        if (noBackgroundButton.getSelection ()) style |= DWT.NO_BACKGROUND;
        if (noFocusButton.getSelection ()) style |= DWT.NO_FOCUS;
        if (noMergePaintsButton.getSelection ()) style |= DWT.NO_MERGE_PAINTS;
        if (noRedrawResizeButton.getSelection ()) style |= DWT.NO_REDRAW_RESIZE;
        if (doubleBufferedButton.getSelection ()) style |= DWT.DOUBLE_BUFFERED;

        /* Create the example widgets */
        paintCount = 0; cx = 0; cy = 0;
        canvas = new Canvas (canvasGroup, style);
        canvas.addPaintListener(new class() PaintListener {
            public void paintControl(PaintEvent e) {
                paintCount++;
                GC gc = e.gc;
                if (fillDamageButton.getSelection ()) {
                    Color color = e.display.getSystemColor (colors [paintCount % colors.length]);
                    gc.setBackground(color);
                    gc.fillRectangle(e.x, e.y, e.width, e.height);
                }
                Point size = canvas.getSize ();
                gc.drawArc(cx + 1, cy + 1, size.x - 2, size.y - 2, 0, 360);
                gc.drawRectangle(cx + (size.x - 10) / 2, cy + (size.y - 10) / 2, 10, 10);
                Point extent = gc.textExtent(canvasString);
                gc.drawString(canvasString, cx + (size.x - extent.x) / 2, cy - extent.y + (size.y - 10) / 2, true);
            }
        });
        canvas.addControlListener(new class() ControlAdapter {
            public void controlResized(ControlEvent event) {
                Point size = canvas.getSize ();
                maxX = size.x * 3 / 2; maxY = size.y * 3 / 2;
                resizeScrollBars ();
            }
        });
        ScrollBar bar = canvas.getHorizontalBar();
        if (bar !is null) {
            hookListeners (bar);
            bar.addSelectionListener(new class() SelectionAdapter {
                public void widgetSelected(SelectionEvent event) {
                    scrollHorizontal (cast(ScrollBar)event.widget);
                }
            });
        }
        bar = canvas.getVerticalBar();
        if (bar !is null) {
            hookListeners (bar);
            bar.addSelectionListener(new class() SelectionAdapter {
                public void widgetSelected(SelectionEvent event) {
                    scrollVertical (cast(ScrollBar)event.widget);
                }
            });
        }
    }

    /**
     * Creates the "Style" group.
     */
    void createStyleGroup() {
        super.createStyleGroup();

        /* Create the extra widgets */
        horizontalButton = new Button (styleGroup, DWT.CHECK);
        horizontalButton.setText ("DWT.H_SCROLL");
        horizontalButton.setSelection(true);
        verticalButton = new Button (styleGroup, DWT.CHECK);
        verticalButton.setText ("DWT.V_SCROLL");
        verticalButton.setSelection(true);
        borderButton = new Button (styleGroup, DWT.CHECK);
        borderButton.setText ("DWT.BORDER");
        noBackgroundButton = new Button (styleGroup, DWT.CHECK);
        noBackgroundButton.setText ("DWT.NO_BACKGROUND");
        noFocusButton = new Button (styleGroup, DWT.CHECK);
        noFocusButton.setText ("DWT.NO_FOCUS");
        noMergePaintsButton = new Button (styleGroup, DWT.CHECK);
        noMergePaintsButton.setText ("DWT.NO_MERGE_PAINTS");
        noRedrawResizeButton = new Button (styleGroup, DWT.CHECK);
        noRedrawResizeButton.setText ("DWT.NO_REDRAW_RESIZE");
        doubleBufferedButton = new Button (styleGroup, DWT.CHECK);
        doubleBufferedButton.setText ("DWT.DOUBLE_BUFFERED");
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
        return [ cast(Widget) canvas ];
    }

    /**
     * Returns a list of set/get API method names (without the set/get prefix)
     * that can be used to set/get values in the example control(s).
     */
    char[][] getMethodNames() {
        return ["ToolTipText"];
    }

    /**
     * Gets the text for the tab folder item.
     */
    char[] getTabText () {
        return "Canvas";
    }

    /**
     * Resizes the maximum and thumb of both scrollbars.
     */
    void resizeScrollBars () {
        Rectangle clientArea = canvas.getClientArea();
        ScrollBar bar = canvas.getHorizontalBar();
        if (bar !is null) {
            bar.setMaximum(maxX);
            bar.setThumb(clientArea.width);
            bar.setPageIncrement(clientArea.width);
        }
        bar = canvas.getVerticalBar();
        if (bar !is null) {
            bar.setMaximum(maxY);
            bar.setThumb(clientArea.height);
            bar.setPageIncrement(clientArea.height);
        }
    }

    /**
     * Scrolls the canvas horizontally.
     *
     * @param scrollBar
     */
    void scrollHorizontal (ScrollBar scrollBar) {
        Rectangle bounds = canvas.getClientArea();
        int x = -scrollBar.getSelection();
        if (x + maxX < bounds.width) {
            x = bounds.width - maxX;
        }
        canvas.scroll(x, cy, cx, cy, maxX, maxY, false);
        cx = x;
    }

    /**
     * Scrolls the canvas vertically.
     *
     * @param scrollBar
     */
    void scrollVertical (ScrollBar scrollBar) {
        Rectangle bounds = canvas.getClientArea();
        int y = -scrollBar.getSelection();
        if (y + maxY < bounds.height) {
            y = bounds.height - maxY;
        }
        canvas.scroll(cx, y, cx, cy, maxX, maxY, false);
        cy = y;
    }

    /**
     * Sets or clears the caret in the "Example" widget.
     */
    void setCaret () {
        Caret oldCaret = canvas.getCaret ();
        if (caretButton.getSelection ()) {
            Caret newCaret = new Caret(canvas, DWT.NONE);
            Font font = canvas.getFont();
            newCaret.setFont(font);
            GC gc = new GC(canvas);
            gc.setFont(font);
            newCaret.setBounds(1, 1, 1, gc.getFontMetrics().getHeight());
            gc.dispose();
            canvas.setCaret (newCaret);
            canvas.setFocus();
        } else {
            canvas.setCaret (null);
        }
        if (oldCaret !is null) oldCaret.dispose ();
    }

    /**
     * Sets the state of the "Example" widgets.
     */
    void setExampleWidgetState () {
        super.setExampleWidgetState ();
        horizontalButton.setSelection ((canvas.getStyle () & DWT.H_SCROLL) !is 0);
        verticalButton.setSelection ((canvas.getStyle () & DWT.V_SCROLL) !is 0);
        borderButton.setSelection ((canvas.getStyle () & DWT.BORDER) !is 0);
        noBackgroundButton.setSelection ((canvas.getStyle () & DWT.NO_BACKGROUND) !is 0);
        noFocusButton.setSelection ((canvas.getStyle () & DWT.NO_FOCUS) !is 0);
        noMergePaintsButton.setSelection ((canvas.getStyle () & DWT.NO_MERGE_PAINTS) !is 0);
        noRedrawResizeButton.setSelection ((canvas.getStyle () & DWT.NO_REDRAW_RESIZE) !is 0);
        doubleBufferedButton.setSelection ((canvas.getStyle () & DWT.DOUBLE_BUFFERED) !is 0);
        if (!instance.startup) setCaret ();
    }
}
