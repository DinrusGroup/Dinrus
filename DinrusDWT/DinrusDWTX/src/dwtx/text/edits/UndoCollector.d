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
module dwtx.text.edits.UndoCollector;

import dwtx.text.edits.MultiTextEdit; // packageimport
import dwtx.text.edits.CopySourceEdit; // packageimport
import dwtx.text.edits.MoveSourceEdit; // packageimport
import dwtx.text.edits.CopyingRangeMarker; // packageimport
import dwtx.text.edits.ReplaceEdit; // packageimport
import dwtx.text.edits.EditDocument; // packageimport
import dwtx.text.edits.DeleteEdit; // packageimport
import dwtx.text.edits.MoveTargetEdit; // packageimport
import dwtx.text.edits.CopyTargetEdit; // packageimport
import dwtx.text.edits.TextEditCopier; // packageimport
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


import dwtx.core.runtime.Assert;
import dwtx.jface.text.BadLocationException;
import dwtx.jface.text.DocumentEvent;
import dwtx.jface.text.IDocument;
import dwtx.jface.text.IDocumentListener;


class UndoCollector : IDocumentListener {

    protected UndoEdit undo;

    package UndoEdit undo_package(){
        return undo;
    }

    private int fOffset;
    private int fLength;

    /**
     * @since 3.1
     */
    private String fLastCurrentText;

    public this(TextEdit root) {
        fOffset= root.getOffset();
        fLength= root.getLength();
    }

    public void connect(IDocument document) {
        document.addDocumentListener(this);
        undo= new UndoEdit();
    }

    public void disconnect(IDocument document) {
        if (undo !is null) {
            document.removeDocumentListener(this);
            undo.defineRegion(fOffset, fLength);
        }
    }

    public void documentChanged(DocumentEvent event) {
        fLength+= getDelta(event);
    }

    private static int getDelta(DocumentEvent event) {
        String text= event.getText();
        return text is null ? -event.getLength() : (text.length() - event.getLength());
    }

    public void documentAboutToBeChanged(DocumentEvent event) {
        int offset= event.getOffset();
        int currentLength= event.getLength();
        String currentText= null;
        try {
            currentText= event.getDocument().get(offset, currentLength);
        } catch (BadLocationException cannotHappen) {
            Assert.isTrue(false, "Can't happen"); //$NON-NLS-1$
        }

        /*
         * see https://bugs.eclipse.org/bugs/show_bug.cgi?id=93634
         * If the same string is replaced on many documents (e.g. rename
         * package), the size of the undo can be reduced by using the same
         * String instance in all edits, instead of using the unique String
         * returned from IDocument.get(int, int).
         */
        if (fLastCurrentText !is null && fLastCurrentText.equals(currentText))
            currentText= fLastCurrentText;
        else
            fLastCurrentText= currentText;

        String newText= event.getText();
        undo.add(new ReplaceEdit(offset, newText !is null ? newText.length() : 0, currentText));
    }
}
