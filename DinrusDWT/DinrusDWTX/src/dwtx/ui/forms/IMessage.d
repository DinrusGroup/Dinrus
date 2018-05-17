/*******************************************************************************
 * Copyright (c) 2007 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 ******************************************************************************/
module dwtx.ui.forms.IMessage;

import dwt.widgets.Control;
import dwtx.jface.dialogs.IMessageProvider;

import dwt.dwthelper.utils;

/**
 * This interface encapsulates a single message that can be shown in a form.
 * Messages can be associated with controls, or be of a general nature.
 *
 * @see IMessageManager
 * @since 3.3
 */
public interface IMessage : IMessageProvider {
    /**
     * Returns the unique message key
     *
     * @return the unique message key
     */
    Object getKey();

    /**
     * Returns data for application use
     *
     * @return data object
     */
    Object getData();

    /**
     * Returns the control this message is associated with.
     *
     * @return the control or <code>null</code> if this is a general message.
     */
    Control getControl();

    /**
     * Messages that are associated with controls can be shown with a prefix
     * that indicates the origin of the message (e.g. the label preceeding the
     * control).
     *
     * @return the message prefix or <code>null</code> if this is a general
     *         message
     */
    String getPrefix();
}
