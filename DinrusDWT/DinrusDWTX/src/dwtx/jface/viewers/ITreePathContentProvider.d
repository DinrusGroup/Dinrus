/*******************************************************************************
 * Copyright (c) 2006 IBM Corporation and others.
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

module dwtx.jface.viewers.ITreePathContentProvider;

import dwtx.jface.viewers.IStructuredContentProvider;
import dwtx.jface.viewers.TreePath;

/**
 * An interface to content providers for tree-structure-oriented viewers that
 * provides content based on the path of elements in the tree viewer..
 *
 * @see AbstractTreeViewer
 * @since 3.2
 */
public interface ITreePathContentProvider : IStructuredContentProvider {

    /**
     * Returns the child elements of the last element in the given path.
     * Implementors may want to use the additional context of the complete path
     * of a parent element in order to decide which children to return.
     * <p>
     * The provided path is relative to the input. The root elements must
     * be obtained by calling
     * {@link IStructuredContentProvider#getElements(Object)}.
     * </p>
     * The result is not modified by the viewer.
     *
     * @param parentPath
     *            the path of the parent element
     * @return an array of child elements
     */
    public Object[] getChildren(TreePath parentPath);

    /**
     * Returns whether the last element of the given path has children.
     * <p>
     * Intended as an optimization for when the viewer does not need the actual
     * children. Clients may be able to implement this more efficiently than
     * <code>getChildren</code>.
     * </p>
     *
     * @param path
     *            the path
     * @return <code>true</code> if the lat element of the path has children,
     *         and <code>false</code> if it has no children
     */
    public bool hasChildren(TreePath path);

    /**
     * Return the possible parent paths for the given element. An empty array
     * can be returned if the paths cannot be computed. If the element is
     * a potential child of the input of the viewer, an empty tree path
     * should be an entry in the returned array.
     *
     * @param element
     *            the element
     * @return the possible parent paths for the given element
     */
    public TreePath[] getParents(Object element);
}
