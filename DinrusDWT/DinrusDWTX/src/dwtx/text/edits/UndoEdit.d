/*******************************************************************************
 * Copyright (c) 2000, 2008 IBM Corporation and others.
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
module dwtx.text.edits.UndoEdit;

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
import dwtx.text.edits.InsertEdit; // packageimport


import dwt.dwthelper.utils;

import dwtx.dwtxhelper.Collection;


import dwtx.jface.text.BadLocationException;
import dwtx.jface.text.IDocument;


/**
 * This class encapsulates the reverse changes of an executed text
 * edit tree. To apply an undo memento to a document use method
 * <code>apply(IDocument)</code>.
 * <p>
 * Clients can't add additional children to an undo edit nor can they
 * add an undo edit as a child to another edit. Doing so results in
 * both cases in a <code>MalformedTreeException<code>.
 *
 * @since 3.0
 * @noinstantiate This class is not intended to be instantiated by clients.
 */
public final class UndoEdit : TextEdit {

    this() {
        super(0, Integer.MAX_VALUE);
    }

    private this(UndoEdit other) {
        super(other);
    }

    /*
     * @see dwtx.text.edits.TextEdit#internalAdd(dwtx.text.edits.TextEdit)
     */
    void internalAdd(TextEdit child)  {
        throw new MalformedTreeException(null, this, TextEditMessages.getString("UndoEdit.no_children")); //$NON-NLS-1$
    }

    /*
     * @see dwtx.text.edits.MultiTextEdit#aboutToBeAdded(dwtx.text.edits.TextEdit)
     */
    void aboutToBeAdded(TextEdit parent) {
        throw new MalformedTreeException(parent, this, TextEditMessages.getString("UndoEdit.can_not_be_added")); //$NON-NLS-1$
    }

    UndoEdit dispatchPerformEdits(TextEditProcessor processor)  {
        return processor.executeUndo();
    }

    void dispatchCheckIntegrity(TextEditProcessor processor)  {
        processor.checkIntegrityUndo();
    }

    /*
     * @see dwtx.text.edits.TextEdit#doCopy()
     */
    protected TextEdit doCopy() {
        return new UndoEdit(this);
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
        fDelta= 0;
        return fDelta;
    }

    void add(ReplaceEdit edit) {
        List children= internalGetChildren();
        if (children is null) {
            children= new ArrayList(2);
            internalSetChildren(children);
        }
        children.add(edit);
    }

    void defineRegion(int offset, int length) {
        internalSetOffset(offset);
        internalSetLength(length);
    }

    bool deleteChildren() {
        return false;
    }
}

