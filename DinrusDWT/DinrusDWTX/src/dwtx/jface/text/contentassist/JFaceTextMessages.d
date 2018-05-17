/*******************************************************************************
 * Copyright (c) 2000, 2005 IBM Corporation and others.
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
module dwtx.jface.text.contentassist.JFaceTextMessages;

import dwt.dwthelper.utils;

import dwt.dwthelper.ResourceBundle;

/**
 * Helper class to get NLSed messages.
 */
class JFaceTextMessages {

//     private static const String RESOURCE_BUNDLE= JFaceTextMessages.classinfo.getName();

    private static ResourceBundle fgResourceBundle_;//= ResourceBundle.getBundle(RESOURCE_BUNDLE);
    private static ResourceBundle fgResourceBundle(){
        if( fgResourceBundle_ is null ){
            synchronized(JFaceTextMessages.classinfo ){
                if( fgResourceBundle_ is null ){
                    fgResourceBundle_ = ResourceBundle.getBundle(
                        getImportData!("dwtx.jface.text.contentassist.JFaceTextMessages.properties"));
                }
            }
        }
        return fgResourceBundle_;
    }

    private this() {
    }

    /**
     * Gets a string from the resource bundle.
     *
     * @param key the string used to get the bundle value, must not be <code>null</code>
     * @return the string from the resource bundle
     */
    public static String getString(String key) {
        try {
            return fgResourceBundle.getString(key);
        } catch (MissingResourceException e) {
            return "!" ~ key ~ "!";//$NON-NLS-2$ //$NON-NLS-1$
        }
    }
}
