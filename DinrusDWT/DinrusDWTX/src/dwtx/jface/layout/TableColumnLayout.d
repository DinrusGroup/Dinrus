/*******************************************************************************
 * Copyright (c) 2007 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Tom Schindl <tom.schindl@bestsolution.at> - initial API and implementation
 *                                               - fix for bug 178280
 *     IBM Corporation - API refactoring and general maintenance
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/

module dwtx.jface.layout.TableColumnLayout;

import dwtx.jface.layout.AbstractColumnLayout;

import dwt.widgets.Composite;
import dwt.widgets.Layout;
import dwt.widgets.Scrollable;
import dwt.widgets.Table;
import dwt.widgets.TableColumn;
import dwt.widgets.Widget;
import dwtx.jface.viewers.ColumnLayoutData;
import dwtx.jface.viewers.ColumnPixelData;

/**
 * The TableColumnLayout is the {@link Layout} used to maintain
 * {@link TableColumn} sizes in a {@link Table}.
 *
 * <p>
 * <b>You can only add the {@link Layout} to a container whose <i>only</i>
 * child is the {@link Table} control you want the {@link Layout} applied to.
 * Don't assign the layout directly the {@link Table}</b>
 * </p>
 *
 * @since 3.3
 */
public class TableColumnLayout : AbstractColumnLayout {

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.layout.AbstractColumnLayout#getColumnCount(dwt.widgets.Scrollable)
     */
    override int getColumnCount(Scrollable tableTree) {
        return (cast(Table) tableTree).getColumnCount();
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.layout.AbstractColumnLayout#setColumnWidths(dwt.widgets.Scrollable,
     *      int[])
     */
    override void setColumnWidths(Scrollable tableTree, int[] widths) {
        TableColumn[] columns = (cast(Table) tableTree).getColumns();
        for (int i = 0; i < widths.length; i++) {
            columns[i].setWidth(widths[i]);
        }
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.layout.AbstractColumnLayout#getLayoutData(int)
     */
    override ColumnLayoutData getLayoutData(Scrollable tableTree, int columnIndex) {
        TableColumn column = (cast(Table) tableTree).getColumn(columnIndex);
        return cast(ColumnLayoutData) column.getData(LAYOUT_DATA);
    }

    Composite getComposite(Widget column) {
        return (cast(TableColumn) column).getParent().getParent();
    }

    /* (non-Javadoc)
     * @see dwtx.jface.layout.AbstractColumnLayout#updateColumnData(dwt.widgets.Widget)
     */
    override void updateColumnData(Widget column) {
        TableColumn tColumn = cast(TableColumn) column;
        Table t = tColumn.getParent();

        if( ! IS_GTK || t.getColumn(t.getColumnCount()-1) !is tColumn ){
            tColumn.setData(LAYOUT_DATA,new ColumnPixelData(tColumn.getWidth()));
            layout(t.getParent(), true);
        }
    }
}
