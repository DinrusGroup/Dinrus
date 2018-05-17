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
module dwtx.text.edits.CopySourceEdit;

import dwtx.text.edits.MoveSourceEdit; // packageimport
import dwtx.text.edits.MoveTargetEdit; // packageimport
import dwtx.text.edits.CopyTargetEdit; // packageimport
import dwtx.text.edits.TextEditCopier; // packageimport
import dwtx.text.edits.ISourceModifier; // packageimport
import dwtx.text.edits.TextEditProcessor; // packageimport
import dwtx.text.edits.TextEditVisitor; // packageimport
import dwtx.text.edits.TextEdit; // packageimport
import dwtx.text.edits.RangeMarker; // packageimport
import dwtx.text.edits.InsertEdit; // packageimport
import dwtx.text.edits.DeleteEdit; // packageimport
import dwtx.text.edits.MalformedTreeException; // packageimport
import dwtx.text.edits.TextEditMessages; // packageimport
import dwtx.text.edits.MultiTextEdit; // packageimport
import dwtx.text.edits.EditDocument; // packageimport
import dwtx.text.edits.ReplaceEdit; // packageimport

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;

import dwtx.core.runtime.Assert;
import dwtx.jface.text.BadLocationException;
import dwtx.jface.text.IDocument;

/**
 * A copy source edit denotes the source of a copy operation. Copy
 * source edits are only valid inside an edit tree if they have a
 * corresponding target edit. Furthermore the corresponding
 * target edit can't be a direct or indirect child of the source
 * edit. Violating one of two requirements will result in a <code>
 * MalformedTreeException</code> when executing the edit tree.
 * <p>
 * A copy source edit can manage an optional source modifier. A
 * source modifier can provide a set of replace edits which will
 * to applied to the source before it gets inserted at the target
 * position.
 *
 * @see dwtx.text.edits.CopyTargetEdit
 *
 * @since 3.0
 */
public final class CopySourceEdit : TextEdit {

    private CopyTargetEdit fTarget;
    private ISourceModifier fModifier;

    private String fSourceContent;
    private TextEdit fSourceRoot;

    private static class PartialCopier : TextEditVisitor {
        TextEdit fResult;
        List fParents;
        TextEdit fCurrentParent;
        public this(){
            fParents= new ArrayList();
        }
        public static TextEdit perform(TextEdit source) {
            PartialCopier copier= new PartialCopier();
            source.accept(copier);
            return copier.fResult;
        }
        private void manageCopy(TextEdit copy) {
            if (fResult is null)
                fResult= copy;
            if (fCurrentParent !is null) {
                fCurrentParent.addChild(copy);
            }
            fParents.add(fCurrentParent);
            fCurrentParent= copy;
        }
        public void postVisit(TextEdit edit) {
            fCurrentParent= cast(TextEdit)fParents.remove(fParents.size() - 1);
        }
        public bool visitNode(TextEdit edit) {
            manageCopy(edit.doCopy_package());
            return true;
        }
        public bool visit(CopySourceEdit edit) {
            manageCopy(new RangeMarker(edit.getOffset(), edit.getLength()));
            return true;
        }
        public bool visit(CopyTargetEdit edit) {
            manageCopy(new InsertEdit(edit.getOffset(), edit.getSourceEdit().getContent()));
            return true;
        }
        public bool visit(MoveSourceEdit edit) {
            manageCopy(new DeleteEdit(edit.getOffset(), edit.getLength()));
            return true;
        }
        public bool visit(MoveTargetEdit edit) {
            manageCopy(new InsertEdit(edit.getOffset(), edit.getSourceEdit().getContent()));
            return true;
        }
    }

    /**
     * Constructs a new copy source edit.
     *
     * @param offset the edit's offset
     * @param length the edit's length
     */
    public this(int offset, int length) {
        super(offset, length);
    }

    /**
     * Constructs a new copy source edit.
     *
     * @param offset the edit's offset
     * @param length the edit's length
     * @param target the edit's target
     */
    public this(int offset, int length, CopyTargetEdit target) {
        this(offset, length);
        setTargetEdit(target);
    }

    /*
     * Copy Constructor
     */
    private this(CopySourceEdit other) {
        super(other);
        if (other.fModifier !is null)
            fModifier= other.fModifier.copy();
    }

    /**
     * Returns the associated target edit or <code>null</code>
     * if no target edit is associated yet.
     *
     * @return the target edit or <code>null</code>
     */
    public CopyTargetEdit getTargetEdit() {
        return fTarget;
    }

    /**
     * Sets the target edit.
     *
     * @param edit the new target edit.
     *
     * @exception MalformedTreeException is thrown if the target edit
     *  is a direct or indirect child of the source edit
     */
    public void setTargetEdit(CopyTargetEdit edit)  {
        Assert.isNotNull(edit);
        if (fTarget !is edit) {
            fTarget= edit;
            fTarget.setSourceEdit(this);
        }
    }

    /**
     * Returns the current source modifier or <code>null</code>
     * if no source modifier is set.
     *
     * @return the source modifier
     */
    public ISourceModifier getSourceModifier() {
        return fModifier;
    }

    /**
     * Sets the optional source modifier.
     *
     * @param modifier the source modifier or <code>null</code>
     *  if no source modification is need.
     */
    public void setSourceModifier(ISourceModifier modifier) {
        fModifier= modifier;
    }

    /*
     * @see TextEdit#doCopy
     */
    protected TextEdit doCopy() {
        return new CopySourceEdit(this);
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

    //---- API for CopyTargetEdit ------------------------------------------------

    String getContent() {
        // The source content can be null if the edit wasn't executed
        // due to an exclusion list of the text edit processor. Return
        // the empty string which can be moved without any harm.
        if (fSourceContent is null)
            return ""; //$NON-NLS-1$
        return fSourceContent;
    }

    void clearContent() {
        fSourceContent= null;
    }

    /*
     * @see TextEdit#postProcessCopy
     */
    protected void postProcessCopy(TextEditCopier copier) {
        if (fTarget !is null) {
            CopySourceEdit source= cast(CopySourceEdit)copier.getCopy(this);
            CopyTargetEdit target= cast(CopyTargetEdit)copier.getCopy(fTarget);
            if (source !is null && target !is null)
                source.setTargetEdit(target);
        }
    }

    //---- consistency check ----------------------------------------------------

    int traverseConsistencyCheck(TextEditProcessor processor, IDocument document, List sourceEdits) {
        int result= super.traverseConsistencyCheck(processor, document, sourceEdits);
        // Since source computation takes place in a recursive fashion (see
        // performSourceComputation) we only do something if we don't have a
        // computed source already.
        if (fSourceContent is null) {
            if (sourceEdits.size() <= result) {
                List list= new ArrayList();
                list.add(this);
                for (int i= sourceEdits.size(); i < result; i++)
                    sourceEdits.add(cast(Object)null);
                sourceEdits.add(cast(Object)list);
            } else {
                List list= cast(List)sourceEdits.get(result);
                if (list is null) {
                    list= new ArrayList();
                    sourceEdits.add(result, cast(Object)list);
                }
                list.add(this);
            }
        }
        return result;
    }

    void performConsistencyCheck(TextEditProcessor processor, IDocument document)  {
        if (fTarget is null)
            throw new MalformedTreeException(getParent(), this, TextEditMessages.getString("CopySourceEdit.no_target")); //$NON-NLS-1$
        if (fTarget.getSourceEdit() !is this)
            throw new MalformedTreeException(getParent(), this, TextEditMessages.getString("CopySourceEdit.different_source")); //$NON-NLS-1$
        /* causes ASTRewrite to fail
        if (getRoot() !is fTarget.getRoot())
            throw new MalformedTreeException(getParent(), this, TextEditMessages.getString("CopySourceEdit.different_tree")); //$NON-NLS-1$
        */
    }

    //---- source computation -------------------------------------------------------

    void traverseSourceComputation(TextEditProcessor processor, IDocument document) {
        // always perform source computation independent of processor.considerEdit
        // The target might need the source and the source is computed in a
        // temporary buffer.
        performSourceComputation(processor, document);
    }

    void performSourceComputation(TextEditProcessor processor, IDocument document) {
        try {
            MultiTextEdit root= new MultiTextEdit(getOffset(), getLength());
            root.internalSetChildren(internalGetChildren());
            fSourceContent= document.get(getOffset(), getLength());
            fSourceRoot= PartialCopier.perform(root);
            fSourceRoot.internalMoveTree(-getOffset());
            if (fSourceRoot.hasChildren()) {
                EditDocument subDocument= new EditDocument(fSourceContent);
                TextEditProcessor subProcessor= TextEditProcessor.createSourceComputationProcessor(subDocument, fSourceRoot, TextEdit.NONE);
                subProcessor.performEdits();
                if (needsTransformation())
                    applyTransformation(subDocument);
                fSourceContent= subDocument.get();
                fSourceRoot= null;
            } else {
                if (needsTransformation()) {
                    EditDocument subDocument= new EditDocument(fSourceContent);
                    applyTransformation(subDocument);
                    fSourceContent= subDocument.get();
                }
            }
        } catch (BadLocationException cannotHappen) {
            Assert.isTrue(false);
        }
    }

    private bool needsTransformation() {
        return fModifier !is null;
    }

    private void applyTransformation(IDocument document)  {
        TextEdit newEdit= new MultiTextEdit(0, document.getLength());
        ReplaceEdit[] replaces= fModifier.getModifications(document.get());
        for (int i= 0; i < replaces.length; i++) {
            newEdit.addChild(replaces[i]);
        }
        try {
            newEdit.apply(document, TextEdit.NONE);
        } catch (BadLocationException cannotHappen) {
            Assert.isTrue(false);
        }
    }

    //---- document updating ----------------------------------------------------------------

    int performDocumentUpdating(IDocument document)  {
        fDelta= 0;
        return fDelta;
    }

    //---- region updating ----------------------------------------------------------------

    /*
     * @see TextEdit#deleteChildren
     */
    bool deleteChildren() {
        return false;
    }
}
