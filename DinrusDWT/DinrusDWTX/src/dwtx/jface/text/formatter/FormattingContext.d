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


module dwtx.jface.text.formatter.FormattingContext;

import dwtx.jface.text.formatter.MultiPassContentFormatter; // packageimport
import dwtx.jface.text.formatter.ContextBasedFormattingStrategy; // packageimport
import dwtx.jface.text.formatter.IFormattingStrategy; // packageimport
import dwtx.jface.text.formatter.IContentFormatterExtension; // packageimport
import dwtx.jface.text.formatter.IFormattingStrategyExtension; // packageimport
import dwtx.jface.text.formatter.IContentFormatter; // packageimport
import dwtx.jface.text.formatter.FormattingContextProperties; // packageimport
import dwtx.jface.text.formatter.ContentFormatter; // packageimport
import dwtx.jface.text.formatter.IFormattingContext; // packageimport

import dwt.dwthelper.utils;

import dwtx.dwtxhelper.Collection;


import dwtx.jface.preference.IPreferenceStore;

/**
 * Default implementation of <code>IFormattingContext</code>.
 *
 * @since 3.0
 */
public class FormattingContext : IFormattingContext {

    /** Map to store the properties */
    private const Map fMap;

    this(){
        fMap= new HashMap();
    }

    /*
     * @see dwtx.jface.text.formatter.IFormattingContext#dispose()
     */
    public void dispose() {
        fMap.clear();
    }

    /*
     * @see dwtx.jface.text.formatter.IFormattingContext#getPreferenceKeys()
     */
    public String[] getPreferenceKeys() {
        return null;
    }

    /*
     * @see dwtx.jface.text.formatter.IFormattingContext#getProperty(java.lang.Object)
     */
    public Object getProperty(Object key) {
        return fMap.get(key);
    }

    /*
     * @see dwtx.jface.text.formatter.IFormattingContext#isBooleanPreference(java.lang.String)
     */
    public bool isBooleanPreference(String key) {
        return false;
    }

    /*
     * @see dwtx.jface.text.formatter.IFormattingContext#isDoublePreference(java.lang.String)
     */
    public bool isDoublePreference(String key) {
        return false;
    }

    /*
     * @see dwtx.jface.text.formatter.IFormattingContext#isFloatPreference(java.lang.String)
     */
    public bool isFloatPreference(String key) {
        return false;
    }

    /*
     * @see dwtx.jface.text.formatter.IFormattingContext#isIntegerPreference(java.lang.String)
     */
    public bool isIntegerPreference(String key) {
        return false;
    }

    /*
     * @see dwtx.jface.text.formatter.IFormattingContext#isLongPreference(java.lang.String)
     */
    public bool isLongPreference(String key) {
        return false;
    }

    /*
     * @see dwtx.jface.text.formatter.IFormattingContext#isStringPreference(java.lang.String)
     */
    public bool isStringPreference(String key) {
        return false;
    }

    /*
     * @see dwtx.jface.text.formatter.IFormattingContext#mapToStore(java.util.Map, dwtx.jface.preference.IPreferenceStore)
     */
    public void mapToStore(Map map, IPreferenceStore store) {

        final String[] preferences= getPreferenceKeys();

        String result= null;
        String preference= null;

        for (int index= 0; index < preferences.length; index++) {

            preference= preferences[index];
            result= stringcast(map.get(preference));

            if (result !is null) {

                try {
                    if (isBooleanPreference(preference)) {
                        store.setValue(preference, result.equals(IPreferenceStore.TRUE));
                    } else if (isIntegerPreference(preference)) {
                        store.setValue(preference, Integer.parseInt(result));
                    } else if (isStringPreference(preference)) {
                        store.setValue(preference, result);
                    } else if (isDoublePreference(preference)) {
                        store.setValue(preference, Double.parseDouble(result));
                    } else if (isFloatPreference(preference)) {
                        store.setValue(preference, Float.parseFloat(result));
                    } else if (isLongPreference(preference)) {
                        store.setValue(preference, Long.parseLong(result));
                    }
                } catch (NumberFormatException exception) {
                    // Do nothing
                }
            }
        }
    }

    /*
     * @see dwtx.jface.text.formatter.IFormattingContext#setProperty(java.lang.Object, java.lang.Object)
     */
    public void setProperty(Object key, Object property) {
        fMap.put(key, property);
    }

    /*
     * @see dwtx.jface.text.formatter.IFormattingContext#storeToMap(dwtx.jface.preference.IPreferenceStore, java.util.Map, bool)
     */
    public void storeToMap(IPreferenceStore store, Map map, bool useDefault) {

        final String[] preferences= getPreferenceKeys();

        String preference= null;
        for (int index= 0; index < preferences.length; index++) {

            preference= preferences[index];

            if (isBooleanPreference(preference)) {
                map.put(preference, (useDefault ? store.getDefaultBoolean(preference) : store.getBoolean(preference)) ? IPreferenceStore.TRUE : IPreferenceStore.FALSE);
            } else if (isIntegerPreference(preference)) {
                map.put(preference, String_valueOf(useDefault ? store.getDefaultInt(preference) : store.getInt(preference)));
            } else if (isStringPreference(preference)) {
                map.put(preference, useDefault ? store.getDefaultString(preference) : store.getString(preference));
            } else if (isDoublePreference(preference)) {
                map.put(preference, String_valueOf(useDefault ? store.getDefaultDouble(preference) : store.getDouble(preference)));
            } else if (isFloatPreference(preference)) {
                map.put(preference, String_valueOf(useDefault ? store.getDefaultFloat(preference) : store.getFloat(preference)));
            } else if (isLongPreference(preference)) {
                map.put(preference, String_valueOf(useDefault ? store.getDefaultLong(preference) : store.getLong(preference)));
            }
        }
    }
}
