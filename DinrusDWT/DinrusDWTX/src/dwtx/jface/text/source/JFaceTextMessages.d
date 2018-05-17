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


module dwtx.jface.text.source.JFaceTextMessages;

import dwt.dwthelper.utils;

import dwt.dwthelper.ResourceBundle;
import dwtx.dwtxhelper.MessageFormat;

/**
 * Accessor for the <code>JFaceTextMessages.properties</code> file in
 * package <code>dwtx.jface.text</code>.
 * @since 2.0
 */
class JFaceTextMessages {

    /** The resource bundle name. */
//     private static const String RESOURCE_BUNDLE= "dwtx.jface.text.JFaceTextMessages";//$NON-NLS-1$

    /** The resource bundle. */
    private static ResourceBundle fgResourceBundle_;//= ResourceBundle.getBundle(RESOURCE_BUNDLE);

    private static ResourceBundle fgResourceBundle(){
        if( fgResourceBundle_ is null ){
            synchronized(JFaceTextMessages.classinfo ){
                if( fgResourceBundle_ is null ){
                    fgResourceBundle_ = ResourceBundle.getBundle(
            getImportData!("dwtx.jface.text.JFaceTextMessages.properties"));
                }
            }
        }
        return fgResourceBundle_;
    }

    /**
     * Prohibits the creation of accessor objects.
     */
    private this() {
    }

    /**
     * Returns the string found in the resource bundle under the given key or a place holder string.
     *
     * @param key the look up key
     * @return the value found under the given key
     */
    public static String getString(String key) {
        try {
            return fgResourceBundle.getString(key);
        } catch (MissingResourceException e) {
            return "!" ~ key ~ "!";//$NON-NLS-2$ //$NON-NLS-1$
        }
    }

    /**
     * Gets a string from the resource bundle and formats it with the argument
     *
     * @param key   the string used to get the bundle value, must not be null
     * @param args arguments used when formatting the string
     * @return the formatted string
     * @since 3.0
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
