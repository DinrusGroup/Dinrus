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
module dwtx.text.edits.MoveSourceEdit;

import dwtx.text.edits.MultiTextEdit; // packageimport
import dwtx.text.edits.CopySourceEdit; // packageimport
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
import dwtx.text.edits.InsertEdit; // packageimport


import dwt.dwthelper.utils;

import dwtx.dwtxhelper.Collection;






import dwtx.core.runtime.Assert;
import dwtx.jface.text.BadLocationException;
import dwtx.jface.text.IDocument;
import dwtx.jface.text.IRegion;
import dwtx.jface.text.Region;

/**
 * A move source edit denotes the source of a move operation. Move
 * source edits are only valid inside an edit tree if they have a
 * corresponding target edit. Furthermore the corresponding target
 * edit can't be a direct or indirect child of the source edit.
 * Violating one of two requirements will result in a <code>
 * MalformedTreeException</code> when executing the edit tree.
 * <p>
 * A move source edit can manage an optional source modifier. A
 * source modifier can provide a set of replace edits which will
 * to applied to the source before it gets inserted at the target
 * position.
 *
 * @see dwtx.text.edits.MoveTargetEdit
 * @see dwtx.text.edits.CopySourceEdit
 *
 * @since 3.0
 */
public final class MoveSourceEdit : TextEdit {

    private MoveTargetEdit fTarget;
    private ISourceModifier fModifier;

    private String fSourceContent;
    private MultiTextEdit fSourceRoot;

    /**
     * Constructs a new move source edit.
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
    public this(int offset, int length, MoveTargetEdit target) {
        this(offset, length);
        setTargetEdit(target);
    }

    /*
     * Copy constructor
     */
    private this(MoveSourceEdit other) {
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
    public MoveTargetEdit getTargetEdit() {
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
    public void setTargetEdit(MoveTargetEdit edit) {
        fTarget= edit;
        fTarget.setSourceEdit(this);
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

    //---- API for MoveTargetEdit ---------------------------------------------

    String getContent() {
        // The source content can be null if the edit wasn't executed
        // due to an exclusion list of the text edit processor. Return
        // the empty string which can be moved without any harm.
        if (fSourceContent is null)
            return ""; //$NON-NLS-1$
        return fSourceContent;
    }

    MultiTextEdit getSourceRoot() {
        return fSourceRoot;
    }

    void clearContent() {
        fSourceContent= null;
        fSourceRoot= null;
    }

    //---- Copying -------------------------------------------------------------

    /*
     * @see TextEdit#doCopy
     */
    protected TextEdit doCopy() {
        return new MoveSourceEdit(this);
    }

    /*
     * @see TextEdit#postProcessCopy
     */
    protected void postProcessCopy(TextEditCopier copier) {
        if (fTarget !is null) {
            MoveSourceEdit source= cast(MoveSourceEdit)copier.getCopy(this);
            MoveTargetEdit target= cast(MoveTargetEdit)copier.getCopy(fTarget);
            if (source !is null && target !is null)
                source.setTargetEdit(target);
        }
    }

    //---- Visitor -------------------------------------------------------------

    /*
     * @see TextEdit#accept0
     */
    protected void accept0(TextEditVisitor visitor) {
        bool visitChildren= visitor.visit(this);
        if (visitChildren) {
            acceptChildren(visitor);
        }
    }

    //---- consistency check ----------------------------------------------------------------

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
            throw new MalformedTreeException(getParent(), this, TextEditMessages.getString("MoveSourceEdit.no_target")); //$NON-NLS-1$
        if (fTarget.getSourceEdit() !is this)
            throw new MalformedTreeException(getParent(), this, TextEditMessages.getString("MoveSourceEdit.different_source"));  //$NON-NLS-1$
        /* Causes AST rewrite to fail
        if (getRoot() !is fTarget.getRoot())
            throw new MalformedTreeException(getParent(), this, TextEditMessages.getString("MoveSourceEdit.different_tree")); //$NON-NLS-1$
        */
    }

    //---- source computation --------------------------------------------------------------

    void traverseSourceComputation(TextEditProcessor processor, IDocument document) {
        // always perform source computation independent of processor.considerEdit
        // The target might need the source and the source is computed in a
        // temporary buffer.
        performSourceComputation(processor, document);
    }

    void performSourceComputation(TextEditProcessor processor, IDocument document) {
        try {
            TextEdit[] children= removeChildren();
            if (children.length > 0) {
                String content= document.get(getOffset(), getLength());
                EditDocument subDocument= new EditDocument(content);
                fSourceRoot= new MultiTextEdit(getOffset(), getLength());
                fSourceRoot.addChildren(children);
                fSourceRoot.internalMoveTree(-getOffset());
                int processingStyle= getStyle(processor);
                TextEditProcessor subProcessor= TextEditProcessor.createSourceComputationProcessor(subDocument, fSourceRoot, processingStyle);
                subProcessor.performEdits();
                if (needsTransformation())
                    applyTransformation(subDocument, processingStyle);
                fSourceContent= subDocument.get();
            } else {
                fSourceContent= document.get(getOffset(), getLength());
                if (needsTransformation()) {
                    EditDocument subDocument= new EditDocument(fSourceContent);
                    applyTransformation(subDocument, getStyle(processor));
                    fSourceContent= subDocument.get();
                }
            }
        } catch (BadLocationException cannotHappen) {
            Assert.isTrue(false);
        }
    }

    private int getStyle(TextEditProcessor processor) {
        // we never need undo while performing local edits.
        if ((processor.getStyle() & TextEdit.UPDATE_REGIONS) !is 0)
            return TextEdit.UPDATE_REGIONS;
        return TextEdit.NONE;
    }

    //---- document updating ----------------------------------------------------------------

    int performDocumentUpdating(IDocument document)  {
        document.replace(getOffset(), getLength(), ""); //$NON-NLS-1$
        fDelta= -getLength();
        return fDelta;
    }

    //---- region updating --------------------------------------------------------------

    /*
     * @see TextEdit#deleteChildren
     */
    bool deleteChildren() {
        return false;
    }

    //---- content transformation --------------------------------------------------

    private bool needsTransformation() {
        return fModifier !is null;
    }

    private void applyTransformation(IDocument document, int style)  {
        if ((style & TextEdit.UPDATE_REGIONS) !is 0 && fSourceRoot !is null) {
            Map editMap= new HashMap();
            TextEdit newEdit= createEdit(editMap);
            List replaces= new ArrayList(Arrays.asList(fModifier.getModifications(document.get())));
            insertEdits(newEdit, replaces);
            try {
                newEdit.apply(document, style);
            } catch (BadLocationException cannotHappen) {
                Assert.isTrue(false);
            }
            restorePositions(editMap);
        } else {
            MultiTextEdit newEdit= new MultiTextEdit(0, document.getLength());
            TextEdit[] replaces= fModifier.getModifications(document.get());
            for (int i= 0; i < replaces.length; i++) {
                newEdit.addChild(replaces[i]);
            }
            try {
                newEdit.apply(document, style);
            } catch (BadLocationException cannotHappen) {
                Assert.isTrue(false);
            }
        }
    }

    private TextEdit createEdit(Map editMap) {
        MultiTextEdit result= new MultiTextEdit(0, fSourceRoot.getLength());
        editMap.put(result, fSourceRoot);
        createEdit(fSourceRoot, result, editMap);
        return result;
    }

    private static void createEdit(TextEdit source, TextEdit target, Map editMap) {
        TextEdit[] children= source.getChildren();
        for (int i= 0; i < children.length; i++) {
            TextEdit child= children[i];
            // a deleted child remains deleted even if the temporary buffer
            // gets modified.
            if (child.isDeleted())
                continue;
            RangeMarker marker= new RangeMarker(child.getOffset(), child.getLength());
            target.addChild(marker);
            editMap.put(marker, child);
            createEdit(child, marker, editMap);
        }
    }

    private void insertEdits(TextEdit root, List edits) {
        while(edits.size() > 0) {
            ReplaceEdit edit= cast(ReplaceEdit)edits.remove(0);
            insert(root, edit, edits);
        }
    }
    private static void insert(TextEdit parent, ReplaceEdit edit, List edits) {
        if (!parent.hasChildren()) {
            parent.addChild(edit);
            return;
        }
        TextEdit[] children= parent.getChildren();
        // First dive down to find the right parent.
        int removed= 0;
        for (int i= 0; i < children.length; i++) {
            TextEdit child= children[i];
            if (child.covers(edit)) {
                insert(child, edit, edits);
                return;
            } else if (edit.covers(child)) {
                parent.removeChild(i - removed++);
                edit.addChild(child);
            } else {
                IRegion intersect= intersect(edit, child);
                if (intersect !is null) {
                    ReplaceEdit[] splits= splitEdit(edit, intersect);
                    insert(child, splits[0], edits);
                    edits.add(splits[1]);
                    return;
                }
            }
        }
        parent.addChild(edit);
    }

    public static IRegion intersect(TextEdit op1, TextEdit op2) {
        int offset1= op1.getOffset();
        int length1= op1.getLength();
        int end1= offset1 + length1 - 1;
        int offset2= op2.getOffset();
        if (end1 < offset2)
            return null;
        int length2= op2.getLength();
        int end2= offset2 + length2 - 1;
        if (end2 < offset1)
            return null;

        int end= Math.min(end1, end2);
        if (offset1 < offset2) {
            return new Region(offset2, end - offset2 + 1);
        }
        return new Region(offset1, end - offset1 + 1);
    }

    private static ReplaceEdit[] splitEdit(ReplaceEdit edit, IRegion intersect) {
        if (edit.getOffset() !is intersect.getOffset())
            return splitIntersectRight(edit, intersect);
        return splitIntersectLeft(edit, intersect);
    }

    private static ReplaceEdit[] splitIntersectRight(ReplaceEdit edit, IRegion intersect) {
        ReplaceEdit[] result= new ReplaceEdit[2];
        // this is the actual delete. We use replace to only deal with one type
        result[0]= new ReplaceEdit(intersect.getOffset(), intersect.getLength(), ""); //$NON-NLS-1$
        result[1]= new ReplaceEdit(
                            edit.getOffset(),
                            intersect.getOffset() - edit.getOffset(),
                            edit.getText());
        return result;
    }

    private static ReplaceEdit[] splitIntersectLeft(ReplaceEdit edit, IRegion intersect) {
        ReplaceEdit[] result= new ReplaceEdit[2];
        result[0]= new ReplaceEdit(intersect.getOffset(), intersect.getLength(), edit.getText());
        result[1]= new ReplaceEdit( // this is the actual delete. We use replace to only deal with one type
                            intersect.getOffset() + intersect.getLength(),
                            edit.getLength() - intersect.getLength(),
                            ""); //$NON-NLS-1$
        return result;
    }

    private static void restorePositions(Map editMap) {
        for (Iterator iter= editMap.keySet().iterator(); iter.hasNext();) {
            TextEdit marker= cast(TextEdit)iter.next();
            TextEdit edit= cast(TextEdit)editMap.get(marker);
            if (marker.isDeleted()) {
                edit.markAsDeleted();
            } else {
                edit.adjustOffset(marker.getOffset() - edit.getOffset());
                edit.adjustLength(marker.getLength() - edit.getLength());
            }
        }
    }
}
