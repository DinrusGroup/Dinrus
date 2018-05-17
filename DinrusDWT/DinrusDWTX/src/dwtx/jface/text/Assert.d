/*******************************************************************************
 * Copyright (c) 2000, 2008 IBM Corporation and others.
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
module dwtx.jface.text.Assert;

import dwtx.jface.text.IDocumentPartitioningListener; // packageimport
import dwtx.jface.text.DefaultTextHover; // packageimport
import dwtx.jface.text.AbstractInformationControl; // packageimport
import dwtx.jface.text.TextUtilities; // packageimport
import dwtx.jface.text.IInformationControlCreatorExtension; // packageimport
import dwtx.jface.text.AbstractInformationControlManager; // packageimport
import dwtx.jface.text.ITextViewerExtension2; // packageimport
import dwtx.jface.text.IDocumentPartitioner; // packageimport
import dwtx.jface.text.DefaultIndentLineAutoEditStrategy; // packageimport
import dwtx.jface.text.ITextSelection; // packageimport
import dwtx.jface.text.Document; // packageimport
import dwtx.jface.text.FindReplaceDocumentAdapterContentProposalProvider; // packageimport
import dwtx.jface.text.ITextListener; // packageimport
import dwtx.jface.text.BadPartitioningException; // packageimport
import dwtx.jface.text.ITextViewerExtension5; // packageimport
import dwtx.jface.text.IDocumentPartitionerExtension3; // packageimport
import dwtx.jface.text.IUndoManager; // packageimport
import dwtx.jface.text.ITextHoverExtension2; // packageimport
import dwtx.jface.text.IRepairableDocument; // packageimport
import dwtx.jface.text.IRewriteTarget; // packageimport
import dwtx.jface.text.DefaultPositionUpdater; // packageimport
import dwtx.jface.text.RewriteSessionEditProcessor; // packageimport
import dwtx.jface.text.TextViewerHoverManager; // packageimport
import dwtx.jface.text.DocumentRewriteSession; // packageimport
import dwtx.jface.text.TextViewer; // packageimport
import dwtx.jface.text.ITextViewerExtension8; // packageimport
import dwtx.jface.text.RegExMessages; // packageimport
import dwtx.jface.text.IDelayedInputChangeProvider; // packageimport
import dwtx.jface.text.ITextOperationTargetExtension; // packageimport
import dwtx.jface.text.IWidgetTokenOwner; // packageimport
import dwtx.jface.text.IViewportListener; // packageimport
import dwtx.jface.text.GapTextStore; // packageimport
import dwtx.jface.text.MarkSelection; // packageimport
import dwtx.jface.text.IDocumentPartitioningListenerExtension; // packageimport
import dwtx.jface.text.IDocumentAdapterExtension; // packageimport
import dwtx.jface.text.IInformationControlExtension; // packageimport
import dwtx.jface.text.IDocumentPartitioningListenerExtension2; // packageimport
import dwtx.jface.text.DefaultDocumentAdapter; // packageimport
import dwtx.jface.text.ITextViewerExtension3; // packageimport
import dwtx.jface.text.IInformationControlCreator; // packageimport
import dwtx.jface.text.TypedRegion; // packageimport
import dwtx.jface.text.ISynchronizable; // packageimport
import dwtx.jface.text.IMarkRegionTarget; // packageimport
import dwtx.jface.text.TextViewerUndoManager; // packageimport
import dwtx.jface.text.IRegion; // packageimport
import dwtx.jface.text.IInformationControlExtension2; // packageimport
import dwtx.jface.text.IDocumentExtension4; // packageimport
import dwtx.jface.text.IDocumentExtension2; // packageimport
import dwtx.jface.text.IDocumentPartitionerExtension2; // packageimport
import dwtx.jface.text.DefaultInformationControl; // packageimport
import dwtx.jface.text.IWidgetTokenOwnerExtension; // packageimport
import dwtx.jface.text.DocumentClone; // packageimport
import dwtx.jface.text.DefaultUndoManager; // packageimport
import dwtx.jface.text.IFindReplaceTarget; // packageimport
import dwtx.jface.text.IAutoEditStrategy; // packageimport
import dwtx.jface.text.ILineTrackerExtension; // packageimport
import dwtx.jface.text.IUndoManagerExtension; // packageimport
import dwtx.jface.text.TextSelection; // packageimport
import dwtx.jface.text.DefaultAutoIndentStrategy; // packageimport
import dwtx.jface.text.IAutoIndentStrategy; // packageimport
import dwtx.jface.text.IPainter; // packageimport
import dwtx.jface.text.IInformationControl; // packageimport
import dwtx.jface.text.IInformationControlExtension3; // packageimport
import dwtx.jface.text.ITextViewerExtension6; // packageimport
import dwtx.jface.text.IInformationControlExtension4; // packageimport
import dwtx.jface.text.DefaultLineTracker; // packageimport
import dwtx.jface.text.IDocumentInformationMappingExtension; // packageimport
import dwtx.jface.text.IRepairableDocumentExtension; // packageimport
import dwtx.jface.text.ITextHover; // packageimport
import dwtx.jface.text.FindReplaceDocumentAdapter; // packageimport
import dwtx.jface.text.ILineTracker; // packageimport
import dwtx.jface.text.Line; // packageimport
import dwtx.jface.text.ITextViewerExtension; // packageimport
import dwtx.jface.text.IDocumentAdapter; // packageimport
import dwtx.jface.text.TextEvent; // packageimport
import dwtx.jface.text.BadLocationException; // packageimport
import dwtx.jface.text.AbstractDocument; // packageimport
import dwtx.jface.text.AbstractLineTracker; // packageimport
import dwtx.jface.text.TreeLineTracker; // packageimport
import dwtx.jface.text.ITextPresentationListener; // packageimport
import dwtx.jface.text.Region; // packageimport
import dwtx.jface.text.ITextViewer; // packageimport
import dwtx.jface.text.IDocumentInformationMapping; // packageimport
import dwtx.jface.text.MarginPainter; // packageimport
import dwtx.jface.text.IPaintPositionManager; // packageimport
import dwtx.jface.text.TextPresentation; // packageimport
import dwtx.jface.text.IFindReplaceTargetExtension; // packageimport
import dwtx.jface.text.ISlaveDocumentManagerExtension; // packageimport
import dwtx.jface.text.ISelectionValidator; // packageimport
import dwtx.jface.text.IDocumentExtension; // packageimport
import dwtx.jface.text.PropagatingFontFieldEditor; // packageimport
import dwtx.jface.text.ConfigurableLineTracker; // packageimport
import dwtx.jface.text.SlaveDocumentEvent; // packageimport
import dwtx.jface.text.IDocumentListener; // packageimport
import dwtx.jface.text.PaintManager; // packageimport
import dwtx.jface.text.IFindReplaceTargetExtension3; // packageimport
import dwtx.jface.text.ITextDoubleClickStrategy; // packageimport
import dwtx.jface.text.IDocumentExtension3; // packageimport
import dwtx.jface.text.Position; // packageimport
import dwtx.jface.text.TextMessages; // packageimport
import dwtx.jface.text.CopyOnWriteTextStore; // packageimport
import dwtx.jface.text.WhitespaceCharacterPainter; // packageimport
import dwtx.jface.text.IPositionUpdater; // packageimport
import dwtx.jface.text.DefaultTextDoubleClickStrategy; // packageimport
import dwtx.jface.text.ListLineTracker; // packageimport
import dwtx.jface.text.ITextInputListener; // packageimport
import dwtx.jface.text.BadPositionCategoryException; // packageimport
import dwtx.jface.text.IWidgetTokenKeeperExtension; // packageimport
import dwtx.jface.text.IInputChangedListener; // packageimport
import dwtx.jface.text.ITextOperationTarget; // packageimport
import dwtx.jface.text.IDocumentInformationMappingExtension2; // packageimport
import dwtx.jface.text.ITextViewerExtension7; // packageimport
import dwtx.jface.text.IInformationControlExtension5; // packageimport
import dwtx.jface.text.IDocumentRewriteSessionListener; // packageimport
import dwtx.jface.text.JFaceTextUtil; // packageimport
import dwtx.jface.text.AbstractReusableInformationControlCreator; // packageimport
import dwtx.jface.text.TabsToSpacesConverter; // packageimport
import dwtx.jface.text.CursorLinePainter; // packageimport
import dwtx.jface.text.ITextHoverExtension; // packageimport
import dwtx.jface.text.IEventConsumer; // packageimport
import dwtx.jface.text.IDocument; // packageimport
import dwtx.jface.text.IWidgetTokenKeeper; // packageimport
import dwtx.jface.text.DocumentCommand; // packageimport
import dwtx.jface.text.TypedPosition; // packageimport
import dwtx.jface.text.IEditingSupportRegistry; // packageimport
import dwtx.jface.text.IDocumentPartitionerExtension; // packageimport
import dwtx.jface.text.AbstractHoverInformationControlManager; // packageimport
import dwtx.jface.text.IEditingSupport; // packageimport
import dwtx.jface.text.IMarkSelection; // packageimport
import dwtx.jface.text.ISlaveDocumentManager; // packageimport
import dwtx.jface.text.DocumentEvent; // packageimport
import dwtx.jface.text.DocumentPartitioningChangedEvent; // packageimport
import dwtx.jface.text.ITextStore; // packageimport
import dwtx.jface.text.JFaceTextMessages; // packageimport
import dwtx.jface.text.DocumentRewriteSessionEvent; // packageimport
import dwtx.jface.text.SequentialRewriteTextStore; // packageimport
import dwtx.jface.text.DocumentRewriteSessionType; // packageimport
import dwtx.jface.text.TextAttribute; // packageimport
import dwtx.jface.text.ITextViewerExtension4; // packageimport
import dwtx.jface.text.ITypedRegion; // packageimport


import dwt.dwthelper.utils;


/**
 * <code>Assert</code> is useful for for embedding runtime sanity checks
 * in code. The static predicate methods all test a condition and throw some
 * type of unchecked exception if the condition does not hold.
 * <p>
 * Assertion failure exceptions, like most runtime exceptions, are
 * thrown when something is misbehaving. Assertion failures are invariably
 * unspecified behavior; consequently, clients should never rely on
 * these being thrown (or not thrown). <b>If you find yourself in the
 * position where you need to catch an assertion failure, you have most
 * certainly written your program incorrectly.</b>
 * </p>
 * <p>
 * Note that an <code>assert</code> statement is slated to be added to the
 * Java language in JDK 1.4, rending this class obsolete.
 * </p>
 *
 * @deprecated As of 3.3, replaced by {@link dwtx.core.runtime.Assert}
 * @noinstantiate This class is not intended to be instantiated by clients.
 */
public final class Assert {

        /**
         * <code>AssertionFailedException</code> is a runtime exception thrown
         * by some of the methods in <code>Assert</code>.
         * <p>
         * This class is not declared public to prevent some misuses; programs that catch
         * or otherwise depend on assertion failures are susceptible to unexpected
         * breakage when assertions in the code are added or removed.
         * </p>
         * <p>
         * This class is not intended to be serialized.
         * </p>
         */
        private static class AssertionFailedException : RuntimeException {

            /**
             * Serial version UID for this class.
             * <p>
             * Note: This class is not intended to be serialized.
             * </p>
             * @since 3.1
             */
            private static const long serialVersionUID= 3689918374733886002L;

            /**
             * Constructs a new exception.
             */
            public this() {
            }

            /**
             * Constructs a new exception with the given message.
             *
             * @param detail the detailed message
             */
            public this(String detail) {
                super(detail);
            }
        }

    /* This class is not intended to be instantiated. */
    private this() {
    }

    /**
     * Asserts that an argument is legal. If the given bool is
     * not <code>true</code>, an <code>IllegalArgumentException</code>
     * is thrown.
     *
     * @param expression the outcome of the check
     * @return <code>true</code> if the check passes (does not return
     *    if the check fails)
     * @exception IllegalArgumentException if the legality test failed
     */
    public static bool isLegal(bool expression) {
        // succeed as quickly as possible
        if (expression) {
            return true;
        }
        return isLegal(expression, "");//$NON-NLS-1$
    }

    /**
     * Asserts that an argument is legal. If the given bool is
     * not <code>true</code>, an <code>IllegalArgumentException</code>
     * is thrown.
     * The given message is included in that exception, to aid debugging.
     *
     * @param expression the outcome of the check
     * @param message the message to include in the exception
     * @return <code>true</code> if the check passes (does not return
     *    if the check fails)
     * @exception IllegalArgumentException if the legality test failed
     */
    public static bool isLegal(bool expression, String message) {
        if (!expression)
            throw new IllegalArgumentException("assertion failed; " ~ message); //$NON-NLS-1$
        return expression;
    }

    /**
     * Asserts that the given object is not <code>null</code>. If this
     * is not the case, some kind of unchecked exception is thrown.
     * <p>
     * As a general rule, parameters passed to API methods must not be
     * <code>null</code> unless <b>explicitly</b> allowed in the method's
     * specification. Similarly, results returned from API methods are never
     * <code>null</code> unless <b>explicitly</b> allowed in the method's
     * specification. Implementations are encouraged to make regular use of
     * <code>Assert.isNotNull</code> to ensure that <code>null</code>
     * parameters are detected as early as possible.
     * </p>
     *
     * @param object the value to test
     * @exception RuntimeException an unspecified unchecked exception if the object
     *   is <code>null</code>
     */
    public static void isNotNull(Object object) {
        // succeed as quickly as possible
        if (object !is null) {
            return;
        }
        isNotNull(object, "");//$NON-NLS-1$
    }

    /**
     * Asserts that the given object is not <code>null</code>. If this
     * is not the case, some kind of unchecked exception is thrown.
     * The given message is included in that exception, to aid debugging.
     * <p>
     * As a general rule, parameters passed to API methods must not be
     * <code>null</code> unless <b>explicitly</b> allowed in the method's
     * specification. Similarly, results returned from API methods are never
     * <code>null</code> unless <b>explicitly</b> allowed in the method's
     * specification. Implementations are encouraged to make regular use of
     * <code>Assert.isNotNull</code> to ensure that <code>null</code>
     * parameters are detected as early as possible.
     * </p>
     *
     * @param object the value to test
     * @param message the message to include in the exception
     * @exception RuntimeException an unspecified unchecked exception if the object
     *   is <code>null</code>
     */
    public static void isNotNull(Object object, String message) {
        if (object is null)
            throw new AssertionFailedException("null argument;" ~ message);//$NON-NLS-1$
    }

    /**
     * Asserts that the given bool is <code>true</code>. If this
     * is not the case, some kind of unchecked exception is thrown.
     *
     * @param expression the outcome of the check
     * @return <code>true</code> if the check passes (does not return
     *    if the check fails)
     */
    public static bool isTrue(bool expression) {
        // succeed as quickly as possible
        if (expression) {
            return true;
        }
        return isTrue(expression, "");//$NON-NLS-1$
    }

    /**
     * Asserts that the given bool is <code>true</code>. If this
     * is not the case, some kind of unchecked exception is thrown.
     * The given message is included in that exception, to aid debugging.
     *
     * @param expression the outcome of the check
     * @param message the message to include in the exception
     * @return <code>true</code> if the check passes (does not return
     *    if the check fails)
     */
    public static bool isTrue(bool expression, String message) {
        if (!expression)
            throw new AssertionFailedException("Assertion failed: "~message);//$NON-NLS-1$
        return expression;
    }
}
