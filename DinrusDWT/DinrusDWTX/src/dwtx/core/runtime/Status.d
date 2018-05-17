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
module dwtx.core.runtime.Status;

import dwtx.core.internal.runtime.IRuntimeConstants;
import dwtx.core.internal.runtime.LocalizationUtils;
import dwtx.core.runtime.IStatus;
import dwtx.core.runtime.Assert;

import dwt.dwthelper.utils;
import tango.text.convert.Format;

/**
 * A concrete status implementation, suitable either for
 * instantiating or subclassing.
 * <p>
 * This class can be used without OSGi running.
 * </p>
 */
public class Status : IStatus {

    /**
     * A standard OK status with an "ok"  message.
     *
     * @since 3.0
     */
    public static const IStatus OK_STATUS;
    /**
     * A standard CANCEL status with no message.
     *
     * @since 3.0
     */
    public static const IStatus CANCEL_STATUS;

    static this(){
        OK_STATUS = new Status(OK, IRuntimeConstants.PI_RUNTIME, OK, LocalizationUtils.safeLocalize("ok"), null); //$NON-NLS-1$
        CANCEL_STATUS = new Status(CANCEL, IRuntimeConstants.PI_RUNTIME, 1, "", null); //$NON-NLS-1$
    }

    /**
     * The severity. One of
     * <ul>
     * <li><code>CANCEL</code></li>
     * <li><code>ERROR</code></li>
     * <li><code>WARNING</code></li>
     * <li><code>INFO</code></li>
     * <li>or <code>OK</code> (0)</li>
     * </ul>
     */
    private int severity = OK;

    /** Unique identifier of plug-in.
     */
    private String pluginId;

    /** Plug-in-specific status code.
     */
    private int code;

    /** Message, localized to the current locale.
     */
    private String message;

    /** Wrapped exception, or <code>null</code> if none.
     */
    private Exception exception = null;

    /** Constant to avoid generating garbage.
     */
    private static const IStatus[] theEmptyStatusArray = null;

    /**
     * Creates a new status object.  The created status has no children.
     *
     * @param severity the severity; one of <code>OK</code>, <code>ERROR</code>,
     * <code>INFO</code>, <code>WARNING</code>,  or <code>CANCEL</code>
     * @param pluginId the unique identifier of the relevant plug-in
     * @param code the plug-in-specific status code, or <code>OK</code>
     * @param message a human-readable message, localized to the
     *    current locale
     * @param exception a low-level exception, or <code>null</code> if not
     *    applicable
     */
    public this(int severity, String pluginId, int code, String message, Exception exception) {
        setSeverity(severity);
        setPlugin(pluginId);
        setCode(code);
        setMessage(message);
        setException(exception);
    }

    /**
     * Simplified constructor of a new status object; assumes that code is <code>OK</code>.
     * The created status has no children.
     *
     * @param severity the severity; one of <code>OK</code>, <code>ERROR</code>,
     * <code>INFO</code>, <code>WARNING</code>,  or <code>CANCEL</code>
     * @param pluginId the unique identifier of the relevant plug-in
     * @param message a human-readable message, localized to the
     *    current locale
     * @param exception a low-level exception, or <code>null</code> if not
     *    applicable
     *
     * @since dwtx.equinox.common 3.3
     */
    public this(int severity, String pluginId, String message, Exception exception) {
        setSeverity(severity);
        setPlugin(pluginId);
        setMessage(message);
        setException(exception);
        setCode(OK);
    }

    /**
     * Simplified constructor of a new status object; assumes that code is <code>OK</code> and
     * exception is <code>null</code>. The created status has no children.
     *
     * @param severity the severity; one of <code>OK</code>, <code>ERROR</code>,
     * <code>INFO</code>, <code>WARNING</code>,  or <code>CANCEL</code>
     * @param pluginId the unique identifier of the relevant plug-in
     * @param message a human-readable message, localized to the
     *    current locale
     *
     * @since dwtx.equinox.common 3.3
     */
    public this(int severity, String pluginId, String message) {
        setSeverity(severity);
        setPlugin(pluginId);
        setMessage(message);
        setCode(OK);
        setException(null);
    }

    /* (Intentionally not javadoc'd)
     * Implements the corresponding method on <code>IStatus</code>.
     */
    public IStatus[] getChildren() {
        return theEmptyStatusArray;
    }

    /* (Intentionally not javadoc'd)
     * Implements the corresponding method on <code>IStatus</code>.
     */
    public int getCode() {
        return code;
    }

    /* (Intentionally not javadoc'd)
     * Implements the corresponding method on <code>IStatus</code>.
     */
    public Exception getException() {
        return exception;
    }

    /* (Intentionally not javadoc'd)
     * Implements the corresponding method on <code>IStatus</code>.
     */
    public String getMessage() {
        return message;
    }

    /* (Intentionally not javadoc'd)
     * Implements the corresponding method on <code>IStatus</code>.
     */
    public String getPlugin() {
        return pluginId;
    }

    /* (Intentionally not javadoc'd)
     * Implements the corresponding method on <code>IStatus</code>.
     */
    public int getSeverity() {
        return severity;
    }

    /* (Intentionally not javadoc'd)
     * Implements the corresponding method on <code>IStatus</code>.
     */
    public bool isMultiStatus() {
        return false;
    }

    /* (Intentionally not javadoc'd)
     * Implements the corresponding method on <code>IStatus</code>.
     */
    public bool isOK() {
        return severity is OK;
    }

    /* (Intentionally not javadoc'd)
     * Implements the corresponding method on <code>IStatus</code>.
     */
    public bool matches(int severityMask) {
        return (severity & severityMask) !is 0;
    }

    /**
     * Sets the status code.
     *
     * @param code the plug-in-specific status code, or <code>OK</code>
     */
    protected void setCode(int code) {
        this.code = code;
    }

    /**
     * Sets the exception.
     *
     * @param exception a low-level exception, or <code>null</code> if not
     *    applicable
     */
    protected void setException(Exception exception) {
        this.exception = exception;
    }

    /**
     * Sets the message. If null is passed, message is set to an empty
     * string.
     *
     * @param message a human-readable message, localized to the
     *    current locale
     */
    protected void setMessage(String message) {
        if (message is null)
            this.message = ""; //$NON-NLS-1$
        else
            this.message = message;
    }

    /**
     * Sets the plug-in id.
     *
     * @param pluginId the unique identifier of the relevant plug-in
     */
    protected void setPlugin(String pluginId) {
        Assert.isLegal(pluginId !is null && pluginId.length > 0);
        this.pluginId = pluginId;
    }

    /**
     * Sets the severity.
     *
     * @param severity the severity; one of <code>OK</code>, <code>ERROR</code>,
     * <code>INFO</code>, <code>WARNING</code>,  or <code>CANCEL</code>
     */
    protected void setSeverity(int severity) {
        Assert.isLegal(severity is OK || severity is ERROR || severity is WARNING || severity is INFO || severity is CANCEL);
        this.severity = severity;
    }

    /**
     * Returns a string representation of the status, suitable
     * for debugging purposes only.
     */
    public override String toString() {
        String sev;
        if (severity is OK) {
            sev="OK"; //$NON-NLS-1$
        } else if (severity is ERROR) {
            sev="ERROR"; //$NON-NLS-1$
        } else if (severity is WARNING) {
            sev="WARNING"; //$NON-NLS-1$
        } else if (severity is INFO) {
            sev="INFO"; //$NON-NLS-1$
        } else if (severity is CANCEL) {
            sev="CANCEL"; //$NON-NLS-1$
        } else {
            sev=Format( "severity={}", severity);
        }
        return Format("Status {}: {} code={} {} {}", sev, pluginId, code, message, exception.toString );
    }
}
