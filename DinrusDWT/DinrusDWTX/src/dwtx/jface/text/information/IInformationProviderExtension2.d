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
module dwtx.jface.text.information.IInformationProviderExtension2;

import dwtx.jface.text.information.InformationPresenter; // packageimport
import dwtx.jface.text.information.IInformationProvider; // packageimport
import dwtx.jface.text.information.IInformationProviderExtension; // packageimport
import dwtx.jface.text.information.IInformationPresenterExtension; // packageimport
import dwtx.jface.text.information.IInformationPresenter; // packageimport


import dwt.dwthelper.utils;

import dwtx.jface.text.IInformationControlCreator;

/**
 * Extends {@link dwtx.jface.text.information.IInformationProvider} with
 * the ability to provide its own information presenter control creator.
 *
 * @see dwtx.jface.text.IInformationControlCreator
 * @see dwtx.jface.text.information.IInformationProvider
 * @since 3.0
 */
public interface IInformationProviderExtension2 {

    /**
     * Returns the information control creator of this information provider.
     *
     * @return the information control creator or <code>null</code> if none is available
     */
    IInformationControlCreator getInformationPresenterControlCreator();
}
