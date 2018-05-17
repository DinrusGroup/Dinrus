/*******************************************************************************
 * Copyright (c) 2008 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 ******************************************************************************/

module dwtx.jface.internal.ConfigureColumnsDialog;


import dwt.DWT;
import dwt.graphics.Image;
import dwt.widgets.Button;
import dwt.widgets.Composite;
import dwt.widgets.Control;
import dwt.widgets.Event;
import dwt.widgets.Item;
import dwt.widgets.Label;
import dwt.widgets.Listener;
import dwt.widgets.Table;
import dwt.widgets.TableColumn;
import dwt.widgets.TableItem;
import dwt.widgets.Text;
import dwt.widgets.Tree;
import dwt.widgets.TreeColumn;
import dwtx.jface.dialogs.Dialog;
import dwtx.jface.layout.GridDataFactory;
import dwtx.jface.layout.GridLayoutFactory;
import dwtx.jface.resource.JFaceResources;
import dwtx.jface.window.IShellProvider;

import dwt.dwthelper.utils;

/**
 * NON-API - This class is internal and will be moved to another package in 3.5.
 *
 */
public class ConfigureColumnsDialog : Dialog {

    private Control targetControl;
    private ColumnObject[] columnObjects;
    private Table table;
    private Button upButton;
    private Button downButton;
    private Text text;
    private bool moveableColumnsFound;

    class ColumnObject {
        Item column;
        int index;
        String name;
        Image image;
        bool visible;
        int width;
        bool moveable;
        bool resizable;

        this(Item column, int index, String text, Image image,
                int width, bool moveable, bool resizable, bool visible) {
            this.column = column;
            this.index = index;
            this.name = text;
            this.image = image;
            this.width = width;
            this.moveable = moveable;
            this.resizable = resizable;
            this.visible = visible;
        }
    }

    /**
     * NON-API - This class is internal and will be moved to another package in
     * 3.5. Creates a new dialog for configuring columns of the given column
     * viewer. The column viewer must have an underlying {@link Tree} or {@link
     * Table}, other controls are not supported.
     *
     * @param shellProvider
     * @param table
     */
    public this(IShellProvider shellProvider, Table table) {
        this(shellProvider, cast(Control) table);
    }

    /**
     * NON-API - This class is internal and will be moved to another package in
     * 3.5. Creates a new dialog for configuring columns of the given column
     * viewer. The column viewer must have an underlying {@link Tree} or {@link
     * Table}, other controls are not supported.
     *
     * @param shellProvider
     * @param tree
     */
    public this(IShellProvider shellProvider, Tree tree) {
        this(shellProvider, cast(Control) tree);
    }

    /**
     * @param shellProvider
     * @param control
     */
    private this(IShellProvider shellProvider, Control control) {
        super(shellProvider);
        this.targetControl = control;
        this.moveableColumnsFound = createColumnObjects();
    }

    protected bool isResizable() {
        return true;
    }

    public void create() {
        super.create();
        getShell().setText(
                JFaceResources.getString("ConfigureColumnsDialog_Title")); //$NON-NLS-1$
    }

    protected void initializeBounds() {
        super.initializeBounds();
        table.setSelection(0);
        handleSelectionChanged(0);
    }

    /**
     * Returns true if any of the columns is moveable (can be reordered).
     */
    private bool createColumnObjects() {
        bool result = true;
        Item[] columns = getViewerColumns();
        ColumnObject[] cObjects = new ColumnObject[columns.length];
        for (int i = 0; i < columns.length; i++) {
            Item c = columns[i];
            bool moveable = getMoveable(c);
            result = result && moveable;
            cObjects[i] = new ColumnObject(c, i, getColumnName(c),
                    getColumnImage(c), getColumnWidth(c), moveable,
                    getResizable(c), true);
        }
        int[] columnOrder = getColumnOrder();
        columnObjects = new ColumnObject[columns.length];
        for (int i = 0; i < columnOrder.length; i++) {
            columnObjects[i] = cObjects[columnOrder[i]];
        }
        return result;
    }

    /**
     * @param c
     * @return
     */
    private Image getColumnImage(Item item) {
        if (null !is cast(TableColumn)item ) {
            return (cast(TableColumn) item).getImage();
        } else if (null !is cast(TreeColumn)item ) {
            return (cast(TreeColumn) item).getImage();
        }
        return null;
    }

    /**
     * @return
     */
    private int[] getColumnOrder() {
        if (null !is cast(Table)targetControl ) {
            return (cast(Table) targetControl).getColumnOrder();
        } else if (null !is cast(Tree)targetControl ) {
            return (cast(Tree) targetControl).getColumnOrder();
        }
        return new int[0];
    }

    /**
     * @param c
     * @return
     */
    private bool getMoveable(Item item) {
        if (null !is cast(TableColumn)item ) {
            return (cast(TableColumn) item).getMoveable();
        } else if (null !is cast(TreeColumn)item ) {
            return (cast(TreeColumn) item).getMoveable();
        }
        return false;
    }

    /**
     * @param c
     * @return
     */
    private bool getResizable(Item item) {
        if (null !is cast(TableColumn)item ) {
            return (cast(TableColumn) item).getResizable();
        } else if (null !is cast(TreeColumn)item ) {
            return (cast(TreeColumn) item).getResizable();
        }
        return false;
    }

    protected Control createDialogArea(Composite parent) {
        Composite composite = cast(Composite) super.createDialogArea(parent);

        table = new Table(composite, DWT.BORDER | DWT.SINGLE | DWT.V_SCROLL
                | DWT.H_SCROLL /*
                                                     * | DWT.CHECK
                                                     */);
        for (int i = 0; i < columnObjects.length; i++) {
            TableItem tableItem = new TableItem(table, DWT.NONE);
            tableItem.setText(columnObjects[i].name);
            tableItem.setImage(columnObjects[i].image);
            tableItem.setData(columnObjects[i]);
        }

        GridDataFactory.defaultsFor(table)
                .span(1, moveableColumnsFound ? 3 : 1).applyTo(table);

        if (moveableColumnsFound) {
            upButton = new Button(composite, DWT.PUSH);
            upButton.setText(JFaceResources
                    .getString("ConfigureColumnsDialog_up")); //$NON-NLS-1$
            upButton.addListener(DWT.Selection, new class Listener {
                public void handleEvent(Event event) {
                    handleMove(table, true);
                }
            });
            setButtonLayoutData(upButton);
            downButton = new Button(composite, DWT.PUSH);
            downButton.setText(JFaceResources
                    .getString("ConfigureColumnsDialog_down")); //$NON-NLS-1$
            downButton.addListener(DWT.Selection, new class Listener {
                public void handleEvent(Event event) {
                    handleMove(table, false);
                }
            });
            setButtonLayoutData(downButton);

            // filler label
            createLabel(composite, ""); //$NON-NLS-1$
        }

        Composite widthComposite = new Composite(composite, DWT.NONE);
        createLabel(widthComposite, JFaceResources
                .getString("ConfigureColumnsDialog_WidthOfSelectedColumn")); //$NON-NLS-1$

        text = new Text(widthComposite, DWT.SINGLE | DWT.BORDER);
        // see #initializeBounds
        text.setText(Integer.toString(1000));

        GridLayoutFactory.fillDefaults().numColumns(2).applyTo(widthComposite);

        int numColumns = moveableColumnsFound ? 2 : 1;

        GridDataFactory.defaultsFor(widthComposite).grab(false, false).span(
                numColumns, 1).applyTo(widthComposite);

        GridLayoutFactory.swtDefaults().numColumns(numColumns).applyTo(
                composite);

        table.addListener(DWT.Selection, new class Listener {
            public void handleEvent(Event event) {
                handleSelectionChanged(table.indexOf(cast(TableItem) event.item));
            }
        });
        text.addListener(DWT.Modify, new class Listener {
            public void handleEvent(Event event) {
                ColumnObject columnObject = columnObjects[table
                        .getSelectionIndex()];
                if (!columnObject.resizable) {
                    return;
                }
                try {
                    int width = Integer.parseInt(text.getText());
                    columnObject.width = width;
                } catch (NumberFormatException ex) {
                    // ignore for now
                }
            }
        });

        Dialog.applyDialogFont(composite);

        return composite;
    }

    /**
     * @param table
     * @param up
     */
    protected void handleMove(Table table, bool up) {
        int index = table.getSelectionIndex();
        int newIndex = index + (up ? -1 : 1);
        if (index < 0 || index >= table.getItemCount()) {
            return;
        }
        ColumnObject columnObject = columnObjects[index];
        columnObjects[index] = columnObjects[newIndex];
        columnObjects[newIndex] = columnObject;
        table.getItem(index).dispose();
        TableItem newItem = new TableItem(table, DWT.NONE, newIndex);
        newItem.setText(columnObject.name);
        newItem.setImage(columnObject.image);
        newItem.setData(columnObject);
        table.setSelection(newIndex);
        handleSelectionChanged(newIndex);
    }

    private void createLabel(Composite composite, String string) {
        Label label = new Label(composite, DWT.NONE);
        label.setText(string);
    }

    /**
     * @param item
     * @return
     */
    private String getColumnName(Item item) {
        String result = ""; //$NON-NLS-1$
        if (null !is cast(TableColumn)item ) {
            result = (cast(TableColumn) item).getText();
            if (result.trim().equals("")) { //$NON-NLS-1$
                result = (cast(TableColumn) item).getToolTipText();
            }
        } else if (null !is cast(TreeColumn)item ) {
            result = (cast(TreeColumn) item).getText();
            if (result.trim().equals("")) { //$NON-NLS-1$
                result = (cast(TreeColumn) item).getToolTipText();
            }
        }
        return result;
    }

    /**
     * @param item
     * @return
     */
    private int getColumnWidth(Item item) {
        if (null !is cast(TableColumn)item ) {
            return (cast(TableColumn) item).getWidth();
        } else if (null !is cast(TreeColumn)item ) {
            return (cast(TreeColumn) item).getWidth();
        }
        return 0;
    }

    /**
     * @return
     */
    private Item[] getViewerColumns() {
        if (null !is cast(Table)targetControl ) {
            return (cast(Table) targetControl).getColumns();
        } else if (null !is cast(Tree)targetControl ) {
            return (cast(Tree) targetControl).getColumns();
        }
        return new Item[0];
    }

    private void handleSelectionChanged(int index) {
        ColumnObject c = columnObjects[index];
        text.setText(Integer.toString(c.width));
        text.setEnabled(c.resizable);
        if (moveableColumnsFound) {
            upButton.setEnabled(c.moveable && index > 0);
            downButton.setEnabled(c.moveable
                    && index + 1 < table.getItemCount());
        }
    }

    protected void okPressed() {
        int[] columnOrder = new int[columnObjects.length];
        for (int i = 0; i < columnObjects.length; i++) {
            ColumnObject columnObject = columnObjects[i];
            columnOrder[i] = columnObject.index;
            setColumnWidth(columnObject.column, columnObject.width);
        }
        setColumnOrder(columnOrder);
        super.okPressed();
    }

    /**
     * @param column
     * @param width
     */
    private void setColumnWidth(Item item, int width) {
        if (null !is cast(TableColumn)item ) {
            (cast(TableColumn) item).setWidth(width);
        } else if (null !is cast(TreeColumn)item ) {
            (cast(TreeColumn) item).setWidth(width);
        }
    }

    /**
     * @param columnOrder
     */
    private void setColumnOrder(int[] order) {
        if (null !is cast(Table)targetControl ) {
            (cast(Table) targetControl).setColumnOrder(order);
        } else if (null !is cast(Tree)targetControl ) {
            (cast(Tree) targetControl).setColumnOrder(order);
        }
    }
}
