/*******************************************************************************
 * Copyright (c) 2000, 2006 IBM Corporation and others.
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
module dwtx.jface.action.IMenuCreator;

import dwt.widgets.Control;
import dwt.widgets.Menu;

/**
 * Interface for something that creates and disposes of DWT menus.  Note that
 * it is the responsibility of the implementor to dispose of DWT menus it
 * creates.
 */
public interface IMenuCreator {
    /**
     * Disposes the menu returned by <code>getMenu</code>. Does nothing
     * if there is no menu.  This method will be executed only when the
     * parent of the menu is disposed.
     */
    public void dispose();

    /**
     * Returns the DWT menu, created as a pop up menu parented by the
     * given control.  In most cases, this menu can be created once, cached and reused
     * when the pop-up/drop-down action occurs.  If the menu must be dynamically
     * created (i.e., each time it is popped up or dropped down), the old menu
     * should be disposed of before replacing it with the new menu.
     *
     * @param parent the parent control
     * @return the menu, or <code>null</code> if the menu could not
     *  be created
     */
    public Menu getMenu(Control parent);

    /**
     * Returns an DWT menu created as a drop down menu parented by the
     * given menu.  In most cases, this menu can be created once, cached and reused
     * when the pop-up/drop-down action occurs.  If the menu must be dynamically
     * created (i.e., each time it is popped up or dropped down), the old menu
     * should be disposed of before replacing it with the new menu.
     *
     * @param parent the parent menu
     * @return the menu, or <code>null</code> if the menu could not
     *  be created
     */
    public Menu getMenu(Menu parent);
}
