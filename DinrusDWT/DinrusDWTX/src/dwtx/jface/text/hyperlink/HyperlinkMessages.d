/*******************************************************************************
 * Copyright (c) 2008 IBM Corporation and others.
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
module dwtx.jface.text.hyperlink.HyperlinkMessages;

import dwt.dwthelper.utils;

import dwt.dwthelper.ResourceBundle;


/**
 * Helper class to get NLSed messages.
 *
 * @since 3.4
 */
class HyperlinkMessages {
    private static ResourceBundle RESOURCE_BUNDLE_;//= ResourceBundle.getBundle(BUNDLE_NAME);
    private static ResourceBundle RESOURCE_BUNDLE(){
        if( RESOURCE_BUNDLE_ is null ){
            synchronized(HyperlinkMessages.classinfo ){
                if( RESOURCE_BUNDLE_ is null ){
                    RESOURCE_BUNDLE_ = ResourceBundle.getBundle(
                        getImportData!("dwtx.jface.text.hyperlink.HyperlinkMessages.properties"));
                }
            }
        }
        return RESOURCE_BUNDLE_;
    }

    private this() {
    }

    /**
     * Gets a string from the resource bundle.
     *
     * @param key the string used to get the bundle value, must not be
     *            <code>null</code>
     * @return the string from the resource bundle
     */
    public static String getString(String key) {
        try {
            return RESOURCE_BUNDLE.getString(key);
        } catch (MissingResourceException e) {
            return '!' ~ key ~ '!';
        }
    }
}
