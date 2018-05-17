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
module dwtx.jface.internal.text.html.HTMLPrinter;

import dwtx.jface.internal.text.html.HTML2TextReader; // packageimport
import dwtx.jface.internal.text.html.BrowserInformationControl; // packageimport
import dwtx.jface.internal.text.html.SubstitutionTextReader; // packageimport
import dwtx.jface.internal.text.html.HTMLTextPresenter; // packageimport
import dwtx.jface.internal.text.html.BrowserInput; // packageimport
import dwtx.jface.internal.text.html.SingleCharReader; // packageimport
import dwtx.jface.internal.text.html.BrowserInformationControlInput; // packageimport
import dwtx.jface.internal.text.html.HTMLMessages; // packageimport


import dwt.dwthelper.utils;
import dwtx.dwtxhelper.URL;

import dwt.DWT;
import dwt.DWTError;
import dwt.graphics.FontData;
import dwt.graphics.RGB;
import dwt.widgets.Display;


/**
 * Provides a set of convenience methods for creating HTML pages.
 * <p>
 * Moved into this package from <code>dwtx.jface.internal.text.revisions</code>.</p>
 */
public class HTMLPrinter {

    private static RGB BG_COLOR_RGB_;
    private static RGB FG_COLOR_RGB_;

    private static RGB BG_COLOR_RGB(){
        COLOR_RGB_init();
        return BG_COLOR_RGB_;
    }
    private static RGB FG_COLOR_RGB(){
        COLOR_RGB_init();
        return FG_COLOR_RGB_;
    }

    private static bool COLOR_RGB_init_complete = false;
    private static void COLOR_RGB_init() {
        if( COLOR_RGB_init_complete ){
            return;
        }
        COLOR_RGB_init_complete = true;
        BG_COLOR_RGB_= new RGB(255, 255, 225); // RGB value of info bg color on WindowsXP
        FG_COLOR_RGB_= new RGB(0, 0, 0); // RGB value of info fg color on WindowsXP
        Display display= Display.getDefault();
        if (display !is null && !display.isDisposed()) {
            try {
                display.asyncExec( dgRunnable( (Display display_){
                    BG_COLOR_RGB_= display_.getSystemColor(DWT.COLOR_INFO_BACKGROUND).getRGB();
                    FG_COLOR_RGB_= display_.getSystemColor(DWT.COLOR_INFO_FOREGROUND).getRGB();
                }, display ));
            } catch (DWTError err) {
                // see: https://bugs.eclipse.org/bugs/show_bug.cgi?id=45294
                if (err.code !is DWT.ERROR_DEVICE_DISPOSED)
                    throw err;
            }
        }
    }

    private this() {
    }

    private static String replace(String text, char c, String s) {

        int previous= 0;
        int current= text.indexOf(c, previous);

        if (current is -1)
            return text;

        StringBuffer buffer= new StringBuffer();
        while (current > -1) {
            buffer.append(text.substring(previous, current));
            buffer.append(s);
            previous= current + 1;
            current= text.indexOf(c, previous);
        }
        buffer.append(text.substring(previous));

        return buffer.toString();
    }

    public static String convertToHTMLContent(String content) {
        content= replace(content, '&', "&amp;"); //$NON-NLS-1$
        content= replace(content, '"', "&quot;"); //$NON-NLS-1$
        content= replace(content, '<', "&lt;"); //$NON-NLS-1$
        return replace(content, '>', "&gt;"); //$NON-NLS-1$
    }

    public static String read(Reader rd) {

        StringBuffer buffer= new StringBuffer();
        char[] readBuffer= new char[2048];

        try {
            int n= rd.read(readBuffer);
            while (n > 0) {
                buffer.append(readBuffer[ 0 .. n ]);
                n= rd.read(readBuffer);
            }
            return buffer.toString();
        } catch (IOException x) {
        }

        return null;
    }

    public static void insertPageProlog(StringBuffer buffer, int position, RGB fgRGB, RGB bgRGB, String styleSheet) {
        if (fgRGB is null)
            fgRGB= FG_COLOR_RGB;
        if (bgRGB is null)
            bgRGB= BG_COLOR_RGB;

        StringBuffer pageProlog= new StringBuffer(300);

        pageProlog.append("<html>"); //$NON-NLS-1$

        appendStyleSheetURL(pageProlog, styleSheet);

        appendColors(pageProlog, fgRGB, bgRGB);

        buffer.select(position,0);
        buffer.replace(pageProlog.toString());
    }

    private static void appendColors(StringBuffer pageProlog, RGB fgRGB, RGB bgRGB) {
        pageProlog.append("<body text=\""); //$NON-NLS-1$
        appendColor(pageProlog, fgRGB);
        pageProlog.append("\" bgcolor=\""); //$NON-NLS-1$
        appendColor(pageProlog, bgRGB);
        pageProlog.append("\">"); //$NON-NLS-1$
    }

    private static void appendColor(StringBuffer buffer, RGB rgb) {
        buffer.append('#');
        appendAsHexString(buffer, rgb.red);
        appendAsHexString(buffer, rgb.green);
        appendAsHexString(buffer, rgb.blue);
    }

    private static void appendAsHexString(StringBuffer buffer, int intValue) {
        String hexValue= Integer.toHexString(intValue);
        if (hexValue.length() is 1)
            buffer.append('0');
        buffer.append(hexValue);
    }

    public static void insertStyles(StringBuffer buffer, String[] styles) {
        if (styles is null || styles.length is 0)
            return;

        StringBuffer styleBuf= new StringBuffer(10 * styles.length);
        for (int i= 0; styles !is null && i < styles.length; i++) {
            styleBuf.append(" style=\""); //$NON-NLS-1$
            styleBuf.append(styles[i]);
            styleBuf.append('"');
        }

        // Find insertion index
        // a) within existing body tag with trailing space
        int index= buffer.slice().indexOf("<body "); //$NON-NLS-1$
        if (index !is -1) {
            buffer.select(index+5, 0);
            buffer.replace(styleBuf);
            return;
        }

        // b) within existing body tag without attributes
        index= buffer.slice().indexOf("<body>"); //$NON-NLS-1$
        if (index !is -1) {
            buffer.select(index+5, 0);
            buffer.replace( " " );
            buffer.select(index+6, 0);
            buffer.replace(styleBuf);
            return;
        }
    }

    private static void appendStyleSheetURL(StringBuffer buffer, String styleSheet) {
        if (styleSheet is null)
            return;

        buffer.append("<head><style CHARSET=\"ISO-8859-1\" TYPE=\"text/css\">"); //$NON-NLS-1$
        buffer.append(styleSheet);
        buffer.append("</style></head>"); //$NON-NLS-1$
    }

    private static void appendStyleSheetURL(StringBuffer buffer, URL styleSheetURL) {
        if (styleSheetURL is null)
            return;

        buffer.append("<head>"); //$NON-NLS-1$

        buffer.append("<LINK REL=\"stylesheet\" HREF= \""); //$NON-NLS-1$
        buffer.append(styleSheetURL.toString());
        buffer.append("\" CHARSET=\"ISO-8859-1\" TYPE=\"text/css\">"); //$NON-NLS-1$

        buffer.append("</head>"); //$NON-NLS-1$
    }

    public static void insertPageProlog(StringBuffer buffer, int position) {
        StringBuffer pageProlog= new StringBuffer(60);
        pageProlog.append("<html>"); //$NON-NLS-1$
        appendColors(pageProlog, FG_COLOR_RGB, BG_COLOR_RGB);
        buffer.select(position, 0);
        buffer.replace(pageProlog.toString());
    }

    public static void insertPageProlog(StringBuffer buffer, int position, URL styleSheetURL) {
        StringBuffer pageProlog= new StringBuffer(300);
        pageProlog.append("<html>"); //$NON-NLS-1$
        appendStyleSheetURL(pageProlog, styleSheetURL);
        appendColors(pageProlog, FG_COLOR_RGB, BG_COLOR_RGB);
        buffer.select(position, 0);
        buffer.replace(pageProlog.toString());
    }

    public static void insertPageProlog(StringBuffer buffer, int position, String styleSheet) {
        insertPageProlog(buffer, position, null, null, styleSheet);
    }

    public static void addPageProlog(StringBuffer buffer) {
        insertPageProlog(buffer, buffer.length());
    }

    public static void addPageEpilog(StringBuffer buffer) {
        buffer.append("</font></body></html>"); //$NON-NLS-1$
    }

    public static void startBulletList(StringBuffer buffer) {
        buffer.append("<ul>"); //$NON-NLS-1$
    }

    public static void endBulletList(StringBuffer buffer) {
        buffer.append("</ul>"); //$NON-NLS-1$
    }

    public static void addBullet(StringBuffer buffer, String bullet) {
        if (bullet !is null) {
            buffer.append("<li>"); //$NON-NLS-1$
            buffer.append(bullet);
            buffer.append("</li>"); //$NON-NLS-1$
        }
    }

    public static void addSmallHeader(StringBuffer buffer, String header) {
        if (header !is null) {
            buffer.append("<h5>"); //$NON-NLS-1$
            buffer.append(header);
            buffer.append("</h5>"); //$NON-NLS-1$
        }
    }

    public static void addParagraph(StringBuffer buffer, String paragraph) {
        if (paragraph !is null) {
            buffer.append("<p>"); //$NON-NLS-1$
            buffer.append(paragraph);
        }
    }

    public static void addParagraph(StringBuffer buffer, Reader paragraphReader) {
        if (paragraphReader !is null)
            addParagraph(buffer, read(paragraphReader));
    }

    /**
     * Replaces the following style attributes of the font definition of the <code>html</code>
     * element:
     * <ul>
     * <li>font-size</li>
     * <li>font-weight</li>
     * <li>font-style</li>
     * <li>font-family</li>
     * </ul>
     * The font's name is used as font family, a <code>sans-serif</code> default font family is
     * appended for the case that the given font name is not available.
     * <p>
     * If the listed font attributes are not contained in the passed style list, nothing happens.
     * </p>
     *
     * @param styles CSS style definitions
     * @param fontData the font information to use
     * @return the modified style definitions
     * @since 3.3
     */
    public static String convertTopLevelFont(String styles, FontData fontData) {
        bool bold= (fontData.getStyle() & DWT.BOLD) !is 0;
        bool italic= (fontData.getStyle() & DWT.ITALIC) !is 0;

        // See: https://bugs.eclipse.org/bugs/show_bug.cgi?id=155993
        String size= Integer.toString(fontData.getHeight()) ~ ("carbon".equals(DWT.getPlatform()) ? "px" : "pt"); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$

        String family= "'" ~ fontData.getName() ~ "',sans-serif"; //$NON-NLS-1$ //$NON-NLS-2$
        styles= styles.replaceFirst("(html\\s*\\{.*(?:\\s|;)font-size:\\s*)\\d+pt(\\;?.*\\})", "$1" ~ size ~ "$2"); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
        styles= styles.replaceFirst("(html\\s*\\{.*(?:\\s|;)font-weight:\\s*)\\w+(\\;?.*\\})", "$1" ~ (bold ? "bold" : "normal") ~ "$2"); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$ //$NON-NLS-4$ //$NON-NLS-5$
        styles= styles.replaceFirst("(html\\s*\\{.*(?:\\s|;)font-style:\\s*)\\w+(\\;?.*\\})", "$1" ~ (italic ? "italic" : "normal") ~ "$2"); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$ //$NON-NLS-4$ //$NON-NLS-5$
        styles= styles.replaceFirst("(html\\s*\\{.*(?:\\s|;)font-family:\\s*).+?(;.*\\})", "$1" ~ family ~ "$2"); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
        return styles;
    }
}
