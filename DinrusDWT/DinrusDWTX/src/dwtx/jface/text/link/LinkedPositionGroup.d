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
module dwtx.jface.text.link.LinkedPositionGroup;

import dwtx.jface.text.link.LinkedModeModel; // packageimport
import dwtx.jface.text.link.LinkedPosition; // packageimport
import dwtx.jface.text.link.ILinkedModeListener; // packageimport
import dwtx.jface.text.link.TabStopIterator; // packageimport
import dwtx.jface.text.link.LinkedModeUI; // packageimport
import dwtx.jface.text.link.InclusivePositionUpdater; // packageimport
import dwtx.jface.text.link.LinkedModeManager; // packageimport
import dwtx.jface.text.link.LinkedPositionAnnotations; // packageimport
import dwtx.jface.text.link.ProposalPosition; // packageimport

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.Collection;
import tango.text.convert.Format;

import dwtx.core.runtime.Assert;
import dwtx.jface.text.BadLocationException;
import dwtx.jface.text.DocumentEvent;
import dwtx.jface.text.IDocument;
import dwtx.jface.text.IRegion;
import dwtx.jface.text.Position;
import dwtx.jface.text.Region;
import dwtx.text.edits.MalformedTreeException;
import dwtx.text.edits.MultiTextEdit;
import dwtx.text.edits.ReplaceEdit;
import dwtx.text.edits.TextEdit;

/**
 * A group of positions in multiple documents that are simultaneously modified -
 * if one gets edited, all other positions in a group are edited the same way.
 * All linked positions in a group have the same content.
 * <p>
 * Normally, new positions are given a tab stop weight which can be used by
 * clients, e.g. the UI. If no weight is given, a position will not be visited.
 * If no weights are used at all, the first position in a document is taken as
 * the only stop as to comply with the behavior of the old linked position
 * infrastructure.
 * </p>
 * <p>
 * Clients may instantiate this class.
 * </p>
 *
 * @since 3.0
 * @noextend This class is not intended to be subclassed by clients.
 */
public class LinkedPositionGroup {

    /** Sequence constant declaring that a position should not be stopped by. */
    public static const int NO_STOP= -1;

    /* members */

    /** The linked positions of this group. */
    private const List fPositions;
    /** Whether we are sealed or not. */
    private bool fIsSealed= false;
    /**
     * <code>true</code> if there are custom iteration weights. For backward
     * compatibility.
     */
    private bool fHasCustomIteration= false;

    /*
     * iteration variables, set to communicate state between isLegalEvent and
     * handleEvent
     */
    /** The position including the most recent <code>DocumentEvent</code>. */
    private LinkedPosition fLastPosition;
    /** The region covered by <code>fLastPosition</code> before the document
     * change.
     */
    private IRegion fLastRegion;

    this(){
        fPositions= new LinkedList();
    }

    /**
     * Adds a position to this group. The document region defined by the
     * position must contain the same content (and thus have the same length) as
     * any of the other positions already in this group. Additionally, all
     * positions added must be disjoint; otherwise a
     * <code>BadLocationException</code> is thrown.
     * <p>
     * Positions added using this method are owned by this group afterwards and
     * may not be updated or modified thereafter.
     * </p>
     * <p>
     * Once a group has been added to a <code>LinkedModeModel</code>, it
     * becomes <em>sealed</em> and no positions may be added any more.
     * </p>
     *
     * @param position the position to add
     * @throws BadLocationException if the position is invalid or conflicts with
     *         other positions in the group
     * @throws IllegalStateException if the group has already been added to a
     *         model
     */
    public void addPosition(LinkedPosition position)  {
        /*
         * Enforces constraints and sets the custom iteration flag. If the
         * position is already in this group, nothing happens.
         */
        Assert.isNotNull(position);
        if (fIsSealed)
            throw new IllegalStateException("cannot add positions after the group is added to an model"); //$NON-NLS-1$

        if (!fPositions.contains(position)) {
            enforceDisjoint(position);
            enforceEqualContent(position);
            fPositions.add(position);
            fHasCustomIteration |= position.getSequenceNumber() !is LinkedPositionGroup.NO_STOP;
        } else
            return; // nothing happens
    }

    /**
     * Enforces the invariant that all positions must contain the same string.
     *
     * @param position the position to check
     * @throws BadLocationException if the equal content check fails
     */
    private void enforceEqualContent(LinkedPosition position)  {
        if (fPositions.size() > 0) {
            LinkedPosition groupPosition= cast(LinkedPosition) fPositions.get(0);
            String groupContent= groupPosition.getContent();
            String positionContent= position.getContent();
            if (!groupContent.equals(positionContent))
                throw new BadLocationException(Format( "First position: '{}' at {}, this position: '{}' at {}",
                        groupContent, groupPosition.getOffset(), //$NON-NLS-1$ //$NON-NLS-2$
                        positionContent, position.getOffset())); //$NON-NLS-1$ //$NON-NLS-2$
        }
    }

    /**
     * Enforces the invariant that all positions must be disjoint.
     *
     * @param position the position to check
     * @throws BadLocationException if the disjointness check fails
     */
    private void enforceDisjoint(LinkedPosition position)  {
        for (Iterator it= fPositions.iterator(); it.hasNext(); ) {
            LinkedPosition p= cast(LinkedPosition) it.next();
            if (p.overlapsWith(position))
                throw new BadLocationException();
        }
    }

    /**
     * Enforces the disjointness for another group
     *
     * @param group the group to check
     * @throws BadLocationException if the disjointness check fails
     */
    void enforceDisjoint(LinkedPositionGroup group)  {
        Assert.isNotNull(group);
        for (Iterator it= group.fPositions.iterator(); it.hasNext(); ) {
            LinkedPosition p= cast(LinkedPosition) it.next();
            enforceDisjoint(p);
        }
    }

    /**
     * Checks whether <code>event</code> is a legal event for this group. An
     * event is legal if it touches at most one position contained within this
     * group.
     *
     * @param event the document event to check
     * @return <code>true</code> if <code>event</code> is legal
     */
    bool isLegalEvent(DocumentEvent event) {
        fLastPosition= null;
        fLastRegion= null;

        for (Iterator it= fPositions.iterator(); it.hasNext(); ) {
            LinkedPosition pos= cast(LinkedPosition) it.next();
            if (overlapsOrTouches(pos, event)) {
                if (fLastPosition !is null) {
                    fLastPosition= null;
                    fLastRegion= null;
                    return false;
                }

                fLastPosition= pos;
                fLastRegion= new Region(pos.getOffset(), pos.getLength());
            }
        }

        return true;
    }

    /**
     * Checks whether the given event touches the given position. To touch means
     * to overlap or come up to the borders of the position.
     *
     * @param position the position
     * @param event the event
     * @return <code>true</code> if <code>position</code> and
     *         <code>event</code> are not absolutely disjoint
     * @since 3.1
     */
    private bool overlapsOrTouches(LinkedPosition position, DocumentEvent event) {
        return (cast(Object)position.getDocument()).opEquals(cast(Object)event.getDocument()) && position.getOffset() <= event.getOffset() + event.getLength() && position.getOffset() + position.getLength() >= event.getOffset();
    }

    /**
     * Creates an edition of a document change that will forward any
     * modification in one position to all linked siblings. The return value is
     * a map from <code>IDocument</code> to <code>TextEdit</code>.
     *
     * @param event the document event to check
     * @return a map of edits, grouped by edited document, or <code>null</code>
     *         if there are no edits
     */
    Map handleEvent(DocumentEvent event) {

        if (fLastPosition !is null) {

            Map map= new HashMap();


            int relativeOffset= event.getOffset() - fLastRegion.getOffset();
            if (relativeOffset < 0) {
                relativeOffset= 0;
            }

            int eventEnd= event.getOffset() + event.getLength();
            int lastEnd= fLastRegion.getOffset() + fLastRegion.getLength();
            int length;
            if (eventEnd > lastEnd)
                length= lastEnd - relativeOffset - fLastRegion.getOffset();
            else
                length= eventEnd - relativeOffset - fLastRegion.getOffset();

            String text= event.getText();
            if (text is null)
                text= ""; //$NON-NLS-1$

            for (Iterator it= fPositions.iterator(); it.hasNext(); ) {
                LinkedPosition p= cast(LinkedPosition) it.next();
                if (p is fLastPosition || p.isDeleted())
                    continue; // don't re-update the origin of the change

                List edits= cast(List) map.get(cast(Object)p.getDocument());
                if (edits is null) {
                    edits= new ArrayList();
                    map.put(cast(Object)p.getDocument(), cast(Object)edits);
                }

                edits.add(new ReplaceEdit(p.getOffset() + relativeOffset, length, text));
            }

            try {
                for (Iterator it= map.keySet().iterator(); it.hasNext();) {
                    IDocument d= cast(IDocument) it.next();
                    TextEdit edit= new MultiTextEdit(0, d.getLength());
                    edit.addChildren(arraycast!(TextEdit)( (cast(List) map.get(cast(Object)d)).toArray()));
                    map.put(cast(Object)d, edit);
                }

                return map;
            } catch (MalformedTreeException x) {
                // may happen during undo, as LinkedModeModel does not know
                // that the changes technically originate from a parent environment
                // if this happens, post notification changes are not accepted anyway and
                // we can simply return null - any changes will be undone by the undo
                // manager
                return null;
            }

        }

        return null;
    }

    /**
     * Sets the model of this group. Once a model has been set, no
     * more positions can be added and the model cannot be changed.
     */
    void seal() {
        Assert.isTrue(!fIsSealed);
        fIsSealed= true;

        if (fHasCustomIteration is false && fPositions.size() > 0) {
            (cast(LinkedPosition) fPositions.get(0)).setSequenceNumber(0);
        }
    }

    IDocument[] getDocuments() {
        IDocument[] docs= new IDocument[fPositions.size()];
        int i= 0;
        for (Iterator it= fPositions.iterator(); it.hasNext(); i++) {
            LinkedPosition pos= cast(LinkedPosition) it.next();
            docs[i]= pos.getDocument();
        }
        return docs;
    }

    void register(LinkedModeModel model)  {
        for (Iterator it= fPositions.iterator(); it.hasNext(); ) {
            LinkedPosition pos= cast(LinkedPosition) it.next();
            model.register(pos);
        }
    }

    /**
     * Returns the position in this group that encompasses all positions in
     * <code>group</code>.
     *
     * @param group the group to be adopted
     * @return a position in the receiver that contains all positions in <code>group</code>,
     *         or <code>null</code> if none can be found
     * @throws BadLocationException if more than one position are affected by
     *         <code>group</code>
     */
    LinkedPosition adopt(LinkedPositionGroup group)  {
        LinkedPosition found= null;
        for (Iterator it= group.fPositions.iterator(); it.hasNext(); ) {
            LinkedPosition pos= cast(LinkedPosition) it.next();
            LinkedPosition localFound= null;
            for (Iterator it2= fPositions.iterator(); it2.hasNext(); ) {
                LinkedPosition myPos= cast(LinkedPosition) it2.next();
                if (myPos.includes(pos)) {
                    if (found is null)
                        found= myPos;
                    else if (found !is myPos)
                        throw new BadLocationException();
                    if (localFound is null)
                        localFound= myPos;
                }
            }

            if (localFound !is found)
                throw new BadLocationException();
        }
        return found;
    }

    /**
     * Finds the closest position to <code>toFind</code>.
     *
     * @param toFind the linked position for which to find the closest position
     * @return the closest position to <code>toFind</code>.
     */
    LinkedPosition getPosition(LinkedPosition toFind) {
        for (Iterator it= fPositions.iterator(); it.hasNext(); ) {
            LinkedPosition p= cast(LinkedPosition) it.next();
            if (p.includes(toFind))
                return p;
        }
        return null;
    }

    /**
     * Returns <code>true</code> if <code>offset</code> is contained in any
     * position in this group.
     *
     * @param offset the offset to check
     * @return <code>true</code> if offset is contained by this group
     */
    bool contains(int offset) {
        for (Iterator it= fPositions.iterator(); it.hasNext(); ) {
            LinkedPosition pos= cast(LinkedPosition) it.next();
            if (pos.includes(offset)) {
                return true;
            }
        }
        return false;
    }

    /**
     * Returns whether this group contains any positions.
     *
     * @return <code>true</code> if this group is empty, <code>false</code> otherwise
     * @since 3.1
     */
    public bool isEmpty() {
        return fPositions.size() is 0;
    }

    /**
     * Returns whether this group contains any positions.
     *
     * @return <code>true</code> if this group is empty, <code>false</code> otherwise
     * @deprecated As of 3.1, replaced by {@link #isEmpty()}
     */
    public bool isEmtpy() {
        return isEmpty();
    }

    /**
     * Returns the positions contained in the receiver as an array. The
     * positions are the actual positions and must not be modified; the array
     * is a copy of internal structures.
     *
     * @return the positions of this group in no particular order
     */
    public LinkedPosition[] getPositions() {
        return arraycast!(LinkedPosition) (fPositions.toArray());
    }

    /**
     * Returns <code>true</code> if the receiver contains <code>position</code>.
     *
     * @param position the position to check
     * @return <code>true</code> if the receiver contains <code>position</code>
     */
    bool contains(Position position) {
        for (Iterator it= fPositions.iterator(); it.hasNext(); ) {
            LinkedPosition p= cast(LinkedPosition) it.next();
            if (position.opEquals(p))
                return true;
        }
        return false;
    }
}
