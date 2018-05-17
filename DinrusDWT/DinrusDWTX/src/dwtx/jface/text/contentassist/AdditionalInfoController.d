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
module dwtx.jface.text.contentassist.AdditionalInfoController;

import dwtx.jface.text.contentassist.ContentAssistEvent; // packageimport
import dwtx.jface.text.contentassist.Helper; // packageimport
import dwtx.jface.text.contentassist.PopupCloser; // packageimport
import dwtx.jface.text.contentassist.IContentAssistant; // packageimport
import dwtx.jface.text.contentassist.CompletionProposal; // packageimport
import dwtx.jface.text.contentassist.ICompletionProposalExtension5; // packageimport
import dwtx.jface.text.contentassist.IContextInformationValidator; // packageimport
import dwtx.jface.text.contentassist.IContentAssistListener; // packageimport
import dwtx.jface.text.contentassist.ICompletionProposalExtension6; // packageimport
import dwtx.jface.text.contentassist.ICompletionListener; // packageimport
import dwtx.jface.text.contentassist.ICompletionProposalExtension2; // packageimport
import dwtx.jface.text.contentassist.IContentAssistantExtension4; // packageimport
import dwtx.jface.text.contentassist.ContextInformation; // packageimport
import dwtx.jface.text.contentassist.ICompletionProposalExtension3; // packageimport
import dwtx.jface.text.contentassist.ContextInformationValidator; // packageimport
import dwtx.jface.text.contentassist.ICompletionProposal; // packageimport
import dwtx.jface.text.contentassist.IContentAssistProcessor; // packageimport
import dwtx.jface.text.contentassist.IContextInformationPresenter; // packageimport
import dwtx.jface.text.contentassist.ICompletionProposalExtension4; // packageimport
import dwtx.jface.text.contentassist.ICompletionListenerExtension; // packageimport
import dwtx.jface.text.contentassist.ContextInformationPopup; // packageimport
import dwtx.jface.text.contentassist.IContextInformationExtension; // packageimport
import dwtx.jface.text.contentassist.IContentAssistantExtension2; // packageimport
import dwtx.jface.text.contentassist.ContentAssistSubjectControlAdapter; // packageimport
import dwtx.jface.text.contentassist.CompletionProposalPopup; // packageimport
import dwtx.jface.text.contentassist.ICompletionProposalExtension; // packageimport
import dwtx.jface.text.contentassist.IContextInformation; // packageimport
import dwtx.jface.text.contentassist.IContentAssistantExtension3; // packageimport
import dwtx.jface.text.contentassist.ContentAssistant; // packageimport
import dwtx.jface.text.contentassist.IContentAssistantExtension; // packageimport
import dwtx.jface.text.contentassist.JFaceTextMessages; // packageimport

import dwt.dwthelper.utils;
import dwtx.dwtxhelper.JThread;
import tango.core.sync.Mutex;
import tango.core.sync.Condition;

import dwt.events.SelectionEvent;
import dwt.events.SelectionListener;
import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwt.widgets.Control;
import dwt.widgets.Display;
import dwt.widgets.Shell;
import dwt.widgets.Table;
import dwt.widgets.TableItem;
import dwtx.core.runtime.Assert;
import dwtx.core.runtime.IProgressMonitor;
import dwtx.core.runtime.IStatus;
import dwtx.core.runtime.Status;
import dwtx.core.runtime.jobs.Job;
import dwtx.jface.internal.text.InformationControlReplacer;
import dwtx.jface.text.AbstractInformationControlManager;
import dwtx.jface.text.AbstractReusableInformationControlCreator;
import dwtx.jface.text.DefaultInformationControl;
import dwtx.jface.text.IInformationControl;
import dwtx.jface.text.IInformationControlCreator;
import dwtx.jface.text.IInformationControlExtension3;


/**
 * Displays the additional information available for a completion proposal.
 *
 * @since 2.0
 */
class AdditionalInfoController : AbstractInformationControlManager {

    alias AbstractInformationControlManager.showInformation showInformation;

    /**
     * A timer thread.
     *
     * @since 3.2
     */
    private static abstract class Timer : Object.Monitor {

        private Mutex fMutex;
        private Condition fMutex_cond;

        public override void lock(){
            fMutex.lock();
        }
        public override void unlock(){
            fMutex.unlock();
        }
        public void notifyAll(){
            fMutex_cond.notifyAll();
        }
        public void wait(){
            fMutex_cond.wait();
        }
        public void wait( long delay ){
            fMutex_cond.wait(delay/1000.0);
        }


        private static const int DELAY_UNTIL_JOB_IS_SCHEDULED= 50;

        /**
         * A <code>Task</code> is {@link Task#run() run} when {@link #delay()} milliseconds have
         * elapsed after it was scheduled without a {@link #reset(ICompletionProposal) reset}
         * to occur.
         */
        private static abstract class Task : Runnable {
            /**
             * @return the delay in milliseconds before this task should be run
             */
            public abstract long delay();
            /**
             * Runs this task.
             */
            public abstract void run();
            /**
             * @return the task to be scheduled after this task has been run
             */
            public abstract Task nextTask();
        }

        /**
         * IDLE: the initial task, and active whenever the info has been shown. It cannot be run,
         * but specifies an infinite delay.
         */
        private Task IDLE;
        private void IDLE_init(){
            IDLE = new class() Task {
                public void run() {
                    Assert.isTrue(false);
                }

                public Task nextTask() {
                    Assert.isTrue(false);
                    return null;
                }

                public long delay() {
                    return Long.MAX_VALUE;
                }

                public override String toString() {
                    return "IDLE"; //$NON-NLS-1$
                }
            };
        }
        /**
         * FIRST_WAIT: Schedules a platform {@link Job} to fetch additional info from an {@link ICompletionProposalExtension5}.
         */
        private Task FIRST_WAIT;
        private void FIRST_WAIT_init() {
            FIRST_WAIT = new class() Task {
                public void run() {
                    final ICompletionProposalExtension5 proposal= getCurrentProposalEx();
                    Job job= new class(JFaceTextMessages.getString("AdditionalInfoController.job_name")) Job { //$NON-NLS-1$
                        this( String txt ){
                            super( txt );
                        }
                        protected IStatus run(IProgressMonitor monitor) {
                            Object info;
                            try {
                                info= proposal.getAdditionalProposalInfo(monitor);
                            } catch (RuntimeException x) {
                                /*
                                * XXX: This is the safest fix at this point so close to end of 3.2.
                                *      Will be revisited when fixing https://bugs.eclipse.org/bugs/show_bug.cgi?id=101033
                                */
                                return new Status(IStatus.WARNING, "dwtx.jface.text", IStatus.OK, "", x); //$NON-NLS-1$ //$NON-NLS-2$
                            }
                            setInfo(cast(ICompletionProposal) proposal, info);
                            return new Status(IStatus.OK, "dwtx.jface.text", IStatus.OK, "", null); //$NON-NLS-1$ //$NON-NLS-2$
                        }
                    };
                    job.schedule();
                }

                public Task nextTask() {
                    return SECOND_WAIT;
                }

                public long delay() {
                    return DELAY_UNTIL_JOB_IS_SCHEDULED;
                }

                public override String toString() {
                    return "FIRST_WAIT"; //$NON-NLS-1$
                }
            };
        }
        /**
         * SECOND_WAIT: Allows display of additional info obtained from an
         * {@link ICompletionProposalExtension5}.
         */
        private Task SECOND_WAIT;
        private void SECOND_WAIT_init() {
            SECOND_WAIT = new class() Task {
                public void run() {
                    // show the info
                    allowShowing();
                }

                public Task nextTask() {
                    return IDLE;
                }

                public long delay() {
                    return fDelay - DELAY_UNTIL_JOB_IS_SCHEDULED;
                }

                public override String toString() {
                    return "SECOND_WAIT"; //$NON-NLS-1$
                }
            };
        }
        /**
         * LEGACY_WAIT: Posts a runnable into the display thread to fetch additional info from non-{@link ICompletionProposalExtension5}s.
         */
        private Task LEGACY_WAIT;
        private void LEGACY_WAIT_init() {
            LEGACY_WAIT = new class()  Task {
                public void run() {
                    final ICompletionProposal proposal= getCurrentProposal();
                    if (!fDisplay.isDisposed()) {
                        fDisplay.asyncExec(new class()  Runnable {
                            public void run() {
                                synchronized (this.outer) {
                                    if (proposal is getCurrentProposal()) {
                                        Object info= stringcast(proposal.getAdditionalProposalInfo());
                                        showInformation(proposal, info);
                                    }
                                }
                            }
                        });
                    }
                }

                public Task nextTask() {
                    return IDLE;
                }

                public long delay() {
                    return fDelay;
                }

                public override String toString() {
                    return "LEGACY_WAIT"; //$NON-NLS-1$
                }
            };
        }
        /**
         * EXIT: The task that triggers termination of the timer thread.
         */
        private Task EXIT;
        private void EXIT_init() {
            EXIT = new class()  Task {
                public long delay() {
                    return 1;
                }

                public Task nextTask() {
                    Assert.isTrue(false);
                    return EXIT;
                }

                public void run() {
                    Assert.isTrue(false);
                }

                public override String toString() {
                    return "EXIT"; //$NON-NLS-1$
                }
            };
        }

        /** The timer thread. */
        private const JThread fThread;

        /** The currently waiting / active task. */
        private Task fTask;
        /** The next wake up time. */
        private long fNextWakeup;

        private ICompletionProposal fCurrentProposal= null;
        private Object fCurrentInfo= null;
        private bool fAllowShowing= false;

        private const Display fDisplay;
        private const int fDelay;

        /**
         * Creates a new timer.
         *
         * @param display the display to use for display thread posting.
         * @param delay the delay until to show additional info
         */
        public this(Display display, int delay) {
        fMutex = new Mutex();
        fMutex_cond = new Condition(fMutex);

            // DWT instance init
            IDLE_init();
            FIRST_WAIT_init();
            SECOND_WAIT_init();
            LEGACY_WAIT_init();
            EXIT_init();

            fDisplay= display;
            fDelay= delay;
            long current= System.currentTimeMillis();
            schedule(IDLE, current);

            fThread= new JThread( &threadrun );
            fThread.setName( JFaceTextMessages.getString("InfoPopup.info_delay_timer_name")); //$NON-NLS-1$
            fThread.start();
        }
        void threadrun() {
            try {
                loop();
            } catch (InterruptedException x) {
            }
        }

        /**
         * Terminates the timer thread.
         */
        public synchronized final void terminate() {
            schedule(EXIT, System.currentTimeMillis());
            notifyAll();
        }

        /**
         * Resets the timer thread as the selection has changed to a new proposal.
         *
         * @param p the new proposal
         */
        public final synchronized void reset(ICompletionProposal p) {
            if (fCurrentProposal !is p) {
                fCurrentProposal= p;
                fCurrentInfo= null;
                fAllowShowing= false;

                long oldWakeup= fNextWakeup;
                Task task= taskOnReset(p);
                schedule(task, System.currentTimeMillis());
                if (fNextWakeup < oldWakeup)
                    notifyAll();
            }
        }

        private Task taskOnReset(ICompletionProposal p) {
            if (p is null)
                return IDLE;
            if (isExt5(p))
                return FIRST_WAIT;
            return LEGACY_WAIT;
        }

        private synchronized void loop()  {
            long current= System.currentTimeMillis();
            Task task= currentTask();

            while (task !is EXIT) {
                long delay= fNextWakeup - current;
                if (delay <= 0) {
                    task.run();
                    task= task.nextTask();
                    schedule(task, current);
                } else {
                    wait(delay);
                    current= System.currentTimeMillis();
                    task= currentTask();
                }
            }
        }

        private Task currentTask() {
            return fTask;
        }

        private void schedule(Task task, long current) {
            fTask= task;
            long nextWakeup= current + task.delay();
            if (nextWakeup <= current)
                fNextWakeup= Long.MAX_VALUE;
            else
                fNextWakeup= nextWakeup;
        }

        private bool isExt5(ICompletionProposal p) {
            return null !is cast(ICompletionProposalExtension5)p;
        }

        ICompletionProposal getCurrentProposal() {
            return fCurrentProposal;
        }

        ICompletionProposalExtension5 getCurrentProposalEx() {
            Assert.isTrue( null !is cast(ICompletionProposalExtension5)fCurrentProposal );
            return cast(ICompletionProposalExtension5) fCurrentProposal;
        }

        synchronized void setInfo(ICompletionProposal proposal, Object info) {
            if (proposal is fCurrentProposal) {
                fCurrentInfo= info;
                if (fAllowShowing) {
                    triggerShowing();
                }
            }
        }

        private void triggerShowing() {
            final Object info= fCurrentInfo;
            if (!fDisplay.isDisposed()) {
                fDisplay.asyncExec(new class()  Runnable {
                    public void run() {
                        synchronized (this.outer) {
                            if (info is fCurrentInfo) {
                                showInformation(fCurrentProposal, info);
                            }
                        }
                    }
                });
            }
        }

        /**
         * Called in the display thread to show additional info.
         *
         * @param proposal the proposal to show information about
         * @param info the information about <code>proposal</code>
         */
        protected abstract void showInformation(ICompletionProposal proposal, Object info);

        void allowShowing() {
            fAllowShowing= true;
            triggerShowing();
        }
    }
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

    /**
     * Default control creator for the information control replacer.
     * @since 3.4
     */
    private static class DefaultPresenterControlCreator : AbstractReusableInformationControlCreator {
        public IInformationControl doCreateInformationControl(Shell shell) {
            return new DefaultInformationControl(shell, true);
        }
    }

    /** The proposal table. */
    private Table fProposalTable;
    /** The table selection listener */
    private SelectionListener fSelectionListener;
    /** The delay after which additional information is displayed */
    private const int fDelay;
    /**
     * The timer thread.
     * @since 3.2
     */
    private Timer fTimer;
    /**
     * The proposal most recently set by {@link #showInformation(ICompletionProposal, Object)},
     * possibly <code>null</code>.
     * @since 3.2
     */
    private ICompletionProposal fProposal;
    /**
     * The information most recently set by {@link #showInformation(ICompletionProposal, Object)},
     * possibly <code>null</code>.
     * @since 3.2
     */
    private Object fInformation;

    /**
     * Creates a new additional information controller.
     *
     * @param creator the information control creator to be used by this controller
     * @param delay time in milliseconds after which additional info should be displayed
     */
    this(IInformationControlCreator creator, int delay) {

        fSelectionListener= new TableSelectionListener();

        super(creator);
        fDelay= delay;
        setAnchor(ANCHOR_RIGHT);
        setFallbackAnchors([ ANCHOR_RIGHT, ANCHOR_LEFT, ANCHOR_BOTTOM ]);

        /*
         * Adjust the location by one pixel towards the proposal popup, so that the single pixel
         * border of the additional info popup overlays with the border of the popup. This avoids
         * having a double black line.
         */
        int spacing= -1;
        setMargins(spacing, spacing); // see also adjustment in #computeLocation

        InformationControlReplacer replacer= new InformationControlReplacer(new DefaultPresenterControlCreator());
        getInternalAccessor().setInformationControlReplacer(replacer);
    }

    /*
     * @see AbstractInformationControlManager#install(Control)
     */
    public void install(Control control) {

        if (fProposalTable is control) {
            // already installed
            return;
        }

        super.install(control.getShell());

        Assert.isTrue( null !is cast(Table)control );
        fProposalTable= cast(Table) control;
        fProposalTable.addSelectionListener(fSelectionListener);
        getInternalAccessor().getInformationControlReplacer().install(fProposalTable);

        fTimer= new class(fProposalTable.getDisplay(), fDelay)  Timer {
            this( Display d, int del ){
                super(d,del);
            }
            protected void showInformation(ICompletionProposal proposal, Object info) {
                InformationControlReplacer replacer= getInternalAccessor().getInformationControlReplacer();
                if (replacer !is null)
                    replacer.hideInformationControl();
                this.outer.showInformation(proposal, info);
            }
        };
    }

    /*
     * @see AbstractInformationControlManager#disposeInformationControl()
     */
    public void disposeInformationControl() {

        if (fTimer !is null) {
            fTimer.terminate();
            fTimer= null;
        }

        fProposal= null;
        fInformation= null;

        if (fProposalTable !is null && !fProposalTable.isDisposed()) {
            fProposalTable.removeSelectionListener(fSelectionListener);
            fProposalTable= null;
        }

        super.disposeInformationControl();
    }

    /**
     *Handles a change of the line selected in the associated selector.
     */
    public void handleTableSelectionChanged() {

        if (fProposalTable !is null && !fProposalTable.isDisposed() && fProposalTable.isVisible()) {
            TableItem[] selection= fProposalTable.getSelection();
            if (selection !is null && selection.length > 0) {

                TableItem item= selection[0];

                Object d= item.getData();
                if ( cast(ICompletionProposal)d ) {
                    ICompletionProposal p= cast(ICompletionProposal) d;
                    fTimer.reset(p);
                }
            }
        }
    }

    void showInformation(ICompletionProposal proposal, Object info) {
        if (fProposalTable is null || fProposalTable.isDisposed())
            return;

        if (fProposal is proposal && ((info is null && fInformation is null) || (info !is null && info.opEquals(fInformation))))
            return;

        fInformation= info;
        fProposal= proposal;
        showInformation();
    }

    /*
     * @see AbstractInformationControlManager#computeInformation()
     */
    protected void computeInformation() {
        if ( cast(ICompletionProposalExtension3)fProposal )
            setCustomInformationControlCreator((cast(ICompletionProposalExtension3) fProposal).getInformationControlCreator());
        else
            setCustomInformationControlCreator(null);

        // compute subject area
        Point size= fProposalTable.getShell().getSize();

        // set information & subject area
        setInformation(fInformation, new Rectangle(0, 0, size.x, size.y));
    }

    /*
     * @see dwtx.jface.text.AbstractInformationControlManager#computeLocation(dwt.graphics.Rectangle, dwt.graphics.Point, dwtx.jface.text.AbstractInformationControlManager.Anchor)
     */
    protected Point computeLocation(Rectangle subjectArea, Point controlSize, Anchor anchor) {
        Point location= super.computeLocation(subjectArea, controlSize, anchor);

        /*
         * The location is computed using subjectControl.toDisplay(), which does not include the
         * trim of the subject control. As we want the additional info popup aligned with the outer
         * coordinates of the proposal popup, adjust this here
         */
        Rectangle trim= fProposalTable.getShell().computeTrim(0, 0, 0, 0);
        location.x += trim.x;
        location.y += trim.y;

        return location;
    }

    /*
     * @see dwtx.jface.text.AbstractInformationControlManager#computeSizeConstraints(Control, IInformationControl)
     */
    protected Point computeSizeConstraints(Control subjectControl, IInformationControl informationControl) {
        // at least as big as the proposal table
        Point sizeConstraint= super.computeSizeConstraints(subjectControl, informationControl);
        Point size= subjectControl.getShell().getSize();

        // AbstractInformationControlManager#internalShowInformationControl(Rectangle, Object) adds trims
        // to the computed constraints. Need to remove them here, to make the outer bounds of the additional
        // info shell fit the bounds of the proposal shell:
        if ( cast(IInformationControlExtension3)fInformationControl ) {
            Rectangle shellTrim= (cast(IInformationControlExtension3) fInformationControl).computeTrim();
            size.x -= shellTrim.width;
            size.y -= shellTrim.height;
        }

        if (sizeConstraint.x < size.x)
            sizeConstraint.x= size.x;
        if (sizeConstraint.y < size.y)
            sizeConstraint.y= size.y;
        return sizeConstraint;
    }

    /*
     * @see dwtx.jface.text.AbstractInformationControlManager#hideInformationControl()
     */
    protected void hideInformationControl() {
        super.hideInformationControl();
    }
    package void hideInformationControl_package() {
        this.hideInformationControl();
    }

    /**
     * @return the current information control, or <code>null</code> if none available
     */
    public IInformationControl getCurrentInformationControl2() {
        return getInternalAccessor().getCurrentInformationControl();
    }
}


