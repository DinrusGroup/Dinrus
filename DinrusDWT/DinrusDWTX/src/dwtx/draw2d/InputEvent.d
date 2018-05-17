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
module dwtx.draw2d.InputEvent;

import dwt.dwthelper.utils;

import dwt.DWT;
import dwtx.draw2d.EventDispatcher;
import dwtx.draw2d.IFigure;

/**
 * The base class for Draw2d events.
 */
public abstract class InputEvent
    : /+java.util.+/EventObject
{

private int state;

private bool consumed = false;

/** @see DWT#ALT */
public static const int ALT = DWT.ALT;
/** @see DWT#CONTROL */
public static const int CONTROL = DWT.CONTROL;
/** @see DWT#SHIFT */
public static const int SHIFT = DWT.SHIFT;
/** @see DWT#BUTTON1 */
public static const int BUTTON1 = DWT.BUTTON1;
/** @see DWT#BUTTON2 */
public static const int BUTTON2 = DWT.BUTTON2;
/** @see DWT#BUTTON3 */
public static const int BUTTON3 = DWT.BUTTON3;
/** @see DWT#BUTTON4 */
public static const int BUTTON4 = DWT.BUTTON4;
/** @see DWT#BUTTON5 */
public static const int BUTTON5 = DWT.BUTTON5;
/** A bitwise OR'ing of {@link #BUTTON1}, {@link #BUTTON2}, {@link #BUTTON3},
 * {@link #BUTTON4} and {@link #BUTTON5} */
public static const int ANY_BUTTON = DWT.BUTTON_MASK;

/**
 * Constructs a new InputEvent.
 * @param dispatcher the event dispatcher
 * @param source the source of the event
 * @param state the state
 */
public this(EventDispatcher dispatcher, IFigure source, int state) {
    super(cast(Object)source);
    this.state = state;
}

/**
 * Marks this event as consumed so that it doesn't get passed on to other listeners.
 */
public void consume() {
    consumed = true;
}

/**
 * Returns the event statemask, which is a bitwise OR'ing of any of the following:
 * {@link #ALT}, {@link #CONTROL}, {@link #SHIFT}, {@link #BUTTON1}, {@link #BUTTON2},
 * {@link #BUTTON3}, {@link #BUTTON4} and {@link #BUTTON5}.
 * @return the state
 */
public int getState() {
    return state;
}

/**
 * @return whether this event has been consumed.
 */
public bool isConsumed() {
    return consumed;
}

}
