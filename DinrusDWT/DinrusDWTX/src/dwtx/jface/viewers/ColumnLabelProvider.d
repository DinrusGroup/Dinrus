/*******************************************************************************
 * Copyright (c) 2006, 2007 IBM Corporation and others.
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

module dwtx.jface.viewers.ColumnLabelProvider;

import dwtx.jface.viewers.CellLabelProvider;
import dwtx.jface.viewers.IFontProvider;
import dwtx.jface.viewers.IColorProvider;
import dwtx.jface.viewers.ILabelProvider;
import dwtx.jface.viewers.ViewerCell;

import dwt.graphics.Color;
import dwt.graphics.Font;
import dwt.graphics.Image;

import dwt.dwthelper.utils;

/**
 * The ColumnLabelProvider is the label provider for viewers
 * that have column support such as {@link TreeViewer} and
 * {@link TableViewer}
 *
 * <p><b>This classes is intended to be subclassed</b></p>
 *
 * @since 3.3
 *
 */
public class ColumnLabelProvider : CellLabelProvider,
        IFontProvider, IColorProvider, ILabelProvider {

    /* (non-Javadoc)
     * @see dwtx.jface.viewers.CellLabelProvider#update(dwtx.jface.viewers.ViewerCell)
     */
    public override void update(ViewerCell cell) {
        Object element = cell.getElement();
        cell.setText(getText(element));
        Image image = getImage(element);
        cell.setImage(image);
        cell.setBackground(getBackground(element));
        cell.setForeground(getForeground(element));
        cell.setFont(getFont(element));

    }

    /* (non-Javadoc)
     * @see dwtx.jface.viewers.IFontProvider#getFont(java.lang.Object)
     */
    public Font getFont(Object element) {
        return null;
    }

    /* (non-Javadoc)
     * @see dwtx.jface.viewers.IColorProvider#getBackground(java.lang.Object)
     */
    public Color getBackground(Object element) {
        return null;
    }

    /* (non-Javadoc)
     * @see dwtx.jface.viewers.IColorProvider#getForeground(java.lang.Object)
     */
    public Color getForeground(Object element) {
        return null;
    }


    /* (non-Javadoc)
     * @see dwtx.jface.viewers.ILabelProvider#getImage(java.lang.Object)
     */
    public Image getImage(Object element) {
        return null;
    }

    /* (non-Javadoc)
     * @see dwtx.jface.viewers.ILabelProvider#getText(java.lang.Object)
     */
    public String getText(Object element) {
        return element is null ? "" : element.toString();//$NON-NLS-1$
    }

}
