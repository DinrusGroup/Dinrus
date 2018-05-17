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
module dwtx.jface.text.templates.InclusivePositionUpdater;

import dwtx.jface.text.templates.SimpleTemplateVariableResolver; // packageimport
import dwtx.jface.text.templates.TemplateBuffer; // packageimport
import dwtx.jface.text.templates.TemplateContext; // packageimport
import dwtx.jface.text.templates.TemplateContextType; // packageimport
import dwtx.jface.text.templates.Template; // packageimport
import dwtx.jface.text.templates.TemplateVariable; // packageimport
import dwtx.jface.text.templates.PositionBasedCompletionProposal; // packageimport
import dwtx.jface.text.templates.TemplateException; // packageimport
import dwtx.jface.text.templates.TemplateTranslator; // packageimport
import dwtx.jface.text.templates.DocumentTemplateContext; // packageimport
import dwtx.jface.text.templates.GlobalTemplateVariables; // packageimport
import dwtx.jface.text.templates.TemplateProposal; // packageimport
import dwtx.jface.text.templates.ContextTypeRegistry; // packageimport
import dwtx.jface.text.templates.JFaceTextTemplateMessages; // packageimport
import dwtx.jface.text.templates.TemplateCompletionProcessor; // packageimport
import dwtx.jface.text.templates.TextTemplateMessages; // packageimport
import dwtx.jface.text.templates.TemplateVariableType; // packageimport
import dwtx.jface.text.templates.TemplateVariableResolver; // packageimport


import dwt.dwthelper.utils;

import dwtx.jface.text.BadPositionCategoryException;
import dwtx.jface.text.DocumentEvent;
import dwtx.jface.text.IPositionUpdater;
import dwtx.jface.text.Position;

/**
 * Position updater that takes any change in [position.offset, position.offset + position.length] as
 * belonging to the position.
 *
 * @since 3.0
 */
class InclusivePositionUpdater : IPositionUpdater {

    /** The position category. */
    private const String fCategory;

    /**
     * Creates a new updater for the given <code>category</code>.
     *
     * @param category the new category.
     */
    public this(String category) {
        fCategory= category;
    }

    /*
     * @see dwtx.jface.text.IPositionUpdater#update(dwtx.jface.text.DocumentEvent)
     */
    public void update(DocumentEvent event) {

        int eventOffset= event.getOffset();
        int eventOldLength= event.getLength();
        int eventNewLength= event.getText() is null ? 0 : event.getText().length();
        int deltaLength= eventNewLength - eventOldLength;

        try {
            Position[] positions= event.getDocument().getPositions(fCategory);

            for (int i= 0; i !is positions.length; i++) {

                Position position= positions[i];

                if (position.isDeleted())
                    continue;

                int offset= position.getOffset();
                int length= position.getLength();
                int end= offset + length;

                if (offset > eventOffset + eventOldLength)
                    // position comes way
                    // after change - shift
                    position.setOffset(offset + deltaLength);
                else if (end < eventOffset) {
                    // position comes way before change -
                    // leave alone
                } else if (offset <= eventOffset && end >= eventOffset + eventOldLength) {
                    // event completely internal to the position - adjust length
                    position.setLength(length + deltaLength);
                } else if (offset < eventOffset) {
                    // event extends over end of position - adjust length
                    int newEnd= eventOffset + eventNewLength;
                    position.setLength(newEnd - offset);
                } else if (end > eventOffset + eventOldLength) {
                    // event extends from before position into it - adjust offset
                    // and length
                    // offset becomes end of event, length adjusted accordingly
                    // we want to recycle the overlapping part
                    position.setOffset(eventOffset);
                    int deleted= eventOffset + eventOldLength - offset;
                    position.setLength(length - deleted + eventNewLength);
                } else {
                    // event consumes the position - delete it
                    position.delete_();
                }
            }
        } catch (BadPositionCategoryException e) {
            // ignore and return
        }
    }

    /**
     * Returns the position category.
     *
     * @return the position category
     */
    public String getCategory() {
        return fCategory;
    }

}
