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
module dwtx.text.edits.MultiTextEdit;

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
import dwtx.text.edits.InsertEdit; // packageimport

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;

import dwtx.core.runtime.Assert;
import dwtx.jface.text.BadLocationException;
import dwtx.jface.text.IDocument;
import dwtx.jface.text.IRegion;

/**
 * A multi-text edit can be used to aggregate several edits into
 * one edit. The edit itself doesn't modify a document.
 * <p>
 * Clients are allowed to implement subclasses of a multi-text
 * edit.Subclasses must implement <code>doCopy()</code> to ensure
 * the a copy of the right type is created. Not implementing
 * <code>doCopy()</code> in subclasses will result in an assertion
 * failure during copying.
 *
 * @since 3.0
 */
public class MultiTextEdit : TextEdit {

    private bool fDefined;

    /**
     * Creates a new <code>MultiTextEdit</code>. The range
     * of the edit is determined by the range of its children.
     *
     * Adding this edit to a parent edit sets its range to the
     * range covered by its children. If the edit doesn't have
     * any children its offset is set to the parent's offset
     * and its length is set to 0.
     */
    public this() {
        super(0, Integer.MAX_VALUE);
        fDefined= false;
    }

    /**
     * Creates a new </code>MultiTextEdit</code> for the given
     * range. Adding a child to this edit which isn't covered
     * by the given range will result in an exception.
     *
     * @param offset the edit's offset
     * @param length the edit's length.
     * @see TextEdit#addChild(TextEdit)
     * @see TextEdit#addChildren(TextEdit[])
     */
    public this(int offset, int length) {
        super(offset, length);
        fDefined= true;
    }

    /*
     * Copy constructor.
     */
    protected this(MultiTextEdit other) {
        super(other);
    }

    /**
     * Checks the edit's integrity.
     * <p>
     * Note that this method <b>should only be called</b> by the edit
     * framework and not by normal clients.</p>
     *<p>
     * This default implementation does nothing. Subclasses may override
     * if needed.</p>
     *
     * @exception MalformedTreeException if the edit isn't in a valid state
     *  and can therefore not be executed
     */
    protected void checkIntegrity()  {
        // does nothing
    }

    /**
     * {@inheritDoc}
     */
    final bool isDefined() {
        if (fDefined)
            return true;
        return hasChildren();
    }

    /**
     * {@inheritDoc}
     */
    public final int getOffset() {
        if (fDefined)
            return super.getOffset();

        List/*<TextEdit>*/ children= internalGetChildren();
        if (children is null || children.size() is 0)
            return 0;
        // the children are already sorted
        return (cast(TextEdit)children.get(0)).getOffset();
    }

    /**
     * {@inheritDoc}
     */
    public final int getLength() {
        if (fDefined)
            return super.getLength();

        List/*<TextEdit>*/ children= internalGetChildren();
        if (children is null || children.size() is 0)
            return 0;
        // the children are already sorted
        TextEdit first= cast(TextEdit)children.get(0);
        TextEdit last= cast(TextEdit)children.get(children.size() - 1);
        return last.getOffset() - first.getOffset() + last.getLength();
    }

    /**
     * {@inheritDoc}
     */
    public final bool covers(TextEdit other) {
        if (fDefined)
            return super.covers(other);
        // an undefined multiple text edit covers everything
        return true;
    }

    /*
     * @see dwtx.text.edits.TextEdit#canZeroLengthCover()
     */
    protected bool canZeroLengthCover() {
        return true;
    }

    /*
     * @see TextEdit#copy
     */
    protected TextEdit doCopy() {
        Assert.isTrue(MultiTextEdit.classinfo is this.classinfo, "Subclasses must reimplement copy0"); //$NON-NLS-1$
        return new MultiTextEdit(this);
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
     * @see dwtx.text.edits.TextEdit#adjustOffset(int)
     * @since 3.1
     */
    void adjustOffset(int delta) {
        if (fDefined)
            super.adjustOffset(delta);
    }

    /*
     * @see dwtx.text.edits.TextEdit#adjustLength(int)
     * @since 3.1
     */
    void adjustLength(int delta) {
        if (fDefined)
            super.adjustLength(delta);
    }

    /*
     * @see TextEdit#performConsistencyCheck
     */
    void performConsistencyCheck(TextEditProcessor processor, IDocument document)  {
        checkIntegrity();
    }

    /*
     * @see TextEdit#performDocumentUpdating
     */
    int performDocumentUpdating(IDocument document)  {
        fDelta= 0;
        return fDelta;
    }

    /*
     * @see TextEdit#deleteChildren
     */
    bool deleteChildren() {
        return false;
    }

    void aboutToBeAdded(TextEdit parent) {
        defineRegion(parent.getOffset());
    }

    void defineRegion(int parentOffset) {
        if (fDefined)
            return;
        if (hasChildren()) {
            IRegion region= getCoverage(getChildren());
            internalSetOffset(region.getOffset());
            internalSetLength(region.getLength());
        } else {
            internalSetOffset(parentOffset);
            internalSetLength(0);
        }
        fDefined= true;
    }

    /*
     * @see dwtx.text.edits.TextEdit#internalToString(java.lang.StringBuffer, int)
     * @since 3.3
     */
    void internalToString(StringBuffer buffer, int indent) {
        super.internalToString(buffer, indent);
        if (! fDefined)
            buffer.append(" [undefined]"); //$NON-NLS-1$
    }
}
