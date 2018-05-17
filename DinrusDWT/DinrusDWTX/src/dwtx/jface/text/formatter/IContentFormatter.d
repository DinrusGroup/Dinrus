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
module dwtx.jface.text.formatter.IContentFormatter;

import dwtx.jface.text.formatter.MultiPassContentFormatter; // packageimport
import dwtx.jface.text.formatter.ContextBasedFormattingStrategy; // packageimport
import dwtx.jface.text.formatter.FormattingContext; // packageimport
import dwtx.jface.text.formatter.IFormattingStrategy; // packageimport
import dwtx.jface.text.formatter.IContentFormatterExtension; // packageimport
import dwtx.jface.text.formatter.IFormattingStrategyExtension; // packageimport
import dwtx.jface.text.formatter.FormattingContextProperties; // packageimport
import dwtx.jface.text.formatter.ContentFormatter; // packageimport
import dwtx.jface.text.formatter.IFormattingContext; // packageimport


import dwt.dwthelper.utils;


import dwtx.jface.text.IDocument;
import dwtx.jface.text.IRegion;


/**
 * The interface of a document content formatter. The formatter formats ranges
 * within documents. The documents are modified by the formatter.<p>
 * The content formatter is assumed to determine the partitioning of the document
 * range to be formatted. For each partition, the formatter determines based
 * on the partition's content type the formatting strategy to be used. Before
 * the first strategy is activated all strategies are informed about the
 * start of the formatting process. After that, the formatting strategies are
 * activated in the sequence defined by the partitioning of the document range to be
 * formatted. It is assumed that a strategy must be finished before the next strategy
 * can be activated. After the last strategy has been finished, all strategies are
 * informed about the termination of the formatting process.</p>
 * <p>
 * The interface can be implemented by clients. By default, clients use <code>ContentFormatter</code>
 * or <code>MultiPassContentFormatter</code> as the standard implementers of this interface.</p>
 *
 * @see IDocument
 * @see IFormattingStrategy
 */
public interface IContentFormatter {

    /**
     * Formats the given region of the specified document.The formatter may safely
     * assume that it is the only subject that modifies the document at this point in time.
     *
     * @param document the document to be formatted
     * @param region the region within the document to be formatted
     */
    void format(IDocument document, IRegion region);

    /**
     * Returns the formatting strategy registered for the given content type.
     *
     * @param contentType the content type for which to look up the formatting strategy
     * @return the formatting strategy for the given content type, or
     *      <code>null</code> if there is no such strategy
     */
    IFormattingStrategy getFormattingStrategy(String contentType);
}
