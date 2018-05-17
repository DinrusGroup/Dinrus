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


module dwtx.jface.text.formatter.MultiPassContentFormatter;

import dwtx.jface.text.formatter.ContextBasedFormattingStrategy; // packageimport
import dwtx.jface.text.formatter.FormattingContext; // packageimport
import dwtx.jface.text.formatter.IFormattingStrategy; // packageimport
import dwtx.jface.text.formatter.IContentFormatterExtension; // packageimport
import dwtx.jface.text.formatter.IFormattingStrategyExtension; // packageimport
import dwtx.jface.text.formatter.IContentFormatter; // packageimport
import dwtx.jface.text.formatter.FormattingContextProperties; // packageimport
import dwtx.jface.text.formatter.ContentFormatter; // packageimport
import dwtx.jface.text.formatter.IFormattingContext; // packageimport

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;

import dwtx.core.runtime.Assert;
import dwtx.jface.text.BadLocationException;
import dwtx.jface.text.DefaultPositionUpdater;
import dwtx.jface.text.IDocument;
import dwtx.jface.text.IRegion;
import dwtx.jface.text.ITypedRegion;
import dwtx.jface.text.TextUtilities;
import dwtx.jface.text.TypedPosition;

/**
 * Content formatter for edit-based formatting strategies.
 * <p>
 * Two kinds of formatting strategies can be registered with this formatter:
 * <ul>
 * <li>one master formatting strategy for the default content type</li>
 * <li>one formatting strategy for each non-default content type</li>
 * </ul>
 * The master formatting strategy always formats the whole region to be
 * formatted in the first pass. In a second pass, all partitions of the region
 * to be formatted that are not of master content type are formatted using the
 * slave formatting strategy registered for the underlying content type. All
 * formatting strategies must implement {@link IFormattingStrategyExtension}.
 * <p>
 * Regions to be formatted with the master formatting strategy always have
 * an offset aligned to the line start. Regions to be formatted with slave formatting
 * strategies are aligned on partition boundaries.
 *
 * @see IFormattingStrategyExtension
 * @since 3.0
 */
public class MultiPassContentFormatter : IContentFormatter, IContentFormatterExtension {

    /**
     * Position updater that shifts otherwise deleted positions to the next
     * non-whitespace character. The length of the positions are truncated to
     * one if the position was shifted.
     */
    protected class NonDeletingPositionUpdater : DefaultPositionUpdater {

        /**
         * Creates a new non-deleting position updater.
         *
         * @param category The position category to update its positions
         */
        public this(String category) {
            super(category);
        }

        /*
         * @see dwtx.jface.text.DefaultPositionUpdater#notDeleted()
         */
        protected final bool notDeleted() {

            if (fOffset < fPosition.offset && (fPosition.offset + fPosition.length < fOffset + fLength)) {

                int offset= fOffset + fLength;
                if (offset < fDocument.getLength()) {

                    try {

                        bool moved= false;
                        char character= fDocument.getChar(offset);

                        while (offset < fDocument.getLength() && Character.isWhitespace(character)) {

                            moved= true;
                            character= fDocument.getChar(offset++);
                        }

                        if (moved)
                            offset--;

                    } catch (BadLocationException exception) {
                        // Can not happen
                    }

                    fPosition.offset= offset;
                    fPosition.length= 0;
                }
            }
            return true;
        }
    }

    /** The master formatting strategy */
    private IFormattingStrategyExtension fMaster= null;
    /** The partitioning of this content formatter */
    private const String fPartitioning;
    /** The slave formatting strategies */
    private const Map fSlaves;
    /** The default content type */
    private const String fType;

    /**
     * Creates a new content formatter.
     *
     * @param partitioning the document partitioning for this formatter
     * @param type the default content type
     */
    public this(String partitioning, String type) {
        fSlaves= new HashMap();

        fPartitioning= partitioning;
        fType= type;
    }

    /*
     * @see dwtx.jface.text.formatter.IContentFormatterExtension#format(dwtx.jface.text.IDocument, dwtx.jface.text.formatter.IFormattingContext)
     */
    public final void format(IDocument medium, IFormattingContext context) {

        context.setProperty(stringcast(FormattingContextProperties.CONTEXT_MEDIUM), cast(Object)medium);

        final Boolean document= cast(Boolean)context.getProperty(stringcast(FormattingContextProperties.CONTEXT_DOCUMENT));
        if (document is null || !document.booleanValue()) {

            final IRegion region= cast(IRegion)context.getProperty(stringcast(FormattingContextProperties.CONTEXT_REGION));
            if (region !is null) {
                try {
                    formatMaster(context, medium, region.getOffset(), region.getLength());
                } finally {
                    formatSlaves(context, medium, region.getOffset(), region.getLength());
                }
            }
        } else {
            try {
                formatMaster(context, medium, 0, medium.getLength());
            } finally {
                formatSlaves(context, medium, 0, medium.getLength());
            }
        }
    }

    /*
     * @see dwtx.jface.text.formatter.IContentFormatter#format(dwtx.jface.text.IDocument, dwtx.jface.text.IRegion)
     */
    public final void format(IDocument medium, IRegion region) {

        final FormattingContext context= new FormattingContext();

        context.setProperty(stringcast(FormattingContextProperties.CONTEXT_DOCUMENT), Boolean.FALSE);
        context.setProperty(stringcast(FormattingContextProperties.CONTEXT_REGION), cast(Object)region);

        format(medium, context);
    }

    /**
     * Formats the document specified in the formatting context with the master
     * formatting strategy.
     * <p>
     * The master formatting strategy covers all regions of the document. The
     * offset of the region to be formatted is aligned on line start boundaries,
     * whereas the end index of the region remains the same. For this formatting
     * type the document partitioning is not taken into account.
     *
     * @param context The formatting context to use
     * @param document The document to operate on
     * @param offset The offset of the region to format
     * @param length The length of the region to format
     */
    protected void formatMaster(IFormattingContext context, IDocument document, int offset, int length) {

        try {

            final int delta= offset - document.getLineInformationOfOffset(offset).getOffset();
            offset -= delta;
            length += delta;

        } catch (BadLocationException exception) {
            // Do nothing
        }

        if (fMaster !is null) {

            context.setProperty(stringcast(FormattingContextProperties.CONTEXT_PARTITION), new TypedPosition(offset, length, fType));

            fMaster.formatterStarts(context);
            fMaster.format();
            fMaster.formatterStops();
        }
    }

    /**
     * Formats the document specified in the formatting context with the
     * formatting strategy registered for the content type.
     * <p>
     * For this formatting type only slave strategies are used. The region to be
     * formatted is aligned on partition boundaries of the underlying content
     * type. The exact formatting strategy is determined by the underlying
     * content type of the document partitioning.
     *
     * @param context The formatting context to use
     * @param document The document to operate on
     * @param offset The offset of the region to format
     * @param length The length of the region to format
     * @param type The content type of the region to format
     */
    protected void formatSlave(IFormattingContext context, IDocument document, int offset, int length, String type) {

        final IFormattingStrategyExtension strategy= cast(IFormattingStrategyExtension)fSlaves.get(type);
        if (strategy !is null) {

            context.setProperty(stringcast(FormattingContextProperties.CONTEXT_PARTITION), new TypedPosition(offset, length, type));

            strategy.formatterStarts(context);
            strategy.format();
            strategy.formatterStops();
        }
    }

    /**
     * Formats the document specified in the formatting context with the slave
     * formatting strategies.
     * <p>
     * For each content type of the region to be formatted in the document
     * partitioning, the registered slave formatting strategy is used to format
     * that particular region. The region to be formatted is aligned on
     * partition boundaries of the underlying content type. If the content type
     * is the document's default content type, nothing happens.
     *
     * @param context The formatting context to use
     * @param document The document to operate on
     * @param offset The offset of the region to format
     * @param length The length of the region to format
     */
    protected void formatSlaves(IFormattingContext context, IDocument document, int offset, int length) {

        Map partitioners= new HashMap(0);
        try {

            final ITypedRegion[] partitions= TextUtilities.computePartitioning(document, fPartitioning, offset, length, false);

            if (!fType.equals(partitions[0].getType()))
                partitions[0]= TextUtilities.getPartition(document, fPartitioning, partitions[0].getOffset(), false);

            if (partitions.length > 1) {

                if (!fType.equals(partitions[partitions.length - 1].getType()))
                    partitions[partitions.length - 1]= TextUtilities.getPartition(document, fPartitioning, partitions[partitions.length - 1].getOffset(), false);
            }

            String type= null;
            ITypedRegion partition= null;

            partitioners= TextUtilities.removeDocumentPartitioners(document);

            for (int index= partitions.length - 1; index >= 0; index--) {

                partition= partitions[index];
                type= partition.getType();

                if (!fType.equals(type))
                    formatSlave(context, document, partition.getOffset(), partition.getLength(), type);
            }

        } catch (BadLocationException exception) {
            // Should not happen
        } finally {
            TextUtilities.addDocumentPartitioners(document, partitioners);
        }
    }

    /*
     * @see dwtx.jface.text.formatter.IContentFormatter#getFormattingStrategy(java.lang.String)
     */
    public final IFormattingStrategy getFormattingStrategy(String type) {
        return null;
    }

    /**
     * Registers a master formatting strategy.
     * <p>
     * The strategy may already be registered with a certain content type as
     * slave strategy. The master strategy is registered for the default content
     * type of documents. If a master strategy has already been registered, it
     * is overridden by the new one.
     *
     * @param strategy The master formatting strategy, must implement
     *  {@link IFormattingStrategyExtension}
     */
    public final void setMasterStrategy(IFormattingStrategy strategy) {
        Assert.isTrue( null !is cast(IFormattingStrategyExtension)strategy );
        fMaster= cast(IFormattingStrategyExtension) strategy;
    }

    /**
     * Registers a slave formatting strategy for a certain content type.
     * <p>
     * The strategy may already be registered as master strategy. An
     * already registered slave strategy for the specified content type
     * will be replaced. However, the same strategy may be registered with
     * several content types. Slave strategies cannot be registered for the
     * default content type of documents.
     *
     * @param strategy The slave formatting strategy
     * @param type The content type to register this strategy with,
     *  must implement {@link IFormattingStrategyExtension}
     */
    public final void setSlaveStrategy(IFormattingStrategy strategy, String type) {
        Assert.isTrue( null !is cast(IFormattingStrategyExtension)strategy );
        if (!fType.equals(type))
            fSlaves.put(type, cast(Object)strategy);
    }
}
