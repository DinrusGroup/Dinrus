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


module dwtx.jface.text.formatter.FormattingContextProperties;

import dwtx.jface.text.formatter.MultiPassContentFormatter; // packageimport
import dwtx.jface.text.formatter.ContextBasedFormattingStrategy; // packageimport
import dwtx.jface.text.formatter.FormattingContext; // packageimport
import dwtx.jface.text.formatter.IFormattingStrategy; // packageimport
import dwtx.jface.text.formatter.IContentFormatterExtension; // packageimport
import dwtx.jface.text.formatter.IFormattingStrategyExtension; // packageimport
import dwtx.jface.text.formatter.IContentFormatter; // packageimport
import dwtx.jface.text.formatter.ContentFormatter; // packageimport
import dwtx.jface.text.formatter.IFormattingContext; // packageimport

import dwt.dwthelper.utils;

/**
 * Keys used by <code>IFormattingContext</code> objects to register specific
 * properties needed during the formatting process of a content formatter
 * implementing <code>IContentFormatterExtension</code>.
 *
 * @see IFormattingContext
 * @see IFormattingStrategyExtension
 * @see IContentFormatterExtension
 * @since 3.0
 */
public class FormattingContextProperties {

    /**
     * Property key of the document property. The property must implement
     * <code>java.lang#Boolean</code>. If set to <code>true</code> the whole
     * document is formatted.
     * <p>
     * Value: <code>"formatting.context.document"</code>
     */
    public static const String CONTEXT_DOCUMENT= "formatting.context.document"; //$NON-NLS-1$

    /**
     * Property key of the partition property. The property must implement
     * <code>dwtx.jface.text#TypedPosition</code>. The partition
     * a context based formatting strategy should format.
     * <p>
     * Value: <code>"formatting.context.partition"</code>
     */
    public static const String CONTEXT_PARTITION= "formatting.context.partition"; //$NON-NLS-1$

    /**
     * Property key of the preferences property. The property must implement
     * <code>java.util#Map</code>. The formatting preferences mapping preference
     * keys to values.
     * <p>
     * Value: <code>"formatting.context.preferences"</code>
     */
    public static const String CONTEXT_PREFERENCES= "formatting.context.preferences"; //$NON-NLS-1$

    /**
     * Property key of the region property. The property must implement <code>dwtx.jface.text#IRegion</code>.
     * The region to format. If set, {@link FormattingContextProperties#CONTEXT_DOCUMENT} should be <code>false</code>
     * for this to take effect.
     * <p>
     * Value: <code>"formatting.context.region"</code>
     */
    public static const String CONTEXT_REGION= "formatting.context.region"; //$NON-NLS-1$

    /**
     * Property key of the medium property. The property must implement <code>dwtx.jface.text#IDocument</code>.
     * The document to format.
     * <p>
     * Value: <code>"formatting.context.medium"</code>
     */
    public static const String CONTEXT_MEDIUM= "formatting.context.medium"; //$NON-NLS-1$

    /**
     * Ensure that this class cannot be instantiated.
     */
    private this() {
    }
}
