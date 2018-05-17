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
module dwtx.text.edits.CopyTargetEdit;

import dwtx.text.edits.MultiTextEdit; // packageimport
import dwtx.text.edits.CopySourceEdit; // packageimport
import dwtx.text.edits.MoveSourceEdit; // packageimport
import dwtx.text.edits.CopyingRangeMarker; // packageimport
import dwtx.text.edits.ReplaceEdit; // packageimport
import dwtx.text.edits.EditDocument; // packageimport
import dwtx.text.edits.UndoCollector; // packageimport
import dwtx.text.edits.DeleteEdit; // packageimport
import dwtx.text.edits.MoveTargetEdit; // packageimport
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
import dwtx.text.edits.InsertEdit; // packageimport


import dwt.dwthelper.utils;

import dwtx.dwtxhelper.Collection;

import dwtx.core.runtime.Assert;
import dwtx.jface.text.BadLocationException;
import dwtx.jface.text.IDocument;

/**
 * A copy target edit denotes the target of a copy operation. Copy
 * target edits are only valid inside an edit tree if they have a
 * corresponding source edit. Furthermore a target edit can't
 * can't be a direct or indirect child of the associated source edit.
 * Violating one of two requirements will result in a <code>
 * MalformedTreeException</code> when executing the edit tree.
 * <p>
 * Copy target edits can't be used as a parent for other edits.
 * Trying to add an edit to a copy target edit results in a <code>
 * MalformedTreeException</code> as well.
 *
 * @see dwtx.text.edits.CopySourceEdit
 *
 * @since 3.0
 */
public final class CopyTargetEdit : TextEdit {

    private CopySourceEdit fSource;

    /**
     * Constructs a new copy target edit
     *
     * @param offset the edit's offset
     */
    public this(int offset) {
        super(offset, 0);
    }

    /**
     * Constructs an new copy target edit
     *
     * @param offset the edit's offset
     * @param source the corresponding source edit
     */
    public this(int offset, CopySourceEdit source) {
        this(offset);
        setSourceEdit(source);
    }

    /*
     * Copy constructor
     */
    private this(CopyTargetEdit other) {
        super(other);
    }

    /**
     * Returns the associated source edit or <code>null</code>
     * if no source edit is associated yet.
     *
     * @return the source edit or <code>null</code>
     */
    public CopySourceEdit getSourceEdit() {
        return fSource;
    }

    /**
     * Sets the source edit.
     *
     * @param edit the source edit
     *
     * @exception MalformedTreeException is thrown if the target edit
     *  is a direct or indirect child of the source edit
     */
    public void setSourceEdit(CopySourceEdit edit)  {
        Assert.isNotNull(edit);
        if (fSource !is edit) {
            fSource= edit;
            fSource.setTargetEdit(this);
            TextEdit parent= getParent();
            while (parent !is null) {
                if (parent is fSource)
                    throw new MalformedTreeException(parent, this, TextEditMessages.getString("CopyTargetEdit.wrong_parent")); //$NON-NLS-1$
                parent= parent.getParent();
            }
        }
    }

    /*
     * @see TextEdit#doCopy
     */
    protected TextEdit doCopy() {
        return new CopyTargetEdit(this);
    }

    /*
     * @see TextEdit#postProcessCopy
     */
    protected void postProcessCopy(TextEditCopier copier) {
        if (fSource !is null) {
            CopyTargetEdit target= cast(CopyTargetEdit)copier.getCopy(this);
            CopySourceEdit source= cast(CopySourceEdit)copier.getCopy(fSource);
            if (target !is null && source !is null)
                target.setSourceEdit(source);
        }
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
     * @see TextEdit#traverseConsistencyCheck
     */
    int traverseConsistencyCheck(TextEditProcessor processor, IDocument document, List sourceEdits) {
        return super.traverseConsistencyCheck(processor, document, sourceEdits) + 1;
    }

    /*
     * @see TextEdit#performConsistencyCheck
     */
    void performConsistencyCheck(TextEditProcessor processor, IDocument document)  {
        if (fSource is null)
            throw new MalformedTreeException(getParent(), this, TextEditMessages.getString("CopyTargetEdit.no_source")); //$NON-NLS-1$
        if (fSource.getTargetEdit() !is this)
            throw new MalformedTreeException(getParent(), this, TextEditMessages.getString("CopyTargetEdit.different_target")); //$NON-NLS-1$
    }

    /*
     * @see TextEdit#performDocumentUpdating
     */
    int performDocumentUpdating(IDocument document)  {
        String source= fSource.getContent();
        document.replace(getOffset(), getLength(), source);
        fDelta= source.length() - getLength();
        fSource.clearContent();
        return fDelta;
    }

    /*
     * @see TextEdit#deleteChildren
     */
    bool deleteChildren() {
        return false;
    }
}
