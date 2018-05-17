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

module jface.snippets.Snippet005TreeCustomMenu;

import dwtx.jface.action.Action;
import dwtx.jface.action.IMenuListener;
import dwtx.jface.action.IMenuManager;
import dwtx.jface.action.MenuManager;
import dwtx.jface.viewers.IStructuredSelection;
import dwtx.jface.viewers.ITreeContentProvider;
import dwtx.jface.viewers.LabelProvider;
import dwtx.jface.viewers.TreeViewer;
import dwtx.jface.viewers.Viewer;
import dwt.layout.FillLayout;
import dwt.widgets.Display;
import dwt.widgets.Shell;
import dwt.DWT;

import dwt.dwthelper.utils;

import tango.util.Convert;
import tango.io.Stdout;

/**
 * Customized context menu based on TreeItem-Selection
 * 
 * @author Tom Schindl <tom.schindl@bestsolution.at>
 *
 */
public class Snippet005TreeCustomMenu {
	private class MyContentProvider : ITreeContentProvider {

		public Object[] getElements(Object inputElement) {
			return (cast(MyModel) inputElement).child;
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

		/* (non-Javadoc)
		 * @see org.eclipse.jface.viewers.ITreeContentProvider#getChildren(java.lang.Object)
		 */
		public Object[] getChildren(Object parentElement) {
			return getElements(parentElement);
		}

		/* (non-Javadoc)
		 * @see org.eclipse.jface.viewers.ITreeContentProvider#getParent(java.lang.Object)
		 */
		public Object getParent(Object element) {
			if (element is null) {
				return null;
			}

			return (cast(MyModel) element).parent;
		}

		/* (non-Javadoc)
		 * @see org.eclipse.jface.viewers.ITreeContentProvider#hasChildren(java.lang.Object)
		 */
		public bool hasChildren(Object element) {
			return (cast(MyModel) element).child.length > 0;
		}

	}

	public class MyModel {
		public MyModel parent;

		public MyModel[] child;

		public int counter;

		public this(int counter, MyModel parent) {
			this.parent = parent;
			this.counter = counter;
		}

		public String toString() {
			String rv = "Item ";
			if (parent !is null) {
				rv = parent.toString() ~  ".";
			}

			rv ~= to!(char[])(counter);

			return rv;
		}
	}

	public this(Shell shell) {
		final TreeViewer v = new TreeViewer(shell);
		v.setLabelProvider(new LabelProvider());
		v.setContentProvider(new MyContentProvider());
		v.setInput(createModel());

		final Action a = new class Action {};
		final MenuManager mgr = new MenuManager();
		mgr.setRemoveAllWhenShown(true);

        class MyMenuListener :  IMenuListener {
            TreeViewer v;
            Action a;
            MenuManager mgr;

            this(TreeViewer v_, Action a_, MenuManager mgr_) {
                this.v = v_; this.a = a_; this.mgr = mgr_;
            }

            /* (non-Javadoc)
             * @see org.eclipse.jface.action.IMenuListener#menuAboutToShow(org.eclipse.jface.action.IMenuManager)
             */
            public void menuAboutToShow(IMenuManager manager) {
                IStructuredSelection selection = cast(IStructuredSelection) v
                    .getSelection();
                if (!selection.isEmpty()) {
                    a.setText("Action for "
                              ~ (cast(MyModel) selection.getFirstElement())
                              .toString());
                    mgr.add(a);
                }
            }
        }

		mgr.addMenuListener(new MyMenuListener(v,a,mgr));
		v.getControl().setMenu(mgr.createContextMenu(v.getControl()));
	}

	private MyModel createModel() {

		MyModel root = new MyModel(0, null);
		root.counter = 0;

		MyModel tmp;
		for (int i = 1; i < 10; i++) {
			tmp = new MyModel(i, root);
			root.child ~= tmp;
			for (int j = 1; j < i; j++) {
				tmp.child ~= new MyModel(j, tmp);
			}
		}

		return root;
	}

}

void main() {
    Display display = new Display();
    Shell shell = new Shell(display);
    shell.setLayout(new FillLayout());
    new Snippet005TreeCustomMenu(shell);
    shell.open();

    while (!shell.isDisposed()) {
        if (!display.readAndDispatch())
            display.sleep();
    }

    display.dispose();
}
