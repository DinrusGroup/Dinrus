/*******************************************************************************
 * Copyright (c) 2000, 2007 IBM Corporation and others.
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
module dwtx.draw2d.SWTEventDispatcher;

import dwt.dwthelper.utils;

import dwt.DWT;
import dwt.accessibility.AccessibleControlEvent;
import dwt.accessibility.AccessibleControlListener;
import dwt.accessibility.AccessibleEvent;
import dwt.accessibility.AccessibleListener;
import dwt.events.DisposeEvent;
import dwt.events.TraverseEvent;
import dwt.graphics.Cursor;
import dwt.widgets.Control;
import dwtx.draw2d.EventDispatcher;
import dwtx.draw2d.IFigure;
import dwtx.draw2d.Figure;
import dwtx.draw2d.MouseEvent;
import dwtx.draw2d.FocusEvent;
import dwtx.draw2d.KeyEvent;
import dwtx.draw2d.ToolTipHelper;
static import dwt.widgets.Control;
import dwtx.draw2d.FocusTraverseManager;
static import dwt.events.FocusEvent;
static import dwt.events.KeyEvent;
static import dwt.events.MouseEvent;

/**
 * The SWTEventDispatcher provides draw2d with the ability to dispatch DWT Events. The
 * {@link dwtx.draw2d.LightweightSystem} adds DWT event listeners on its Canvas.
 * When the Canvas receives an DWT event, it calls the appropriate dispatcher method in
 * SWTEventDispatcher.
 */
public class SWTEventDispatcher
    : EventDispatcher
{

/**
 * Used to tell if any button is pressed without regard to the specific button.
 * @deprecated Use {@link DWT#BUTTON_MASK} instead.
 */
protected static const int ANY_BUTTON = DWT.BUTTON_MASK;

private bool figureTraverse = true;

private bool captured;
private IFigure root;
private IFigure mouseTarget;
private IFigure cursorTarget;
private IFigure focusOwner;
private IFigure hoverSource;

private MouseEvent currentEvent;
private Cursor cursor;
/** The control this dispatcher is listening to. */
protected dwt.widgets.Control.Control control;

private ToolTipHelper toolTipHelper;
private FocusTraverseManager focusManager;

/**
 * Implements {@link EventDispatcher.AccessibilityDispatcher} but
 * does nothing in the implementation.
 */
protected class FigureAccessibilityDispatcher
    : AccessibilityDispatcher
{
    /** @see AccessibleControlListener#getChildAtPoint(AccessibleControlEvent) */
    public void getChildAtPoint(AccessibleControlEvent e) { }
    /** @see AccessibleControlListener#getChildCount(AccessibleControlEvent) */
    public void getChildCount(AccessibleControlEvent e) { }
    /** @see AccessibleControlListener#getChildren(AccessibleControlEvent) */
    public void getChildren(AccessibleControlEvent e) { }
    /** @see AccessibleControlListener#getDefaultAction(AccessibleControlEvent) */
    public void getDefaultAction(AccessibleControlEvent e) { }
    /** @see AccessibleListener#getDescription(AccessibleEvent) */
    public void getDescription(AccessibleEvent e) { }
    /** @see AccessibleControlListener#getFocus(AccessibleControlEvent) */
    public void getFocus(AccessibleControlEvent e) { }
    /** @see AccessibleListener#getHelp(AccessibleEvent) */
    public void getHelp(AccessibleEvent e) { }
    /** @see AccessibleListener#getKeyboardShortcut(AccessibleEvent) */
    public void getKeyboardShortcut(AccessibleEvent e) { }
    /** @see AccessibleControlListener#getLocation(AccessibleControlEvent) */
    public void getLocation(AccessibleControlEvent e) { }
    /** @see AccessibleListener#getName(AccessibleEvent) */
    public void getName(AccessibleEvent e) { }
    /** @see AccessibleControlListener#getRole(AccessibleControlEvent) */
    public void getRole(AccessibleControlEvent e) { }
    /** @see AccessibleControlListener#getSelection(AccessibleControlEvent) */
    public void getSelection(AccessibleControlEvent e) { }
    /** @see AccessibleControlListener#getState(AccessibleControlEvent) */
    public void getState(AccessibleControlEvent e) { }
    /** @see AccessibleControlListener#getValue(AccessibleControlEvent) */
    public void getValue(AccessibleControlEvent e) { }
}

public this(){
    focusManager = new FocusTraverseManager();
}

/**
 * @see EventDispatcher#dispatchFocusGained(dwt.events.FocusEvent)
 */
public void dispatchFocusGained(dwt.events.FocusEvent.FocusEvent e) {
    IFigure currentFocusOwner = getFocusTraverseManager().getCurrentFocusOwner();

    /*
     * Upon focus gained, if there is no current focus owner,
     * set focus on first focusable child.
     */
    if (currentFocusOwner is null)
        currentFocusOwner =
                    getFocusTraverseManager().getNextFocusableFigure(root, focusOwner);
    setFocus(currentFocusOwner);
}

/**
 * @see EventDispatcher#dispatchFocusLost(dwt.events.FocusEvent)
 */
public void dispatchFocusLost(dwt.events.FocusEvent.FocusEvent e) {
    setFocus(null);
}

/**
 * @see EventDispatcher#dispatchKeyPressed(dwt.events.KeyEvent)
 */
public void dispatchKeyPressed(dwt.events.KeyEvent.KeyEvent e) {
    if (focusOwner !is null) {
        KeyEvent event = new KeyEvent(this, focusOwner, e);
        focusOwner.handleKeyPressed(event);
    }
}

/**
 * @see EventDispatcher#dispatchKeyReleased(dwt.events.KeyEvent)
 */
public void dispatchKeyReleased(dwt.events.KeyEvent.KeyEvent e) {
    if (focusOwner !is null) {
        KeyEvent event = new KeyEvent(this, focusOwner, e);
        focusOwner.handleKeyReleased(event);
    }
}

/**
 * @see EventDispatcher#dispatchKeyTraversed(TraverseEvent)
 */
public void dispatchKeyTraversed(TraverseEvent e) {
    if (!figureTraverse)
        return;
    IFigure nextFigure = null;

    if (e.detail is DWT.TRAVERSE_TAB_NEXT)
        nextFigure = getFocusTraverseManager().getNextFocusableFigure(root, focusOwner);
    else if (e.detail is DWT.TRAVERSE_TAB_PREVIOUS)
        nextFigure =
                getFocusTraverseManager().getPreviousFocusableFigure(root, focusOwner);

    if (nextFigure !is null) {
        e.doit = false;
        setFocus(nextFigure);
    }
}

/**
 * @see EventDispatcher#dispatchMouseHover(dwt.events.MouseEvent)
 */
public void dispatchMouseHover(dwt.events.MouseEvent.MouseEvent me) {
    receive(me);
    if (mouseTarget !is null)
        mouseTarget.handleMouseHover(currentEvent);
    /*
     * Check Tooltip source.
     * Get Tooltip source's Figure.
     * Set that tooltip as the lws contents on the helper.
     */
    if (hoverSource !is null) {
        toolTipHelper = getToolTipHelper();
        IFigure tip = hoverSource.getToolTip();
        Control control = cast(Control)me.getSource();
        dwt.graphics.Point.Point absolute;
        absolute = control.toDisplay(new dwt.graphics.Point.Point(me.x, me.y));
        toolTipHelper.displayToolTipNear(hoverSource, tip, absolute.x, absolute.y);
    }
}

/**
 * @see EventDispatcher#dispatchMouseDoubleClicked(dwt.events.MouseEvent)
 */
public void dispatchMouseDoubleClicked(dwt.events.MouseEvent.MouseEvent me) {
    receive(me);
    if (mouseTarget !is null)
        mouseTarget.handleMouseDoubleClicked(currentEvent);
}

/**
 * @see EventDispatcher#dispatchMouseEntered(dwt.events.MouseEvent)
 */
public void dispatchMouseEntered(dwt.events.MouseEvent.MouseEvent me) {
    receive(me);
}

/**
 * @see EventDispatcher#dispatchMouseExited(dwt.events.MouseEvent)
 */
public void dispatchMouseExited(dwt.events.MouseEvent.MouseEvent me) {
    setHoverSource(null, me);
    if (mouseTarget !is null) {
        currentEvent =
                new MouseEvent(me.x, me.y, this, mouseTarget, me.button, me.stateMask);
        mouseTarget.handleMouseExited(currentEvent);
        releaseCapture();
        mouseTarget = null;
    }
}

/**
 * @see EventDispatcher#dispatchMousePressed(dwt.events.MouseEvent)
 */
public void dispatchMousePressed(dwt.events.MouseEvent.MouseEvent me) {
    receive(me);
    if (mouseTarget !is null) {
        mouseTarget.handleMousePressed(currentEvent);
        if (currentEvent.isConsumed())
            setCapture(mouseTarget);
    }
}

/**
 * @see EventDispatcher#dispatchMouseMoved(dwt.events.MouseEvent)
 */
public void dispatchMouseMoved(dwt.events.MouseEvent.MouseEvent me) {
    receive(me);
    if (mouseTarget !is null) {
        if ((me.stateMask & DWT.BUTTON_MASK) !is 0)
            mouseTarget.handleMouseDragged(currentEvent);
        else
            mouseTarget.handleMouseMoved(currentEvent);
    }
}

/**
 * @see EventDispatcher#dispatchMouseReleased(dwt.events.MouseEvent)
 */
public void dispatchMouseReleased(dwt.events.MouseEvent.MouseEvent me) {
    receive(me);
    if (mouseTarget !is null) {
        mouseTarget.handleMouseReleased(currentEvent);
    }
    releaseCapture();
    receive(me);
}

/**
 * @see EventDispatcher#getAccessibilityDispatcher()
 */
protected AccessibilityDispatcher getAccessibilityDispatcher() {
    return null;
}

/**
 * Returns the current mouse event.
 * @return the current mouse event; can be <code>null</code>
 */
protected MouseEvent getCurrentEvent() {
    return currentEvent;
}

private IFigure getCurrentToolTip() {
    if (hoverSource !is null)
        return hoverSource.getToolTip();
    else
        return null;
}

/**
 * Returns the figure that the cursor is over.
 * @return the cursor target
 */
protected IFigure getCursorTarget() {
    return cursorTarget;
}

/**
 * Returns the ToolTipHelper used to display tooltips on hover events.
 * @return the ToolTipHelper
 */
protected ToolTipHelper getToolTipHelper() {
    if (toolTipHelper is null)
        toolTipHelper = new ToolTipHelper(control);
    return toolTipHelper;
}

/**
 * Returns the FocusTraverseManager which is used to determine which figure will get focus
 * when a TAB or ALT+TAB key sequence occurs.
 * @return the FocusTraverseManager
 */
protected final FocusTraverseManager getFocusTraverseManager() {
    if (focusManager is null) {
        focusManager = new FocusTraverseManager();
    }
    return focusManager;
}

/**
 * @see EventDispatcher#getFocusOwner()
 */
/*package*/ IFigure getFocusOwner() {
    return focusOwner;
}

/**
 * Returns the figure that is the target of mouse events.  This may not be the figure
 * beneath the cursor because another figure may have captured the mouse and will continue
 * to get mouse events until capture is released.
 * @return the mouse target
 */
protected IFigure getMouseTarget() {
    return mouseTarget;
}

/**
 * Returns the root figure for this dispatcher.
 * @return the root figure
 */
protected IFigure getRoot() {
    return root;
}

/**
 * @see EventDispatcher#isCaptured()
 */
public bool isCaptured() {
    return captured;
}

private void receive(dwt.events.MouseEvent.MouseEvent me) {
    currentEvent = null;
    updateFigureUnderCursor(me);
    int state = me.stateMask;
    if (captured) {
        if (mouseTarget !is null)
            currentEvent = new MouseEvent(me.x, me.y, this, mouseTarget, me.button, state);
    } else {
        IFigure f = root.findMouseEventTargetAt(me.x, me.y);
        if (f is mouseTarget) {
            if (mouseTarget !is null)
                currentEvent =
                        new MouseEvent(me.x, me.y, this, mouseTarget, me.button, state);
            return;
        }
        if (mouseTarget !is null) {
            currentEvent = new MouseEvent(me.x, me.y, this, mouseTarget, me.button, state);
            mouseTarget.handleMouseExited(currentEvent);
        }
        setMouseTarget(f);
        if (mouseTarget !is null) {
            currentEvent = new MouseEvent(me.x, me.y, this, mouseTarget, me.button, state);
            mouseTarget.handleMouseEntered(currentEvent);
        }
    }
}

/**
 * @see EventDispatcher#releaseCapture()
 */
protected void releaseCapture() {
    captured = false;
}

/**
 * @see EventDispatcher#requestFocus(IFigure)
 */
public void requestFocus(IFigure fig) {
    setFocus(fig);
}

/**
 * @see EventDispatcher#requestRemoveFocus(IFigure)
 */
public void requestRemoveFocus(IFigure fig) {
    if (getFocusOwner() is fig)
        setFocus(null);
    if (mouseTarget is fig)
        mouseTarget = null;
    if (cursorTarget is fig)
        cursorTarget = null;
    if (hoverSource is fig)
        hoverSource = null;
    getFocusTraverseManager().setCurrentFocusOwner(null);
}

/**
 * @see EventDispatcher#setCapture(IFigure)
 */
protected void setCapture(IFigure figure) {
    captured = true;
    mouseTarget = figure;
}

/**
 * @see EventDispatcher#setControl(Control)
 */
public void setControl(Control c) {
    if (c is control)
        return;
    if (control !is null && !control.isDisposed())
        throw new RuntimeException(
                "Can not set control again once it has been set"); //$NON-NLS-1$
    if (c !is null)
        c.addDisposeListener(new class() dwt.events.DisposeListener.DisposeListener {
            public void widgetDisposed(DisposeEvent e) {
                if (toolTipHelper !is null)
                    toolTipHelper.dispose();
            }
        });
    control = c;
}

/**
 * Sets the mouse cursor.
 * @param c the new cursor
 */
protected void setCursor(Cursor c) {
    if (c is null && cursor is null) {
        return;
    } else if ((c !is cursor) || (!c.opEquals(cursor))) {
        cursor = c;
        if (control !is null && !control.isDisposed())
            control.setCursor(c);
    }
}

/**
 * Enables key traversal via TAB and ALT+TAB if <i>traverse</i> is <code>true</code>.
 * Disables it otherwise.
 * @param traverse whether key traversal should be enabled
 */
public void setEnableKeyTraversal(bool traverse) {
    figureTraverse = traverse;
}

/**
 * Sets the figure under the mouse cursor.
 * @param f the new figure under the cursor
 */
protected void setFigureUnderCursor(IFigure f) {
    if (cursorTarget is f)
        return;
    cursorTarget = f;
    updateCursor();
}

/**
 * Sets the focus figure.  If the figure currently with focus is not <code>null</code>,
 * {@link IFigure#handleFocusLost(FocusEvent)} is called on the current focused figure. If
 * the new focus figure is not <code>null</code>, this will call
 * {@link IFigure#handleFocusGained(FocusEvent)} on the new focused figure.
 * @param fig the new focus figure
 */
protected void setFocus(IFigure fig) {
    if (fig is focusOwner)
        return;
    FocusEvent fe = new FocusEvent(focusOwner, fig);
    IFigure oldOwner = focusOwner;
    focusOwner = fig;
    if (oldOwner !is null)
        oldOwner.handleFocusLost(fe);
    if (fig !is null)
        getFocusTraverseManager().setCurrentFocusOwner(fig);
    if (focusOwner !is null)
        focusOwner.handleFocusGained(fe);
}

/**
 * Sets the figure that the mouse cursor is hovering over.
 * @param figure the new hover source
 * @param me the mouse event
 */
protected void setHoverSource(Figure figure, dwt.events.MouseEvent.MouseEvent me) {
    hoverSource = figure;
    if (figure !is null) {
        Control control = cast(Control)me.getSource();
        dwt.graphics.Point.Point absolute;
        absolute = control.toDisplay(new dwt.graphics.Point.Point(me.x, me.y));
        toolTipHelper = getToolTipHelper();
        toolTipHelper.updateToolTip(
                            hoverSource, getCurrentToolTip(), absolute.x, absolute.y);
    } else if (toolTipHelper !is null) {
        // Update with null to clear hoverSource in ToolTipHelper
        toolTipHelper.updateToolTip(hoverSource, getCurrentToolTip(), me.x, me.y);
    }
}

/**
 * Sets the given figure to be the target of future mouse events.
 * @param figure the new mouse target
 */
protected void setMouseTarget(IFigure figure) {
    mouseTarget = figure;
}

/**
 * @see EventDispatcher#setRoot(IFigure)
 */
public void setRoot(IFigure figure) {
    root = figure;
}

/**
 * @see EventDispatcher#updateCursor()
 */
protected void updateCursor() {
    Cursor newCursor = null;
    if (cursorTarget !is null)
        newCursor = cursorTarget.getCursor();
    setCursor(newCursor);
}

/**
 * Updates the figure under the cursor, unless the mouse is captured, in which case all
 * mouse events will be routed to the figure that captured the mouse.
 * @param me the mouse event
 */
protected void updateFigureUnderCursor(dwt.events.MouseEvent.MouseEvent me) {
    if (!captured) {
        IFigure f = root.findFigureAt(me.x, me.y);
        setFigureUnderCursor(f);
        if (cast(Figure)cursorTarget !is hoverSource)
            updateHoverSource(me);
    }
}

/**
 * Updates the figure that will receive hover events.  The hover source must have a
 * tooltip.  If the figure under the mouse doesn't have a tooltip set, this method will
 * walk up the ancestor hierarchy until either a figure with a tooltip is found or it
 * gets to the root figure.
 * @param me the mouse event
 */
protected void updateHoverSource(dwt.events.MouseEvent.MouseEvent me) {
    /*
     * Derive source from figure under cursor.
     * Set the source in setHoverSource();
     * If figure.getToolTip() is null, get parent's toolTip
     * Continue parent traversal until a toolTip is found or root is reached.
     */
    if (cursorTarget !is null) {
        bool sourceFound = false;
        Figure source = cast(Figure)cursorTarget;
        while (!sourceFound && source.getParent() !is null) {
            if (source.getToolTip() !is null)
                sourceFound = true;
            else
                source = cast(Figure)source.getParent();
        }
        setHoverSource(source, me);
    } else {
        setHoverSource(null, me);
    }
}

}
