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


module dwtx.jface.text.rules.RuleBasedDamagerRepairer;

import dwtx.jface.text.rules.FastPartitioner; // packageimport
import dwtx.jface.text.rules.ITokenScanner; // packageimport
import dwtx.jface.text.rules.Token; // packageimport
import dwtx.jface.text.rules.RuleBasedScanner; // packageimport
import dwtx.jface.text.rules.EndOfLineRule; // packageimport
import dwtx.jface.text.rules.WordRule; // packageimport
import dwtx.jface.text.rules.WhitespaceRule; // packageimport
import dwtx.jface.text.rules.WordPatternRule; // packageimport
import dwtx.jface.text.rules.IPredicateRule; // packageimport
import dwtx.jface.text.rules.DefaultPartitioner; // packageimport
import dwtx.jface.text.rules.NumberRule; // packageimport
import dwtx.jface.text.rules.SingleLineRule; // packageimport
import dwtx.jface.text.rules.PatternRule; // packageimport
import dwtx.jface.text.rules.ICharacterScanner; // packageimport
import dwtx.jface.text.rules.IRule; // packageimport
import dwtx.jface.text.rules.DefaultDamagerRepairer; // packageimport
import dwtx.jface.text.rules.IToken; // packageimport
import dwtx.jface.text.rules.IPartitionTokenScanner; // packageimport
import dwtx.jface.text.rules.MultiLineRule; // packageimport
import dwtx.jface.text.rules.RuleBasedPartitioner; // packageimport
import dwtx.jface.text.rules.RuleBasedPartitionScanner; // packageimport
import dwtx.jface.text.rules.BufferedRuleBasedScanner; // packageimport
import dwtx.jface.text.rules.IWhitespaceDetector; // packageimport

import dwt.dwthelper.utils;


import dwtx.jface.text.TextAttribute;


/**
 * @deprecated use <code>DefaultDamagerRepairer</code>
 */
public class RuleBasedDamagerRepairer : DefaultDamagerRepairer {

    /**
     * Creates a damager/repairer that uses the given scanner and returns the given default
     * text attribute if the current token does not carry a text attribute.
     *
     * @param scanner the rule based scanner to be used
     * @param defaultTextAttribute the text attribute to be returned if none is specified by the current token,
     *          may not be <code>null</code>
     *
     * @deprecated use RuleBasedDamagerRepairer(RuleBasedScanner) instead
     */
    public this(RuleBasedScanner scanner, TextAttribute defaultTextAttribute) {
        super(scanner, defaultTextAttribute);
    }

    /**
     * Creates a damager/repairer that uses the given scanner. The scanner may not be <code>null</code>
     * and is assumed to return only token that carry text attributes.
     *
     * @param scanner the rule based scanner to be used, may not be <code>null</code>
     * @since 2.0
     */
    public this(RuleBasedScanner scanner) {
        super(scanner);
    }
}


