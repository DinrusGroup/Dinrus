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
module dwtx.ui.internal.forms.widgets.SWTUtil;
import dwt.dnd.DragSource;
import dwt.dnd.DropTarget;
import dwt.widgets.Caret;
import dwt.widgets.Control;
import dwt.widgets.Display;
import dwt.widgets.Menu;
import dwt.widgets.ScrollBar;
import dwt.widgets.Shell;
import dwt.widgets.Widget;

/**
 * Utility class to simplify access to some DWT resources.
 */
public class SWTUtil {

    /**
     * Returns the standard display to be used. The method first checks, if
     * the thread calling this method has an associated disaply. If so, this
     * display is returned. Otherwise the method returns the default display.
     */
    public static Display getStandardDisplay() {
        Display display;
        display = Display.getCurrent();
        if (display is null)
            display = Display.getDefault();
        return display;
    }

    /**
     * Returns the shell for the given widget. If the widget doesn't represent
     * a DWT object that manage a shell, <code>null</code> is returned.
     *
     * @return the shell for the given widget
     */
    public static Shell getShell(Widget widget) {
        if (null !is cast(Control)widget )
            return (cast(Control) widget).getShell();
        if (null !is cast(Caret)widget )
            return (cast(Caret) widget).getParent().getShell();
        if (null !is cast(DragSource)widget )
            return (cast(DragSource) widget).getControl().getShell();
        if (null !is cast(DropTarget)widget )
            return (cast(DropTarget) widget).getControl().getShell();
        if (null !is cast(Menu)widget )
            return (cast(Menu) widget).getParent().getShell();
        if (null !is cast(ScrollBar)widget )
            return (cast(ScrollBar) widget).getParent().getShell();

        return null;
    }
}
