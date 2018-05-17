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
module dwtx.jface.text.templates.TextTemplateMessages;

import dwt.dwthelper.utils;

import dwt.dwthelper.ResourceBundle;
import dwtx.dwtxhelper.MessageFormat;

/*
 * @since 3.0
 */
class TextTemplateMessages {

//     private static const String RESOURCE_BUNDLE= TextTemplateMessages.classinfo.getName();
    private static ResourceBundle fgResourceBundle_;//= ResourceBundle.getBundle(RESOURCE_BUNDLE);
    private static ResourceBundle fgResourceBundle(){
        if( fgResourceBundle_ is null ){
            synchronized(TextTemplateMessages.classinfo ){
                if( fgResourceBundle_ is null ){
                    fgResourceBundle_ = ResourceBundle.getBundle(
                        getImportData!("dwtx.jface.text.templates.TextTemplateMessages.properties"));
                }
            }
        }
        return fgResourceBundle_;
    }

    private this() {
    }

    public static String getString(String key) {
        try {
            return fgResourceBundle.getString(key);
        } catch (MissingResourceException e) {
            return '!' ~ key ~ '!';
        }
    }

    public static String getFormattedString(String key, Object[] args... ) {
        return MessageFormat.format(getString(key), args);
    }
}
