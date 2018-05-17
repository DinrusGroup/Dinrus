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
module dwtx.jface.text.DocumentRewriteSessionType;

import dwt.dwthelper.utils;

/**
 * A document rewrite session type.
 * <p>
 * Allowed values are:
 * <ul>
 *  <li>{@link DocumentRewriteSessionType#UNRESTRICTED}</li>
 *  <li>{@link DocumentRewriteSessionType#UNRESTRICTED_SMALL} (since 3.3)</li>
 *  <li>{@link DocumentRewriteSessionType#SEQUENTIAL}</li>
 *  <li>{@link DocumentRewriteSessionType#STRICTLY_SEQUENTIAL}</li>
 * </ul>
 * </p>
 *
 * @see dwtx.jface.text.IDocument
 * @see dwtx.jface.text.IDocumentExtension4
 * @see dwtx.jface.text.IDocumentRewriteSessionListener
 * @since 3.1
 */
public class DocumentRewriteSessionType {

    static this(){
        UNRESTRICTED= new DocumentRewriteSessionType();
        UNRESTRICTED_SMALL= new DocumentRewriteSessionType();
        SEQUENTIAL= new DocumentRewriteSessionType();
        STRICTLY_SEQUENTIAL= new DocumentRewriteSessionType();
    }

    /**
     * An unrestricted rewrite session is a sequence of unrestricted replace operations. This
     * session type should only be used for <em>large</em> operations that touch more than about
     * fifty lines. Use {@link #UNRESTRICTED_SMALL} for small operations.
     */
    public const static DocumentRewriteSessionType UNRESTRICTED;
    /**
     * An small unrestricted rewrite session is a short sequence of unrestricted replace operations.
     * This should be used for changes that touch less than about fifty lines.
     *
     * @since 3.3
     */
    public const static DocumentRewriteSessionType UNRESTRICTED_SMALL;
    /**
     * A sequential rewrite session is a sequence of non-overlapping replace
     * operations starting at an arbitrary document offset.
     */
    public const static DocumentRewriteSessionType SEQUENTIAL;
    /**
     * A strictly sequential rewrite session is a sequence of non-overlapping
     * replace operations from the start of the document to its end.
     */
    public const static DocumentRewriteSessionType STRICTLY_SEQUENTIAL;


    /**
     * Prohibit external object creation.
     */
    private this() {
    }
}
