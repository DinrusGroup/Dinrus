/*******************************************************************************
 * Copyright (c) 2000, 2005 IBM Corporation and others.
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
module dwtx.jface.internal.text.link.contentassist.Helper2;

import dwtx.jface.internal.text.link.contentassist.IProposalListener; // packageimport
import dwtx.jface.internal.text.link.contentassist.LineBreakingReader; // packageimport
import dwtx.jface.internal.text.link.contentassist.CompletionProposalPopup2; // packageimport
import dwtx.jface.internal.text.link.contentassist.ContextInformationPopup2; // packageimport
import dwtx.jface.internal.text.link.contentassist.ContentAssistMessages; // packageimport
import dwtx.jface.internal.text.link.contentassist.PopupCloser2; // packageimport
import dwtx.jface.internal.text.link.contentassist.IContentAssistListener2; // packageimport
import dwtx.jface.internal.text.link.contentassist.ContentAssistant2; // packageimport
import dwtx.jface.internal.text.link.contentassist.AdditionalInfoController2; // packageimport


import dwt.dwthelper.utils;



import dwt.widgets.Widget;


/**
 * Helper class for testing widget state.
 */
class Helper2 {

    /**
     * Returns whether the widget is <code>null</code> or disposed.
     *
     * @param widget the widget to check
     * @return <code>true</code> if the widget is neither <code>null</code> nor disposed
     */
    public static bool okToUse(Widget widget) {
        return (widget !is null && !widget.isDisposed());
    }
}
