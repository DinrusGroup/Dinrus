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
module dwtx.draw2d.ScrollBar;

import dwt.dwthelper.utils;

import dwtx.dwtxhelper.Bean;

import dwt.graphics.Color;
import dwtx.draw2d.geometry.Dimension;
import dwtx.draw2d.geometry.Point;
import dwtx.draw2d.geometry.Rectangle;
import dwtx.draw2d.geometry.Transposer;

import dwtx.draw2d.Orientable;
import dwtx.draw2d.Figure;
import dwtx.draw2d.IFigure;
import dwtx.draw2d.RangeModel;
import dwtx.draw2d.Clickable;
import dwtx.draw2d.MouseMotionListener;
import dwtx.draw2d.MouseListener;
import dwtx.draw2d.MouseEvent;
import dwtx.draw2d.FigureUtilities;
import dwtx.draw2d.ColorConstants;
import dwtx.draw2d.Button;
import dwtx.draw2d.RangeModel;
import dwtx.draw2d.DefaultRangeModel;
import dwtx.draw2d.ArrowButton;
import dwtx.draw2d.ButtonBorder;
import dwtx.draw2d.ChangeListener;
import dwtx.draw2d.ChangeEvent;
import dwtx.draw2d.Panel;
import dwtx.draw2d.ScrollBarLayout;
import dwtx.draw2d.SchemeBorder;
import dwtx.draw2d.ActionListener;
import dwtx.draw2d.ActionEvent;

/**
 * Provides for the scrollbars used by the {@link ScrollPane}. A ScrollBar is made up of
 * five essential Figures: An 'Up' arrow button, a 'Down' arrow button, a draggable
 * 'Thumb', a 'Pageup' button, and a 'Pagedown' button.
 */
public class ScrollBar
    : Figure
    , Orientable, PropertyChangeListener
{

private static const int ORIENTATION_FLAG = Figure.MAX_FLAG << 1;
/** @see Figure#MAX_FLAG */
protected static const int MAX_FLAG = ORIENTATION_FLAG;

private static Color COLOR_TRACK_;
private static Color COLOR_TRACK(){
    if( COLOR_TRACK_ is null ){
        synchronized( ScrollBar.classinfo ){
            if( COLOR_TRACK_ is null ){
                COLOR_TRACK_ = FigureUtilities.mixColors(
                    ColorConstants.white,
                    ColorConstants.button);
            }
        }
    }
    return COLOR_TRACK_;
}

private RangeModel rangeModel = null;
private IFigure thumb;
private Clickable pageUp_, pageDown_;
private Clickable buttonUp, buttonDown;
/**
 * Listens to mouse events on the scrollbar to take care of scrolling.
 */
protected ThumbDragger thumbDragger;

private bool isHorizontal_ = false;

private int pageIncrement = 50;
private int stepIncrement = 10;

/**
 * Transposes from vertical to horizontal if needed.
 */
protected /+final+/ Transposer transposer;

private void instanceInit(){
    thumbDragger = new ThumbDragger();
    transposer = new Transposer();
    setRangeModel(new DefaultRangeModel());
}

/**
 * Constructs a ScrollBar. ScrollBar orientation is vertical by default. Call
 * {@link #setHorizontal(bool)} with <code>true</code> to set horizontal orientation.
 *
 * @since 2.0
 */
public this() {
    instanceInit();
    initialize();
}

/**
 * Creates the default 'Up' ArrowButton for the ScrollBar.
 *
 * @return the up button
 * @since 2.0
 */
protected Clickable createDefaultUpButton() {
    Button buttonUp = new ArrowButton();
    buttonUp.setBorder(new ButtonBorder(ButtonBorder.SCHEMES.BUTTON_SCROLLBAR));
    return buttonUp;
}

/**
 * Creates the default 'Down' ArrowButton for the ScrollBar.
 *
 * @return the down button
 * @since 2.0
 */
protected Clickable createDefaultDownButton() {
    Button buttonDown = new ArrowButton();
    buttonDown.setBorder(new ButtonBorder(ButtonBorder.SCHEMES.BUTTON_SCROLLBAR));
    return buttonDown;
}

/**
 * Creates the pagedown Figure for the Scrollbar.
 *
 * @return the page down figure
 * @since 2.0
 */
protected Clickable createPageDown() {
    return createPageUp();
}

/**
 * Creates the pageup Figure for the Scrollbar.
 *
 * @return the page up figure
 * @since 2.0
 */
protected Clickable createPageUp() {
    Clickable clickable = new Clickable();
    clickable.setOpaque(true);
    clickable.setBackgroundColor(COLOR_TRACK);
    clickable.setRequestFocusEnabled(false);
    clickable.setFocusTraversable(false);
    clickable.addChangeListener( dgChangeListener( (ChangeEvent evt, Clickable clickable_){
        if (clickable_.getModel().isArmed())
            clickable_.setBackgroundColor(ColorConstants.black);
        else
            clickable_.setBackgroundColor(COLOR_TRACK);
    }, clickable));
    return clickable;
}

/**
 * Creates the Scrollbar's "thumb", the draggable Figure that indicates the Scrollbar's
 * position.
 *
 * @return the thumb figure
 * @since 2.0
 */
protected IFigure createDefaultThumb() {
    Panel thumb = new Panel();
    thumb.setMinimumSize(new Dimension(6, 6));
    thumb.setBackgroundColor(ColorConstants.button);

    thumb.setBorder(new SchemeBorder(SchemeBorder.SCHEMES.BUTTON_CONTRAST));
    return thumb;
}

/**
 * Returns the figure used as the up button.
 * @return the up button
 */
protected IFigure getButtonUp() {
    // TODO: The set method takes a Clickable while the get method returns an IFigure.
    // Change the get method to return Clickable (since that's what it's typed as).
    return buttonUp;
}

/**
 * Returns the figure used as the down button.
 * @return the down button
 */
protected IFigure getButtonDown() {
    // TODO: The set method takes a Clickable while the get method returns an IFigure.
    // Change the get method to return Clickable (since that's what it's typed as).
    return buttonDown;
}

/**
 * Returns the extent.
 * @return the extent
 * @see RangeModel#getExtent()
 */
public int getExtent() {
    return getRangeModel().getExtent();
}

/**
 * Returns the minumum value.
 * @return the minimum
 * @see RangeModel#getMinimum()
 */
public int getMinimum() {
    return getRangeModel().getMinimum();
}

/**
 * Returns the maximum value.
 * @return the maximum
 * @see RangeModel#getMaximum()
 */
public int getMaximum() {
    return getRangeModel().getMaximum();
}

/**
 * Returns the figure used for page down.
 * @return the page down figure
 */
protected IFigure getPageDown() {
    // TODO: The set method takes a Clickable while the get method returns an IFigure.
    // Change the get method to return Clickable (since that's what it's typed as).
    return pageDown_;
}

/**
 * Returns the the amound the scrollbar will move when the page up or page down areas are
 * pressed.
 * @return the page increment
 */
public int getPageIncrement() {
    return pageIncrement;
}

/**
 * Returns the figure used for page up.
 * @return the page up figure
 */
protected IFigure getPageUp() {
    // TODO: The set method takes a Clickable while the get method returns an IFigure.
    // Change the get method to return Clickable (since that's what it's typed as).
    return pageUp_;
}

/**
 * Returns the range model for this scrollbar.
 * @return the range model
 */
public RangeModel getRangeModel() {
    return rangeModel;
}

/**
 * Returns the amount the scrollbar will move when the up or down arrow buttons are
 * pressed.
 * @return the step increment
 */
public int getStepIncrement() {
    return stepIncrement;
}

/**
 * Returns the figure used as the scrollbar's thumb.
 * @return the thumb figure
 */
protected IFigure getThumb() {
    return thumb;
}

/**
 * Returns the current scroll position of the scrollbar.
 * @return the current value
 * @see RangeModel#getValue()
 */
public int getValue() {
    return getRangeModel().getValue();
}

/**
 * Returns the size of the range of allowable values.
 * @return the value range
 */
protected int getValueRange() {
    return getMaximum() - getExtent() - getMinimum();
}

/**
 * Initilization of the ScrollBar. Sets the Scrollbar to have a ScrollBarLayout with
 * vertical orientation. Creates the Figures that make up the components of the ScrollBar.
 *
 * @since 2.0
 */
protected void initialize() {
    setLayoutManager(new ScrollBarLayout(transposer));
    setUpClickable(createDefaultUpButton());
    setDownClickable(createDefaultDownButton());
    setPageUp(createPageUp());
    setPageDown(createPageDown());
    setThumb(createDefaultThumb());
}

/**
 * Returns <code>true</code> if this scrollbar is orientated horizontally,
 * <code>false</code> otherwise.
 * @return whether this scrollbar is horizontal
 */
public bool isHorizontal() {
    return isHorizontal_;
}

private void pageDown() {
    setValue(getValue() + getPageIncrement());
}

private void pageUp() {
    setValue(getValue() - getPageIncrement());
}

/**
 * @see PropertyChangeListener#propertyChange(java.beans.PropertyChangeEvent)
 */
public void propertyChange(PropertyChangeEvent event) {
    if (null !is cast(RangeModel)event.getSource() ) {
        setEnabled(getRangeModel().isEnabled());
        if (RangeModel.PROPERTY_VALUE.equals(event.getPropertyName())) {
            firePropertyChange("value", event.getOldValue(), //$NON-NLS-1$
                                        event.getNewValue());
            revalidate();
        }
        if (RangeModel.PROPERTY_MINIMUM.equals(event.getPropertyName())) {
            firePropertyChange("value", event.getOldValue(), //$NON-NLS-1$
                                        event.getNewValue());
            revalidate();
        }
        if (RangeModel.PROPERTY_MAXIMUM.equals(event.getPropertyName())) {
            firePropertyChange("value", event.getOldValue(), //$NON-NLS-1$
                                        event.getNewValue());
            revalidate();
        }
        if (RangeModel.PROPERTY_EXTENT.equals(event.getPropertyName())) {
            firePropertyChange("value", event.getOldValue(), //$NON-NLS-1$
                                        event.getNewValue());
            revalidate();
        }
    }
}

/**
 * @see IFigure#revalidate()
 */
public void revalidate() {
    // Override default revalidate to prevent going up the parent chain. Reason for this
    // is that preferred size never changes unless orientation changes.
    invalidate();
    getUpdateManager().addInvalidFigure(this);
}

/**
 * Does nothing because this doesn't make sense for a scrollbar.
 * @see Orientable#setDirection(int)
 */
public void setDirection(int direction) {
    //Doesn't make sense for Scrollbar.
}

/**
 * Sets the Clickable that represents the down arrow of the Scrollbar to <i>down</i>.
 *
 * @param down the down button
 * @since 2.0
 */
public void setDownClickable(Clickable down) {
    if (buttonDown !is null) {
        remove(buttonDown);
    }
    buttonDown = down;
    if (buttonDown !is null) {
        if (auto b = cast(Orientable)buttonDown )
            b.setDirection(isHorizontal()
                                                    ? Orientable.EAST
                                                    : Orientable.SOUTH);
        buttonDown.setFiringMethod(Clickable.REPEAT_FIRING);
        buttonDown.addActionListener(dgActionListener( (ActionEvent evt){
            stepDown();
        }));
        add(buttonDown, stringcast(ScrollBarLayout.DOWN_ARROW));
    }
}

/**
 * Sets the Clickable that represents the up arrow of the Scrollbar to <i>up</i>.
 *
 * @param up the up button
 * @since 2.0
 */
public void setUpClickable(Clickable up) {
    if (buttonUp !is null) {
        remove(buttonUp);
    }
    buttonUp = up;
    if (up !is null) {
        if (auto o = cast(Orientable)up )
            o.setDirection(isHorizontal()
                                            ? Orientable.WEST
                                            : Orientable.NORTH);
        buttonUp.setFiringMethod(Clickable.REPEAT_FIRING);
        buttonUp.addActionListener(dgActionListener( (ActionEvent evt){
            stepUp();
        }));
        add(buttonUp, stringcast(ScrollBarLayout.UP_ARROW));
    }
}

/**
 * @see IFigure#setEnabled(bool)
 */
public void setEnabled(bool value) {
    if (isEnabled() is value)
        return;
    super.setEnabled(value);
    setChildrenEnabled(value);
    if (getThumb() !is null) {
        getThumb().setVisible(value);
        revalidate();
    }
}

/**
 * Sets the extent of the Scrollbar to <i>ext</i>
 *
 * @param ext the extent
 * @since 2.0
 */
public void setExtent(int ext) {
    if (getExtent() is ext)
        return;
    getRangeModel().setExtent(ext);
}

/**
 * Sets the orientation of the ScrollBar. If <code>true</code>, the Scrollbar will have
 * a horizontal orientation. If <code>false</code>, the scrollBar will have a vertical
 * orientation.
 *
 * @param value <code>true</code> if the scrollbar should be horizontal
 * @since 2.0
 */
public final void setHorizontal(bool value) {
    setOrientation(value ? HORIZONTAL : VERTICAL);
}

/**
 * Sets the maximum position to <i>max</i>.
 *
 * @param max the maximum position
 * @since 2.0
 */
public void setMaximum(int max) {
    if (getMaximum() is max)
        return;
    getRangeModel().setMaximum(max);
}

/**
 * Sets the minimum position to <i>min</i>.
 *
 * @param min the minumum position
 * @since 2.0
 */
public void setMinimum(int min) {
    if (getMinimum() is min)
        return;
    getRangeModel().setMinimum(min);
}

/**
 * @see Orientable#setOrientation(int)
 */
public void setOrientation(int value) {
    if ((value is HORIZONTAL) is isHorizontal())
        return;
    isHorizontal_ = value is HORIZONTAL;
    transposer.setEnabled(isHorizontal_);

    setChildrenOrientation(value);
    super.revalidate();
}

/**
 * Sets the ScrollBar to scroll <i>increment</i> pixels when its pageup or pagedown
 * buttons are pressed. (Note that the pageup and pagedown buttons are <b>NOT</b> the
 * arrow buttons, they are the figures between the arrow buttons and the ScrollBar's
 * thumb figure).
 *
 * @param increment the new page increment
 * @since 2.0
 */
public void setPageIncrement(int increment) {
    pageIncrement = increment;
}

/**
 * Sets the pagedown button to the passed Clickable. The pagedown button is the figure
 * between the down arrow button and the ScrollBar's thumb figure.
 *
 * @param down the page down figure
 * @since 2.0
 */
public void setPageDown(Clickable down) {
    if (pageDown_ !is null)
        remove(pageDown_);
    pageDown_ = down;
    if (pageDown_ !is null) {
        pageDown_.setFiringMethod(Clickable.REPEAT_FIRING);
        pageDown_.addActionListener(dgActionListener( (ActionEvent evt){
            pageDown();
        }));
        add(down,stringcast( ScrollBarLayout.PAGE_DOWN));
    }
}

/**
 * Sets the pageup button to the passed Clickable. The pageup button is the rectangular
 * figure between the down arrow button and the ScrollBar's thumb figure.
 *
 * @param up the page up figure
 * @since 2.0
 */
public void setPageUp(Clickable up) {
    if (pageUp_ !is null)
        remove(pageUp_);
    pageUp_ = up;
    if (pageUp_ !is null) {
        pageUp_.setFiringMethod(Clickable.REPEAT_FIRING);
        pageUp_.addActionListener(dgActionListener((ActionEvent evt){
            pageUp();
        }));
        add(pageUp_, stringcast(ScrollBarLayout.PAGE_UP));
    }
}

/**
 * Sets the ScrollBar's RangeModel to the passed value.
 *
 * @param rangeModel the new range model
 * @since 2.0
 */
public void setRangeModel(RangeModel rangeModel) {
    if (this.rangeModel !is null)
        this.rangeModel.removePropertyChangeListener(this);
    this.rangeModel = rangeModel;
    rangeModel.addPropertyChangeListener(this);
}

/**
 * Sets the ScrollBar's step increment to the passed value. The step increment indicates
 * how many pixels the ScrollBar will scroll when its up or down arrow button is pressed.
 *
 * @param increment the new step increment
 * @since 2.0
 */
public void setStepIncrement(int increment) {
    stepIncrement = increment;
}

/**
 * Sets the ScrollBar's thumb to the passed Figure. The thumb is the draggable component
 * of the ScrollBar that indicates the ScrollBar's position.
 *
 * @param figure the thumb figure
 * @since 2.0
 */
public void setThumb(IFigure figure) {
    if (thumb !is null) {
        thumb.removeMouseListener(thumbDragger);
        thumb.removeMouseMotionListener(thumbDragger);
        remove(thumb);
    }
    thumb = figure;
    if (thumb !is null) {
        thumb.addMouseListener(thumbDragger);
        thumb.addMouseMotionListener(thumbDragger);
        add(thumb, stringcast(ScrollBarLayout.THUMB));
    }
}

/**
 * Sets the value of the Scrollbar to <i>v</i>
 *
 * @param v the new value
 * @since 2.0
 */
public void setValue(int v) {
    getRangeModel().setValue(v);
}

/**
 * Causes the ScrollBar to scroll down (or right) by the value of its step increment.
 *
 * @since 2.0
 */
protected void stepDown() {
    setValue(getValue() + getStepIncrement());
}

/**
 * Causes the ScrollBar to scroll up (or left) by the value of its step increment.
 *
 * @since 2.0
 */
protected void stepUp() {
    setValue(getValue() - getStepIncrement());
}

class ThumbDragger
    : MouseMotionListener.Stub
    , MouseListener
{
    protected Point start;
    protected int dragRange;
    protected int revertValue;
    protected bool armed;
    public this() { }

    public void mousePressed(MouseEvent me) {
        armed = true;
        start = me.getLocation();
        Rectangle area = new Rectangle(transposer.t(getClientArea()));
        Dimension thumbSize = transposer.t(getThumb().getSize());
        if (getButtonUp() !is null)
            area.height -= transposer.t(getButtonUp().getSize()).height;
        if (getButtonDown() !is null)
            area.height -= transposer.t(getButtonDown().getSize()).height;
        Dimension sizeDifference = new Dimension(area.width,
                                                    area.height - thumbSize.height);
        dragRange = sizeDifference.height;
        revertValue = getValue();
        me.consume();
    }

    public void mouseDragged(MouseEvent me) {
        if (!armed)
            return;
        Dimension difference = transposer.t(me.getLocation().getDifference(start));
        int change = getValueRange() * difference.height / dragRange;
        setValue(revertValue + change);
        me.consume();
    }

    public void mouseReleased(MouseEvent me) {
        if (!armed)
            return;
        armed = false;
        me.consume();
    }

    public void mouseDoubleClicked(MouseEvent me) { }
}

}
