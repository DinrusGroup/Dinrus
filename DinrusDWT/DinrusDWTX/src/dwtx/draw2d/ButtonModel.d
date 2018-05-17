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
module dwtx.draw2d.ButtonModel;

import dwt.dwthelper.utils;
import dwt.dwthelper.Runnable;
import dwtx.dwtxhelper.Collection;
import dwtx.dwtxhelper.Timer;
import dwtx.dwtxhelper.TimerTask;
static import dwt.widgets.Display;

import dwtx.draw2d.ButtonGroup;
import dwtx.draw2d.ActionListener;
import dwtx.draw2d.ChangeListener;
import dwtx.draw2d.ButtonStateTransitionListener;
import dwtx.draw2d.EventListenerList;
import dwtx.draw2d.ActionEvent;
import dwtx.draw2d.ChangeEvent;


//import dwtx.draw2d.internal.Timer;

/**
 * A model for buttons containing several properties, including enabled, pressed,
 * selected, rollover enabled and mouseover.
 */
public class ButtonModel {

/** Enabled property */
public static const String ENABLED_PROPERTY = "enabled"; //$NON-NLS-1$
/** Pressed property */
public static const String PRESSED_PROPERTY = "pressed"; //$NON-NLS-1$
/** Selected property */
public static const String SELECTED_PROPERTY = "selected"; //$NON-NLS-1$
/** Rollover Enabled property */
public static const String ROLLOVER_ENABLED_PROPERTY = "rollover enabled"; //$NON-NLS-1$
/** Mouseover property */
public static const String MOUSEOVER_PROPERTY = "mouseover"; //$NON-NLS-1$

/** Armed property */
public static const String ARMED_PROPERTY = "armed";  //$NON-NLS-1$


/** Flag for armed button state */
protected static const int ARMED_FLAG               = 1;
/** Flag for pressed button state */
protected static const int PRESSED_FLAG             = 2;
/** Flag for mouseOver state */
protected static const int MOUSEOVER_FLAG           = 4;
/** Flag for selected button state */
protected static const int SELECTED_FLAG            = 8;
/** Flag for enablement button state */
protected static const int ENABLED_FLAG             = 16;
/** Flag for rollover enablement button state */
protected static const int ROLLOVER_ENABLED_FLAG    = 32;
/** Flag that can be used by subclasses to define more states */
protected static const int MAX_FLAG                 = ROLLOVER_ENABLED_FLAG;

private int state = ENABLED_FLAG;
private Object data;

/**
 * Action performed events are not fired until the mouse button is released.
 */
public static const int DEFAULT_FIRING_BEHAVIOR = 0;

/**
 * Action performed events fire repeatedly until the mouse button is released.
 */
public static const int REPEAT_FIRING_BEHAVIOR  = 1;

/**
 * The name of the action associated with this button.
 */
protected String actionName;

/**
 * The ButtonGroup this button belongs to (if any).
 */
protected ButtonGroup group = null;

private EventListenerList listeners;

/**
 * Listens to button state transitions and fires action performed events based on the
 * desired behavior ({@link #DEFAULT_FIRING_BEHAVIOR} or {@link #REPEAT_FIRING_BEHAVIOR}).
 */
protected ButtonStateTransitionListener firingBehavior;

this(){
    listeners = new EventListenerList();
    installFiringBehavior();
}

/**
 * Registers the given listener as an ActionListener.
 *
 * @param listener The ActionListener to add
 * @since 2.0
 */
public void addActionListener(ActionListener listener) {
    if (listener is null)
        throw new IllegalArgumentException("");
    listeners.addListener(ActionListener.classinfo, cast(Object)listener);
}

/**
 * Registers the given listener as a ChangeListener.
 *
 * @param listener The ChangeListener to add
 * @since 2.0
 */
public void addChangeListener(ChangeListener listener) {
    if (listener is null)
        throw new IllegalArgumentException("");
    listeners.addListener(ChangeListener.classinfo, cast(Object)listener);
}

/**
 * Registers the given listener as a ButtonStateTransitionListener.
 *
 * @param listener The ButtonStateTransitionListener to add
 * @since 2.0
 */
public void addStateTransitionListener(ButtonStateTransitionListener listener) {
    if (listener is null)
        throw new IllegalArgumentException("");
    listeners.addListener(ButtonStateTransitionListener.classinfo, cast(Object)listener);
}

/**
 * Notifies any ActionListeners on this ButtonModel that an action has been performed.
 *
 * @since 2.0
 */
protected void fireActionPerformed() {
    Iterator iter = listeners.getListeners(ActionListener.classinfo);
    ActionEvent action = new ActionEvent(this);
    while (iter.hasNext())
        (cast(ActionListener)iter.next()).
            actionPerformed(action);
}

/**
 * Notifies any listening ButtonStateTransitionListener that the pressed state of this
 * button has been cancelled.
 *
 * @since 2.0
 */
protected void fireCanceled() {
    Iterator iter = listeners.getListeners(ButtonStateTransitionListener.classinfo);
    while (iter.hasNext())
        (cast(ButtonStateTransitionListener)iter.next()).
            canceled();
}

/**
 * Notifies any listening ButtonStateTransitionListener that this button has been pressed.
 *
 * @since 2.0
 */
protected void firePressed() {
    Iterator iter = listeners.getListeners(ButtonStateTransitionListener.classinfo);
    while (iter.hasNext())
        (cast(ButtonStateTransitionListener)iter.next()).
            pressed();
}

/**
 * Notifies any listening ButtonStateTransitionListener that this button has been
 * released.
 *
 * @since 2.0
 */
protected void fireReleased() {
    Iterator iter = listeners.getListeners(ButtonStateTransitionListener.classinfo);
    while (iter.hasNext())
        (cast(ButtonStateTransitionListener)iter.next()).
            released();
}

/**
 * Notifies any listening ButtonStateTransitionListeners that this button has resumed
 * activity.
 *
 * @since 2.0
 */
protected void fireResume() {
    Iterator iter = listeners.getListeners(ButtonStateTransitionListener.classinfo);
    while (iter.hasNext())
        (cast(ButtonStateTransitionListener)iter.next()).
            resume();
}

/**
 * Notifies any listening ChangeListeners that this button's state has changed.
 *
 * @param property The name of the property that changed
 * @since 2.0
 */
protected void fireStateChanged(String property) {
    Iterator iter = listeners.getListeners(ChangeListener.classinfo);
    ChangeEvent change = new ChangeEvent(this, property);
    while (iter.hasNext())
        (cast(ChangeListener)iter.next()).
            handleStateChanged(change);
}

/**
 * Notifies any listening ButtonStateTransitionListeners that this button has suspended
 * activity.
 *
 * @since 2.0
 */
protected void fireSuspend() {
    Iterator iter = listeners.getListeners(ButtonStateTransitionListener.classinfo);
    while (iter.hasNext())
        (cast(ButtonStateTransitionListener)iter.next()).
            suspend();
}

bool getFlag(int which) {
    return (state & which) !is 0;
}

/**
 * Returns the group to which this model belongs.
 *
 * @return The ButtonGroup to which this model belongs
 * @since 2.0
 */
public ButtonGroup getGroup() {
    return group;
}

/**
 * Returns an object representing user data.
 *
 * @return User data
 * @since 2.0
 */
public Object getUserData() {
    return data;
}

/**
 * Sets the firing behavior for this button.
 *
 * @since 2.0
 */
protected void installFiringBehavior() {
    setFiringBehavior(DEFAULT_FIRING_BEHAVIOR);
}

/**
 * Returns <code>true</code> if this button is armed. If a button is armed, it will fire
 * an ActionPerformed when released.
 *
 * @return <code>true</code> if this button is armed
 * @since 2.0
 */
public bool isArmed() {
    return (state & ARMED_FLAG) !is 0;
}

/**
 * Returns <code>true</code> if this button is enabled.
 *
 * @return <code>true</code> if this button is enabled
 * @since 2.0
 */
public bool isEnabled() {
    return (state & ENABLED_FLAG) !is 0;
}

/**
 * Returns <code>true</code> if the mouse is over this button.
 *
 * @return <code>true</code> if the mouse is over this button
 * @since 2.0
 */
public bool isMouseOver() {
    return (state & MOUSEOVER_FLAG) !is 0;
}

/**
 * Returns <code>true</code> if this button is pressed.
 *
 * @return <code>true</code> if this button is pressed
 * @since 2.0
 */
public bool isPressed() {
    return (state & PRESSED_FLAG) !is 0;
}

/**
 * Returns the selection state of this model. If this model belongs to any group, the
 * group is queried for selection state, else the flags are used.
 *
 * @return  <code>true</code> if this button is selected
 * @since 2.0
 */
public bool isSelected() {
    if (group is null) {
        return (state & SELECTED_FLAG) !is 0;
    } else {
        return group.isSelected(this);
    }
}

/**
 * Removes the given ActionListener.
 *
 * @param listener The ActionListener to remove
 * @since 2.0
 */
public void removeActionListener(ActionListener listener) {
    listeners.removeListener(ActionListener.classinfo, cast(Object)listener);
}

/**
 * Removes the given ChangeListener.
 *
 * @param listener The ChangeListener to remove
 * @since 2.0
 */
public void removeChangeListener(ChangeListener listener) {
    listeners.removeListener(ChangeListener.classinfo, cast(Object)listener);
}

/**
 * Removes the given ButtonStateTransitionListener.
 *
 * @param listener The ButtonStateTransitionListener to remove
 * @since 2.0
 */
public void removeStateTransitionListener(ButtonStateTransitionListener listener) {
    listeners.removeListener(ButtonStateTransitionListener.classinfo, cast(Object)listener);
}

/**
 * Sets this button to be armed. If a button is armed, it will fire an ActionPerformed
 * when released.
 *
 *@param value The armed state
 * @since 2.0
 */
public void setArmed(bool value) {
    if (isArmed() is value)
        return;
    if (!isEnabled())
        return;
    setFlag(ARMED_FLAG, value);
    fireStateChanged(ARMED_PROPERTY);
}

/**
 * Sets this button to be enabled.
 *
 * @param value The enabled state
 * @since 2.0
 */
public void setEnabled(bool value) {
    if (isEnabled() is value)
        return;
    if (!value) {
        setMouseOver(false);
        setArmed(false);
        setPressed(false);
    }
    setFlag(ENABLED_FLAG, value);
    fireStateChanged(ENABLED_PROPERTY);
}

/**
 * Sets the firing behavior for this button. {@link #DEFAULT_FIRING_BEHAVIOR} is the
 * default behavior, where action performed events are not fired until the mouse button is
 * released. {@link #REPEAT_FIRING_BEHAVIOR} causes action performed events to fire
 * repeatedly until the mouse button is released.
 *
 * @param type The firing behavior type
 * @since 2.0
 *
 */
public void setFiringBehavior(int type) {
    if (firingBehavior !is null)
        removeStateTransitionListener(firingBehavior);
    switch (type) {
        case REPEAT_FIRING_BEHAVIOR:
            firingBehavior = new RepeatFiringBehavior();
            break;
        default:
            firingBehavior = new DefaultFiringBehavior();
    }
    addStateTransitionListener(firingBehavior);
}

void setFlag(int flag, bool value) {
    if (value)
        state |= flag;
    else
        state &= ~flag;
}

/**
 * Sets the ButtonGroup to which this model belongs to. Adds this model as a listener to
 * the group.
 *
 * @param bg The group to which this model belongs.
 * @since 2.0
 */
public void setGroup(ButtonGroup bg) {
    if (group is bg)
        return;
    if (group !is null)
        group.remove(this);
    group = bg;
    if (group !is null)
        group.add(this);
}

/**
 * Sets the mouseover property of this button.
 *
 * @param value The value the mouseover property will be set to
 * @since 2.0
 */
public void setMouseOver(bool value) {
    if (isMouseOver() is value)
        return;
    if (isPressed())
        if (value)
            fireResume();
        else
            fireSuspend();
    setFlag(MOUSEOVER_FLAG, value);
    fireStateChanged(MOUSEOVER_PROPERTY);
}

/**
 * Sets the pressed property of this button.
 *
 * @param value The value the pressed property will be set to
 * @since 2.0
 */
public void setPressed(bool value) {
    if (isPressed() is value)
        return;
    setFlag(PRESSED_FLAG, value);
    if (value)
        firePressed();
    else {
        if (isArmed())
            fireReleased();
        else
            fireCanceled();
    }
    fireStateChanged(PRESSED_PROPERTY);
}

/**
 * Sets this button to be selected.
 *
 * @param value The value the selected property will be set to
 * @since 2.0
 */
public void setSelected(bool value) {
    if (group is null) {
        if (isSelected() is value)
            return;
    } else {
        group.setSelected(this, value);
        if (getFlag(SELECTED_FLAG) is isSelected())
            return;
    }
    setFlag(SELECTED_FLAG, value);
    fireStateChanged(SELECTED_PROPERTY);
}

/**
 * Sets user data.
 *
 * @param data The user data
 * @since 2.0
 */
public void setUserData(Object data) {
    this.data = data;
}

class DefaultFiringBehavior
    : ButtonStateTransitionListener
{
    public void released() {
        fireActionPerformed();
    }
}

class RepeatFiringBehavior
    : ButtonStateTransitionListener
{
    protected static const int
        INITIAL_DELAY = 250,
        STEP_DELAY = 40;

    protected int
        stepDelay = INITIAL_DELAY,
        initialDelay = STEP_DELAY;

    protected Timer timer;

    public void pressed() {
        fireActionPerformed();
        if (!isEnabled())
            return;

        timer = new Timer();
        TimerTask runAction = new Task(timer);

        timer.scheduleAtFixedRate(runAction, INITIAL_DELAY, STEP_DELAY);
    }

    public void canceled() {
        suspend();
    }
    public void released() {
        suspend();
    }

    public void resume() {
        timer = new Timer();

        TimerTask runAction = new Task(timer);

        timer.scheduleAtFixedRate(runAction, STEP_DELAY, STEP_DELAY);
    }

    public void suspend() {
        if (timer is null) return;
        timer.cancel();
        timer = null;
    }
}

class Task
    : TimerTask {

    private Timer timer;

    public this(Timer timer) {
        this.timer = timer;
    }

    public void run() {
        dwt.widgets.Display.Display.getDefault().syncExec(dgRunnable( {
                if (!isEnabled())
                    timer.cancel();
                fireActionPerformed();
        }));
    }
}

}
