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
 *                                                 fixes in bug 198665, 200731
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/

module dwtx.jface.viewers.TableViewerEditor;

import dwtx.jface.viewers.ColumnViewerEditor;
import dwtx.jface.viewers.SWTFocusCellManager;
import dwtx.jface.viewers.CellEditor;
import dwtx.jface.viewers.TableViewer;
import dwtx.jface.viewers.ColumnViewerEditorActivationStrategy;
import dwtx.jface.viewers.ColumnViewerEditorActivationEvent;
import dwtx.jface.viewers.ViewerCell;
import dwtx.jface.viewers.StructuredSelection;


import dwt.DWT;
import dwt.custom.TableEditor;
import dwt.widgets.Control;
import dwt.widgets.Item;
import dwt.widgets.Table;
import dwt.widgets.TableItem;

import dwt.dwthelper.utils;
// import dwtx.dwtxhelper.Collection;

/**
 * This is an editor-implementation for {@link Table}
 *
 * @since 3.3
 *
 */
public final class TableViewerEditor : ColumnViewerEditor {
    /**
     * This viewer's table editor.
     */
    private TableEditor tableEditor;

    private SWTFocusCellManager focusCellManager;

    /**
     * @param viewer
     *            the viewer the editor is attached to
     * @param focusCellManager
     *            the cell focus manager if one used or <code>null</code>
     * @param editorActivationStrategy
     *            the strategy used to decide about the editor activation
     * @param feature
     *            the feature mask
     */
    this(TableViewer viewer, SWTFocusCellManager focusCellManager,
            ColumnViewerEditorActivationStrategy editorActivationStrategy,
            int feature) {
        super(viewer, editorActivationStrategy, feature);
        tableEditor = new TableEditor(viewer.getTable());
        this.focusCellManager = focusCellManager;
    }

    /**
     * Create a customized editor with focusable cells
     *
     * @param viewer
     *            the viewer the editor is created for
     * @param focusCellManager
     *            the cell focus manager if one needed else <code>null</code>
     * @param editorActivationStrategy
     *            activation strategy to control if an editor activated
     * @param feature
     *            bit mask controlling the editor
     *            <ul>
     *            <li>{@link ColumnViewerEditor#DEFAULT}</li>
     *            <li>{@link ColumnViewerEditor#TABBING_CYCLE_IN_ROW}</li>
     *            <li>{@link ColumnViewerEditor#TABBING_HORIZONTAL}</li>
     *            <li>{@link ColumnViewerEditor#TABBING_MOVE_TO_ROW_NEIGHBOR}</li>
     *            <li>{@link ColumnViewerEditor#TABBING_VERTICAL}</li>
     *            </ul>
     * @see #create(TableViewer, ColumnViewerEditorActivationStrategy, int)
     */
    public static void create(TableViewer viewer,
            SWTFocusCellManager focusCellManager,
            ColumnViewerEditorActivationStrategy editorActivationStrategy,
            int feature) {
        TableViewerEditor editor = new TableViewerEditor(viewer,
                focusCellManager, editorActivationStrategy, feature);
        viewer.setColumnViewerEditor(editor);
        if (focusCellManager !is null) {
            focusCellManager.init();
        }
    }

    /**
     * Create a customized editor whose activation process is customized
     *
     * @param viewer
     *            the viewer the editor is created for
     * @param editorActivationStrategy
     *            activation strategy to control if an editor activated
     * @param feature
     *            bit mask controlling the editor
     *            <ul>
     *            <li>{@link ColumnViewerEditor#DEFAULT}</li>
     *            <li>{@link ColumnViewerEditor#TABBING_CYCLE_IN_ROW}</li>
     *            <li>{@link ColumnViewerEditor#TABBING_HORIZONTAL}</li>
     *            <li>{@link ColumnViewerEditor#TABBING_MOVE_TO_ROW_NEIGHBOR}</li>
     *            <li>{@link ColumnViewerEditor#TABBING_VERTICAL}</li>
     *            </ul>
     */
    public static void create(TableViewer viewer,
            ColumnViewerEditorActivationStrategy editorActivationStrategy,
            int feature) {
        create(viewer, null, editorActivationStrategy, feature);
    }

    protected override void setEditor(Control w, Item item, int columnNumber) {
        tableEditor.setEditor(w, cast(TableItem) item, columnNumber);
    }

    protected override void setLayoutData(LayoutData layoutData) {
        tableEditor.grabHorizontal = layoutData.grabHorizontal;
        tableEditor.horizontalAlignment = layoutData.horizontalAlignment;
        tableEditor.minimumWidth = layoutData.minimumWidth;
        tableEditor.verticalAlignment = layoutData.verticalAlignment;

        if( layoutData.minimumHeight !is DWT.DEFAULT ) {
            tableEditor.minimumHeight = layoutData.minimumHeight;
        }
    }

    public override ViewerCell getFocusCell() {
        if (focusCellManager !is null) {
            return focusCellManager.getFocusCell();
        }

        return super.getFocusCell();
    }

    protected override void updateFocusCell(ViewerCell focusCell,
            ColumnViewerEditorActivationEvent event) {
        // Update the focus cell when we activated the editor with these 2
        // events
        if (event.eventType is ColumnViewerEditorActivationEvent.PROGRAMMATIC
                || event.eventType is ColumnViewerEditorActivationEvent.TRAVERSAL) {

            auto l = getViewer().getSelectionFromWidget_package();

            if (focusCellManager !is null) {
                focusCellManager.setFocusCell(focusCell);
            }

            if (!l.contains(focusCell.getElement())) {
                getViewer().setSelection(
                        new StructuredSelection(focusCell.getElement()),true);
            }
        }
    }
}
