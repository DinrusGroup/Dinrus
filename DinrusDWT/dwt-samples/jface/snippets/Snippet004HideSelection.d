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
 *     wbaxter at gmail dot com
 *******************************************************************************/

module jface.snippets.Snippet004HideSelection;

import dwtx.jface.viewers.IStructuredContentProvider;
import dwtx.jface.viewers.LabelProvider;
import dwtx.jface.viewers.StructuredSelection;
import dwtx.jface.viewers.TableViewer;
import dwtx.jface.viewers.Viewer;
import dwt.DWT;
import dwt.events.MouseAdapter;
import dwt.events.MouseEvent;
import dwt.graphics.Point;
import dwt.layout.FillLayout;
import dwt.widgets.Display;
import dwt.widgets.Shell;

import dwt.dwthelper.utils;

import tango.util.Convert;
import tango.util.collection.ArraySeq;

/**
 * Snippet that hides the selection when nothing is selected.
 * 
 * @author Tom Schindl <tom.schindl@bestsolution.at>
 *
 */
public class Snippet004HideSelection {
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
		MyModelArray model = createModel();
		v.setInput(model);
		v.getTable().setLinesVisible(true);
		v.getTable().addMouseListener(new class(v) MouseAdapter {
            private TableViewer v;
            this(TableViewer v_) {
                this.v = v_;
            }

			/* (non-Javadoc)
			 * @see org.eclipse.swt.events.MouseAdapter#mouseDown(org.eclipse.swt.events.MouseEvent)
			 */
			public void mouseDown(MouseEvent e) {
				if( v.getTable().getItem(new Point(e.x,e.y)) is null ) {
					v.setSelection(new StructuredSelection());
				}
			}
			
		});
	}
	
	private MyModelArray createModel() {
		MyModelArray elements = new MyModelArray;
        elements.capacity = 10;
		for( int i = 0; i < 10; i++ ) {
			elements ~= new MyModel(i);
		}
		
		return elements;
	}

}

static void main() {
    Display display = new Display ();
    Shell shell = new Shell(display);
    shell.setLayout(new FillLayout());
    new Snippet004HideSelection(shell);
    shell.open ();
		
    while (!shell.isDisposed ()) {
        if (!display.readAndDispatch ()) display.sleep ();
    }
		
    display.dispose ();

}

