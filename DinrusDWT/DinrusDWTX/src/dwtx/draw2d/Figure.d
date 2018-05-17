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
module dwtx.draw2d.Figure;

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Bean;
import dwtx.dwtxhelper.Collection;

import dwt.graphics.Color;
import dwt.graphics.Cursor;
import dwt.graphics.Font;
import dwtx.draw2d.geometry.Dimension;
import dwtx.draw2d.geometry.Insets;
import dwtx.draw2d.geometry.Point;
import dwtx.draw2d.geometry.Rectangle;
import dwtx.draw2d.geometry.Translatable;
import dwtx.draw2d.IFigure;
import dwtx.draw2d.LayoutManager;
import dwtx.draw2d.EventListenerList;
import dwtx.draw2d.Border;
import dwtx.draw2d.AncestorHelper;
import dwtx.draw2d.CoordinateListener;
import dwtx.draw2d.FigureListener;
import dwtx.draw2d.FocusListener;
import dwtx.draw2d.KeyListener;
import dwtx.draw2d.MouseListener;
import dwtx.draw2d.MouseMotionListener;
import dwtx.draw2d.TreeSearch;
import dwtx.draw2d.LayoutListener;
import dwtx.draw2d.UpdateManager;
import dwtx.draw2d.Graphics;
import dwtx.draw2d.AncestorListener;
import dwtx.draw2d.MouseEvent;
import dwtx.draw2d.EventDispatcher;
import dwtx.draw2d.FocusEvent;
import dwtx.draw2d.KeyEvent;
import dwtx.draw2d.AncestorHelper;
import dwtx.draw2d.ExclusionSearch;
import dwtx.draw2d.AbstractBackground;
import dwtx.draw2d.Orientable;
import dwtx.draw2d.GraphicsSource;

/**
 * The base implementation for graphical figures.
 */
public class Figure
    : IFigure
{

private static /+const+/ Rectangle PRIVATE_RECT;
private static /+const+/ Point PRIVATE_POINT;
private static const int
    FLAG_VALID   = 1,
    FLAG_OPAQUE  = (1 << 1),
    FLAG_VISIBLE = (1 << 2),
    FLAG_FOCUSABLE = (1 << 3),
    FLAG_ENABLED = (1 << 4),
    FLAG_FOCUS_TRAVERSABLE = (1 << 5);

static const int
    FLAG_REALIZED = 1 << 31;

/**
 * The largest flag defined in this class.  If subclasses define flags, they should
 * declare them as larger than this value and redefine MAX_FLAG to be their largest flag
 * value.
 * <P>
 * This constant is evaluated at runtime and will not be inlined by the compiler.
 */
protected static const int MAX_FLAG = FLAG_FOCUS_TRAVERSABLE;

/**
 * The rectangular area that this Figure occupies.
 */
protected Rectangle bounds;

private LayoutManager layoutManager;

/**
 * The flags for this Figure.
 */
protected int flags = FLAG_VISIBLE | FLAG_ENABLED;

private IFigure parent;
private Cursor cursor;

private PropertyChangeSupport propertyListeners;
private EventListenerList eventListeners;

private List children;

/**
 * This Figure's preferred size.
 */
protected Dimension prefSize;

/**
 * This Figure's minimum size.
 */
protected Dimension minSize;

/**
 * This Figure's maximum size.
 */
protected Dimension maxSize;

/**
 * @deprecated access using {@link #getLocalFont()}
 */
protected Font font;

/**
 * @deprecated access using {@link #getLocalBackgroundColor()}.
 */
protected Color bgColor;

/**
 * @deprecated access using {@link #getLocalForegroundColor()}.
 */
protected Color fgColor;

/**
 * @deprecated access using {@link #getBorder()}
 */
protected Border border;

/**
 * @deprecated access using {@link #getToolTip()}
 */
protected IFigure toolTip;

private AncestorHelper ancestorHelper;

private static void static_this(){
    if( PRIVATE_RECT is null ){
        synchronized( Figure.classinfo ){
            if( PRIVATE_RECT is null ){
                PRIVATE_RECT = new Rectangle();
                PRIVATE_POINT = new Point();
            }
        }
    }
}

private void instanceInit(){
    static_this();
    bounds = new Rectangle(0, 0, 0, 0);
    eventListeners = new EventListenerList();
    children = Collections.EMPTY_LIST;
}

this(){
    instanceInit();
}
/**
 * Calls {@link #add(IFigure, Object, int)} with -1 as the index.
 * @see IFigure#add(IFigure, Object)
 */
public final void add(IFigure figure, Object constraint) {
    add(figure, constraint, -1);
}

/**
 * @see IFigure#add(IFigure, Object, int)
 */
public void add(IFigure figure, Object constraint, int index) {
    if (children is Collections.EMPTY_LIST)
        children = new ArrayList(2);
    if (index < -1 || index > children.size())
        throw new IndexOutOfBoundsException("Index does not exist"); //$NON-NLS-1$

    //Check for Cycle in hierarchy
    for (IFigure f = this; f !is null; f = f.getParent())
        if (figure is f)
            throw new IllegalArgumentException(
                        "Figure being added introduces cycle"); //$NON-NLS-1$

    //Detach the child from previous parent
    if (figure.getParent() !is null)
        figure.getParent().remove(figure);

    if (index is -1)
        children.add(cast(Object) figure);
    else
        children.add(index, cast(Object)figure);
    figure.setParent(this);

    if (layoutManager !is null)
        layoutManager.setConstraint(figure, constraint);

    revalidate();

    if (getFlag(FLAG_REALIZED))
        figure.addNotify();
    figure.repaint();
}

/**
 * Calls {@link #add(IFigure, Object, int)} with <code>null</code> as the constraint and
 * -1 as the index.
 * @see IFigure#add(IFigure)
 */
public final void add(IFigure figure) {
    add(figure, null, -1);
}

/**
 * Calls {@link #add(IFigure, Object, int)} with <code>null</code> as the constraint.
 * @see IFigure#add(IFigure, int)
 */
public final void add(IFigure figure, int index) {
    add(figure, null, index);
}
/**
 * @see IFigure#addAncestorListener(AncestorListener)
 */
public void addAncestorListener(AncestorListener ancestorListener) {
    if (ancestorHelper is null)
        ancestorHelper = new AncestorHelper(this);
    ancestorHelper.addAncestorListener(ancestorListener);
}

/**
 * @see IFigure#addCoordinateListener(CoordinateListener)
 */
public void addCoordinateListener(CoordinateListener listener) {
    eventListeners.addListener(CoordinateListener.classinfo, cast(Object)listener);
}

/**
 * @see IFigure#addFigureListener(FigureListener)
 */
public void addFigureListener(FigureListener listener) {
    eventListeners.addListener(FigureListener.classinfo, cast(Object)listener);
}

/**
 * @see IFigure#addFocusListener(FocusListener)
 */
public void addFocusListener(FocusListener listener) {
    eventListeners.addListener(FocusListener.classinfo, cast(Object)listener);
}

/**
 * @see IFigure#addKeyListener(KeyListener)
 */
public void addKeyListener(KeyListener listener) {
    eventListeners.addListener(KeyListener.classinfo, cast(Object)listener);
}

/**
 * Appends the given layout listener to the list of layout listeners.
 * @since 3.1
 * @param listener the listener being added
 */
public void addLayoutListener(LayoutListener listener) {
    if (auto n = cast(LayoutNotifier)layoutManager ) {
        LayoutNotifier notifier = n;
        notifier.listeners.add(cast(Object)listener);
    } else
        layoutManager = new LayoutNotifier(layoutManager, listener);
}

/**
 * Adds a listener of type <i>clazz</i> to this Figure's list of event listeners.
 * @param clazz The listener type
 * @param listener The listener
 */
protected void addListener(ClassInfo clazz, Object listener) {
    eventListeners.addListener(clazz, cast(Object)listener);
}

/**
 * @see IFigure#addMouseListener(MouseListener)
 */
public void addMouseListener(MouseListener listener) {
    eventListeners.addListener(MouseListener.classinfo, cast(Object)listener);
}

/**
 * @see IFigure#addMouseMotionListener(MouseMotionListener)
 */
public void addMouseMotionListener(MouseMotionListener listener) {
    eventListeners.addListener(MouseMotionListener.classinfo, cast(Object)listener);
}

/**
 * Called after the receiver's parent has been set and it has been added to its parent.
 *
 * @since 2.0
 */
public void addNotify() {
    if (getFlag(FLAG_REALIZED))
        throw new RuntimeException("addNotify() should not be called multiple times"); //$NON-NLS-1$
    setFlag(FLAG_REALIZED, true);
    assert(children);
    for (int i = 0; i < children.size(); i++){
        assert(children.get(i));
        assert(cast(IFigure)children.get(i));
        (cast(IFigure)children.get(i)).addNotify();
    }
}

/**
 * @see IFigure#addPropertyChangeListener(String,
 * PropertyChangeListener)
 */
public void addPropertyChangeListener(String property, PropertyChangeListener listener) {
    if (propertyListeners is null)
        propertyListeners = new PropertyChangeSupport(this);
    propertyListeners.addPropertyChangeListener(property, listener);
}

/**
 * @see IFigure#addPropertyChangeListener(PropertyChangeListener)
 */
public void addPropertyChangeListener(PropertyChangeListener listener) {
    if (propertyListeners is null)
        propertyListeners = new PropertyChangeSupport(this);
    propertyListeners.addPropertyChangeListener(listener);
}

/**
 * This method is final.  Override {@link #containsPoint(int, int)} if needed.
 * @see IFigure#containsPoint(Point)
 * @since 2.0
 */
public final bool containsPoint(Point p) {
    return containsPoint(p.x, p.y);
}

/**
 * @see IFigure#containsPoint(int, int)
 */
public bool containsPoint(int x, int y) {
    return getBounds().contains(x, y);
}

/**
 * @see IFigure#erase()
 */
public void erase() {
    if (getParent() is null || !isVisible())
        return;

    Rectangle r = new Rectangle(getBounds());
    getParent().translateToParent(r);
    getParent().repaint(r.x, r.y, r.width, r.height);
}

/**
 * Returns a descendant of this Figure such that the Figure returned contains the point
 * (x, y), and is accepted by the given TreeSearch. Returns <code>null</code> if none
 * found.
 * @param x The X coordinate
 * @param y The Y coordinate
 * @param search the TreeSearch
 * @return The descendant Figure at (x,y)
 */
protected IFigure findDescendantAtExcluding(int x, int y, TreeSearch search) {
    PRIVATE_POINT.setLocation(x, y);
    translateFromParent(PRIVATE_POINT);
    if (!getClientArea(Rectangle.SINGLETON).contains(PRIVATE_POINT))
        return null;

    x = PRIVATE_POINT.x;
    y = PRIVATE_POINT.y;
    IFigure fig;
    for (int i = children.size(); i > 0;) {
        i--;
        fig = cast(IFigure)children.get(i);
        if (fig.isVisible()) {
            fig = fig.findFigureAt(x, y, search);
            if (fig !is null)
                return fig;
        }
    }
    //No descendants were found
    return null;
}

/**
 * @see IFigure#findFigureAt(Point)
 */
public final IFigure findFigureAt(Point pt) {
    return findFigureAtExcluding(pt.x, pt.y, Collections.EMPTY_LIST);
}

/**
 * @see IFigure#findFigureAt(int, int)
 */
public final IFigure findFigureAt(int x, int y) {
    return findFigureAt(x, y, IdentitySearch.INSTANCE);
}

/**
 * @see IFigure#findFigureAt(int, int, TreeSearch)
 */
public IFigure findFigureAt(int x, int y, TreeSearch search) {
    if (!containsPoint(x, y))
        return null;
    if (search.prune(this))
        return null;
    IFigure child = findDescendantAtExcluding(x, y, search);
    if (child !is null)
        return child;
    if (search.accept(this))
        return this;
    return null;
}

/**
 * @see IFigure#findFigureAtExcluding(int, int, Collection)
 */
public final IFigure findFigureAtExcluding(int x, int y, Collection c) {
    return findFigureAt(x, y, new ExclusionSearch(c));
}

/**
 * Returns the deepest descendant for which {@link #isMouseEventTarget()} returns
 * <code>true</code> or <code>null</code> if none found. The Parameters <i>x</i> and
 * <i>y</i> are absolute locations. Any Graphics transformations applied by this Figure to
 * its children during {@link #paintChildren(Graphics)} (thus causing the children to
 * appear transformed to the user) should be applied inversely to the points <i>x</i> and
 * <i>y</i> when called on the children.
 *
 * @param x The X coordinate
 * @param y The Y coordinate
 * @return The deepest descendant for which isMouseEventTarget() returns true
 */
public IFigure findMouseEventTargetAt(int x, int y) {
    if (!containsPoint(x, y))
        return null;
    IFigure f = findMouseEventTargetInDescendantsAt(x, y);
    if (f !is null)
        return f;
    if (isMouseEventTarget())
        return this;
    return null;
}

/**
 * Searches this Figure's children for the deepest descendant for which
 * {@link #isMouseEventTarget()} returns <code>true</code> and returns that descendant or
 * <code>null</code> if none found.
 * @see #findMouseEventTargetAt(int, int)
 * @param x The X coordinate
 * @param y The Y coordinate
 * @return The deepest descendant for which isMouseEventTarget() returns true
 */
protected IFigure findMouseEventTargetInDescendantsAt(int x, int y) {
    PRIVATE_POINT.setLocation(x, y);
    translateFromParent(PRIVATE_POINT);

    if (!getClientArea(Rectangle.SINGLETON).contains(PRIVATE_POINT))
        return null;

    IFigure fig;
    for (int i = children.size(); i > 0;) {
        i--;
        fig = cast(IFigure)children.get(i);
        if (fig.isVisible() && fig.isEnabled()) {
            if (fig.containsPoint(PRIVATE_POINT.x, PRIVATE_POINT.y)) {
                fig = fig.findMouseEventTargetAt(PRIVATE_POINT.x, PRIVATE_POINT.y);
                return fig;
            }
        }
    }
    return null;
}

/**
 * Notifies to all {@link CoordinateListener}s that this figure's local coordinate system
 * has changed in a way which affects the absolute bounds of figures contained within.
 *
 * @since 3.1
 */
protected void fireCoordinateSystemChanged() {
    if (!eventListeners.containsListener(CoordinateListener.classinfo))
        return;
    Iterator figureListeners = eventListeners.getListeners(CoordinateListener.classinfo);
    while (figureListeners.hasNext())
        (cast(CoordinateListener)figureListeners.next()).
            coordinateSystemChanged(this);
}

/**
 * Notifies to all {@link FigureListener}s that this figure has moved. Moved means
 * that the bounds have changed in some way, location and/or size.
 * @since 3.1
 */
protected void fireFigureMoved() {
    if (!eventListeners.containsListener(FigureListener.classinfo))
        return;
    Iterator figureListeners = eventListeners.getListeners(FigureListener.classinfo);
    while (figureListeners.hasNext())
        (cast(FigureListener)figureListeners.next()).
            figureMoved(this);
}

/**
 * Fires both figuremoved and coordinate system changed. This method exists for
 * compatibility. Some listeners which used to listen for figureMoved now listen for
 * coordinates changed.  So to be sure that those new listeners are notified, any client
 * code which used called this method will also result in notification of coordinate
 * changes.
 * @since 2.0
 * @deprecated call fireFigureMoved() or fireCoordinateSystemChanged() as appropriate
 */
protected void fireMoved() {
    fireFigureMoved();
    fireCoordinateSystemChanged();
}

/**
 * Notifies any {@link PropertyChangeListener PropertyChangeListeners} listening to this
 * Figure that the bool property with id <i>property</i> has changed.
 * @param property The id of the property that changed
 * @param old The old value of the changed property
 * @param current The current value of the changed property
 * @since 2.0
 */
protected void firePropertyChange(String property, bool old, bool current) {
    if (propertyListeners is null)
        return;
    propertyListeners.firePropertyChange(property, old, current);
}

/**
 * Notifies any {@link PropertyChangeListener PropertyChangeListeners} listening to this
 * figure that the Object property with id <i>property</i> has changed.
 * @param property The id of the property that changed
 * @param old The old value of the changed property
 * @param current The current value of the changed property
 * @since 2.0
 */
protected void firePropertyChange(String property, Object old, Object current) {
    if (propertyListeners is null)
        return;
    propertyListeners.firePropertyChange(property, old, current);
}

/**
 * Notifies any {@link PropertyChangeListener PropertyChangeListeners} listening to this
 * figure that the integer property with id <code>property</code> has changed.
 * @param property The id of the property that changed
 * @param old The old value of the changed property
 * @param current The current value of the changed property
 * @since 2.0
 */
protected void firePropertyChange(String property, int old, int current) {
    if (propertyListeners is null)
        return;
    propertyListeners.firePropertyChange(property, old, current);
}

/**
 * Returns this Figure's background color.  If this Figure's background color is
 * <code>null</code> and its parent is not <code>null</code>, the background color is
 * inherited from the parent.
 * @see IFigure#getBackgroundColor()
 */
public Color getBackgroundColor() {
    if (bgColor is null && getParent() !is null)
        return getParent().getBackgroundColor();
    return bgColor;
}

/**
 * @see IFigure#getBorder()
 */
public Border getBorder() {
    return border;
}

/**
 * Returns the smallest rectangle completely enclosing the figure. Implementors may return
 * the Rectangle by reference. For this reason, callers of this method must not modify the
 * returned Rectangle.
 * @return The bounds of this Figure
 */
public Rectangle getBounds() {
    return bounds;
}

/**
 * @see IFigure#getChildren()
 */
public List getChildren() {
    return children;
}

/**
 * @see IFigure#getClientArea(Rectangle)
 */
public Rectangle getClientArea(Rectangle rect) {
    rect.setBounds(getBounds());
    rect.crop(getInsets());
    if (useLocalCoordinates())
        rect.setLocation(0, 0);
    return rect;
}

/**
 * @see IFigure#getClientArea()
 */
public final Rectangle getClientArea() {
    return getClientArea(new Rectangle());
}

/**
 * @see IFigure#getCursor()
 */
public Cursor getCursor() {
    if (cursor is null && getParent() !is null)
        return getParent().getCursor();
    return cursor;
}

/**
 * Returns the value of the given flag.
 * @param flag The flag to get
 * @return The value of the given flag
 */
protected bool getFlag(int flag) {
    return (flags & flag) !is 0;
}

/**
 * @see IFigure#getFont()
 */
public Font getFont() {
    if (font !is null)
        return font;
    if (getParent() !is null)
        return getParent().getFont();
    return null;
}

/**
 * @see IFigure#getForegroundColor()
 */
public Color getForegroundColor() {
    if (fgColor is null && getParent() !is null)
        return getParent().getForegroundColor();
    return fgColor;
}

/**
 * Returns the border's Insets if the border is set. Otherwise returns NO_INSETS, an
 * instance of Insets with all 0s. Returns Insets by reference.  DO NOT Modify returned
 * value. Cannot return null.
 * @return This Figure's Insets
 */
public Insets getInsets() {
    if (getBorder() !is null)
        return getBorder().getInsets(this);
    return IFigure_NO_INSETS;
}

/**
 * @see IFigure#getLayoutManager()
 */
public LayoutManager getLayoutManager() {
    if (auto n = cast(LayoutNotifier)layoutManager )
        return n.realLayout;
    return layoutManager;
}

/**
 * Returns an Iterator over the listeners of type <i>clazz</i> that are listening to
 * this Figure. If there are no listeners of type <i>clazz</i>, an empty iterator is
 * returned.
 * @param clazz The type of listeners to get
 * @return An Iterator over the requested listeners
 * @since 2.0
 */
protected Iterator getListeners(ClassInfo clazz) {
    if (eventListeners is null)
        return Collections.EMPTY_LIST.iterator();
    return eventListeners.getListeners(clazz);
}

/**
 * Returns <code>null</code> or the local background Color of this Figure. Does not
 * inherit this Color from the parent.
 * @return bgColor <code>null</code> or the local background Color
 */
public Color getLocalBackgroundColor() {
    return bgColor;
}

/**
 * Returns <code>null</code> or the local font setting for this figure.  Does not return
 * values inherited from the parent figure.
 * @return <code>null</code> or the local font
 * @since 3.1
 */
protected Font getLocalFont() {
    return font;
}

/**
 * Returns <code>null</code> or the local foreground Color of this Figure. Does not
 * inherit this Color from the parent.
 * @return fgColor <code>null</code> or the local foreground Color
 */
public Color getLocalForegroundColor() {
    return fgColor;
}

/**
 * Returns the top-left corner of this Figure's bounds.
 * @return The top-left corner of this Figure's bounds
 * @since 2.0
 */
public final Point getLocation() {
    return getBounds().getLocation();
}

/**
 * @see IFigure#getMaximumSize()
 */
public Dimension getMaximumSize() {
    if (maxSize !is null)
        return maxSize;
    return IFigure_MAX_DIMENSION;
}

/**
 * @see IFigure#getMinimumSize()
 */
public final Dimension getMinimumSize() {
    return getMinimumSize(-1, -1);
}

/**
 * @see IFigure#getMinimumSize(int, int)
 */
public Dimension getMinimumSize(int wHint, int hHint) {
    if (minSize !is null)
        return minSize;
    if (getLayoutManager() !is null) {
        Dimension d = getLayoutManager().getMinimumSize(this, wHint, hHint);
        if (d !is null)
            return d;
    }
    return getPreferredSize(wHint, hHint);
}

/**
 * @see IFigure#getParent()
 */
public IFigure getParent() {
    return parent;
}

/**
 * @see IFigure#getPreferredSize()
 */
public final Dimension getPreferredSize() {
    return getPreferredSize(-1, -1);
}

/**
 * @see IFigure#getPreferredSize(int, int)
 */
public Dimension getPreferredSize(int wHint, int hHint) {
    if (prefSize !is null)
        return prefSize;
    if (getLayoutManager() !is null) {
        Dimension d = getLayoutManager().getPreferredSize(this, wHint, hHint);
        if (d !is null)
            return d;
    }
    return getSize();
}

/**
 * @see IFigure#getSize()
 */
public final Dimension getSize() {
    return getBounds().getSize();
}

/**
 * @see IFigure#getToolTip()
 */
public IFigure getToolTip() {
    return toolTip;
}

/**
 * @see IFigure#getUpdateManager()
 */
public UpdateManager getUpdateManager() {
    if (getParent() !is null)
        return getParent().getUpdateManager();
    // Only happens when the figure has not been realized
    return NO_MANAGER;
}

/**
 * @see IFigure#handleFocusGained(FocusEvent)
 */
public void handleFocusGained(FocusEvent event) {
    Iterator iter = eventListeners.getListeners(FocusListener.classinfo);
    while (iter.hasNext())
        (cast(FocusListener)iter.next()).
            focusGained(event);
}

/**
 * @see IFigure#handleFocusLost(FocusEvent)
 */
public void handleFocusLost(FocusEvent event) {
    Iterator iter = eventListeners.getListeners(FocusListener.classinfo);
    while (iter.hasNext())
        (cast(FocusListener)iter.next()).
            focusLost(event);
}

/**
 * @see IFigure#handleKeyPressed(KeyEvent)
 */
public void handleKeyPressed(KeyEvent event) {
    Iterator iter = eventListeners.getListeners(KeyListener.classinfo);
    while (!event.isConsumed() && iter.hasNext())
        (cast(KeyListener)iter.next()).
            keyPressed(event);
}

/**
 * @see IFigure#handleKeyReleased(KeyEvent)
 */
public void handleKeyReleased(KeyEvent event) {
    Iterator iter = eventListeners.getListeners(KeyListener.classinfo);
    while (!event.isConsumed() && iter.hasNext())
        (cast(KeyListener)iter.next()).
            keyReleased(event);
}

/**
 * @see IFigure#handleMouseDoubleClicked(MouseEvent)
 */
public void handleMouseDoubleClicked(MouseEvent event) {
    Iterator iter = eventListeners.getListeners(MouseListener.classinfo);
    while (!event.isConsumed() && iter.hasNext())
        (cast(MouseListener)iter.next()).
            mouseDoubleClicked(event);
}

/**
 * @see IFigure#handleMouseDragged(MouseEvent)
 */
public void handleMouseDragged(MouseEvent event) {
    Iterator iter = eventListeners.getListeners(MouseMotionListener.classinfo);
    while (!event.isConsumed() && iter.hasNext())
        (cast(MouseMotionListener)iter.next()).
            mouseDragged(event);
}

/**
 * @see IFigure#handleMouseEntered(MouseEvent)
 */
public void handleMouseEntered(MouseEvent event) {
    Iterator iter = eventListeners.getListeners(MouseMotionListener.classinfo);
    while (!event.isConsumed() && iter.hasNext())
        (cast(MouseMotionListener)iter.next()).
            mouseEntered(event);
}

/**
 * @see IFigure#handleMouseExited(MouseEvent)
 */
public void handleMouseExited(MouseEvent event) {
    Iterator iter = eventListeners.getListeners(MouseMotionListener.classinfo);
    while (!event.isConsumed() && iter.hasNext())
        (cast(MouseMotionListener)iter.next()).
            mouseExited(event);
}

/**
 * @see IFigure#handleMouseHover(MouseEvent)
 */
public void handleMouseHover(MouseEvent event) {
    Iterator iter = eventListeners.getListeners(MouseMotionListener.classinfo);
    while (!event.isConsumed() && iter.hasNext())
        (cast(MouseMotionListener)iter.next()).
            mouseHover(event);
}

/**
 * @see IFigure#handleMouseMoved(MouseEvent)
 */
public void handleMouseMoved(MouseEvent event) {
    Iterator iter = eventListeners.getListeners(MouseMotionListener.classinfo);
    while (!event.isConsumed() && iter.hasNext())
        (cast(MouseMotionListener)iter.next()).
            mouseMoved(event);
}

/**
 * @see IFigure#handleMousePressed(MouseEvent)
 */
public void handleMousePressed(MouseEvent event) {
    Iterator iter = eventListeners.getListeners(MouseListener.classinfo);
    while (!event.isConsumed() && iter.hasNext())
        (cast(MouseListener)iter.next()).
            mousePressed(event);
}

/**
 * @see IFigure#handleMouseReleased(MouseEvent)
 */
public void handleMouseReleased(MouseEvent event) {
    Iterator iter = eventListeners.getListeners(MouseListener.classinfo);
    while (!event.isConsumed() && iter.hasNext())
        (cast(MouseListener)iter.next()).
            mouseReleased(event);
}

/**
 * @see IFigure#hasFocus()
 */
public bool hasFocus() {
    EventDispatcher dispatcher = internalGetEventDispatcher();
    if (dispatcher is null)
        return false;
    return dispatcher.getFocusOwner() is this;
}

/**
 * @see IFigure#internalGetEventDispatcher()
 */
public EventDispatcher internalGetEventDispatcher() {
    if (getParent() !is null)
        return getParent().internalGetEventDispatcher();
    return null;
}

/**
 * @see IFigure#intersects(Rectangle)
 */
public bool intersects(Rectangle rect) {
    return getBounds().intersects(rect);
}

/**
 * @see IFigure#invalidate()
 */
public void invalidate() {
    if (layoutManager !is null)
        layoutManager.invalidate();
    setValid(false);
}

/**
 * @see IFigure#invalidateTree()
 */
public void invalidateTree() {
    invalidate();
    for (Iterator iter = children.iterator(); iter.hasNext();) {
        IFigure child = cast(IFigure) iter.next();
        child.invalidateTree();
    }
}

/**
 * @see IFigure#isCoordinateSystem()
 */
public bool isCoordinateSystem() {
    return useLocalCoordinates();
}

/**
 * @see IFigure#isEnabled()
 */
public bool isEnabled() {
    return (flags & FLAG_ENABLED) !is 0;
}

/**
 * @see IFigure#isFocusTraversable()
 */
public bool isFocusTraversable() {
    return (flags & FLAG_FOCUS_TRAVERSABLE) !is 0;
}

/**
 * Returns <code>true</code> if this Figure can receive {@link MouseEvent MouseEvents}.
 * @return <code>true</code> if this Figure can receive {@link MouseEvent MouseEvents}
 * @since 2.0
 */
protected bool isMouseEventTarget() {
    return (eventListeners.containsListener(MouseListener.classinfo)
        || eventListeners.containsListener(MouseMotionListener.classinfo));
}

/**
 * @see dwtx.draw2d.IFigure#isMirrored()
 */
public bool isMirrored() {
    if (getParent() !is null)
        return getParent().isMirrored();
    return false;
}

/**
 * @see IFigure#isOpaque()
 */
public bool isOpaque() {
    return (flags & FLAG_OPAQUE) !is 0;
}

/**
 * @see IFigure#isRequestFocusEnabled()
 */
public bool isRequestFocusEnabled() {
    return (flags & FLAG_FOCUSABLE) !is 0;
}

/**
 * @see IFigure#isShowing()
 */
public bool isShowing() {
    return isVisible()
      && (getParent() is null
        || getParent().isShowing());
}

/**
 * Returns <code>true</code> if this Figure is valid.
 * @return <code>true</code> if this Figure is valid
 * @since 2.0
 */
protected bool isValid() {
    return (flags & FLAG_VALID) !is 0;
}

/**
 * Returns <code>true</code> if revalidating this Figure does not require revalidating its
 * parent.
 * @return <code>true</code> if revalidating this Figure doesn't require revalidating its
 * parent.
 * @since 2.0
 */
protected bool isValidationRoot() {
    return false;
}

/**
 * @see IFigure#isVisible()
 */
public bool isVisible() {
    return getFlag(FLAG_VISIBLE);
}

/**
 * Lays out this Figure using its {@link LayoutManager}.
 *
 * @since 2.0
 */
protected void layout() {
    if (layoutManager !is null)
        layoutManager.layout(this);
}

/**
 * Paints this Figure and its children.
 * @param graphics The Graphics object used for painting
 * @see #paintFigure(Graphics)
 * @see #paintClientArea(Graphics)
 * @see #paintBorder(Graphics)
 */
public void paint(Graphics graphics) {
    if (getLocalBackgroundColor() !is null)
        graphics.setBackgroundColor(getLocalBackgroundColor());
    if (getLocalForegroundColor() !is null)
        graphics.setForegroundColor(getLocalForegroundColor());
    if (font !is null)
        graphics.setFont(font);

    graphics.pushState();
    try {
        paintFigure(graphics);
        graphics.restoreState();
        paintClientArea(graphics);
        paintBorder(graphics);
    } finally {
        graphics.popState();
    }
}

/**
 * Paints the border associated with this Figure, if one exists.
 * @param graphics The Graphics used to paint
 * @see Border#paint(IFigure, Graphics, Insets)
 * @since 2.0
 */
protected void paintBorder(Graphics graphics) {
    if (getBorder() !is null)
        getBorder().paint(this, graphics, IFigure_NO_INSETS);
}

/**
 * Paints this Figure's children. The caller must save the state of the graphics prior to
 * calling this method, such that <code>graphics.restoreState()</code> may be called
 * safely, and doing so will return the graphics to its original state when the method was
 * entered.
 * <P>
 * This method must leave the Graphics in its original state upon return.
 * @param graphics the graphics used to paint
 * @since 2.0
 */
protected void paintChildren(Graphics graphics) {
    IFigure child;

    Rectangle clip = Rectangle.SINGLETON;
    for (int i = 0; i < children.size(); i++) {
        child = cast(IFigure)children.get(i);
        if (child.isVisible() && child.intersects(graphics.getClip(clip))) {
            graphics.clipRect(child.getBounds());
            child.paint(graphics);
            graphics.restoreState();
        }
    }
}

/**
 * Paints this Figure's client area. The client area is typically defined as the anything
 * inside the Figure's {@link Border} or {@link Insets}, and by default includes the
 * children of this Figure. On return, this method must leave the given Graphics in its
 * initial state.
 * @param graphics The Graphics used to paint
 * @since 2.0
 */
protected void paintClientArea(Graphics graphics) {
    if (children.isEmpty())
        return;

    bool optimizeClip = getBorder() is null || getBorder().isOpaque();

    if (useLocalCoordinates()) {
        graphics.translate(
            getBounds().x + getInsets().left,
            getBounds().y + getInsets().top);
        if (!optimizeClip)
            graphics.clipRect(getClientArea(PRIVATE_RECT));
        graphics.pushState();
        paintChildren(graphics);
        graphics.popState();
        graphics.restoreState();
    } else {
        if (optimizeClip)
            paintChildren(graphics);
        else {
            graphics.clipRect(getClientArea(PRIVATE_RECT));
            graphics.pushState();
            paintChildren(graphics);
            graphics.popState();
            graphics.restoreState();
        }
    }
}

/**
 * Paints this Figure's primary representation, or background. Changes made to the
 * graphics to the graphics current state will not affect the subsequent calls to {@link
 * #paintClientArea(Graphics)} and {@link #paintBorder(Graphics)}. Furthermore, it is safe
 * to call <code>graphics.restoreState()</code> within this method, and doing so will
 * restore the graphics to its original state upon entry.
 * @param graphics The Graphics used to paint
 * @since 2.0
 */
protected void paintFigure(Graphics graphics) {
    if (isOpaque())
        graphics.fillRectangle(getBounds());
    if (null !is cast(AbstractBackground)getBorder() )
        (cast(AbstractBackground) getBorder()).paintBackground(this, graphics, IFigure_NO_INSETS);
}

/**
 * Translates this Figure's bounds, without firing a move.
 * @param dx The amount to translate horizontally
 * @param dy The amount to translate vertically
 * @see #translate(int, int)
 * @since 2.0
 */
protected void primTranslate(int dx, int dy) {
    bounds.x += dx;
    bounds.y += dy;
    if (useLocalCoordinates()) {
        fireCoordinateSystemChanged();
        return;
    }
    for (int i = 0; i < children.size(); i++)
        (cast(IFigure)children.get(i)).translate(dx, dy);
}

/**
 * Removes the given child Figure from this Figure's hierarchy and revalidates this
 * Figure. The child Figure's {@link #removeNotify()} method is also called.
 * @param figure The Figure to remove
 */
public void remove(IFigure figure) {
    if ((figure.getParent() !is this))
        throw new IllegalArgumentException(
                "Figure is not a child"); //$NON-NLS-1$
    if (getFlag(FLAG_REALIZED))
        figure.removeNotify();
    if (layoutManager !is null)
        layoutManager.remove(figure);
    // The updates in the UpdateManager *have* to be
    // done asynchronously, else will result in
    // incorrect dirty region corrections.
    figure.erase();
    figure.setParent(null);
    children.remove(cast(Object)figure);
    revalidate();
}

/**
 * Removes all children from this Figure.
 *
 * @see #remove(IFigure)
 * @since 2.0
 */
public void removeAll() {
    List list = new ArrayList(getChildren());
    for (int i = 0; i < list.size(); i++) {
        remove(cast(IFigure)list.get(i));
    }
}

/**
 * @see IFigure#removeAncestorListener(AncestorListener)
 */
public void removeAncestorListener(AncestorListener listener) {
    if (ancestorHelper !is null) {
        ancestorHelper.removeAncestorListener(listener);
        if (ancestorHelper.isEmpty()) {
            ancestorHelper.dispose();
            ancestorHelper = null;
        }
    }
}

/**
 * @see IFigure#removeCoordinateListener(CoordinateListener)
 */
public void removeCoordinateListener(CoordinateListener listener) {
    eventListeners.removeListener(CoordinateListener.classinfo, cast(Object)listener);
}

/**
 * @see IFigure#removeFigureListener(FigureListener)
 */
public void removeFigureListener(FigureListener listener) {
    eventListeners.removeListener(FigureListener.classinfo, cast(Object)listener);
}

/**
 * @see IFigure#removeFocusListener(FocusListener)
 */
public void removeFocusListener(FocusListener listener) {
    eventListeners.removeListener(FocusListener.classinfo, cast(Object)listener);
}

/**
 * @see IFigure#removeKeyListener(KeyListener)
 */
public void removeKeyListener(KeyListener listener) {
    eventListeners.removeListener(KeyListener.classinfo, cast(Object)listener);
}

/**
 * Removes the first occurence of the given listener.
 * @since 3.1
 * @param listener the listener being removed
 */
public void removeLayoutListener(LayoutListener listener) {
    if (auto notifier = cast(LayoutNotifier)layoutManager ) {
        notifier.listeners.remove(cast(Object)listener);
        if (notifier.listeners.isEmpty())
            layoutManager = notifier.realLayout;
    }
}

/**
 * Removes <i>listener</i> of type <i>clazz</i> from this Figure's list of listeners.
 * @param clazz The type of listener
 * @param listener The listener to remove
 * @since 2.0
 */
protected void removeListener(ClassInfo clazz, Object listener) {
    if (eventListeners is null)
        return;
    eventListeners.removeListener(clazz, listener);
}

/**
 * @see IFigure#removeMouseListener(MouseListener)
 */
public void removeMouseListener(MouseListener listener) {
    eventListeners.removeListener(MouseListener.classinfo, cast(Object)listener);
}

/**
 * @see IFigure#removeMouseMotionListener(MouseMotionListener)
 */
public void removeMouseMotionListener(MouseMotionListener listener) {
    eventListeners.removeListener(MouseMotionListener.classinfo, cast(Object)listener);
}

/**
 * Called prior to this figure's removal from its parent
 */
public void removeNotify() {
    for (int i = 0; i < children.size(); i++)
        (cast(IFigure)children.get(i)).removeNotify();
    if (internalGetEventDispatcher() !is null)
        internalGetEventDispatcher().requestRemoveFocus(this);
    setFlag(FLAG_REALIZED, false);
}

/**
 * @see IFigure#removePropertyChangeListener(PropertyChangeListener)
 */
public void removePropertyChangeListener(PropertyChangeListener listener) {
    if (propertyListeners is null) return;
    propertyListeners.removePropertyChangeListener(listener);
}

/**
 * @see IFigure#removePropertyChangeListener(String, PropertyChangeListener)
 */
public void removePropertyChangeListener(
    String property,
    PropertyChangeListener listener) {
    if (propertyListeners is null) return;
    propertyListeners.removePropertyChangeListener(property, listener);
}

/**
 * @see IFigure#repaint(Rectangle)
 */
public final void repaint(Rectangle rect) {
    repaint(rect.x, rect.y, rect.width, rect.height);
}

/**
 * @see IFigure#repaint(int, int, int, int)
 */
public void repaint(int x, int y, int w, int h) {
    if (isVisible())
        getUpdateManager().addDirtyRegion(this, x, y, w, h);
}

/**
 * @see IFigure#repaint()
 */
public void repaint() {
    repaint(getBounds());
}

/**
 * @see IFigure#requestFocus()
 */
public final void requestFocus() {
    if (!isRequestFocusEnabled() || hasFocus())
        return;
    EventDispatcher dispatcher = internalGetEventDispatcher();
    if (dispatcher is null)
        return;
    dispatcher.requestFocus(this);
}

/**
 * @see IFigure#revalidate()
 */
public void revalidate() {
    invalidate();
    if (getParent() is null || isValidationRoot())
        getUpdateManager().addInvalidFigure(this);
    else
        getParent().revalidate();
}

/**
 * @see IFigure#setBackgroundColor(Color)
 */
public void setBackgroundColor(Color bg) {
    bgColor = bg;
    repaint();
}

/**
 * @see IFigure#setBorder(Border)
 */
public void setBorder(Border border) {
    this.border = border;
    revalidate();
    repaint();
}

/**
 * Sets the bounds of this Figure to the Rectangle <i>rect</i>. Note that <i>rect</i> is
 * compared to the Figure's current bounds to determine what needs to be repainted and/or
 * exposed and if validation is required. Since {@link #getBounds()} may return the
 * current bounds by reference, it is not safe to modify that Rectangle and then call
 * setBounds() after making modifications. The figure would assume that the bounds are
 * unchanged, and no layout or paint would occur. For proper behavior, always use a copy.
 * @param rect The new bounds
 * @since 2.0
 */
public void setBounds(Rectangle rect) {
    int x = bounds.x,
        y = bounds.y;

    bool resize = (rect.width !is bounds.width) || (rect.height !is bounds.height),
          translate = (rect.x !is x) || (rect.y !is y);

    if ((resize || translate) && isVisible())
        erase();
    if (translate) {
        int dx = rect.x - x;
        int dy = rect.y - y;
        primTranslate(dx, dy);
    }

    bounds.width = rect.width;
    bounds.height = rect.height;

    if (translate || resize) {
        if (resize)
            invalidate();
        fireFigureMoved();
        repaint();
    }
}

/**
 * Sets the direction of any {@link Orientable} children.  Allowable values for
 * <code>dir</code> are found in {@link PositionConstants}.
 * @param direction The direction
 * @see Orientable#setDirection(int)
 * @since 2.0
 */
protected void setChildrenDirection(int direction) {
    FigureIterator iterator = new FigureIterator(this);
    IFigure child;
    while (iterator.hasNext()) {
        child = iterator.nextFigure();
        if ( auto c = cast(Orientable)child )
            c.setDirection(direction);
    }
}

/**
 * Sets all childrens' enabled property to <i>value</i>.
 * @param value The enable value
 * @see #setEnabled(bool)
 * @since 2.0
 */
protected void setChildrenEnabled(bool value) {
    FigureIterator iterator = new FigureIterator(this);
    while (iterator.hasNext())
        iterator.nextFigure().setEnabled(value);
}

/**
 * Sets the orientation of any {@link Orientable} children. Allowable values for
 * <i>orientation</i> are found in {@link PositionConstants}.
 * @param orientation The Orientation
 * @see Orientable#setOrientation(int)
 * @since 2.0
 */
protected void setChildrenOrientation(int orientation) {
    FigureIterator iterator = new FigureIterator(this);
    IFigure child;
    while (iterator.hasNext()) {
        child = iterator.nextFigure();
        if (auto c = cast(Orientable)child )
            c.setOrientation(orientation);
    }
}

/**
 * @see IFigure#setConstraint(IFigure, Object)
 */
public void setConstraint(IFigure child, Object constraint) {
    if (child.getParent() !is this)
        throw new IllegalArgumentException(
            "Figure must be a child"); //$NON-NLS-1$

    if (layoutManager !is null)
        layoutManager.setConstraint(child, constraint);
    revalidate();
}

/**
 * @see IFigure#setCursor(Cursor)
 */
public void setCursor(Cursor cursor) {
    if (this.cursor is cursor)
        return;
    this.cursor = cursor;
    EventDispatcher dispatcher = internalGetEventDispatcher();
    if (dispatcher !is null)
        dispatcher.updateCursor_package();
}

/**
 * @see IFigure#setEnabled(bool)
 */
public void setEnabled(bool value) {
    if (isEnabled() is value)
        return;
    setFlag(FLAG_ENABLED, value);
}

/**
 * Sets the given flag to the given value.
 * @param flag The flag to set
 * @param value The value
 * @since 2.0
 */
protected final void setFlag(int flag, bool value) {
    if (value)
        flags |= flag;
    else
        flags &= ~flag;
}

/**
 * @see IFigure#setFocusTraversable(bool)
 */
public void setFocusTraversable(bool focusTraversable) {
    if (isFocusTraversable() is focusTraversable)
        return;
    setFlag(FLAG_FOCUS_TRAVERSABLE, focusTraversable);
}

/**
 * @see IFigure#setFont(Font)
 */
public void setFont(Font f) {
    if (font !is f) {
        font = f;
        revalidate();
        repaint();
    }
}

/**
 * @see IFigure#setForegroundColor(Color)
 */
public void setForegroundColor(Color fg) {
    if (fgColor !is null && fgColor.opEquals(fg))
        return;
    fgColor = fg;
    repaint();
}

/**
 * @see IFigure#setLayoutManager(LayoutManager)
 */
public void setLayoutManager(LayoutManager manager) {
    if (auto n = cast(LayoutNotifier)layoutManager )
        n.realLayout = manager;
    else
        layoutManager = manager;
    revalidate();
}

/**
 * @see IFigure#setLocation(Point)
 */
public void setLocation(Point p) {
    if (getLocation().opEquals(p))
        return;
    Rectangle r = new Rectangle(getBounds());
    r.setLocation(p);
    setBounds(r);
}

/**
 * @see IFigure#setMaximumSize(Dimension)
 */
public void setMaximumSize(Dimension d) {
    if (maxSize !is null && maxSize.opEquals(d))
        return;
    maxSize = d;
    revalidate();
}

/**
 * @see IFigure#setMinimumSize(Dimension)
 */
public void setMinimumSize(Dimension d) {
    if (minSize !is null && minSize.opEquals(d))
        return;
    minSize = d;
    revalidate();
}

/**
 * @see IFigure#setOpaque(bool)
 */
public void setOpaque(bool opaque) {
    if (isOpaque() is opaque)
        return;
    setFlag(FLAG_OPAQUE, opaque);
    repaint();
}

/**
 * @see IFigure#setParent(IFigure)
 */
public void setParent(IFigure p) {
    IFigure oldParent = parent;
    parent = p;
    firePropertyChange("parent", cast(Object)oldParent, cast(Object)p);//$NON-NLS-1$
}

/**
 * @see IFigure#setPreferredSize(Dimension)
 */
public void setPreferredSize(Dimension size) {
    if (prefSize !is null && prefSize.opEquals(size))
        return;
    prefSize = size;
    revalidate();
}

/**
 * Sets the preferred size of this figure.
 * @param w The new preferred width
 * @param h The new preferred height
 * @see #setPreferredSize(Dimension)
 * @since 2.0
 */
public final void setPreferredSize(int w, int h) {
    setPreferredSize(new Dimension(w, h));
}

/**
 * @see IFigure#setRequestFocusEnabled(bool)
 */
public void setRequestFocusEnabled(bool requestFocusEnabled) {
    if (isRequestFocusEnabled() is requestFocusEnabled)
        return;
    setFlag(FLAG_FOCUSABLE, requestFocusEnabled);
}

/**
 * @see IFigure#setSize(Dimension)
 */
public final void setSize(Dimension d) {
    setSize(d.width, d.height);
}

/**
 * @see IFigure#setSize(int, int)
 */
public void setSize(int w, int h) {
    Rectangle bounds = getBounds();
    if (bounds.width is w && bounds.height is h)
        return;
    Rectangle r = new Rectangle(getBounds());
    r.setSize(w, h);
    setBounds(r);
}

/**
 * @see IFigure#setToolTip(IFigure)
 */
public void setToolTip(IFigure f) {
    if (toolTip is f)
        return;
    toolTip = f;
}

/**
 * Sets this figure to be valid if <i>value</i> is <code>true</code> and invalid
 * otherwise.
 * @param value The valid value
 * @since 2.0
 */
public void setValid(bool value) {
    setFlag(FLAG_VALID, value);
}

/**
 * @see IFigure#setVisible(bool)
 */
public void setVisible(bool visible) {
    bool currentVisibility = isVisible();
    if (visible is currentVisibility)
        return;
    if (currentVisibility)
        erase();
    setFlag(FLAG_VISIBLE, visible);
    if (visible)
        repaint();
    revalidate();
}

/**
 * @see IFigure#translate(int, int)
 */
public final void translate(int x, int y) {
    primTranslate(x, y);
    fireFigureMoved();
}

/**
 * @see IFigure#translateFromParent(Translatable)
 */
public void translateFromParent(Translatable t) {
    if (useLocalCoordinates())
        t.performTranslate(
            -getBounds().x - getInsets().left,
            -getBounds().y - getInsets().top);
}

/**
 * @see IFigure#translateToAbsolute(Translatable)
 */
public final void translateToAbsolute(Translatable t) {
    if (getParent() !is null) {
        getParent().translateToParent(t);
        getParent().translateToAbsolute(t);
    }
}

/**
 * @see IFigure#translateToParent(Translatable)
 */
public void translateToParent(Translatable t) {
    if (useLocalCoordinates())
        t.performTranslate(
            getBounds().x + getInsets().left,
            getBounds().y + getInsets().top);
}

/**
 * @see IFigure#translateToRelative(Translatable)
 */
public final void translateToRelative(Translatable t) {
    if (getParent() !is null) {
        getParent().translateToRelative(t);
        getParent().translateFromParent(t);
    }
}

/**
 * Returns <code>true</code> if this Figure uses local coordinates. This means its
 * children are placed relative to this Figure's top-left corner.
 * @return <code>true</code> if this Figure uses local coordinates
 * @since 2.0
 */
protected bool useLocalCoordinates() {
    return false;
}

/**
 * @see IFigure#validate()
 */
public void validate() {
    if (isValid())
        return;
    setValid(true);
    layout();
    for (int i = 0; i < children.size(); i++)
        (cast(IFigure)children.get(i)).validate();
}

/**
 * A search which does not filter any figures.
 * since 3.0
 */
protected static final class IdentitySearch : TreeSearch {
    /**
     * The singleton instance.
     */
    private static IdentitySearch INSTANCE_;
    public static IdentitySearch INSTANCE(){
        if( INSTANCE_ is null ){
            synchronized( IdentitySearch.classinfo ){
                if( INSTANCE_ is null ){
                    INSTANCE_ = new IdentitySearch();
                }
            }
        }
        return INSTANCE_;
    }

    private this() { }
    /**
     * Always returns <code>true</code>.
     * @see TreeSearch#accept(IFigure)
     */
    public bool accept(IFigure f) {
        return true;
    }
    /**
     * Always returns <code>false</code>.
     * @see TreeSearch#prune(IFigure)
     */
    public bool prune(IFigure f) {
        return false;
    }
}

final class LayoutNotifier : LayoutManager {

    LayoutManager realLayout;
    List listeners;

    this(LayoutManager layout, LayoutListener listener) {
        listeners = new ArrayList(1);
        realLayout = layout;
        listeners.add(cast(Object)listener);
    }

    public Object getConstraint(IFigure child) {
        if (realLayout !is null)
            return realLayout.getConstraint(child);
        return null;
    }

    public Dimension getMinimumSize(IFigure container, int wHint, int hHint) {
        if (realLayout !is null)
            return realLayout.getMinimumSize(container, wHint, hHint);
        return null;
    }

    public Dimension getPreferredSize(IFigure container, int wHint, int hHint) {
        if (realLayout !is null)
            return realLayout.getPreferredSize(container, wHint, hHint);
        return null;
    }

    public void invalidate() {
        for (int i = 0; i < listeners.size(); i++)
            (cast(LayoutListener)listeners.get(i)).invalidate(this.outer);

        if (realLayout !is null)
            realLayout.invalidate();
    }

    public void layout(IFigure container) {
        bool consumed = false;
        for (int i = 0; i < listeners.size(); i++)
            consumed |= (cast(LayoutListener)listeners.get(i)).layout(container);

        if (realLayout !is null && !consumed)
            realLayout.layout(container);
        for (int i = 0; i < listeners.size(); i++)
            (cast(LayoutListener)listeners.get(i)).postLayout(container);
    }

    public void remove(IFigure child) {
        for (int i = 0; i < listeners.size(); i++)
            (cast(LayoutListener)listeners.get(i)).remove(child);
        if (realLayout !is null)
            realLayout.remove(child);
    }

    public void setConstraint(IFigure child, Object constraint) {
        for (int i = 0; i < listeners.size(); i++)
            (cast(LayoutListener)listeners.get(i)).setConstraint(child, constraint);
        if (realLayout !is null)
            realLayout.setConstraint(child, constraint);
    }
}

/**
 * Iterates over a Figure's children.
 */
public static class FigureIterator {
    private List list;
    private int index;
    /**
     * Constructs a new FigureIterator for the given Figure.
     * @param figure The Figure whose children to iterate over
     */
    public this(IFigure figure) {
        list = figure.getChildren();
        index = list.size();
    }
    /**
     * Returns the next Figure.
     * @return The next Figure
     */
    public IFigure nextFigure() {
        return cast(IFigure)list.get(--index);
    }
    /**
     * Returns <code>true</code> if there's another Figure to iterate over.
     * @return <code>true</code> if there's another Figure to iterate over
     */
    public bool hasNext() {
        return index > 0;
    }
}

/**
 * An UpdateManager that does nothing.
 */
private static UpdateManager NO_MANAGER_;
protected static UpdateManager NO_MANAGER(){
    if( NO_MANAGER_ is null ){
        synchronized( Figure.classinfo ){
            if( NO_MANAGER_ is null ){
                NO_MANAGER_ = new class() UpdateManager {
                    public void addDirtyRegion (IFigure figure, int x, int y, int w, int h) { }
                    public void addInvalidFigure(IFigure f) { }
                    public void performUpdate() { }
                    public void performUpdate(Rectangle region) { }
                    public void setRoot(IFigure root) { }
                    public void setGraphicsSource(GraphicsSource gs) { }
                };
            }
        }
    }
    return NO_MANAGER_;
}

}
