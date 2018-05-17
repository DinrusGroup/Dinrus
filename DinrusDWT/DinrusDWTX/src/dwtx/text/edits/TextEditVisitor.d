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
module dwtx.text.edits.TextEditVisitor;

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
import dwtx.text.edits.TextEditGroup; // packageimport
import dwtx.text.edits.TextEdit; // packageimport
import dwtx.text.edits.RangeMarker; // packageimport
import dwtx.text.edits.UndoEdit; // packageimport
import dwtx.text.edits.InsertEdit; // packageimport


import dwt.dwthelper.utils;

/**
 * A visitor for text edits.
 * <p>
 * For each different concrete text edit type <it>T</it> there is a method:
 * <ul>
 *   <li><code>public bool visit(<it>T</it> node)</code> - Visits the given edit to
 *   perform some arbitrary operation. If <code>true </code> is returned, the given edit's
 *   child edits will be visited next; however, if <code>false</code> is returned, the
 *   given edit's child edits will not be visited. The default implementation provided by
 *   this class calls a generic method <code>visitNode(<it>TextEdit</it> node)</code>.
 *   Subclasses may reimplement these method as needed.</li>
 * </ul>
 * </p>
 * <p>
 * In addition, there are methods for visiting text edits in the
 * abstract, regardless of node type:
 * <ul>
 *   <li><code>public void preVisit(TextEdit edit)</code> - Visits
 *   the given edit to perform some arbitrary operation.
 *   This method is invoked prior to the appropriate type-specific
 *   <code>visit</code> method.
 *   The default implementation of this method does nothing.
 *   Subclasses may reimplement this method as needed.</li>
 *
 *   <li><code>public void postVisit(TextEdit edit)</code> - Visits
 *   the given edit to perform some arbitrary operation.
 *   This method is invoked after the appropriate type-specific
 *   <code>endVisit</code> method.
 *   The default implementation of this method does nothing.
 *   Subclasses may reimplement this method as needed.</li>
 * </ul>
 * </p>
 * <p>
 * For edits with children, the child nodes are visited in increasing order.
 * </p>
 *
 * @see TextEdit#accept(TextEditVisitor)
 * @since 3.0
 */
public class TextEditVisitor {

    /**
     * Visits the given text edit prior to the type-specific visit.
     * (before <code>visit</code>).
     * <p>
     * The default implementation does nothing. Subclasses may reimplement.
     * </p>
     *
     * @param edit the node to visit
     */
    public void preVisit(TextEdit edit) {
        // default implementation: do nothing
    }

    /**
     * Visits the given text edit following the type-specific visit
     * (after <code>endVisit</code>).
     * <p>
     * The default implementation does nothing. Subclasses may reimplement.
     * </p>
     *
     * @param edit the node to visit
     */
    public void postVisit(TextEdit edit) {
        // default implementation: do nothing
    }

    /**
     * Visits the given text edit. This method is called by default from
     * type-specific visits. It is not called by an edit's accept method.
     * The default implementation returns <code>true</code>.
     *
     * @param edit the node to visit
     * @return If <code>true</code> is returned, the given node's child
     *  nodes will be visited next; however, if <code>false</code> is
     *  returned, the given node's child nodes will not be visited.
     */
    public bool visitNode(TextEdit edit) {
        return true;
    }

    /**
     * Visits a <code>CopySourceEdit</code> instance.
     *
     * @param edit the node to visit
     * @return If <code>true</code> is returned, the given node's child
     *  nodes will be visited next; however, if <code>false</code> is
     *  returned, the given node's child nodes will not be visited.
     */
    public bool visit(CopySourceEdit edit) {
        return visitNode(edit);
    }

    /**
     * Visits a <code>CopyTargetEdit</code> instance.
     *
     * @param edit the node to visit
     * @return If <code>true</code> is returned, the given node's child
     *  nodes will be visited next; however, if <code>false</code> is
     *  returned, the given node's child nodes will not be visited.
     */
    public bool visit(CopyTargetEdit edit) {
        return visitNode(edit);
    }

    /**
     * Visits a <code>MoveSourceEdit</code> instance.
     *
     * @param edit the node to visit
     * @return If <code>true</code> is returned, the given node's child
     *  nodes will be visited next; however, if <code>false</code> is
     *  returned, the given node's child nodes will not be visited.
     */
    public bool visit(MoveSourceEdit edit) {
        return visitNode(edit);
    }

    /**
     * Visits a <code>MoveTargetEdit</code> instance.
     *
     * @param edit the node to visit
     * @return If <code>true</code> is returned, the given node's child
     *  nodes will be visited next; however, if <code>false</code> is
     *  returned, the given node's child nodes will not be visited.
     */
    public bool visit(MoveTargetEdit edit) {
        return visitNode(edit);
    }

    /**
     * Visits a <code>RangeMarker</code> instance.
     *
     * @param edit the node to visit
     * @return If <code>true</code> is returned, the given node's child
     *  nodes will be visited next; however, if <code>false</code> is
     *  returned, the given node's child nodes will not be visited.
     */
    public bool visit(RangeMarker edit) {
        return visitNode(edit);
    }

    /**
     * Visits a <code>CopyingRangeMarker</code> instance.
     *
     * @param edit the node to visit
     * @return If <code>true</code> is returned, the given node's child
     *  nodes will be visited next; however, if <code>false</code> is
     *  returned, the given node's child nodes will not be visited.
     */
    public bool visit(CopyingRangeMarker edit) {
        return visitNode(edit);
    }

    /**
     * Visits a <code>DeleteEdit</code> instance.
     *
     * @param edit the node to visit
     * @return If <code>true</code> is returned, the given node's child
     *  nodes will be visited next; however, if <code>false</code> is
     *  returned, the given node's child nodes will not be visited.
     */
    public bool visit(DeleteEdit edit) {
        return visitNode(edit);
    }

    /**
     * Visits a <code>InsertEdit</code> instance.
     *
     * @param edit the node to visit
     * @return If <code>true</code> is returned, the given node's child
     *  nodes will be visited next; however, if <code>false</code> is
     *  returned, the given node's child nodes will not be visited.
     */
    public bool visit(InsertEdit edit) {
        return visitNode(edit);
    }

    /**
     * Visits a <code>ReplaceEdit</code> instance.
     *
     * @param edit the node to visit
     * @return If <code>true</code> is returned, the given node's child
     *  nodes will be visited next; however, if <code>false</code> is
     *  returned, the given node's child nodes will not be visited.
     */
    public bool visit(ReplaceEdit edit) {
        return visitNode(edit);
    }

    /**
     * Visits a <code>UndoEdit</code> instance.
     *
     * @param edit the node to visit
     * @return If <code>true</code> is returned, the given node's child
     *  nodes will be visited next; however, if <code>false</code> is
     *  returned, the given node's child nodes will not be visited.
     */
    public bool visit(UndoEdit edit) {
        return visitNode(edit);
    }

    /**
     * Visits a <code>MultiTextEdit</code> instance.
     *
     * @param edit the node to visit
     * @return If <code>true</code> is returned, the given node's child
     *  nodes will be visited next; however, if <code>false</code> is
     *  returned, the given node's child nodes will not be visited.
     */
    public bool visit(MultiTextEdit edit) {
        return visitNode(edit);
    }
}
