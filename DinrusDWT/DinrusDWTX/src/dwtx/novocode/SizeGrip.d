/*******************************************************************************
 * Copyright (c) 2004 Stefan Zeiger and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.novocode.com/legal/epl-v10.html
 *
 * Contributors:
 *     Stefan Zeiger (szeiger@novocode.com) - initial API and implementation
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/
/++
+ This code was take from http://www.novocode.com/swt/
+/
module dwtx.novocode.SizeGrip;

import dwt.dwthelper.utils;
import dwt.dwthelper.Runnable;
import dwtx.dwtxhelper.Timer;
import dwtx.dwtxhelper.TimerTask;

import dwt.DWT;
import dwt.graphics.Color;
import dwt.graphics.Cursor;
import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwt.widgets.Canvas;
import dwt.widgets.Composite;
import dwt.widgets.Display;
import dwt.widgets.Event;
import dwt.widgets.Listener;
import dwt.widgets.Shell;


/**
 * A non-native size grip which looks (and almost feels) like the native Win32 size grip.
 * <p>
 * The SHADOW_IN style causes highlight lines to be drawn at the right and bottom border.
 * This style should be used when placing the size grip on top of the bottom right corner
 * of a FramedComposite with style SHADOW_IN. If the FLAT style is set, the size grip is
 * drawn in a Windows XP style instead of the normal Windows Classic style.
 * </p><p>
 * <dl>
 * <dt><b>Styles:</b></dt>
 * <dd>SHADOW_IN, FLAT</dd>
 * <dt><b>Events:</b></dt>
 * <dd>(none)</dd>
 * </dl>
 * </p><p>
 * NOTE: The visibility of this widget is controlled by the "maximized" state of the
 * shell. The size grip is hidden when the shell is maximized, even if it has been made
 * visible by calling <code>setVisible(true)</code>. getVisible() always returns
 * the value set with setVisible(). isVisible() returns the true visibility, as usual.
 * </p>
 *
 * <p>New in 1.6: Smoother resizing for a more native look &amp; feel. The window size is
 * not updated more than once every 25ms to reduce the number of unnecessary repaints.</p>
 *
 * <p>New in 1.8: You can specify a parent Composite other than the shell which will be
 * resized by the SizeGrip.</p>
 *
 * @author Stefan Zeiger (szeiger@novocode.com)
 * @since Mar 8, 2004
 * @version $Id: SizeGrip.java,v 1.9 2005/01/24 21:52:14 szeiger Exp $
 */

public final class SizeGrip : Canvas
{
    private static const int WIDTH  = 13;
    private static const int HEIGHT = 13;
    private static const long UPDATE_DELAY = 25;

    private int mouseDownOffsetX, mouseDownOffsetY, snapBackX, snapBackY;
    private bool cancelled;
    private Cursor sizeCursor;
    private Point minSize;
    private bool userVisible = true;
    private /+volatile+/ long lastUpdate;
    private Timer timer;
    private TimerTask timerTask;
    private Composite resizableParent;


    public this(Composite parent, int style)
    {
        this(parent, parent.getShell(), style);
    }

    private void onDispose( Event e ){
        if(sizeCursor !is null) {
            sizeCursor.dispose();
            sizeCursor = null;
        }
    }
    private void onPaint( Event event ){
        Rectangle r = getClientArea();
        if(r.width is 0 || r.height is 0) return;

        Display disp = getDisplay();
        Color shadow = disp.getSystemColor(DWT.COLOR_WIDGET_NORMAL_SHADOW);
        Color highlight = disp.getSystemColor(DWT.COLOR_WIDGET_HIGHLIGHT_SHADOW);



        event.gc.setLineWidth(1);

        if((getStyle() & DWT.FLAT) !is 0) {
            event.gc.setBackground(highlight);
            event.gc.fillRectangle(r.width-3, r.height-3, 2, 2);
            event.gc.fillRectangle(r.width-7, r.height-3, 2, 2);
            event.gc.fillRectangle(r.width-11, r.height-3, 2, 2);
            event.gc.fillRectangle(r.width-3, r.height-7, 2, 2);
            event.gc.fillRectangle(r.width-7, r.height-7, 2, 2);
            event.gc.fillRectangle(r.width-3, r.height-11, 2, 2);
            event.gc.setBackground(shadow);
            event.gc.fillRectangle(r.width-4, r.height-4, 2, 2);
            event.gc.fillRectangle(r.width-8, r.height-4, 2, 2);
            event.gc.fillRectangle(r.width-12, r.height-4, 2, 2);
            event.gc.fillRectangle(r.width-4, r.height-8, 2, 2);
            event.gc.fillRectangle(r.width-8, r.height-8, 2, 2);
            event.gc.fillRectangle(r.width-4, r.height-12, 2, 2);
            event.gc.setForeground(highlight);
        }
        else {
            event.gc.setForeground(shadow);
            event.gc.drawLine(r.width-3, r.height-2, r.width-2, r.height-3);
            event.gc.drawLine(r.width-4, r.height-2, r.width-2, r.height-4);
            event.gc.drawLine(r.width-7, r.height-2, r.width-2, r.height-7);
            event.gc.drawLine(r.width-8, r.height-2, r.width-2, r.height-8);
            event.gc.drawLine(r.width-11, r.height-2, r.width-2, r.height-11);
            event.gc.drawLine(r.width-12, r.height-2, r.width-2, r.height-12);

            event.gc.setForeground(highlight);
            event.gc.drawLine(r.width-5, r.height-2, r.width-2, r.height-5);
            event.gc.drawLine(r.width-9, r.height-2, r.width-2, r.height-9);
            event.gc.drawLine(r.width-13, r.height-2, r.width-2, r.height-13);
        }

        if((getStyle() & DWT.SHADOW_IN) !is 0) {
            if(event.width > WIDTH) event.gc.drawLine(0, r.height-1, r.width-14, r.height-1);
            if(event.height > HEIGHT) event.gc.drawLine(r.width-1, 0, r.width-1, r.height-14);
        }
    }
    private void onMouseDown( Event event ){
        if(event.button is 1) {
            mouseDownOffsetX = event.x;
            mouseDownOffsetY = event.y;
            Point p = resizableParent.getSize();
            snapBackX = p.x;
            snapBackY = p.y;
            cancelled = false;
            //System.out.println("x="+mouseDownOffsetX+", y="+mouseDownOffsetY);
        }
        else if(event.button is 3 && (event.stateMask & DWT.BUTTON1) !is 0) // chord click
        {
            if(snapBackX > 0 && snapBackY > 0)
            {
                resizableParent.setSize(snapBackX, snapBackY);
                snapBackX = 0;
                snapBackY = 0;
                cancelled = true;
            }
        }
    }
    private void onMouseMove( Event event ){
        if(!cancelled && (event.stateMask & DWT.BUTTON1) !is 0)
        {
            if(timerTask !is null)
            {
                timerTask.cancel();
                timerTask = null;
            }
            long now = System.currentTimeMillis();

            long lastUpdate_;
            synchronized(this){
                lastUpdate_ = lastUpdate;
            }

            if(lastUpdate_ + UPDATE_DELAY < now)
            {
                performResize(event);

                synchronized(this){
                    lastUpdate = now;
                }

            }
            else
            {
                timerTask = new class() TimerTask
                {
                    public void run()
                    {
                        TimerTask executingTask = this;
                        event.display.asyncExec( dgRunnable( (Event event_, TimerTask executingTask_ )
                            {
                                if(executingTask_ !is timerTask) return;
                                performResize(event_);
                            }, event, executingTask ));
                    }
                };
                timer.schedule(timerTask, UPDATE_DELAY);
            }
        }
    }
    private void onMouseUp( Event event ){
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

    public this(Composite parent, Composite resizableParent_, int style)
    {
        super(parent, style = checkStyle (style));
        this.timer = new Timer(true);
        this.resizableParent = resizableParent_;
        setSize(WIDTH, HEIGHT);

        sizeCursor = new Cursor(getDisplay(), DWT.CURSOR_SIZENWSE);
        setCursor(sizeCursor);

        addListener(DWT.Dispose, dgListener( &onDispose ));
        addListener(DWT.Paint, dgListener( &onPaint ));
        addListener(DWT.MouseDown, dgListener( &onMouseDown ));
        addListener(DWT.MouseMove, dgListener( &onMouseMove ));
        addListener(DWT.MouseUp, dgListener( &onMouseUp ));

        Listener resizeListener = ( null !is cast(Shell)resizableParent) ? dgListener( &onResize ) : null;

        if(resizeListener !is null) resizableParent.addListener(DWT.Resize, resizeListener);

        addListener(DWT.Dispose, dgListener( &onDisposeResizeListener, resizeListener ));

        updateVisibility();
    }

    private void onDisposeResizeListener(Event event, Listener resizeListener ) {
        timer.cancel();
        if(resizeListener !is null) resizableParent.removeListener(DWT.Resize, resizeListener);
    }
    private void onResize( Event event ){
        updateVisibility();
    }

    private void performResize(Event event)
    {
        // Make sure we stay within the container parent's client area
        Rectangle ca;
        if(cast(Shell)resizableParent ) ca = getDisplay().getClientArea();
        else ca = getDisplay().map(resizableParent.getParent(), null, resizableParent.getParent().getClientArea());
        Point limit = toControl(ca.x + ca.width - 1, ca.y + ca.height - 1);
        event.x = Math.min(event.x, limit.x);
        event.y = Math.min(event.y, limit.y);

        Point p = resizableParent.getSize();
        int newX = p.x + event.x - mouseDownOffsetX;
        int newY = p.y + event.y - mouseDownOffsetY;
        if(minSize !is null)
        {
            newX = Math.max(minSize.x, newX);
            newY = Math.max(minSize.y, newY);
        }
        if(newX !is p.x || newY !is p.y) resizableParent.setSize(newX, newY);
    }


    private void updateVisibility()
    {
        if( auto shell = cast(Shell)resizableParent )
        {
            bool vis = super.getVisible();
            bool max = shell.getMaximized();
            bool newVis = userVisible && !max;
            if(vis !is newVis) super.setVisible(newVis);
        }
        else if(userVisible !is super.getVisible()) super.setVisible(userVisible);
    }


    public Point computeSize(int wHint, int hHint, bool changed)
    {
        checkWidget();
        if(wHint is DWT.DEFAULT) wHint = WIDTH;
        if(hHint is DWT.DEFAULT) hHint = HEIGHT;
        return new Point(wHint, hHint);
    }


    private static int checkStyle(int style)
    {
        int mask = DWT.SHADOW_IN | DWT.FLAT;
        style &= mask;
        return style;
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


    public bool getVisible()
    {
        checkWidget();
        return userVisible;
    }


    public void setVisible(bool visible)
    {
        checkWidget();
        userVisible = visible;
        updateVisibility();
    }
}
