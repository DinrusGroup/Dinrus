/*******************************************************************************
 * Copyright (c) 2006 IBM Corporation and others.
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
module dwtx.jface.internal.text.revisions.HunkComputer;

import dwtx.jface.internal.text.revisions.LineIndexOutOfBoundsException; // packageimport
import dwtx.jface.internal.text.revisions.Hunk; // packageimport
import dwtx.jface.internal.text.revisions.Colors; // packageimport
import dwtx.jface.internal.text.revisions.ChangeRegion; // packageimport
import dwtx.jface.internal.text.revisions.Range; // packageimport
import dwtx.jface.internal.text.revisions.RevisionPainter; // packageimport
import dwtx.jface.internal.text.revisions.RevisionSelectionProvider; // packageimport


import dwt.dwthelper.utils;

import dwtx.dwtxhelper.Collection;


import dwtx.jface.text.source.ILineDiffInfo;
import dwtx.jface.text.source.ILineDiffer;


/**
 * Computes the diff hunks from an {@link ILineDiffer}.
 *
 * @since 3.3
 */
public final class HunkComputer {
    /**
     * Converts the line-based information of {@link ILineDiffer} into {@link Hunk}s, grouping
     * contiguous blocks of lines that are changed (added, deleted).
     *
     * @param differ the line differ to query
     * @param lines the number of lines to query
     * @return the corresponding {@link Hunk} information
     */
    public static Hunk[] computeHunks(ILineDiffer differ, int lines) {
        List hunks= new ArrayList(lines);

        int added= 0;
        int changed= 0;
        ILineDiffInfo info= null;
        for (int line= 0; line < lines; line++) {
            info= differ.getLineInfo(line);
            if (info is null)
                continue;

            int changeType= info.getChangeType();
            switch (changeType) {
                case ILineDiffInfo.ADDED:
                    added++;
                    continue;
                case ILineDiffInfo.CHANGED:
                    changed++;
                    continue;
                case ILineDiffInfo.UNCHANGED:
                    added -= info.getRemovedLinesAbove();
                    if (added !is 0 || changed !is 0) {
                        hunks.add(new Hunk(line - changed - Math.max(0, added), added, changed));
                        added= 0;
                        changed= 0;
                    }
                default:
            }
        }

        // last hunk
        if (info !is null) {
            added -= info.getRemovedLinesBelow();
            if (added !is 0 || changed !is 0) {
                hunks.add(new Hunk(lines - changed, added, changed));
                added= 0;
                changed= 0;
            }
        }

        return arraycast!(Hunk)( hunks.toArray());
    }
    private this() {
    }
}
