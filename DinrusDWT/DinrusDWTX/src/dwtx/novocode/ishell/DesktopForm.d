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

module dwtx.novocode.ishell.DesktopForm;

import dwt.DWT;
import dwt.graphics.Color;
import dwt.graphics.Rectangle;
import dwt.widgets.Composite;
import dwt.widgets.Control;
import dwt.widgets.Display;
import dwt.widgets.Event;
import dwt.widgets.Listener;
import dwt.widgets.Shell;

import dwtx.novocode.ishell.internal.DesktopListener;
import dwtx.novocode.ishell.InternalShell;

import tango.core.Array;


/**
 * A desktop which manages internal shells.
 *
 * @author Stefan Zeiger (szeiger@novocode.com)
 * @since Jan 21, 2005
 * @version $Id: DesktopForm.java 344 2005-07-09 22:37:51 +0000 (Sat, 09 Jul 2005) szeiger $
 */

class DesktopForm : Composite
{
    private static const InternalShell[] EMPTY_INTERNALSHELL_ARRAY/** = new InternalShell[0]*/;
    private static const int FIRST_SHELL_LOCATION = 32;
    private static const int SHELL_LOCATION_OFFSET = 16;

    private InternalShell activeShell;
    private DesktopListener[] desktopListeners;
    private InternalShell[] allShells;
    private InternalShell[] visibleShells;
    private int nextShellLocation = FIRST_SHELL_LOCATION;
    private bool showMaximizedTitle;
    private bool autoMaximize = true;
    private bool enableCtrlTab = true;
    private bool allowDeactivate;
    private Shell shell;
    private InternalShell ishell;
    private Listener mouseDownFilter, focusInFilter, traverseFilter;


    this(Composite parent, int style)
    {
        super(parent, style);
        Display display = getDisplay();
        shell = getShell();

        Color bg = display.getSystemColor(DWT.COLOR_TITLE_INACTIVE_BACKGROUND);
        setBackground(bg);
        int brightness = bg.getRed() + bg.getGreen() + bg.getBlue();
        setForeground(display.getSystemColor(brightness > 400 ? DWT.COLOR_BLACK : DWT.COLOR_WHITE));

        addListener(DWT.Resize, dgListener(&onResize));

        mouseDownFilter = dgListener(&onMouseDownFilter);
        focusInFilter = dgListener(&onFocusInFilter);
        traverseFilter = dgListener(&onTraverseFilter);

        display.addFilter(DWT.MouseDown, mouseDownFilter);
        display.addFilter(DWT.FocusIn, focusInFilter);
        display.addFilter(DWT.Traverse, traverseFilter);

        addListener(DWT.Dispose, dgListener(&onDispose));
    }


    private void onResize(Event event)
    {
        Rectangle ca = getClientArea();
        foreach(c; getChildren())
        {
            if(cast(InternalShell)c !is null)
                (cast(InternalShell)c).desktopResized(ca);
        }
    }


    private void onMouseDownFilter(Event event)
    {
        if(!(cast(Control)event.widget !is null)) return;
        Control c = cast(Control)event.widget;
        if(c.getShell() !is shell) return;
        bool[] desktopHit = new bool[1];
        InternalShell ishell = getInternalShell(c, desktopHit);
        if(desktopHit[0] && allowDeactivate) activate(null);
        if(ishell is null) return;
        activate(ishell);
    }


    private void onFocusInFilter(Event event)
    {
        if(!(cast(Control)event.widget !is null)) return;
        Control c = cast(Control)event.widget;
        if(c.getShell() !is shell) return;
        bool[] desktopHit = new bool[1];
        ishell = getInternalShell(c, desktopHit);
        if(desktopHit[0] && allowDeactivate) activate(null);
        if(ishell is null) return;
        ishell.focusControl = c;
    }


    private void onTraverseFilter(Event event)
    {
        if(!enableCtrlTab) return;
        if(!event.doit) return; // don't steal traverse event if a control wants to handle it directly
        if((event.stateMask & DWT.CTRL) is 0) return;
        if(event.detail !is DWT.TRAVERSE_TAB_NEXT && event.detail !is DWT.TRAVERSE_TAB_PREVIOUS) return;
        if(!(cast(Control)event.widget !is null)) return;
        Control c = cast(Control)event.widget;
        if(c.getShell() !is shell) return;
        bool[] desktopHit = new bool[1];
        InternalShell ishell = getInternalShell(c, desktopHit);
        if(ishell !is null || desktopHit[0])
        {
            if(event.detail is DWT.TRAVERSE_TAB_NEXT) activateNextShell();
            else activatePreviousShell();
            event.doit = false;
        }
    }


    private void onDispose(Event event)
    {
        display.removeFilter(DWT.MouseDown, mouseDownFilter);
        display.removeFilter(DWT.FocusIn, focusInFilter);
        display.removeFilter(DWT.Traverse, traverseFilter);
    }


    void manage(InternalShell ishell)
    {
        Rectangle bounds = getBounds();
        if(nextShellLocation > bounds.height-100 || nextShellLocation > bounds.width-100)
            nextShellLocation = FIRST_SHELL_LOCATION;
        ishell.setLocation(bounds.x+nextShellLocation, bounds.y+nextShellLocation);
        nextShellLocation += SHELL_LOCATION_OFFSET;

        ishell.addListener(DWT.Dispose, dgListener(&onIshellDispose));
        allShells ~= ishell;
        if(ishell.isVisible()) visibleShells ~= ishell;
        notifyDesktopListenersCreate(ishell);
    }


    private void onIshellDispose(Event event)
    {
        allShells.remove(ishell);
        visibleShells.remove(ishell);
        if(ishell is activeShell)
        {
            activateTopmostVisibleShellExcept(ishell);
            if(autoMaximize && !hasVisibleMaximizedShell())
                setAllVisibleMaximized(false);
        }
        notifyDesktopListenersDispose(ishell);
    }


    private InternalShell activateTopmostVisibleShellExcept(InternalShell except)
    {
        Control[] children = getChildren();
        for(int i=0; i<children.length; i++)
        {
            Control c = children[i];
            if(c is except) continue;
            if(cast(InternalShell)c !is null && c.isVisible())
            {
                InternalShell ishell = cast(InternalShell)c;
                activate(ishell);
                return ishell;
            }
        }
        activeShell = null;
        notifyDesktopListenersActivate(null);
        return null;
    }


    void activate(InternalShell ishell)
    {
        if(ishell is activeShell) return;
        checkWidget();
        if(ishell !is null)
        {
            if(!ishell.isVisible()) ishell.setVisible(true);
            if((ishell.getStyle() & DWT.ON_TOP) !is 0)
                ishell.moveAbove(null);
            else
            {
                InternalShell firstRegular = getTopmostRegularShell();
                if(firstRegular !is null && firstRegular !is ishell) ishell.moveAbove(firstRegular);
                else
                {
                    Control[] children = getChildren();
                    if(children.length > 0) ishell.moveAbove(children[0]);
                }
            }
        }
        InternalShell oldActiveShell = activeShell;
        activeShell = ishell;
        if(oldActiveShell !is null) oldActiveShell.redrawDecorationsAfterActivityChange();
        if(ishell !is null)
        {
            if(activeShell.isVisible()) activeShell.redrawDecorationsAfterActivityChange();
            setTabList(/**new Control[] { activeShell }*/[ activeShell ]);
            activeShell.setFocus();
        }
        else
        {
            setTabList(/**new Control[] {}*/[]);
            forceFocus();
        }
        notifyDesktopListenersActivate(ishell);
    }


    private InternalShell getTopmostRegularShell()
    {
        foreach(c; getChildren())
        {
            if(!(cast(InternalShell)c !is null)) continue;
            if((c.getStyle() & DWT.ON_TOP) is 0) return cast(InternalShell)c;
        }
        return null;
    }


    private InternalShell getBottommostOnTopShell()
    {
        Control[] ch = getChildren();
        for(int i=ch.length-1; i>=0; i--)
        {
            Control c = ch[i];
            if(!(cast(InternalShell)c !is null)) continue;
            if((c.getStyle() & DWT.ON_TOP) !is 0) return cast(InternalShell)c;
        }
        return null;
    }


    void shellVisibilityChanged(InternalShell ishell, bool visible)
    {
        if(visible)
        {
            if(!contains(visibleShells, ishell))
            {
                visibleShells ~= ishell;
                if(autoMaximize && !ishell.getMaximized() && (ishell.getStyle() & DWT.MAX) !is 0 && hasVisibleMaximizedShell())
                    ishell.setMaximizedWithoutNotification(true);
            }
            if(ishell.getMaximized())
                ishell.desktopResized(getClientArea());
        }
        else
        {
            visibleShells.remove(ishell);
            if(ishell is activeShell)
            {
                activateTopmostVisibleShellExcept(ishell);
                if(autoMaximize && !hasVisibleMaximizedShell())
                    setAllVisibleMaximized(false);
            }
        }
    }


    private InternalShell getInternalShell(Control c, bool[] desktopHit)
    {
        while(c !is null && c !is /**DesktopForm.*/this)
        {
            if(cast(InternalShell)c !is null && (cast(InternalShell)c).getParent() is this)
                return cast(InternalShell)c;
            c = c.getParent();
        }
        if(desktopHit !is null && c is /**DesktopForm.*/this) desktopHit[0] = true;
        return null;
    }


    public InternalShell getActiveShell()
    {
        return activeShell;
    }


    public InternalShell[] getVisibleShells()
    {
        checkWidget();
        return visibleShells;
    }


    public InternalShell[] getShells()
    {
        checkWidget();
        return allShells;
    }


    public void setShowMaximizedTitle(bool b)
    {
        checkWidget();
        showMaximizedTitle = b;
        Rectangle ca = getClientArea();
        foreach(c; getChildren())
        {
            if(cast(InternalShell)c !is null)
                (cast(InternalShell)c).desktopResized(ca);
        }
    }


    public bool getShowMaximizedTitle()
    {
        checkWidget();
        return showMaximizedTitle;
    }


    public void setAutoMaximize(bool b)
    {
        checkWidget();
        autoMaximize = b;
        bool hasMax = false;
        foreach(ins; visibleShells)
        {
            if(ins.getMaximized())
            {
                hasMax = true;
                break;
            }
        }
        if(hasMax)
        {
            // Maximize all shells
            foreach(ins; visibleShells)
            {
                if((ins.getStyle() & DWT.MAX) !is 0) ins.setMaximized(true);
            }
        }
    }


    public bool getAutoMaximize()
    {
        checkWidget();
        return autoMaximize;
    }


    public void setEnableCtrlTab(bool b)
    {
        checkWidget();
        this.enableCtrlTab = b;
    }


    public bool getEnableCtrlTab()
    {
        return enableCtrlTab;
    }


    public void setAllowDeactivate(bool b)
    {
        checkWidget();
        this.allowDeactivate = b;
        if(!allowDeactivate && activeShell is null)
            activateTopmostVisibleShellExcept(null);
    }


    public bool getAllowDeactivate()
    {
        return allowDeactivate;
    }


    void shellMaximizedOrRestored(InternalShell ishell, bool maximized)
    {
        setAllVisibleMaximized(maximized);
    }


    private void setAllVisibleMaximized(bool maximized)
    {
        if(autoMaximize) // maximize or restore all shells
        {
            foreach(c; getChildren())
            {
                if(cast(InternalShell)c !is null)
                {
                    InternalShell ishell = cast(InternalShell)c;
                    if((ishell.getStyle() & DWT.MAX) !is 0 && ishell.isVisible())
                        (cast(InternalShell)c).setMaximizedWithoutNotification(maximized);
                }
            }
        }
    }


    private void activateNextShell()
    {
        if(activeShell is null)
        {
            activateTopmostVisibleShellExcept(null);
            return;
        }
        if(visibleShells.length < 2) return;
        InternalShell topReg = getTopmostRegularShell();
        InternalShell botTop = getBottommostOnTopShell();
        if((activeShell.getStyle() & DWT.ON_TOP) !is 0)
        {
            activeShell.moveBelow(botTop);
            if(topReg !is null) activate(topReg);
            else activateTopmostVisibleShellExcept(null);
        }
        else
        {
            activeShell.moveBelow(null);
            activateTopmostVisibleShellExcept(null);
        }
    }


    private void activatePreviousShell()
    {
        if(activeShell is null)
        {
            activateTopmostVisibleShellExcept(null);
            return;
        }
        if(visibleShells.length < 2) return;
        InternalShell topReg = getTopmostRegularShell();
        InternalShell botTop = getBottommostOnTopShell();
        if(activeShell is topReg && botTop !is null) activate(botTop);
        else
        {
            Control[] ch = getChildren();
            for(int i=ch.length-1; i>=0; i--)
            {
                if(cast(InternalShell)ch[i] !is null && ch[i].isVisible())
                {
                    activate(cast(InternalShell)ch[i]);
                    break;
                }
            }
        }
    }


    public void addDesktopListener(DesktopListener l)
    {
        desktopListeners ~= l;
    }


    public void removeDesktopListener(DesktopListener l)
    {
        desktopListeners.remove(l);
    }


    private void notifyDesktopListenersCreate(InternalShell ishell)
    {
        Event event = new Event();
        event.widget = ishell;
        foreach(l; desktopListeners) l.shellCreated(event);
    }


    private void notifyDesktopListenersDispose(InternalShell ishell)
    {
        Event event = new Event();
        event.widget = ishell;
        foreach(l; desktopListeners) l.shellDisposed(event);
    }


    private void notifyDesktopListenersActivate(InternalShell ishell)
    {
        Event event = new Event();
        event.widget = ishell;
        foreach(l; desktopListeners) l.shellActivated(event);
    }


    private bool hasVisibleMaximizedShell()
    {
        foreach(ins; visibleShells)
            if(ins.getMaximized()) return true;
        return false;
    }
}
