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
module dwtx.draw2d.PopUpHelper;

import dwt.dwthelper.utils;



import dwt.DWT;
import dwt.graphics.Color;
import dwt.graphics.Rectangle;
import dwt.widgets.Control;
import dwt.widgets.Shell;
import dwtx.draw2d.geometry.Dimension;
import dwtx.draw2d.LightweightSystem;

/**
 * Provides abstract support for classes that manage popups. Popups in Draw2d consist of a
 * LightweightSystem object with an DWT shell as its Control. Desired popup behavior is
 * attained by adding appropriate listeners to this shell.
 */
public abstract class PopUpHelper {

private Shell shell;
private LightweightSystem lws;
private bool tipShowing;
/**
 * The Control this PopUpHelper's tooltip will belong to.
 */
protected Control control;

/**
 * These style bits should be used when creating the Shell.
 * @see #createShell()
 */
protected const int shellStyle;

/**
 * Constructs a PopUpHelper to assist with popups on Control c.
 *
 * @param c the Control
 * @since 2.0
 */
protected this(Control c) {
    this (c, DWT.ON_TOP | DWT.NO_TRIM);
}

/**
 * Constructs a PopUpHelper to display the given shell style popup.
 * @param c the control on which the popup is active.
 * @param shellStyle the DWT style bits for the shell
 * @since 3.1
 */
protected this(Control c, int shellStyle) {
    control = c;
    this.shellStyle = shellStyle | DWT.NO_BACKGROUND | DWT.NO_REDRAW_RESIZE;
}

/**
 * Creates and returns the LightweightSystem object used by PopUpHelper to draw upon.
 *
 * @return the newly created LightweightSystem
 * @since 2.0
 */
protected LightweightSystem createLightweightSystem() {
    return new LightweightSystem();
}

/**
 * Creates a new Shell object with the style specified for this helper.
 *
 * @return the newly created Shell
 * @since 2.0
 */
protected Shell createShell() {
    return new Shell(control.getShell(), shellStyle);
}

/**
 * Dispose of this PopUpHelper object.
 *
 * @since 2.0
 */
public void dispose() {
    if (isShowing())
        hide();
    if (shell !is null && !shell.isDisposed())
        shell.dispose();
}

/**
 * Returns this PopUpHelper's shell. If no shell exists for this PopUpHelper, a new shell
 * is created and hookShellListeners() is called.
 *
 * @return the Shell
 * @since 2.0
 */
protected Shell getShell() {
    if (shell is null) {
        shell = createShell();
        hookShellListeners();
    }
    return shell;
}

/**
 * Returns the size needed to display the shell's trim.  This method should not be called
 * until the shell has been created.
 * @return the size of the shells trim.
 * @since 3.1
 */
protected Dimension getShellTrimSize() {
    Rectangle trim = shell.computeTrim(0, 0, 0, 0);
    return new Dimension(trim.width, trim.height);
}

/**
 * Returns this PopUpHelper's LightweightSystem. If no LightweightSystem exists for this
 * PopUpHelper, a new LightweightSystem is created with this PopUpHelper's Shell as its
 * Control.
 *
 * @return the LightweightSystem
 * @since 2.0
 */
protected LightweightSystem getLightweightSystem() {
    if (lws is null) {
        lws = createLightweightSystem();
        lws.setControl(getShell());
    }
    return lws;
}

/**
 * Hides this PopUpHelper's Shell.
 *
 * @since 2.0
 */
protected void hide() {
    if (shell !is null && !shell.isDisposed())
        shell.setVisible(false);
    tipShowing = false;
}

/**
 * Desired popup helper behavior is achieved by writing listeners that manipulate the
 * behavior of the PopUpHelper's Shell. Override this method and add these listeners here.
 *
 * @since 2.0
 */
protected abstract void hookShellListeners();

/**
 * Returns <code>true</code> if this PopUpHelper's Shell is visible, <code>false</code>
 * otherwise.
 *
 * @return <code>true</code> if this PopUpHelper's Shell is visible
 * @since 2.0
 */
public bool isShowing() {
    return tipShowing;
}

/**
 * Sets the background color of this PopUpHelper's Shell.
 *
 * @param c the new background color
 * @since 2.0
 */
public void setBackgroundColor(Color c) {
    getShell().setBackground(c);
}

/**
 * Sets the foreground color of this PopUpHelper's Shell.
 *
 * @param c the new foreground color
 * @since 2.0
 */
public void setForegroundColor(Color c) {
    getShell().setForeground(c);
}

/**
 * Sets the bounds on this PopUpHelper's Shell.
 *
 * @param x the x coordinate
 * @param y the y coordinate
 * @param width the width
 * @param height the height
 * @since 2.0
 */
protected void setShellBounds(int x, int y, int width, int height) {
    getShell().setBounds(x, y, width, height);
}

/**
 * Displays this PopUpHelper's Shell.
 *
 * @since 2.0
 */
protected void show() {
    getShell().setVisible(true);
    tipShowing = true;
}

}
