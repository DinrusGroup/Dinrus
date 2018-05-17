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

module dwtx.jface.bindings.keys.formatting.FormalKeyFormatter;

import dwtx.jface.bindings.keys.formatting.AbstractKeyFormatter;

import dwtx.jface.bindings.keys.IKeyLookup;
import dwtx.jface.bindings.keys.KeyLookupFactory;
import dwtx.jface.bindings.keys.KeySequence;
import dwtx.jface.bindings.keys.KeyStroke;

import dwt.dwthelper.utils;

/**
 * <p>
 * Formats the keys in the internal key sequence grammar. This is used for
 * persistence, and is not really intended for display to the user.
 * </p>
 *
 * @since 3.1
 */
public final class FormalKeyFormatter : AbstractKeyFormatter {
    alias AbstractKeyFormatter.format format;

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.bindings.keys.KeyFormatter#format(dwtx.ui.keys.KeySequence)
     */
    public override String format(int key) {
        IKeyLookup lookup = KeyLookupFactory.getDefault();
        return lookup.formalNameLookup(key);
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.bindings.keys.AbstractKeyFormatter#getKeyDelimiter()
     */
    protected override String getKeyDelimiter() {
        return KeyStroke.KEY_DELIMITER;
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.bindings.keys.AbstractKeyFormatter#getKeyStrokeDelimiter()
     */
    protected override String getKeyStrokeDelimiter() {
        return KeySequence.KEY_STROKE_DELIMITER;
    }

    /*
     * (non-Javadoc)
     *
     * @see dwtx.jface.bindings.keys.AbstractKeyFormatter#sortModifierKeys(int)
     */
    protected override int[] sortModifierKeys(int modifierKeys) {
        IKeyLookup lookup = KeyLookupFactory.getDefault();
        int[] sortedKeys = new int[4];
        int index = 0;

        if ((modifierKeys & lookup.getAlt()) !is 0) {
            sortedKeys[index++] = lookup.getAlt();
        }
        if ((modifierKeys & lookup.getCommand()) !is 0) {
            sortedKeys[index++] = lookup.getCommand();
        }
        if ((modifierKeys & lookup.getCtrl()) !is 0) {
            sortedKeys[index++] = lookup.getCtrl();
        }
        if ((modifierKeys & lookup.getShift()) !is 0) {
            sortedKeys[index++] = lookup.getShift();
        }

        return sortedKeys;
    }
}
