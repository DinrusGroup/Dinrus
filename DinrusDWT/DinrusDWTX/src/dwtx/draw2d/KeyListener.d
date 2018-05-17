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
module dwtx.draw2d.KeyListener;

import dwt.dwthelper.utils;
import dwtx.draw2d.KeyEvent;

/**
 * A listener interface for receiving {@link KeyEvent KeyEvents} from the keyboard.
 */
public interface KeyListener {

/**
 * Called when a key is pressed.
 * @param ke The KeyEvent object
 */
void keyPressed(KeyEvent ke);

/**
 * Called when a key is released.
 * @param ke The KeyEvent object
 */
void keyReleased(KeyEvent ke);

}

/**
 * An empty implementation of KeyListener for convenience.
 */
class KeyListenerStub
    : KeyListener
{
    /**
     * @see dwtx.draw2d.KeyListener#keyPressed(KeyEvent)
     */
    public void keyPressed(KeyEvent ke) { }
    /**
     * @see dwtx.draw2d.KeyListener#keyReleased(KeyEvent)
     */
    public void keyReleased(KeyEvent ke) { }

}
