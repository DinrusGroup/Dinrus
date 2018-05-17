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

module dwtx.novocode.ishell.internal.TitleBar;

import dwt.dwthelper.utils;
import dwt.dwthelper.Runnable;
import dwtx.dwtxhelper.Timer;
import dwtx.dwtxhelper.TimerTask;

import dwt.DWT;
import dwt.graphics.Color;
import dwt.graphics.Font;
import dwt.graphics.FontData;
import dwt.graphics.GC;
import dwt.graphics.Image;
import dwt.graphics.ImageData;
import dwt.graphics.PaletteData;
import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwt.graphics.RGB;
import dwt.widgets.Canvas;
import dwt.widgets.Display;
import dwt.widgets.Event;
import dwt.widgets.Listener;
import dwt.widgets.Menu;
import dwt.widgets.MenuItem;
import dwt.widgets.Shell;

import dwtx.novocode.ishell.DesktopForm;
import dwtx.novocode.ishell.InternalShell;

import dwt.dwthelper.utils;


/**
 * A title bar for an InternalShell.
 *
 * @author Stefan Zeiger (szeiger@novocode.com)
 * @since Jan 21, 2005
 * @version $Id: TitleBar.java 342 2005-07-09 20:37:13 +0000 (Sat, 09 Jul 2005) szeiger $
 */

class TitleBar : Canvas
{
    private static const long UPDATE_DELAY = 25;
    private static const int MINIMUM_GRAB_AREA = 2;
    private static const String ELLIPSIS = "...";
    private static const int LEFT_PADDING = 2;
    private static const int RIGHT_PADDING = 2;
    private static const int IMAGE_SIZE = 16;
    private static const int TOOL_SIZE = 14;
    private static const int TOP_PADDING = 1;
    private static const int BOTTOM_PADDING = 1;

    private int mouseDownOffsetX, mouseDownOffsetY, snapBackX, snapBackY;
    private bool cancelled;
    private /**volatile*/ long lastUpdate;
    private Timer timer;
    private TimerTask timerTask;
    private InternalShell ishell;
    private DesktopForm desktop;
    private String text;
    private Image image;
    private bool styleClose, styleMax, styleTool, styleMin;
    private Image closeImage, restoreImage, maximizeImage, minimizeImage;
    private MenuItem restoreItem, closeItem, maximizeItem;
    private Menu defaultPopup;
    private Point minGrabSize;
    private Shell shell;
    private Color gradStartColor, gradEndColor, textColor, inactiveGradStartColor, inactiveGradEndColor, inactiveTextColor;
    private Listener activateListener, deactivateListener;


    this(InternalShell parent, int style)
    {
        super(parent, checkStyle(style));
        this.timer = new Timer(true);
        this.minGrabSize = new Point(MINIMUM_GRAB_AREA, MINIMUM_GRAB_AREA);
        this.ishell = parent;
        this.desktop = cast(DesktopForm)ishell.getParent();
        this.styleClose = (style & DWT.CLOSE) !is 0;
        this.styleMax = (style & DWT.MAX) !is 0;
        this.styleMin = (style & DWT.MIN) !is 0;
        this.styleTool = (style & DWT.TOOL) !is 0;

        Display display = getDisplay();
        shell = getShell();

        gradStartColor = display.getSystemColor(DWT.COLOR_TITLE_BACKGROUND);
        gradEndColor = display.getSystemColor(DWT.COLOR_TITLE_BACKGROUND_GRADIENT);
        textColor = display.getSystemColor(DWT.COLOR_TITLE_FOREGROUND);
        inactiveGradStartColor = display.getSystemColor(DWT.COLOR_TITLE_INACTIVE_BACKGROUND);
        inactiveGradEndColor = display.getSystemColor(DWT.COLOR_TITLE_INACTIVE_BACKGROUND_GRADIENT);
        inactiveTextColor = display.getSystemColor(DWT.COLOR_TITLE_INACTIVE_FOREGROUND);

        GC gc = new GC(this);
        int imgHeight = gc.getFontMetrics().getHeight()-1;
        if(imgHeight%2 is 0) imgHeight--;
        gc.dispose();

        closeImage = createMenuImage(IMAGE_TYPE_CLOSE, imgHeight);
        restoreImage = createMenuImage(IMAGE_TYPE_RESTORE, imgHeight);
        maximizeImage = createMenuImage(IMAGE_TYPE_MAXIMIZE, imgHeight);
        minimizeImage = createMenuImage(IMAGE_TYPE_MINIMIZE, imgHeight);

        setFont(createTitleFont(getFont(), styleTool));

        defaultPopup = new Menu(this);

        restoreItem = new MenuItem(defaultPopup, DWT.PUSH);
        restoreItem.setText("&Restore");
        restoreItem.setImage(restoreImage);
        restoreItem.addListener(DWT.Selection, dgListener(&restoreListener));

        MenuItem minimizeItem = new MenuItem(defaultPopup, DWT.PUSH);
        minimizeItem.setText("Mi&nimize");
        minimizeItem.setEnabled(styleMin);
        minimizeItem.setImage(minimizeImage);
        minimizeItem.addListener(DWT.Selection, dgListener(&minimizeListener));

        maximizeItem = new MenuItem(defaultPopup, DWT.PUSH);
        maximizeItem.setText("Ma&ximize");
        maximizeItem.setImage(maximizeImage);
        maximizeItem.addListener(DWT.Selection, dgListener(&maximizeListener));

        new MenuItem(defaultPopup, DWT.SEPARATOR);

        closeItem = new MenuItem(defaultPopup, DWT.PUSH);
        closeItem.setText("&Close");
        closeItem.setEnabled(styleClose);
        closeItem.setImage(closeImage);
        closeItem.addListener(DWT.Selection, dgListener(&closeListener));

        addListener(DWT.Paint, dgListener(&onPaint));
        addListener(DWT.MouseDown, dgListener(&onMouseDown));
        addListener(DWT.MenuDetect, dgListener(&onMenuDetect));
        addListener(DWT.MouseDoubleClick, dgListener(&onMouseDoubleClick));
        addListener(DWT.MouseMove, dgListener(&onMouseMove));
        addListener(DWT.MouseUp, dgListener(&onMouseUp));

        activateListener = dgListener(&onActivateListener);
        deactivateListener = dgListener(&onDeactivateListener);
        shell.addListener(DWT.Activate, activateListener);
        shell.addListener(DWT.Deactivate, deactivateListener);

        addListener(DWT.Dispose, dgListener(&onDispose));
    }


    private void restoreListener(Event event)
    {
        ishell.setMaximized(false);
    }


    private void minimizeListener(Event event)
    {
        ishell.setMinimized(true);
    }


    private void maximizeListener(Event event)
    {
        ishell.setMaximized(true);
    }


    private void closeListener(Event event)
    {
        ishell.close();
    }


    private void onPaint(Event event)
    {
        Rectangle r = getClientArea();
        if(r.width is 0 || r.height is 0) return;

        bool active = (shell is display.getActiveShell() && ishell.isActiveShell());

        GC gc = event.gc;
        gc.setForeground(active ? gradStartColor : inactiveGradStartColor);
        gc.setBackground(active ? gradEndColor : inactiveGradEndColor);
        gc.fillGradientRectangle(r.x, r.y, r.width, r.height, false);

        int textLeftPadding = LEFT_PADDING;
        if(image !is null)
        {
            Rectangle imageBounds = image.getBounds();
            if(imageBounds.width > IMAGE_SIZE || imageBounds.height > IMAGE_SIZE)
                gc.drawImage(image, 0, 0, imageBounds.width, imageBounds.height, LEFT_PADDING, TOP_PADDING, IMAGE_SIZE, IMAGE_SIZE);
            else
                gc.drawImage(image, LEFT_PADDING + (IMAGE_SIZE-imageBounds.width)/2, (r.height-imageBounds.height)/2);
            textLeftPadding += IMAGE_SIZE + LEFT_PADDING;
        }

        if(text !is null && text.length() > 0)
        {
            gc.setForeground(active ? textColor : inactiveTextColor);
            String s = text;
            int availableWidth = r.width - textLeftPadding - RIGHT_PADDING;
            if(gc.textExtent(s, DWT.DRAW_TRANSPARENT).x > availableWidth)
            {
                int ellipsisWidth = gc.textExtent(ELLIPSIS, DWT.DRAW_TRANSPARENT).x;
                while(s.length() > 0)
                {
                    s = s.substring(0, s.length()-1);
                    if(gc.textExtent(s, DWT.DRAW_TRANSPARENT).x + ellipsisWidth <= availableWidth)
                    {
                        s ~= ELLIPSIS;
                        break;
                    }
                }
                setToolTipText(text);
            }
            else setToolTipText(null);
            if(s.length() > 0) gc.drawString(s, textLeftPadding, (r.height-gc.getFontMetrics().getHeight())/2, true);
        }
        else setToolTipText(null);
    }


    private void onMouseDown(Event event)
    {
        if(event.button is 1)
        {
            if(image !is null && event.x < LEFT_PADDING + IMAGE_SIZE)
            {
                cancelled = true;
                // left-clicking on the image always shows the default popup menu
                instrumentDefaultPopup(true);
                defaultPopup.setLocation(toDisplay(0, getSize().y));
                defaultPopup.setVisible(true);
            }
            else
            {
                mouseDownOffsetX = event.x;
                mouseDownOffsetY = event.y;
                Point p = ishell.getLocation();
                snapBackX = p.x;
                snapBackY = p.y;
                cancelled = false;
            }
        }
        else if(event.button is 3)
        {
            if((event.stateMask & DWT.BUTTON1) !is 0 && snapBackX !is Integer.MIN_VALUE && snapBackY !is Integer.MIN_VALUE)
            {
                ishell.setLocation(snapBackX, snapBackY);
                snapBackX = Integer.MIN_VALUE;
                snapBackY = Integer.MIN_VALUE;
                cancelled = true;
            }
            else
            {
            }
        }
    }


    private void onMenuDetect(Event event)
    {
        event.doit = false;
        Menu m = getMenu();
        if(m is null || m.isDisposed())
        {
            m = defaultPopup;
            instrumentDefaultPopup(false);
        }
        m.setLocation(event.x, event.y);
        m.setVisible(true);
    }


    private void onMouseDoubleClick(Event event)
    {
        if(event.button is 1)
        {
            if(image !is null && event.x < LEFT_PADDING + IMAGE_SIZE)
            {
                if(styleClose) ishell.close();
            }
            else
            {
                if(styleMax) ishell.setMaximized(!ishell.getMaximized());
            }
            cancelled = true;
        }
    }


    private void onMouseMove(Event event)
    {
        if(!cancelled && (event.stateMask & DWT.BUTTON1) !is 0 && !ishell.getMaximized())
        {
            if(timerTask !is null)
            {
                timerTask.cancel();
                timerTask = null;
            }
            long now = System.currentTimeMillis();
            if(lastUpdate + UPDATE_DELAY < now)
            {
                performMove(event);
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
                                    performMove(event);
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
        if(ishell.getMaximized()) return;
        if(image is null || event.x >= LEFT_PADDING + IMAGE_SIZE)
        {
            if(timerTask !is null)
            {
                timerTask.cancel();
                timerTask = null;
            }
            if(!cancelled && (event.stateMask & DWT.BUTTON1) !is 0)
            {
                performMove(event);
            }
        }
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
        timer.cancel();
        shell.removeListener(DWT.Activate, activateListener);
        shell.removeListener(DWT.Deactivate, deactivateListener);
        closeImage.dispose();
        maximizeImage.dispose();
        restoreImage.dispose();
        minimizeImage.dispose();
        defaultPopup.dispose();
    }


    private void performMove(Event event)
    {
        Point p = ishell.getLocation();
        int newX = p.x + event.x - mouseDownOffsetX;
        int newY = p.y + event.y - mouseDownOffsetY;

        // Make sure that the minimum grab area stays visible
        Rectangle deskCA = desktop.getClientArea();
        Rectangle bounds = getBounds();
        newX = Math.min(Math.max(newX, deskCA.x-bounds.x-bounds.width+MINIMUM_GRAB_AREA), deskCA.x-bounds.x+deskCA.width-minGrabSize.x);
        newY = Math.min(Math.max(newY, deskCA.y-bounds.y-bounds.height+MINIMUM_GRAB_AREA), deskCA.y-bounds.y+deskCA.height-MINIMUM_GRAB_AREA);

        if(newX !is p.x || newY !is p.y) ishell.setLocation(newX, newY);
    }


    public Point getMinGrabSize()
    {
        return minGrabSize;
    }


    public Point computeSize(int wHint, int hHint, bool changed)
    {
        checkWidget();
        if(wHint is DWT.DEFAULT) wHint = 50;
        if(hHint is DWT.DEFAULT)
        {
            GC gc = new GC(this);
            hHint = gc.getFontMetrics().getHeight();
            hHint = Math.max(hHint, styleTool ?  TOOL_SIZE : IMAGE_SIZE);
            hHint += TOP_PADDING + BOTTOM_PADDING;
            gc.dispose();
        }
        return new Point(wHint, hHint);
    }


    private static int checkStyle(int style)
    {
        //int mask = DWT.SHADOW_IN | DWT.FLAT;
        //style &= mask;
        style = DWT.NO_FOCUS;
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


    public void setText(String text)
    {
        checkWidget();
        this.text = text;
        redraw();
    }


    public String getText() { return text; }


    public void setImage(Image image)
    {
        checkWidget();
        if(styleTool) return;
        this.image = image;
        minGrabSize.x = MINIMUM_GRAB_AREA;
        if(image !is null) minGrabSize.x += LEFT_PADDING + IMAGE_SIZE;
        redraw();
    }


    public Image getImage() { return image; }


    private Font createTitleFont(Font f, bool tool)
    {
        FontData[] fds = f.getFontData();
        foreach(fd; fds)
        {
            fd.setStyle(fd.getStyle() | DWT.BOLD);
            if(tool) fd.setHeight(cast(int)(fd.getHeight()*0.9));
        }
        return new Font(getDisplay(), fds);
    }


    private void instrumentDefaultPopup(bool onImage)
    {
        restoreItem.setEnabled(styleMax && ishell.getMaximized());
        maximizeItem.setEnabled(styleMax && !ishell.getMaximized());
        MenuItem def = null;
        if(onImage)
        {
            if(styleClose) def = closeItem;
        }
        else if(styleMax)
        {
            def = ishell.getMaximized() ? restoreItem : maximizeItem;
        }
        defaultPopup.setDefaultItem(def);
    }


    private static const int IMAGE_TYPE_CLOSE    = 1;
    private static const int IMAGE_TYPE_MAXIMIZE = 2;
    private static const int IMAGE_TYPE_RESTORE  = 3;
    private static const int IMAGE_TYPE_MINIMIZE = 4;


    private Image createMenuImage(int type, int height)
    {
        final Point size = new Point(height, height);
        final int imgWidth = height + height/2;
        final Color fg = getForeground();
        final Color white = getDisplay().getSystemColor(DWT.COLOR_WHITE);
        final RGB blackRGB = new RGB(0,0,0);

        ImageData id = new ImageData(imgWidth, size.y, 1, new PaletteData([ blackRGB, fg.getRGB() ]));
        ImageData maskid = new ImageData(imgWidth, size.y, 1, new PaletteData([ blackRGB, white.getRGB() ]));

        Image img = new Image(getDisplay(), id);
        GC gc = new GC(img);
        gc.setForeground(fg);
        drawMenuImage(gc, size, type);
        gc.dispose();

        Image maskimg = new Image(getDisplay(), maskid);
        gc = new GC(maskimg);
        gc.setForeground(white);
        drawMenuImage(gc, size, type);
        gc.dispose();

        Image transp = new Image(getDisplay(), img.getImageData(), maskimg.getImageData());
        img.dispose();
        maskimg.dispose();
        return transp;
    }


    private void drawMenuImage(GC gc, Point size, int type)
    {
        switch(type)
        {
            case IMAGE_TYPE_CLOSE:
                gc.drawLine(1, 1, size.x-2, size.y-2);
                gc.drawLine(2, 1, size.x-2, size.y-3);
                gc.drawLine(1, 2, size.x-3, size.y-2);
                gc.drawLine(1, size.y-2, size.x-2, 1);
                gc.drawLine(1, size.y-3, size.x-3, 1);
                gc.drawLine(2, size.y-2, size.x-2, 2);
                break;

            case IMAGE_TYPE_RESTORE:
                gc.drawRectangle(0, 4, size.x-4, size.y-6);
                gc.drawLine(1, 5, size.x-5, 5);
                gc.drawLine(2, 1, size.x-2, 1);
                gc.drawLine(2, 2, size.x-2, 2);
                gc.drawPoint(2, 3);
                gc.drawLine(size.x-2, 3, size.x-2, size.y-5);
                gc.drawPoint(size.x-3, size.y-5);
                break;

            case IMAGE_TYPE_MAXIMIZE:
                gc.drawRectangle(0, 0, size.x-2, size.y-2);
                gc.drawLine(1, 1, size.x-3, 1);
                break;

            case IMAGE_TYPE_MINIMIZE:
                gc.drawLine(1, size.y-2, size.x-4, size.y-2);
                gc.drawLine(1, size.y-3, size.x-4, size.y-3);
                break;
            default:
        }
    }
}
