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
module dwtx.jface.contentassist.ISubjectControlContentAssistant;

import dwtx.jface.contentassist.IContentAssistSubjectControl;

import dwt.dwthelper.utils;

import dwtx.jface.text.contentassist.IContentAssistant;


/**
 * Extends {@link dwtx.jface.text.contentassist.IContentAssistant} to
 * allow to install a content assistant on the given
 * {@linkplain dwtx.jface.contentassist.IContentAssistSubjectControl content assist subject control}.
 *
 * @since 3.0
 * @deprecated As of 3.2, replaced by Platform UI's field assist support
 */
public interface ISubjectControlContentAssistant : IContentAssistant {

    /**
     * Installs content assist support on the given subject.
     *
     * @param contentAssistSubjectControl the one who requests content assist
     */
    void install(IContentAssistSubjectControl contentAssistSubjectControl);
}
