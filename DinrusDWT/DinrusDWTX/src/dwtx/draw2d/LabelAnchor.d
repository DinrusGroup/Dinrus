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
module dwtx.draw2d.LabelAnchor;

import dwt.dwthelper.utils;

import dwtx.draw2d.geometry.Rectangle;
import dwtx.draw2d.ChopboxAnchor;
import dwtx.draw2d.Label;

/**
 * LabelAnchors must have an owner of type {@link Label}. The LabelAnchor behaves like
 * {@link ChopboxAnchor} but {@link Connection Connections} will point to the center of
 * its owner's icon as opposed to the center of the entire owning Label.
 */
public class LabelAnchor
    : ChopboxAnchor
{

/**
 * Constructs a LabelAnchor with no owner.
 *
 * @since 2.0
 */
protected this() { }

/**
 * Constructs a LabelAnchor with owner <i>label</i>.
 * @param label This LabelAnchor's owner
 * @since 2.0
 */
public this(Label label) {
    super(label);
}

/**
 * Returns the bounds of this LabelAnchor's owning Label icon.
 * @return The bounds of this LabelAnchor's owning Label icon
 * @since 2.0
 */
protected Rectangle getBox() {
    Label label = cast(Label)getOwner();
    return label.getIconBounds();
}

}
