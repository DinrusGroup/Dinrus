/*******************************************************************************
 * Copyright (c) 2000, 2006 IBM Corporation and others.
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
module dwtx.jface.text.rules.WordPatternRule;

import dwtx.jface.text.rules.FastPartitioner; // packageimport
import dwtx.jface.text.rules.ITokenScanner; // packageimport
import dwtx.jface.text.rules.Token; // packageimport
import dwtx.jface.text.rules.RuleBasedScanner; // packageimport
import dwtx.jface.text.rules.EndOfLineRule; // packageimport
import dwtx.jface.text.rules.WordRule; // packageimport
import dwtx.jface.text.rules.WhitespaceRule; // packageimport
import dwtx.jface.text.rules.IPredicateRule; // packageimport
import dwtx.jface.text.rules.DefaultPartitioner; // packageimport
import dwtx.jface.text.rules.NumberRule; // packageimport
import dwtx.jface.text.rules.SingleLineRule; // packageimport
import dwtx.jface.text.rules.PatternRule; // packageimport
import dwtx.jface.text.rules.IWordDetector; // packageimport
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


import dwtx.core.runtime.Assert;



/**
 * A specific single line rule which stipulates that the start
 * and end sequence occur within a single word, as defined by a word detector.
 *
 * @see IWordDetector
 */
public class WordPatternRule : SingleLineRule {

    /** The word detector used by this rule */
    protected IWordDetector fDetector;
    /** The internal buffer used for pattern detection */
    private StringBuffer fBuffer;

    /**
     * Creates a rule for the given starting and ending word
     * pattern which, if detected, will return the specified token.
     * A word detector is used to identify words.
     *
     * @param detector the word detector to be used
     * @param startSequence the start sequence of the word pattern
     * @param endSequence the end sequence of the word pattern
     * @param token the token to be returned on success
     */
    public this(IWordDetector detector, String startSequence, String endSequence, IToken token) {
        this(detector, startSequence, endSequence, token, cast(wchar)0);
    }

    /**
    /**
     * Creates a rule for the given starting and ending word
     * pattern which, if detected, will return the specified token.
     * A word detector is used to identify words.
     * Any character which follows the given escapeCharacter will be ignored.
     *
     * @param detector the word detector to be used
     * @param startSequence the start sequence of the word pattern
     * @param endSequence the end sequence of the word pattern
     * @param token the token to be returned on success
     * @param escapeCharacter the escape character
     */
    public this(IWordDetector detector, String startSequence, String endSequence, IToken token, char escapeCharacter) {
        fBuffer= new StringBuffer();
        super(startSequence, endSequence, token, escapeCharacter);
        Assert.isNotNull(cast(Object)detector);
        fDetector= detector;
    }

    /**
     * Returns whether the end sequence was detected.
     * The rule acquires the rest of the word, using the
     * provided word detector, and tests to determine if
     * it ends with the end sequence.
     *
     * @param scanner the scanner to be used
     * @return <code>true</code> if the word ends on the given end sequence
     */
    protected bool endSequenceDetected(ICharacterScanner scanner) {
        fBuffer.truncate(0);
        int c= scanner.read();
        while (fDetector.isWordPart(cast(dchar) c)) {
            fBuffer.append(cast(char) c);
            c= scanner.read();
        }
        scanner.unread();

        if (fBuffer.length() >= fEndSequence.length) {
            for (int i=fEndSequence.length - 1, j= fBuffer.length() - 1; i >= 0; i--, j--) {
                if (fEndSequence[i] !is fBuffer.slice()[j]) {
                    unreadBuffer(scanner);
                    return false;
                }
            }
            return true;
        }

        unreadBuffer(scanner);
        return false;
    }

    /**
     * Returns the characters in the buffer to the scanner.
     * Note that the rule must also return the characters
     * read in as part of the start sequence expect the first one.
     *
     * @param scanner the scanner to be used
     */
    protected void unreadBuffer(ICharacterScanner scanner) {
        fBuffer.select(0, 0 );
        fBuffer.replace(fStartSequence);
        for (int i= fBuffer.length() - 1; i > 0; i--)
            scanner.unread();
    }
}
