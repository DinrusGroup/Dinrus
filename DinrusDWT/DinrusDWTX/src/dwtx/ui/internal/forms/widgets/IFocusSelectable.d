/*******************************************************************************
 * Copyright (c) 2003, 2005 IBM Corporation and others.
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
module dwtx.ui.internal.forms.widgets.IFocusSelectable;

import dwtx.dwtxhelper.Collection;

import dwt.graphics.Rectangle;
import dwt.dwthelper.utils;

public interface IFocusSelectable {
    bool isFocusSelectable(Hashtable resourceTable);
    bool setFocus(Hashtable resourceTable, bool direction);
    Rectangle getBounds();
}
