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


module dwtx.jface.text.rules.Token;

import dwtx.jface.text.rules.FastPartitioner; // packageimport
import dwtx.jface.text.rules.ITokenScanner; // packageimport
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
 * Standard implementation of <code>IToken</code>.
 */
public class Token : IToken {

    /** Internal token type: Undefined */
    private static const int T_UNDEFINED= 0;
    /** Internal token type: EOF */
    private static const int T_EOF= 1;
    /** Internal token type: Whitespace */
    private static const int T_WHITESPACE= 2;
    /** Internal token type: Others */
    private static const int T_OTHER=   3;


    /**
     * Standard token: Undefined.
     */
    public static IToken UNDEFINED_;
    public static IToken UNDEFINED(){
        if( UNDEFINED_ is null ){
            synchronized( Token.classinfo ){
                if( UNDEFINED_ is null ){
                    UNDEFINED_ = new Token(T_UNDEFINED);
                }
            }
        }
        return UNDEFINED_;
    }
    /**
     * Standard token: End Of File.
     */
    public static IToken EOF_;
    public static IToken EOF(){
        if( EOF_ is null ){
            synchronized( Token.classinfo ){
                if( EOF_ is null ){
                    EOF_ = new Token(T_EOF);
                }
            }
        }
        return EOF_;
    }
    /**
     * Standard token: Whitespace.
     */
    public static IToken WHITESPACE_;
    public static IToken WHITESPACE(){
        if( WHITESPACE_ is null ){
            synchronized( Token.classinfo ){
                if( WHITESPACE_ is null ){
                    WHITESPACE_ = new Token(T_WHITESPACE);
                }
            }
        }
        return WHITESPACE_;
    }

    /**
     * Standard token: Neither {@link #UNDEFINED}, {@link #WHITESPACE}, nor {@link #EOF}.
     * @deprecated will be removed
     */
    public static IToken OTHER_;
    public static IToken OTHER(){
        if( OTHER_ is null ){
            synchronized( Token.classinfo ){
                if( OTHER_ is null ){
                    OTHER_ = new Token(T_OTHER);
                }
            }
        }
        return OTHER_;
    }

    /** The type of this token */
    private int fType;
    /** The data associated with this token */
    private Object fData;

    /**
     * Creates a new token according to the given specification which does not
     * have any data attached to it.
     *
     * @param type the type of the token
     * @since 2.0
     */
    private this(int type) {
        fType= type;
        fData= null;
    }

    /**
     * Creates a new token which represents neither undefined, whitespace, nor EOF.
     * The newly created token has the given data attached to it.
     *
     * @param data the data attached to the newly created token
     */
    public this(Object data) {
        fType= T_OTHER;
        fData= data;
    }

    /**
     * Re-initializes the data of this token. The token may not represent
     * undefined, whitespace, or EOF.
     *
     * @param data to be attached to the token
     * @since 2.0
     */
    public void setData(Object data) {
        Assert.isTrue(isOther());
        fData= data;
    }

    /*
     * @see IToken#getData()
     */
    public Object getData() {
        return fData;
    }

    /*
     * @see IToken#isOther()
     */
    public bool isOther() {
        return (fType is T_OTHER);
    }

    /*
     * @see IToken#isEOF()
     */
    public bool isEOF() {
        return (fType is T_EOF);
    }

    /*
     * @see IToken#isWhitespace()
     */
    public bool isWhitespace() {
        return (fType is T_WHITESPACE);
    }

    /*
     * @see IToken#isUndefined()
     */
    public bool isUndefined() {
        return (fType is T_UNDEFINED);
    }
}
