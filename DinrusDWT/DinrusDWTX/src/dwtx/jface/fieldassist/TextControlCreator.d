/*******************************************************************************
 * Copyright (c) 2005, 2007 IBM Corporation and others.
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
module dwtx.jface.fieldassist.TextControlCreator;

import dwtx.jface.fieldassist.IControlCreator;

import dwt.widgets.Composite;
import dwt.widgets.Control;
import dwt.widgets.Text;

import dwt.dwthelper.utils;

/**
 * An {@link IControlCreator} for DWT Text controls. This is a convenience class
 * for creating text controls to be supplied to a decorated field.
 *
 * @since 3.2
 * @deprecated As of 3.3, clients should use {@link ControlDecoration} instead
 *             of {@link DecoratedField}.
 *
 */
public class TextControlCreator : IControlCreator {

    public Control createControl(Composite parent, int style) {
        return new Text(parent, style);
    }
}
