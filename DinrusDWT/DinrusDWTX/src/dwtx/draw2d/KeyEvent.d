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
module dwtx.draw2d.KeyEvent;

import dwt.dwthelper.utils;
import dwtx.draw2d.InputEvent;
import dwtx.draw2d.IFigure;
import dwtx.draw2d.EventDispatcher;
static import dwt.events.KeyEvent;

/**
 * An event caused by the user interacting with the keyboard.
 */
public class KeyEvent
    : InputEvent
{

/**
 * The character that was pressed.
 * @see dwt.events.KeyEvent#character
 */
public char character;

/**
 * The keycode.
 * @see dwt.events.KeyEvent#keyCode
 */
public int keycode;

/**
 * Constructs a new KeyEvent.
 * @param dispatcher the event dispatcher
 * @param source the source of the event
 * @param ke an DWT key event used to supply the statemask, keycode and character
 */
public this(EventDispatcher dispatcher, IFigure source,
                    dwt.events.KeyEvent.KeyEvent ke) {
    super(dispatcher, source, ke.stateMask);
    character = ke.character;
    keycode = ke.keyCode;
}

}
