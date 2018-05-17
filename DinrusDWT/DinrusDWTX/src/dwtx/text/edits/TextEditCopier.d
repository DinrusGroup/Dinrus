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
module dwtx.text.edits.TextEditCopier;

import dwtx.text.edits.MultiTextEdit; // packageimport
import dwtx.text.edits.CopySourceEdit; // packageimport
import dwtx.text.edits.MoveSourceEdit; // packageimport
import dwtx.text.edits.CopyingRangeMarker; // packageimport
import dwtx.text.edits.ReplaceEdit; // packageimport
import dwtx.text.edits.EditDocument; // packageimport
import dwtx.text.edits.UndoCollector; // packageimport
import dwtx.text.edits.DeleteEdit; // packageimport
import dwtx.text.edits.MoveTargetEdit; // packageimport
import dwtx.text.edits.CopyTargetEdit; // packageimport
import dwtx.text.edits.ISourceModifier; // packageimport
import dwtx.text.edits.TextEditMessages; // packageimport
import dwtx.text.edits.TextEditProcessor; // packageimport
import dwtx.text.edits.MalformedTreeException; // packageimport
import dwtx.text.edits.TreeIterationInfo; // packageimport
import dwtx.text.edits.TextEditVisitor; // packageimport
import dwtx.text.edits.TextEditGroup; // packageimport
import dwtx.text.edits.TextEdit; // packageimport
import dwtx.text.edits.RangeMarker; // packageimport
import dwtx.text.edits.UndoEdit; // packageimport
import dwtx.text.edits.InsertEdit; // packageimport


import dwt.dwthelper.utils;

import dwtx.dwtxhelper.Collection;





import dwtx.core.runtime.Assert;


/**
 * Copies a tree of text edits. A text edit copier keeps a map
 * between original and new text edits. It can be used to map
 * a copy back to its original edit.
 *
 * @since 3.0
 */
public final class TextEditCopier {

    private TextEdit fEdit;
    private Map fCopies;

    /**
     * Constructs a new <code>TextEditCopier</code> for the
     * given edit. The actual copy is done by calling <code>
     * perform</code>.
     *
     * @param edit the edit to copy
     *
     * @see #perform()
     */
    public this(TextEdit edit) {
//         super();
        Assert.isNotNull(edit);
        fEdit= edit;
        fCopies= new HashMap();
    }

    /**
     * Performs the actual copying.
     *
     * @return the copy
     */
    public TextEdit perform() {
        TextEdit result= doCopy(fEdit);
        if (result !is null) {
            for (Iterator iter= fCopies.keySet().iterator(); iter.hasNext();) {
                TextEdit edit= cast(TextEdit)iter.next();
                edit.postProcessCopy_package(this);
            }
        }
        return result;
    }

    /**
     * Returns the copy for the original text edit.
     *
     * @param original the original for which the copy
     *  is requested
     * @return the copy of the original edit or <code>null</code>
     *  if the original isn't managed by this copier
     */
    public TextEdit getCopy(TextEdit original) {
        Assert.isNotNull(original);
        return cast(TextEdit)fCopies.get(original);
    }

    //---- helper methods --------------------------------------------

    private TextEdit doCopy(TextEdit edit) {
        TextEdit result= edit.doCopy_package();
        List children= edit.internalGetChildren();
        if (children !is null) {
            List newChildren= new ArrayList(children.size());
            for (Iterator iter= children.iterator(); iter.hasNext();) {
                TextEdit childCopy= doCopy(cast(TextEdit)iter.next());
                childCopy.internalSetParent(result);
                newChildren.add(childCopy);
            }
            result.internalSetChildren(newChildren);
        }
        addCopy(edit, result);
        return result;
    }

    private void addCopy(TextEdit original, TextEdit copy) {
        fCopies.put(original, copy);
    }
}
