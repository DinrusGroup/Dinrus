/*******************************************************************************
 * Copyright (c) 2000, 2007 IBM Corporation and others.
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
module dwtx.jface.text.templates.TemplateTranslator;

import dwtx.jface.text.templates.SimpleTemplateVariableResolver; // packageimport
import dwtx.jface.text.templates.TemplateBuffer; // packageimport
import dwtx.jface.text.templates.TemplateContext; // packageimport
import dwtx.jface.text.templates.TemplateContextType; // packageimport
import dwtx.jface.text.templates.Template; // packageimport
import dwtx.jface.text.templates.TemplateVariable; // packageimport
import dwtx.jface.text.templates.PositionBasedCompletionProposal; // packageimport
import dwtx.jface.text.templates.TemplateException; // packageimport
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
import dwtx.dwtxhelper.Collection;
import dwtx.dwtxhelper.regex;

/**
 * The template translator translates a string into a template buffer. Regions marked as variables
 * are translated into <code>TemplateVariable</code>s.
 * <p>
 * The EBNF grammar of a valid string is as follows:
 * </p>
 * <p>
 * template := (text | escape)*. <br />
 * text := character - dollar. <br />
 * escape := dollar ('{' variable '}' | dollar). <br />
 * dollar := '$'. <br />
 * variable := identifier | identifier ':' type. <br />
 * type := qualifiedname | qualifiedname '(' arguments ')'. <br />
 * arguments := (argument ',')* argument. <br />
 * argument := qualifiedname | argumenttext. <br />
 * qualifiedname := (identifier '.')* identifier. <br />
 * argumenttext := "'" (character - "'" | "'" "'")* "'". <br />
 * </p>
 * <p>
 * Clients may only replace the <code>createVariable</code> method of this class.
 * </p>
 *
 * @since 3.0
 */
public class TemplateTranslator {
    /**
     * Regex pattern for qualifiedname
     * @since 3.4
     */
    private static const String QUALIFIED_NAME= "(?:\\w++\\.)*\\w++"; //$NON-NLS-1$

    /**
     * Regex pattern for argumenttext
     * @since 3.4
     */
    private static const String ARGUMENT_TEXT= "'(?:(?:'')|(?:[^']))*'"; //$NON-NLS-1$

    /**
     * Regex pattern for argument
     * @since 3.4
     */
    private static const String ARGUMENT= "(?:" ~ QUALIFIED_NAME ~ ")|(?:" ~ ARGUMENT_TEXT ~ ")"; //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$

    /**
     * Precompiled regex pattern for qualified names.
     * @since 3.3
     */
    private static Pattern PARAM_PATTERN_;
    private static Pattern PARAM_PATTERN(){
        if( PARAM_PATTERN_ is null ){
            synchronized( TemplateTranslator.classinfo ){
                if( PARAM_PATTERN_ is null ){
                    PARAM_PATTERN_ = Pattern.compile(ARGUMENT);
                }
            }
        }
        return PARAM_PATTERN_;
    }
    /**
     * Precompiled regex pattern for valid dollar escapes (dollar literals and variables) and
     * (invalid) single dollars.
     * @since 3.3
     */
    private static Pattern ESCAPE_PATTERN_;
    private static Pattern ESCAPE_PATTERN(){
        if( ESCAPE_PATTERN_ is null ){
            synchronized( TemplateTranslator.classinfo ){
                if( ESCAPE_PATTERN_ is null ){
                    ESCAPE_PATTERN_ = Pattern.compile(
                        "\\$\\$|\\$\\{\\s*+" ~ // $$|${                                                         //$NON-NLS-1$
                        "(\\w*+)" ~ // variable id group (1)                                                    //$NON-NLS-1$
                        "\\s*+(?::\\s*+" ~ // :                                                                 //$NON-NLS-1$
                        "(" ~ QUALIFIED_NAME ~ ")" ~ // variable type group (2)                                 //$NON-NLS-1$ //$NON-NLS-2$
                        "\\s*+(?:\\(\\s*+" ~ // (                                                               //$NON-NLS-1$
                        "((?:(?:" ~ ARGUMENT ~ ")\\s*+,\\s*+)*(?:" ~ ARGUMENT ~ "))" ~ // arguments group (3)   //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
                        "\\s*+\\))?\\s*+)?\\}|\\$"); // )}|$                                                    //$NON-NLS-1$
                }
            }
        }
        return ESCAPE_PATTERN_;
    }
    /**
     * @since 3.3
     */
    private final class VariableDescription {
        const List fOffsets;
        const String fName;
        TemplateVariableType fType;

        this(String name, TemplateVariableType type) {
            fOffsets= new ArrayList(5);
            fName= name;
            fType= type;
        }

        void mergeType(TemplateVariableType type)  {
            if (type is null)
                return;
            if (fType is null)
                fType= type;
            if (!type.opEquals(fType))
                fail(TextTemplateMessages.getFormattedString("TemplateTranslator.error.incompatible.type", stringcast(fName))); //$NON-NLS-1$
        }
    }

    /** Last translation error. */
    private String fErrorMessage;
    /**
     * Used to ensure compatibility with subclasses overriding
     * {@link #createVariable(String, String, int[])}.
     * @since 3.3
     */
    private TemplateVariableType fCurrentType;

    /**
     * Returns an error message if an error occurred for the last translation, <code>null</code>
     * otherwise.
     *
     * @return the error message if an error occurred during the most recent translation,
     *         <code>null</code> otherwise
     */
    public String getErrorMessage() {
        return fErrorMessage;
    }

    /**
     * Translates a template to a <code>TemplateBuffer</code>. <code>null</code> is returned if
     * there was an error. <code>getErrorMessage()</code> retrieves the associated error message.
     *
     * @param template the template to translate.
     * @return returns the template buffer corresponding to the string
     * @see #getErrorMessage()
     * @throws TemplateException if translation failed
     */
    public TemplateBuffer translate(Template template_)  {
        return parse(template_.getPattern());
    }

    /**
     * Translates a template string to <code>TemplateBuffer</code>. <code>null</code> is
     * returned if there was an error. <code>getErrorMessage()</code> retrieves the associated
     * error message.
     *
     * @param string the string to translate.
     * @return returns the template buffer corresponding to the string
     * @see #getErrorMessage()
     * @throws TemplateException if translation failed
     */
    public TemplateBuffer translate(String string)  {
        return parse(string);
    }

    /**
     * Internal parser.
     *
     * @param string the string to parse
     * @return the parsed <code>TemplateBuffer</code>
     * @throws TemplateException if the string does not conform to the template format
     */
    private TemplateBuffer parse(String string)  {

        fErrorMessage= null;
        final StringBuffer buffer= new StringBuffer(string.length());
        final Matcher matcher= ESCAPE_PATTERN.matcher(string);
        final Map variables= new LinkedHashMap();

        int complete= 0;
        while (matcher.find()) {
            // append any verbatim text
            buffer.append(string.substring(complete, matcher.start()));

            // check the escaped sequence
            if ("$".equals(matcher.group())) { //$NON-NLS-1$
                fail(TextTemplateMessages.getString("TemplateTranslator.error.incomplete.variable")); //$NON-NLS-1$
            } else if ("$$".equals(matcher.group())) { //$NON-NLS-1$
                // escaped $
                buffer.append('$');
            } else {
                // parse variable
                String name= matcher.group(1);
                String typeName= matcher.group(2);
                String params= matcher.group(3);
                TemplateVariableType type= createType(typeName, params);

                updateOrCreateVariable(variables, name, type, buffer.length());

                buffer.append(name);
            }
            complete= matcher.end();
        }
        // append remaining verbatim text
        buffer.append(string.substring(complete));

        TemplateVariable[] vars= createVariables(variables);
        return new TemplateBuffer(buffer.toString(), vars);
    }

    private TemplateVariableType createType(String typeName, String paramString) {
        if (typeName is null)
            return null;

        if (paramString is null)
            return new TemplateVariableType(typeName);

        final Matcher matcher= PARAM_PATTERN.matcher(paramString);
        List params= new ArrayList(5);
        while (matcher.find()) {
            String argument= matcher.group();
            if (argument.charAt(0) is '\'') {
                // argumentText
                argument= argument.substring(1, argument.length() - 1).replaceAll("''", "'"); //$NON-NLS-1$ //$NON-NLS-2$
            }

            params.add(argument);
        }

        return new TemplateVariableType(typeName, stringcast( params.toArray()));
    }

    private void fail(String message)  {
        fErrorMessage= message;
        throw new TemplateException(message);
    }

    /**
     * If there is no variable named <code>name</code>, a new variable with the given type, name
     * and offset is created. If one exists, the offset is added to the variable and the type is
     * merged with the existing type.
     *
     * @param variables the variables by variable name
     * @param name the name of the variable
     * @param type the variable type, <code>null</code> for not defined
     * @param offset the buffer offset of the variable
     * @throws TemplateException if merging the type fails
     * @since 3.3
     */
    private void updateOrCreateVariable(Map variables, String name, TemplateVariableType type, int offset)  {
        VariableDescription varDesc= cast(VariableDescription) variables.get(name);
        if (varDesc is null) {
            varDesc= new VariableDescription(name, type);
            variables.put(name, varDesc);
        } else {
            varDesc.mergeType(type);
        }
        varDesc.fOffsets.add(new Integer(offset));
    }

    /**
     * Creates proper {@link TemplateVariable}s from the variable descriptions.
     *
     * @param variables the variable descriptions by variable name
     * @return the corresponding variables
     * @since 3.3
     */
    private TemplateVariable[] createVariables(Map variables) {
        TemplateVariable[] result= new TemplateVariable[variables.size()];
        int idx= 0;
        for (Iterator it= variables.values().iterator(); it.hasNext(); idx++) {
            VariableDescription desc= cast(VariableDescription) it.next();
            TemplateVariableType type= desc.fType is null ? new TemplateVariableType(desc.fName) : desc.fType;
            int[] offsets= new int[desc.fOffsets.size()];
            int i= 0;
            for (Iterator intIt= desc.fOffsets.iterator(); intIt.hasNext(); i++) {
                Integer offset= cast(Integer) intIt.next();
                offsets[i]= offset.intValue();
            }
            fCurrentType= type;
            /*
             * Call the deprecated version of createVariable. When not overridden, it will delegate
             * to the new version using fCurrentType.
             */
            TemplateVariable var= createVariable(type.getName(), desc.fName, offsets);
            result[idx]= var;
        }
        fCurrentType= null; // avoid dangling reference
        return result;
    }

    /**
     * Hook method to create new variables. Subclasses may override to supply their custom variable
     * type.
     * <p>
     * Clients may replace this method.
     * </p>
     *
     * @param type the type of the new variable.
     * @param name the name of the new variable.
     * @param offsets the offsets where the variable occurs in the template
     * @return a new instance of <code>TemplateVariable</code>
     * @deprecated as of 3.3 use {@link #createVariable(TemplateVariableType, String, int[])} instead
     */
    protected TemplateVariable createVariable(String type, String name, int[] offsets) {
        return createVariable(fCurrentType, name, offsets);
    }

    /**
     * Hook method to create new variables. Subclasses may override to supply their custom variable
     * type.
     * <p>
     * Clients may replace this method.
     * </p>
     *
     * @param type the type of the new variable.
     * @param name the name of the new variable.
     * @param offsets the offsets where the variable occurs in the template
     * @return a new instance of <code>TemplateVariable</code>
     * @since 3.3
     */
    protected TemplateVariable createVariable(TemplateVariableType type, String name, int[] offsets) {
        return new TemplateVariable(type, name, name, offsets);
    }
}
