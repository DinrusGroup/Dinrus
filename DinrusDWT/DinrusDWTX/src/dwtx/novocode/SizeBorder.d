/*******************************************************************************
 * Copyright (c) 2005 Stefan Zeiger and others.
 * All rights reserved. This program and the accompanying materials 
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.novocode.com/legal/epl-v10.html
 * 
 * Contributors:
 *     Stefan Zeiger (szeiger@novocode.com) - initial API and implementation
 *******************************************************************************/

module dwtx.novocode.SizeBorder;

import dwt.dwthelper.utils;
import dwt.dwthelper.Runnable;
import dwtx.dwtxhelper.Timer;
import dwtx.dwtxhelper.TimerTask;

import dwt.DWT;
import dwt.graphics.Color;
import dwt.graphics.Cursor;
import dwt.graphics.GC;
import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwt.widgets.Canvas;
import dwt.widgets.Composite;
import dwt.widgets.Display;
import dwt.widgets.Event;
import dwt.widgets.Listener;
import dwt.widgets.Shell;


/**
 * A border for a resizable container. This border control usually fills the
 * entire container, with a content pane above it (not covering the actual
 * border area).
 * 
 * <p>If the style SWT.BORDER ist set, a beveled border (as used on Windows
 * Classic window decorations) will be drawn. Without this style, no drawing
 * is done.</p>
 *
 * @author Stefan Zeiger (szeiger@novocode.com)
 * @since Jan 21, 2005
 * @version $Id: SizeBorder.java 321 2005-02-26 15:44:24 +0000 (Sat, 26 Feb 2005) szeiger $
 */

class SizeBorder : Canvas
{
    private static const long UPDATE_DELAY = 25;

    private static const int AREA_NONE = 0;
    private static const int AREA_N    = 1;
    private static const int AREA_S    = 2;
    private static const int AREA_E    = 4;
    private static const int AREA_W    = 8;
    private static const int AREA_NW   = 9;
    private static const int AREA_NE   = 5;
    private static const int AREA_SE   = 6;
    private static const int AREA_SW   = 10;

    private Rectangle snapBack;
    private bool cancelled = true;
    private /**volatile*/ long lastUpdate;
    private Timer timer;
    private TimerTask timerTask;
    private Composite resizableParent;
    private Point minSize, mouseDownOffset;
    private int borderWidth = 4, cornerSize = 16;
    private Display display;
    private Cursor cursor, cursorNWSE, cursorNESW, cursorWE, cursorNS;
    private int currentArea;
    private Color highlightShadowColor, lightShadowColor, normalShadowColor,darkShadowColor;


    this(Composite parent, int style)
    {
        this(parent, parent.getShell(), style);
    }


    this(Composite parent, Composite resizableParent, int style)
    {
        super(parent, checkStyle (style));
        this.timer = new Timer(true);
        this.resizableParent = resizableParent;
        this.display = getDisplay();

        cursorNWSE = new Cursor(getDisplay(), DWT.CURSOR_SIZENWSE);
        cursorNESW = new Cursor(getDisplay(), DWT.CURSOR_SIZENESW);
        cursorWE = new Cursor(getDisplay(), DWT.CURSOR_SIZEWE);
        cursorNS = new Cursor(getDisplay(), DWT.CURSOR_SIZENS);

        addListener(DWT.Dispose, dgListener(&onDispose));

        if((style & DWT.BORDER) !is 0)
        {
            highlightShadowColor = display.getSystemColor(DWT.COLOR_WIDGET_HIGHLIGHT_SHADOW);
            lightShadowColor = display.getSystemColor(DWT.COLOR_WIDGET_LIGHT_SHADOW);
            normalShadowColor = display.getSystemColor(DWT.COLOR_WIDGET_NORMAL_SHADOW);
            darkShadowColor = display.getSystemColor(DWT.COLOR_WIDGET_DARK_SHADOW);

            addListener(DWT.Paint, dgListener(&onPaint));
        }

        addListener(DWT.MouseDown, dgListener(&onMouseDown));

        addListener(DWT.MouseMove, dgListener(&onMouseMove));

        addListener(DWT.MouseUp, dgListener(&onMouseUp));

        addListener(DWT.Show, dgListener(&onShow));
    }

    private void onDispose(Event event)
    {
        cursorNWSE.dispose();
        cursorNESW.dispose();
        cursorWE.dispose();
        cursorNS.dispose();

        timer.cancel();
    }


    private void onPaint(Event event)
    {
        Rectangle r = getClientArea();
        if(r.width is 0 || r.height is 0) return;
        drawBevelRect(event.gc, r.x, r.y, r.width-1, r.height-1, lightShadowColor, darkShadowColor);
        drawBevelRect(event.gc, r.x+1, r.y+1, r.width-3, r.height-3, highlightShadowColor, normalShadowColor);
    }


    private void onMouseDown(Event event)
    {
        if(event.button is 1)
        {
            currentArea = areaAtPoint(event.x, event.y);
            if(currentArea is AREA_NONE) return;
            if(cast(Shell)resizableParent !is null)
                mouseDownOffset = toDisplay(event.x, event.y);
            else
                mouseDownOffset = display.map(/**SizeBorder.this*/getSizeBorder(), resizableParent.getParent(), event.x, event.y);
            snapBack = resizableParent.getBounds();
            cancelled = false;
        }
        else if(event.button is 3 && (event.stateMask & DWT.BUTTON1) !is 0) // chord click
        {
            if(snapBack !is null)
            {
                resizableParent.setBounds(snapBack);
                snapBack = null;
                cancelled = true;
            }
        }
    }


    private void onMouseMove(Event event)
    {
        if((event.stateMask & DWT.BUTTON1) is 0) updateCursor(areaAtPoint(event.x, event.y));

        if(!cancelled && (event.stateMask & DWT.BUTTON1) !is 0)
        {
            if(timerTask !is null)
            {
                timerTask.cancel();
                timerTask = null;
            }
            long now = System.currentTimeMillis();
            if(lastUpdate + UPDATE_DELAY < now)
            {
                performResize(event);
                lastUpdate = now;
            }
            else
            {
                timerTask = new class() TimerTask
                {
                    public void run()
                    {
                        TimerTask executingTask = this;
                        event.display.asyncExec(new class() Runnable
                            {
                                public void run()
                                {
                                    if(executingTask !is timerTask) return;
                                    performResize(event);
                                }
                            });
                    }
                };
                timer.schedule(timerTask, UPDATE_DELAY);
            }
        }
    }


    private void onMouseUp(Event event)
    {
        if(timerTask !is null)
        {
            timerTask.cancel();
            timerTask = null;
        }
        if(!cancelled && (event.stateMask & DWT.BUTTON1) !is 0)
        {
            performResize(event);
        }
    }


    private void onShow(Event event)
    {
        Point p = toControl(display.getCursorLocation());
        updateCursor(areaAtPoint(p.x, p.y));
    }


    private SizeBorder getSizeBorder()
    {
        return this;
    }

    private static int checkStyle(int style)
    {
        //int mask = DWT.NONE;
        //style &= mask;
        style = DWT.NO_FOCUS;
        return style;
    }


    private void performResize(Event event)
    {
        // Make sure we stay within the container parent's client area
        Rectangle ca;
        if(cast(Shell)resizableParent !is null) ca = getDisplay().getClientArea();
        else ca = getDisplay().map(resizableParent.getParent(), null, resizableParent.getParent().getClientArea());
        Point caOffset = toControl(ca.x, ca.y);
        event.x = Math.max(Math.min(event.x, caOffset.x + ca.width - 1), caOffset.x);
        event.y = Math.max(Math.min(event.y, caOffset.y + ca.height - 1), caOffset.y);

        // Compute movement relative to position at MouseDown event
        Point movement = (cast(Shell)resizableParent !is null)
            ? toDisplay(event.x, event.y)
            : display.map(this, resizableParent.getParent(), event.x, event.y);
        movement.x -= mouseDownOffset.x;
        movement.y -= mouseDownOffset.y;

        // Compute new size and position
        int newW = snapBack.width, newH = snapBack.height, newX = snapBack.x, newY = snapBack.y;
        if((currentArea & AREA_E) !is 0) newW += movement.x;
        else if((currentArea & AREA_W) !is 0) { newW -= movement.x; newX += snapBack.width - newW; }
        if((currentArea & AREA_S) !is 0) newH += movement.y;
        else if((currentArea & AREA_N) !is 0) { newH -= movement.y; newY += snapBack.height - newH; }

        // Do not go below the container's minimum size
        int minW, minH;
        if(minSize !is null) { minW = minSize.x; minH = minSize.y; }
        else { minW = 0; minH = 0; }
        int maxX = snapBack.x + snapBack.width - minW;
        int maxY = snapBack.y + snapBack.height - minH;

        newW = Math.max(minW, newW);
        newH = Math.max(minH, newH);
        newX = Math.min(maxX, newX);
        newY = Math.min(maxY, newY);

        resizableParent.setBounds(newX, newY, newW, newH);
    }


    private void updateCursor(int area)
    {
        Cursor c = null;
        switch(area)
        {
            case AREA_N:  case AREA_S:  c = cursorNS;   break;
            case AREA_W:  case AREA_E:  c = cursorWE;   break;
            case AREA_NW: case AREA_SE: c = cursorNWSE; break;
            case AREA_NE: case AREA_SW: c = cursorNESW; break;
            default:
        }
        if(cursor is c) return;
        cursor = c;
        setCursor(c);
    }


    private int areaAtPoint(int x, int y)
    {
        Point size = getSize();
        if(x < borderWidth) // left edge
        {
            if(y < cornerSize) return AREA_NW;
            else if(y >= size.y-cornerSize) return AREA_SW;
            else return AREA_W;
        }
        else if(x >= size.x-borderWidth) // right edge
        {
            if(y >= size.y-cornerSize) return AREA_SE;
            else if(y < cornerSize) return AREA_NE;
            else return AREA_E;
        }
        else if(y < borderWidth) // top edge
        {
            if(x < cornerSize) return AREA_NW;
            else if(x >= size.x-cornerSize) return AREA_NE;
            else return AREA_N;
        }
        else if(y >= size.y-borderWidth) // bottom edge
        {
            if(x >= size.x-cornerSize) return AREA_SE;
            else if(x < cornerSize) return AREA_SW;
            else return AREA_S;
        }
        else return AREA_NONE;
    }


    public Point computeSize(int wHint, int hHint, bool changed)
    {
        checkWidget();
        if(wHint == DWT.DEFAULT) wHint = 0;
        if(hHint == DWT.DEFAULT) hHint = 0;
        return new Point(wHint, hHint);
    }


    public bool setFocus()
    {
        checkWidget();
        return false;
    }


    public bool isReparentable ()
    {
        checkWidget();
        return false;
    }


    /**
     * Set the allowed minimum size for the shell. The SizeGrip will
     * not resize the shell to a smaller size.
     * <p>
     * Note: This does <em>not</em> affect other ways of resizing the shell,
     * like using the size controls which are placed on the trimmings by
     * the window manager.
     * </p>
     */

    public void setMinimumShellSize(Point p)
    {
        checkWidget();
        this.minSize = p;
    }


    /**
     * Set the allowed minimum size for the shell. The SizeGrip will
     * not resize the shell to a smaller size.
     * <p>
     * Note: This does <em>not</em> affect other ways of resizing the shell,
     * like using the size controls which are placed on the trimmings by
     * the window manager.
     * </p>
     */

    public void setMinimumShellSize(int width, int height)
    {
        checkWidget();
        this.minSize = new Point(width, height);
    }


    public void setBorderWidth(int width)
    {
        checkWidget();
        borderWidth = width;
        Point p = toControl(display.getCursorLocation());
        updateCursor(areaAtPoint(p.x, p.y));
    }


    public void setCornerSize(int size)
    {
        checkWidget();
        cornerSize = size;
        Point p = toControl(display.getCursorLocation());
        updateCursor(areaAtPoint(p.x, p.y));
    }


    private static void drawBevelRect(GC gc, int x, int y, int w, int h, Color topleft, Color bottomright)
    {
        gc.setForeground(bottomright);
        gc.drawLine(x + w, y, x + w, y + h);
        gc.drawLine(x, y + h, x + w, y + h);

        gc.setForeground(topleft);
        gc.drawLine(x, y, x + w - 1, y);
        gc.drawLine(x, y, x, y + h - 1);
    }
}
