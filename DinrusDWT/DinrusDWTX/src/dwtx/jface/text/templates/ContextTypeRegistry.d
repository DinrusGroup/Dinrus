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
module dwtx.jface.text.templates.ContextTypeRegistry;

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
import dwtx.jface.text.templates.InclusivePositionUpdater; // packageimport
import dwtx.jface.text.templates.TemplateProposal; // packageimport
import dwtx.jface.text.templates.JFaceTextTemplateMessages; // packageimport
import dwtx.jface.text.templates.TemplateCompletionProcessor; // packageimport
import dwtx.jface.text.templates.TextTemplateMessages; // packageimport
import dwtx.jface.text.templates.TemplateVariableType; // packageimport
import dwtx.jface.text.templates.TemplateVariableResolver; // packageimport


import dwt.dwthelper.utils;

import dwtx.dwtxhelper.Collection;



/**
 * A registry for context types. Editor implementors will usually instantiate a
 * registry and configure the context types available in their editor.
 * <p>
 * In order to pick up templates contributed using the <code>dwtx.ui.editors.templates</code>
 * extension point, use a <code>ContributionContextTypeRegistry</code>.
 * </p>
 *
 * @since 3.0
 */
public class ContextTypeRegistry {

    /** all known context types */
    private const Map fContextTypes;

    this(){
        fContextTypes= new LinkedHashMap();
    }
    /**
     * Adds a context type to the registry. If there already is a context type
     * with the same ID registered, it is replaced.
     *
     * @param contextType the context type to add
     */
    public void addContextType(TemplateContextType contextType) {
        fContextTypes.put(contextType.getId(), contextType);
    }

    /**
     * Returns the context type if the id is valid, <code>null</code> otherwise.
     *
     * @param id the id of the context type to retrieve
     * @return the context type if <code>name</code> is valid, <code>null</code> otherwise
     */
    public TemplateContextType getContextType(String id) {
        return cast(TemplateContextType) fContextTypes.get(id);
    }

    /**
     * Returns an iterator over all registered context types.
     *
     * @return an iterator over all registered context types
     */
    public Iterator contextTypes() {
        return fContextTypes.values().iterator();
    }
}
