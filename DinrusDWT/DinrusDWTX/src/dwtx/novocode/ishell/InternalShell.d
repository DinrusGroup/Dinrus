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

module dwtx.novocode.ishell.InternalShell;

import dwt.dwthelper.utils;
import dwt.DWT;
import dwt.DWTException;
import dwt.graphics.Image;
import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwt.layout.FormAttachment;
import dwt.layout.FormData;
import dwt.layout.FormLayout;
import dwt.widgets.Composite;
import dwt.widgets.Control;
import dwt.widgets.Event;
import dwt.widgets.Listener;
import dwt.widgets.Menu;

import dwtx.novocode.SizeBorder;
import dwtx.novocode.SizeGrip;
import dwtx.novocode.ishell.DesktopForm;
import dwtx.novocode.ishell.internal.TitleBar;
import dwtx.novocode.ishell.internal.TitleBarButton;


/**
 * An internal shell which can be placed on a DesktopForm.
 * <p>
 * <dl>
 * <dt><b>Styles:</b></dt>
 * <dd>RESIZE, CLOSE, MAX, ON_TOP, TOOL, NO_RADIO_GROUP</dd>
 * <dt><b>Events:</b></dt>
 * <dd>(none)</dd>
 * </dl>
 * </p>
 *
 * @author Stefan Zeiger (szeiger@novocode.com)
 * @since Jan 21, 2005
 * @version $Id: InternalShell.java 344 2005-07-09 22:37:51 +0000 (Sat, 09 Jul 2005) szeiger $
 */

// [TODO] Support styles NO_TRIM, BORDER, TITLE
// [TODO] Separate "minimized" from "not visible"

class InternalShell : Composite
{
    private static const int BORDER_SIZE = 4;

    private Composite contentPane;
    private TitleBar titleBar;
    private SizeGrip sizeGrip;
    private SizeBorder sizeBorder;
    private int minWidth = 112;
    private int minHeight;
    private DesktopForm desktop;
    private bool maximized;
    private Rectangle pluralizedBounds;
    private int titleHeight;
    private int style;
    private TitleBarButton closeButton, maxButton, minButton;

    Control focusControl;


    this(DesktopForm parent, int style)
    {
        super(parent, checkStyle(style));
        this.desktop = parent;
        this.style = style;
        setBackground(getDisplay().getSystemColor(DWT.COLOR_WIDGET_BACKGROUND));
        FormLayout layout = new FormLayout();
        setLayout(layout);
        FormData fd;

        titleBar = new TitleBar(this, style & (DWT.CLOSE | DWT.RESIZE | DWT.MAX | DWT.TOOL | DWT.MIN));
        titleHeight = titleBar.computeSize(DWT.DEFAULT, DWT.DEFAULT, true).y;

        Control leftButton = null;

        if((style & (DWT.CLOSE | DWT.MAX | DWT.MIN)) !is 0)
        {
            closeButton = new TitleBarButton(this, DWT.CLOSE);
            if((style & DWT.CLOSE) is 0) closeButton.setEnabled(false);
            closeButton.addListener(DWT.Selection, dgListener(&closeListener));
            fd = new FormData(titleHeight, titleHeight);
            if(leftButton !is null) fd.right = new FormAttachment(leftButton);
            else fd.right = new FormAttachment(100, -BORDER_SIZE);
            fd.top = new FormAttachment(0, BORDER_SIZE);
            closeButton.setLayoutData(fd);
            leftButton = closeButton;

            if((style & (DWT.MAX|DWT.MIN)) !is 0)
            {
                maxButton = new TitleBarButton(this, DWT.MAX);
                if((style & DWT.MAX) is 0) maxButton.setEnabled(false);
                maxButton.addListener(DWT.Selection, dgListener(&maximizeListener));
                fd = new FormData(titleHeight, titleHeight);
                if(leftButton !is null) fd.right = new FormAttachment(leftButton);
                else fd.right = new FormAttachment(100, -BORDER_SIZE);
                fd.top = new FormAttachment(0, BORDER_SIZE);
                maxButton.setLayoutData(fd);
                leftButton = maxButton;

                minButton = new TitleBarButton(this, DWT.MIN);
                if((style & DWT.MIN) is 0) minButton.setEnabled(false);
                minButton.addListener(DWT.Selection, dgListener(&minimizeListener));
                fd = new FormData(titleHeight, titleHeight);
                if(leftButton !is null) fd.right = new FormAttachment(leftButton);
                else fd.right = new FormAttachment(100, -BORDER_SIZE);
                fd.top = new FormAttachment(0, BORDER_SIZE);
                minButton.setLayoutData(fd);
                leftButton = minButton;
            }
        }

        fd = new FormData();
        fd.left = new FormAttachment(0, BORDER_SIZE);
        if(leftButton !is null) fd.right = new FormAttachment(leftButton);
        else fd.right = new FormAttachment(100, -BORDER_SIZE);
        fd.top = new FormAttachment(0, BORDER_SIZE);
        titleBar.setLayoutData(fd);

        contentPane = new Composite(this, DWT.NONE);
        fd = new FormData();
        fd.left = new FormAttachment(0, BORDER_SIZE);
        fd.right = new FormAttachment(100, -BORDER_SIZE);
        fd.top = new FormAttachment(titleBar, 1);
        fd.bottom = new FormAttachment(100, -BORDER_SIZE);
        contentPane.setLayoutData(fd);

        sizeBorder = new SizeBorder(this, this, DWT.BORDER);
        sizeBorder.setBorderWidth(BORDER_SIZE);
        fd = new FormData();
        fd.left = new FormAttachment(0);
        fd.right = new FormAttachment(100);
        fd.top = new FormAttachment(0);
        fd.bottom = new FormAttachment(100);
        sizeBorder.setLayoutData(fd);

        minHeight = titleHeight + 2*BORDER_SIZE;
        sizeBorder.setMinimumShellSize(minWidth, minHeight);
        sizeBorder.setCornerSize(titleHeight + BORDER_SIZE);
        if((style & DWT.RESIZE) is 0) sizeBorder.setEnabled(false);

        setSize(320, 240);
        setVisible(false);

        desktop.manage(this);
    }


    private void closeListener(Event event)
    {
        close();
    }


    private void maximizeListener(Event event)
    {
        setMaximized(!maximized);
    }


    private void minimizeListener(Event event)
    {
        setMinimized(true);
    }


    private static int checkStyle(int style)
    {
        int mask = DWT.NO_RADIO_GROUP;
        style &= mask;
        return style;
    }


    public int getStyle()
    {
        return style;
    }


    public Composite getContentPane() { return contentPane; }


    public void setText(String s) { titleBar.setText(s); }

    public String getText() { return titleBar.getText(); }


    public void setCustomMenu(Menu menu) { titleBar.setMenu(menu); }

    public Menu getCustomMenu() { return titleBar.getMenu(); }


    public void setImage(Image image) { titleBar.setImage(image); }

    public Image getImage() { return titleBar.getImage(); }


    public void createSizeGrip(int style)
    {
        checkWidget();
        if(sizeGrip !is null)
            throw new DWTException("SizeGrip was already created");
        if((this.style & DWT.RESIZE) is 0)
            throw new DWTException("Cannot create SizeGrip for InternalShell without style RESIZE");
        sizeGrip = new SizeGrip(this, this, style);
        sizeGrip.setBackground(contentPane.getBackground());
        sizeGrip.moveAbove(contentPane);
        FormData fd = new FormData();
        fd.right = new FormAttachment(100, -BORDER_SIZE);
        fd.bottom = new FormAttachment(100, -BORDER_SIZE);
        sizeGrip.setLayoutData(fd);
        sizeGrip.setMinimumShellSize(minWidth, minHeight);
        if(isVisible()) layout(true);
    }


    public Point computeSize(int wHint, int hHint, bool changed)
    {
        Point p = super.computeSize(wHint, hHint, changed);
        if(p.x < minWidth) p.x = minWidth;
        if(p.y < minHeight) p.y = minHeight;
        return p;
    }


    public void setSize(int width, int height)
    {
        if(width < minWidth) width = minWidth;
        if(height < minHeight) height = minHeight;
        super.setSize(width, height);
    }


    public void setBounds(int x, int y, int width, int height)
    {
        if(width < minWidth) width = minWidth;
        if(height < minHeight) height = minHeight;
        super.setBounds(x, y, width, height);
    }


    public void setMinimumSize(int width, int height)
    {
        checkWidget();
        minWidth = width;
        minHeight = height;
        sizeGrip.setMinimumShellSize(minWidth, minHeight);
        sizeBorder.setMinimumShellSize(minWidth, minHeight);
        Point size = getSize();
        if(size.x < minWidth || size.y < minHeight)
            setSize(Math.max(minWidth, size.x), Math.max(minHeight, size.y));
    }


    public void close()
    {
        Event event = new Event();
        notifyListeners(DWT.Close, event);
        if(event.doit && !isDisposed()) dispose();
    }


    public void open()
    {
        desktop.activate(this);
        setVisible(true);
        setFocus();
    }


    public void setVisible(bool visible)
    {
        if(!visible) desktop.shellVisibilityChanged(this, false);
        super.setVisible(visible);
        if(visible) desktop.shellVisibilityChanged(this, true);
    }


    public void setActive()
    {
        desktop.activate(this);
    }


    public void setMaximized(bool maximized)
    {
        checkWidget();
        if(this.maximized is maximized) return;
        setMaximizedWithoutNotification(maximized);
        desktop.shellMaximizedOrRestored(this, maximized);
    }


    public void setMinimized(bool minimized)
    {
        checkWidget();
        bool wasMaximized = maximized;
        setVisible(!minimized);
        maximized = wasMaximized;
    }


    public bool getMinimized()
    {
        return getVisible();
    }


    void setMaximizedWithoutNotification(bool maximized)
    {
        if(this.maximized is maximized) return;
        this.maximized = maximized;
        if(maximized)
        {
            pluralizedBounds = getBounds();
            desktopResized(desktop.getClientArea());
        }
        else
        {
            setBounds(pluralizedBounds.x,pluralizedBounds.y,pluralizedBounds.width,pluralizedBounds.height);
        }
        // Note: This method may be called in a Dispose event for this object
        if(sizeGrip !is null && !sizeGrip.isDisposed()) sizeGrip.setVisible(!maximized);
        if(!sizeBorder.isDisposed()) sizeBorder.setEnabled(!maximized && (style & DWT.RESIZE) !is 0);
        if(maxButton !is null && !maxButton.isDisposed()) maxButton.redraw();
    }


    public bool getMaximized()
    {
        checkWidget();
        return maximized;
    }


    void redrawDecorationsAfterActivityChange()
    {
        // Note: This method may be called in a Dispose event for this object
        if(!titleBar.isDisposed()) titleBar.redraw();
        if(closeButton !is null && !closeButton.isDisposed()) closeButton.redraw();
        if(maxButton !is null && !maxButton.isDisposed()) maxButton.redraw();
        if(minButton !is null && !minButton.isDisposed()) minButton.redraw();
    }


    void desktopResized(Rectangle deskCA)
    {
        if(maximized)
        {
            int hideTitle = desktop.getShowMaximizedTitle() ? 0 : (titleHeight+1);
            setBounds(deskCA.x - BORDER_SIZE,
                    deskCA.y - BORDER_SIZE - hideTitle,
                    deskCA.width + 2*BORDER_SIZE,
                    deskCA.height + 2*BORDER_SIZE + hideTitle);
        }
        else forceVisibleLocation(deskCA);
    }


    public bool setFocus()
    {
        if(focusControl !is null && focusControl !is this && !focusControl.isDisposed())
            return focusControl.setFocus();
        return super.setFocus();
    }


    public bool isActiveShell()
    {
        return desktop.getActiveShell() is this;
    }


    private void forceVisibleLocation(Rectangle deskCA)
    {
        Point p = getLocation();
        Point minGrabSize = titleBar.getMinGrabSize();
        int x = p.x, y = p.y;
        int minX = minGrabSize.x + BORDER_SIZE, minY = minGrabSize.y + BORDER_SIZE;
        x = Math.min(Math.max(x, deskCA.x+minY), deskCA.x+deskCA.width-minX);
        y = Math.min(Math.max(y, deskCA.y+minY), deskCA.y+deskCA.height-minY);
        if(x != p.x || y != p.y) setLocation(x, y);
    }
}
