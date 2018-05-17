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
module dwtx.text.edits.MoveTargetEdit;

import dwtx.text.edits.MultiTextEdit; // packageimport
import dwtx.text.edits.CopySourceEdit; // packageimport
import dwtx.text.edits.MoveSourceEdit; // packageimport
import dwtx.text.edits.CopyingRangeMarker; // packageimport
import dwtx.text.edits.ReplaceEdit; // packageimport
import dwtx.text.edits.EditDocument; // packageimport
import dwtx.text.edits.UndoCollector; // packageimport
import dwtx.text.edits.DeleteEdit; // packageimport
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
import dwtx.text.edits.InsertEdit; // packageimport


import dwt.dwthelper.utils;

import dwtx.dwtxhelper.Collection;


import dwtx.jface.text.BadLocationException;
import dwtx.jface.text.IDocument;

/**
 * A move target edit denotes the target of a move operation. Move
 * target edits are only valid inside an edit tree if they have a
 * corresponding source edit. Furthermore a target edit can't
 * can't be a direct or indirect child of its associated source edit.
 * Violating one of two requirements will result in a <code>
 * MalformedTreeException</code> when executing the edit tree.
 * <p>
 * Move target edits can't be used as a parent for other edits.
 * Trying to add an edit to a move target edit results in a <code>
 * MalformedTreeException</code> as well.
 *
 * @see dwtx.text.edits.MoveSourceEdit
 * @see dwtx.text.edits.CopyTargetEdit
 *
 * @since 3.0
 */
public final class MoveTargetEdit : TextEdit {

    private MoveSourceEdit fSource;

    /**
     * Constructs a new move target edit
     *
     * @param offset the edit's offset
     */
    public this(int offset) {
        super(offset, 0);
    }

    /**
     * Constructs an new move target edit
     *
     * @param offset the edit's offset
     * @param source the corresponding source edit
     */
    public this(int offset, MoveSourceEdit source) {
        this(offset);
        setSourceEdit(source);
    }

    /*
     * Copy constructor
     */
    private this(MoveTargetEdit other) {
        super(other);
    }

    /**
     * Returns the associated source edit or <code>null</code>
     * if no source edit is associated yet.
     *
     * @return the source edit or <code>null</code>
     */
    public MoveSourceEdit getSourceEdit() {
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
    public void setSourceEdit(MoveSourceEdit edit) {
        if (fSource !is edit) {
            fSource= edit;
            fSource.setTargetEdit(this);
            TextEdit parent= getParent();
            while (parent !is null) {
                if (parent is fSource)
                    throw new MalformedTreeException(parent, this, TextEditMessages.getString("MoveTargetEdit.wrong_parent")); //$NON-NLS-1$
                parent= parent.getParent();
            }
        }
    }

    /*
     * @see TextEdit#doCopy
     */
    protected TextEdit doCopy() {
        return new MoveTargetEdit(this);
    }

    /*
     * @see TextEdit#postProcessCopy
     */
    protected void postProcessCopy(TextEditCopier copier) {
        if (fSource !is null) {
            MoveTargetEdit target= cast(MoveTargetEdit)copier.getCopy(this);
            MoveSourceEdit source= cast(MoveSourceEdit)copier.getCopy(fSource);
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

    //---- consistency check ----------------------------------------------------------

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
            throw new MalformedTreeException(getParent(), this, TextEditMessages.getString("MoveTargetEdit.no_source")); //$NON-NLS-1$
        if (fSource.getTargetEdit() !is this)
            throw new MalformedTreeException(getParent(), this, TextEditMessages.getString("MoveTargetEdit.different_target")); //$NON-NLS-1$
    }

    //---- document updating ----------------------------------------------------------------

    /*
     * @see TextEdit#performDocumentUpdating
     */
    int performDocumentUpdating(IDocument document)  {
        String source= fSource.getContent();
        document.replace(getOffset(), getLength(), source);
        fDelta= source.length() - getLength();

        MultiTextEdit sourceRoot= fSource.getSourceRoot();
        if (sourceRoot !is null) {
            sourceRoot.internalMoveTree(getOffset());
            TextEdit[] sourceChildren= sourceRoot.removeChildren();
            List children= new ArrayList(sourceChildren.length);
            for (int i= 0; i < sourceChildren.length; i++) {
                TextEdit child= sourceChildren[i];
                child.internalSetParent(this);
                children.add(child);
            }
            internalSetChildren(children);
        }
        fSource.clearContent();
        return fDelta;
    }

    //---- region updating --------------------------------------------------------------

    /*
     * @see dwtx.text.edits.TextEdit#traversePassThree
     */
    int traverseRegionUpdating(TextEditProcessor processor, IDocument document, int accumulatedDelta, bool delete_) {
        // the children got already updated / normalized while they got removed
        // from the source edit. So we only have to adjust the offset computed to
        // far.
        if (delete_) {
            deleteTree();
        } else {
            internalMoveTree(accumulatedDelta);
        }
        return accumulatedDelta + fDelta;
    }

    bool deleteChildren() {
        return false;
    }
}
