/*******************************************************************************
 * Copyright (c) 2006, 2008 IBM Corporation and others.
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
module dwtx.jface.text.quickassist.IQuickFixableAnnotation;

import dwtx.jface.text.quickassist.QuickAssistAssistant; // packageimport
import dwtx.jface.text.quickassist.IQuickAssistAssistant; // packageimport
import dwtx.jface.text.quickassist.IQuickAssistAssistantExtension; // packageimport
import dwtx.jface.text.quickassist.IQuickAssistInvocationContext; // packageimport
import dwtx.jface.text.quickassist.IQuickAssistProcessor; // packageimport


import dwt.dwthelper.utils;


import dwtx.core.runtime.AssertionFailedException;
import dwtx.jface.text.source.Annotation;


/**
 * Allows an annotation to tell whether there are quick fixes
 * for it and to cache that state.
 * <p>
 * Caching the state is important to improve overall performance as calling
 * {@link dwtx.jface.text.quickassist.IQuickAssistAssistant#canFix(Annotation)}
 * can be expensive.
 * </p>
 * <p>
 * This interface can be implemented by clients.</p>
 * 
 * @since 3.2
 */
public interface IQuickFixableAnnotation {

    /**
     * Sets whether there are quick fixes available for
     * this annotation.
     * 
     * @param state <code>true</code> if there are quick fixes available, false otherwise
     */
    void setQuickFixable(bool state);

    /**
     * Tells whether the quick fixable state has been set.
     * <p>
     * Normally this means {@link #setQuickFixable(bool)} has been
     * called at least once but it can also be hard-coded, e.g. always
     * return <code>true</code>.
     * </p>
     * 
     * @return <code>true</code> if the state has been set
     */
    bool isQuickFixableStateSet();

    /**
     * Tells whether there are quick fixes for this annotation.
     * <p>
     * <strong>Note:</strong> This method must only be called
     * if {@link #isQuickFixableStateSet()} returns <code>true</code>.</p>
     * 
     * @return <code>true</code> if this annotation offers quick fixes
     * @throws AssertionFailedException if called when {@link #isQuickFixableStateSet()} is <code>false</code>
     */
    bool isQuickFixable() ;

}
