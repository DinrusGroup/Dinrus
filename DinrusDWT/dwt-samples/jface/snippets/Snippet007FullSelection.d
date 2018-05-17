/*******************************************************************************
 * Copyright (c) 2006 Tom Schindl and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Tom Schindl - initial API and implementation
 *******************************************************************************/

module jface.snippets.Snippet007FullSelection;

import dwtx.jface.viewers.CellEditor;
import dwtx.jface.viewers.ICellModifier;
import dwtx.jface.viewers.IStructuredContentProvider;
import dwtx.jface.viewers.LabelProvider;
import dwtx.jface.viewers.TableViewer;
import dwtx.jface.viewers.TextCellEditor;
import dwtx.jface.viewers.Viewer;
import dwt.DWT;
import dwt.graphics.Color;
import dwt.graphics.GC;
import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwt.layout.FillLayout;
import dwt.widgets.Display;
import dwt.widgets.Event;
import dwt.widgets.Listener;
import dwt.widgets.Shell;
import dwt.widgets.TableColumn;
import dwt.widgets.TableItem;

import dwt.dwthelper.utils;

import tango.util.Convert;
import tango.util.collection.ArraySeq;

/**
 * TableViewer: Hide full selection
 * 
 * @author Tom Schindl <tom.schindl@bestsolution.at>
 *
 */
public class Snippet007FullSelection {
    alias ArraySeq!(MyModel) MyModelArray;

	private class MyContentProvider : IStructuredContentProvider {

		/* (non-Javadoc)
		 * @see org.eclipse.jface.viewers.IStructuredContentProvider#getElements(java.lang.Object)
		 */
		public Object[] getElements(Object inputElement) {
			return (cast(MyModelArray)inputElement).toArray;
		}

		/* (non-Javadoc)
		 * @see org.eclipse.jface.viewers.IContentProvider#dispose()
		 */
		public void dispose() {
			
		}

		/* (non-Javadoc)
		 * @see org.eclipse.jface.viewers.IContentProvider#inputChanged(org.eclipse.jface.viewers.Viewer, java.lang.Object, java.lang.Object)
		 */
		public void inputChanged(Viewer viewer, Object oldInput, Object newInput) {
			
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
	
	public this(Shell shell) {
		final TableViewer v = new TableViewer(shell,DWT.BORDER|DWT.FULL_SELECTION);
		v.setLabelProvider(new LabelProvider());
		v.setContentProvider(new MyContentProvider());
		v.setCellModifier(new class(v) ICellModifier {
            TableViewer v;
            this(TableViewer v_) { this.v=v_; }

			public bool canModify(Object element, String property) {
				return true;
			}

			public Object getValue(Object element, String property) {
				return new ArrayWrapperString( to!(char[])((cast(MyModel)element).counter) );
			}

			public void modify(Object element, String property, Object value) {
				auto item = cast(TableItem)element;
                auto valuestr = cast(ArrayWrapperString)value;
				(cast(MyModel)item.getData()).counter = to!(int)(valuestr.array);
				v.update(item.getData(), null);
			}
			
		});
		v.setColumnProperties(["column1", "column2" ]);
		v.setCellEditors([ new TextCellEditor(v.getTable()),new TextCellEditor(v.getTable()) ]);
		
		TableColumn column = new TableColumn(v.getTable(),DWT.NONE);
		column.setWidth(100);
		column.setText("Column 1");
		
		column = new TableColumn(v.getTable(),DWT.NONE);
		column.setWidth(100);
		column.setText("Column 2");
		
		MyModelArray model = createModel();
		v.setInput(model);
		v.getTable().setLinesVisible(true);
		v.getTable().setHeaderVisible(true);
		
		v.getTable().addListener(DWT.EraseItem, new class Listener {

			/* (non-Javadoc)
			 * @see org.eclipse.swt.widgets.Listener#handleEvent(org.eclipse.swt.widgets.Event)
			 */
			public void handleEvent(Event event) {
				event.detail &= ~DWT.SELECTED;
			}
		});
		
	}
	
	private MyModelArray createModel() {
		auto elements = new MyModelArray;
        elements.capacity = 10;
		
		for( int i = 0; i < 10; i++ ) {
			elements ~= new MyModel(i);
		}
		
		return elements;
	}
	
}


void main() {
    Display display = new Display ();
    Shell shell = new Shell(display);
    shell.setLayout(new FillLayout());
    new Snippet007FullSelection(shell);
    shell.open ();
		
    while (!shell.isDisposed ()) {
        if (!display.readAndDispatch ()) display.sleep ();
    }
		
    display.dispose ();

}

