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

module dwtx.novocode.ishell.internal.TitleBarButton;

import dwt.DWT;
import dwt.graphics.Color;
import dwt.graphics.GC;
import dwt.graphics.Point;
import dwt.widgets.Display;
import dwt.widgets.Event;
import dwt.widgets.Listener;
import dwt.widgets.Shell;

import dwtx.novocode.ishell.InternalShell;
import dwtx.novocode.ishell.internal.CustomDrawnButton;


/**
 * A title bar button for an InternalShell.
 *
 * @author Stefan Zeiger (szeiger@novocode.com)
 * @since Jan 30, 2005
 * @version $Id: TitleBarButton.java 322 2005-02-26 20:31:26 +0000 (Sat, 26 Feb 2005) szeiger $
 */

class TitleBarButton : CustomDrawnButton
{
    private Color highlightShadowColor, lightShadowColor, normalShadowColor, darkShadowColor;
    private Color gradEndColor, inactiveGradEndColor, widgetBackgroundColor, widgetForegroundColor;
    private int style;
    private Shell shell;
    private Display display;
    private InternalShell ishell;
    private int leftOff, rightOff;
    private Listener activateListener, deactivateListener;

    this(InternalShell parent, int style)
    {
        super(parent, DWT.NO_FOCUS | DWT.NO_BACKGROUND);
        this.style = style;
        this.shell = getShell();
        this.display = getDisplay();
        this.ishell = parent;

        highlightShadowColor = display.getSystemColor(DWT.COLOR_WIDGET_HIGHLIGHT_SHADOW);
        lightShadowColor = display.getSystemColor(DWT.COLOR_WIDGET_LIGHT_SHADOW);
        normalShadowColor = display.getSystemColor(DWT.COLOR_WIDGET_NORMAL_SHADOW);
        darkShadowColor = display.getSystemColor(DWT.COLOR_WIDGET_DARK_SHADOW);
        gradEndColor = display.getSystemColor(DWT.COLOR_TITLE_BACKGROUND_GRADIENT);
        inactiveGradEndColor = display.getSystemColor(DWT.COLOR_TITLE_INACTIVE_BACKGROUND_GRADIENT);
        widgetBackgroundColor = display.getSystemColor(DWT.COLOR_WIDGET_BACKGROUND);
        widgetForegroundColor = display.getSystemColor(DWT.COLOR_WIDGET_FOREGROUND);

        if((style & (DWT.CLOSE | DWT.MAX)) !is 0) rightOff = 2;
        else leftOff = 2;

        activateListener = dgListener(&onActivateListener);
        deactivateListener = dgListener(&onDeactivateListener);
        shell.addListener(DWT.Activate, activateListener);
        shell.addListener(DWT.Deactivate, deactivateListener);

        addListener(DWT.Dispose, dgListener(&onDispose));
    }


    private void onActivateListener(Event event)
    {
        redraw();
    }


    private void onDeactivateListener(Event event)
    {
        redraw();
    }


    private void onDispose(Event event)
    {
        shell.removeListener(DWT.Activate, activateListener);
        shell.removeListener(DWT.Deactivate, deactivateListener);
    }


    public int getStyle()
    {
        return style;
    }


    protected void onPaint(Event event, bool pressed)
    {
        Point size = getSize();
        bool active = (shell is display.getActiveShell() && ishell.isActiveShell());
        GC gc = event.gc;

        gc.setBackground(active ? gradEndColor : inactiveGradEndColor);
        gc.fillRectangle(0, 0, size.x, size.y);
        gc.setBackground(widgetBackgroundColor);
        gc.fillRectangle(2, 4, size.x-4, size.y-6);

        Color tloColor, tliColor, broColor, briColor;
        int pOff;
        if(pressed)
        {
            tloColor = darkShadowColor;
            tliColor = normalShadowColor;
            broColor = highlightShadowColor;
            briColor = lightShadowColor;
            pOff = 1;
        }
        else
        {
            tloColor = highlightShadowColor;
            tliColor = lightShadowColor;
            broColor = darkShadowColor;
            briColor = normalShadowColor;
            pOff = 0;
        }

        drawBevelRect(gc, leftOff, 2, size.x-1-leftOff-rightOff, size.y-5, tloColor, broColor);
        drawBevelRect(gc, 1+leftOff, 3, size.x-3-leftOff-rightOff, size.y-7, tliColor, briColor);

        if(isEnabled())
        {
            gc.setForeground(widgetForegroundColor);
            drawImage(gc, size, pOff);
        }
        else
        {
            gc.setForeground(highlightShadowColor);
            drawImage(gc, size, 1);
            gc.setForeground(normalShadowColor);
            drawImage(gc, size, 0);
        }
    }


    private void drawImage(GC gc, Point size, int pOff)
    {
        if((style & DWT.CLOSE) !is 0) drawCloseImage(gc, size, pOff);
        else if((style & DWT.MAX) !is 0)
        {
            if(ishell.getMaximized()) drawRestoreImage(gc, size, pOff);
            else drawMaximizeImage(gc, size, pOff);
        }
        else if((style & DWT.MIN) !is 0) drawMinimizeImage(gc, size, pOff);
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


    private void drawCloseImage(GC gc, Point size, int pOff)
    {
        gc.drawLine(pOff+leftOff+4, pOff+5, pOff+size.x-leftOff-rightOff-6, pOff+size.y-7);
        gc.drawLine(pOff+leftOff+5, pOff+5, pOff+size.x-leftOff-rightOff-5, pOff+size.y-7);
        gc.drawLine(pOff+leftOff+4, pOff+size.y-7, pOff+size.x-leftOff-rightOff-6, pOff+5);
        gc.drawLine(pOff+leftOff+5, pOff+size.y-7, pOff+size.x-leftOff-rightOff-5, pOff+5);
    }


    private void drawRestoreImage(GC gc, Point size, int pOff)
    {
        gc.drawRectangle(pOff+leftOff+3, pOff+7, size.x-leftOff-rightOff-11, size.y-13);
        gc.drawLine(pOff+leftOff+4, pOff+8, pOff+size.x-leftOff-rightOff-9, pOff+8);
        gc.drawLine(pOff+leftOff+6, pOff+5, pOff+size.x-leftOff-rightOff-7, pOff+5);
        gc.drawLine(pOff+leftOff+5, pOff+4, pOff+size.x-leftOff-rightOff-6, pOff+4);
        gc.drawLine(pOff+size.x-leftOff-rightOff-7, pOff+size.y-9, pOff+size.x-leftOff-rightOff-6, pOff+size.y-9);
        gc.drawLine(pOff+size.x-leftOff-rightOff-6, pOff+size.y-10, pOff+size.x-leftOff-rightOff-6, pOff+5);
        gc.drawLine(pOff+leftOff+5, pOff+5, pOff+leftOff+5, pOff+6);
    }


    private void drawMaximizeImage(GC gc, Point size, int pOff)
    {
        gc.drawRectangle(pOff+leftOff+3, pOff+4, size.x-leftOff-rightOff-8, size.y-10);
        gc.drawLine(pOff+leftOff+4, pOff+5, pOff+size.x-leftOff-rightOff-6, pOff+5);
    }


    private void drawMinimizeImage(GC gc, Point size, int pOff)
    {
        gc.drawLine(pOff+leftOff+4, pOff+size.y-6, pOff+size.x-leftOff-rightOff-5, pOff+size.y-6);
        gc.drawLine(pOff+leftOff+4, pOff+size.y-7, pOff+size.x-leftOff-rightOff-5, pOff+size.y-7);
    }
}
