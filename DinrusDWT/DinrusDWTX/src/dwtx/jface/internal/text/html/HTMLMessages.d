/*******************************************************************************
 * Copyright (c) 2006 IBM Corporation and others.
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
module dwtx.jface.internal.text.html.HTMLMessages;

import dwtx.jface.internal.text.html.HTML2TextReader; // packageimport
import dwtx.jface.internal.text.html.HTMLPrinter; // packageimport
import dwtx.jface.internal.text.html.BrowserInformationControl; // packageimport
import dwtx.jface.internal.text.html.SubstitutionTextReader; // packageimport
import dwtx.jface.internal.text.html.HTMLTextPresenter; // packageimport
import dwtx.jface.internal.text.html.BrowserInput; // packageimport
import dwtx.jface.internal.text.html.SingleCharReader; // packageimport
import dwtx.jface.internal.text.html.BrowserInformationControlInput; // packageimport


import dwt.dwthelper.utils;

import dwt.dwthelper.ResourceBundle;
import dwtx.dwtxhelper.MessageFormat;


/**
 * Helper class to get NLSed messages.
 *
 * @since 3.3
 */
class HTMLMessages {

//     private static const String RESOURCE_BUNDLE= HTMLMessages.classinfo.getName();

    private static ResourceBundle fgResourceBundle;//= ResourceBundle.getBundle(RESOURCE_BUNDLE);

    static this() {
        fgResourceBundle = ResourceBundle.getBundle(
            getImportData!("dwtx.jface.internal.text.html.HTMLMessages.properties"));
    }

    private this() {
    }

    /**
     * Gets a string from the resource bundle.
     *
     * @param key the string used to get the bundle value, must not be null
     * @return the string from the resource bundle
     */
    public static String getString(String key) {
        try {
            return fgResourceBundle.getString(key);
        } catch (MissingResourceException e) {
            return "!" ~ key ~ "!";//$NON-NLS-2$ //$NON-NLS-1$
        }
    }

    /**
     * Gets a string from the resource bundle and formats it with the given arguments.
     *
     * @param key the string used to get the bundle value, must not be null
     * @param args the arguments used to format the string
     * @return the formatted string
     */
    public static String getFormattedString(String key, Object[] args...) {
        String format= null;
        try {
            format= fgResourceBundle.getString(key);
        } catch (MissingResourceException e) {
            return "!" ~ key ~ "!";//$NON-NLS-2$ //$NON-NLS-1$
        }
        return MessageFormat.format(format, args);
    }

}
