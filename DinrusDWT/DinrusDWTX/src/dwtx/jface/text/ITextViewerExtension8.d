/*******************************************************************************
 * Copyright (c) 2007, 2008 IBM Corporation and others.
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
module dwtx.jface.text.ITextViewerExtension8;

import dwt.dwthelper.utils;

import dwt.custom.StyledTextPrintOptions;


/**
 * Extension interface for {@link dwtx.jface.text.ITextViewer}. Adds the
 * ability to print and set how hovers should be enriched when the mouse is moved into them.
 *
 * @since 3.4
 */
public interface ITextViewerExtension8 {

    /**
     * Print the text viewer contents using the given options.
     *
     * @param options the print options
     */
    void print(StyledTextPrintOptions options);

    /**
     * Sets the hover enrich mode.
     * A non-<code>null</code> <code>mode</code> defines when hovers
     * should be enriched once the mouse is moved into them.
     * If <code>mode</code> is <code>null</code>, hovers are automatically closed
     * when the mouse is moved out of the {@link ITextHover#getHoverRegion(ITextViewer, int) hover region}.
     * <p>
     * Note that a hover can only be enriched if its {@link IInformationControlExtension5#getInformationPresenterControlCreator()}
     * is not <code>null</code>.
     * </p>
     *
     * @param mode the enrich mode, or <code>null</code>
     */
    void setHoverEnrichMode(EnrichMode mode);



}

    /**
     * Type-safe enum of the available enrich modes.
     */
    public final class EnrichMode {

        /**
         * Enrich the hover shortly after the mouse has been moved into it and
         * stopped moving.
         *
         * @see ITextViewerExtension8#setHoverEnrichMode(dwtx.jface.text.ITextViewerExtension8.EnrichMode)
         */
        public static const EnrichMode AFTER_DELAY;

        /**
         * Enrich the hover immediately when the mouse is moved into it.
         *
         * @see ITextViewerExtension8#setHoverEnrichMode(dwtx.jface.text.ITextViewerExtension8.EnrichMode)
         */
        public static const EnrichMode IMMEDIATELY;

        /**
         * Enrich the hover on explicit mouse click.
         *
         * @see ITextViewerExtension8#setHoverEnrichMode(dwtx.jface.text.ITextViewerExtension8.EnrichMode)
         */
        public static const EnrichMode ON_CLICK;


        static this(){
            AFTER_DELAY= new EnrichMode("after delay"); //$NON-NLS-1$
            IMMEDIATELY= new EnrichMode("immediately"); //$NON-NLS-1$
            ON_CLICK= new EnrichMode("on click"); //$NON-NLS-1$;
        }

        private String fName;

        private this(String name) {
            fName= name;
        }

        /*
         * @see java.lang.Object#toString()
         */
        public override String toString() {
            return fName;
        }
    }
alias EnrichMode ITextViewerExtension8_EnrichMode;
