/*******************************************************************************
 * Copyright (c) 2000, 2006 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *     Sebastian Davids: sdavids@gmx.de - see bug 25376
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/
module dwtx.jface.text.templates.GlobalTemplateVariables;

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
import dwtx.jface.text.templates.InclusivePositionUpdater; // packageimport
import dwtx.jface.text.templates.TemplateProposal; // packageimport
import dwtx.jface.text.templates.ContextTypeRegistry; // packageimport
import dwtx.jface.text.templates.JFaceTextTemplateMessages; // packageimport
import dwtx.jface.text.templates.TemplateCompletionProcessor; // packageimport
import dwtx.jface.text.templates.TextTemplateMessages; // packageimport
import dwtx.jface.text.templates.TemplateVariableType; // packageimport
import dwtx.jface.text.templates.TemplateVariableResolver; // packageimport


import dwt.dwthelper.utils;

// import com.ibm.icu.text.DateFormat;
// import com.ibm.icu.util.Calendar;

/**
 * Global variables which are available in any context.
 * <p>
 * Clients may instantiate the classes contained within this class.
 * </p>
 *
 * @since 3.0
 */
public class GlobalTemplateVariables {

    /** The type of the selection variables. */
    public static const String SELECTION= "selection"; //$NON-NLS-1$

    /**
     * The cursor variable determines the cursor placement after template edition.
     */
    public static class Cursor : SimpleTemplateVariableResolver {

        /** Name of the cursor variable, value= {@value} */
        public static const String NAME= "cursor"; //$NON-NLS-1$

        /**
         * Creates a new cursor variable
         */
        public this() {
            super(NAME, TextTemplateMessages.getString("GlobalVariables.variable.description.cursor")); //$NON-NLS-1$
            setEvaluationString(""); //$NON-NLS-1$
        }
    }

    /**
     * The word selection variable determines templates that work on a full
     * lines selection.
     */
    public static class WordSelection : SimpleTemplateVariableResolver {

        /** Name of the word selection variable, value= {@value} */
        public static const String NAME= "word_selection"; //$NON-NLS-1$

        /**
         * Creates a new word selection variable
         */
        public this() {
            super(NAME, TextTemplateMessages.getString("GlobalVariables.variable.description.selectedWord")); //$NON-NLS-1$
        }
        protected String resolve(TemplateContext context) {
            String selection= context.getVariable(SELECTION);
            if (selection is null)
                return ""; //$NON-NLS-1$
            return selection;
        }
    }

    /**
     * The line selection variable determines templates that work on selected
     * lines.
     */
    public static class LineSelection : SimpleTemplateVariableResolver {

        /** Name of the line selection variable, value= {@value} */
        public static const String NAME= "line_selection"; //$NON-NLS-1$

        /**
         * Creates a new line selection variable
         */
        public this() {
            super(NAME, TextTemplateMessages.getString("GlobalVariables.variable.description.selectedLines")); //$NON-NLS-1$
        }
        protected String resolve(TemplateContext context) {
            String selection= context.getVariable(SELECTION);
            if (selection is null)
                return ""; //$NON-NLS-1$
            return selection;
        }
    }

    /**
     * The dollar variable inserts an escaped dollar symbol.
     */
    public static class Dollar : SimpleTemplateVariableResolver {
        /**
         * Creates a new dollar variable
         */
        public this() {
            super("dollar", TextTemplateMessages.getString("GlobalVariables.variable.description.dollar")); //$NON-NLS-1$ //$NON-NLS-2$
            setEvaluationString("$"); //$NON-NLS-1$
        }
    }

    /**
     * The date variable evaluates to the current date.
     */
    public static class Date : SimpleTemplateVariableResolver {
        /**
         * Creates a new date variable
         */
        public this() {
            super("date", TextTemplateMessages.getString("GlobalVariables.variable.description.date")); //$NON-NLS-1$ //$NON-NLS-2$
        }
        protected String resolve(TemplateContext context) {
            implMissing(__FILE__,__LINE__);
            return null;
            //return DateFormat.getDateInstance().format(new java.util.Date());
        }
    }

    /**
     * The year variable evaluates to the current year.
     */
    public static class Year : SimpleTemplateVariableResolver {
        /**
         * Creates a new year variable
         */
        public this() {
            super("year", TextTemplateMessages.getString("GlobalVariables.variable.description.year")); //$NON-NLS-1$ //$NON-NLS-2$
        }
        protected String resolve(TemplateContext context) {
            implMissing(__FILE__,__LINE__);
            return null;
            //return Integer.toString(Calendar.getInstance().get(Calendar.YEAR));
        }
    }

    /**
     * The time variable evaluates to the current time.
     */
    public static class Time : SimpleTemplateVariableResolver {
        /**
         * Creates a new time variable
         */
        public this() {
            super("time", TextTemplateMessages.getString("GlobalVariables.variable.description.time")); //$NON-NLS-1$ //$NON-NLS-2$
        }

        /**
         * {@inheritDoc}
         */
        protected String resolve(TemplateContext context) {
            implMissing(__FILE__,__LINE__);
            return null;
            //return DateFormat.getTimeInstance().format(new java.util.Date());
        }
    }

    /**
     * The user variable evaluates to the current user.
     */
    public static class User : SimpleTemplateVariableResolver {
        /**
         * Creates a new user name variable
         */
        public this() {
            super("user", TextTemplateMessages.getString("GlobalVariables.variable.description.user")); //$NON-NLS-1$ //$NON-NLS-2$
        }

        /**
         * {@inheritDoc}
         */
        protected String resolve(TemplateContext context) {
            return System.getProperty("user.name"); //$NON-NLS-1$
        }
    }
}
