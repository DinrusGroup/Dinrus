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
module jface.snippets.Snippet040TableViewerSorting;

// http://dev.eclipse.org/viewcvs/index.cgi/org.eclipse.jface.snippets/Eclipse%20JFace%20Snippets/org/eclipse/jface/snippets/viewers/Snippet040TableViewerSorting.java?view=markup

import dwtx.jface.viewers.CellEditor;
import dwtx.jface.viewers.ColumnLabelProvider;
import dwtx.jface.viewers.ColumnViewer;
import dwtx.jface.viewers.EditingSupport;
import dwtx.jface.viewers.IStructuredContentProvider;
import dwtx.jface.viewers.TableViewer;
import dwtx.jface.viewers.TableViewerColumn;
import dwtx.jface.viewers.TextCellEditor;
import dwtx.jface.viewers.Viewer;
import dwtx.jface.viewers.ViewerComparator;
import dwt.DWT;
import dwt.events.SelectionAdapter;
import dwt.events.SelectionEvent;
import dwt.layout.FillLayout;
import dwt.widgets.Display;
import dwt.widgets.Shell;
import dwt.dwthelper.utils;

/**
 * Example usage of ViewerComparator in tables to allow sorting
 *
 * @author Tom Schindl <tom.schindl@bestsolution.at>
 *
 */

void main(String[] args) {
    Snippet040TableViewerSorting.main(args);
}

    private class MyContentProvider : IStructuredContentProvider {

        public Object[] getElements(Object inputElement) {
            return (cast(ArrayWrapperT!(Person)) inputElement).array;
        }

        public void dispose() {
        }

        public void inputChanged(Viewer viewer, Object oldInput, Object newInput) {
        }

    }

    public class Person {
        public String givenname;
        public String surname;
        public String email;

        public this(String givenname, String surname, String email) {
            this.givenname = givenname;
            this.surname = surname;
            this.email = email;
        }

    }

    protected abstract class AbstractEditingSupport : EditingSupport {
        private TextCellEditor editor;

        public this(TableViewer viewer) {
            super(viewer);
            this.editor = new TextCellEditor(viewer.getTable());
        }

        protected bool canEdit(Object element) {
            return true;
        }

        protected CellEditor getCellEditor(Object element) {
            return editor;
        }

        protected void setValue(Object element, Object value) {
            doSetValue(element, value);
            getViewer().update(element, null);
        }

        protected abstract void doSetValue(Object element, Object value);
    }

    private abstract class ColumnViewerSorter : ViewerComparator {
        public static final int ASC = 1;

        public static final int NONE = 0;

        public static final int DESC = -1;

        private int direction = 0;

        private TableViewerColumn column;

        private ColumnViewer viewer;

        public this(ColumnViewer viewer_, TableViewerColumn column_) {
            this.column = column_;
            this.viewer = viewer_;
            this.column.getColumn().addSelectionListener(new class() SelectionAdapter {
                public void widgetSelected(SelectionEvent e) {
                    this.outer.widgetSelected(e);
                }
            });
        }

        private void widgetSelected(SelectionEvent e){
            if( viewer.getComparator() !is null ) {
                if( viewer.getComparator() is this ) {
                    int tdirection = direction;

                    if( tdirection is ASC ) {
                        setSorter(this, DESC);
                    } else if( tdirection is DESC ) {
                        setSorter(this, NONE);
                    }
                } else {
                    setSorter(this, ASC);
                }
            } else {
                setSorter(this, ASC);
            }
        }
        public void setSorter(ColumnViewerSorter sorter, int direction) {
            if( direction is NONE ) {
                column.getColumn().getParent().setSortColumn(null);
                column.getColumn().getParent().setSortDirection(DWT.NONE);
                viewer.setComparator(null);
            } else {
                column.getColumn().getParent().setSortColumn(column.getColumn());
                sorter.direction = direction;

                if( direction is ASC ) {
                    column.getColumn().getParent().setSortDirection(DWT.DOWN);
                } else {
                    column.getColumn().getParent().setSortDirection(DWT.UP);
                }

                if( viewer.getComparator() is sorter ) {
                    viewer.refresh();
                } else {
                    viewer.setComparator(sorter);
                }

            }
        }

        public int compare(Viewer viewer, Object e1, Object e2) {
            return direction * doCompare(viewer, e1, e2);
        }

        protected abstract int doCompare(Viewer viewer, Object e1, Object e2);
    }

public class Snippet040TableViewerSorting {


    public this(Shell shell) {
        TableViewer v = new TableViewer(shell, DWT.BORDER | DWT.FULL_SELECTION);
        v.setContentProvider(new MyContentProvider());

        TableViewerColumn column = new TableViewerColumn(v, DWT.NONE);
        column.getColumn().setWidth(200);
        column.getColumn().setText("Givenname");
        column.getColumn().setMoveable(true);
        column.setLabelProvider(new class() ColumnLabelProvider {
            public String getText(Object element) {
                return (cast(Person) element).givenname;
            }
        });

        column.setEditingSupport(new class(v) AbstractEditingSupport {
            public this(TableViewer t ){
                super(t);
            }
            protected Object getValue(Object element) {
                return new ArrayWrapperString((cast(Person) element).givenname);
            }
            protected void doSetValue(Object element, Object value) {
                (cast(Person) element).givenname = stringcast(value);
            }
        });

        ColumnViewerSorter cSorter = new class(v,column) ColumnViewerSorter {
            this(TableViewer t, TableViewerColumn c ){
                super(t,c);
            }
            protected int doCompare(Viewer viewer, Object e1, Object e2) {
                Person p1 = cast(Person) e1;
                Person p2 = cast(Person) e2;
                return p1.givenname.compareToIgnoreCase(p2.givenname);
            }
        };

        column = new TableViewerColumn(v, DWT.NONE);
        column.getColumn().setWidth(200);
        column.getColumn().setText("Surname");
        column.getColumn().setMoveable(true);
        column.setLabelProvider(new class() ColumnLabelProvider {
            public String getText(Object element) {
                return (cast(Person) element).surname;
            }
        });

        column.setEditingSupport(new class(v) AbstractEditingSupport {
            this(TableViewer t ){
                super(t);
            }
            protected Object getValue(Object element) {
                return stringcast((cast(Person) element).surname);
            }
            protected void doSetValue(Object element, Object value) {
                (cast(Person) element).surname = stringcast(value);
            }
        });

        new class(v,column) ColumnViewerSorter {
            this(TableViewer t, TableViewerColumn c ){
                super(t,c);
            }
            protected int doCompare(Viewer viewer, Object e1, Object e2) {
                Person p1 = cast(Person) e1;
                Person p2 = cast(Person) e2;
                return p1.surname.compareToIgnoreCase(p2.surname);
            }
        };

        column = new TableViewerColumn(v, DWT.NONE);
        column.getColumn().setWidth(200);
        column.getColumn().setText("E-Mail");
        column.getColumn().setMoveable(true);
        column.setLabelProvider(new class() ColumnLabelProvider {
            public String getText(Object element) {
                return (cast(Person) element).email;
            }
        });

        column.setEditingSupport(new class(v) AbstractEditingSupport {
            this(TableViewer t ){
                super(t);
            }
            protected Object getValue(Object element) {
                return stringcast((cast(Person) element).email);
            }
            protected void doSetValue(Object element, Object value) {
                (cast(Person) element).email = stringcast(value);
            }
        });
        new class(v,column) ColumnViewerSorter {
            this(TableViewer t, TableViewerColumn c ){
                super(t,c);
            }
            protected int doCompare(Viewer viewer, Object e1, Object e2) {
                Person p1 = cast(Person) e1;
                Person p2 = cast(Person) e2;
                return p1.email.compareToIgnoreCase(p2.email);
            }
        };

        Person[] model = createModel();
        v.setInput( new ArrayWrapperT!(Person)(model));
        v.getTable().setLinesVisible(true);
        v.getTable().setHeaderVisible(true);
        cSorter.setSorter(cSorter, ColumnViewerSorter.ASC);
    }

    private Person[] createModel() {
        Person[] elements = new Person[4];
        elements[0] = new Person("Tom", "Schindl",
                "tom.schindl@bestsolution.at");
        elements[1] = new Person("Boris", "Bokowski",
                "Boris_Bokowski@ca.ibm.com");
        elements[2] = new Person("Tod", "Creasey", "Tod_Creasey@ca.ibm.com");
        elements[3] = new Person("Wayne", "Beaton", "wayne@eclipse.org");

        return elements;
    }

    /**
     * @param args
     */
    public static void main(String[] args) {
        Display display = new Display();

        Shell shell = new Shell(display);
        shell.setLayout(new FillLayout());
        new Snippet040TableViewerSorting(shell);
        shell.open();

        while (!shell.isDisposed()) {
            if (!display.readAndDispatch())
                display.sleep();
        }
        display.dispose();
    }

}
