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
module dwtx.jface.text.templates.TemplateVariableType;

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
import dwtx.jface.text.templates.ContextTypeRegistry; // packageimport
import dwtx.jface.text.templates.JFaceTextTemplateMessages; // packageimport
import dwtx.jface.text.templates.TemplateCompletionProcessor; // packageimport
import dwtx.jface.text.templates.TextTemplateMessages; // packageimport
import dwtx.jface.text.templates.TemplateVariableResolver; // packageimport


import dwt.dwthelper.utils;

import dwtx.dwtxhelper.Collection;




import dwtx.core.runtime.Assert;


/**
 * Value object that represents the type of a template variable. A type is defined by its name and
 * may have parameters.
 *
 * @since 3.3
 * @noinstantiate This class is not intended to be instantiated by clients.
 */
public final class TemplateVariableType {

    /** The name of the type. */
    private const String fName;
    /** The parameter list. */
    private const List fParams;

    this(String name) {
        this(name, new String[0]);
    }

    this(String name, String[] params) {
        Assert.isLegal(name !is null);
        Assert.isLegal(params !is null);
        fName= name;
        fParams= Collections.unmodifiableList(new ArrayList(Arrays.asList(stringcast(params))));
    }

    /**
     * Returns the type name of this variable type.
     *
     * @return the type name of this variable type
     */
    public String getName() {
        return fName;
    }

    /**
     * Returns the unmodifiable and possibly empty list of parameters (element type: {@link String})
     *
     * @return the list of parameters
     */
    public List getParams() {
        return fParams;
    }

    /*
     * @see java.lang.Object#equals(java.lang.Object)
     */
    public override int opEquals(Object obj) {
        if ( cast(TemplateVariableType)obj ) {
            TemplateVariableType other= cast(TemplateVariableType) obj;
            return other.fName.equals(fName) && other.fParams.opEquals(cast(Object)fParams);
        }
        return false;
    }

    /*
     * @see java.lang.Object#hashCode()
     */
    public override hash_t toHash() {
        alias .toHash toHash;
        return fName.toHash() + fParams.toHash();
    }
    /*
     * @see java.lang.Object#toString()
     * @since 3.3
     */
    public override String toString() {
        return fName ~ (cast(Object)fParams).toString();
    }
}
