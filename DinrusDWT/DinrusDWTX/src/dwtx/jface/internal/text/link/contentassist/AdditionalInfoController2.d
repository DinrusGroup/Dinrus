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


module dwtx.jface.internal.text.link.contentassist.AdditionalInfoController2;

import dwtx.jface.internal.text.link.contentassist.IProposalListener; // packageimport
import dwtx.jface.internal.text.link.contentassist.LineBreakingReader; // packageimport
import dwtx.jface.internal.text.link.contentassist.CompletionProposalPopup2; // packageimport
import dwtx.jface.internal.text.link.contentassist.ContextInformationPopup2; // packageimport
import dwtx.jface.internal.text.link.contentassist.ContentAssistMessages; // packageimport
import dwtx.jface.internal.text.link.contentassist.Helper2; // packageimport
import dwtx.jface.internal.text.link.contentassist.PopupCloser2; // packageimport
import dwtx.jface.internal.text.link.contentassist.IContentAssistListener2; // packageimport
import dwtx.jface.internal.text.link.contentassist.ContentAssistant2; // packageimport

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.JThread;
import tango.core.sync.Mutex;
import tango.core.sync.Condition;

import dwt.events.SelectionEvent;
import dwt.events.SelectionListener;
import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwt.widgets.Control;
import dwt.widgets.Table;
import dwt.widgets.TableItem;
import dwtx.core.runtime.Assert;
import dwtx.jface.text.AbstractInformationControlManager;
import dwtx.jface.text.IInformationControl;
import dwtx.jface.text.IInformationControlCreator;
import dwtx.jface.text.contentassist.ICompletionProposal;
import dwtx.jface.text.contentassist.ICompletionProposalExtension3;


/**
 * Displays the additional information available for a completion proposal.
 *
 * @since 2.0
 */
class AdditionalInfoController2 : AbstractInformationControlManager , Runnable {

    /**
     * Internal table selection listener.
     */
    private class TableSelectionListener : SelectionListener {

        /*
         * @see SelectionListener#widgetSelected(SelectionEvent)
         */
        public void widgetSelected(SelectionEvent e) {
            handleTableSelectionChanged();
        }

        /*
         * @see SelectionListener#widgetDefaultSelected(SelectionEvent)
         */
        public void widgetDefaultSelected(SelectionEvent e) {
        }
    }


    /** The proposal table */
    private Table fProposalTable;
    /** The thread controlling the delayed display of the additional info */
    private JThread fThread;
    /** Indicates whether the display delay has been reset */
    private bool fIsReset= false;
    /** Object to synchronize display thread and table selection changes */
    private const Mutex     fMutex;
    private const Condition fMutex_cond;
    /** Thread access lock. */
    private const Object fThreadAccess;
    /** Object to synchronize initial display of additional info */
    private Mutex     fStartSignal;
    private Condition fStartSignal_cond;
    /** The table selection listener */
    private SelectionListener fSelectionListener;
    /** The delay after which additional information is displayed */
    private int fDelay;


    /**
     * Creates a new additional information controller.
     *
     * @param creator the information control creator to be used by this controller
     * @param delay time in milliseconds after which additional info should be displayed
     */
    this(IInformationControlCreator creator, int delay) {
        fSelectionListener= new TableSelectionListener();
        fThreadAccess= new Object();
        fMutex= new Mutex();
        fMutex_cond= new Condition(fMutex);
        super(creator);
        fDelay= delay;
        setAnchor(ANCHOR_RIGHT);
        setFallbackAnchors([ANCHOR_RIGHT, ANCHOR_LEFT, ANCHOR_BOTTOM ]);
    }

    /*
     * @see AbstractInformationControlManager#install(Control)
     */
    public void install(Control control) {

        if (fProposalTable is control) {
            // already installed
            return;
        }

        super.install(control);

        Assert.isTrue( null !is cast(Table)control );
        fProposalTable= cast(Table) control;
        fProposalTable.addSelectionListener(fSelectionListener);
        synchronized (fThreadAccess) {
            if (fThread !is null)
                fThread.interrupt();
            fThread= new JThread(this, ContentAssistMessages.getString("InfoPopup.info_delay_timer_name")); //$NON-NLS-1$

            fStartSignal= new Mutex();
            fStartSignal_cond= new Condition(fStartSignal);
            synchronized (fStartSignal) {
                fThread.start();
                try {
                    // wait until thread is ready
                    fStartSignal_cond.wait();
                } catch (InterruptedException x) {
                }
            }
        }
    }

    /*
     * @see AbstractInformationControlManager#disposeInformationControl()
     */
     public void disposeInformationControl() {

        synchronized (fThreadAccess) {
            if (fThread !is null) {
                fThread.interrupt();
                fThread= null;
            }
        }

        if (fProposalTable !is null && !fProposalTable.isDisposed()) {
            fProposalTable.removeSelectionListener(fSelectionListener);
            fProposalTable= null;
        }

        super.disposeInformationControl();
    }

    /*
     * @see java.lang.Runnable#run()
     */
    public void run() {
        try {
            while (true) {

                synchronized (fMutex) {

                    if (fStartSignal !is null) {
                        synchronized (fStartSignal) {
                            fStartSignal_cond.notifyAll();
                            fStartSignal= null;
                            fStartSignal_cond = null;
                        }
                    }

                    // Wait for a selection event to occur.
                    fMutex_cond.wait();

                    while (true) {
                        fIsReset= false;
                        // Delay before showing the popup.
                        fMutex_cond.wait(fDelay);
                        if (!fIsReset)
                            break;
                    }
                }

                if (fProposalTable !is null && !fProposalTable.isDisposed()) {
                    fProposalTable.getDisplay().asyncExec(new class()  Runnable {
                        public void run() {
                            if (!fIsReset)
                                showInformation();
                        }
                    });
                }

            }
        } catch (InterruptedException e) {
        }

        synchronized (fThreadAccess) {
            // only null fThread if it is us!
            if (JThread.currentThread() is fThread)
                fThread= null;
        }
    }

    /**
     *Handles a change of the line selected in the associated selector.
     */
    public void handleTableSelectionChanged() {

        if (fProposalTable !is null && !fProposalTable.isDisposed() && fProposalTable.isVisible()) {
            synchronized (fMutex) {
                fIsReset= true;
                fMutex_cond.notifyAll();
            }
        }
    }

    /*
     * @see AbstractInformationControlManager#computeInformation()
     */
    protected void computeInformation() {

        if (fProposalTable is null || fProposalTable.isDisposed())
            return;

        TableItem[] selection= fProposalTable.getSelection();
        if (selection !is null && selection.length > 0) {

            TableItem item= selection[0];

            // compute information
            String information= null;
            Object d= item.getData();

            if ( cast(ICompletionProposal)d ) {
                ICompletionProposal p= cast(ICompletionProposal) d;
                information= p.getAdditionalProposalInfo();
            }

            if ( cast(ICompletionProposalExtension3)d )
                setCustomInformationControlCreator((cast(ICompletionProposalExtension3) d).getInformationControlCreator());
            else
                setCustomInformationControlCreator(null);

            // compute subject area
            setMargins(4, -1);
            Rectangle area= fProposalTable.getBounds();
            area.x= 0; // subject area is the whole subject control
            area.y= 0;

            // set information & subject area
            setInformation(information, area);
        }
    }

    /*
     * @see dwtx.jface.text.AbstractInformationControlManager#computeSizeConstraints(Control, IInformationControl)
     */
    protected Point computeSizeConstraints(Control subjectControl, IInformationControl informationControl) {
        // at least as big as the proposal table
        Point sizeConstraint= super.computeSizeConstraints(subjectControl, informationControl);
        Point size= subjectControl.getSize();
        if (sizeConstraint.x < size.x)
            sizeConstraint.x= size.x;
        if (sizeConstraint.y < size.y)
            sizeConstraint.y= size.y;
        return sizeConstraint;
    }
}


