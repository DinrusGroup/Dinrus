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
module dwtx.ui.forms.widgets.AbstractHyperlink;


import dwt.DWT;
import dwt.accessibility.ACC;
import dwt.events.PaintEvent;
import dwt.events.PaintListener;
import dwt.graphics.GC;
import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwt.widgets.Canvas;
import dwt.widgets.Composite;
import dwt.widgets.Event;
import dwt.widgets.Listener;
import dwtx.core.runtime.ListenerList;
import dwtx.ui.forms.events.HyperlinkEvent;
import dwtx.ui.forms.events.IHyperlinkListener;
import dwtx.ui.internal.forms.widgets.FormsResources;

import dwt.dwthelper.utils;

/**
 * This is the base class for custom hyperlink widget. It is responsible for
 * processing mouse and keyboard events, and converting them into unified
 * hyperlink events. Subclasses are responsible for rendering the hyperlink in
 * the client area.
 *
 * @since 3.0
 */
public abstract class AbstractHyperlink : Canvas {
    private bool hasFocus;
    bool paintFocus=true;

    /*
     * Armed link is one that will activate on a mouse up event, i.e.
     * it has received a mouse down and mouse still on top of it.
     */
    private bool armed;

    private ListenerList listeners;

    /**
     * Amount of the margin width around the hyperlink (default is 1).
     */
    protected int marginWidth = 1;

    /**
     * Amount of the margin height around the hyperlink (default is 1).
     */
    protected int marginHeight = 1;

    /**
     * Creates a new hyperlink in the provided parent.
     *
     * @param parent
     *            the control parent
     * @param style
     *            the widget style
     */
    public this(Composite parent, int style) {
        super(parent, style);
        addListener(DWT.KeyDown, new class Listener {
            public void handleEvent(Event e) {
                if (e.character is '\r') {
                    handleActivate(e);
                }
            }
        });
        addPaintListener(new class PaintListener {
            public void paintControl(PaintEvent e) {
                paint(e);
            }
        });
        addListener(DWT.Traverse, new class Listener {
            public void handleEvent(Event e) {
                switch (e.detail) {
                case DWT.TRAVERSE_PAGE_NEXT:
                case DWT.TRAVERSE_PAGE_PREVIOUS:
                case DWT.TRAVERSE_ARROW_NEXT:
                case DWT.TRAVERSE_ARROW_PREVIOUS:
                case DWT.TRAVERSE_RETURN:
                    e.doit = false;
                    return;
                default:
                }
                e.doit = true;
            }
        });
        Listener listener = new class Listener {
            public void handleEvent(Event e) {
                switch (e.type) {
                case DWT.FocusIn:
                    hasFocus = true;
                    handleEnter(e);
                    break;
                case DWT.FocusOut:
                    hasFocus = false;
                    handleExit(e);
                    break;
                case DWT.DefaultSelection:
                    handleActivate(e);
                    break;
                case DWT.MouseEnter:
                    handleEnter(e);
                    break;
                case DWT.MouseExit:
                    handleExit(e);
                    break;
                case DWT.MouseDown:
                    handleMouseDown(e);
                    break;
                case DWT.MouseUp:
                    handleMouseUp(e);
                    break;
                case DWT.MouseMove:
                    handleMouseMove(e);
                    break;
                default:
                }
            }
        };
        addListener(DWT.MouseEnter, listener);
        addListener(DWT.MouseExit, listener);
        addListener(DWT.MouseDown, listener);
        addListener(DWT.MouseUp, listener);
        addListener(DWT.MouseMove, listener);
        addListener(DWT.FocusIn, listener);
        addListener(DWT.FocusOut, listener);
        setCursor(FormsResources.getHandCursor());
    }

    /**
     * Adds the event listener to this hyperlink.
     *
     * @param listener
     *            the event listener to add
     */
    public void addHyperlinkListener(IHyperlinkListener listener) {
        if (listeners is null)
            listeners = new ListenerList();
        listeners.add(cast(Object)listener);
    }

    /**
     * Removes the event listener from this hyperlink.
     *
     * @param listener
     *            the event listener to remove
     */
    public void removeHyperlinkListener(IHyperlinkListener listener) {
        if (listeners is null)
            return;
        listeners.remove(cast(Object)listener);
    }

    /**
     * Returns the selection state of the control. When focus is gained, the
     * state will be <samp>true </samp>; it will switch to <samp>false </samp>
     * when the control looses focus.
     *
     * @return <code>true</code> if the widget has focus, <code>false</code>
     *         otherwise.
     */
    public bool getSelection() {
        return hasFocus;
    }

    /**
     * Called when hyperlink is entered. Subclasses that override this method
     * must call 'super'.
     */
    protected void handleEnter(Event e) {
        redraw();
        if (listeners is null)
            return;
        int size = listeners.size();
        HyperlinkEvent he = new HyperlinkEvent(this, getHref(), getText(),
                e.stateMask);
        Object[] listenerList = listeners.getListeners();
        for (int i = 0; i < size; i++) {
            IHyperlinkListener listener = cast(IHyperlinkListener) listenerList[i];
            listener.linkEntered(he);
        }
    }

    /**
     * Called when hyperlink is exited. Subclasses that override this method
     * must call 'super'.
     */
    protected void handleExit(Event e) {
        // disarm the link; won't activate on mouseup
        armed = false;
        redraw();
        if (listeners is null)
            return;
        int size = listeners.size();
        HyperlinkEvent he = new HyperlinkEvent(this, getHref(), getText(),
                e.stateMask);
        Object[] listenerList = listeners.getListeners();
        for (int i = 0; i < size; i++) {
            IHyperlinkListener listener = cast(IHyperlinkListener) listenerList[i];
            listener.linkExited(he);
        }
    }

    /**
     * Called when hyperlink has been activated. Subclasses that override this
     * method must call 'super'.
     */
    protected void handleActivate(Event e) {
        // disarm link, back to normal state
        armed = false;
        getAccessible().setFocus(ACC.CHILDID_SELF);
        if (listeners is null)
            return;
        int size = listeners.size();
        setCursor(FormsResources.getBusyCursor());
        HyperlinkEvent he = new HyperlinkEvent(this, getHref(), getText(),
                e.stateMask);
        Object[] listenerList = listeners.getListeners();
        for (int i = 0; i < size; i++) {
            IHyperlinkListener listener = cast(IHyperlinkListener) listenerList[i];
            listener.linkActivated(he);
        }
        if (!isDisposed())
            setCursor(FormsResources.getHandCursor());
    }

    /**
     * Sets the object associated with this hyperlink. Concrete implementation
     * of this class can use if to store text, URLs or model objects that need
     * to be processed on hyperlink events.
     *
     * @param href
     *            the hyperlink object reference
     */
    public void setHref(Object href) {
        setData("href", href); //$NON-NLS-1$
    }

    /**
     * Returns the object associated with this hyperlink.
     *
     * @see #setHref
     * @return the hyperlink object reference
     */
    public Object getHref() {
        return getData("href"); //$NON-NLS-1$
    }

    /**
     * Returns the textual representation of this hyperlink suitable for showing
     * in tool tips or on the status line.
     *
     * @return the hyperlink text
     */
    public String getText() {
        return getToolTipText();
    }

    /**
     * Paints the hyperlink as a reaction to the provided paint event.
     *
     * @param gc
     *            graphic context
     */
    protected abstract void paintHyperlink(GC gc);

    /**
     * Paints the control as a reaction to the provided paint event.
     *
     * @param e
     *            the paint event
     */
    protected void paint(PaintEvent e) {
        GC gc = e.gc;
        Rectangle clientArea = getClientArea();
        if (clientArea.width is 0 || clientArea.height is 0)
            return;
        paintHyperlink(gc);
        if (paintFocus && hasFocus) {
            Rectangle carea = getClientArea();
            gc.setForeground(getForeground());
            gc.drawFocus(0, 0, carea.width, carea.height);
        }
    }

    private void handleMouseDown(Event e) {
        if (e.button !is 1)
            return;
        // armed and ready to activate on mouseup
        armed = true;
    }

    private void handleMouseUp(Event e) {
        if (!armed || e.button !is 1)
            return;
        Point size = getSize();
        // Filter out mouse up events outside
        // the link. This can happen when mouse is
        // clicked, dragged outside the link, then
        // released.
        if (e.x < 0)
            return;
        if (e.y < 0)
            return;
        if (e.x >= size.x)
            return;
        if (e.y >= size.y)
            return;
        handleActivate(e);
    }

    private void handleMouseMove(Event e) {
        // disarm link if we move out of bounds
        if (armed) {
            Point size = getSize();
            armed = (e.x >= 0 && e.y >= 0 && e.x < size.x && e.y < size.y);
        }
    }

    /*
     * (non-Javadoc)
     * @see dwt.widgets.Control#setEnabled(bool)
     */

    public void setEnabled (bool enabled) {
        super.setEnabled(enabled);
        redraw();
    }
}
