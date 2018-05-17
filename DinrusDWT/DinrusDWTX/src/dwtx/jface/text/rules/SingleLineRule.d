/*******************************************************************************
 * Copyright (c) 2000, 2005 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *     Christopher Lenz (cmlenz@gmx.de) - support for line continuation
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/
module dwtx.jface.text.rules.SingleLineRule;

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
import dwtx.jface.text.rules.PatternRule; // packageimport
import dwtx.jface.text.rules.RuleBasedDamagerRepairer; // packageimport
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


/**
 * A specific configuration of pattern rule whereby
 * the pattern begins with a specific sequence and may
 * end with a specific sequence, but will not span more
 * than a single line.
 */
public class SingleLineRule : PatternRule {

    /**
     * Creates a rule for the given starting and ending sequence
     * which, if detected, will return the specified token.
     *
     * @param startSequence the pattern's start sequence
     * @param endSequence the pattern's end sequence
     * @param token the token to be returned on success
     */
    public this(String startSequence, String endSequence, IToken token) {
        this(startSequence, endSequence, token, cast(wchar) 0);
    }

    /**
     * Creates a rule for the given starting and ending sequence
     * which, if detected, will return the specified token.
     * Any character which follows the given escape character
     * will be ignored.
     *
     * @param startSequence the pattern's start sequence
     * @param endSequence the pattern's end sequence
     * @param token the token to be returned on success
     * @param escapeCharacter the escape character
     */
    public this(String startSequence, String endSequence, IToken token, char escapeCharacter) {
        this(startSequence, endSequence, token, escapeCharacter, false);
    }

    /**
     * Creates a rule for the given starting and ending sequence
     * which, if detected, will return the specified token. Alternatively, the
     * line can also be ended with the end of the file.
     * Any character which follows the given escape character
     * will be ignored.
     *
     * @param startSequence the pattern's start sequence
     * @param endSequence the pattern's end sequence
     * @param token the token to be returned on success
     * @param escapeCharacter the escape character
     * @param breaksOnEOF indicates whether the end of the file successfully terminates this rule
     * @since 2.1
     */
    public this(String startSequence, String endSequence, IToken token, char escapeCharacter, bool breaksOnEOF) {
        super(startSequence, endSequence, token, escapeCharacter, true, breaksOnEOF);
    }

    /**
     * Creates a rule for the given starting and ending sequence
     * which, if detected, will return the specified token. Alternatively, the
     * line can also be ended with the end of the file.
     * Any character which follows the given escape character
     * will be ignored. In addition, an escape character immediately before an
     * end of line can be set to continue the line.
     *
     * @param startSequence the pattern's start sequence
     * @param endSequence the pattern's end sequence
     * @param token the token to be returned on success
     * @param escapeCharacter the escape character
     * @param breaksOnEOF indicates whether the end of the file successfully terminates this rule
     * @param escapeContinuesLine indicates whether the specified escape character is used for line
     *        continuation, so that an end of line immediately after the escape character does not
     *        terminate the line, even if <code>breakOnEOL</code> is true
     * @since 3.0
     */
    public this(String startSequence, String endSequence, IToken token, char escapeCharacter, bool breaksOnEOF, bool escapeContinuesLine) {
        super(startSequence, endSequence, token, escapeCharacter, true, breaksOnEOF, escapeContinuesLine);
    }
}
