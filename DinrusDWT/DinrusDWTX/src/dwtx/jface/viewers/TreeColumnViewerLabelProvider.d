/*******************************************************************************
 * Copyright (c) 2006, 2007 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *     Tom Schindl <tom.schindl@bestsolution.at> - initial API and implementation
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/

module dwtx.jface.viewers.TreeColumnViewerLabelProvider;

import dwtx.jface.viewers.IBaseLabelProvider;
import dwtx.jface.viewers.TableColumnViewerLabelProvider;
import dwtx.jface.viewers.ITreePathLabelProvider;
import dwtx.jface.viewers.ViewerLabel;
import dwtx.jface.viewers.TreePath;
import dwtx.jface.viewers.ILabelProviderListener;

import dwt.dwthelper.utils;

/**
 * TreeViewerLabelProvider is the ViewerLabelProvider that handles TreePaths.
 *
 * @since 3.3
 *
 */
public class TreeColumnViewerLabelProvider :
        TableColumnViewerLabelProvider {
    private ITreePathLabelProvider treePathProvider;
    private void init_treePathProvider(){
        treePathProvider = new class ITreePathLabelProvider {
            /*
            * (non-Javadoc)
            *
            * @see dwtx.jface.viewers.ITreePathLabelProvider#updateLabel(dwtx.jface.viewers.ViewerLabel,
            *      dwtx.jface.viewers.TreePath)
            */
            public void updateLabel(ViewerLabel label, TreePath elementPath) {
                // Do nothing by default

            }

            /*
            * (non-Javadoc)
            *
            * @see dwtx.jface.viewers.IBaseLabelProvider#dispose()
            */
            public void dispose() {
                // Do nothing by default

            }

            /*
            * (non-Javadoc)
            *
            * @see dwtx.jface.viewers.IBaseLabelProvider#addListener(dwtx.jface.viewers.ILabelProviderListener)
            */
            public void addListener(ILabelProviderListener listener) {
                // Do nothing by default

            }

            /*
            * (non-Javadoc)
            *
            * @see dwtx.jface.viewers.IBaseLabelProvider#removeListener(dwtx.jface.viewers.ILabelProviderListener)
            */
            public void removeListener(ILabelProviderListener listener) {
                // Do nothing by default

            }

            /* (non-Javadoc)
            * @see dwtx.jface.viewers.IBaseLabelProvider#isLabelProperty(java.lang.Object, java.lang.String)
            */
            public bool isLabelProperty(Object element, String property) {
                return false;
            }

        };
    }

    /**
     * Create a new instance of the receiver with the supplied labelProvider.
     *
     * @param labelProvider
     */
    public this(IBaseLabelProvider labelProvider) {
        init_treePathProvider();
        super(labelProvider);
    }

    /**
     * Update the label for the element with TreePath.
     *
     * @param label
     * @param elementPath
     */
    public void updateLabel(ViewerLabel label, TreePath elementPath) {
        treePathProvider.updateLabel(label, elementPath);

    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.viewers.ViewerLabelProvider#setProviders(java.lang.Object)
     */
    public override void setProviders(Object provider) {
        super.setProviders(provider);
        if ( auto p = cast(ITreePathLabelProvider) provider )
            treePathProvider = p;
    }

    /**
     * Return the ITreePathLabelProvider for the receiver.
     *
     * @return Returns the treePathProvider.
     */
    public ITreePathLabelProvider getTreePathProvider() {
        return treePathProvider;
    }

}
