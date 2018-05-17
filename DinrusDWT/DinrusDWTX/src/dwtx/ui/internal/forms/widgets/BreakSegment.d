/*******************************************************************************
 * Copyright (c) 2000, 2005 IBM Corporation and others.
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
module dwtx.ui.internal.forms.widgets.BreakSegment;

import dwtx.ui.internal.forms.widgets.ParagraphSegment;
import dwtx.ui.internal.forms.widgets.Locator;
import dwtx.ui.internal.forms.widgets.SelectionData;

import dwt.graphics.FontMetrics;
import dwt.graphics.GC;
import dwt.graphics.Rectangle;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;

/**
 * This segment serves as break within a paragraph. It has no data -
 * just starts a new line and resets the locator.
 */

public class BreakSegment : ParagraphSegment {
    /* (non-Javadoc)
     * @see dwtx.ui.forms.internal.widgets.ParagraphSegment#advanceLocator(dwt.graphics.GC, int, dwtx.ui.forms.internal.widgets.Locator, java.util.Hashtable)
     */
    public bool advanceLocator(GC gc, int wHint, Locator locator,
            Hashtable objectTable, bool computeHeightOnly) {
        if (locator.rowHeight is 0) {
            FontMetrics fm = gc.getFontMetrics();
            locator.rowHeight = fm.getHeight();
        }
        if (computeHeightOnly) locator.collectHeights();
        locator.x = locator.indent;
        locator.y += locator.rowHeight;
        locator.rowHeight = 0;
        locator.leading = 0;
        return true;
    }

    public void paint(GC gc, bool hover, Hashtable resourceTable, bool selected, SelectionData selData, Rectangle repaintRegion) {
        //nothing to paint
    }
    public bool contains(int x, int y) {
        return false;
    }
    public bool intersects(Rectangle rect) {
        return false;
    }
    /* (non-Javadoc)
     * @see dwtx.ui.internal.forms.widgets.ParagraphSegment#layout(dwt.graphics.GC, int, dwtx.ui.internal.forms.widgets.Locator, java.util.Hashtable, bool, dwtx.ui.internal.forms.widgets.SelectionData)
     */
    public void layout(GC gc, int width, Locator locator, Hashtable ResourceTable,
            bool selected) {
        locator.resetCaret();
        if (locator.rowHeight is 0) {
            FontMetrics fm = gc.getFontMetrics();
            locator.rowHeight = fm.getHeight();
        }
        locator.y += locator.rowHeight;
        locator.rowHeight = 0;
        locator.rowCounter++;
    }

    /* (non-Javadoc)
     * @see dwtx.ui.internal.forms.widgets.ParagraphSegment#computeSelection(dwt.graphics.GC, java.util.Hashtable, bool, dwtx.ui.internal.forms.widgets.SelectionData)
     */
    public void computeSelection(GC gc, Hashtable resourceTable, SelectionData selData) {
        selData.markNewLine();
    }
}
