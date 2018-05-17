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
module dwtx.draw2d.BorderLayout;

import dwt.dwthelper.utils;

import dwtx.draw2d.geometry.Dimension;
import dwtx.draw2d.geometry.Insets;
import dwtx.draw2d.geometry.Rectangle;
import dwtx.draw2d.AbstractHintLayout;
import dwtx.draw2d.IFigure;
import dwtx.draw2d.PositionConstants;

/**
 * @author Pratik Shah
 */
public class BorderLayout
    : AbstractHintLayout
{

/**
 * Constant to be used as a constraint for child figures
 */
private static Integer CENTER_;
public static Integer CENTER(){
    if( !initStaticCtor_done ) initStaticCtor();
    return CENTER_;
}
/**
 * Constant to be used as a constraint for child figures
 */
private static Integer TOP_;
public static Integer TOP(){
    if( !initStaticCtor_done ) initStaticCtor();
    return TOP_;
}
/**
 * Constant to be used as a constraint for child figures
 */
private static Integer BOTTOM_;
public static Integer BOTTOM(){
    if( !initStaticCtor_done ) initStaticCtor();
    return BOTTOM_;
}
/**
 * Constant to be used as a constraint for child figures
 */
private static Integer LEFT_;
public static Integer LEFT(){
    if( !initStaticCtor_done ) initStaticCtor();
    return LEFT_;
}
/**
 * Constant to be used as a constraint for child figures
 */
private static Integer RIGHT_;
public static Integer RIGHT(){
    if( !initStaticCtor_done ) initStaticCtor();
    return RIGHT_;
}

private static bool initStaticCtor_done = false;
private static void initStaticCtor(){
    synchronized( BorderLayout.classinfo ){
        if( !initStaticCtor_done ){
            CENTER_ = new Integer(PositionConstants.CENTER);
            TOP_ = new Integer(PositionConstants.TOP);
            BOTTOM_ = new Integer(PositionConstants.BOTTOM);
            LEFT_ = new Integer(PositionConstants.LEFT);
            RIGHT_ = new Integer(PositionConstants.RIGHT);
            initStaticCtor_done = true;
        }
    }
}

private IFigure center, left, top, bottom, right;
private int vGap = 0, hGap = 0;

/**
 * @see dwtx.draw2d.AbstractHintLayout#calculateMinimumSize(IFigure, int, int)
 */
protected Dimension calculateMinimumSize(IFigure container, int wHint, int hHint) {
    int minWHint = 0, minHHint = 0;
    if (wHint < 0) {
        minWHint = -1;
    }
    if (hHint < 0) {
        minHHint = -1;
    }
    Insets border = container.getInsets();
    wHint = Math.max(minWHint, wHint - border.getWidth());
    hHint = Math.max(minHHint, hHint - border.getHeight());
    Dimension minSize = new Dimension();
    int middleRowWidth = 0, middleRowHeight = 0;
    int rows = 0, columns = 0;

    if (top !is null  && top.isVisible()) {
        Dimension childSize = top.getMinimumSize(wHint, hHint);
        hHint = Math.max(minHHint, hHint - (childSize.height + vGap));
        minSize.setSize(childSize);
        rows += 1;
    }
    if (bottom !is null && bottom.isVisible()) {
        Dimension childSize = bottom.getMinimumSize(wHint, hHint);
        hHint = Math.max(minHHint, hHint - (childSize.height + vGap));
        minSize.width = Math.max(minSize.width, childSize.width);
        minSize.height += childSize.height;
        rows += 1;
    }
    if (left !is null && left.isVisible()) {
        Dimension childSize = left.getMinimumSize(wHint, hHint);
        middleRowWidth = childSize.width;
        middleRowHeight = childSize.height;
        wHint = Math.max(minWHint, wHint - (childSize.width + hGap));
        columns += 1;
    }
    if (right !is null  && right.isVisible()) {
        Dimension childSize = right.getMinimumSize(wHint, hHint);
        middleRowWidth += childSize.width;
        middleRowHeight = Math.max(childSize.height, middleRowHeight);
        wHint = Math.max(minWHint, wHint - (childSize.width + hGap));
        columns += 1;
    }
    if (center !is null && center.isVisible()) {
        Dimension childSize = center.getMinimumSize(wHint, hHint);
        middleRowWidth += childSize.width;
        middleRowHeight = Math.max(childSize.height, middleRowHeight);
        columns += 1;
    }

    rows += columns > 0 ? 1 : 0;
    // Add spacing, insets, and the size of the middle row
    minSize.height += middleRowHeight + border.getHeight() + ((rows - 1) * vGap);
    minSize.width = Math.max(minSize.width, middleRowWidth) + border.getWidth()
                    + ((columns - 1) * hGap);

    return minSize;
}

/**
 * @see AbstractLayout#calculatePreferredSize(IFigure, int, int)
 */
protected Dimension calculatePreferredSize(IFigure container, int wHint, int hHint) {
    int minWHint = 0, minHHint = 0;
    if (wHint < 0)
        minWHint = -1;

    if (hHint < 0)
        minHHint = -1;

    Insets border = container.getInsets();
    wHint = Math.max(minWHint, wHint - border.getWidth());
    hHint = Math.max(minHHint, hHint - border.getHeight());
    Dimension prefSize = new Dimension();
    int middleRowWidth = 0, middleRowHeight = 0;
    int rows = 0, columns = 0;

    if (top !is null && top.isVisible()) {
        Dimension childSize = top.getPreferredSize(wHint, hHint);
        hHint = Math.max(minHHint, hHint - (childSize.height + vGap));
        prefSize.setSize(childSize);
        rows += 1;
    }
    if (bottom !is null && bottom.isVisible()) {
        Dimension childSize = bottom.getPreferredSize(wHint, hHint);
        hHint = Math.max(minHHint, hHint - (childSize.height + vGap));
        prefSize.width = Math.max(prefSize.width, childSize.width);
        prefSize.height += childSize.height;
        rows += 1;
    }
    if (left !is null && left.isVisible()) {
        Dimension childSize = left.getPreferredSize(wHint, hHint);
        middleRowWidth = childSize.width;
        middleRowHeight = childSize.height;
        wHint = Math.max(minWHint, wHint - (childSize.width + hGap));
        columns += 1;
    }
    if (right !is null && right.isVisible()) {
        Dimension childSize = right.getPreferredSize(wHint, hHint);
        middleRowWidth += childSize.width;
        middleRowHeight = Math.max(childSize.height, middleRowHeight);
        wHint = Math.max(minWHint, wHint - (childSize.width + hGap));
        columns += 1;
    }
    if (center !is null && center.isVisible()) {
        Dimension childSize = center.getPreferredSize(wHint, hHint);
        middleRowWidth += childSize.width;
        middleRowHeight = Math.max(childSize.height, middleRowHeight);
        columns += 1;
    }

    rows += columns > 0 ? 1 : 0;
    // Add spacing, insets, and the size of the middle row
    prefSize.height += middleRowHeight + border.getHeight() + ((rows - 1) * vGap);
    prefSize.width = Math.max(prefSize.width, middleRowWidth) + border.getWidth()
                    + ((columns - 1) * hGap);

    return prefSize;
}

/**
 * @see dwtx.draw2d.LayoutManager#layout(IFigure)
 */
public void layout(IFigure container) {
    Rectangle area = container.getClientArea();
    Rectangle rect = new Rectangle();

    Dimension childSize;

    if (top !is null && top.isVisible()) {
        childSize = top.getPreferredSize(area.width, -1);
        rect.setLocation(area.x, area.y);
        rect.setSize(childSize);
        rect.width = area.width;
        top.setBounds(rect);
        area.y += rect.height + vGap;
        area.height -= rect.height + vGap;
    }
    if (bottom !is null && bottom.isVisible()) {
        childSize = bottom.getPreferredSize(Math.max(area.width, 0), -1);
        rect.setSize(childSize);
        rect.width = area.width;
        rect.setLocation(area.x, area.y + area.height - rect.height);
        bottom.setBounds(rect);
        area.height -= rect.height + vGap;
    }
    if (left !is null && left.isVisible()) {
        childSize = left.getPreferredSize(-1, Math.max(0, area.height));
        rect.setLocation(area.x, area.y);
        rect.width = childSize.width;
        rect.height = Math.max(0, area.height);
        left.setBounds(rect);
        area.x += rect.width + hGap;
        area.width -= rect.width + hGap;
    }
    if (right !is null && right.isVisible()) {
        childSize = right.getPreferredSize(-1, Math.max(0, area.height));
        rect.width = childSize.width;
        rect.height = Math.max(0, area.height);
        rect.setLocation(area.x + area.width - rect.width, area.y);
        right.setBounds(rect);
        area.width -= rect.width + hGap;
    }
    if (center !is null && center.isVisible()) {
        if (area.width < 0)
            area.width = 0;
        if (area.height < 0)
            area.height = 0;
        center.setBounds(area);
    }
}

/**
 * @see dwtx.draw2d.AbstractLayout#remove(IFigure)
 */
public void remove(IFigure child) {
    if (center is child) {
        center = null;
    } else if (top is child) {
        top = null;
    } else if (bottom is child) {
        bottom = null;
    } else if (right is child) {
        right = null;
    } else if (left is child) {
        left = null;
    }
}

/**
 * Sets the location of hte given child in this layout.  Valid constraints:
 * <UL>
 *      <LI>{@link #CENTER}</LI>
 *      <LI>{@link #TOP}</LI>
 *      <LI>{@link #BOTTOM}</LI>
 *      <LI>{@link #LEFT}</LI>
 *      <LI>{@link #RIGHT}</LI>
 *      <LI><code>null</code> (to remove a child's constraint)</LI>
 * </UL>
 *
 * <p>
 * Ensure that the given Figure is indeed a child of the Figure on which this layout has
 * been set.  Proper behaviour cannot be guaranteed if that is not the case.  Also ensure
 * that every child has a valid constraint.
 * </p>
 * <p>
 * Passing a <code>null</code> constraint will invoke {@link #remove(IFigure)}.
 * </p>
 * <p>
 * If the given child was assigned another constraint earlier, it will be re-assigned to
 * the new constraint.  If there is another child with the given constraint, it will be
 * over-ridden so that the given child now has that constraint.
 * </p>
 *
 * @see dwtx.draw2d.AbstractLayout#setConstraint(IFigure, Object)
 */
public void setConstraint(IFigure child, Object constraint) {
    remove(child);
    super.setConstraint(child, constraint);
    if (constraint is null) {
        return;
    }

    switch ((cast(Integer) constraint).intValue()) {
        case PositionConstants.CENTER :
            center = child;
            break;
        case PositionConstants.TOP :
            top = child;
            break;
        case PositionConstants.BOTTOM :
            bottom = child;
            break;
        case PositionConstants.RIGHT :
            right = child;
            break;
        case PositionConstants.LEFT :
            left = child;
            break;
        default :
            break;
    }
}

/**
 * Sets the horizontal spacing to be used between the children.  Default is 0.
 *
 * @param gap The horizonal spacing
 */
public void setHorizontalSpacing(int gap) {
    hGap = gap;
}

/**
 * Sets the vertical spacing ot be used between the children.  Default is 0.
 *
 * @param gap The vertical spacing
 */
public void setVerticalSpacing(int gap) {
    vGap = gap;
}

}
