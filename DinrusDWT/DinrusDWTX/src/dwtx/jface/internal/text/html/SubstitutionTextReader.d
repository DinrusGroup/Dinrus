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
module dwtx.jface.internal.text.html.SubstitutionTextReader;

import dwtx.jface.internal.text.html.HTML2TextReader; // packageimport
import dwtx.jface.internal.text.html.HTMLPrinter; // packageimport
import dwtx.jface.internal.text.html.BrowserInformationControl; // packageimport
import dwtx.jface.internal.text.html.HTMLTextPresenter; // packageimport
import dwtx.jface.internal.text.html.BrowserInput; // packageimport
import dwtx.jface.internal.text.html.SingleCharReader; // packageimport
import dwtx.jface.internal.text.html.BrowserInformationControlInput; // packageimport
import dwtx.jface.internal.text.html.HTMLMessages; // packageimport

import dwt.dwthelper.utils;
import tango.core.Exception;

/**
 * Reads the text contents from a reader and computes for each character
 * a potential substitution. The substitution may eat more characters than
 * only the one passed into the computation routine.
 * <p>
 * Moved into this package from <code>dwtx.jface.internal.text.revisions</code>.</p>
 */
public abstract class SubstitutionTextReader : SingleCharReader {

    private static String LINE_DELIM_;
    protected static String LINE_DELIM() {
        if( LINE_DELIM_ is null ){
            LINE_DELIM_ = System.getProperty("line.separator", "\n"); //$NON-NLS-1$ //$NON-NLS-2$
        }
        return LINE_DELIM_;
    }

    private Reader fReader;
    protected bool fWasWhiteSpace;
    private int fCharAfterWhiteSpace;

    /**
     * Tells whether white space characters are skipped.
     */
    private bool fSkipWhiteSpace= true;

    private bool fReadFromBuffer;
    private StringBuffer fBuffer;
    private int fIndex;


    protected this(Reader reader) {
        fReader= reader;
        fBuffer= new StringBuffer();
        fIndex= 0;
        fReadFromBuffer= false;
        fCharAfterWhiteSpace= -1;
        fWasWhiteSpace= true;
    }

    /**
     * Computes the substitution for the given character and if necessary
     * subsequent characters. Implementation should use <code>nextChar</code>
     * to read subsequent characters.
     *
     * @param c the character to be substituted
     * @return the substitution for <code>c</code>
     * @throws IOException in case computing the substitution fails
     */
    protected abstract String computeSubstitution(int c) ;

    /**
     * Returns the internal reader.
     *
     * @return the internal reader
     */
    protected Reader getReader() {
        return fReader;
    }

    /**
     * Returns the next character.
     * @return the next character
     * @throws IOException in case reading the character fails
     */
    protected int nextChar()  {
        fReadFromBuffer= (fBuffer.length() > 0);
        if (fReadFromBuffer) {
            char ch= fBuffer.slice().charAt(fIndex++);
            if (fIndex >= fBuffer.length()) {
                fBuffer.truncate(0);
                fIndex= 0;
            }
            return ch;
        }

        int ch= fCharAfterWhiteSpace;
        if (ch is -1) {
            ch= fReader.read();
        }
        if (fSkipWhiteSpace && Character.isWhitespace(cast(char)ch)) {
            do {
                ch= fReader.read();
            } while (Character.isWhitespace(cast(char)ch));
            if (ch !is -1) {
                fCharAfterWhiteSpace= ch;
                return ' ';
            }
        } else {
            fCharAfterWhiteSpace= -1;
        }
        return ch;
    }

    /// DWT
    protected int nextDChar()  {
        char[4] buf = void;
        int ch1 = nextChar();
        if( ch1 is -1 ) return -1;
        buf[0] = cast(char)ch1;
        if(( ch1 & 0x80 ) is 0x00 ){
            return ch1;
        }
        else if(( ch1 & 0xE0 ) is 0xC0 ){
            int ch2 = nextChar();
            if( ch2 is -1 ) throw new UnicodeException(__FILE__,__LINE__);
            buf[1] = cast(char)ch2;
        }
        else if(( ch1 & 0xF0 ) is 0xE0 ){
            int ch2 = nextChar();
            if( ch1 is -1 ) throw new UnicodeException(__FILE__,__LINE__);
            buf[1] = cast(char)ch2;
            int ch3 = nextChar();
            if( ch3 is -1 ) throw new UnicodeException(__FILE__,__LINE__);
            buf[2] = cast(char)ch3;
        }
        else if(( ch1 & 0xF8 ) is 0xF0 ){
            int ch2 = nextChar();
            if( ch1 is -1 ) throw new UnicodeException(__FILE__,__LINE__);
            buf[1] = cast(char)ch2;
            int ch3 = nextChar();
            if( ch3 is -1 ) throw new UnicodeException(__FILE__,__LINE__);
            buf[2] = cast(char)ch3;
            int ch4 = nextChar();
            if( ch4 is -1 ) throw new UnicodeException(__FILE__,__LINE__);
            buf[3] = cast(char)ch4;
        }
        else {
            throw new UnicodeException(__FILE__,__LINE__);
        }
        uint ate;
        return tango.text.convert.Utf.decode( buf, ate );
    }

    /**
     * @see Reader#read()
     */
    public int read()  {
        int c;
        do {

            c= nextChar();
            while (!fReadFromBuffer) {
                String s= computeSubstitution(c);
                if (s is null)
                    break;
                if (s.length() > 0){
                    fBuffer.select(0, 0);
                    fBuffer.replace(s);
                }
                c= nextChar();
            }

        } while (fSkipWhiteSpace && fWasWhiteSpace && (c is ' '));
        fWasWhiteSpace= (c is ' ' || c is '\r' || c is '\n');
        return c;
    }

    /**
     * @see Reader#ready()
     */
    public bool ready()  {
        return fReader.ready();
    }

    /**
     * @see Reader#close()
     */
    public void close()  {
        fReader.close();
    }

    /**
     * @see Reader#reset()
     */
    public void reset()  {
        fReader.reset();
        fWasWhiteSpace= true;
        fCharAfterWhiteSpace= -1;
        fBuffer.truncate(0);
        fIndex= 0;
    }

    protected final void setSkipWhitespace(bool state) {
        fSkipWhiteSpace= state;
    }

    protected final bool isSkippingWhitespace() {
        return fSkipWhiteSpace;
    }
}
