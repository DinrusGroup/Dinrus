/*******************************************************************************
 * Copyright (c) 2000, 2008 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *     Cagatay Calli <ccalli@gmail.com> - [find/replace] retain caps when replacing - https://bugs.eclipse.org/bugs/show_bug.cgi?id=28949
 *     Cagatay Calli <ccalli@gmail.com> - [find/replace] define & fix behavior of retain caps with other escapes and text before \C - https://bugs.eclipse.org/bugs/show_bug.cgi?id=217061
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/
module dwtx.jface.text.FindReplaceDocumentAdapter;

import dwtx.jface.text.IDocumentPartitioningListener; // packageimport
import dwtx.jface.text.DefaultTextHover; // packageimport
import dwtx.jface.text.AbstractInformationControl; // packageimport
import dwtx.jface.text.TextUtilities; // packageimport
import dwtx.jface.text.IInformationControlCreatorExtension; // packageimport
import dwtx.jface.text.AbstractInformationControlManager; // packageimport
import dwtx.jface.text.ITextViewerExtension2; // packageimport
import dwtx.jface.text.IDocumentPartitioner; // packageimport
import dwtx.jface.text.DefaultIndentLineAutoEditStrategy; // packageimport
import dwtx.jface.text.ITextSelection; // packageimport
import dwtx.jface.text.Document; // packageimport
import dwtx.jface.text.FindReplaceDocumentAdapterContentProposalProvider; // packageimport
import dwtx.jface.text.ITextListener; // packageimport
import dwtx.jface.text.BadPartitioningException; // packageimport
import dwtx.jface.text.ITextViewerExtension5; // packageimport
import dwtx.jface.text.IDocumentPartitionerExtension3; // packageimport
import dwtx.jface.text.IUndoManager; // packageimport
import dwtx.jface.text.ITextHoverExtension2; // packageimport
import dwtx.jface.text.IRepairableDocument; // packageimport
import dwtx.jface.text.IRewriteTarget; // packageimport
import dwtx.jface.text.DefaultPositionUpdater; // packageimport
import dwtx.jface.text.RewriteSessionEditProcessor; // packageimport
import dwtx.jface.text.TextViewerHoverManager; // packageimport
import dwtx.jface.text.DocumentRewriteSession; // packageimport
import dwtx.jface.text.TextViewer; // packageimport
import dwtx.jface.text.ITextViewerExtension8; // packageimport
import dwtx.jface.text.RegExMessages; // packageimport
import dwtx.jface.text.IDelayedInputChangeProvider; // packageimport
import dwtx.jface.text.ITextOperationTargetExtension; // packageimport
import dwtx.jface.text.IWidgetTokenOwner; // packageimport
import dwtx.jface.text.IViewportListener; // packageimport
import dwtx.jface.text.GapTextStore; // packageimport
import dwtx.jface.text.MarkSelection; // packageimport
import dwtx.jface.text.IDocumentPartitioningListenerExtension; // packageimport
import dwtx.jface.text.IDocumentAdapterExtension; // packageimport
import dwtx.jface.text.IInformationControlExtension; // packageimport
import dwtx.jface.text.IDocumentPartitioningListenerExtension2; // packageimport
import dwtx.jface.text.DefaultDocumentAdapter; // packageimport
import dwtx.jface.text.ITextViewerExtension3; // packageimport
import dwtx.jface.text.IInformationControlCreator; // packageimport
import dwtx.jface.text.TypedRegion; // packageimport
import dwtx.jface.text.ISynchronizable; // packageimport
import dwtx.jface.text.IMarkRegionTarget; // packageimport
import dwtx.jface.text.TextViewerUndoManager; // packageimport
import dwtx.jface.text.IRegion; // packageimport
import dwtx.jface.text.IInformationControlExtension2; // packageimport
import dwtx.jface.text.IDocumentExtension4; // packageimport
import dwtx.jface.text.IDocumentExtension2; // packageimport
import dwtx.jface.text.IDocumentPartitionerExtension2; // packageimport
import dwtx.jface.text.DefaultInformationControl; // packageimport
import dwtx.jface.text.IWidgetTokenOwnerExtension; // packageimport
import dwtx.jface.text.DocumentClone; // packageimport
import dwtx.jface.text.DefaultUndoManager; // packageimport
import dwtx.jface.text.IFindReplaceTarget; // packageimport
import dwtx.jface.text.IAutoEditStrategy; // packageimport
import dwtx.jface.text.ILineTrackerExtension; // packageimport
import dwtx.jface.text.IUndoManagerExtension; // packageimport
import dwtx.jface.text.TextSelection; // packageimport
import dwtx.jface.text.DefaultAutoIndentStrategy; // packageimport
import dwtx.jface.text.IAutoIndentStrategy; // packageimport
import dwtx.jface.text.IPainter; // packageimport
import dwtx.jface.text.IInformationControl; // packageimport
import dwtx.jface.text.IInformationControlExtension3; // packageimport
import dwtx.jface.text.ITextViewerExtension6; // packageimport
import dwtx.jface.text.IInformationControlExtension4; // packageimport
import dwtx.jface.text.DefaultLineTracker; // packageimport
import dwtx.jface.text.IDocumentInformationMappingExtension; // packageimport
import dwtx.jface.text.IRepairableDocumentExtension; // packageimport
import dwtx.jface.text.ITextHover; // packageimport
import dwtx.jface.text.ILineTracker; // packageimport
import dwtx.jface.text.Line; // packageimport
import dwtx.jface.text.ITextViewerExtension; // packageimport
import dwtx.jface.text.IDocumentAdapter; // packageimport
import dwtx.jface.text.TextEvent; // packageimport
import dwtx.jface.text.BadLocationException; // packageimport
import dwtx.jface.text.AbstractDocument; // packageimport
import dwtx.jface.text.AbstractLineTracker; // packageimport
import dwtx.jface.text.TreeLineTracker; // packageimport
import dwtx.jface.text.ITextPresentationListener; // packageimport
import dwtx.jface.text.Region; // packageimport
import dwtx.jface.text.ITextViewer; // packageimport
import dwtx.jface.text.IDocumentInformationMapping; // packageimport
import dwtx.jface.text.MarginPainter; // packageimport
import dwtx.jface.text.IPaintPositionManager; // packageimport
import dwtx.jface.text.TextPresentation; // packageimport
import dwtx.jface.text.IFindReplaceTargetExtension; // packageimport
import dwtx.jface.text.ISlaveDocumentManagerExtension; // packageimport
import dwtx.jface.text.ISelectionValidator; // packageimport
import dwtx.jface.text.IDocumentExtension; // packageimport
import dwtx.jface.text.PropagatingFontFieldEditor; // packageimport
import dwtx.jface.text.ConfigurableLineTracker; // packageimport
import dwtx.jface.text.SlaveDocumentEvent; // packageimport
import dwtx.jface.text.IDocumentListener; // packageimport
import dwtx.jface.text.PaintManager; // packageimport
import dwtx.jface.text.IFindReplaceTargetExtension3; // packageimport
import dwtx.jface.text.ITextDoubleClickStrategy; // packageimport
import dwtx.jface.text.IDocumentExtension3; // packageimport
import dwtx.jface.text.Position; // packageimport
import dwtx.jface.text.TextMessages; // packageimport
import dwtx.jface.text.CopyOnWriteTextStore; // packageimport
import dwtx.jface.text.WhitespaceCharacterPainter; // packageimport
import dwtx.jface.text.IPositionUpdater; // packageimport
import dwtx.jface.text.DefaultTextDoubleClickStrategy; // packageimport
import dwtx.jface.text.ListLineTracker; // packageimport
import dwtx.jface.text.ITextInputListener; // packageimport
import dwtx.jface.text.BadPositionCategoryException; // packageimport
import dwtx.jface.text.IWidgetTokenKeeperExtension; // packageimport
import dwtx.jface.text.IInputChangedListener; // packageimport
import dwtx.jface.text.ITextOperationTarget; // packageimport
import dwtx.jface.text.IDocumentInformationMappingExtension2; // packageimport
import dwtx.jface.text.ITextViewerExtension7; // packageimport
import dwtx.jface.text.IInformationControlExtension5; // packageimport
import dwtx.jface.text.IDocumentRewriteSessionListener; // packageimport
import dwtx.jface.text.JFaceTextUtil; // packageimport
import dwtx.jface.text.AbstractReusableInformationControlCreator; // packageimport
import dwtx.jface.text.TabsToSpacesConverter; // packageimport
import dwtx.jface.text.CursorLinePainter; // packageimport
import dwtx.jface.text.ITextHoverExtension; // packageimport
import dwtx.jface.text.IEventConsumer; // packageimport
import dwtx.jface.text.IDocument; // packageimport
import dwtx.jface.text.IWidgetTokenKeeper; // packageimport
import dwtx.jface.text.DocumentCommand; // packageimport
import dwtx.jface.text.TypedPosition; // packageimport
import dwtx.jface.text.IEditingSupportRegistry; // packageimport
import dwtx.jface.text.IDocumentPartitionerExtension; // packageimport
import dwtx.jface.text.AbstractHoverInformationControlManager; // packageimport
import dwtx.jface.text.IEditingSupport; // packageimport
import dwtx.jface.text.IMarkSelection; // packageimport
import dwtx.jface.text.ISlaveDocumentManager; // packageimport
import dwtx.jface.text.DocumentEvent; // packageimport
import dwtx.jface.text.DocumentPartitioningChangedEvent; // packageimport
import dwtx.jface.text.ITextStore; // packageimport
import dwtx.jface.text.JFaceTextMessages; // packageimport
import dwtx.jface.text.DocumentRewriteSessionEvent; // packageimport
import dwtx.jface.text.SequentialRewriteTextStore; // packageimport
import dwtx.jface.text.DocumentRewriteSessionType; // packageimport
import dwtx.jface.text.TextAttribute; // packageimport
import dwtx.jface.text.ITextViewerExtension4; // packageimport
import dwtx.jface.text.ITypedRegion; // packageimport

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.regex;

import dwtx.core.runtime.Assert;


/**
 * Provides search and replace operations on
 * {@link dwtx.jface.text.IDocument}.
 * <p>
 * Replaces
 * {@link dwtx.jface.text.IDocument#search(int, String, bool, bool, bool)}.
 *
 * @since 3.0
 */
public class FindReplaceDocumentAdapter : CharSequence {

    /**
     * Internal type for operation codes.
     */
    private static class FindReplaceOperationCode {
    }

    // Find/replace operation codes.
    private static FindReplaceOperationCode FIND_FIRST_;
    private static FindReplaceOperationCode FIND_FIRST(){
        if( FIND_FIRST_ is null ){
            synchronized( FindReplaceDocumentAdapter.classinfo ){
                if( FIND_FIRST_ is null ){
                    FIND_FIRST_ = new FindReplaceOperationCode();
                }
            }
        }
        return FIND_FIRST_;
    }

    private static FindReplaceOperationCode FIND_NEXT_;
    private static FindReplaceOperationCode FIND_NEXT(){
        if( FIND_NEXT_ is null ){
            synchronized( FindReplaceDocumentAdapter.classinfo ){
                if( FIND_NEXT_ is null ){
                    FIND_NEXT_ = new FindReplaceOperationCode();
                }
            }
        }
        return FIND_NEXT_;
    }
    private static FindReplaceOperationCode REPLACE_;
    private static FindReplaceOperationCode REPLACE(){
        if( REPLACE_ is null ){
            synchronized( FindReplaceDocumentAdapter.classinfo ){
                if( REPLACE_ is null ){
                    REPLACE_ = new FindReplaceOperationCode();
                }
            }
        }
        return REPLACE_;
    }
    private static FindReplaceOperationCode REPLACE_FIND_NEXT_;
    private static FindReplaceOperationCode REPLACE_FIND_NEXT(){
        if( REPLACE_FIND_NEXT_ is null ){
            synchronized( FindReplaceDocumentAdapter.classinfo ){
                if( REPLACE_FIND_NEXT_ is null ){
                    REPLACE_FIND_NEXT_ = new FindReplaceOperationCode();
                }
            }
        }
        return REPLACE_FIND_NEXT_;
    }

    /**
     * Retain case mode constants.
     * @since 3.4
     */
    private static const int RC_MIXED= 0;
    private static const int RC_UPPER= 1;
    private static const int RC_LOWER= 2;
    private static const int RC_FIRSTUPPER= 3;


    /**
     * The adapted document.
     */
    private IDocument fDocument;

    /**
     * State for findReplace.
     */
    private FindReplaceOperationCode fFindReplaceState= null;

    /**
     * The matcher used in findReplace.
     */
    private Matcher fFindReplaceMatcher;

    /**
     * The match offset from the last findReplace call.
     */
    private int fFindReplaceMatchOffset;

    /**
     * Retain case mode
     */
    private int fRetainCaseMode;

    /**
     * Constructs a new find replace document adapter.
     *
     * @param document the adapted document
     */
    public this(IDocument document) {
        Assert.isNotNull(cast(Object)document);
        fDocument= document;
    }

    /**
     * Returns the location of a given string in this adapter's document based on a set of search criteria.
     *
     * @param startOffset document offset at which search starts
     * @param findString the string to find
     * @param forwardSearch the search direction
     * @param caseSensitive indicates whether lower and upper case should be distinguished
     * @param wholeWord indicates whether the findString should be limited by white spaces as
     *          defined by Character.isWhiteSpace. Must not be used in combination with <code>regExSearch</code>.
     * @param regExSearch if <code>true</code> findString represents a regular expression
     *          Must not be used in combination with <code>wholeWord</code>.
     * @return the find or replace region or <code>null</code> if there was no match
     * @throws BadLocationException if startOffset is an invalid document offset
     * @throws PatternSyntaxException if a regular expression has invalid syntax
     */
    public IRegion find(int startOffset, String findString, bool forwardSearch, bool caseSensitive, bool wholeWord, bool regExSearch)  {
        Assert.isTrue(!(regExSearch && wholeWord));

        // Adjust offset to special meaning of -1
        if (startOffset is -1 && forwardSearch)
            startOffset= 0;
        if (startOffset is -1 && !forwardSearch)
            startOffset= length() - 1;

        return findReplace(FIND_FIRST, startOffset, findString, null, forwardSearch, caseSensitive, wholeWord, regExSearch);
    }

    /**
     * Stateful findReplace executes a FIND, REPLACE, REPLACE_FIND or FIND_FIRST operation.
     * In case of REPLACE and REPLACE_FIND it sends a <code>DocumentEvent</code> to all
     * registered <code>IDocumentListener</code>.
     *
     * @param startOffset document offset at which search starts
     *          this value is only used in the FIND_FIRST operation and otherwise ignored
     * @param findString the string to find
     *          this value is only used in the FIND_FIRST operation and otherwise ignored
     * @param replaceText the string to replace the current match
     *          this value is only used in the REPLACE and REPLACE_FIND operations and otherwise ignored
     * @param forwardSearch the search direction
     * @param caseSensitive indicates whether lower and upper case should be distinguished
     * @param wholeWord indicates whether the findString should be limited by white spaces as
     *          defined by Character.isWhiteSpace. Must not be used in combination with <code>regExSearch</code>.
     * @param regExSearch if <code>true</code> this operation represents a regular expression
     *          Must not be used in combination with <code>wholeWord</code>.
     * @param operationCode specifies what kind of operation is executed
     * @return the find or replace region or <code>null</code> if there was no match
     * @throws BadLocationException if startOffset is an invalid document offset
     * @throws IllegalStateException if a REPLACE or REPLACE_FIND operation is not preceded by a successful FIND operation
     * @throws PatternSyntaxException if a regular expression has invalid syntax
     */
    private IRegion findReplace(FindReplaceOperationCode operationCode, int startOffset, String findString, String replaceText, bool forwardSearch, bool caseSensitive, bool wholeWord, bool regExSearch)  {

        // Validate option combinations
        Assert.isTrue(!(regExSearch && wholeWord));

        // Validate state
        if ((operationCode is REPLACE || operationCode is REPLACE_FIND_NEXT) && (fFindReplaceState !is FIND_FIRST && fFindReplaceState !is FIND_NEXT))
            throw new IllegalStateException("illegal findReplace state: cannot replace without preceding find"); //$NON-NLS-1$

        if (operationCode is FIND_FIRST) {
            // Reset

            if (findString is null || findString.length is 0)
                return null;

            // Validate start offset
            if (startOffset < 0 || startOffset >= length())
                throw new BadLocationException();

            int patternFlags= 0;

            if (regExSearch) {
                patternFlags |= Pattern.MULTILINE;
                findString= substituteLinebreak(findString);
            }

            if (!caseSensitive)
                patternFlags |= Pattern.CASE_INSENSITIVE | Pattern.UNICODE_CASE;

            if (wholeWord)
                findString= "\\b" ~ findString ~ "\\b"; //$NON-NLS-1$ //$NON-NLS-2$

            if (!regExSearch && !wholeWord)
                findString= asRegPattern(findString);

            fFindReplaceMatchOffset= startOffset;
            if (fFindReplaceMatcher !is null && fFindReplaceMatcher.pattern().pattern().equals(findString) && fFindReplaceMatcher.pattern().flags() is patternFlags) {
                /*
                 * Commented out for optimization:
                 * The call is not needed since FIND_FIRST uses find(int) which resets the matcher
                 */
                // fFindReplaceMatcher.reset();
            } else {
                Pattern pattern= Pattern.compile(findString, patternFlags);
                fFindReplaceMatcher= pattern.matcher(this);
            }
        }

        // Set state
        fFindReplaceState= operationCode;

        if (operationCode is REPLACE || operationCode is REPLACE_FIND_NEXT) {
            if (regExSearch) {
                Pattern pattern= fFindReplaceMatcher.pattern();
                String prevMatch= fFindReplaceMatcher.group();
                try {
                    replaceText= interpretReplaceEscapes(replaceText, prevMatch);
                    Matcher replaceTextMatcher= pattern.matcher(prevMatch);
                    replaceText= replaceTextMatcher.replaceFirst(replaceText);
                } catch (IndexOutOfBoundsException ex) {
                    throw new PatternSyntaxException(ex.msg/+getLocalizedMessage()+/, replaceText, -1);
                }
            }

            int offset= fFindReplaceMatcher.start();
            int length= fFindReplaceMatcher.group().length;

            if (cast(IRepairableDocumentExtension)fDocument
                    && (cast(IRepairableDocumentExtension)fDocument).isLineInformationRepairNeeded(offset, length, replaceText)) {
                String message= TextMessages.getString("FindReplaceDocumentAdapter.incompatibleLineDelimiter"); //$NON-NLS-1$
                throw new PatternSyntaxException(message, replaceText, offset);
            }

            fDocument.replace(offset, length, replaceText);

            if (operationCode is REPLACE) {
                return new Region(offset, replaceText.length);
            }
        }

        if (operationCode !is REPLACE) {
            if (forwardSearch) {

                bool found= false;
                if (operationCode is FIND_FIRST)
                    found= fFindReplaceMatcher.find(startOffset);
                else
                    found= fFindReplaceMatcher.find();

                if (operationCode is REPLACE_FIND_NEXT)
                    fFindReplaceState= FIND_NEXT;

                if (found && fFindReplaceMatcher.group().length > 0)
                    return new Region(fFindReplaceMatcher.start(), fFindReplaceMatcher.group().length);
                return null;
            }

            // backward search
            bool found= fFindReplaceMatcher.find(0);
            int index= -1;
            int length= -1;
            while (found && fFindReplaceMatcher.start() + fFindReplaceMatcher.group().length <= fFindReplaceMatchOffset + 1) {
                index= fFindReplaceMatcher.start();
                length= fFindReplaceMatcher.group().length;
                found= fFindReplaceMatcher.find(index + 1);
            }
            fFindReplaceMatchOffset= index;
            if (index > -1) {
                // must set matcher to correct position
                fFindReplaceMatcher.find(index);
                return new Region(index, length);
            }
            return null;
        }

        return null;
    }

    /**
     * Substitutes \R in a regex find pattern with (?>\r\n?|\n)
     *
     * @param findString the original find pattern
     * @return the transformed find pattern
     * @throws PatternSyntaxException if \R is added at an illegal position (e.g. in a character set)
     * @since 3.4
     */
    private String substituteLinebreak(String findString)  {
        int length= findString.length;
        StringBuffer buf= new StringBuffer(length);

        int inCharGroup= 0;
        int inBraces= 0;
        bool inQuote= false;
        for (int i= 0; i < length; i++) {
            char ch= .charAt(findString, i);
            switch (ch) {
                case '[':
                    buf.append(ch);
                    if (! inQuote)
                        inCharGroup++;
                    break;

                case ']':
                    buf.append(ch);
                    if (! inQuote)
                        inCharGroup--;
                    break;

                case '{':
                    buf.append(ch);
                    if (! inQuote && inCharGroup is 0)
                        inBraces++;
                    break;

                case '}':
                    buf.append(ch);
                    if (! inQuote && inCharGroup is 0)
                        inBraces--;
                    break;

                case '\\':
                    if (i + 1 < length) {
                        char ch1= .charAt(findString, i + 1);
                        if (inQuote) {
                            if (ch1 is 'E')
                                inQuote= false;
                            buf.append(ch).append(ch1);
                            i++;

                        } else if (ch1 is 'R') {
                            if (inCharGroup > 0 || inBraces > 0) {
                                String msg= TextMessages.getString("FindReplaceDocumentAdapter.illegalLinebreak"); //$NON-NLS-1$
                                throw new PatternSyntaxException(msg, findString, i);
                            }
                            buf.append("(?>\\r\\n?|\\n)"); //$NON-NLS-1$
                            i++;

                        } else {
                            if (ch1 is 'Q') {
                                inQuote= true;
                            }
                            buf.append(ch).append(ch1);
                            i++;
                        }
                    } else {
                        buf.append(ch);
                    }
                    break;

                default:
                    buf.append(ch);
                    break;
            }

        }
        return buf.toString();
    }

    /**
     * Interprets current Retain Case mode (all upper-case,all lower-case,capitalized or mixed)
     * and appends the character <code>ch</code> to <code>buf</code> after processing.
     *
     * @param buf the output buffer
     * @param ch the character to process
     * @since 3.4
     */
    private void interpretRetainCase(StringBuffer buf, dchar ch) {
        if (fRetainCaseMode is RC_UPPER)
            buf.append(dcharToString(Character.toUpperCase(ch)));
        else if (fRetainCaseMode is RC_LOWER)
            buf.append(dcharToString(Character.toLowerCase(ch)));
        else if (fRetainCaseMode is RC_FIRSTUPPER) {
            buf.append(dcharToString(Character.toUpperCase(ch)));
            fRetainCaseMode= RC_MIXED;
        } else
            buf.append(dcharToString(ch));
    }

    /**
     * Interprets escaped characters in the given replace pattern.
     *
     * @param replaceText the replace pattern
     * @param foundText the found pattern to be replaced
     * @return a replace pattern with escaped characters substituted by the respective characters
     * @since 3.4
     */
    private String interpretReplaceEscapes(String replaceText, String foundText) {
        int length= replaceText.length;
        bool inEscape= false;
        StringBuffer buf= new StringBuffer(length);

        /* every string we did not check looks mixed at first
         * so initialize retain case mode with RC_MIXED
         */
        fRetainCaseMode= RC_MIXED;

        for (int i= 0; i < length; i++) {
            char ch= .charAt(replaceText, i);
            if (inEscape) {
                i= interpretReplaceEscape(ch, i, buf, replaceText, foundText);
                inEscape= false;

            } else if (ch is '\\') {
                inEscape= true;

            } else if (ch is '$') {
                buf.append(ch);

                /*
                 * Feature in java.util.regex.Matcher#replaceFirst(String):
                 * $00, $000, etc. are interpreted as $0 and
                 * $01, $001, etc. are interpreted as $1, etc. .
                 * If we support \0 as replacement pattern for capturing group 0,
                 * it would not be possible any more to write a replacement pattern
                 * that appends 0 to a capturing group (like $0\0).
                 * The fix is to interpret \00 and $00 as $0\0, and
                 * \01 and $01 as $0\1, etc.
                 */
                if (i + 2 < length) {
                    char ch1= .charAt(replaceText, i + 1);
                    char ch2= .charAt(replaceText, i + 2);
                    if (ch1 is '0' && '0' <= ch2 && ch2 <= '9') {
                        buf.append("0\\"); //$NON-NLS-1$
                        i++; // consume the 0
                    }
                }
            } else {
                interpretRetainCase(buf, ch);
            }
        }

        if (inEscape) {
            // '\' as last character is invalid, but we still add it to get an error message
            buf.append('\\');
        }
        return buf.toString();
    }

    /**
     * Interprets the escaped character <code>ch</code> at offset <code>i</code>
     * of the <code>replaceText</code> and appends the interpretation to <code>buf</code>.
     *
     * @param ch the escaped character
     * @param i the offset
     * @param buf the output buffer
     * @param replaceText the original replace pattern
     * @param foundText the found pattern to be replaced
     * @return the new offset
     * @since 3.4
     */
    private int interpretReplaceEscape(char ch, int i, StringBuffer buf, String replaceText, String foundText) {
        int length= replaceText.length;
        switch (ch) {
            case 'r':
                buf.append('\r');
                break;
            case 'n':
                buf.append('\n');
                break;
            case 't':
                buf.append('\t');
                break;
            case 'f':
                buf.append('\f');
                break;
            case 'a':
                buf.append("\u0007"c);
                break;
            case 'e':
                buf.append("\u001B"c);
                break;
            case 'R': //see http://www.unicode.org/unicode/reports/tr18/#Line_Boundaries
                buf.append(TextUtilities.getDefaultLineDelimiter(fDocument));
                break;
            /*
             * \0 for octal is not supported in replace string, since it
             * would conflict with capturing group \0, etc.
             */
            case '0':
                buf.append('$').append(ch);
                /*
                 * See explanation in "Feature in java.util.regex.Matcher#replaceFirst(String)"
                 * in interpretReplaceEscape(String) above.
                 */
                if (i + 1 < length) {
                    char ch1= .charAt(replaceText, i + 1);
                    if ('0' <= ch1 && ch1 <= '9') {
                        buf.append('\\');
                    }
                }
                break;

            case '1':
            case '2':
            case '3':
            case '4':
            case '5':
            case '6':
            case '7':
            case '8':
            case '9':
                buf.append('$').append(ch);
                break;

            case 'c':
                if (i + 1 < length) {
                    char ch1= .charAt(replaceText, i + 1);
                    interpretRetainCase(buf, cast(wchar)(ch1 ^ 64));
                    i++;
                } else {
                    String msg= TextMessages.getFormattedString("FindReplaceDocumentAdapter.illegalControlEscape", stringcast("\\c")); //$NON-NLS-1$ //$NON-NLS-2$
                    throw new PatternSyntaxException(msg, replaceText, i);
                }
                break;

            case 'x':
                if (i + 2 < length) {
                    int parsedInt;
                    try {
                        parsedInt= Integer.parseInt(replaceText.substring(i + 1, i + 3), 16);
                        if (parsedInt < 0)
                            throw new NumberFormatException("");
                    } catch (NumberFormatException e) {
                        String msg= TextMessages.getFormattedString("FindReplaceDocumentAdapter.illegalHexEscape", stringcast(replaceText.substring(i - 1, i + 3))); //$NON-NLS-1$
                        throw new PatternSyntaxException(msg, replaceText, i);
                    }
                    interpretRetainCase(buf, cast(wchar) parsedInt);
                    i+= 2;
                } else {
                    String msg= TextMessages.getFormattedString("FindReplaceDocumentAdapter.illegalHexEscape", stringcast(replaceText.substring(i - 1, length))); //$NON-NLS-1$
                    throw new PatternSyntaxException(msg, replaceText, i);
                }
                break;

            case 'u':
                if (i + 4 < length) {
                    int parsedInt;
                    try {
                        parsedInt= Integer.parseInt(replaceText.substring(i + 1, i + 5), 16);
                        if (parsedInt < 0)
                            throw new NumberFormatException("");
                    } catch (NumberFormatException e) {
                        String msg= TextMessages.getFormattedString("FindReplaceDocumentAdapter.illegalUnicodeEscape", stringcast(replaceText.substring(i - 1, i + 5))); //$NON-NLS-1$
                        throw new PatternSyntaxException(msg, replaceText, i);
                    }
                    interpretRetainCase(buf, cast(wchar) parsedInt);
                    i+= 4;
                } else {
                    String msg= TextMessages.getFormattedString("FindReplaceDocumentAdapter.illegalUnicodeEscape", stringcast(replaceText.substring(i - 1, length))); //$NON-NLS-1$
                    throw new PatternSyntaxException(msg, replaceText, i);
                }
                break;

            case 'C':
                if(foundText.toUpperCase().equals(foundText)) // is whole match upper-case?
                    fRetainCaseMode= RC_UPPER;
                else if (foundText.toLowerCase().equals(foundText)) // is whole match lower-case?
                    fRetainCaseMode= RC_LOWER;
                else if(Character.isUpperCase(.charAt(foundText,0))) // is first character upper-case?
                    fRetainCaseMode= RC_FIRSTUPPER;
                else
                    fRetainCaseMode= RC_MIXED;
                break;

            default:
                // unknown escape k: append uninterpreted \k
                buf.append('\\').append(ch);
                break;
        }
        return i;
    }

    /**
     * Converts a non-regex string to a pattern
     * that can be used with the regex search engine.
     *
     * @param string the non-regex pattern
     * @return the string converted to a regex pattern
     */
    private String asRegPattern(String string) {
        StringBuffer out_= new StringBuffer(string.length);
        bool quoting= false;

        for (int i= 0, length= string.length; i < length; i++) {
            char ch= .charAt(string, i);
            if (ch is '\\') {
                if (quoting) {
                    out_.append("\\E"); //$NON-NLS-1$
                    quoting= false;
                }
                out_.append("\\\\"); //$NON-NLS-1$
                continue;
            }
            if (!quoting) {
                out_.append("\\Q"); //$NON-NLS-1$
                quoting= true;
            }
            out_.append(ch);
        }
        if (quoting)
            out_.append("\\E"); //$NON-NLS-1$

        return out_.toString();
    }

    /**
     * Substitutes the previous match with the given text.
     * Sends a <code>DocumentEvent</code> to all registered <code>IDocumentListener</code>.
     *
     * @param text the substitution text
     * @param regExReplace if <code>true</code> <code>text</code> represents a regular expression
     * @return the replace region or <code>null</code> if there was no match
     * @throws BadLocationException if startOffset is an invalid document offset
     * @throws IllegalStateException if a REPLACE or REPLACE_FIND operation is not preceded by a successful FIND operation
     * @throws PatternSyntaxException if a regular expression has invalid syntax
     *
     * @see DocumentEvent
     * @see IDocumentListener
     */
    public IRegion replace(String text, bool regExReplace)  {
        return findReplace(REPLACE, -1, null, text, false, false, false, regExReplace);
    }

    // ---------- CharSequence implementation ----------

    /*
     * @see java.lang.CharSequence#length()
     */
    public int length() {
        return fDocument.getLength();
    }

    /*
     * @see java.lang.CharSequence#charAt(int)
     */
    public override char charAt(int index) {
        try {
            return fDocument.getChar(index);
        } catch (BadLocationException e) {
            throw new IndexOutOfBoundsException();
        }
    }

    /*
     * @see java.lang.CharSequence#subSequence(int, int)
     */
    public CharSequence subSequence(int start, int end) {
        try {
            return new StringCharSequence(fDocument.get(start, end - start));
        } catch (BadLocationException e) {
            throw new IndexOutOfBoundsException();
        }
    }

    /*
     * @see java.lang.Object#toString()
     */
    public override String toString() {
        return fDocument.get();
    }
}
