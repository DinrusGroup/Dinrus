/*******************************************************************************
 * Copyright (c) 2000, 2004 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 * D Port:
 *     Thomas Demmer <t_demmer AT web DOT de>
 *******************************************************************************/
module button.Snippet162;

/*
 * Adding an accessible listener to provide state information
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 */
import dwt.DWT;
import dwt.accessibility.ACC;
import dwt.accessibility.Accessible;
import dwt.accessibility.AccessibleAdapter;
import dwt.accessibility.AccessibleControlListener;
import dwt.accessibility.AccessibleControlAdapter;
import dwt.accessibility.AccessibleControlEvent;
import dwt.accessibility.AccessibleEvent;
import dwt.graphics.GC;
import dwt.graphics.Image;
import dwt.graphics.Point;

import dwt.layout.FillLayout;
import dwt.widgets.Display;
import dwt.widgets.Shell;
import dwt.widgets.Table;
import dwt.widgets.TableColumn;
import dwt.widgets.TableItem;

import dwt.dwthelper.utils;


void main(String[] args){
    Snippet162.main(args);
}

public class Snippet162 {

    final static String STATE = "CheckedIndices";

    public static void main (String [] args) {
        final Display display = new Display ();
        Image checkedImage = getCheckedImage (display);
        Image uncheckedImage = getUncheckedImage (display);
        Shell shell = new Shell (display);
        shell.setLayout (new FillLayout ());
        final Table table = new Table (shell, DWT.BORDER);
        TableColumn column1 = new TableColumn (table, DWT.NONE);
        TableColumn column2 = new TableColumn (table, DWT.NONE);
        TableColumn column3 = new TableColumn (table, DWT.NONE);
        TableItem item1 = new TableItem (table, DWT.NONE);
        item1.setText ( ["first item", "a", "b"]);
        item1.setImage (1, uncheckedImage);
        item1.setImage (2, uncheckedImage);
        item1.setData (STATE, null);
        TableItem item2 = new TableItem (table, DWT.NONE);
        item2.setText ( ["second item", "c", "d"]);
        item2.setImage (1, uncheckedImage);
        item2.setImage (2, checkedImage);
        item2.setData (STATE,  new ArrayWrapperInt([2]));
        TableItem item3 = new TableItem (table, DWT.NONE);
        item3.setText ( ["third", "e", "f"]);
        item3.setImage (1, checkedImage);
        item3.setImage (2, checkedImage);
        item3.setData (STATE, new ArrayWrapperInt( [1, 2]));
        column1.pack ();
        column2.pack ();
        column3.pack ();

        Accessible accessible = table.getAccessible ();
        accessible.addAccessibleListener( new class() AccessibleAdapter  {
            public void getName (AccessibleEvent e) {
                super.getName (e);
                if (e.childID >= 0 && e.childID < table.getItemCount ()) {
                    TableItem item = table.getItem (e.childID);
                    Point pt = display.getCursorLocation ();
                    pt = display.map (null, table, pt);
                    for (int i = 0; i < table.getColumnCount (); i++) {
                        if (item.getBounds (i).contains (pt)) {
                            int [] data = (cast(ArrayWrapperInt)item.getData (STATE)).array;
                            bool checked = false;
                            if (data !is null) {
                                for (int j = 0; j < data.length; j++) {
                                    if (data [j] == i) {
                                        checked = true;
                                        break;
                                    }
                                }
                            }
                            e.result = item.getText (i) ~ " " ~ (checked ? "checked" : "unchecked");
                            break;
                        }
                    }
                }
            }
        });

        accessible.addAccessibleControlListener (new class() AccessibleControlAdapter  {
            public void getState (AccessibleControlEvent e) {
                super.getState (e);
                if (e.childID >= 0 && e.childID < table.getItemCount ()) {
                    TableItem item = table.getItem (e.childID);
                    int [] data =(cast(ArrayWrapperInt)item.getData (STATE)).array;
                    if (data !is null) {
                        Point pt = display.getCursorLocation ();
                        pt = display.map (null, table, pt);
                        for (int i = 0; i < data.length; i++) {
                            if (item.getBounds (data [i]).contains (pt)) {
                                e.detail |= ACC.STATE_CHECKED;
                                break;
                            }
                        }
                    }
                }
            }
        });
        shell.open ();
        while (!shell.isDisposed ()) {
            if (!display.readAndDispatch ()) display.sleep ();
        }
        checkedImage.dispose ();
        uncheckedImage.dispose ();
        display.dispose ();
    }

    static Image getCheckedImage (Display display) {
        Image image = new Image (display, 16, 16);
        GC gc = new GC (image);
        gc.setBackground (display.getSystemColor (DWT.COLOR_YELLOW));
        gc.fillOval (0, 0, 16, 16);
        gc.setForeground (display.getSystemColor (DWT.COLOR_DARK_GREEN));
        gc.drawLine (0, 0, 16, 16);
        gc.drawLine (16, 0, 0, 16);
        gc.dispose ();
        return image;
    }

    static Image getUncheckedImage (Display display) {
        Image image = new Image (display, 16, 16);
        GC gc = new GC (image);
        gc.setBackground (display.getSystemColor (DWT.COLOR_YELLOW));
        gc.fillOval (0, 0, 16, 16);
        gc.dispose ();
        return image;
    }
}
