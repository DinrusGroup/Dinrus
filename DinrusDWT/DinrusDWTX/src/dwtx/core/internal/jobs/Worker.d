/*******************************************************************************
 * Copyright (c) 2003, 2006 IBM Corporation and others.
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
module dwtx.core.internal.jobs.Worker;

import dwtx.dwtxhelper.JThread;
import tango.text.convert.Format;
import dwt.dwthelper.utils;

import dwtx.core.internal.runtime.RuntimeLog;
import dwtx.core.runtime.IStatus;
import dwtx.core.runtime.OperationCanceledException;
import dwtx.core.runtime.Status;
import dwtx.core.runtime.jobs.Job;
import dwtx.osgi.util.NLS;

import dwtx.core.internal.jobs.InternalJob;
import dwtx.core.internal.jobs.WorkerPool;
import dwtx.core.internal.jobs.JobMessages;
import dwtx.core.internal.jobs.JobManager;

/**
 * A worker thread processes jobs supplied to it by the worker pool.  When
 * the worker pool gives it a null job, the worker dies.
 */
public class Worker : JThread {
    //worker number used for debugging purposes only
    private static int nextWorkerNumber = 0;
    private /+volatile+/ InternalJob currentJob_;
    private final WorkerPool pool;

    public this(WorkerPool pool) {
        super();
        this.setName( Format("Worker-{}", nextWorkerNumber++)); //$NON-NLS-1$
        this.pool = pool;
        //set the context loader to avoid leaking the current context loader
        //for the thread that spawns this worker (bug 98376)
// DWT
//         setContextClassLoader(pool.defaultContextLoader);
    }

    /**
     * Returns the currently running job, or null if none.
     */
    public Job currentJob() {
        return cast(Job) currentJob_;
    }

    private IStatus handleException(InternalJob job, Exception t) {
        String message = NLS.bind(JobMessages.jobs_internalError, job.getName_package());
        return new Status(IStatus.ERROR, JobManager.PI_JOBS, JobManager.PLUGIN_ERROR, message, t);
    }

    public override void run() {
        this.setPriority(NORM_PRIORITY);
        try {
            while ((currentJob_ = pool.startJob_package(this)) !is null) {
                currentJob_.setThread_package(this);
                IStatus result = Status.OK_STATUS;
                try {
                    result = currentJob_.run_package(currentJob_.getProgressMonitor());
                } catch (OperationCanceledException e) {
                    result = Status.CANCEL_STATUS;
                } catch (Exception e) {
                    result = handleException(currentJob_, e);
//                 } catch (ThreadDeath e) {
//                     //must not consume thread death
//                     result = handleException(currentJob_, e);
//                     throw e;
//                 } catch (Error e) {
//                     result = handleException(currentJob_, e);
                } finally {
                    //clear interrupted state for this thread
                    JThread.interrupted();

                    //result must not be null
                    if (result is null)
                        result = handleException(currentJob_, new NullPointerException());
                    pool.endJob_package(currentJob_, result);
                    if ((result.getSeverity() & (IStatus.ERROR | IStatus.WARNING)) !is 0)
                        RuntimeLog.log(result);
                    currentJob_ = null;
                }
            }
        } catch (Exception t) {
            ExceptionPrintStackTrace(t);
        } finally {
            currentJob_ = null;
            pool.endWorker_package(this);
        }
    }
}
