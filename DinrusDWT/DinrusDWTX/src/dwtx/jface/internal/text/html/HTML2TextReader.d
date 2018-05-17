/*******************************************************************************
 * Copyright (c) 2000, 2008 IBM Corporation and others.
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
module dwtx.jface.internal.text.html.HTML2TextReader;

import dwtx.jface.internal.text.html.HTMLPrinter; // packageimport
import dwtx.jface.internal.text.html.BrowserInformationControl; // packageimport
import dwtx.jface.internal.text.html.SubstitutionTextReader; // packageimport
import dwtx.jface.internal.text.html.HTMLTextPresenter; // packageimport
import dwtx.jface.internal.text.html.BrowserInput; // packageimport
import dwtx.jface.internal.text.html.SingleCharReader; // packageimport
import dwtx.jface.internal.text.html.BrowserInformationControlInput; // packageimport
import dwtx.jface.internal.text.html.HTMLMessages; // packageimport

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.PushbackReader;
import dwtx.dwtxhelper.Collection;
static import tango.text.convert.Utf;

import dwt.DWT;
import dwt.custom.StyleRange;
import dwtx.jface.text.TextPresentation;


/**
 * Reads the text contents from a reader of HTML contents and translates
 * the tags or cut them out.
 * <p>
 * Moved into this package from <code>dwtx.jface.internal.text.revisions</code>.</p>
 */
public class HTML2TextReader : SubstitutionTextReader {

    private static const String EMPTY_STRING= ""; //$NON-NLS-1$
    private static Map fgEntityLookup_;
    private static Set fgTags_;
    private static Map fgEntityLookup(){
        if( fgEntityLookup_ is null ){
            synchronized(HTML2TextReader.classinfo ){
                if( fgEntityLookup_ is null ){
                    fgEntityLookup_= new HashMap(7);
                    fgEntityLookup_.put("lt", "<"); //$NON-NLS-1$ //$NON-NLS-2$
                    fgEntityLookup_.put("gt", ">"); //$NON-NLS-1$ //$NON-NLS-2$
                    fgEntityLookup_.put("nbsp", " "); //$NON-NLS-1$ //$NON-NLS-2$
                    fgEntityLookup_.put("amp", "&"); //$NON-NLS-1$ //$NON-NLS-2$
                    fgEntityLookup_.put("circ", "^"); //$NON-NLS-1$ //$NON-NLS-2$
                    fgEntityLookup_.put("tilde", "~"); //$NON-NLS-2$ //$NON-NLS-1$
                    fgEntityLookup_.put("quot", "\"");        //$NON-NLS-1$ //$NON-NLS-2$
                }
            }
        }
        return fgEntityLookup_;
    }
    private static Set fgTags(){
        if( fgTags_ is null ){
            synchronized(HTML2TextReader.classinfo ){
                if( fgTags_ is null ){
                    fgTags_= new HashSet();
                    fgTags_.add("b"); //$NON-NLS-1$
                    fgTags_.add("br"); //$NON-NLS-1$
                    fgTags_.add("br/"); //$NON-NLS-1$
                    fgTags_.add("div"); //$NON-NLS-1$
                    fgTags_.add("h1"); //$NON-NLS-1$
                    fgTags_.add("h2"); //$NON-NLS-1$
                    fgTags_.add("h3"); //$NON-NLS-1$
                    fgTags_.add("h4"); //$NON-NLS-1$
                    fgTags_.add("h5"); //$NON-NLS-1$
                    fgTags_.add("p"); //$NON-NLS-1$
                    fgTags_.add("dl"); //$NON-NLS-1$
                    fgTags_.add("dt"); //$NON-NLS-1$
                    fgTags_.add("dd"); //$NON-NLS-1$
                    fgTags_.add("li"); //$NON-NLS-1$
                    fgTags_.add("ul"); //$NON-NLS-1$
                    fgTags_.add("pre"); //$NON-NLS-1$
                    fgTags_.add("head"); //$NON-NLS-1$
                }
            }
        }
        return fgTags_;
    }

    private int fCounter= 0;
    private TextPresentation fTextPresentation;
    private int fBold= 0;
    private int fStartOffset= -1;
    private bool fInParagraph= false;
    private bool fIsPreformattedText= false;
    private bool fIgnore= false;
    private bool fHeaderDetected= false;

    /**
     * Transforms the HTML text from the reader to formatted text.
     *
     * @param reader the reader
     * @param presentation If not <code>null</code>, formattings will be applied to
     * the presentation.
    */
    public this(Reader reader, TextPresentation presentation) {
        super(new PushbackReader(reader));
        fTextPresentation= presentation;
    }

    public int read()  {
        int c= super.read();
        if (c !is -1)
            ++ fCounter;
        return c;
    }

    protected void startBold() {
        if (fBold is 0)
            fStartOffset= fCounter;
        ++ fBold;
    }

    protected void startPreformattedText() {
        fIsPreformattedText= true;
        setSkipWhitespace(false);
    }

    protected void stopPreformattedText() {
        fIsPreformattedText= false;
        setSkipWhitespace(true);
    }

    protected void stopBold() {
        -- fBold;
        if (fBold is 0) {
            if (fTextPresentation !is null) {
                fTextPresentation.addStyleRange(new StyleRange(fStartOffset, fCounter - fStartOffset, null, null, DWT.BOLD));
            }
            fStartOffset= -1;
        }
    }

    /*
     * @see dwtx.jdt.internal.ui.text.SubstitutionTextReader#computeSubstitution(int)
     */
    protected String computeSubstitution(int c)  {

        if (c is '<')
            return  processHTMLTag();
        else if (fIgnore)
            return EMPTY_STRING;
        else if (c is '&')
            return processEntity();
        else if (fIsPreformattedText)
            return processPreformattedText(c);

        return null;
    }

    private String html2Text(String html) {

        if (html is null || html.length() is 0)
            return EMPTY_STRING;

        html= html.toLowerCase();

        String tag= html;
        if ('/' is tag.charAt(0))
            tag= tag.substring(1);

        if (!fgTags.contains(tag))
            return EMPTY_STRING;


        if ("pre".equals(html)) { //$NON-NLS-1$
            startPreformattedText();
            return EMPTY_STRING;
        }

        if ("/pre".equals(html)) { //$NON-NLS-1$
            stopPreformattedText();
            return EMPTY_STRING;
        }

        if (fIsPreformattedText)
            return EMPTY_STRING;

        if ("b".equals(html)) { //$NON-NLS-1$
            startBold();
            return EMPTY_STRING;
        }

        if ((html.length() > 1 && html.charAt(0) is 'h' && Character.isDigit(html.charAt(1))) || "dt".equals(html)) { //$NON-NLS-1$
            startBold();
            return EMPTY_STRING;
        }

        if ("dl".equals(html)) //$NON-NLS-1$
            return LINE_DELIM;

        if ("dd".equals(html)) //$NON-NLS-1$
            return "\t"; //$NON-NLS-1$

        if ("li".equals(html)) //$NON-NLS-1$
            // FIXME: this hard-coded prefix does not work for RTL languages, see https://bugs.eclipse.org/bugs/show_bug.cgi?id=91682
            return LINE_DELIM ~ HTMLMessages.getString("HTML2TextReader.listItemPrefix"); //$NON-NLS-1$

        if ("/b".equals(html)) { //$NON-NLS-1$
            stopBold();
            return EMPTY_STRING;
        }

        if ("p".equals(html))  { //$NON-NLS-1$
            fInParagraph= true;
            return LINE_DELIM;
        }

        if ("br".equals(html) || "br/".equals(html) || "div".equals(html)) //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
            return LINE_DELIM;

        if ("/p".equals(html))  { //$NON-NLS-1$
            bool inParagraph= fInParagraph;
            fInParagraph= false;
            return inParagraph ? EMPTY_STRING : LINE_DELIM;
        }

        if ((html.startsWith("/h") && html.length() > 2 && Character.isDigit(html.charAt(2))) || "/dt".equals(html)) { //$NON-NLS-1$ //$NON-NLS-2$
            stopBold();
            return LINE_DELIM;
        }

        if ("/dd".equals(html)) //$NON-NLS-1$
            return LINE_DELIM;

        if ("head".equals(html) && !fHeaderDetected) { //$NON-NLS-1$
            fHeaderDetected= true;
            fIgnore= true;
            return EMPTY_STRING;
        }

        if ("/head".equals(html) && fHeaderDetected && fIgnore) { //$NON-NLS-1$
            fIgnore= false;
            return EMPTY_STRING;
        }

        return EMPTY_STRING;
    }

    /*
     * A '<' has been read. Process a html tag
     */
    private String processHTMLTag()  {

        StringBuffer buf= new StringBuffer();
        int ch;
        do {

            ch= nextDChar();

            while (ch !is -1 && ch !is '>') {
                buf.append(dcharToString(Character.toLowerCase(cast(dchar) ch)));
                ch= nextDChar();
                if (ch is '"'){
                    buf.append(dcharToString(Character.toLowerCase(cast(dchar) ch)));
                    ch= nextDChar();
                    while (ch !is -1 && ch !is '"'){
                        buf.append(dcharToString(Character.toLowerCase(cast(dchar) ch)));
                        ch= nextDChar();
                    }
                }
                if (ch is '<' && !isInComment(buf)) {
                    unreadDChar(ch);
                    return '<' ~ buf.toString();
                }
            }

            if (ch is -1)
                return null;

            if (!isInComment(buf) || isCommentEnd(buf)) {
                break;
            }
            // unfinished comment
            buf.append(dcharToString(cast(dchar) ch));
        } while (true);

        return html2Text(buf.toString());
    }

    private static bool isInComment(StringBuffer buf) {
        return buf.length() >= 3 && "!--".equals(buf.slice().substring(0, 3)); //$NON-NLS-1$
    }

    private static bool isCommentEnd(StringBuffer buf) {
        int tagLen= buf.length();
        return tagLen >= 5 && "--".equals(buf.slice().substring(tagLen - 2)); //$NON-NLS-1$
    }

    private String processPreformattedText(int c) {
        if  (c is '\r' || c is '\n')
            fCounter++;
        return null;
    }


    private void unreadDChar(dchar ch)  {
        char[4] buf;
        dchar[1] ibuf;
        ibuf[0] = ch;
        foreach( char c; tango.text.convert.Utf.toString( ibuf[], buf[] )){
            (cast(PushbackReader) getReader()).unread(c);
        }
    }

    protected String entity2Text(String symbol) {
        if (symbol.length() > 1 && symbol.charAt(0) is '#') {
            int ch;
            try {
                if (symbol.charAt(1) is 'x') {
                    ch= Integer.parseInt(symbol.substring(2), 16);
                } else {
                    ch= Integer.parseInt(symbol.substring(1), 10);
                }
                return dcharToString( cast(dchar)ch);
            } catch (NumberFormatException e) {
            }
        } else {
            String str= stringcast( fgEntityLookup.get(symbol));
            if (str !is null) {
                return str;
            }
        }
        return "&" ~ symbol; // not found //$NON-NLS-1$
    }

    /*
     * A '&' has been read. Process a entity
     */
    private String processEntity()  {
        StringBuffer buf= new StringBuffer();
        int ch= nextDChar();
        while (Character.isLetterOrDigit(cast(dchar)ch) || ch is '#') {
            buf.append(dcharToString(cast(dchar) ch));
            ch= nextDChar();
        }

        if (ch is ';')
            return entity2Text(buf.toString());

        buf.select(0, 0);
        buf.prepend("&");
        if (ch !is -1)
            buf.append(dcharToString(cast(dchar) ch));
        return buf.toString();
    }
}
