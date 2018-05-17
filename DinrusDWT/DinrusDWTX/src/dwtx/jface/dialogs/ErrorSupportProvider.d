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

module dwtx.jface.dialogs.ErrorSupportProvider;


import dwt.widgets.Composite;
import dwt.widgets.Control;
import dwtx.core.runtime.IStatus;

/**
 * A ErrorSupportProvider defines the area to be shown in an error dialog for extra support information.
 * @since 3.3
 *
 */
public abstract class ErrorSupportProvider {


        /**
         * Create an area for adding support components as a child of parent.
         * @param parent The parent {@link Composite}
         * @param status The {@link IStatus} that is being displayed.
         * @return Control
         */
        public abstract Control createSupportArea(Composite parent, IStatus status);
}
