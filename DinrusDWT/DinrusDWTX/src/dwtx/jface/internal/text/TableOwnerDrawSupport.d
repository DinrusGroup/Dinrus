/*******************************************************************************
 * Copyright (c) 2008 IBM Corporation and others.
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
module dwtx.jface.internal.text.TableOwnerDrawSupport;

import dwtx.jface.internal.text.NonDeletingPositionUpdater; // packageimport
import dwtx.jface.internal.text.InternalAccessor; // packageimport
import dwtx.jface.internal.text.StickyHoverManager; // packageimport
import dwtx.jface.internal.text.InformationControlReplacer; // packageimport
import dwtx.jface.internal.text.DelayedInputChangeListener; // packageimport


import dwt.dwthelper.utils;

import dwt.DWT;
import dwt.custom.StyleRange;
import dwt.graphics.Color;
import dwt.graphics.GC;
import dwt.graphics.Image;
import dwt.graphics.Rectangle;
import dwt.graphics.TextLayout;
import dwt.widgets.Event;
import dwt.widgets.Listener;
import dwt.widgets.Table;
import dwt.widgets.TableItem;


/**
 * Adds owner draw support for tables.
 *
 * @since 3.4
 */
public class TableOwnerDrawSupport : Listener {

    private static const String STYLED_RANGES_KEY= "styled_ranges"; //$NON-NLS-1$

    private TextLayout fLayout;

    public static void install(Table table) {
        TableOwnerDrawSupport listener= new TableOwnerDrawSupport(table);
        table.addListener(DWT.Dispose, listener);
        table.addListener(DWT.MeasureItem, listener);
        table.addListener(DWT.EraseItem, listener);
        table.addListener(DWT.PaintItem, listener);
    }

    /**
     * Stores the styled ranges in the given table item.
     *
     * @param item table item
     * @param column the column index
     * @param ranges the styled ranges or <code>null</code> to remove them
     */
    public static void storeStyleRanges(TableItem item, int column, StyleRange[] ranges) {
        item.setData(STYLED_RANGES_KEY ~ Integer.toString(column), new ArrayWrapperObject(arraycast!(Object)(ranges)));
    }

    /**
     * Returns the styled ranges which are stored in the given table item.
     *
     * @param item table item
     * @param column the column index
     * @return the styled ranges
     */
    private static StyleRange[] getStyledRanges(TableItem item, int column) {
        return arrayFromObject!(StyleRange)(item.getData(STYLED_RANGES_KEY ~ Integer.toString(column)));
    }

    private this(Table table) {
        int orientation= table.getStyle() & (DWT.LEFT_TO_RIGHT | DWT.RIGHT_TO_LEFT);
        fLayout= new TextLayout(table.getDisplay());
        fLayout.setOrientation(orientation);
    }

    /*
     * @see dwt.widgets.Listener#handleEvent(dwt.widgets.Event)
     */
    public void handleEvent(Event event) {
        switch (event.type) {
            case DWT.MeasureItem:
                break;
            case DWT.EraseItem:
                event.detail &= ~DWT.FOREGROUND;
                break;
            case DWT.PaintItem:
                performPaint(event);
                break;
            case DWT.Dispose:
                widgetDisposed();
                break;
            default:
            }
    }

    /**
     * Performs the paint operation.
     *
     * @param event the event
     */
    private void performPaint(Event event) {
        TableItem item= cast(TableItem) event.item;
        GC gc= event.gc;
        int index= event.index;

        bool isSelected= (event.detail & DWT.SELECTED) !is 0;

        // Remember colors to restore the GC later
        Color oldForeground= gc.getForeground();
        Color oldBackground= gc.getBackground();

        if (!isSelected) {
            Color foreground= item.getForeground(index);
            gc.setForeground(foreground);

            Color background= item.getBackground(index);
            gc.setBackground(background);
        }

        Image image=item.getImage(index);
        if (image !is null) {
            Rectangle imageBounds=item.getImageBounds(index);
            Rectangle bounds=image.getBounds();
            int x=imageBounds.x + Math.max(0, (imageBounds.width - bounds.width) / 2);
            int y=imageBounds.y + Math.max(0, (imageBounds.height - bounds.height) / 2);
            gc.drawImage(image, x, y);
        }

        fLayout.setFont(item.getFont(index));

        // XXX: needed to clear the style info, see https://bugs.eclipse.org/bugs/show_bug.cgi?id=226090
        fLayout.setText(""); //$NON-NLS-1$

        fLayout.setText(item.getText(index));

        StyleRange[] ranges= getStyledRanges(item, index);
        if (ranges !is null) {
            for (int i= 0; i < ranges.length; i++) {
                StyleRange curr= ranges[i];
                if (isSelected) {
                    curr= cast(StyleRange) curr.clone();
                    curr.foreground= null;
                    curr.background= null;
                }
                fLayout.setStyle(curr, curr.start, curr.start + curr.length - 1);
            }
        }

        Rectangle textBounds=item.getTextBounds(index);
        if (textBounds !is null) {
            Rectangle layoutBounds=fLayout.getBounds();
            int x=textBounds.x;
            int y=textBounds.y + Math.max(0, (textBounds.height - layoutBounds.height) / 2);
            fLayout.draw(gc, x, y);
        }

        if ((event.detail & DWT.FOCUSED) !is 0) {
            Rectangle focusBounds=item.getBounds();
            gc.drawFocus(focusBounds.x, focusBounds.y, focusBounds.width, focusBounds.height);
        }

        if (!isSelected) {
            gc.setForeground(oldForeground);
            gc.setBackground(oldBackground);
        }
    }

    private void widgetDisposed() {
        fLayout.dispose();
    }
}

