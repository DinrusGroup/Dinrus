/*******************************************************************************
 * Copyright (c) 2000, 2008 IBM Corporation and others.
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
module dwtx.draw2d.FigureCanvas;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Bean;
static import dwtx.dwtxhelper.Collection;

import dwt.DWT;
import dwt.events.SelectionAdapter;
import dwt.events.SelectionEvent;
import dwt.graphics.Font;
import dwt.widgets.Canvas;
import dwt.widgets.Composite;
import dwt.widgets.Control;
import dwtx.draw2d.geometry.Dimension;
import dwtx.draw2d.geometry.Point;
import dwtx.draw2d.geometry.Rectangle;
import dwtx.draw2d.Viewport;
import dwtx.draw2d.LightweightSystem;
import dwtx.draw2d.IFigure;
import dwtx.draw2d.Border;
import dwtx.draw2d.RangeModel;
static import dwt.graphics.Point;
static import dwt.graphics.Rectangle;
import dwtx.draw2d.UpdateListener;
import dwtx.draw2d.ScrollPaneSolver;

/**
 * A Canvas that contains {@link Figure Figures}.
 *
 * <dl>
 * <dt><b>Required Styles (when using certain constructors):</b></dt>
 * <dd>V_SCROLL, H_SCROLL, NO_REDRAW_RESIZE</dd>
 * <dt><b>Optional Styles:</b></dt>
 * <dd>DOUBLE_BUFFERED, RIGHT_TO_LEFT, LEFT_TO_RIGHT, NO_BACKGROUND, BORDER</dd>
 * </dl>
 * <p>
 * Note: Only one of the styles RIGHT_TO_LEFT, LEFT_TO_RIGHT may be specified.
 * </p>
 */
public class FigureCanvas
    : Canvas
{

private static final int ACCEPTED_STYLES =
        DWT.RIGHT_TO_LEFT | DWT.LEFT_TO_RIGHT
        | DWT.V_SCROLL | DWT.H_SCROLL
        | DWT.NO_BACKGROUND
        | DWT.NO_REDRAW_RESIZE
        | DWT.DOUBLE_BUFFERED
        | DWT.BORDER;

/**
 * The default styles are mixed in when certain constructors are used. This
 * constant is a bitwise OR of the following DWT style constants:
 * <UL>
 *   <LI>{@link DWT#NO_REDRAW_RESIZE}</LI>
 *   <LI>{@link DWT#NO_BACKGROUND}</LI>
 *   <LI>{@link DWT#V_SCROLL}</LI>
 *   <LI>{@link DWT#H_SCROLL}</LI>
 * </UL>
 */
static const int DEFAULT_STYLES =
        DWT.NO_REDRAW_RESIZE
        | DWT.NO_BACKGROUND
        | DWT.V_SCROLL
        | DWT.H_SCROLL;

private static const int REQUIRED_STYLES =
        DWT.NO_REDRAW_RESIZE
        | DWT.V_SCROLL
        | DWT.H_SCROLL;

/** Never show scrollbar */
public static int NEVER = 0;
/** Automatically show scrollbar when needed */
public static int AUTOMATIC = 1;
/** Always show scrollbar */
public static int ALWAYS = 2;

private int vBarVisibility;
private int hBarVisibility;
private Viewport viewport;
private Font font;
private int hBarOffset;
private int vBarOffset;

private PropertyChangeListener horizontalChangeListener;
private PropertyChangeListener verticalChangeListener;
private const LightweightSystem lws;

/**
 * Creates a new FigureCanvas with the given parent and the {@link #DEFAULT_STYLES}.
 *
 * @param parent the parent
 */
public this(Composite parent) {
    this(parent, DWT.DOUBLE_BUFFERED, new LightweightSystem());
}

/**
 * Constructor which applies the default styles plus any optional styles indicated.
 * @param parent the parent composite
 * @param style see the class javadoc for optional styles
 * @since 3.1
 */
public this(Composite parent, int style) {
    this(parent, style, new LightweightSystem());
}

/**
 * Constructor which uses the given styles verbatim. Certain styles must be used
 * with this class. Refer to the class javadoc for more details.
 * @param style see the class javadoc for <b>required</b> and optional styles
 * @param parent the parent composite
 * @since 3.4
 */
public this(int style, Composite parent) {
    this(style, parent, new LightweightSystem());
}

/**
 * Constructs a new FigureCanvas with the given parent and LightweightSystem, using
 * the {@link #DEFAULT_STYLES}.
 * @param parent the parent
 * @param lws the LightweightSystem
 */
public this(Composite parent, LightweightSystem lws) {
    this(parent, DWT.DOUBLE_BUFFERED, lws);
}

/**
 * Constructor taking a lightweight system and DWT style, which is used verbatim.
 * Certain styles must be used with this class. Refer to the class javadoc for
 * more details.
 * @param style see the class javadoc for <b>required</b> and optional styles
 * @param parent the parent composite
 * @param lws the LightweightSystem
 * @since 3.4
 */
public this(int style, Composite parent, LightweightSystem lws) {
    this.lws = lws;
    vBarVisibility = AUTOMATIC;
    hBarVisibility = AUTOMATIC;

    horizontalChangeListener = new class() PropertyChangeListener {
        public void propertyChange(PropertyChangeEvent event) {
            RangeModel model = getViewport().getHorizontalRangeModel();
            hBarOffset = Math.max(0, -model.getMinimum());
            getHorizontalBar().setValues(
                model.getValue() + hBarOffset,
                model.getMinimum() + hBarOffset,
                model.getMaximum() + hBarOffset,
                model.getExtent(),
                Math.max(1, model.getExtent() / 20),
                Math.max(1, model.getExtent() * 3 / 4));
        }
    };

    verticalChangeListener = new class() PropertyChangeListener {
        public void propertyChange(PropertyChangeEvent event) {
            RangeModel model = getViewport().getVerticalRangeModel();
            vBarOffset = Math.max(0, -model.getMinimum());
            getVerticalBar().setValues(
                model.getValue() + vBarOffset,
                model.getMinimum() + vBarOffset,
                model.getMaximum() + vBarOffset,
                model.getExtent(),
                Math.max(1, model.getExtent() / 20),
                Math.max(1, model.getExtent() * 3 / 4));
        }
    };
    super(parent, checkStyle(style));
    getHorizontalBar().setVisible(false);
    getVerticalBar().setVisible(false);
    lws.setControl(this);
    hook();
}

/**
 * Constructor
 * @param parent the parent composite
 * @param style look at class javadoc for valid styles
 * @param lws the lightweight system
 * @since 3.1
 */
public this(Composite parent, int style, LightweightSystem lws) {
    this(style | DEFAULT_STYLES, parent, lws);
}

private static int checkStyle(int style) {
    if ((style & REQUIRED_STYLES) !is REQUIRED_STYLES)
        throw new IllegalArgumentException("Required style missing on FigureCanvas"); //$NON-NLS-1$
    if ((style & ~ACCEPTED_STYLES) !is 0)
        throw new IllegalArgumentException("Invalid style being set on FigureCanvas"); //$NON-NLS-1$
    return style;
}

/**
 * @see dwt.widgets.Composite#computeSize(int, int, bool)
 */
public dwt.graphics.Point.Point computeSize(int wHint, int hHint, bool changed) {
    // TODO not accounting for scrollbars and trim
    Dimension size = getLightweightSystem().getRootFigure().getPreferredSize(wHint, hHint);
    size.union_(new Dimension(wHint, hHint));
    return new dwt.graphics.Point.Point(size.width, size.height);
}

/**
 * @return the contents of the {@link Viewport}.
 */
public IFigure getContents() {
    return getViewport().getContents();
}

/**
 * @see dwt.widgets.Control#getFont()
 */
public Font getFont() {
    if (font is null)
        font = super.getFont();
    return font;
}

/**
 * @return the horizontal scrollbar visibility.
 */
public int getHorizontalScrollBarVisibility() {
    return hBarVisibility;
}

/**
 * @return the LightweightSystem
 */
public LightweightSystem getLightweightSystem() {
    return lws;
}

/**
 * @return the vertical scrollbar visibility.
 */
public int getVerticalScrollBarVisibility() {
    return vBarVisibility;
}

/**
 * Returns the Viewport.  If it's <code>null</code>, a new one is created.
 * @return the viewport
 */
public Viewport getViewport() {
    if (viewport is null)
        setViewport(new Viewport(true));
    return viewport;
}

/**
 * Adds listeners for scrolling.
 */
private void hook() {
    getLightweightSystem().getUpdateManager().addUpdateListener(new class() UpdateListener {
        public void notifyPainting(Rectangle damage, dwtx.dwtxhelper.Collection.Map dirtyRegions) { }
        public void notifyValidating() {
            if (!isDisposed())
                layoutViewport();
        }
    });

    getHorizontalBar().addSelectionListener(new class() SelectionAdapter {
        public void widgetSelected(SelectionEvent event) {
            scrollToX(getHorizontalBar().getSelection() - hBarOffset);
        }
    });

    getVerticalBar().addSelectionListener(new class() SelectionAdapter {
        public void widgetSelected(SelectionEvent event) {
            scrollToY(getVerticalBar().getSelection() - vBarOffset);
        }
    });
}

private void hookViewport() {
    getViewport()
        .getHorizontalRangeModel()
        .addPropertyChangeListener(horizontalChangeListener);
    getViewport()
        .getVerticalRangeModel()
        .addPropertyChangeListener(verticalChangeListener);
}

private void unhookViewport() {
    getViewport()
        .getHorizontalRangeModel()
        .removePropertyChangeListener(horizontalChangeListener);
    getViewport()
        .getVerticalRangeModel()
        .removePropertyChangeListener(verticalChangeListener);
}

private void layoutViewport() {
    ScrollPaneSolver.Result result;
    result = ScrollPaneSolver.solve((new Rectangle(getBounds())).setLocation(0, 0),
        getViewport(),
        getHorizontalScrollBarVisibility(),
        getVerticalScrollBarVisibility(),
        computeTrim(0, 0, 0, 0).width,
        computeTrim(0, 0, 0, 0).height);
    getLightweightSystem().setIgnoreResize(true);
    try {
        if (getHorizontalBar().getVisible() !is result.showH)
            getHorizontalBar().setVisible(result.showH);
        if (getVerticalBar().getVisible() !is result.showV)
            getVerticalBar().setVisible(result.showV);
        Rectangle r = new Rectangle(getClientArea());
        r.setLocation(0, 0);
        getLightweightSystem().getRootFigure().setBounds(r);
    } finally {
        getLightweightSystem().setIgnoreResize(false);
    }
}

/**
 * Scrolls in an animated way to the new x and y location.
 * @param x the x coordinate to scroll to
 * @param y the y coordinate to scroll to
 */
public void scrollSmoothTo(int x, int y) {
    // Ensure newHOffset and newVOffset are within the appropriate ranges
    x = verifyScrollBarOffset(getViewport().getHorizontalRangeModel(), x);
    y = verifyScrollBarOffset(getViewport().getVerticalRangeModel(), y);

    int oldX = getViewport().getViewLocation().x;
    int oldY = getViewport().getViewLocation().y;
    int dx = x - oldX;
    int dy = y - oldY;

    if (dx is 0 && dy is 0)
        return; //Nothing to do.

    Dimension viewingArea = getViewport().getClientArea().getSize();

    int minFrames = 3;
    int maxFrames = 6;
    if (dx is 0 || dy is 0) {
        minFrames = 6;
        maxFrames = 13;
    }
    int frames = (Math.abs(dx) + Math.abs(dy)) / 15;
    frames = Math.max(frames, minFrames);
    frames = Math.min(frames, maxFrames);

    int stepX = Math.min((dx / frames), (viewingArea.width / 3));
    int stepY = Math.min((dy / frames), (viewingArea.height / 3));

    for (int i = 1; i < frames; i++) {
        scrollTo(oldX + i * stepX, oldY + i * stepY);
        getViewport().getUpdateManager().performUpdate();
    }
    scrollTo(x, y);
}

/**
 * Scrolls the contents to the new x and y location.  If this scroll operation only
 * consists of a vertical or horizontal scroll, a call will be made to
 * {@link #scrollToY(int)} or {@link #scrollToX(int)}, respectively, to increase
 * performance.
 *
 * @param x the x coordinate to scroll to
 * @param y the y coordinate to scroll to
 */
public void scrollTo(int x, int y) {
    x = verifyScrollBarOffset(getViewport().getHorizontalRangeModel(), x);
    y = verifyScrollBarOffset(getViewport().getVerticalRangeModel(), y);
    if (x is getViewport().getViewLocation().x)
        scrollToY(y);
    else if (y is getViewport().getViewLocation().y)
        scrollToX(x);
    else
        getViewport().setViewLocation(x, y);
}
/**
 * Scrolls the contents horizontally so that they are offset by <code>hOffset</code>.
 *
 * @param hOffset the new horizontal offset
 */
public void scrollToX(int hOffset) {
    hOffset = verifyScrollBarOffset(getViewport().getHorizontalRangeModel(), hOffset);
    int hOffsetOld = getViewport().getViewLocation().x;
    if (hOffset is hOffsetOld)
        return;
    int dx = -hOffset + hOffsetOld;

    Rectangle clientArea = getViewport().getBounds().getCropped(getViewport().getInsets());
    Rectangle blit = clientArea.getResized(-Math.abs(dx), 0);
    Rectangle expose = clientArea.getCopy();
    Point dest = clientArea.getTopLeft();
    expose.width = Math.abs(dx);
    if (dx < 0) { //Moving left?
        blit.translate(-dx, 0); //Move blit area to the right
        expose.x = dest.x + blit.width;
    } else //Moving right
        dest.x += dx; //Move expose area to the right

    // fix for bug 41111
    Control[] children = getChildren();
    bool[] manualMove = new bool[children.length];
    for (int i = 0; i < children.length; i++) {
        dwt.graphics.Rectangle.Rectangle bounds = children[i].getBounds();
        manualMove[i] = blit.width <= 0 || bounds.x > blit.x + blit.width
                || bounds.y > blit.y + blit.height || bounds.x + bounds.width < blit.x
                || bounds.y + bounds.height < blit.y;
    }
    scroll(dest.x, dest.y, blit.x, blit.y, blit.width, blit.height, true);
    for (int i = 0; i < children.length; i++) {
        if (children[i].isDisposed ())
            continue;
        dwt.graphics.Rectangle.Rectangle bounds = children[i].getBounds();
        if (manualMove[i])
            children[i].setBounds(bounds.x + dx, bounds.y, bounds.width, bounds.height);
    }

    getViewport().setIgnoreScroll(true);
    getViewport().setHorizontalLocation(hOffset);
    getViewport().setIgnoreScroll(false);
    redraw(expose.x, expose.y, expose.width, expose.height, true);
}

/**
 * Scrolls the contents vertically so that they are offset by <code>vOffset</code>.
 *
 * @param vOffset the new vertical offset
 */
public void scrollToY(int vOffset) {
    vOffset = verifyScrollBarOffset(getViewport().getVerticalRangeModel(), vOffset);
    int vOffsetOld = getViewport().getViewLocation().y;
    if (vOffset is vOffsetOld)
        return;
    int dy = -vOffset + vOffsetOld;

    Rectangle clientArea = getViewport().getBounds().getCropped(getViewport().getInsets());
    Rectangle blit = clientArea.getResized(0, -Math.abs(dy));
    Rectangle expose = clientArea.getCopy();
    Point dest = clientArea.getTopLeft();
    expose.height = Math.abs(dy);
    if (dy < 0) { //Moving up?
        blit.translate(0, -dy); //Move blit area down
        expose.y = dest.y + blit.height; //Move expose area down
    } else //Moving down
        dest.y += dy;

    // fix for bug 41111
    Control[] children = getChildren();
    bool[] manualMove = new bool[children.length];
    for (int i = 0; i < children.length; i++) {
        dwt.graphics.Rectangle.Rectangle bounds = children[i].getBounds();
        manualMove[i] = blit.height <= 0 || bounds.x > blit.x + blit.width
                || bounds.y > blit.y + blit.height || bounds.x + bounds.width < blit.x
                || bounds.y + bounds.height < blit.y;
    }
    scroll(dest.x, dest.y, blit.x, blit.y, blit.width, blit.height, true);
    for (int i = 0; i < children.length; i++) {
        if (children[i].isDisposed ())
            continue;
        dwt.graphics.Rectangle.Rectangle bounds = children[i].getBounds();
        if (manualMove[i])
            children[i].setBounds(bounds.x, bounds.y + dy, bounds.width, bounds.height);
    }

    getViewport().setIgnoreScroll(true);
    getViewport().setVerticalLocation(vOffset);
    getViewport().setIgnoreScroll(false);
    redraw(expose.x, expose.y, expose.width, expose.height, true);
}

/**
 * Sets the given border on the LightweightSystem's root figure.
 *
 * @param   border  The new border
 */
public void setBorder(Border border) {
    getLightweightSystem().getRootFigure().setBorder(border);
}

/**
 * Sets the contents of the {@link Viewport}.
 *
 * @param figure the new contents
 */
public void setContents(IFigure figure) {
    getViewport().setContents(figure);
}

/**
 * @see dwt.widgets.Control#setFont(dwt.graphics.Font)
 */
public void setFont(Font font) {
    this.font = font;
    super.setFont(font);
}

/**
 * Sets the horizontal scrollbar visibility.  Possible values are {@link #AUTOMATIC},
 * {@link #ALWAYS}, and {@link #NEVER}.
 *
 * @param v the new visibility
 */
public void setHorizontalScrollBarVisibility(int v) {
    hBarVisibility = v;
}

/**
 * Sets both the horizontal and vertical scrollbar visibility to the given value.
 * Possible values are {@link #AUTOMATIC}, {@link #ALWAYS}, and {@link #NEVER}.
 * @param both the new visibility
 */
public void setScrollBarVisibility(int both) {
    setHorizontalScrollBarVisibility(both);
    setVerticalScrollBarVisibility(both);
}

/**
 * Sets the vertical scrollbar visibility.  Possible values are {@link #AUTOMATIC},
 * {@link #ALWAYS}, and {@link #NEVER}.
 *
 * @param v the new visibility
 */
public void setVerticalScrollBarVisibility(int v) {
    vBarVisibility = v;
}

/**
 * Sets the Viewport. The given Viewport must use "fake" scrolling. That is, it must be
 * constructed using <code>new Viewport(true)</code>.
 *
 * @param vp the new viewport
 */
public void setViewport(Viewport vp) {
    if (viewport !is null)
        unhookViewport();
    viewport = vp;
    lws.setContents(viewport);
    hookViewport();
}

private int verifyScrollBarOffset(RangeModel model, int value) {
    value = Math.max(model.getMinimum(), value);
    return Math.min(model.getMaximum() - model.getExtent(), value);
}

}
