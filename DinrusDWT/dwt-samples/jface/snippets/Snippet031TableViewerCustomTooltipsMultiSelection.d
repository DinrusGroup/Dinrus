/*******************************************************************************
 * Copyright (c) 2007 Adam Neal and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Adam Neal - initial API and implementation
 * Port to the D programming language:
 *     yidabu at gmail dot com  ( D China http://www.d-programming-language-china.org/ ) 
 *******************************************************************************/

module jface.snippets.Snippet031TableViewerCustomTooltipsMultiSelection;

// http://dev.eclipse.org/viewcvs/index.cgi/org.eclipse.jface.snippets/Eclipse%20JFace%20Snippets/org/eclipse/jface/snippets/viewers/Snippet031TableViewerCustomTooltipsMultiSelection.java?view=markup

import tango.util.collection.ArrayBag;
alias ArrayBag!(MyModel) ArrayList;
import tango.util.Convert;

import dwtx.jface.viewers.ArrayContentProvider;
import dwtx.jface.viewers.ILabelProviderListener;
import dwtx.jface.viewers.ITableLabelProvider;
import dwtx.jface.viewers.TableViewer;
import dwt.DWT;
import dwt.graphics.Image;
import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwt.layout.FillLayout;
import dwt.widgets.Display;
import dwt.widgets.Event;
import dwt.widgets.Label;
import dwt.widgets.Listener;
import dwt.widgets.Shell;
import dwt.widgets.Table;
import dwt.widgets.TableColumn;
import dwt.widgets.TableItem;
import dwt.dwthelper.System;
import dwt.widgets.Listener;

alias char[] String;
void main(String[] args)
{
    Snippet031TableViewerCustomTooltipsMultiSelection.main(args);
}

/**
 * A simple TableViewer to demonstrate how custom tooltips could be created easily while preserving 
 * the multiple selection.
 * 
 * This is a modified example taken from Tom Schindl's Snippet023TreeViewerCustomTooltips.java
 * 
 * This code is for users pre 3.3 others could use newly added tooltip support in {@link CellLabelProvider}
 * @author Adam Neal <Adam_Neal@ca.ibm.com>
 * 
 */
public class Snippet031TableViewerCustomTooltipsMultiSelection {
    public class MyLableProvider : ITableLabelProvider {

        public Image getColumnImage(Object element, int columnIndex) {
            return null;
        }

        public String getColumnText(Object element, int columnIndex) {
            //if (element instanceof MyModel) {            
                switch (columnIndex) {
                    case 0: return (cast(MyModel)element).col1;
                    case 1: return (cast(MyModel)element).col2;
                }
            //}

            return "";
        }

        public void addListener(ILabelProviderListener listener) {
            /* Ignore */
        }

        public void dispose() {
            /* Ignore */
        }

        public bool isLabelProperty(Object element, String property) {
            return false;
        }

        public void removeListener(ILabelProviderListener listener) {
            /* Ignore */
        }

    }



    public this(Shell shell) {


        final Table table = new Table(shell, DWT.H_SCROLL | DWT.V_SCROLL | DWT.MULTI | DWT.FULL_SELECTION);
        table.setHeaderVisible(true);
        table.setLinesVisible(true);

        final TableViewer v = new TableViewer(table);
        TableColumn tableColumn1 = new TableColumn(table, DWT.NONE);
        TableColumn tableColumn2 = new TableColumn(table, DWT.NONE);

        String column1 = "Column 1", column2 = "Column 2";
        /* Setup the table  columns */
        tableColumn1.setText(column1);
        tableColumn2.setText(column2);
        tableColumn1.pack();
        tableColumn2.pack();

        v.setColumnProperties([ column1, column2 ]);
        v.setLabelProvider(new MyLableProvider());
        v.setContentProvider(new ArrayContentProvider!(MyModel));
        v.setInput(createModel());

        tooltipLabelListener = new TooltipLabelListener();

        /**
         * The listener that gets added to the table.  This listener is responsible for creating the tooltips
         * when hovering over a cell item. This listener will listen for the following events:
         *  <li>DWT.KeyDown     - to remove the tooltip</li>
         *  <li>DWT.Dispose     - to remove the tooltip</li>
         *  <li>DWT.MouseMove   - to remove the tooltip</li>
         *  <li>DWT.MouseHover  - to set the tooltip</li>
         */

        Listener tableListener = dgListener(&handleTableListener, table);

        table.addListener (DWT.Dispose, tableListener);
        table.addListener (DWT.KeyDown, tableListener);
        table.addListener (DWT.MouseMove, tableListener);
        table.addListener (DWT.MouseHover, tableListener);
    }

    void handleTableListener(Event event, Table table)
    {
        Shell tooltip = null;
        Label label = null;

        /*
         * (non-Javadoc)
         * @see dwt.widgets.Listener#handleEvent(dwt.widgets.Event)
         */
       switch (event.type) {
            case DWT.KeyDown:
            case DWT.Dispose:
            case DWT.MouseMove: {
                if (tooltip is null) break;
                tooltip.dispose ();
                tooltip = null;
                label = null;
                break;
            }
            case DWT.MouseHover: {
                Point coords = new Point(event.x, event.y);
                TableItem item = table.getItem(coords);
                if (item !is null) {
                    int columnCount = table.getColumnCount();
                    for (int columnIndex = 0; columnIndex < columnCount; columnIndex++) {
                        if (item.getBounds(columnIndex).contains(coords)) {
                            /* Dispose of the old tooltip (if one exists */
                            if (tooltip !is null  && !tooltip.isDisposed ()) tooltip.dispose ();

                            /* Create a new Tooltip */
                            tooltip = new Shell (table.getShell(), DWT.ON_TOP | DWT.NO_FOCUS | DWT.TOOL);
                            tooltip.setBackground (table.getDisplay().getSystemColor (DWT.COLOR_INFO_BACKGROUND));
                            FillLayout layout = new FillLayout ();
                            layout.marginWidth = 2;
                            tooltip.setLayout (layout);
                            label = new Label (tooltip, DWT.NONE);
                            label.setForeground (table.getDisplay().getSystemColor (DWT.COLOR_INFO_FOREGROUND));
                            label.setBackground (table.getDisplay().getSystemColor (DWT.COLOR_INFO_BACKGROUND));

                            /* Store the TableItem with the label so we can pass the mouse event later */
                            label.setData ("_TableItem_", item);

                            /* Set the tooltip text */
                            label.setText("Tooltip: " ~ to!(char[])(item.getData()) ~ " : " ~ to!(char[])(columnIndex));

                            /* Setup Listeners to remove the tooltip and transfer the received mouse events */
                            label.addListener (DWT.MouseExit, tooltipLabelListener);
                            label.addListener (DWT.MouseDown, tooltipLabelListener);

                            /* Set the size and position of the tooltip */
                            Point size = tooltip.computeSize (DWT.DEFAULT, DWT.DEFAULT);
                            Rectangle rect = item.getBounds (columnIndex);
                            Point pt = table.toDisplay (rect.x, rect.y);
                            tooltip.setBounds (pt.x, pt.y, size.x, size.y);

                            /* Show it */
                            tooltip.setVisible (true);
                            break;
                        }
                    }
                }
            }
        }
    }

    /**
     * This listener is added to the tooltip so that it can either dispose itself if the mouse
     * exits the tooltip or so it can pass the selection event through to the table.
     */
    final TooltipLabelListener tooltipLabelListener;
    final class TooltipLabelListener : Listener {
        private bool isCTRLDown(Event e) {
            return (e.stateMask & DWT.CTRL) != 0;
        }
       /*
        * (non-Javadoc)
        * @see dwt.widgets.Listener#handleEvent(dwt.widgets.Event)
        */
       public void handleEvent (Event event) {
           Label label = cast(Label)event.widget;
           Shell shell = label.getShell ();
           switch (event.type) {
                case DWT.MouseDown: /* Handle a user Click */
                    /* Extract our Data */
                    Event e = new Event ();
                    e.item = cast(TableItem) label.getData ("_TableItem_");
                    Table table = (cast(TableItem) e.item).getParent();

                    /* Construct the new Selection[] to show */
                    TableItem [] newSelection = null;
                    if (isCTRLDown(event)) {
                        /* We have 2 scenario's.  
                         *  1) We are selecting an already selected element - so remove it from the selected indices
                         *  2) We are selecting a non-selected element - so add it to the selected indices
                         */
                        TableItem[] sel = table.getSelection();
                        for (int i = 0; i < sel.length; ++i) {
                            //if (e.item.equals(sel[i])) {
                            if (e.item is sel[i]) {
                                // We are de-selecting this element
                                newSelection = new TableItem[sel.length - 1];
                                System.arraycopy(sel, 0, newSelection, 0, i);
                                System.arraycopy(sel, i+1, newSelection, i, sel.length - i - 1);
                                break;
                            }
                        }

                        /*
                         * If we haven't created the newSelection[] yet, than we are adding the newly selected element
                         * into the list of selected indicies
                         */
                        if (newSelection is null) {
                            newSelection = new TableItem[sel.length + 1];
                            System.arraycopy(sel, 0, newSelection, 0, sel.length);
                            newSelection[sel.length] = cast(TableItem) e.item;
                        }

                    } else {
                        /* CTRL is not down, so we simply select the single element */
                        newSelection = [ cast(TableItem) e.item ];
                    }
                    /* Set the new selection of the table and notify the listeners */
                    table.setSelection (newSelection);
                    table.notifyListeners (DWT.Selection, e);

                    /* Remove the Tooltip */
                    shell.dispose ();
                    table.setFocus();
                    break;
                case DWT.MouseExit:
                    shell.dispose ();
                    break;
            }
        }
    }


    private ArrayList createModel() {
        ArrayList list = new ArrayList;
        list.add(new MyModel("A", "B"));
        list.add(new MyModel("C", "D"));
        list.add(new MyModel("E", "F"));
        return list;
    }

    public static void main(String[] args) {
        Display display = new Display();
        Shell shell = new Shell(display);
        shell.setLayout(new FillLayout());
        new Snippet031TableViewerCustomTooltipsMultiSelection(shell);
        shell.open();

        while (!shell.isDisposed()) {
            if (!display.readAndDispatch())
                display.sleep();
        }

        display.dispose();
    }
}

public class MyModel {
    public String col1, col2;

    public this(String c1, String c2) {
        col1 = c1;
        col2 = c2;
    }

    public String toString() {
        return col1 ~ col2;
    }
}

