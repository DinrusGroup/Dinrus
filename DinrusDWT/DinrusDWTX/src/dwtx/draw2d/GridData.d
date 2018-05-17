/*******************************************************************************
 * Copyright (c) 2000, 2007 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *     Asim Ullah - Ported for use in draw2d (c.f Bugzilla 71684).[Sep 10, 2004]
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/
module dwtx.draw2d.GridData;

import dwt.dwthelper.utils;


import dwt.DWT;
import dwtx.draw2d.geometry.Dimension;
import dwtx.draw2d.IFigure;

/**
 * <code>GridData</code> is the layout data object associated with
 * <code>GridLayout</code>. To set a <code>GridData</code> object into a
 * <code>Figure</code>, you use the <code>setConstraint()</code> method of
 * <code>GridLayout</code> to map the <code>Figure</code> to its layout
 * <code>GridData</code>.
 * <p>
 * There are two ways to create a <code>GridData</code> object with certain
 * fields set. The first is to set the fields directly, like this:
 *
 * <pre>
 * GridData gridData = new GridData();
 * gridData.horizontalAlignment = GridData.FILL;
 * gridData.grabExcessHorizontalSpace = true;
 *
 * // associate the figure to the GridData object
 * myGridlayout.setConstraint(myFigure, gridData);
 * </pre>
 *
 * The second is to take advantage of convenience style bits defined by
 * <code>GridData</code>:
 *
 * <pre>
 * GridData gridData = new GridData(GridData.HORIZONTAL_ALIGN_FILL
 *      | GridData.GRAB_HORIZONTAL);
 * </pre>
 *
 * </p>
 * <p>
 * NOTE: Do not reuse <code>GridData</code> objects. Every child in the parent
 * <code>Figure</code> that is managed by the <code>GridLayout</code> must
 * have a unique <code>GridData</code> object. If the layout data for a Grid
 * member in a <code>GridLayout</code> is null at layout time, a unique
 * <code>GridData</code> object is created for it.
 * </p>
 *
 * @see GridLayout
 */
public final class GridData {
    /**
     * verticalAlignment specifies how figures will be positioned vertically
     * within a cell.
     *
     * The default value is CENTER.
     *
     * Possible values are:
     *
     * DWT.BEGINNING (or DWT.TOP): Position the figure at the top of the cell
     * DWT.CENTER: Position the figure in the vertical center of the cell
     * DWT.END (or DWT.BOTTOM): Position the figure at the bottom of the cell
     * DWT.FILL: Resize the figure to fill the cell vertically
     */
    public int verticalAlignment = CENTER;

    /**
     * horizontalAlignment specifies how figures will be positioned horizontally
     * within a cell.
     *
     * The default value is BEGINNING.
     *
     * Possible values are:
     *
     * DWT.BEGINNING (or DWT.LEFT): Position the figure at the left of the cell
     * DWT.CENTER: Position the figure in the horizontal center of the cell
     * DWT.END (or DWT.RIGHT): Position the figure at the right of the cell
     * DWT.FILL: Resize the figure to fill the cell horizontally
     */
    public int horizontalAlignment = BEGINNING;

    /**
     * widthHint specifies a minimum width for the column. A value of
     * DWT.DEFAULT indicates that no minimum width is specified.
     *
     * The default value is DWT.DEFAULT.
     */
    public int widthHint = DWT.DEFAULT;

    /**
     * heightHint specifies a minimum height for the row. A value of DWT.DEFAULT
     * indicates that no minimum height is specified.
     *
     * The default value is DWT.DEFAULT.
     */
    public int heightHint = DWT.DEFAULT;

    /**
     * horizontalIndent specifies the number of pixels of indentation that will
     * be placed along the left side of the cell.
     *
     * The default value is 0.
     */
    public int horizontalIndent = 0;

    /**
     * horizontalSpan specifies the number of column cells that the figure will
     * take up.
     *
     * The default value is 1.
     */
    public int horizontalSpan = 1;

    /**
     * verticalSpan specifies the number of row cells that the figure will take
     * up.
     *
     * The default value is 1.
     */
    public int verticalSpan = 1;

    /**
     * grabExcessHorizontalSpace specifies whether the cell will be made wide
     * enough to fit the remaining horizontal space.
     *
     * The default value is false.
     */
    public bool grabExcessHorizontalSpace = false;

    /**
     * grabExcessVerticalSpace specifies whether the cell will be made tall
     * enough to fit the remaining vertical space.
     *
     * The default value is false.
     */
    public bool grabExcessVerticalSpace = false;

    /**
     * Value for horizontalAlignment or verticalAlignment. Position the figure
     * at the top or left of the cell. Not recommended. Use DWT.BEGINNING,
     * DWT.TOP or DWT.LEFT instead.
     */
    public static const int BEGINNING = DWT.BEGINNING;

    /**
     * Value for horizontalAlignment or verticalAlignment. Position the figure
     * in the vertical or horizontal center of the cell Not recommended. Use
     * DWT.CENTER instead.
     */
    public static const int CENTER = 2;

    /**
     * Value for horizontalAlignment or verticalAlignment. Position the figure
     * at the bottom or right of the cell Not recommended. Use DWT.END,
     * DWT.BOTTOM or DWT.RIGHT instead.
     */
    public static const int END = 3;

    /**
     * Value for horizontalAlignment or verticalAlignment. Resize the figure to
     * fill the cell horizontally or vertically. Not recommended. Use DWT.FILL
     * instead.
     */
    public static const int FILL = DWT.FILL;

    /**
     * Style bit for <code>new GridData(int)</code>. Position the figure at
     * the top of the cell. Not recommended. Use
     * <code>new GridData(int, DWT.BEGINNING, bool, bool)</code>
     * instead.
     */
    public static const int VERTICAL_ALIGN_BEGINNING = 1 << 1;

    /**
     * Style bit for <code>new GridData(int)</code> to position the figure in
     * the vertical center of the cell. Not recommended. Use
     * <code>new GridData(int, DWT.CENTER, bool, bool)</code> instead.
     */
    public static const int VERTICAL_ALIGN_CENTER = 1 << 2;

    /**
     * Style bit for <code>new GridData(int)</code> to position the figure at
     * the bottom of the cell. Not recommended. Use
     * <code>new GridData(int, DWT.END, bool, bool)</code> instead.
     */
    public static const int VERTICAL_ALIGN_END = 1 << 3;

    /**
     * Style bit for <code>new GridData(int)</code> to resize the figure to
     * fill the cell vertically. Not recommended. Use
     * <code>new GridData(int, DWT.FILL, bool, bool)</code> instead
     */
    public static const int VERTICAL_ALIGN_FILL = 1 << 4;

    /**
     * Style bit for <code>new GridData(int)</code> to position the figure at
     * the left of the cell. Not recommended. Use
     * <code>new GridData(DWT.BEGINNING, int, bool, bool)</code>
     * instead.
     */
    public static const int HORIZONTAL_ALIGN_BEGINNING = 1 << 5;

    /**
     * Style bit for <code>new GridData(int)</code> to position the figure in
     * the horizontal center of the cell. Not recommended. Use
     * <code>new GridData(DWT.CENTER, int, bool, bool)</code> instead.
     */
    public static const int HORIZONTAL_ALIGN_CENTER = 1 << 6;

    /**
     * Style bit for <code>new GridData(int)</code> to position the figure at
     * the right of the cell. Not recommended. Use
     * <code>new GridData(DWT.END, int, bool, bool)</code> instead.
     */
    public static const int HORIZONTAL_ALIGN_END = 1 << 7;

    /**
     * Style bit for <code>new GridData(int)</code> to resize the figure to
     * fill the cell horizontally. Not recommended. Use
     * <code>new GridData(DWT.FILL, int, bool, bool)</code> instead.
     */
    public static const int HORIZONTAL_ALIGN_FILL = 1 << 8;

    /**
     * Style bit for <code>new GridData(int)</code> to resize the figure to
     * fit the remaining horizontal space. Not recommended. Use
     * <code>new GridData(int, int, true, bool)</code> instead.
     */
    public static const int GRAB_HORIZONTAL = 1 << 9;

    /**
     * Style bit for <code>new GridData(int)</code> to resize the figure to
     * fit the remaining vertical space. Not recommended. Use
     * <code>new GridData(int, int, bool, true)</code> instead.
     */
    public static const int GRAB_VERTICAL = 1 << 10;

    /**
     * Style bit for <code>new GridData(int)</code> to resize the figure to
     * fill the cell vertically and to fit the remaining vertical space.
     * FILL_VERTICAL = VERTICAL_ALIGN_FILL | GRAB_VERTICAL Not recommended. Use
     * <code>new GridData(int, DWT.FILL, bool, true)</code> instead.
     */
    public static const int FILL_VERTICAL = VERTICAL_ALIGN_FILL | GRAB_VERTICAL;

    /**
     * Style bit for <code>new GridData(int)</code> to resize the figure to
     * fill the cell horizontally and to fit the remaining horizontal space.
     * FILL_HORIZONTAL = HORIZONTAL_ALIGN_FILL | GRAB_HORIZONTAL Not
     * recommended. Use <code>new GridData(DWT.FILL, int, true, bool)</code>
     * instead.
     */
    public static const int FILL_HORIZONTAL = HORIZONTAL_ALIGN_FILL
            | GRAB_HORIZONTAL;

    /**
     * Style bit for <code>new GridData(int)</code> to resize the figure to
     * fill the cell horizontally and vertically and to fit the remaining
     * horizontal and vertical space. FILL_BOTH = FILL_VERTICAL |
     * FILL_HORIZONTAL Not recommended. Use
     * <code>new GridData(DWT.FILL, DWT.FILL, true, true)</code> instead.
     */
    public static const int FILL_BOTH = FILL_VERTICAL | FILL_HORIZONTAL;

    int cacheWidth = -1, cacheHeight = -1;
    int[][] cache;
    int cacheIndex = -1;

    /**
     * Constructs a new instance of GridData using default values.
     */
    public this() {
        cache = new int[][](2,4);
    }

    /**
     * Constructs a new instance based on the GridData style. This constructor
     * is not recommended.
     *
     * @param style
     *            the GridData style
     */
    public this(int style) {
        this();
        if ((style & VERTICAL_ALIGN_BEGINNING) !is 0)
            verticalAlignment = BEGINNING;
        if ((style & VERTICAL_ALIGN_CENTER) !is 0)
            verticalAlignment = CENTER;
        if ((style & VERTICAL_ALIGN_FILL) !is 0)
            verticalAlignment = FILL;
        if ((style & VERTICAL_ALIGN_END) !is 0)
            verticalAlignment = END;
        if ((style & HORIZONTAL_ALIGN_BEGINNING) !is 0)
            horizontalAlignment = BEGINNING;
        if ((style & HORIZONTAL_ALIGN_CENTER) !is 0)
            horizontalAlignment = CENTER;
        if ((style & HORIZONTAL_ALIGN_FILL) !is 0)
            horizontalAlignment = FILL;
        if ((style & HORIZONTAL_ALIGN_END) !is 0)
            horizontalAlignment = END;
        grabExcessHorizontalSpace = (style & GRAB_HORIZONTAL) !is 0;
        grabExcessVerticalSpace = (style & GRAB_VERTICAL) !is 0;
    }

    /**
     * Constructs a new instance of GridData according to the parameters.
     *
     * @param horizontalAlignment
     *            how figure will be positioned horizontally within a cell
     * @param verticalAlignment
     *            how figure will be positioned vertically within a cell
     * @param grabExcessHorizontalSpace
     *            whether cell will be made wide enough to fit the remaining
     *            horizontal space
     * @param grabExcessVerticalSpace
     *            whether cell will be made high enough to fit the remaining
     *            vertical space
     *
     */
    public this(int horizontalAlignment, int verticalAlignment,
            bool grabExcessHorizontalSpace, bool grabExcessVerticalSpace) {
        this(horizontalAlignment, verticalAlignment, grabExcessHorizontalSpace,
                grabExcessVerticalSpace, 1, 1);
    }

    /**
     * Constructs a new instance of GridData according to the parameters.
     *
     * @param horizontalAlignment
     *            how figure will be positioned horizontally within a cell
     * @param verticalAlignment
     *            how figure will be positioned vertically within a cell
     * @param grabExcessHorizontalSpace
     *            whether cell will be made wide enough to fit the remaining
     *            horizontal space
     * @param grabExcessVerticalSpace
     *            whether cell will be made high enough to fit the remaining
     *            vertical space
     * @param horizontalSpan
     *            the number of column cells that the figure will take up
     * @param verticalSpan
     *            the number of row cells that the figure will take up
     *
     */
    public this(int horizontalAlignment, int verticalAlignment,
            bool grabExcessHorizontalSpace, bool grabExcessVerticalSpace,
            int horizontalSpan, int verticalSpan) {
        this();
        this.horizontalAlignment = horizontalAlignment;
        this.verticalAlignment = verticalAlignment;
        this.grabExcessHorizontalSpace = grabExcessHorizontalSpace;
        this.grabExcessVerticalSpace = grabExcessVerticalSpace;
        this.horizontalSpan = horizontalSpan;
        this.verticalSpan = verticalSpan;
    }

    /**
     * Constructs a new instance of GridData according to the parameters. A
     * value of DWT.DEFAULT indicates that no minimum width or no minumum height
     * is specified.
     *
     * @param width
     *            a minimum width for the column
     * @param height
     *            a minimum height for the row
     *
     */
    public this(int width, int height) {
        this();
        this.widthHint = width;
        this.heightHint = height;
    }

    Dimension computeSize(IFigure figure, bool flushCache) {
        if (cacheWidth !is -1 && cacheHeight !is -1) {
            return new Dimension(cacheWidth, cacheHeight);
        }
        for (int i = 0; i < cacheIndex + 1; i++) {
            if (cache[i][0] is widthHint && cache[i][1] is heightHint) {
                cacheWidth = cache[i][2];
                cacheHeight = cache[i][3];
                return new Dimension(cacheWidth, cacheHeight);
            }
        }

        Dimension size = figure.getPreferredSize(widthHint, heightHint);
        if (widthHint !is -1)
            size.width = widthHint;
        if (heightHint !is -1)
            size.height = heightHint;

        if (cacheIndex < cache.length - 1)
            cacheIndex++;
        cache[cacheIndex][0] = widthHint;
        cache[cacheIndex][1] = heightHint;
        cacheWidth = cache[cacheIndex][2] = size.width;
        cacheHeight = cache[cacheIndex][3] = size.height;
        return size;
    }

    void flushCache() {
        cacheWidth = cacheHeight = -1;
        cacheIndex = -1;
    }

    String getName() {
        String string = this.classinfo.name;
        int index = string.lastIndexOf('.');
        if (index is -1)
            return string;
        return string.substring(index + 1, string.length);
    }

    public String toString() {

        String hAlign = ""; //$NON-NLS-1$
        switch (horizontalAlignment) {
        case DWT.FILL:
            hAlign = "DWT.FILL"; //$NON-NLS-1$
            break;
        case DWT.BEGINNING:
            hAlign = "DWT.BEGINNING"; //$NON-NLS-1$
            break;
        case DWT.LEFT:
            hAlign = "DWT.LEFT"; //$NON-NLS-1$
            break;
        case DWT.END:
            hAlign = "DWT.END"; //$NON-NLS-1$
            break;
        case END:
            hAlign = "GridData.END"; //$NON-NLS-1$
            break;
        case DWT.RIGHT:
            hAlign = "DWT.RIGHT"; //$NON-NLS-1$
            break;
        case DWT.CENTER:
            hAlign = "DWT.CENTER"; //$NON-NLS-1$
            break;
        case CENTER:
            hAlign = "GridData.CENTER"; //$NON-NLS-1$
            break;
        default:
            hAlign = "Undefined " ~ Integer.toString(horizontalAlignment); //$NON-NLS-1$
            break;
        }
        String vAlign = ""; //$NON-NLS-1$
        switch (verticalAlignment) {
        case DWT.FILL:
            vAlign = "DWT.FILL"; //$NON-NLS-1$
            break;
        case DWT.BEGINNING:
            vAlign = "DWT.BEGINNING"; //$NON-NLS-1$
            break;
        case DWT.TOP:
            vAlign = "DWT.TOP"; //$NON-NLS-1$
            break;
        case DWT.END:
            vAlign = "DWT.END"; //$NON-NLS-1$
            break;
        case END:
            vAlign = "GridData.END"; //$NON-NLS-1$
            break;
        case DWT.BOTTOM:
            vAlign = "DWT.BOTTOM"; //$NON-NLS-1$
            break;
        case DWT.CENTER:
            vAlign = "DWT.CENTER"; //$NON-NLS-1$
            break;
        case CENTER:
            vAlign = "GridData.CENTER"; //$NON-NLS-1$
            break;
        default:
            vAlign = "Undefined " ~ Integer.toString(verticalAlignment); //$NON-NLS-1$
            break;
        }
        String string = getName() ~ " {"; //$NON-NLS-1$
        string ~= "horizontalAlignment=" ~ hAlign ~ " "; //$NON-NLS-1$ //$NON-NLS-2$
        if (horizontalIndent !is 0)
            string ~= "horizontalIndent=" ~ Integer.toString(horizontalIndent) ~ " "; //$NON-NLS-1$ //$NON-NLS-2$
        if (horizontalSpan !is 1)
            string ~= "horizontalSpan=" ~ Integer.toString(horizontalSpan) ~ " "; //$NON-NLS-1$//$NON-NLS-2$
        if (grabExcessHorizontalSpace)
            string ~= "grabExcessHorizontalSpace=" ~ Integer.toString(grabExcessHorizontalSpace) //$NON-NLS-1$
                    ~ " "; //$NON-NLS-1$
        if (widthHint !is DWT.DEFAULT)
            string ~= "widthHint=" ~ Integer.toString(widthHint) ~ " "; //$NON-NLS-1$ //$NON-NLS-2$
        string ~= "verticalAlignment=" ~ vAlign ~ " "; //$NON-NLS-1$ //$NON-NLS-2$
        if (verticalSpan !is 1)
            string ~= "verticalSpan=" ~ Integer.toString(verticalSpan) ~ " "; //$NON-NLS-1$ //$NON-NLS-2$
        if (grabExcessVerticalSpace)
            string ~= "grabExcessVerticalSpace=" ~ Integer.toString(grabExcessVerticalSpace) //$NON-NLS-1$
                    ~ " "; //$NON-NLS-1$
        if (heightHint !is DWT.DEFAULT)
            string ~= "heightHint=" ~ Integer.toString(heightHint) ~ " "; //$NON-NLS-1$ //$NON-NLS-2$
        string = string.trim();
        string ~= "}"; //$NON-NLS-1$
        return string;

    }

}
