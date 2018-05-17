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
module dwtx.jface.text.link.ProposalPosition;

import dwtx.jface.text.link.LinkedModeModel; // packageimport
import dwtx.jface.text.link.LinkedPosition; // packageimport
import dwtx.jface.text.link.ILinkedModeListener; // packageimport
import dwtx.jface.text.link.TabStopIterator; // packageimport
import dwtx.jface.text.link.LinkedModeUI; // packageimport
import dwtx.jface.text.link.InclusivePositionUpdater; // packageimport
import dwtx.jface.text.link.LinkedPositionGroup; // packageimport
import dwtx.jface.text.link.LinkedModeManager; // packageimport
import dwtx.jface.text.link.LinkedPositionAnnotations; // packageimport


import dwt.dwthelper.utils;

import dwtx.dwtxhelper.Collection;

import dwtx.jface.text.IDocument;
import dwtx.jface.text.contentassist.ICompletionProposal;

/**
 * LinkedPosition with added completion proposals.
 * <p>
 * Clients may instantiate or extend this class.
 * </p>
 *
 * @since 3.0
 */
public class ProposalPosition : LinkedPosition {

    /**
     * The proposals
     */
    private ICompletionProposal[] fProposals;

    /**
     * Creates a new instance.
     *
     * @param document the document
     * @param offset the offset of the position
     * @param length the length of the position
     * @param sequence the iteration sequence rank
     * @param proposals the proposals to be shown when entering this position
     */
    public this(IDocument document, int offset, int length, int sequence, ICompletionProposal[] proposals) {
        super(document, offset, length, sequence);
        fProposals= copy(proposals);
    }

    /**
     * Creates a new instance, with no sequence number.
     *
     * @param document the document
     * @param offset the offset of the position
     * @param length the length of the position
     * @param proposals the proposals to be shown when entering this position
     */
    public this(IDocument document, int offset, int length, ICompletionProposal[] proposals) {
        super(document, offset, length, LinkedPositionGroup.NO_STOP);
        fProposals= copy(proposals);
    }

    /*
     * @since 3.1
     */
    private ICompletionProposal[] copy(ICompletionProposal[] proposals) {
        if (proposals !is null) {
            ICompletionProposal[] copy= new ICompletionProposal[proposals.length];
            SimpleType!(ICompletionProposal).arraycopy(proposals, 0, copy, 0, proposals.length);
            return copy;
        }
        return null;
    }

    /*
     * @see java.lang.Object#equals(java.lang.Object)
     */
    public override int opEquals(Object o) {
        if ( cast(ProposalPosition)o ) {
            if (super.opEquals(o)) {
                return Arrays.equals(fProposals, (cast(ProposalPosition)o).fProposals);
            }
        }
        return false;
    }

    /**
     * Returns the proposals attached to this position. The returned array is owned by
     * this <code>ProposalPosition</code> and may not be modified by clients.
     *
     * @return an array of choices, including the initial one. Callers must not
     *         modify it.
     */
    public ICompletionProposal[] getChoices() {
        return fProposals;
    }

    /*
     * @see dwtx.jdt.internal.ui.text.link.LinkedPosition#hashCode()
     */
    public override hash_t toHash() {
        return super.toHash() | (fProposals is null ? 0 : (cast(hash_t)fProposals.ptr)/+.toHash()+/);
    }
}
