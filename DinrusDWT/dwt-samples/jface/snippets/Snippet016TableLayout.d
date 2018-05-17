/*******************************************************************************
 * Copyright (c) 2006 Tom Schindl and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Tom Schindl - initial API and implementation
 * Port to the D programming language:
 *     yidabu at gmail dot com  ( D China http://www.d-programming-language-china.org/ )
 *******************************************************************************/

module jface.snippets.Snippet016TableLayout;


import dwtx.jface.layout.TableColumnLayout;
import dwtx.jface.viewers.ColumnWeightData;
import dwtx.jface.viewers.IStructuredContentProvider;
import dwtx.jface.viewers.ITableLabelProvider;
import dwtx.jface.viewers.LabelProvider;
import dwtx.jface.viewers.TableViewer;
import dwtx.jface.viewers.Viewer;
import dwt.DWT;
import dwt.graphics.Image;
import dwt.layout.FillLayout;
import dwt.widgets.Composite;
import dwt.widgets.Display;
import dwt.widgets.Shell;
import dwt.widgets.Table;
import dwt.widgets.TableColumn;

import dwt.dwthelper.utils;

import tango.util.Convert;
/**
 * @param args
 */
void main(String[] args) {
    Display display = new Display();
    Shell shell = new Shell(display);
    //shell.setSize(400, 150);
    shell.setLayout(new FillLayout());

    new Snippet016TableLayout(shell);
    shell.open();

    while (!shell.isDisposed()) {
        if (!display.readAndDispatch())
            display.sleep();
    }

    display.dispose();

}

/**
 * A simple TableViewer to demonstrate usage
 *
 * @author Tom Schindl <tom.schindl@bestsolution.at>
 * @since 3.3M3
 */
public class Snippet016TableLayout {
    private class MyContentProvider : IStructuredContentProvider {

        /*
         * (non-Javadoc)
         *
         * @see dwtx.jface.viewers.IStructuredContentProvider#getElements(java.lang.Object)
         */
        public Object[] getElements(Object inputElement) {
            return (cast(ArrayWrapperObject) inputElement).array;
        }

        /*
         * (non-Javadoc)
         *
         * @see dwtx.jface.viewers.IContentProvider#dispose()
         */
        public void dispose() {

        }

        /*
         * (non-Javadoc)
         *
         * @see dwtx.jface.viewers.IContentProvider#inputChanged(dwtx.jface.viewers.Viewer,
         *      java.lang.Object, java.lang.Object)
         */
        public void inputChanged(Viewer viewer, Object oldInput, Object newInput) {

        }

    }

    private class MyLabelProvider : LabelProvider, ITableLabelProvider {

        public Image getColumnImage(Object element, int columnIndex) {
            return null;
        }

        public String getColumnText(Object element, int columnIndex) {
            return to!(char[])(columnIndex) ~ " - " ~ element.toString();
        }

    }

    public class MyModel {
        public int counter;

        public this(int counter) {
            this.counter = counter;
        }

        public String toString() {
            return "Item " ~ to!(char[])(this.counter);
        }
    }

    public this(Composite comp) {
        final TableViewer v = new TableViewer(new Table(comp, DWT.BORDER));
        v.setLabelProvider(new MyLabelProvider());
        v.setContentProvider(new MyContentProvider());
        v.getTable().setHeaderVisible(true);

        TableColumnLayout ad = new TableColumnLayout();
        comp.setLayout(ad);

        TableColumn column = new TableColumn(v.getTable(), DWT.NONE);
        column.setText("Column 1");
        column.setMoveable(true);
        ad.setColumnData(column, new ColumnWeightData(90, 290));

        column = new TableColumn(v.getTable(), DWT.NONE);
        column.setText("Column 2");
        column.setMoveable(true);
        ad.setColumnData(column, new ColumnWeightData(10, 200));

        MyModel[] model = createModel();
        v.setInput(new ArrayWrapperObject(model));
        v.getTable().setLinesVisible(true);
    }

    private MyModel[] createModel() {
        MyModel[] elements = new MyModel[10];

        for (int i = 0; i < 10; i++) {
            elements[i] = new MyModel(i);
        }

        return elements;
    }



}
