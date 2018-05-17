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
 *                                               - bug fix for bug 187189, 182800, 215069
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/

module dwtx.jface.viewers.SWTFocusCellManager;

import dwtx.jface.viewers.CellNavigationStrategy;
import dwtx.jface.viewers.ColumnViewer;
import dwtx.jface.viewers.ViewerCell;
import dwtx.jface.viewers.ViewerRow;
import dwtx.jface.viewers.FocusCellHighlighter;
import dwtx.jface.viewers.Viewer;
import dwtx.jface.viewers.ISelectionChangedListener;
import dwtx.jface.viewers.SelectionChangedEvent;

import dwt.DWT;
import dwt.events.DisposeEvent;
import dwt.events.DisposeListener;
import dwt.graphics.Point;
import dwt.widgets.Event;
import dwt.widgets.Listener;
import dwtx.core.runtime.Assert;

/**
 * This class is responsible to provide cell management base features for the
 * DWT-Controls {@link dwt.widgets.Table} and
 * {@link dwt.widgets.Tree}.
 *
 * @since 3.3
 *
 */
abstract class SWTFocusCellManager {

    private CellNavigationStrategy navigationStrategy;

    private ColumnViewer viewer;

    private ViewerCell focusCell;

    private FocusCellHighlighter cellHighlighter;

    private DisposeListener itemDeletionListener;


    /**
     * @param viewer
     * @param focusDrawingDelegate
     * @param navigationDelegate
     */
    public this(ColumnViewer viewer,
            FocusCellHighlighter focusDrawingDelegate,
            CellNavigationStrategy navigationDelegate) {

        itemDeletionListener = new class DisposeListener {
            public void widgetDisposed(DisposeEvent e) {
                setFocusCell(null);
            }
        };

        this.viewer = viewer;
        this.cellHighlighter = focusDrawingDelegate;
        this.navigationStrategy = navigationDelegate;
        hookListener(viewer);
    }

    /**
     * This method is called by the framework to initialize this cell manager.
     */
    void init() {
        this.cellHighlighter.init_package();
        this.navigationStrategy.init_package();
    }

    private void handleMouseDown(Event event) {
        ViewerCell cell = viewer.getCell(new Point(event.x, event.y));
        if (cell !is null) {

            if (!cell.opEquals(focusCell)) {
                setFocusCell(cell);
            }
        }
    }

    private void handleKeyDown(Event event) {
        ViewerCell tmp = null;

        if (navigationStrategy.isCollapseEvent(viewer, focusCell, event)) {
            navigationStrategy.collapse(viewer, focusCell, event);
        } else if (navigationStrategy.isExpandEvent(viewer, focusCell, event)) {
            navigationStrategy.expand(viewer, focusCell, event);
        } else if (navigationStrategy.isNavigationEvent(viewer, event)) {
            tmp = navigationStrategy.findSelectedCell(viewer, focusCell, event);

            if (tmp !is null) {
                if (!tmp.opEquals(focusCell)) {
                    setFocusCell(tmp);
                }
            }
        }

        if (navigationStrategy.shouldCancelEvent(viewer, event)) {
            event.doit = false;
        }
    }

    private void handleSelection(Event event) {
        if ((event.detail & DWT.CHECK) is 0 && focusCell !is null && focusCell.getItem() !is event.item
                && event.item !is null ) {
            ViewerRow row = viewer.getViewerRowFromItem_package(event.item);
            Assert
                    .isNotNull(row,
                            "Internal Structure invalid. Row item has no row ViewerRow assigned"); //$NON-NLS-1$
            ViewerCell tmp = row.getCell(focusCell.getColumnIndex());
            if (!focusCell.opEquals(tmp)) {
                setFocusCell(tmp);
            }
        }
    }

    private void handleFocusIn(Event event) {
        if (focusCell is null) {
            setFocusCell(getInitialFocusCell());
        }
    }

    abstract ViewerCell getInitialFocusCell();

    private void hookListener(ColumnViewer viewer) {
        Listener listener = new class Listener {

            public void handleEvent(Event event) {
                switch (event.type) {
                case DWT.MouseDown:
                    handleMouseDown(event);
                    break;
                case DWT.KeyDown:
                    handleKeyDown(event);
                    break;
                case DWT.Selection:
                    handleSelection(event);
                    break;
                case DWT.FocusIn:
                    handleFocusIn(event);
                    break;
                default:
                }
            }
        };

        viewer.getControl().addListener(DWT.MouseDown, listener);
        viewer.getControl().addListener(DWT.KeyDown, listener);
        viewer.getControl().addListener(DWT.Selection, listener);
        viewer.addSelectionChangedListener(new class ISelectionChangedListener {

            public void selectionChanged(SelectionChangedEvent event) {
                if( event.getSelection_package.isEmpty() ) {
                    setFocusCell(null);
                }
            }

        });
        viewer.getControl().addListener(DWT.FocusIn, listener);
    }

    /**
     * @return the cell with the focus
     *
     */
    public ViewerCell getFocusCell() {
        return focusCell;
    }

    void setFocusCell(ViewerCell focusCell) {
        ViewerCell oldCell = this.focusCell;

        if( this.focusCell !is null && ! this.focusCell.getItem().isDisposed() ) {
            this.focusCell.getItem().removeDisposeListener(itemDeletionListener);
        }

        this.focusCell = focusCell;

        if( this.focusCell !is null && ! this.focusCell.getItem().isDisposed() ) {
            this.focusCell.getItem().addDisposeListener(itemDeletionListener);
        }

        this.cellHighlighter.focusCellChanged_package(focusCell,oldCell);
    }

    ColumnViewer getViewer() {
        return viewer;
    }
}
