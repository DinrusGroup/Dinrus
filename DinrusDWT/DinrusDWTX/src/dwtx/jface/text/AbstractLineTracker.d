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
module dwtx.jface.text.AbstractLineTracker;

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
import tango.text.convert.Format;

import dwtx.dwtxhelper.Collection;


    /**
     * Combines the information of the occurrence of a line delimiter. <code>delimiterIndex</code>
     * is the index where a line delimiter starts, whereas <code>delimiterLength</code>,
     * indicates the length of the delimiter.
     */
    protected class DelimiterInfo {
        public int delimiterIndex;
        public int delimiterLength;
        public String delimiter;
    }
    alias DelimiterInfo AbstractLineTracker_DelimiterInfo;

/**
 * Abstract implementation of <code>ILineTracker</code>. It lets the definition of line
 * delimiters to subclasses. Assuming that '\n' is the only line delimiter, this abstract
 * implementation defines the following line scheme:
 * <ul>
 * <li> "" -> [0,0]
 * <li> "a" -> [0,1]
 * <li> "\n" -> [0,1], [1,0]
 * <li> "a\n" -> [0,2], [2,0]
 * <li> "a\nb" -> [0,2], [2,1]
 * <li> "a\nbc\n" -> [0,2], [2,3], [5,0]
 * </ul>
 * <p>
 * This class must be subclassed.
 * </p>
 */
public abstract class AbstractLineTracker : ILineTracker, ILineTrackerExtension {

    /**
     * Tells whether this class is in debug mode.
     *
     * @since 3.1
     */
    private static const bool DEBUG= false;

    /**
     * Representation of replace and set requests.
     *
     * @since 3.1
     */
    protected static class Request {
        public const int offset;
        public const int length;
        public const String text;

        public this(int offset, int length, String text) {
            this.offset= offset;
            this.length= length;
            this.text= text;
        }

        public this(String text) {
            this.offset= -1;
            this.length= -1;
            this.text= text;
        }

        public bool isReplaceRequest() {
            return this.offset > -1 && this.length > -1;
        }
    }

    /**
     * The active rewrite session.
     *
     * @since 3.1
     */
    private DocumentRewriteSession fActiveRewriteSession;
    /**
     * The list of pending requests.
     *
     * @since 3.1
     */
    private List fPendingRequests;
    /**
     * The implementation that this tracker delegates to.
     *
     * @since 3.2
     */
    private ILineTracker fDelegate;
    private void fDelegate_init() {
        fDelegate = new class() ListLineTracker {
            public String[] getLegalLineDelimiters() {
                return this.outer.getLegalLineDelimiters();
            }

            protected DelimiterInfo nextDelimiterInfo(String text, int offset) {
                return this.outer.nextDelimiterInfo(text, offset);
            }
        };
    }
    /**
     * Whether the delegate needs conversion when the line structure is modified.
     */
    private bool fNeedsConversion= true;

    /**
     * Creates a new line tracker.
     */
    protected this() {
        fDelegate_init();
    }

    /*
     * @see dwtx.jface.text.ILineTracker#computeNumberOfLines(java.lang.String)
     */
    public int computeNumberOfLines(String text) {
        return fDelegate.computeNumberOfLines(text);
    }

    /*
     * @see dwtx.jface.text.ILineTracker#getLineDelimiter(int)
     */
    public String getLineDelimiter(int line)  {
        checkRewriteSession();
        return fDelegate.getLineDelimiter(line);
    }

    /*
     * @see dwtx.jface.text.ILineTracker#getLineInformation(int)
     */
    public IRegion getLineInformation(int line)  {
        checkRewriteSession();
        return fDelegate.getLineInformation(line);
    }

    /*
     * @see dwtx.jface.text.ILineTracker#getLineInformationOfOffset(int)
     */
    public IRegion getLineInformationOfOffset(int offset)  {
        checkRewriteSession();
        return fDelegate.getLineInformationOfOffset(offset);
    }

    /*
     * @see dwtx.jface.text.ILineTracker#getLineLength(int)
     */
    public int getLineLength(int line)  {
        checkRewriteSession();
        return fDelegate.getLineLength(line);
    }

    /*
     * @see dwtx.jface.text.ILineTracker#getLineNumberOfOffset(int)
     */
    public int getLineNumberOfOffset(int offset)  {
        checkRewriteSession();
        return fDelegate.getLineNumberOfOffset(offset);
    }

    /*
     * @see dwtx.jface.text.ILineTracker#getLineOffset(int)
     */
    public int getLineOffset(int line)  {
        checkRewriteSession();
        return fDelegate.getLineOffset(line);
    }

    /*
     * @see dwtx.jface.text.ILineTracker#getNumberOfLines()
     */
    public int getNumberOfLines() {
        try {
            checkRewriteSession();
        } catch (BadLocationException x) {
            // TODO there is currently no way to communicate that exception back to the document
        }
        return fDelegate.getNumberOfLines();
    }

    /*
     * @see dwtx.jface.text.ILineTracker#getNumberOfLines(int, int)
     */
    public int getNumberOfLines(int offset, int length)  {
        checkRewriteSession();
        return fDelegate.getNumberOfLines(offset, length);
    }

    /*
     * @see dwtx.jface.text.ILineTracker#set(java.lang.String)
     */
    public void set(String text) {
        if (hasActiveRewriteSession()) {
            fPendingRequests.clear();
            fPendingRequests.add(new Request(text));
            return;
        }

        fDelegate.set(text);
    }

    /*
     * @see dwtx.jface.text.ILineTracker#replace(int, int, java.lang.String)
     */
    public void replace(int offset, int length, String text)  {
        if (hasActiveRewriteSession()) {
            fPendingRequests.add(new Request(offset, length, text));
            return;
        }

        checkImplementation();

        fDelegate.replace(offset, length, text);
    }

    /**
     * Converts the implementation to be a {@link TreeLineTracker} if it isn't yet.
     *
     * @since 3.2
     */
    private void checkImplementation() {
        if (fNeedsConversion) {
            fNeedsConversion= false;
            fDelegate= new class(cast(ListLineTracker) fDelegate)  TreeLineTracker {
                this(ListLineTracker arg){
                    super(arg);
                }
                protected DelimiterInfo nextDelimiterInfo(String text, int offset) {
                    return this.outer.nextDelimiterInfo(text, offset);
                }

                public String[] getLegalLineDelimiters() {
                    return this.outer.getLegalLineDelimiters();
                }
            };
        }
    }

    /**
     * Returns the information about the first delimiter found in the given text starting at the
     * given offset.
     *
     * @param text the text to be searched
     * @param offset the offset in the given text
     * @return the information of the first found delimiter or <code>null</code>
     */
    protected abstract DelimiterInfo nextDelimiterInfo(String text, int offset);

    /*
     * @see dwtx.jface.text.ILineTrackerExtension#startRewriteSession(dwtx.jface.text.DocumentRewriteSession)
     * @since 3.1
     */
    public final void startRewriteSession(DocumentRewriteSession session) {
        if (fActiveRewriteSession !is null)
            throw new IllegalStateException();
        fActiveRewriteSession= session;
        fPendingRequests= new ArrayList(20);
    }

    /*
     * @see dwtx.jface.text.ILineTrackerExtension#stopRewriteSession(dwtx.jface.text.DocumentRewriteSession, java.lang.String)
     * @since 3.1
     */
    public final void stopRewriteSession(DocumentRewriteSession session, String text) {
        if (fActiveRewriteSession is session) {
            fActiveRewriteSession= null;
            fPendingRequests= null;
            set(text);
        }
    }

    /**
     * Tells whether there's an active rewrite session.
     *
     * @return <code>true</code> if there is an active rewrite session, <code>false</code>
     *         otherwise
     * @since 3.1
     */
    protected final bool hasActiveRewriteSession() {
        return fActiveRewriteSession !is null;
    }

    /**
     * Flushes the active rewrite session.
     *
     * @throws BadLocationException in case the recorded requests cannot be processed correctly
     * @since 3.1
     */
    protected final void flushRewriteSession()  {
        if (DEBUG)
            System.out_.println(Format("AbstractLineTracker: Flushing rewrite session: {}", fActiveRewriteSession)); //$NON-NLS-1$

        Iterator e= fPendingRequests.iterator();

        fPendingRequests= null;
        fActiveRewriteSession= null;

        while (e.hasNext()) {
            Request request= cast(Request) e.next();
            if (request.isReplaceRequest())
                replace(request.offset, request.length, request.text);
            else
                set(request.text);
        }
    }

    /**
     * Checks the presence of a rewrite session and flushes it.
     *
     * @throws BadLocationException in case flushing does not succeed
     * @since 3.1
     */
    protected final void checkRewriteSession()  {
        if (hasActiveRewriteSession())
            flushRewriteSession();
    }
}
