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
module dwtx.jface.text.templates.SimpleTemplateVariableResolver;

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
import dwtx.jface.text.templates.ContextTypeRegistry; // packageimport
import dwtx.jface.text.templates.JFaceTextTemplateMessages; // packageimport
import dwtx.jface.text.templates.TemplateCompletionProcessor; // packageimport
import dwtx.jface.text.templates.TextTemplateMessages; // packageimport
import dwtx.jface.text.templates.TemplateVariableType; // packageimport
import dwtx.jface.text.templates.TemplateVariableResolver; // packageimport


import dwt.dwthelper.utils;


/**
 * A simple template variable resolver, which always evaluates to a defined string.
 * <p>
 * Clients may instantiate and extend this class.
 * </p>
 *
 * @since 3.0
 */
public class SimpleTemplateVariableResolver : TemplateVariableResolver {

    /** The string to which this variable evaluates. */
    private String fEvaluationString;

    /*
     * @see TemplateVariableResolver#TemplateVariableResolver(String, String)
     */
    protected this(String type, String description) {
        super(type, description);
    }

    /**
     * Sets the string to which this variable evaluates.
     *
     * @param evaluationString the evaluation string, may be <code>null</code>.
     */
    public final void setEvaluationString(String evaluationString) {
        fEvaluationString= evaluationString;
    }

    /*
     * @see TemplateVariableResolver#evaluate(TemplateContext)
     */
    protected String resolve(TemplateContext context) {
        return fEvaluationString;
    }

    /**
     * Returns always <code>true</code>, since simple variables are normally
     * unambiguous.
     *
     * @param context {@inheritDoc}
     * @return <code>true</code>
     */
    protected bool isUnambiguous(TemplateContext context) {
        return true;
    }
}
