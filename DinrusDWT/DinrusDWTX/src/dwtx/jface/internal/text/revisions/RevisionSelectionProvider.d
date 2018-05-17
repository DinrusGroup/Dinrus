/*******************************************************************************
 * Copyright (c) 2006 IBM Corporation and others.
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
module dwtx.jface.internal.text.revisions.RevisionSelectionProvider;

import dwtx.jface.internal.text.revisions.HunkComputer; // packageimport
import dwtx.jface.internal.text.revisions.LineIndexOutOfBoundsException; // packageimport
import dwtx.jface.internal.text.revisions.Hunk; // packageimport
import dwtx.jface.internal.text.revisions.Colors; // packageimport
import dwtx.jface.internal.text.revisions.ChangeRegion; // packageimport
import dwtx.jface.internal.text.revisions.Range; // packageimport
import dwtx.jface.internal.text.revisions.RevisionPainter; // packageimport


import dwt.dwthelper.utils;



import dwtx.core.runtime.ListenerList;
import dwtx.jface.text.ITextSelection;
import dwtx.jface.text.ITextViewer;
import dwtx.jface.text.revisions.Revision;
import dwtx.jface.viewers.IPostSelectionProvider;
import dwtx.jface.viewers.ISelection;
import dwtx.jface.viewers.ISelectionChangedListener;
import dwtx.jface.viewers.ISelectionProvider;
import dwtx.jface.viewers.IStructuredSelection;
import dwtx.jface.viewers.SelectionChangedEvent;
import dwtx.jface.viewers.StructuredSelection;

/**
 * A selection provider for annotate revisions. Selections of a revision can currently happen in
 * following ways - note that this list may be changed in the future:
 * <ul>
 * <li>when the user clicks the revision ruler with the mouse</li>
 * <li>when the caret is moved to a revision's line (only on post-selection)</li>
 * </ul>
 * <p>
 * Calling {@link #setSelection(ISelection)} will set the current sticky revision on the ruler.
 * </p>
 *
 * @since 3.2
 */
public final class RevisionSelectionProvider : ISelectionProvider {

    /**
     * Post selection listener on the viewer that remembers the selection provider it is registered
     * with.
     */
    private final class PostSelectionListener : ISelectionChangedListener {
        private const IPostSelectionProvider fPostProvider;

        public this(IPostSelectionProvider postProvider) {
            postProvider.addPostSelectionChangedListener(this);
            fPostProvider= postProvider;
        }

        public void selectionChanged(SelectionChangedEvent event) {
            ISelection selection= event.getSelection();
            if ( cast(ITextSelection)selection ) {
                ITextSelection ts= cast(ITextSelection) selection;
                int offset= ts.getOffset();
                setSelectedRevision(fPainter.getRevision(offset));
            }

        }

        public void dispose() {
            fPostProvider.removePostSelectionChangedListener(this);
        }
    }

    private const RevisionPainter fPainter;
    private const ListenerList fListeners;

    /**
     * The text viewer once we are installed, <code>null</code> if not installed.
     */
    private ITextViewer fViewer;
    /**
     * The selection listener on the viewer, or <code>null</code>.
     */
    private PostSelectionListener fSelectionListener;
    /**
     * The last selection, or <code>null</code>.
     */
    private Revision fSelection;
    /**
     * Incoming selection changes are ignored while sending out events.
     *
     * @since 3.3
     */
    private bool fIgnoreEvents= false;

    /**
     * Creates a new selection provider.
     *
     * @param painter the painter that the created provider interacts with
     */
    this(RevisionPainter painter) {
        fListeners= new ListenerList();
        fPainter= painter;
    }

    /*
     * @see dwtx.jface.viewers.ISelectionProvider#addSelectionChangedListener(dwtx.jface.viewers.ISelectionChangedListener)
     */
    public void addSelectionChangedListener(ISelectionChangedListener listener) {
        fListeners.add(cast(Object)listener);
    }

    /*
     * @see dwtx.jface.viewers.ISelectionProvider#removeSelectionChangedListener(dwtx.jface.viewers.ISelectionChangedListener)
     */
    public void removeSelectionChangedListener(ISelectionChangedListener listener) {
        fListeners.remove(cast(Object)listener);
    }

    /*
     * @see dwtx.jface.viewers.ISelectionProvider#getSelection()
     */
    public ISelection getSelection() {
        if (fSelection is null)
            return StructuredSelection.EMPTY;
        return new StructuredSelection(fSelection);
    }

    /*
     * @see dwtx.jface.viewers.ISelectionProvider#setSelection(dwtx.jface.viewers.ISelection)
     */
    public void setSelection(ISelection selection) {
        if (fIgnoreEvents)
            return;
        if ( cast(IStructuredSelection)selection ) {
            Object first= (cast(IStructuredSelection) selection).getFirstElement();
            if ( cast(Revision)first )
                fPainter.handleRevisionSelected(cast(Revision) first);
            else if ( auto str = cast(ArrayWrapperString)first )
                fPainter.handleRevisionSelected(str.array);
            else if (selection.isEmpty())
                fPainter.handleRevisionSelected(cast(Revision) null);
        }
    }

    /**
     * Installs the selection provider on the viewer.
     *
     * @param viewer the viewer on which we listen to for post selection events
     */
    void install(ITextViewer viewer) {
        uninstall();
        fViewer= viewer;
        if (fViewer !is null) {
            ISelectionProvider provider= fViewer.getSelectionProvider();
            if ( cast(IPostSelectionProvider)provider ) {
                IPostSelectionProvider postProvider= cast(IPostSelectionProvider) provider;
                fSelectionListener= new PostSelectionListener(postProvider);
            }
        }
    }

    /**
     * Uninstalls the selection provider.
     */
    void uninstall() {
        fViewer= null;
        if (fSelectionListener !is null) {
            fSelectionListener.dispose();
            fSelectionListener= null;
        }
    }

    /**
     * Private protocol used by {@link RevisionPainter} to signal selection of a revision.
     *
     * @param revision the selected revision, or <code>null</code> for none
     */
    void revisionSelected(Revision revision) {
        setSelectedRevision(revision);
    }

    /**
     * Updates the currently selected revision and sends out an event if it changed.
     *
     * @param revision the newly selected revision or <code>null</code> for none
     */
    private void setSelectedRevision(Revision revision) {
        if (revision !is fSelection) {
            fSelection= revision;
            fireSelectionEvent();
        }
    }

    private void fireSelectionEvent() {
        fIgnoreEvents= true;
        try {
            ISelection selection= getSelection();
            SelectionChangedEvent event= new SelectionChangedEvent(this, selection);

            Object[] listeners= fListeners.getListeners();
            for (int i= 0; i < listeners.length; i++)
                (cast(ISelectionChangedListener) listeners[i]).selectionChanged(event);
        } finally {
            fIgnoreEvents= false;
        }
    }
}
