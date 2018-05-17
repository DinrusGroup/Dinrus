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
module dwtx.jface.internal.text.link.contentassist.LineBreakingReader;

import dwtx.jface.internal.text.link.contentassist.IProposalListener; // packageimport
import dwtx.jface.internal.text.link.contentassist.CompletionProposalPopup2; // packageimport
import dwtx.jface.internal.text.link.contentassist.ContextInformationPopup2; // packageimport
import dwtx.jface.internal.text.link.contentassist.ContentAssistMessages; // packageimport
import dwtx.jface.internal.text.link.contentassist.Helper2; // packageimport
import dwtx.jface.internal.text.link.contentassist.PopupCloser2; // packageimport
import dwtx.jface.internal.text.link.contentassist.IContentAssistListener2; // packageimport
import dwtx.jface.internal.text.link.contentassist.ContentAssistant2; // packageimport
import dwtx.jface.internal.text.link.contentassist.AdditionalInfoController2; // packageimport


import dwt.dwthelper.utils;
import dwtx.dwtxhelper.BufferedReader;
import dwtx.dwtxhelper.mangoicu.UBreakIterator;

import dwt.graphics.GC;

/*
 * Not a real reader. Could change if requested
 */
public class LineBreakingReader {

    private BufferedReader fReader;
    private GC fGC;
    private int fMaxWidth;

    private String fLine;
    private int fOffset;

    private UBreakIterator fLineBreakIterator;
    private bool fBreakWords;

    /**
     * Creates a reader that breaks an input text to fit in a given width.
     *
     * @param reader Reader of the input text
     * @param gc The graphic context that defines the currently used font sizes
     * @param maxLineWidth The max width (pixels) where the text has to fit in
     */
    public this(Reader reader, GC gc, int maxLineWidth) {
        fReader= new BufferedReader(reader);
        fGC= gc;
        fMaxWidth= maxLineWidth;
        fOffset= 0;
        fLine= null;
        fLineBreakIterator= UBreakIterator.openLineIterator( ULocale.Default);
        fBreakWords= true;
    }

    public bool isFormattedLine() {
        return fLine !is null;
    }

    /**
     * Reads the next line. The lengths of the line will not exceed the given maximum
     * width.
     *
     * @return the next line
     * @throws IOException
     */
    public String readLine()  {
        if (fLine is null) {
            String line= fReader.readLine();
            if (line is null)
                return null;

            int lineLen= fGC.textExtent(line).x;
            if (lineLen < fMaxWidth) {
                return line;
            }
            fLine= line;
            fLineBreakIterator.setText(line);
            fOffset= 0;
        }
        int breakOffset= findNextBreakOffset(fOffset);
        String res;
        if (breakOffset !is UBreakIterator.DONE) {
            res= fLine.substring(fOffset, breakOffset);
            fOffset= findWordBegin(breakOffset);
            if (fOffset is fLine.length()) {
                fLine= null;
            }
        } else {
            res= fLine.substring(fOffset);
            fLine= null;
        }
        return res;
    }

    private int findNextBreakOffset(int currOffset) {
        int currWidth= 0;
        int nextOffset= fLineBreakIterator.following(currOffset);
        while (nextOffset !is UBreakIterator.DONE) {
            String word= fLine.substring(currOffset, nextOffset);
            int wordWidth= fGC.textExtent(word).x;
            int nextWidth= wordWidth + currWidth;
            if (nextWidth > fMaxWidth) {
                if (currWidth > 0)
                    return currOffset;

                if (!fBreakWords)
                    return nextOffset;

                // need to fit into fMaxWidth
                int length= word.length();
                while (length >= 0) {
                    length--;
                    word= word.substring(0, length);
                    wordWidth= fGC.textExtent(word).x;
                    if (wordWidth + currWidth < fMaxWidth)
                        return currOffset + length;
                }
                return nextOffset;
            }
            currWidth= nextWidth;
            currOffset= nextOffset;
            nextOffset= fLineBreakIterator.next();
        }
        return nextOffset;
    }

    private int findWordBegin(int idx) {
        while (idx < fLine.length() && Character.isWhitespace(fLine.charAt(idx))) {
            idx++;
        }
        return idx;
    }
}
