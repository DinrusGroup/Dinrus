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


module dwtx.jface.text.rules.DefaultDamagerRepairer;

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
import dwtx.jface.text.rules.RuleBasedDamagerRepairer; // packageimport
import dwtx.jface.text.rules.ICharacterScanner; // packageimport
import dwtx.jface.text.rules.IRule; // packageimport
import dwtx.jface.text.rules.IToken; // packageimport
import dwtx.jface.text.rules.IPartitionTokenScanner; // packageimport
import dwtx.jface.text.rules.MultiLineRule; // packageimport
import dwtx.jface.text.rules.RuleBasedPartitioner; // packageimport
import dwtx.jface.text.rules.RuleBasedPartitionScanner; // packageimport
import dwtx.jface.text.rules.BufferedRuleBasedScanner; // packageimport
import dwtx.jface.text.rules.IWhitespaceDetector; // packageimport

import dwt.dwthelper.utils;





import dwt.DWT;
import dwt.custom.StyleRange;
import dwtx.core.runtime.Assert;
import dwtx.jface.text.BadLocationException;
import dwtx.jface.text.DocumentEvent;
import dwtx.jface.text.IDocument;
import dwtx.jface.text.IRegion;
import dwtx.jface.text.ITypedRegion;
import dwtx.jface.text.Region;
import dwtx.jface.text.TextAttribute;
import dwtx.jface.text.TextPresentation;
import dwtx.jface.text.presentation.IPresentationDamager;
import dwtx.jface.text.presentation.IPresentationRepairer;


/**
 * A standard implementation of a syntax driven presentation damager
 * and presentation repairer. It uses a token scanner to scan
 * the document and to determine its damage and new text presentation.
 * The tokens returned by the scanner are supposed to return text attributes
 * as their data.
 *
 * @see ITokenScanner
 * @since 2.0
 */
public class DefaultDamagerRepairer : IPresentationDamager, IPresentationRepairer {


    /** The document this object works on */
    protected IDocument fDocument;
    /** The scanner it uses */
    protected ITokenScanner fScanner;
    /** The default text attribute if non is returned as data by the current token */
    protected TextAttribute fDefaultTextAttribute;

    /**
     * Creates a damager/repairer that uses the given scanner and returns the given default
     * text attribute if the current token does not carry a text attribute.
     *
     * @param scanner the token scanner to be used
     * @param defaultTextAttribute the text attribute to be returned if non is specified by the current token,
     *          may not be <code>null</code>
     *
     * @deprecated use DefaultDamagerRepairer(ITokenScanner) instead
     */
    public this(ITokenScanner scanner, TextAttribute defaultTextAttribute) {

        Assert.isNotNull(defaultTextAttribute);

        fScanner= scanner;
        fDefaultTextAttribute= defaultTextAttribute;
    }

    /**
     * Creates a damager/repairer that uses the given scanner. The scanner may not be <code>null</code>
     * and is assumed to return only token that carry text attributes.
     *
     * @param scanner the token scanner to be used, may not be <code>null</code>
     */
    public this(ITokenScanner scanner) {

        Assert.isNotNull(cast(Object)scanner);

        fScanner= scanner;
        fDefaultTextAttribute= new TextAttribute(null);
    }

    /*
     * @see IPresentationDamager#setDocument(IDocument)
     * @see IPresentationRepairer#setDocument(IDocument)
     */
    public void setDocument(IDocument document) {
        fDocument= document;
    }


    //---- IPresentationDamager

    /**
     * Returns the end offset of the line that contains the specified offset or
     * if the offset is inside a line delimiter, the end offset of the next line.
     *
     * @param offset the offset whose line end offset must be computed
     * @return the line end offset for the given offset
     * @exception BadLocationException if offset is invalid in the current document
     */
    protected int endOfLineOf(int offset)  {

        IRegion info= fDocument.getLineInformationOfOffset(offset);
        if (offset <= info.getOffset() + info.getLength())
            return info.getOffset() + info.getLength();

        int line= fDocument.getLineOfOffset(offset);
        try {
            info= fDocument.getLineInformation(line + 1);
            return info.getOffset() + info.getLength();
        } catch (BadLocationException x) {
            return fDocument.getLength();
        }
    }

    /*
     * @see IPresentationDamager#getDamageRegion(ITypedRegion, DocumentEvent, bool)
     */
    public IRegion getDamageRegion(ITypedRegion partition, DocumentEvent e, bool documentPartitioningChanged) {

        if (!documentPartitioningChanged) {
            try {

                IRegion info= fDocument.getLineInformationOfOffset(e.getOffset());
                int start= Math.max(partition.getOffset(), info.getOffset());

                int end= e.getOffset() + (e.getText() is null ? e.getLength() : e.getText().length());

                if (info.getOffset() <= end && end <= info.getOffset() + info.getLength()) {
                    // optimize the case of the same line
                    end= info.getOffset() + info.getLength();
                } else
                    end= endOfLineOf(end);

                end= Math.min(partition.getOffset() + partition.getLength(), end);
                return new Region(start, end - start);

            } catch (BadLocationException x) {
            }
        }

        return partition;
    }

    //---- IPresentationRepairer

    /*
     * @see IPresentationRepairer#createPresentation(TextPresentation, ITypedRegion)
     */
    public void createPresentation(TextPresentation presentation, ITypedRegion region) {

        if (fScanner is null) {
            // will be removed if deprecated constructor will be removed
            addRange(presentation, region.getOffset(), region.getLength(), fDefaultTextAttribute);
            return;
        }

        int lastStart= region.getOffset();
        int length= 0;
        bool firstToken= true;
        IToken lastToken= Token.UNDEFINED;
        TextAttribute lastAttribute= getTokenTextAttribute(lastToken);

        fScanner.setRange(fDocument, lastStart, region.getLength());

        while (true) {
            IToken token= fScanner.nextToken();
            if (token.isEOF())
                break;

            TextAttribute attribute= getTokenTextAttribute(token);
            if (lastAttribute !is null && lastAttribute.equals(attribute)) {
                length += fScanner.getTokenLength();
                firstToken= false;
            } else {
                if (!firstToken)
                    addRange(presentation, lastStart, length, lastAttribute);
                firstToken= false;
                lastToken= token;
                lastAttribute= attribute;
                lastStart= fScanner.getTokenOffset();
                length= fScanner.getTokenLength();
            }
        }

        addRange(presentation, lastStart, length, lastAttribute);
    }

    /**
     * Returns a text attribute encoded in the given token. If the token's
     * data is not <code>null</code> and a text attribute it is assumed that
     * it is the encoded text attribute. It returns the default text attribute
     * if there is no encoded text attribute found.
     *
     * @param token the token whose text attribute is to be determined
     * @return the token's text attribute
     */
    protected TextAttribute getTokenTextAttribute(IToken token) {
        Object data= token.getData();
        if ( cast(TextAttribute)data )
            return cast(TextAttribute) data;
        return fDefaultTextAttribute;
    }

    /**
     * Adds style information to the given text presentation.
     *
     * @param presentation the text presentation to be extended
     * @param offset the offset of the range to be styled
     * @param length the length of the range to be styled
     * @param attr the attribute describing the style of the range to be styled
     */
    protected void addRange(TextPresentation presentation, int offset, int length, TextAttribute attr) {
        if (attr !is null) {
            int style= attr.getStyle();
            int fontStyle= style & (DWT.ITALIC | DWT.BOLD | DWT.NORMAL);
            StyleRange styleRange= new StyleRange(offset, length, attr.getForeground(), attr.getBackground(), fontStyle);
            styleRange.strikeout= (style & TextAttribute.STRIKETHROUGH) !is 0;
            styleRange.underline= (style & TextAttribute.UNDERLINE) !is 0;
            styleRange.font= attr.getFont();
            presentation.addStyleRange(styleRange);
        }
    }
}


