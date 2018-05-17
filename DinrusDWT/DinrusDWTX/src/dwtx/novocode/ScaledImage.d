/*******************************************************************************
 * Copyright (c) 2004 Stefan Zeiger and others.
 * All rights reserved. This program and the accompanying materials 
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.novocode.com/legal/epl-v10.html
 * 
 * Contributors:
 *     Stefan Zeiger (szeiger@novocode.com) - initial API and implementation
 *     IBM Corporation - original SWT CLabel implementation on which this class is based
 *******************************************************************************/

module dwtx.novocode.ScaledImage;

import dwt.DWT;
import dwt.graphics.Color;
import dwt.graphics.GC;
import dwt.graphics.Image;
import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwt.widgets.Canvas;
import dwt.widgets.Composite;
import dwt.widgets.Event;
import dwt.widgets.Listener;


/**
 * An image / gradient component. Under development.
 *
 * @author Stefan Zeiger (szeiger@novocode.com)
 * @since Mar 21, 2005
 * @version $Id: ScaledImage.java 346 2005-07-11 20:15:57 +0000 (Mon, 11 Jul 2005) szeiger $
 */

class ScaledImage : Canvas
{
    private const Rectangle DEFAULT_BOUNDS;

    public static const int IMAGE_PLACEMENT_STRETCH = 0;
    public static const int IMAGE_PLACEMENT_TILE    = 1;

    private Image image;

    private Color[] gradientColors;

    private int[] gradientPercents;

    private bool gradientVertical;

    private int imagePlacement = IMAGE_PLACEMENT_STRETCH;


    this(Composite parent, int style)
    {
        super(parent, style | DWT.NO_BACKGROUND);
        this.DEFAULT_BOUNDS = new Rectangle(0, 0, 32, 32);

        addListener(DWT.Paint, dgListener(&onPaint));
    }


    private void onPaint(Event event)
    {
        Rectangle rect = getClientArea();
        GC gc = event.gc;
        if(image is null
                || image.getImageData().getTransparencyType() !is DWT.TRANSPARENCY_NONE)
        {

            if(gradientColors !is null)
            {
                // draw a gradient behind the text
                Color oldBackground = gc.getBackground();
                if(gradientColors.length is 1)
                {
                    if(gradientColors[0] !is null) gc.setBackground(gradientColors[0]);
                    gc.fillRectangle(0, 0, rect.width, rect.height);
                }
                else
                {
                    Color oldForeground = gc.getForeground();
                    Color lastColor = gradientColors[0];
                    if(lastColor is null) lastColor = oldBackground;
                    int pos = 0;
                    for(int i = 0; i < gradientPercents.length; ++i)
                    {
                        gc.setForeground(lastColor);
                        lastColor = gradientColors[i + 1];
                        if(lastColor is null) lastColor = oldBackground;
                        gc.setBackground(lastColor);
                        if(gradientVertical)
                        {
                            int gradientHeight = (gradientPercents[i] * rect.height / 100)
                                - pos;
                            gc.fillGradientRectangle(0, pos, rect.width, gradientHeight,
                                    true);
                            pos += gradientHeight;
                        }
                        else
                        {
                            int gradientWidth = (gradientPercents[i] * rect.width / 100)
                                - pos;
                            gc.fillGradientRectangle(pos, 0, gradientWidth, rect.height,
                                    false);
                            pos += gradientWidth;
                        }
                    }
                    if(gradientVertical && pos < rect.height)
                    {
                        gc.setBackground(getBackground());
                        gc.fillRectangle(0, pos, rect.width, rect.height - pos);
                    }
                    if(!gradientVertical && pos < rect.width)
                    {
                        gc.setBackground(getBackground());
                        gc.fillRectangle(pos, 0, rect.width - pos, rect.height);
                    }
                    gc.setForeground(oldForeground);
                }
                gc.setBackground(oldBackground);
            }
            else
            {
                if((getStyle() & DWT.NO_BACKGROUND) !is 0)
                {
                    gc.setBackground(getBackground());
                    gc.fillRectangle(rect);
                }
            }

        }
        if(image !is null)
        {
            Rectangle ib = image.getBounds();
            if(imagePlacement is IMAGE_PLACEMENT_TILE)
            {
                int maxStartX = rect.x + rect.width;
                int maxStartY = rect.y + rect.height;
                for(int x = rect.x; x < maxStartX; x += ib.width)
                    for(int y = rect.y; y < maxStartY; y += ib.height)
                        event.gc.drawImage(image, x, y);
            }
            else // IMAGE_PLACEMENT_STRETCH
            {
                event.gc.drawImage(image, ib.x, ib.y, ib.width, ib.height, rect.x,
                        rect.y, rect.width, rect.height);
            }
        }
    }


    public void setImage(Image image)
    {
        this.image = image;
        redraw();
    }


    public void setImagePlacement(int imagePlacement)
    {
        this.imagePlacement = imagePlacement;
        redraw();
    }


    public Point computeSize(int wHint, int hHint, bool changed)
    {
        checkWidget();
        Rectangle ib = image !is null ? image.getBounds() : DEFAULT_BOUNDS;
        if(wHint == DWT.DEFAULT) wHint = ib.width;
        if(hHint == DWT.DEFAULT) hHint = ib.height;
        return new Point(wHint, hHint);
    }


    public void setBackground(Color color)
    {
        super.setBackground(color);
        // Are these settings the same as before?
        if(color !is null && gradientColors is null && gradientPercents is null)
        {
            Color background = getBackground();
            if(color is background)
            {
                return;
            }
        }
        gradientColors = null;
        gradientPercents = null;
        redraw();
    }


    public void setBackground(Color[] colors, int[] percents)
    {
        setBackground(colors, percents, false);
    }


    public void setBackground(Color[] colors, int[] percents, bool vertical)
    {
        checkWidget();
        if(colors !is null)
        {
            if(percents is null || percents.length !is colors.length - 1)
            {
                DWT.error(DWT.ERROR_INVALID_ARGUMENT);
            }
            if(getDisplay().getDepth() < 15)
            {
                // Don't use gradients on low color displays
                colors = [ colors[colors.length - 1] ];
                percents = [];
            }
            for(int i = 0; i < percents.length; i++)
            {
                if(percents[i] < 0 || percents[i] > 100)
                {
                    DWT.error(DWT.ERROR_INVALID_ARGUMENT);
                }
                if(i > 0 && percents[i] < percents[i - 1])
                {
                    DWT.error(DWT.ERROR_INVALID_ARGUMENT);
                }
            }
        }

        // Are these settings the same as before?
        Color background = getBackground();
        if((gradientColors !is null) && (colors !is null)
                && (gradientColors.length is colors.length))
        {
            bool same = false;
            for(int i = 0; i < gradientColors.length; i++)
            {
                same = (gradientColors[i] is colors[i])
                    || ((gradientColors[i] is null) && (colors[i] is background))
                    || ((gradientColors[i] is background) && (colors[i] is null));
                if(!same) break;
            }
            if(same)
            {
                for(int i = 0; i < gradientPercents.length; i++)
                {
                    same = gradientPercents[i] is percents[i];
                    if(!same) break;
                }
            }
            if(same && this.gradientVertical is vertical) return;
        }
        // Store the new settings
        if(colors is null)
        {
            gradientColors = null;
            gradientPercents = null;
            gradientVertical = false;
        }
        else
        {
            gradientColors = new Color[colors.length];
            for(int i = 0; i < colors.length; ++i)
                gradientColors[i] = (colors[i] !is null) ? colors[i] : background;
            gradientPercents = new int[percents.length];
            for(int i = 0; i < percents.length; ++i)
                gradientPercents[i] = percents[i];
            gradientVertical = vertical;
        }
        // Refresh with the new settings
        redraw();
    }
}
