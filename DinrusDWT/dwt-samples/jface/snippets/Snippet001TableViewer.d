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

module jface.snippets.Snippet001TableViewer;

import dwtx.jface.viewers.IStructuredContentProvider;
import dwtx.jface.viewers.LabelProvider;
import dwtx.jface.viewers.TableViewer;
import dwtx.jface.viewers.Viewer;
import dwt.layout.FillLayout;
import dwt.widgets.Display;
import dwt.widgets.Shell;
import dwt.DWT;

import dwt.dwthelper.utils;

import tango.util.Convert;
import tango.util.collection.ArraySeq;

/**
 * A simple TableViewer to demonstrate usage
 * 
 * @author Tom Schindl <tom.schindl@bestsolution.at>
 *
 */
public class Snippet001TableViewer {
	private class MyContentProvider : IStructuredContentProvider {

		/* (non-Javadoc)
		 * @see org.eclipse.jface.viewers.IStructuredContentProvider#getElements(java.lang.Object)
		 */
		public Object[] getElements(Object inputElement) {
			return (cast(ArraySeq!(MyModel))inputElement).toArray;
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
		final TableViewer v = new TableViewer(shell);
		v.setLabelProvider(new LabelProvider());
		v.setContentProvider(new MyContentProvider());
		ArraySeq!(MyModel) model = createModel();
		v.setInput(model);
		v.getTable().setLinesVisible(true);
	}
	
	private ArraySeq!(MyModel) createModel() {
		ArraySeq!(MyModel) elements = new ArraySeq!(MyModel);
        elements.capacity  = 10;

		for( int i = 0; i < 10; i++ ) {
			elements ~= new MyModel(i);
		}
		
		return elements;
	}
	
}

void main() 
{
    Display display = new Display ();
    Shell shell = new Shell(display);
    shell.setLayout(new FillLayout());
    new Snippet001TableViewer(shell);
    shell.open ();
		
    while (!shell.isDisposed ()) {
        if (!display.readAndDispatch ()) display.sleep ();
    }
		
    display.dispose ();

}

