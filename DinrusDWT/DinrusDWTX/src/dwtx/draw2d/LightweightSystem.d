/*******************************************************************************
 * Copyright (c) 2000, 2005 IBM Corporation and others.
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
module dwtx.draw2d.LightweightSystem;

import dwt.dwthelper.utils;

import dwt.DWT;
import dwt.accessibility.AccessibleControlEvent;
import dwt.accessibility.AccessibleControlListener;
import dwt.accessibility.AccessibleEvent;
import dwt.accessibility.AccessibleListener;
import dwt.events.ControlAdapter;
import dwt.events.ControlEvent;
import dwt.events.DisposeEvent;
import dwt.events.DisposeListener;
import dwt.events.FocusEvent;
import dwt.events.FocusListener;
import dwt.events.KeyEvent;
import dwt.events.KeyListener;
import dwt.events.MouseEvent;
import dwt.events.MouseListener;
import dwt.events.MouseMoveListener;
import dwt.events.MouseTrackListener;
import dwt.events.TraverseEvent;
import dwt.events.TraverseListener;
import dwt.graphics.Color;
import dwt.graphics.Font;
import dwt.graphics.GC;
import dwt.widgets.Canvas;
import dwt.widgets.Event;
import dwt.widgets.Listener;
import dwtx.draw2d.geometry.Rectangle;
import dwtx.draw2d.IFigure;
import dwtx.draw2d.EventDispatcher;
import dwtx.draw2d.UpdateManager;
import dwtx.draw2d.Figure;
import dwtx.draw2d.DeferredUpdateManager;
import dwtx.draw2d.SWTEventDispatcher;
import dwtx.draw2d.StackLayout;
import dwtx.draw2d.BufferedGraphicsSource;
import dwtx.draw2d.NativeGraphicsSource;

/**
 * The LightweightSystem is the link between DWT and Draw2d. It is the component that
 * provides the ability for {@link Figure Figures} to be hosted on an DWT Canvas.
 * <p>
 * Normal procedure for using a LightweightSystem:
 * <ol>
 *      <li>Create an DWT Canvas.
 *      <li>Create a LightweightSystem passing it that Canvas.
 *      <li>Create a Draw2d Figure and call setContents(IFigure). This Figure will be the
 *          top-level Figure of the Draw2d application.
 * </ol>
 */
public class LightweightSystem {

private Canvas canvas;
IFigure contents;
private IFigure root;
private EventDispatcher dispatcher;
private UpdateManager manager;
private int ignoreResize;

/**
 * Constructs a LightweightSystem on Canvas <i>c</i>.
 *
 * @param c the canvas
 * @since 2.0
 */
public this(Canvas c) {
    this();
    setControl(c);
}

/**
 * Constructs a LightweightSystem <b>without</b> a Canvas.
 */
public this() {
    manager = new DeferredUpdateManager();
    init();
}

/**
 * Adds DWT listeners to the LightWeightSystem's Canvas. This allows for DWT events to be
 * dispatched and handled by its {@link EventDispatcher}.
 * <P>
 * <EM>WARNING:</EM> This method should not be overridden.
 * @since 2.0
 */
protected void addListeners() {
    EventHandler handler = createEventHandler();
    canvas.getAccessible().addAccessibleListener(handler);
    canvas.getAccessible().addAccessibleControlListener(handler);
    canvas.addMouseListener(handler);
    canvas.addMouseMoveListener(handler);
    canvas.addMouseTrackListener(handler);
    canvas.addKeyListener(handler);
    canvas.addTraverseListener(handler);
    canvas.addFocusListener(handler);
    canvas.addDisposeListener(handler);
    canvas.addListener(DWT.MouseWheel, handler);

    canvas.addControlListener(new class() ControlAdapter {
        public void controlResized(ControlEvent e) {
            this.outer.controlResized();
        }
    });
    canvas.addListener(DWT.Paint, new class() Listener {
        public void handleEvent(Event e) {
            this.outer.paint(e.gc);
        }
    });
}

/**
 * Resizes and revalidates the root figure when the control is resized.
 */
protected void controlResized() {
    if (ignoreResize > 0)
        return;
    Rectangle r = new Rectangle(canvas.getClientArea());
    r.setLocation(0, 0);
    root.setBounds(r);
    root.revalidate();
    getUpdateManager().performUpdate();
}

/**
 * Returns this LightwightSystem's EventDispatcher.
 *
 * @return the event dispatcher
 * @since 2.0
 */
protected EventDispatcher getEventDispatcher() {
    if (dispatcher is null)
        setEventDispatcher(new SWTEventDispatcher());
    return dispatcher;
}

/**
 * Returns this LightweightSystem's root figure.
 *
 * @return the root figure
 * @since 2.0
 */
public IFigure getRootFigure() {
    return root;
}

/**
 * Returns a new instance of this LightweightSystem's EventHandler.
 *
 * @return the newly created event handler
 * @since 2.0
 */
protected final EventHandler createEventHandler() {
    return internalCreateEventHandler();
}

/**
 * Creates and returns the root figure.
 *
 * @return the newly created root figure
 */
protected RootFigure createRootFigure() {
    RootFigure f = new RootFigure();
    f.addNotify();
    f.setOpaque(true);
    f.setLayoutManager(new StackLayout());
    return f;
}

/**
 * Returns this LightweightSystem's UpdateManager.
 *
 * @return the update manager
 * @since 2.0
 */
public UpdateManager getUpdateManager() {
    return manager;
}

/**
 * Initializes this LightweightSystem by setting the root figure.
 */
protected void init() {
    setRootPaneFigure(createRootFigure());
}

EventHandler internalCreateEventHandler() {
    return new EventHandler();
}

/**
 * Invokes this LightweightSystem's {@link UpdateManager} to paint this
 * LightweightSystem's Canvas and contents.
 *
 * @param gc the GC used for painting
 * @since 2.0
 */
public void paint(GC gc) {
    getUpdateManager().paint(gc);
}

/**
 * Sets the contents of the LightweightSystem to the passed figure. This figure should be
 * the top-level Figure in a Draw2d application.
 *
 * @param figure the new root figure
 * @since 2.0
 */
public void setContents(IFigure figure) {
    if (contents !is null)
        root.remove(contents);
    contents = figure;
    root.add(contents);
}

/**
 * Sets the LightweightSystem's control to the passed Canvas.
 *
 * @param c the canvas
 * @since 2.0
 */
public void setControl(Canvas c) {
    if (canvas is c)
        return;
    canvas = c;
    if ((c.getStyle() & DWT.DOUBLE_BUFFERED) !is 0)
        getUpdateManager().setGraphicsSource(new NativeGraphicsSource(canvas));
    else
        getUpdateManager().setGraphicsSource(new BufferedGraphicsSource(canvas));
    getEventDispatcher().setControl(c);
    addListeners();

    //Size the root figure and contents to the current control's size
    Rectangle r = new Rectangle(canvas.getClientArea());
    r.setLocation(0, 0);
    root.setBounds(r);
    root.revalidate();
}

/**
 * Sets this LightweightSystem's EventDispatcher.
 *
 * @param dispatcher the new event dispatcher
 * @since 2.0
 */
public void setEventDispatcher(EventDispatcher dispatcher) {
    this.dispatcher = dispatcher;
    dispatcher.setRoot(root);
    dispatcher.setControl(canvas);
}

void setIgnoreResize(bool value) {
    if (value)
        ignoreResize++;
    else
        ignoreResize--;
}

/**
 * Sets this LightweightSystem's root figure.
 * @param root the new root figure
 */
protected void setRootPaneFigure(RootFigure root) {
    getUpdateManager().setRoot(root);
    this.root = root;
}

/**
 * Sets this LightweightSystem's UpdateManager.
 *
 * @param um the new update manager
 * @since 2.0
 */
public void setUpdateManager(UpdateManager um) {
    manager = um;
    manager.setRoot(root);
}

/**
 * The figure at the root of the LightweightSystem.  If certain properties (i.e. font,
 * background/foreground color) are not set, the RootFigure will obtain these properties
 * from LightweightSystem's Canvas.
 */
protected class RootFigure
    : Figure
{
    /** @see IFigure#getBackgroundColor() */
    public Color getBackgroundColor() {
        if (bgColor !is null)
            return bgColor;
        if (canvas !is null)
            return canvas.getBackground();
        return null;
    }

    /** @see IFigure#getFont() */
    public Font getFont() {
        if (font !is null)
            return font;
        if (canvas !is null)
            return canvas.getFont();
        return null;
    }

    /** @see IFigure#getForegroundColor() */
    public Color getForegroundColor() {
        if (fgColor !is null)
            return fgColor;
        if (canvas !is null)
            return canvas.getForeground();
        return null;
    }

    /** @see IFigure#getUpdateManager() */
    public UpdateManager getUpdateManager() {
        return this.outer.getUpdateManager();
    }

    /** @see IFigure#internalGetEventDispatcher() */
    public EventDispatcher internalGetEventDispatcher() {
        return getEventDispatcher();
    }

    /**
     * @see IFigure#isMirrored()
     */
    public bool isMirrored() {
        return (this.outer.canvas.getStyle() & DWT.MIRRORED) !is 0;
    }

    /** @see Figure#isShowing() */
    public bool isShowing() {
        return true;
    }
}

/**
 * Listener used to get all necessary events from the Canvas and pass them on to the
 * {@link EventDispatcher}.
 */
protected class EventHandler
    : MouseMoveListener, MouseListener, AccessibleControlListener, KeyListener,
                TraverseListener, FocusListener, AccessibleListener, MouseTrackListener,
                Listener, DisposeListener
{
    /** @see FocusListener#focusGained(FocusEvent) */
    public void focusGained(FocusEvent e) {
        getEventDispatcher().dispatchFocusGained(e);
    }

    /** @see FocusListener#focusLost(FocusEvent) */
    public void focusLost(FocusEvent e) {
        getEventDispatcher().dispatchFocusLost(e);
    }

    /** @see AccessibleControlListener#getChild(AccessibleControlEvent) */
    public void getChild(AccessibleControlEvent e) {
        EventDispatcher.AccessibilityDispatcher ad;
        ad = getEventDispatcher().getAccessibilityDispatcher_package();
        if (ad !is null)
            ad.getChild(e);
    }

    /** @see AccessibleControlListener#getChildAtPoint(AccessibleControlEvent) */
    public void getChildAtPoint(AccessibleControlEvent e) {
        EventDispatcher.AccessibilityDispatcher ad;
        ad = getEventDispatcher().getAccessibilityDispatcher_package();
        if (ad !is null)
            ad.getChildAtPoint(e);
    }

    /** @see AccessibleControlListener#getChildCount(AccessibleControlEvent) */
    public void getChildCount(AccessibleControlEvent e) {
        EventDispatcher.AccessibilityDispatcher ad;
        ad = getEventDispatcher().getAccessibilityDispatcher_package();
        if (ad !is null)
            ad.getChildCount(e);
    }

    /** @see AccessibleControlListener#getChildren(AccessibleControlEvent) */
    public void getChildren(AccessibleControlEvent e) {
        EventDispatcher.AccessibilityDispatcher ad;
        ad = getEventDispatcher().getAccessibilityDispatcher_package();
        if (ad !is null)
            ad.getChildren(e);
    }

    /** @see AccessibleControlListener#getDefaultAction(AccessibleControlEvent) */
    public void getDefaultAction(AccessibleControlEvent e) {
        EventDispatcher.AccessibilityDispatcher ad;
        ad = getEventDispatcher().getAccessibilityDispatcher_package();
        if (ad !is null)
            ad.getDefaultAction(e);
    }

    /** @see AccessibleListener#getDescription(AccessibleEvent) */
    public void getDescription(AccessibleEvent e) {
        EventDispatcher.AccessibilityDispatcher ad;
        ad = getEventDispatcher().getAccessibilityDispatcher_package();
        if (ad !is null)
            ad.getDescription(e);
    }

    /** @see AccessibleControlListener#getFocus(AccessibleControlEvent) */
    public void getFocus(AccessibleControlEvent e) {
        EventDispatcher.AccessibilityDispatcher ad;
        ad = getEventDispatcher().getAccessibilityDispatcher_package();
        if (ad !is null)
            ad.getFocus(e);
    }

    /** @see AccessibleListener#getHelp(AccessibleEvent) */
    public void getHelp(AccessibleEvent e) {
        EventDispatcher.AccessibilityDispatcher ad;
        ad = getEventDispatcher().getAccessibilityDispatcher_package();
        if (ad !is null)
            ad.getHelp(e);
    }

    /** @see AccessibleListener#getKeyboardShortcut(AccessibleEvent) */
    public void getKeyboardShortcut(AccessibleEvent e) {
        EventDispatcher.AccessibilityDispatcher ad;
        ad = getEventDispatcher().getAccessibilityDispatcher_package();
        if (ad !is null)
            ad.getKeyboardShortcut(e);
    }

    /** @see AccessibleControlListener#getLocation(AccessibleControlEvent) */
    public void getLocation(AccessibleControlEvent e) {
        EventDispatcher.AccessibilityDispatcher ad;
        ad = getEventDispatcher().getAccessibilityDispatcher_package();
        if (ad !is null)
            ad.getLocation(e);
    }

    /** @see AccessibleListener#getName(AccessibleEvent) */
    public void getName(AccessibleEvent e) {
        EventDispatcher.AccessibilityDispatcher ad;
        ad = getEventDispatcher().getAccessibilityDispatcher_package();
        if (ad !is null)
            ad.getName(e);
    }

    /** @see AccessibleControlListener#getRole(AccessibleControlEvent) */
    public void getRole(AccessibleControlEvent e) {
        EventDispatcher.AccessibilityDispatcher ad;
        ad = getEventDispatcher().getAccessibilityDispatcher_package();
        if (ad !is null)
            ad.getRole(e);
    }

    /** @see AccessibleControlListener#getSelection(AccessibleControlEvent) */
    public void getSelection(AccessibleControlEvent e) {
        EventDispatcher.AccessibilityDispatcher ad;
        ad = getEventDispatcher().getAccessibilityDispatcher_package();
        if (ad !is null)
            ad.getSelection(e);
    }

    /** @see AccessibleControlListener#getState(AccessibleControlEvent) */
    public void getState(AccessibleControlEvent e) {
        EventDispatcher.AccessibilityDispatcher ad;
        ad = getEventDispatcher().getAccessibilityDispatcher_package();
        if (ad !is null)
            ad.getState(e);
    }

    /** @see AccessibleControlListener#getValue(AccessibleControlEvent) */
    public void getValue(AccessibleControlEvent e) {
        EventDispatcher.AccessibilityDispatcher ad;
        ad = getEventDispatcher().getAccessibilityDispatcher_package();
        if (ad !is null)
            ad.getValue(e);
    }

    /**
     * @see Listener#handleEvent(dwt.widgets.Event)
     * @since 3.1
     */
    public void handleEvent(Event event) {
        // Mouse wheel events
        if (event.type is DWT.MouseWheel)
            getEventDispatcher().dispatchMouseWheelScrolled(event);
    }

    /** @see KeyListener#keyPressed(KeyEvent) */
    public void keyPressed(KeyEvent e) {
        getEventDispatcher().dispatchKeyPressed(e);
    }

    /** @see KeyListener#keyReleased(KeyEvent) */
    public void keyReleased(KeyEvent e) {
        getEventDispatcher().dispatchKeyReleased(e);
    }

    /** @see TraverseListener#keyTraversed(TraverseEvent) */
    public void keyTraversed(TraverseEvent e) {
        /*
         * Doit is almost always false by default for Canvases with KeyListeners. Set to
         * true to allow normal behavior.  For example, in Dialogs ESC should close.
         */
        e.doit = true;
        getEventDispatcher().dispatchKeyTraversed(e);
    }

    /** @see MouseListener#mouseDoubleClick(MouseEvent) */
    public void mouseDoubleClick(MouseEvent e) {
        getEventDispatcher().dispatchMouseDoubleClicked(e);
    }

    /**@see MouseListener#mouseDown(MouseEvent)*/
    public void mouseDown(MouseEvent e) {
        getEventDispatcher().dispatchMousePressed(e);
    }

    /**@see MouseTrackListener#mouseEnter(MouseEvent)*/
    public void mouseEnter(MouseEvent e) {
        getEventDispatcher().dispatchMouseEntered(e);
    }

    /**@see MouseTrackListener#mouseExit(MouseEvent)*/
    public void mouseExit(MouseEvent e) {
        getEventDispatcher().dispatchMouseExited(e);
    }

    /**@see MouseTrackListener#mouseHover(MouseEvent)*/
    public void mouseHover(MouseEvent e) {
        getEventDispatcher().dispatchMouseHover(e);
    }

    /**@see MouseMoveListener#mouseMove(MouseEvent)*/
    public void mouseMove(MouseEvent e) {
        getEventDispatcher().dispatchMouseMoved(e);
    }

    /**@see MouseListener#mouseUp(MouseEvent)*/
    public void mouseUp(MouseEvent e) {
        getEventDispatcher().dispatchMouseReleased(e);
    }

    /**@see DisposeListener#widgetDisposed(DisposeEvent)*/
    public void widgetDisposed(DisposeEvent e) {
        getUpdateManager().dispose();
    }
}

}
