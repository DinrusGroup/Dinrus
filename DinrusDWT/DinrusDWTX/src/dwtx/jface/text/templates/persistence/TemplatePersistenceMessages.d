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
module dwtx.jface.text.templates.persistence.TemplatePersistenceMessages;

import dwtx.jface.text.templates.persistence.TemplatePersistenceData; // packageimport
import dwtx.jface.text.templates.persistence.TemplateReaderWriter; // packageimport
import dwtx.jface.text.templates.persistence.TemplateStore; // packageimport


import dwt.dwthelper.utils;

import dwt.dwthelper.ResourceBundle;
import dwtx.dwtxhelper.MessageFormat;

/**
 * @since 3.0
 */
class TemplatePersistenceMessages {

//     private static const String RESOURCE_BUNDLE= TemplatePersistenceMessages.classinfo.getName();
    private static ResourceBundle fgResourceBundle_;//= ResourceBundle.getBundle(RESOURCE_BUNDLE);
    private static ResourceBundle fgResourceBundle(){
        if( fgResourceBundle_ is null ){
            synchronized(TemplatePersistenceMessages.classinfo ){
                if( fgResourceBundle_ is null ){
                    fgResourceBundle_ = ResourceBundle.getBundle(
                        getImportData!("dwtx.jface.text.templates.persistence.TemplatePersistenceMessages.properties"));
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

    public static String getFormattedString(String key, Object[] args...) {
        return MessageFormat.format(getString(key), args);
    }
}
