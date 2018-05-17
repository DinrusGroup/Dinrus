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
module dwtx.draw2d.ToolTipHelper;

import dwt.dwthelper.utils;
import dwt.dwthelper.Runnable;
import dwtx.dwtxhelper.Timer;
import dwtx.dwtxhelper.TimerTask;

import dwt.DWT;
import dwt.events.MouseTrackAdapter;
import dwt.graphics.Point;
import dwt.widgets.Display;
static import dwt.widgets.Control;
static import dwt.graphics.Rectangle;
static import dwt.events.MouseEvent;

import dwtx.draw2d.geometry.Dimension;
import dwtx.draw2d.IFigure;
import dwtx.draw2d.PopUpHelper;
import dwtx.draw2d.ColorConstants;

/**
 * This class is used by SWTEventDispatcher as support to display Figure tooltips on a
 * mouse hover event. Tooltips are drawn directly below the cursor unless the display
 * does not allow, in which case the tooltip will be drawn directly above the cursor.
 * Tooltips will be displayed with a LineBorder. The background of the tooltips will be
 * the standard DWT tooltipBackground color unless the Figure's tooltip has set its own
 * background.
 */
public class ToolTipHelper
    : PopUpHelper
{

private Timer timer;
private IFigure currentTipSource;

/**
 * Constructs a ToolTipHelper to be associated with Control <i>c</i>.
 *
 * @param c the control
 * @since 2.0
 */
public this(dwt.widgets.Control.Control c) {
    super(c, DWT.TOOL | DWT.ON_TOP);
    getShell().setBackground(ColorConstants.tooltipBackground);
    getShell().setForeground(ColorConstants.tooltipForeground);
}

/*
 * Calculates the location where the tooltip will be painted. Returns this as a Point.
 * Tooltip will be painted directly below the cursor if possible, otherwise it will be
 * painted directly above cursor.
 */
private Point computeWindowLocation(IFigure tip, int eventX, int eventY) {
    dwt.graphics.Rectangle.Rectangle clientArea = control.getDisplay().getClientArea();
    Point preferredLocation = new Point(eventX, eventY + 26);

    Dimension tipSize = getLightweightSystem()
        .getRootFigure()
        .getPreferredSize()
        .getExpanded(getShellTrimSize());

    // Adjust location if tip is going to fall outside display
    if (preferredLocation.y + tipSize.height > clientArea.height)
        preferredLocation.y = eventY - tipSize.height;

    if (preferredLocation.x + tipSize.width > clientArea.width)
        preferredLocation.x -= (preferredLocation.x + tipSize.width) - clientArea.width;

    return preferredLocation;
}

/**
 * Sets the LightWeightSystem's contents to the passed tooltip, and displays the tip. The
 * tip will be displayed only if the tip source is different than the previously viewed
 * tip source. (i.e. The cursor has moved off of the previous tooltip source figure.)
 * <p>
 * The tooltip will be painted directly below the cursor if possible, otherwise it will be
 * painted directly above cursor.
 *
 * @param hoverSource the figure over which the hover event was fired
 * @param tip the tooltip to be displayed
 * @param eventX the x coordinate of the hover event
 * @param eventY the y coordinate of the hover event
 * @since 2.0
 */
public void displayToolTipNear(IFigure hoverSource, IFigure tip, int eventX, int eventY) {
    if (tip !is null && hoverSource !is currentTipSource) {
        getLightweightSystem().setContents(tip);
        Point displayPoint = computeWindowLocation(tip, eventX, eventY);
        Dimension shellSize = getLightweightSystem().getRootFigure()
            .getPreferredSize().getExpanded(getShellTrimSize());
        setShellBounds(displayPoint.x, displayPoint.y, shellSize.width, shellSize.height);
        show();
        currentTipSource = hoverSource;
        timer = new Timer(true);
        timer.schedule(new class() TimerTask {
            public void run() {
                Display.getDefault().syncExec(dgRunnable( {
                    hide();
                    timer.cancel();
                }));
            }
        }, 5000);
    }
}

/**
 * Disposes of the tooltip's shell and kills the timer.
 *
 * @see PopUpHelper#dispose()
 */
public void dispose() {
    if (isShowing()) {
        timer.cancel();
        hide();
    }
    getShell().dispose();
}

/**
 * @see PopUpHelper#hookShellListeners()
 */
protected void hookShellListeners() {
    // Close the tooltip window if the mouse enters the tooltip
    getShell().addMouseTrackListener(new class() MouseTrackAdapter {
        public void mouseEnter(dwt.events.MouseEvent.MouseEvent e) {
            hide();
            currentTipSource = null;
            timer.cancel();
        }
    });
}

/**
 * Displays the hover source's tooltip if a tooltip of another source is currently being
 * displayed.
 *
 * @param figureUnderMouse the figure over which the cursor was when called
 * @param tip the tooltip to be displayed
 * @param eventX the x coordinate of the cursor
 * @param eventY the y coordinate of the cursor
 * @since 2.0
 */
public void updateToolTip(IFigure figureUnderMouse, IFigure tip, int eventX, int eventY) {
    /* If the cursor is not on any Figures, it has been moved
       off of the control. Hide the tool tip. */
    if (figureUnderMouse is null) {
        if (isShowing()) {
            hide();
            timer.cancel();
        }
    }
    // Makes tooltip appear without a hover event if a tip is currently being displayed
    if (isShowing() && figureUnderMouse !is currentTipSource) {
        hide();
        timer.cancel();
        displayToolTipNear(figureUnderMouse, tip, eventX, eventY);
    } else if (!isShowing() && figureUnderMouse !is currentTipSource)
        currentTipSource = null;
}

}
