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
module dwtx.jface.text.IAutoIndentStrategy;

import dwtx.jface.text.IAutoEditStrategy; // packageimport

import dwt.dwthelper.utils;

/**
 * Exists for backward compatibility.
 *
 * @deprecated since 3.0, use <code>IAutoEditStrategy</code> directly
 */
public interface IAutoIndentStrategy : IAutoEditStrategy {
}
