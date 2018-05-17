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
module dwtx.text.edits.InsertEdit;

import dwtx.text.edits.MultiTextEdit; // packageimport
import dwtx.text.edits.CopySourceEdit; // packageimport
import dwtx.text.edits.MoveSourceEdit; // packageimport
import dwtx.text.edits.CopyingRangeMarker; // packageimport
import dwtx.text.edits.ReplaceEdit; // packageimport
import dwtx.text.edits.EditDocument; // packageimport
import dwtx.text.edits.UndoCollector; // packageimport
import dwtx.text.edits.DeleteEdit; // packageimport
import dwtx.text.edits.MoveTargetEdit; // packageimport
import dwtx.text.edits.CopyTargetEdit; // packageimport
import dwtx.text.edits.TextEditCopier; // packageimport
import dwtx.text.edits.ISourceModifier; // packageimport
import dwtx.text.edits.TextEditMessages; // packageimport
import dwtx.text.edits.TextEditProcessor; // packageimport
import dwtx.text.edits.MalformedTreeException; // packageimport
import dwtx.text.edits.TreeIterationInfo; // packageimport
import dwtx.text.edits.TextEditVisitor; // packageimport
import dwtx.text.edits.TextEditGroup; // packageimport
import dwtx.text.edits.TextEdit; // packageimport
import dwtx.text.edits.RangeMarker; // packageimport
import dwtx.text.edits.UndoEdit; // packageimport


import dwt.dwthelper.utils;


import dwtx.core.runtime.Assert;
import dwtx.jface.text.BadLocationException;
import dwtx.jface.text.IDocument;

/**
 * Text edit to insert a text at a given position in a
 * document.
 * <p>
 * An insert edit is equivalent to <code>ReplaceEdit(offset, 0, text)
 * </code>
 *
 * @since 3.0
 */
public final class InsertEdit : TextEdit {

    private String fText;

    /**
     * Constructs a new insert edit.
     *
     * @param offset the insertion offset
     * @param text the text to insert
     */
    public this(int offset, String text) {
        super(offset, 0);
        Assert.isNotNull(text);
        fText= text;
    }

    /*
     * Copy constructor
     */
    private this(InsertEdit other) {
        super(other);
        fText= other.fText;
    }

    /**
     * Returns the text to be inserted.
     *
     * @return the edit's text.
     */
    public String getText() {
        return fText;
    }

    /*
     * @see TextEdit#doCopy
     */
    protected TextEdit doCopy() {
        return new InsertEdit(this);
    }

    /*
     * @see TextEdit#accept0
     */
    protected void accept0(TextEditVisitor visitor) {
        bool visitChildren= visitor.visit(this);
        if (visitChildren) {
            acceptChildren(visitor);
        }
    }

    /*
     * @see TextEdit#performDocumentUpdating
     */
    int performDocumentUpdating(IDocument document)  {
        document.replace(getOffset(), getLength(), fText);
        fDelta= fText.length() - getLength();
        return fDelta;
    }

    /*
     * @see TextEdit#deleteChildren
     */
    bool deleteChildren() {
        return false;
    }

    /*
     * @see dwtx.text.edits.TextEdit#internalToString(java.lang.StringBuffer, int)
     * @since 3.3
     */
    void internalToString(StringBuffer buffer, int indent) {
        super.internalToString(buffer, indent);
        buffer.append(" <<").append(fText); //$NON-NLS-1$
    }
}
