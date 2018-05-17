/*******************************************************************************
 * Copyright (c) 2003, 2006 IBM Corporation and others.
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
module dwtx.jface.preference.PreferenceContentProvider;

import dwtx.jface.preference.IPreferenceNode;
import dwtx.jface.preference.PreferenceManager;

import dwtx.jface.viewers.ITreeContentProvider;
import dwtx.jface.viewers.Viewer;

import dwt.dwthelper.utils;

/**
 * Provides a tree model for <code>PreferenceManager</code> content.
 *
 * @since 3.0
 */
public class PreferenceContentProvider : ITreeContentProvider {

    private PreferenceManager manager;

    /* (non-Javadoc)
     * @see dwtx.jface.viewers.IContentProvider#dispose()
     */
    public void dispose() {
        manager = null;
    }

    /**
     * Find the parent of the provided node.  Will search recursivly through the
     * preference tree.
     *
     * @param parent the possible parent node.
     * @param target the target child node.
     * @return the parent node of the child node.
     */
    private IPreferenceNode findParent(IPreferenceNode parent,
            IPreferenceNode target) {
        if (parent.getId().equals(target.getId())) {
            return null;
        }

        IPreferenceNode found = parent.findSubNode(target.getId());
        if (found !is null) {
            return parent;
        }

        IPreferenceNode[] children = parent.getSubNodes();

        for (int i = 0; i < children.length; i++) {
            found = findParent(children[i], target);
            if (found !is null) {
                return found;
            }
        }

        return null;
    }

    /*
     *  (non-Javadoc)
     * @see dwtx.jface.viewers.ITreeContentProvider#getChildren(java.lang.Object)
     */
    public Object[] getChildren(Object parentElement) {//must be an instance of <code>IPreferenceNode</code>.
        return arraycast!(Object)((cast(IPreferenceNode) parentElement).getSubNodes());
    }

    /*
     *  (non-Javadoc)
     * @see dwtx.jface.viewers.IStructuredContentProvider#getElements(java.lang.Object)
     */
    public Object[] getElements(Object inputElement) {// must be an instance of <code>PreferenceManager</code>.
        return getChildren(cast(Object)(cast(PreferenceManager) inputElement).getRoot_package());
    }

    /*
     *  (non-Javadoc)
     * @see dwtx.jface.viewers.ITreeContentProvider#getParent(java.lang.Object)
     */
    public Object getParent(Object element) {//must be an instance of <code>IPreferenceNode</code>.
        IPreferenceNode targetNode = cast(IPreferenceNode) element;
        IPreferenceNode root = manager.getRoot_package();
        return cast(Object)findParent(root, targetNode);
    }

    /* (non-Javadoc)
     * @see dwtx.jface.viewers.ITreeContentProvider#hasChildren(java.lang.Object)
     */
    public bool hasChildren(Object element) {
        return getChildren(element).length > 0;
    }

    /* (non-Javadoc)
     * @see dwtx.jface.viewers.IContentProvider#inputChanged(dwtx.jface.viewers.Viewer, java.lang.Object, java.lang.Object)
     */
    public void inputChanged(Viewer viewer, Object oldInput, Object newInput) {
        manager = cast(PreferenceManager) newInput;
    }
    /**
     * Set the manager for the preferences.
     * @param manager The manager to set.
     *
     * @since 3.1
     */
    protected void setManager(PreferenceManager manager) {
        this.manager = manager;
    }
}
