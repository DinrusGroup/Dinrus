/*******************************************************************************
 * Copyright (c) 2004, 2005 IBM Corporation and others.
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

module dwtx.draw2d.text.BidiChars;

import dwt.dwthelper.utils;

/**
 * @since 3.1
 */
class BidiChars {

static const dchar P_SEP = '\u2029';
static const dchar ZWJ = '\u200d';
static const dchar LRO = '\u202d';
static const dchar RLO = '\u202e';
static const dchar OBJ = '\ufffc';
static const dchar LRE = '\u202a';
static const dchar RLE = '\u202b';

}
