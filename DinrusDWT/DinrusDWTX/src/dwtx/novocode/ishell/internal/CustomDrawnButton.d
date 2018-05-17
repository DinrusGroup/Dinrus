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

module dwtx.novocode.ishell.internal.CustomDrawnButton;

import dwt.DWT;
import dwt.graphics.Point;
import dwt.widgets.Canvas;
import dwt.widgets.Composite;
import dwt.widgets.Display;
import dwt.widgets.Event;
import dwt.widgets.Listener;


/**
 * A simple button control which needs to be subclassed to draw a specific
 * kind of button. This base class provides the event handling.
 * 
 * @author Stefan Zeiger (szeiger@novocode.com)
 * @since Jan 30, 2005
 * @version $Id: CustomDrawnButton.java 320 2005-02-26 13:37:02 +0000 (Sat, 26 Feb 2005) szeiger $
 */

class CustomDrawnButton : Canvas
{
    private bool pressed;
    private Display display;
    private bool drawnMouseIn = false;


    this(Composite parent, int style)
    {
        super(parent, style);
        this.display = getDisplay();

        addListener(DWT.Paint, dgListener(&paintListener));

        addListener(DWT.MouseDown, dgListener(&onMouseDown));

        addListener(DWT.MouseUp, dgListener(&onMouseUp));

        addListener(DWT.MouseMove, dgListener(&onMouseMove));
    }


    private void paintListener(Event event)
    {
        bool mouseIn = mouseIn();
        onPaint(event, pressed && mouseIn);
        drawnMouseIn = mouseIn;
    }


    private void onMouseDown(Event event)
    {
        if(event.button is 1)
        {
            pressed = true;
            redraw();
        }
        else if(event.button is 3 && (event.stateMask & DWT.BUTTON1) !is 0) // chord click
        {
            pressed = false;
            redraw();
        }
    }


    private void onMouseUp(Event event)
    {
        if(pressed && (event.stateMask & DWT.BUTTON1) !is 0)
        {
            pressed = false;
            if(mouseIn())
            {
                Event selectionEvent = new Event();
                notifyListeners(DWT.Selection, selectionEvent);
            }
            if(!isDisposed()) redraw();
        }
    }


    private void onMouseMove(Event event)
    {
        if(!pressed) return;
        bool mouseIn = mouseIn();
        if(mouseIn is drawnMouseIn) return;
        redraw();
    }


    private bool mouseIn()
    {
        Point p = toControl(display.getCursorLocation());
        if(p.x < -1 || p.y < -1) return false;
        Point size = getSize();
        return p.x <= size.x+1 && p.y <= size.y+1;
    }


    public Point computeSize(int wHint, int hHint, bool changed)
    {
        checkWidget();
        if(wHint is DWT.DEFAULT) wHint = 0;
        if(hHint is DWT.DEFAULT) hHint = 0;
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


    protected abstract void onPaint(Event event, bool pressed);
}
