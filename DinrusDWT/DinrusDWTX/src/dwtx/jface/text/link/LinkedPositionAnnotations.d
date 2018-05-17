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
module dwtx.jface.text.link.LinkedPositionAnnotations;

import dwtx.jface.text.link.LinkedModeModel; // packageimport
import dwtx.jface.text.link.LinkedPosition; // packageimport
import dwtx.jface.text.link.ILinkedModeListener; // packageimport
import dwtx.jface.text.link.TabStopIterator; // packageimport
import dwtx.jface.text.link.LinkedModeUI; // packageimport
import dwtx.jface.text.link.InclusivePositionUpdater; // packageimport
import dwtx.jface.text.link.LinkedPositionGroup; // packageimport
import dwtx.jface.text.link.LinkedModeManager; // packageimport
import dwtx.jface.text.link.ProposalPosition; // packageimport


import dwt.dwthelper.utils;

import dwtx.dwtxhelper.Collection;






import dwtx.core.runtime.Assert;
import dwtx.jface.text.BadLocationException;
import dwtx.jface.text.IDocument;
import dwtx.jface.text.Position;
import dwtx.jface.text.source.Annotation;
import dwtx.jface.text.source.AnnotationModel;

/**
 * Internal class.
 *
 * @since 3.0
 */
final class LinkedPositionAnnotations : AnnotationModel {

    /* annotation types */
    private static const String TARGET_ANNOTATION_TYPE= "dwtx.ui.internal.workbench.texteditor.link.target"; //$NON-NLS-1$
    private static const String SLAVE_ANNOTATION_TYPE= "dwtx.ui.internal.workbench.texteditor.link.slave"; //$NON-NLS-1$
    private static const String FOCUS_ANNOTATION_TYPE= "dwtx.ui.internal.workbench.texteditor.link.master"; //$NON-NLS-1$
    private static const String EXIT_ANNOTATION_TYPE= "dwtx.ui.internal.workbench.texteditor.link.exit"; //$NON-NLS-1$

    /* configuration */
    private bool fMarkTargets= true;
    private bool fMarkSlaves= true;
    private bool fMarkFocus= true;
    private bool fMarkExitTarget= true;

    private Annotation fFocusAnnotation= null;
    private Annotation fExitAnnotation= null;
    private const Map fGroupAnnotations;
    private const Map fTargetAnnotations;
    private Position[] fTargets;
    private LinkedPosition fExitPosition= null;

    public this(){
        fGroupAnnotations= new HashMap();
        fTargetAnnotations= new HashMap();
    }

    /**
     * Sets the position that should be highlighted as the focus position, i.e.
     * as the position whose changes are propagated to all its linked positions
     * by the linked environment.
     *
     * @param position the new focus position, or <code>null</code> if no focus is set.
     * @throws BadLocationException if <code>position</code> is invalid
     */
    private void setFocusPosition(Position position)  {
        if (fMarkFocus && getPosition(fFocusAnnotation) !is position) {
            removeAnnotation(fFocusAnnotation, false);
            if (position !is null) {
                fFocusAnnotation= new Annotation(FOCUS_ANNOTATION_TYPE, false, ""); //$NON-NLS-1$
                addAnnotation(fFocusAnnotation, position, false);
            } else
                fFocusAnnotation= null;
        }
    }

    /**
     * Sets the position that should be highlighted as the exit position, i.e.
     * as the position whose changes are propagated to all its linked positions
     * by the linked environment.
     *
     * @param position the new exit position, or <code>null</code> if no focus is set.
     * @throws BadLocationException in case <code>position</code> is invalid
     */
    private void setExitPosition(Position position)  {
        if (fMarkExitTarget && getPosition(fExitAnnotation) !is position) {
            removeAnnotation(fExitAnnotation, false);
            if (position !is null) {
                fExitAnnotation= new Annotation(EXIT_ANNOTATION_TYPE, false, ""); //$NON-NLS-1$
                addAnnotation(fExitAnnotation, position, false);
            } else
                fExitAnnotation= null;
        }
    }

    /**
     * Sets the positions that should be highlighted as the slave positions, i.e.
     * as the positions that are linked to the focus position.
     *
     * @param positions the new slave positions, or <code>null</code> if no slave positions are to be set
     * @throws BadLocationException in case any of the given positions is invalid
     */
    private void setGroupPositions(List positions)  {
        if (!fMarkSlaves)
            return;

        // remove all positions which are already there
        // Algorithm: toRemove contains all mappings at first, but all that are in
        // positions get removed -> toRemove contains the difference set of previous - new
        // toAdd are the new positions, which don't exist in previous = new - previous
        List toRemove= new ArrayList(fGroupAnnotations.values());
        Map toAdd= new HashMap();
        if (positions !is null) {
            for (Iterator iter= positions.iterator(); iter.hasNext();) {
                Position p= cast(Position) iter.next();
                if (fGroupAnnotations.containsKey(p)) {
                    toRemove.remove(fGroupAnnotations.get(p));
                } else {
                    Annotation a= new Annotation(SLAVE_ANNOTATION_TYPE, false, ""); //$NON-NLS-1$
                    toAdd.put(a, p);
                    fGroupAnnotations.put(p, a);
                }
            }
        }
        fGroupAnnotations.values().removeAll(toRemove);

        replaceAnnotations(arraycast!(Annotation)( toRemove.toArray()), toAdd, false);
    }

    /**
     * Sets the positions that should be highlighted as the target positions, i.e.
     * as the positions that can be jumped to in a linked set up.
     *
     * @param positions the new target positions, or <code>null</code> if no target positions are to be set
     * @throws BadLocationException in case any of the given positions is invalid
     */
    private void setTargetPositions(List positions)  {
        if (!fMarkTargets)
            return;

        // remove all positions which are already there
        // Algorithm: toRemove contains all mappings at first, but all that are in
        // positions get removed -> toRemove contains the difference set of previous - new
        // toAdd are the new positions, which don't exist in previous = new - previous
        List toRemove= new ArrayList(fTargetAnnotations.values());
        Map toAdd= new HashMap();
        if (positions !is null) {
            for (Iterator iter= positions.iterator(); iter.hasNext();) {
                Position p= cast(Position) iter.next();
                if (fTargetAnnotations.containsKey(p)) {
                    toRemove.remove(fTargetAnnotations.get(p));
                } else {
                    Annotation a= new Annotation(TARGET_ANNOTATION_TYPE, false, ""); //$NON-NLS-1$
                    toAdd.put(a, p);
                    fTargetAnnotations.put(p, a);
                }
            }
        }
        fTargetAnnotations.values().removeAll(toRemove);

        replaceAnnotations(arraycast!(Annotation)( toRemove.toArray()), toAdd, false);
    }

    /**
     * Switches the focus position to <code>position</code> given the
     * <code>LinkedModeModel env</code>. The slave positions for <code>position</code>
     * is extracted from the environment and set accordingly, the target positions
     * are updated as well.
     *
     * @param env
     * @param position
     */
    public void switchToPosition(LinkedModeModel env, LinkedPosition position) {
        if (fDocument is null ||
                (position !is null && getPosition(fFocusAnnotation) is position) ||
                (position is null && fFocusAnnotation is null))
            return;

        LinkedPositionGroup linkedGroup= null;
        if (position !is null)
            linkedGroup= env.getGroupForPosition(position);

        List targets= new ArrayList();
        targets.addAll(Arrays.asList(fTargets));

        List group;
        if (linkedGroup !is null)
            group= new ArrayList(Arrays.asList(linkedGroup.getPositions()));
        else
            group= new ArrayList();

        if (position is null || !(cast(Object)fDocument).opEquals(cast(Object)position.getDocument()))
            // position is not valid if not in this document
            position= null;

        LinkedPosition exit= fExitPosition;
        if (exit is null || !(cast(Object)fDocument).opEquals(cast(Object)exit.getDocument()))
            // position is not valid if not in this document
            exit= null;


        if (exit !is null) {
            group.remove(exit);
            targets.remove(exit);
        }

        group.removeAll(targets);
        targets.remove(position);
        group.remove(position);
        prune(targets);
        prune(group);

        try {
            setFocusPosition(position);
            setExitPosition(exit);
            setGroupPositions(group);
            setTargetPositions(targets);
        } catch (BadLocationException e) {
            // will never happen as we don't actually add/remove positions from the document
            // see the addPosition / removePosition methods
            Assert.isTrue(false);
        }
        fireModelChanged();

    }

    /**
     * Prune <code>list</code> of all <code>LinkedPosition</code>s that
     * do not belong to this model's <code>IDocument</code>.
     *
     * @param list the list of positions to prune
     */
    private void prune(List list) {
        for (Iterator iter= list.iterator(); iter.hasNext();) {
            LinkedPosition pos= cast(LinkedPosition) iter.next();
            if (!(cast(Object)pos.getDocument()).opEquals(cast(Object)fDocument))
                iter.remove();
        }
    }

    /**
     * Sets the target positions
     * @param positions
     */
    public void setTargets(Position[] positions) {
        fTargets= positions;
    }

    /**
     * Sets the exit position.
     *
     * @param position the new exit position, or <code>null</code> if no exit position should be set
     */
    public void setExitTarget(LinkedPosition position) {
        fExitPosition = position;
    }

    /*
     * @see dwtx.jface.text.source.AnnotationModel#addPosition(dwtx.jface.text.IDocument, dwtx.jface.text.Position)
     */
    protected void addPosition(IDocument document, Position position) {
        // don't to anything as our positions are managed by custom
        // position updaters
    }

    /*
     * @see dwtx.jface.text.source.AnnotationModel#removePosition(dwtx.jface.text.IDocument, dwtx.jface.text.Position)
     */
    protected void removePosition(IDocument document, Position pos) {
        // don't to anything as our positions are managed by custom
        // position updaters
    }

    /*
     * @see dwtx.jface.text.source.AnnotationModel#fireModelChanged()
     */
    public void fireModelChanged() {
        super.fireModelChanged();
    }

    /**
     * Sets the drawing state for the exit target. Default is <code>true</code>.
     *
     * @param markExitTargets the new drawing state for exit targets
     */
    public void markExitTarget(bool markExitTargets) {
        fMarkExitTarget= markExitTargets;
    }

    /**
     * Sets the drawing state for the focus position. Default is <code>true</code>.
     *
     * @param markFocus the new drawing state for exit targets
     */
    public void markFocus(bool markFocus) {
        fMarkFocus= markFocus;
    }

    /**
     * Sets the drawing state for slave positions. Default is <code>true</code>.
     *
     * @param markSlaves the new drawing state for slaves
     */
    public void markSlaves(bool markSlaves) {
        fMarkSlaves= markSlaves;
    }

    /**
     * Sets the drawing state for targets. Default is <code>true</code>.
     *
     * @param markTargets the new drawing state for targets
     */
    public void markTargets(bool markTargets) {
        fMarkTargets= markTargets;
    }
}
