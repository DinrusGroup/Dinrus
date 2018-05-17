/*******************************************************************************
 * Copyright (c) 2000, 2007 IBM Corporation and others.
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
module dwtx.draw2d.text.FlowUtilities;

import dwt.dwthelper.utils;

import dwtx.dwtxhelper.mangoicu.UBreakIterator;
import dwtx.dwtxhelper.mangoicu.ULocale;

import dwt.DWT;
import dwt.graphics.Font;
import dwt.graphics.Rectangle;
import dwt.graphics.TextLayout;
import dwt.widgets.Display;
import dwtx.draw2d.FigureUtilities;
import dwtx.draw2d.TextUtilities;
import dwtx.draw2d.text.TextFragmentBox;
import dwtx.draw2d.text.InlineFlow;
import dwtx.draw2d.text.FlowContext;
import dwtx.draw2d.text.FlowBorder;
import dwtx.draw2d.text.ParagraphTextLayout;
import dwtx.draw2d.text.TextFlow;

interface LookAhead {
    int getWidth();
}

/**
 * Utility class for FlowFigures.
 * @author hudsonr
 * @since 3.4
 */
public class FlowUtilities
{

/**
 * a singleton default instance
 */
private static FlowUtilities INSTANCE_;
public static FlowUtilities INSTANCE(){
    if( INSTANCE_ is null ){
        synchronized( FlowUtilities.classinfo ){
            if( INSTANCE_ is null ){
                INSTANCE_ = new FlowUtilities();
            }
        }
    }
    return INSTANCE_;
}



private static bool INTERNAL_LINE_BREAK_initialized = false;
private static UBreakIterator INTERNAL_LINE_BREAK_;
private static UBreakIterator INTERNAL_LINE_BREAK(){
    if( !INTERNAL_LINE_BREAK_initialized ){
        synchronized( FlowUtilities.classinfo ){
            if( !INTERNAL_LINE_BREAK_initialized ){
                INTERNAL_LINE_BREAK_ = UBreakIterator.openLineIterator( ULocale.Default );
            }
            INTERNAL_LINE_BREAK_initialized = true;
        }
    }
    return INTERNAL_LINE_BREAK_;
}

private static TextLayout layout;

private static bool LINE_BREAK_initialized = false;
private static UBreakIterator LINE_BREAK_;
static UBreakIterator LINE_BREAK(){
    if( !LINE_BREAK_initialized ){
        synchronized( FlowUtilities.classinfo ){
            if( !LINE_BREAK_initialized ){
                LINE_BREAK_ = UBreakIterator.openLineIterator( ULocale.Default );
            }
            LINE_BREAK_initialized = true;
        }
    }
    return LINE_BREAK_;
}

static bool canBreakAfter(dchar c) {
    bool result = CharacterIsWhitespace(c) || c is '-';
    if (!result && (c < 'a' || c > 'z')) {
        // chinese characters and such would be caught in here
        // LINE_BREAK is used here because INTERNAL_LINE_BREAK might be in use
        LINE_BREAK.setText(dcharToString(c) ~ "a"); //$NON-NLS-1$
        result = LINE_BREAK.isBoundary(1);
    }
    return result;
}

private static int findFirstDelimeter(String string) {
    int macNL = string.indexOf('\r');
    int unixNL = string.indexOf('\n');

    if (macNL is -1)
        macNL = Integer.MAX_VALUE;
    if (unixNL is -1)
        unixNL = Integer.MAX_VALUE;

    return Math.min(macNL, unixNL);
}

/**
 * Gets the average character width.
 *
 * @param fragment the supplied TextFragmentBox to use for calculation.
 *                 if the length is 0 or if the width is or below 0,
 *                 the average character width is taken from standard
 *                 font metrics.
 * @param font     the font to use in case the TextFragmentBox conditions
 *                 above are true.
 * @return         the average character width
 */
protected float getAverageCharWidth(TextFragmentBox fragment, Font font) {
    if (fragment.getWidth() > 0 && fragment.length !is 0)
        return fragment.getWidth() / cast(float)fragment.length;
    return FigureUtilities.getFontMetrics(font).getAverageCharWidth();
}

static int getBorderAscent(InlineFlow owner) {
    if (null !is cast(FlowBorder)owner.getBorder() ) {
        FlowBorder border = cast(FlowBorder)owner.getBorder();
        return border.getInsets(owner).top;
    }
    return 0;
}

static int getBorderAscentWithMargin(InlineFlow owner) {
    if (null !is cast(FlowBorder)owner.getBorder() ) {
        FlowBorder border = cast(FlowBorder)owner.getBorder();
        return border.getTopMargin() + border.getInsets(owner).top;
    }
    return 0;
}

static int getBorderDescent(InlineFlow owner) {
    if (null !is cast(FlowBorder)owner.getBorder() ) {
        FlowBorder border = cast(FlowBorder)owner.getBorder();
        return border.getInsets(owner).bottom;
    }
    return 0;
}

static int getBorderDescentWithMargin(InlineFlow owner) {
    if (null !is cast(FlowBorder)owner.getBorder() ) {
        FlowBorder border = cast(FlowBorder)owner.getBorder();
        return border.getBottomMargin() + border.getInsets(owner).bottom;
    }
    return 0;
}

/**
 * Provides a TextLayout that can be used by the Draw2d text package for Bidi.  This
 * TextLayout should not be disposed by clients.  The provided TextLayout's orientation
 * will be LTR.
 *
 * @return an DWT TextLayout that can be used for Bidi
 * @since 3.1
 */
static TextLayout getTextLayout() {
    if (layout is null)
        layout = new TextLayout(Display.getDefault());
    layout.setOrientation(DWT.LEFT_TO_RIGHT);
    return layout;
}

/**
 * @param frag
 * @param string
 * @param font
 * @since 3.1
 */
private static void initBidi(TextFragmentBox frag, String string, Font font) {
    if (frag.requiresBidi()) {
        TextLayout textLayout = getTextLayout();
        textLayout.setFont(font);
        //$TODO need to insert overrides in front of string.
        textLayout.setText(string);
    }
}

private int measureString(TextFragmentBox frag, String string, int guess, Font font) {
    if (frag.requiresBidi()) {
        // The text and/or could have changed if the lookAhead was invoked.  This will
        // happen at most once.
        return getTextLayoutBounds(string, font, 0, guess - 1).width;
    } else
        return getTextUtilities().getStringExtents(string.substring(0, guess), font).width;
}

/**
 * Sets up the fragment width based using the font and string passed in.
 *
 * @param fragment
 *            the text fragment whose width will be set
 * @param font
 *            the font to be used in the calculation
 * @param string
 *            the string to be used in the calculation
 */
final protected void setupFragment(TextFragmentBox fragment, Font font, String string) {
    if (fragment.getWidth() is -1 || fragment.isTruncated()) {
        int width;
        if (string.length is 0 || fragment.length is 0)
            width = 0;
        else if (fragment.requiresBidi()) {
            width = getTextLayoutBounds(string, font, 0, fragment.length - 1).width;
        } else
            width = getTextUtilities().getStringExtents(string.substring(0, fragment.length), font).width;
        if (fragment.isTruncated())
            width += getEllipsisWidth(font);
        fragment.setWidth(width);
    }
}
package void setupFragment_package(TextFragmentBox fragment, Font font, String string) {
    setupFragment( fragment, font, string );
}

/**
 * Sets up a fragment and returns the number of characters consumed from the given
 * String. An average character width can be provided as a hint for faster calculation.
 * If a fragment's bidi level is set, a TextLayout will be used to calculate the width.
 *
 * @param frag the TextFragmentBox
 * @param string the String
 * @param font the Font used for measuring
 * @param context the flow context
 * @param wrapping the word wrap style
 * @return the number of characters that will fit in the given space; can be 0 (eg., when
 * the first character of the given string is a newline)
 */
final protected int wrapFragmentInContext(TextFragmentBox frag, String string,
        FlowContext context, LookAhead lookahead, Font font, int wrapping) {
    frag.setTruncated(false);
    int strLen = string.length;
    if (strLen is 0) {
        frag.setWidth(-1);
        frag.length = 0;
        setupFragment(frag, font, string);
        context.addToCurrentLine(frag);
        return 0;
    }

    INTERNAL_LINE_BREAK.setText(string);

    initBidi(frag, string, font);
    float avgCharWidth = getAverageCharWidth(frag, font);
    frag.setWidth(-1);

    /*
     * Setup initial boundaries within the string.
     */
    int absoluteMin = 0;
    int max, min = 1;
    if (wrapping is ParagraphTextLayout.WORD_WRAP_HARD) {
        absoluteMin = INTERNAL_LINE_BREAK.next();
        while (absoluteMin > 0 && CharacterIsWhitespace(string[absoluteMin - 1 .. $].firstCodePoint()))
            absoluteMin--;
        min = Math.max(absoluteMin, 1);
    }
    int firstDelimiter = findFirstDelimeter(string);
    if (firstDelimiter is 0)
        min = max = 0;
    else
        max = Math.min(strLen, firstDelimiter) + 1;


    int availableWidth = context.getRemainingLineWidth();
    int guess = 0, guessSize = 0;

    while (true) {
        if ((max - min) <= 1) {
            if (min is absoluteMin
                    && context.isCurrentLineOccupied()
                    && !context.getContinueOnSameLine()
                    && availableWidth < measureString(frag, string, min, font)
                        + ((min is strLen && lookahead !is null) ? lookahead.getWidth() : 0)
            ) {
                context.endLine();
                availableWidth = context.getRemainingLineWidth();
                max = Math.min(strLen, firstDelimiter) + 1;
                if ((max - min) <= 1)
                    break;
            } else
                break;
        }
        // Pick a new guess size
        // New guess is the last guess plus the missing width in pixels
        // divided by the average character size in pixels
        guess += 0.5f + (availableWidth - guessSize) / avgCharWidth;

        if (guess >= max) guess = max - 1;
        if (guess <= min) guess = min + 1;

        guessSize = measureString(frag, string, guess, font);

        if (guess is strLen
                && lookahead !is null
                && !canBreakAfter(string.charAt(strLen - 1))
                && guessSize + lookahead.getWidth() > availableWidth) {
            max = guess;
            continue;
        }

        if (guessSize <= availableWidth) {
            min = guess;
            frag.setWidth(guessSize);
            if (guessSize is availableWidth)
                max = guess + 1;
        } else
            max = guess;
    }

    int result = min;
    bool continueOnLine = false;
    if (min is strLen) {
        //Everything fits
        if (string.charAt(strLen - 1) is ' ') {
            if (frag.getWidth() is -1) {
                frag.length = result;
                frag.setWidth(measureString(frag, string, result, font));
            }
            if (lookahead.getWidth() > availableWidth - frag.getWidth()) {
                frag.length = result - 1;
                frag.setWidth(-1);
            } else
                frag.length = result;
        } else {
            continueOnLine = !canBreakAfter(string.charAt(strLen - 1));
            frag.length = result;
        }
    } else if (min is firstDelimiter) {
        //move result past the delimiter
        frag.length = result;
        if (string.charAt(min) is '\r') {
            result++;
            if (++min < strLen && string.charAt(min) is '\n')
                result++;
        } else if (string.charAt(min) is '\n')
            result++;
    } else if (string.charAt(min) is ' '
            || canBreakAfter(string.charAt(min - 1))
            || INTERNAL_LINE_BREAK.isBoundary(min)) {
        frag.length = min;
        if (string.charAt(min) is ' ')
            result++;
        else if (string.charAt(min - 1) is ' ') {
            frag.length--;
            frag.setWidth(-1);
        }
    } else {
out_:
        // In the middle of an unbreakable offset
        result = INTERNAL_LINE_BREAK.previous(min);
        if (result is 0) {
            switch (wrapping) {
                case ParagraphTextLayout.WORD_WRAP_TRUNCATE :
                    int truncatedWidth = availableWidth - getEllipsisWidth(font);
                    if (truncatedWidth > 0) {
                        //$TODO this is very slow.  It should be using avgCharWidth to go faster
                        while (min > 0) {
                            guessSize = measureString(frag, string, min, font);
                            if (guessSize <= truncatedWidth)
                                break;
                            min--;
                        }
                        frag.length = min;
                    } else
                        frag.length = 0;
                    frag.setTruncated(true);
                    result = INTERNAL_LINE_BREAK.next(max - 1);
                    goto out_;

                default:
                    result = min;
                    break;
            }
        }
        frag.length = result;
        if (string.charAt(result - 1) is ' ')
            frag.length--;
        frag.setWidth(-1);
    }

    setupFragment(frag, font, string);
    context.addToCurrentLine(frag);
    context.setContinueOnSameLine(continueOnLine);
    return result;
}
package int wrapFragmentInContext_package(TextFragmentBox frag, String string,
        FlowContext context, LookAhead lookahead, Font font, int wrapping) {
    return wrapFragmentInContext( frag, string, context, lookahead, font, wrapping );
}

/**
 * @see TextLayout#getBounds()
 */
protected Rectangle getTextLayoutBounds(String s, Font f, int start, int end) {
    TextLayout textLayout = getTextLayout();
    textLayout.setFont(f);
    textLayout.setText(s);
    return textLayout.getBounds(start, end);
}

/**
 * Returns an instance of a <code>TextUtililities</code> class on which
 * text calculations can be performed. Clients may override to customize.
 *
 * @return the <code>TextUtililities</code> instance
 * @since 3.4
 */
protected TextUtilities getTextUtilities() {
    return TextUtilities.INSTANCE;
}

/**
 * Gets the ellipsis width.
 *
 * @param font
 *            the font to be used in the calculation
 * @return the width of the ellipsis
 * @since 3.4
 */
private int getEllipsisWidth(Font font) {
    return getTextUtilities().getStringExtents(TextFlow.ELLIPSIS, font).width;
}
}
