/**
Original: com.novocode.naf.swt.custom.CustomSeparator
 ***/

/*******************************************************************************
 * Copyright (c) 2004 Stefan Zeiger and others.
 * All rights reserved. This program and the accompanying materials 
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.novocode.com/legal/epl-v10.html
 * 
 * Contributors:
 *     Stefan Zeiger (szeiger@novocode.com) - initial API and implementation
 *******************************************************************************/

module dwtx.novocode.CustomSeparator;

import dwt.DWT;
//import dwt.events.PaintEvent;
//import dwt.events.PaintListener;
import dwt.graphics.Color;
import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwt.widgets.Canvas;
import dwt.widgets.Composite;
import dwt.widgets.Display;
import dwt.widgets.Event;
import dwt.widgets.Listener;


/**
 * Instances of this class are non-native separator lines.
 * <dl>
 * <dt><b>Styles:</b></dt>
 * <dd>SHADOW_IN, SHADOW_OUT, SHADOW_NONE, HORIZONTAL, VERTICAL</dd>
 * <dt><b>Events:</b></dt>
 * <dd>(none)</dd>
 * </dl>
 * <p>
 * Note: Only one of SHADOW_IN, SHADOW_OUT and SHADOW_NONE may be specified.
 * If neither ist specified, the default value SHADOW_IN is used. If SHADOW_NONE
 * is specified, a single line is drawn with the control's foreground color.
 * Only one of HORIZONTAL and VERTICAL may be specified. The default is VERTICAL.
 * </p>
 *
 * @author Stefan Zeiger (szeiger@novocode.com)
 * @since Feb 12, 2004
 * @version $Id: CustomSeparator.java 199 2004-10-08 13:20:36 +0000 (Fri, 08 Oct 2004) szeiger $
 */

class CustomSeparator : Canvas
{
    private int lineSize;
    private int style;


    this(Composite parent, int style)
    {
        super(parent, style = checkStyle (style));

        this.style = style;

        if((style & DWT.SHADOW_IN) !is 0 || (style & DWT.SHADOW_OUT) !is 0) lineSize = 2;
        else lineSize = 1;

        /**addPaintListener(new class() PaintListener
          {
          public void paintControl(PaintEvent event) { onPaint(event); }
          });*/
        addListener(DWT.Paint, dgListener(&onPaint));
    }


    private int checkStyle(int style)
    {
        int mask = DWT.SHADOW_IN | DWT.SHADOW_OUT| DWT.SHADOW_NONE | DWT.HORIZONTAL | DWT.VERTICAL;
        style &= mask;
        if((style & (DWT.SHADOW_IN | DWT.SHADOW_OUT| DWT.SHADOW_NONE)) is 0) style |= DWT.SHADOW_IN;
        if((style & (DWT.HORIZONTAL | DWT.VERTICAL)) is 0) style |= DWT.VERTICAL;
        return style;
    }


    public Point computeSize(int wHint, int hHint, bool changed)
    {
        checkWidget();
        if(wHint is DWT.DEFAULT) wHint = lineSize;
        if(hHint is DWT.DEFAULT) hHint = lineSize;
        return new Point(wHint, hHint);
    }


    public bool setFocus()
    {
        checkWidget();
        return false;
    }


    private void onPaint(Event event)
    {
        Rectangle r = getClientArea();
        if(r.width is 0 || r.height is 0) return;
        bool horiz = ((style & DWT.HORIZONTAL) !is 0);
        int mid = horiz ? r.y + (r.height/2) : r.x + (r.width/2);

        Display disp = getDisplay();
        event.gc.setLineWidth(1);

        if((style & DWT.SHADOW_IN) !is 0)
        {
            Color shadow = disp.getSystemColor(DWT.COLOR_WIDGET_NORMAL_SHADOW);
            Color highlight = disp.getSystemColor(DWT.COLOR_WIDGET_HIGHLIGHT_SHADOW);
            event.gc.setForeground(shadow);
            if(horiz) event.gc.drawLine(r.x, mid-1, r.x+r.width-1, mid-1);
            else event.gc.drawLine(mid-1, r.y, mid-1, r.y+r.height-1);
            event.gc.setForeground(highlight);
            if(horiz) event.gc.drawLine(r.x, mid, r.x+r.width-1, mid);
            else event.gc.drawLine(mid, r.y, mid, r.y+r.height-1);
        }
        else if((style & DWT.SHADOW_OUT) !is 0)
        {
            Color shadow = disp.getSystemColor(DWT.COLOR_WIDGET_NORMAL_SHADOW);
            Color highlight = disp.getSystemColor(DWT.COLOR_WIDGET_HIGHLIGHT_SHADOW);
            event.gc.setForeground(highlight);
            if(horiz) event.gc.drawLine(r.x, mid-1, r.x+r.width-1, mid-1);
            else event.gc.drawLine(mid-1, r.y, mid-1, r.y+r.height-1);
            event.gc.setForeground(shadow);
            if(horiz) event.gc.drawLine(r.x, mid, r.x+r.width-1, mid);
            else event.gc.drawLine(mid, r.y, mid, r.y+r.height-1);
        }
        else
        {
            event.gc.setForeground(getForeground());
            if(horiz) event.gc.drawLine(r.x, mid, r.x+r.width-1, mid);
            else event.gc.drawLine(mid, r.y, mid, r.y+r.height-1);
        }
    }
}
