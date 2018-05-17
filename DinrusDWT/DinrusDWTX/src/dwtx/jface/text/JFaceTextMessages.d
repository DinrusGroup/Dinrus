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
module dwtx.jface.text.JFaceTextMessages;

import dwt.dwthelper.utils;

import dwt.dwthelper.ResourceBundle;

class JFaceTextMessages {

//     private static const String RESOURCE_BUNDLE= "dwtx.jface.text.JFaceTextMessages";//$NON-NLS-1$

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

    private this() {
    }

    public static String getString(String key) {
        try {
            return fgResourceBundle.getString(key);
        } catch (MissingResourceException e) {
            return "!" ~ key ~ "!";//$NON-NLS-2$ //$NON-NLS-1$
        }
    }
}
