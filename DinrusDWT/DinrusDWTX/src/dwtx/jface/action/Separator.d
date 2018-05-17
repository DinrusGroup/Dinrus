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
module dwtx.jface.action.Separator;

import dwtx.jface.action.AbstractGroupMarker;

import dwt.DWT;
import dwt.widgets.Menu;
import dwt.widgets.MenuItem;
import dwt.widgets.ToolBar;
import dwt.widgets.ToolItem;

import dwt.dwthelper.utils;

/**
 * A separator is a special kind of contribution item which acts
 * as a visual separator and, optionally, acts as a group marker.
 * Unlike group markers, separators do have a visual representation for
 * menus and toolbars.
 * <p>
 * This class may be instantiated; it is not intended to be
 * subclassed outside the framework.
 * </p>
 * @noextend This class is not intended to be subclassed by clients.
 */
public class Separator : AbstractGroupMarker {
    alias AbstractGroupMarker.fill fill;
    /**
     * Creates a separator which does not start a new group.
     */
    public this() {
        super();
    }

    /**
     * Creates a new separator which also defines a new group having the given group name.
     * The group name must not be <code>null</code> or the empty string.
     * The group name is also used as the item id.
     *
     * @param groupName the group name of the separator
     */
    public this(String groupName) {
        super(groupName);
    }

    /* (non-Javadoc)
     * Method declared on IContributionItem.
     * Fills the given menu with a DWT separator MenuItem.
     */
    public override void fill(Menu menu, int index) {
        if (index >= 0) {
            new MenuItem(menu, DWT.SEPARATOR, index);
        } else {
            new MenuItem(menu, DWT.SEPARATOR);
        }
    }

    /* (non-Javadoc)
     * Method declared on IContributionItem.
     * Fills the given tool bar with a DWT separator ToolItem.
     */
    public override void fill(ToolBar toolbar, int index) {
        if (index >= 0) {
            new ToolItem(toolbar, DWT.SEPARATOR, index);
        } else {
            new ToolItem(toolbar, DWT.SEPARATOR);
        }
    }

    /**
     * The <code>Separator</code> implementation of this <code>IContributionItem</code>
     * method returns <code>true</code>
     */
    public override bool isSeparator() {
        return true;
    }
}
