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


module dwtx.jface.text.IInformationControl;

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
import dwtx.jface.text.Assert; // packageimport
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


import dwt.DWT;
import dwt.events.DisposeListener;
import dwt.events.FocusListener;
import dwt.graphics.Color;
import dwt.graphics.Point;


/**
 * Interface of a control presenting information. The information is given in
 * the form of an input object. It can be either the content itself or a
 * description of the content. The specification of what is required from an
 * input object is left to the implementers of this interface.
 * <p>
 * <em>If this information control is used by a {@link AbstractHoverInformationControlManager}
 * then that manager will own this control and override any properties that
 * may have been set before by any other client.</em></p>
 * <p>
 * The information control must not grab focus when made visible using
 * <code>setVisible(true)</code>.
 *
 * In order to provide backward compatibility for clients of
 * <code>IInformationControl</code>, extension interfaces are used as a means
 * of evolution. The following extension interfaces exist:
 * <ul>
 * <li>{@link dwtx.jface.text.IInformationControlExtension} since
 *     version 2.0 introducing the predicate of whether the control has anything to
 *     show or would be empty</li>
 * <li>{@link dwtx.jface.text.IInformationControlExtension2} since
 *     version 2.1 replacing the original concept of textual input by general input
 *     objects.</li>
 * <li>{@link dwtx.jface.text.IInformationControlExtension3} since
 *     version 3.0 providing access to the control's bounds and introducing
 *     the concept of persistent size and location.</li>
 * <li>{@link dwtx.jface.text.IInformationControlExtension4} since
 *     version 3.3, adding API which allows to set this information control's status field text.</li>
 * <li>{@link dwtx.jface.text.IInformationControlExtension5} since
 *     version 3.4, adding API to get the visibility of the control, to
 *     test whether another control is a child of the information control,
 *     to compute size constraints based on the information control's main font
 *     and to return a control creator for an enriched version of this information control.</li>
 * </ul>
 * <p>
 * Clients can implement this interface and its extension interfaces,
 * subclass {@link AbstractInformationControl}, or use the (text-based)
 * default implementation {@link DefaultInformationControl}.
 *
 * @see dwtx.jface.text.IInformationControlExtension
 * @see dwtx.jface.text.IInformationControlExtension2
 * @see dwtx.jface.text.IInformationControlExtension3
 * @see dwtx.jface.text.IInformationControlExtension4
 * @see dwtx.jface.text.IInformationControlExtension5
 * @see AbstractInformationControl
 * @see DefaultInformationControl
 * @since 2.0
 */
public interface IInformationControl {

    /**
     * Sets the information to be presented by this information control.
     * <p>
     * Replaced by {@link IInformationControlExtension2#setInput(Object)}.
     *
     * @param information the information to be presented
     */
    void setInformation(String information);

    /**
     * Sets the information control's size constraints. A constraint value of
     * {@link DWT#DEFAULT} indicates no constraint. This method must be called before
     * {@link #computeSizeHint()} is called.
     * <p>
     * Note: An information control which implements {@link IInformationControlExtension3}
     * may ignore this method or use it as hint for its very first appearance.
     * </p>
     * @param maxWidth the maximal width of the control  to present the information, or {@link DWT#DEFAULT} for not constraint
     * @param maxHeight the maximal height of the control to present the information, or {@link DWT#DEFAULT} for not constraint
     */
    void setSizeConstraints(int maxWidth, int maxHeight);

    /**
     * Computes and returns a proposal for the size of this information control depending
     * on the information to present. The method tries to honor known size constraints but might
     * return a size that exceeds them.
     *
     * @return the computed size hint
     */
    Point computeSizeHint();

    /**
     * Controls the visibility of this information control.
     * <p>
     * <strong>Note:</strong> The information control must not grab focus when
     * made visible.
     * </p>
     * 
     * @param visible <code>true</code> if the control should be visible
     */
    void setVisible(bool visible);

    /**
     * Sets the size of this information control.
     *
     * @param width the width of the control
     * @param height the height of the control
     */
    void setSize(int width, int height);

    /**
     * Sets the location of this information control.
     *
     * @param location the location
     */
    void setLocation(Point location);

    /**
     * Disposes this information control.
     */
    void dispose();

    /**
     * Adds the given listener to the list of dispose listeners.
     * If the listener is already registered it is not registered again.
     *
     * @param listener the listener to be added
     */
    void addDisposeListener(DisposeListener listener);

    /**
     * Removes the given listeners from the list of dispose listeners.
     * If the listener is not registered this call has no effect.
     *
     * @param listener the listener to be removed
     */
    void removeDisposeListener(DisposeListener listener);

    /**
     * Sets the foreground color of this information control.
     *
     * @param foreground the foreground color of this information control
     */
    void setForegroundColor(Color foreground);

    /**
     * Sets the background color of this information control.
     *
     * @param background the background color of this information control
     */
    void setBackgroundColor(Color background);

    /**
     * Returns whether this information control (or one of its children) has the focus.
     * The suggested implementation is like this (<code>fShell</code> is this information control's shell):
     * <pre>return fShell.getDisplay().getActiveShell() is fShell</pre>
     *
     * @return <code>true</code> when the information control has the focus, otherwise <code>false</code>
     */
    bool isFocusControl();

    /**
     * Sets the keyboard focus to this information control.
     */
    void setFocus();

    /**
     * Adds the given listener to the list of focus listeners.
     * If the listener is already registered it is not registered again.
     * <p>
     * The suggested implementation is to install listeners for {@link DWT#Activate} and {@link DWT#Deactivate}
     * on the shell and forward events to the focus listeners. Clients are
     * encouraged to subclass {@link AbstractInformationControl}, which does this
     * for free.
     * </p>
     * 
     * @param listener the listener to be added
     */
    void addFocusListener(FocusListener listener);

    /**
     * Removes the given listeners from the list of focus listeners.
     * If the listener is not registered this call has no affect.
     *
     * @param listener the listener to be removed
     */
    void removeFocusListener(FocusListener listener);
}
