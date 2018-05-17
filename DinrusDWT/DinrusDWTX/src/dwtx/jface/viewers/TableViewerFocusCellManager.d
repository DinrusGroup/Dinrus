/*******************************************************************************
 * Copyright (c) 2007, 2008 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *     Tom Schindl <tom.schindl@bestsolution.at> - initial API and implementation
 *                                                 fix in bug: 210752
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/

module dwtx.jface.viewers.TableViewerFocusCellManager;

import dwtx.jface.viewers.SWTFocusCellManager;
import dwtx.jface.viewers.CellNavigationStrategy;
import dwtx.jface.viewers.TableViewer;
import dwtx.jface.viewers.FocusCellHighlighter;
import dwtx.jface.viewers.ViewerCell;

import dwt.widgets.Table;

import dwt.dwthelper.utils;

/**
 * This class is responsible to provide the concept of cells for {@link Table}.
 * This concept is needed to provide features like editor activation with the
 * keyboard
 *
 * @since 3.3
 *
 */
public class TableViewerFocusCellManager : SWTFocusCellManager {
    private static const CellNavigationStrategy TABLE_NAVIGATE;
    static this(){
        TABLE_NAVIGATE = new CellNavigationStrategy();
    }

    /**
     * Create a new manager with a default navigation strategy:
     * <ul>
     * <li><code>DWT.ARROW_UP</code>: navigate to cell above</li>
     * <li><code>DWT.ARROW_DOWN</code>: navigate to cell below</li>
     * <li><code>DWT.ARROW_RIGHT</code>: navigate to next visible cell on
     * the right</li>
     * <li><code>DWT.ARROW_LEFT</code>: navigate to next visible cell on the
     * left</li>
     * </ul>
     *
     * @param viewer
     *            the viewer the manager is bound to
     * @param focusDrawingDelegate
     *            the delegate responsible to highlight selected cell
     */
    public this(TableViewer viewer,
            FocusCellHighlighter focusDrawingDelegate) {
        this(viewer, focusDrawingDelegate, TABLE_NAVIGATE);
    }

    /**
     * Create a new manager
     *
     * @param viewer
     *            the viewer the manager is bound to
     * @param focusDrawingDelegate
     *            the delegate responsible to highlight selected cell
     * @param navigationStrategy
     *            the strategy used to navigate the cells
     * @since 3.4
     */
    public this(TableViewer viewer,
            FocusCellHighlighter focusDrawingDelegate,
            CellNavigationStrategy navigationStrategy) {
        super(viewer, focusDrawingDelegate, navigationStrategy);
    }

    override ViewerCell getInitialFocusCell() {
        Table table = cast(Table) getViewer().getControl();

        if (! table.isDisposed() && table.getItemCount() > 0 && ! table.getItem(0).isDisposed()) {
            return getViewer().getViewerRowFromItem_package(table.getItem(0))
                    .getCell(0);
        }

        return null;
    }

    public ViewerCell getFocusCell() {
        ViewerCell cell = super.getFocusCell();
        Table t = cast(Table) getViewer().getControl();

        // It is possible that the selection has changed under the hood
        if (cell !is null) {
            if (t.getSelection().length is 1
                    && t.getSelection()[0] !is cell.getItem()) {
                setFocusCell(getViewer().getViewerRowFromItem_package(
                        t.getSelection()[0]).getCell(cell.getColumnIndex()));
            }
        }

        return super.getFocusCell();
    }

}
