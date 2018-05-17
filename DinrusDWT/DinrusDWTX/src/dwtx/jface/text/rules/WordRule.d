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
module dwtx.jface.text.rules.WordRule;

import dwtx.jface.text.rules.FastPartitioner; // packageimport
import dwtx.jface.text.rules.ITokenScanner; // packageimport
import dwtx.jface.text.rules.Token; // packageimport
import dwtx.jface.text.rules.RuleBasedScanner; // packageimport
import dwtx.jface.text.rules.EndOfLineRule; // packageimport
import dwtx.jface.text.rules.WhitespaceRule; // packageimport
import dwtx.jface.text.rules.WordPatternRule; // packageimport
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


import dwtx.dwtxhelper.Collection;



import dwtx.core.runtime.Assert;



/**
 * An implementation of <code>IRule</code> capable of detecting words
 * Word rules also allow for the association of tokens with specific words.
 * That is, not only can the rule be used to provide tokens for exact matches,
 * but also for the generalized notion of a word in the context in which it is used.
 * A word rules uses a word detector to determine what a word is.
 *
 * @see IWordDetector
 */
public class WordRule : IRule {

    /** Internal setting for the un-initialized column constraint. */
    protected static const int UNDEFINED= -1;

    /** The word detector used by this rule. */
    protected IWordDetector fDetector;
    /** The default token to be returned on success and if nothing else has been specified. */
    protected IToken fDefaultToken;
    /** The column constraint. */
    protected int fColumn= UNDEFINED;
    /** The table of predefined words and token for this rule. */
    protected Map fWords;
    /** Buffer used for pattern detection. */
    private StringBuffer fBuffer;
    /**
     * Tells whether this rule is case sensitive.
     * @since 3.3
     */
    private bool fIgnoreCase= false;

    /**
     * Creates a rule which, with the help of an word detector, will return the token
     * associated with the detected word. If no token has been associated, the scanner
     * will be rolled back and an undefined token will be returned in order to allow
     * any subsequent rules to analyze the characters.
     *
     * @param detector the word detector to be used by this rule, may not be <code>null</code>
     * @see #addWord(String, IToken)
     */
    public this(IWordDetector detector) {
        this(detector, Token.UNDEFINED, false);
    }

    /**
     * Creates a rule which, with the help of a word detector, will return the token
     * associated with the detected word. If no token has been associated, the
     * specified default token will be returned.
     *
     * @param detector the word detector to be used by this rule, may not be <code>null</code>
     * @param defaultToken the default token to be returned on success
     *          if nothing else is specified, may not be <code>null</code>
     * @see #addWord(String, IToken)
     */
    public this(IWordDetector detector, IToken defaultToken) {
        this(detector, defaultToken, false);
    }

    /**
     * Creates a rule which, with the help of a word detector, will return the token
     * associated with the detected word. If no token has been associated, the
     * specified default token will be returned.
     *
     * @param detector the word detector to be used by this rule, may not be <code>null</code>
     * @param defaultToken the default token to be returned on success
     *          if nothing else is specified, may not be <code>null</code>
     * @param ignoreCase the case sensitivity associated with this rule
     * @see #addWord(String, IToken)
     * @since 3.3
     */
    public this(IWordDetector detector, IToken defaultToken, bool ignoreCase) {
        fWords= new HashMap();
        fBuffer= new StringBuffer();

        Assert.isNotNull(cast(Object)detector);
        Assert.isNotNull(cast(Object)defaultToken);

        fDetector= detector;
        fDefaultToken= defaultToken;
        fIgnoreCase= ignoreCase;
    }

    /**
     * Adds a word and the token to be returned if it is detected.
     *
     * @param word the word this rule will search for, may not be <code>null</code>
     * @param token the token to be returned if the word has been found, may not be <code>null</code>
     */
    public void addWord(String word, IToken token) {
        //Assert.isNotNull(word);
        Assert.isNotNull(cast(Object)token);

        fWords.put(word, cast(Object)token);
    }

    /**
     * Sets a column constraint for this rule. If set, the rule's token
     * will only be returned if the pattern is detected starting at the
     * specified column. If the column is smaller then 0, the column
     * constraint is considered removed.
     *
     * @param column the column in which the pattern starts
     */
    public void setColumnConstraint(int column) {
        if (column < 0)
            column= UNDEFINED;
        fColumn= column;
    }

    /*
     * @see IRule#evaluate(ICharacterScanner)
     */
    public IToken evaluate(ICharacterScanner scanner) {
        int c= scanner.read();
        if (c !is ICharacterScanner.EOF && fDetector.isWordStart(cast(dchar) c)) {
            if (fColumn is UNDEFINED || (fColumn is scanner.getColumn() - 1)) {

                fBuffer.truncate(0);
                do {
                    fBuffer.append(cast(char) c);
                    c= scanner.read();
                } while (c !is ICharacterScanner.EOF && fDetector.isWordPart(cast(dchar) c));
                scanner.unread();

                String buffer= fBuffer.toString();
                IToken token= cast(IToken)fWords.get(buffer);

                if(fIgnoreCase) {
                    Iterator iter= fWords.keySet().iterator();
                    while (iter.hasNext()) {
                        String key= stringcast(iter.next());
                        if(buffer.equalsIgnoreCase(key)) {
                            token= cast(IToken)fWords.get(key);
                            break;
                        }
                    }
                } else
                    token= cast(IToken)fWords.get(buffer);

                if (token !is null)
                    return token;

                if (fDefaultToken.isUndefined())
                    unreadBuffer(scanner);

                return fDefaultToken;
            }
        }

        scanner.unread();
        return Token.UNDEFINED;
    }

    /**
     * Returns the characters in the buffer to the scanner.
     *
     * @param scanner the scanner to be used
     */
    protected void unreadBuffer(ICharacterScanner scanner) {
        for (int i= fBuffer.length() - 1; i >= 0; i--)
            scanner.unread();
    }

}
