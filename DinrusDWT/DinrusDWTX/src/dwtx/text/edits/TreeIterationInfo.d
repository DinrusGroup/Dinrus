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
module dwtx.text.edits.TreeIterationInfo;

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
import dwtx.text.edits.TextEditCopier; // packageimport
import dwtx.text.edits.ISourceModifier; // packageimport
import dwtx.text.edits.TextEditMessages; // packageimport
import dwtx.text.edits.TextEditProcessor; // packageimport
import dwtx.text.edits.MalformedTreeException; // packageimport
import dwtx.text.edits.TextEditVisitor; // packageimport
import dwtx.text.edits.TextEditGroup; // packageimport
import dwtx.text.edits.TextEdit; // packageimport
import dwtx.text.edits.RangeMarker; // packageimport
import dwtx.text.edits.UndoEdit; // packageimport
import dwtx.text.edits.InsertEdit; // packageimport


import dwt.dwthelper.utils;

import dwtx.core.runtime.Assert;


class TreeIterationInfo {

    interface Visitor {
        void visit(TextEdit edit);
    }

    private int fMark= -1;
    private TextEdit[][] fEditStack;
    private int[] fIndexStack;

    public this(){
        fEditStack= new TextEdit[][](10);
        fIndexStack= new int[10];
    }

    public int getSize() {
        return fMark + 1;
    }
    public void push(TextEdit[] edits) {
        if (++fMark is fEditStack.length) {
            TextEdit[][] t1= new TextEdit[][](fEditStack.length * 2);
            SimpleType!(TextEdit[]).arraycopy(fEditStack, 0, t1, 0, fEditStack.length);
            fEditStack= t1;
            int[] t2= new int[fEditStack.length];
            System.arraycopy(fIndexStack, 0, t2, 0, fIndexStack.length);
            fIndexStack= t2;
        }
        fEditStack[fMark]= edits;
        fIndexStack[fMark]= -1;
    }
    public void setIndex(int index) {
        fIndexStack[fMark]= index;
    }
    public void pop() {
        fEditStack[fMark]= null;
        fIndexStack[fMark]= -1;
        fMark--;
    }
    public void accept(Visitor visitor) {
        for (int i= fMark; i >= 0; i--) {
            Assert.isTrue(fIndexStack[i] >= 0);
            int start= fIndexStack[i] + 1;
            TextEdit[] edits= fEditStack[i];
            for (int s= start; s < edits.length; s++) {
                visitor.visit(edits[s]);
            }
        }
    }
}
