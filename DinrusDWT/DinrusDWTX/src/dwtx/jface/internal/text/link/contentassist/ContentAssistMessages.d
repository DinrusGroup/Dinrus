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
module dwtx.jface.internal.text.link.contentassist.ContentAssistMessages;


import dwtx.jface.internal.text.link.contentassist.IProposalListener; // packageimport
import dwtx.jface.internal.text.link.contentassist.LineBreakingReader; // packageimport
import dwtx.jface.internal.text.link.contentassist.CompletionProposalPopup2; // packageimport
import dwtx.jface.internal.text.link.contentassist.ContextInformationPopup2; // packageimport
import dwtx.jface.internal.text.link.contentassist.Helper2; // packageimport
import dwtx.jface.internal.text.link.contentassist.PopupCloser2; // packageimport
import dwtx.jface.internal.text.link.contentassist.IContentAssistListener2; // packageimport
import dwtx.jface.internal.text.link.contentassist.ContentAssistant2; // packageimport
import dwtx.jface.internal.text.link.contentassist.AdditionalInfoController2; // packageimport

import dwt.dwthelper.utils;

import dwt.dwthelper.ResourceBundle;
import dwtx.dwtxhelper.MessageFormat;


/**
 * Helper class to get NLSed messages.
 *
 * @since 3.0
 */
class ContentAssistMessages {

//     private static const String RESOURCE_BUNDLE= ContentAssistMessages.classinfo.getName();

    private static ResourceBundle fgResourceBundle;//= ResourceBundle.getBundle(RESOURCE_BUNDLE);

    static this() {
        fgResourceBundle = ResourceBundle.getBundle(
            getImportData!("dwtx.jface.internal.text.link.contentassist.ContentAssistMessages.properties"));
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
    public static String getFormattedString(String key, Object[] args... ) {
        String format= null;
        try {
            format= fgResourceBundle.getString(key);
        } catch (MissingResourceException e) {
            return "!" ~ key ~ "!";//$NON-NLS-2$ //$NON-NLS-1$
        }
        return MessageFormat.format(format, args);
    }


}
