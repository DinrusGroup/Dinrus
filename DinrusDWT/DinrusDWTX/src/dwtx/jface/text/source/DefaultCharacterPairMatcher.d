/*******************************************************************************
 * Copyright (c) 2006, 2007 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Christian Plesner Hansen (plesner@quenta.org) - initial API and implementation
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/
module dwtx.jface.text.source.DefaultCharacterPairMatcher;

import dwtx.jface.text.source.ISharedTextColors; // packageimport
import dwtx.jface.text.source.ILineRange; // packageimport
import dwtx.jface.text.source.IAnnotationPresentation; // packageimport
import dwtx.jface.text.source.IVerticalRulerInfoExtension; // packageimport
import dwtx.jface.text.source.ICharacterPairMatcher; // packageimport
import dwtx.jface.text.source.TextInvocationContext; // packageimport
import dwtx.jface.text.source.LineChangeHover; // packageimport
import dwtx.jface.text.source.IChangeRulerColumn; // packageimport
import dwtx.jface.text.source.IAnnotationMap; // packageimport
import dwtx.jface.text.source.IAnnotationModelListenerExtension; // packageimport
import dwtx.jface.text.source.ISourceViewerExtension2; // packageimport
import dwtx.jface.text.source.IAnnotationHover; // packageimport
import dwtx.jface.text.source.ContentAssistantFacade; // packageimport
import dwtx.jface.text.source.IAnnotationAccess; // packageimport
import dwtx.jface.text.source.IVerticalRulerExtension; // packageimport
import dwtx.jface.text.source.IVerticalRulerColumn; // packageimport
import dwtx.jface.text.source.LineNumberRulerColumn; // packageimport
import dwtx.jface.text.source.MatchingCharacterPainter; // packageimport
import dwtx.jface.text.source.IAnnotationModelExtension; // packageimport
import dwtx.jface.text.source.ILineDifferExtension; // packageimport
import dwtx.jface.text.source.LineNumberChangeRulerColumn; // packageimport
import dwtx.jface.text.source.IAnnotationAccessExtension; // packageimport
import dwtx.jface.text.source.ISourceViewer; // packageimport
import dwtx.jface.text.source.AnnotationModel; // packageimport
import dwtx.jface.text.source.ILineDifferExtension2; // packageimport
import dwtx.jface.text.source.IAnnotationModelListener; // packageimport
import dwtx.jface.text.source.IVerticalRuler; // packageimport
import dwtx.jface.text.source.DefaultAnnotationHover; // packageimport
import dwtx.jface.text.source.SourceViewer; // packageimport
import dwtx.jface.text.source.SourceViewerConfiguration; // packageimport
import dwtx.jface.text.source.AnnotationBarHoverManager; // packageimport
import dwtx.jface.text.source.CompositeRuler; // packageimport
import dwtx.jface.text.source.ImageUtilities; // packageimport
import dwtx.jface.text.source.VisualAnnotationModel; // packageimport
import dwtx.jface.text.source.IAnnotationModel; // packageimport
import dwtx.jface.text.source.ISourceViewerExtension3; // packageimport
import dwtx.jface.text.source.ILineDiffInfo; // packageimport
import dwtx.jface.text.source.VerticalRulerEvent; // packageimport
import dwtx.jface.text.source.ChangeRulerColumn; // packageimport
import dwtx.jface.text.source.ILineDiffer; // packageimport
import dwtx.jface.text.source.AnnotationModelEvent; // packageimport
import dwtx.jface.text.source.AnnotationColumn; // packageimport
import dwtx.jface.text.source.AnnotationRulerColumn; // packageimport
import dwtx.jface.text.source.IAnnotationHoverExtension; // packageimport
import dwtx.jface.text.source.AbstractRulerColumn; // packageimport
import dwtx.jface.text.source.ISourceViewerExtension; // packageimport
import dwtx.jface.text.source.AnnotationMap; // packageimport
import dwtx.jface.text.source.IVerticalRulerInfo; // packageimport
import dwtx.jface.text.source.IAnnotationModelExtension2; // packageimport
import dwtx.jface.text.source.LineRange; // packageimport
import dwtx.jface.text.source.IAnnotationAccessExtension2; // packageimport
import dwtx.jface.text.source.VerticalRuler; // packageimport
import dwtx.jface.text.source.JFaceTextMessages; // packageimport
import dwtx.jface.text.source.IOverviewRuler; // packageimport
import dwtx.jface.text.source.Annotation; // packageimport
import dwtx.jface.text.source.IVerticalRulerListener; // packageimport
import dwtx.jface.text.source.ISourceViewerExtension4; // packageimport
import dwtx.jface.text.source.AnnotationPainter; // packageimport
import dwtx.jface.text.source.IAnnotationHoverExtension2; // packageimport
import dwtx.jface.text.source.OverviewRuler; // packageimport
import dwtx.jface.text.source.OverviewRulerHoverManager; // packageimport


import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;


import dwtx.core.runtime.Assert;
import dwtx.jface.text.BadLocationException;
import dwtx.jface.text.IDocument;
import dwtx.jface.text.IDocumentExtension3;
import dwtx.jface.text.IRegion;
import dwtx.jface.text.ITypedRegion;
import dwtx.jface.text.Region;
import dwtx.jface.text.TextUtilities;

/**
 * A character pair matcher that matches a specified set of character
 * pairs against each other.  Only characters that occur in the same
 * partitioning are matched.
 *
 * @since 3.3
 */
public class DefaultCharacterPairMatcher : ICharacterPairMatcher {

    private int fAnchor= -1;
    private const CharPairs fPairs;
    private const String fPartitioning;

    /**
     * Creates a new character pair matcher that matches the specified
     * characters within the specified partitioning.  The specified
     * list of characters must have the form
     * <blockquote>{ <i>start</i>, <i>end</i>, <i>start</i>, <i>end</i>, ..., <i>start</i>, <i>end</i> }</blockquote>
     * For instance:
     * <pre>
     * char[] chars = new char[] {'(', ')', '{', '}', '[', ']'};
     * new SimpleCharacterPairMatcher(chars, ...);
     * </pre>
     * 
     * @param chars a list of characters
     * @param partitioning the partitioning to match within
     */
    public this(char[] chars, String partitioning) {
        Assert.isLegal(chars.length % 2 is 0);
        Assert.isNotNull(partitioning);
        fPairs= new CharPairs(chars);
        fPartitioning= partitioning;
    }
    
    /**
     * Creates a new character pair matcher that matches characters
     * within the default partitioning.  The specified list of
     * characters must have the form
     * <blockquote>{ <i>start</i>, <i>end</i>, <i>start</i>, <i>end</i>, ..., <i>start</i>, <i>end</i> }</blockquote>
     * For instance:
     * <pre>
     * char[] chars = new char[] {'(', ')', '{', '}', '[', ']'};
     * new SimpleCharacterPairMatcher(chars);
     * </pre>
     * 
     * @param chars a list of characters
     */
    public this(char[] chars) {
        this(chars, IDocumentExtension3.DEFAULT_PARTITIONING);
    }
    
    /* @see ICharacterPairMatcher#match(IDocument, int) */
    public IRegion match(IDocument doc, int offset) {
        if (doc is null || offset < 0 || offset > doc.getLength()) return null;
        try {
            return performMatch(doc, offset);
        } catch (BadLocationException ble) {
            return null;
        }
    }
        
    /*
     * Performs the actual work of matching for #match(IDocument, int).
     */
    private IRegion performMatch(IDocument doc, int caretOffset)  {
        final int charOffset= caretOffset - 1;
        final char prevChar= doc.getChar(Math.max(charOffset, 0));
        if (!fPairs.contains(prevChar)) return null;
        final bool isForward= fPairs.isStartCharacter(prevChar);
        fAnchor= isForward ? ICharacterPairMatcher.LEFT : ICharacterPairMatcher.RIGHT;
        final int searchStartPosition= isForward ? caretOffset : caretOffset - 2;
        final int adjustedOffset= isForward ? charOffset : caretOffset;
        final String partition= TextUtilities.getContentType(doc, fPartitioning, charOffset, false);
        final DocumentPartitionAccessor partDoc= new DocumentPartitionAccessor(doc, fPartitioning, partition);
        int endOffset= findMatchingPeer(partDoc, prevChar, fPairs.getMatching(prevChar),
                isForward,  isForward ? doc.getLength() : -1,
                searchStartPosition);
        if (endOffset is -1) return null;
        final int adjustedEndOffset= isForward ? endOffset + 1: endOffset;
        if (adjustedEndOffset is adjustedOffset) return null;
        return new Region(Math.min(adjustedOffset, adjustedEndOffset),
                Math.abs(adjustedEndOffset - adjustedOffset));
    }

    /**
     * Searches <code>doc</code> for the specified end character, <code>end</code>.
     * 
     * @param doc the document to search
     * @param start the opening matching character
     * @param end the end character to search for
     * @param searchForward search forwards or backwards?
     * @param boundary a boundary at which the search should stop
     * @param startPos the start offset
     * @return the index of the end character if it was found, otherwise -1
     * @throws BadLocationException
     */
    private int findMatchingPeer(DocumentPartitionAccessor doc, char start, char end, bool searchForward, int boundary, int startPos)  {
        int pos= startPos;
        while (pos !is boundary) {
            final char c= doc.getChar(pos);
            if (doc.isMatch(pos, end)) {
                return pos;
            } else if (c is start && doc.inPartition(pos)) {
                pos= findMatchingPeer(doc, start, end, searchForward, boundary,
                        doc.getNextPosition(pos, searchForward));
                if (pos is -1) return -1;
            }
            pos= doc.getNextPosition(pos, searchForward);
        }
        return -1;
    }

    /* @see ICharacterPairMatcher#getAnchor() */
    public int getAnchor() {
        return fAnchor;
    }
    
    /* @see ICharacterPairMatcher#dispose() */
    public void dispose() { }

    /* @see ICharacterPairMatcher#clear() */
    public void clear() {
        fAnchor= -1;
    }

    /**
     * Utility class that wraps a document and gives access to
     * partitioning information.  A document is tied to a particular
     * partition and, when considering whether or not a position is a
     * valid match, only considers position within its partition.
     */
    private static class DocumentPartitionAccessor {
        
        private const IDocument fDocument;
        private const String fPartitioning, fPartition;
        private ITypedRegion fCachedPartition;
        
        /**
         * Creates a new partitioned document for the specified document.
         * 
         * @param doc the document to wrap
         * @param partitioning the partitioning used
         * @param partition the partition managed by this document
         */
        public this(IDocument doc, String partitioning,
                String partition) {
            fDocument= doc;
            fPartitioning= partitioning;
            fPartition= partition;
        }
    
        /**
         * Returns the character at the specified position in this document.
         * 
         * @param pos an offset within this document
         * @return the character at the offset
         * @throws BadLocationException
         */
        public char getChar(int pos)  {
            return fDocument.getChar(pos);
        }
        
        /**
         * Returns true if the character at the specified position is a
         * valid match for the specified end character.  To be a valid
         * match, it must be in the appropriate partition and equal to the
         * end character.
         * 
         * @param pos an offset within this document
         * @param end the end character to match against
         * @return true exactly if the position represents a valid match
         * @throws BadLocationException
         */
        public bool isMatch(int pos, char end)  {
            return getChar(pos) is end && inPartition(pos);
        }
        
        /**
         * Returns true if the specified offset is within the partition
         * managed by this document.
         * 
         * @param pos an offset within this document
         * @return true if the offset is within this document's partition
         */
        public bool inPartition(int pos) {
            final ITypedRegion partition= getPartition(pos);
            return partition !is null && partition.getType().equals(fPartition);
        }
        
        /**
         * Returns the next position to query in the search.  The position
         * is not guaranteed to be in this document's partition.
         * 
         * @param pos an offset within the document
         * @param searchForward the direction of the search
         * @return the next position to query
         */
        public int getNextPosition(int pos, bool searchForward) {
            final ITypedRegion partition= getPartition(pos);
            if (partition is null) return simpleIncrement(pos, searchForward);
            if (fPartition.equals(partition.getType()))
                return simpleIncrement(pos, searchForward);
            if (searchForward) {
                int end= partition.getOffset() + partition.getLength();
                if (pos < end)
                    return end;
            } else {
                int offset= partition.getOffset();
                if (pos > offset)
                    return offset - 1;
            }
            return simpleIncrement(pos, searchForward);
        }
    
        private int simpleIncrement(int pos, bool searchForward) {
            return pos + (searchForward ? 1 : -1);
        }
        
        /**
         * Returns partition information about the region containing the
         * specified position.
         * 
         * @param pos a position within this document.
         * @return positioning information about the region containing the
         *   position
         */
        private ITypedRegion getPartition(int pos) {
            if (fCachedPartition is null || !contains(fCachedPartition, pos)) {
                Assert.isTrue(pos >= 0 && pos <= fDocument.getLength());
                try {
                    fCachedPartition= TextUtilities.getPartition(fDocument, fPartitioning, pos, false);
                } catch (BadLocationException e) {
                    fCachedPartition= null;
                }
            }
            return fCachedPartition;
        }
        
        private static bool contains(IRegion region, int pos) {
            int offset= region.getOffset();
            return offset <= pos && pos < offset + region.getLength();
        }
        
    }

    /**
     * Utility class that encapsulates access to matching character pairs.
     */
    private static class CharPairs {

        private const char[] fPairs;

        public this(char[] pairs) {
            fPairs= pairs;
        }

        /**
         * Returns true if the specified character pair occurs in one
         * of the character pairs.
         * 
         * @param c a character
         * @return true exactly if the character occurs in one of the pairs
         */
        public bool contains(char c) {
            return getAllCharacters().contains(new Character(c));
        }

        private Set/*<Character>*/ fCharsCache= null;
        /**
         * @return A set containing all characters occurring in character pairs.
         */
        private Set/*<Character>*/ getAllCharacters() {
            if (fCharsCache is null) {
                Set/*<Character>*/ set= new HashSet/*<Character>*/();
                for (int i= 0; i < fPairs.length; i++)
                    set.add(new Character(fPairs[i]));
                fCharsCache= set;
            }
            return fCharsCache;
        }

        /**
         * Returns true if the specified character opens a character pair
         * when scanning in the specified direction.
         *
         * @param c a character
         * @param searchForward the direction of the search
         * @return whether or not the character opens a character pair
         */
        public bool isOpeningCharacter(char c, bool searchForward) {
            for (int i= 0; i < fPairs.length; i += 2) {
                if (searchForward && getStartChar(i) is c) return true;
                else if (!searchForward && getEndChar(i) is c) return true;
            }
            return false;
        }

        /**
         * Returns true of the specified character is a start character.
         * 
         * @param c a character
         * @return true exactly if the character is a start character
         */
        public bool isStartCharacter(char c) {
            return this.isOpeningCharacter(c, true);
        }
    
        /**
         * Returns the matching character for the specified character.
         * 
         * @param c a character occurring in a character pair
         * @return the matching character
         */
        public char getMatching(char c) {
            for (int i= 0; i < fPairs.length; i += 2) {
                if (getStartChar(i) is c) return getEndChar(i);
                else if (getEndChar(i) is c) return getStartChar(i);
            }
            Assert.isTrue(false);
            return '\0';
        }
    
        private char getStartChar(int i) {
            return fPairs[i];
        }
    
        private char getEndChar(int i) {
            return fPairs[i + 1];
        }
    
    }

}
