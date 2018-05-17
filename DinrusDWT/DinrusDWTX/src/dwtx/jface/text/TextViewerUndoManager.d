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


module dwtx.jface.text.TextViewerUndoManager;

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
import dwt.custom.StyledText;
import dwt.events.KeyEvent;
import dwt.events.KeyListener;
import dwt.events.MouseEvent;
import dwt.events.MouseListener;
import dwt.widgets.Display;
import dwt.widgets.Shell;
import dwtx.core.commands.ExecutionException;
import dwtx.core.commands.operations.IUndoContext;
import dwtx.jface.dialogs.MessageDialog;
import dwtx.text.undo.DocumentUndoEvent;
import dwtx.text.undo.DocumentUndoManager;
import dwtx.text.undo.DocumentUndoManagerRegistry;
import dwtx.text.undo.IDocumentUndoListener;
import dwtx.text.undo.IDocumentUndoManager;


/**
 * Implementation of {@link dwtx.jface.text.IUndoManager} using the shared
 * document undo manager.
 * <p>
 * It registers with the connected text viewer as text input listener, and obtains
 * its undo manager from the current document.  It also monitors mouse and keyboard
 * activities in order to partition the stream of text changes into undo-able
 * edit commands.
 * <p>
 * This class is not intended to be subclassed.
 * </p>
 *
 * @see ITextViewer
 * @see ITextInputListener
 * @see IDocumentUndoManager
 * @see MouseListener
 * @see KeyListener
 * @see DocumentUndoManager
 *
 * @since 3.2
 * @noextend This class is not intended to be subclassed by clients.
 */
public class TextViewerUndoManager : IUndoManager, IUndoManagerExtension {


    /**
     * Internal listener to mouse and key events.
     */
    private class KeyAndMouseListener : MouseListener, KeyListener {

        /*
         * @see MouseListener#mouseDoubleClick
         */
        public void mouseDoubleClick(MouseEvent e) {
        }

        /*
         * If the right mouse button is pressed, the current editing command is closed
         * @see MouseListener#mouseDown
         */
        public void mouseDown(MouseEvent e) {
            if (e.button is 1)
                if (isConnected())
                    fDocumentUndoManager.commit();
        }

        /*
         * @see MouseListener#mouseUp
         */
        public void mouseUp(MouseEvent e) {
        }

        /*
         * @see KeyListener#keyPressed
         */
        public void keyReleased(KeyEvent e) {
        }

        /*
         * On cursor keys, the current editing command is closed
         * @see KeyListener#keyPressed
         */
        public void keyPressed(KeyEvent e) {
            switch (e.keyCode) {
                case DWT.ARROW_UP:
                case DWT.ARROW_DOWN:
                case DWT.ARROW_LEFT:
                case DWT.ARROW_RIGHT:
                    if (isConnected()) {
                        fDocumentUndoManager.commit();
                    }
                    break;
                default:
            }
        }
    }


    /**
     * Internal text input listener.
     */
    private class TextInputListener : ITextInputListener {

        /*
         * @see dwtx.jface.text.ITextInputListener#inputDocumentAboutToBeChanged(dwtx.jface.text.IDocument, dwtx.jface.text.IDocument)
         */
        public void inputDocumentAboutToBeChanged(IDocument oldInput, IDocument newInput) {
            disconnectDocumentUndoManager();
        }

        /*
         * @see dwtx.jface.text.ITextInputListener#inputDocumentChanged(dwtx.jface.text.IDocument, dwtx.jface.text.IDocument)
         */
        public void inputDocumentChanged(IDocument oldInput, IDocument newInput) {
            connectDocumentUndoManager(newInput);
        }
    }


    /**
     * Internal document undo listener.
     */
    private class DocumentUndoListener : IDocumentUndoListener {

        /*
         * @see dwtx.jface.text.IDocumentUndoListener#documentUndoNotification(DocumentUndoEvent)
         */
        public void documentUndoNotification(DocumentUndoEvent event ){
            if (!isConnected()) return;

            int eventType= event.getEventType();
            if (((eventType & DocumentUndoEvent.ABOUT_TO_UNDO) !is 0) || ((eventType & DocumentUndoEvent.ABOUT_TO_REDO) !is 0))  {
                if (event.isCompound()) {
                    ITextViewerExtension extension= null;
                    if ( cast(ITextViewerExtension)fTextViewer )
                        extension= cast(ITextViewerExtension) fTextViewer;

                    if (extension !is null)
                        extension.setRedraw(false);
                }
                fTextViewer.getTextWidget().getDisplay().syncExec(new class()  Runnable {
                    public void run() {
                        if ( cast(TextViewer)fTextViewer )
                            (cast(TextViewer)fTextViewer).ignoreAutoEditStrategies_package(true);
                    }
                });

            } else if (((eventType & DocumentUndoEvent.UNDONE) !is 0) || ((eventType & DocumentUndoEvent.REDONE) !is 0))  {
                fTextViewer.getTextWidget().getDisplay().syncExec(new class()  Runnable {
                    public void run() {
                        if ( cast(TextViewer)fTextViewer )
                            (cast(TextViewer)fTextViewer).ignoreAutoEditStrategies_package(false);
                    }
                });
                if (event.isCompound()) {
                    ITextViewerExtension extension= null;
                    if ( cast(ITextViewerExtension)fTextViewer )
                        extension= cast(ITextViewerExtension) fTextViewer;

                    if (extension !is null)
                        extension.setRedraw(true);
                }

                // Reveal the change if this manager's viewer has the focus.
                if (fTextViewer !is null) {
                    StyledText widget= fTextViewer.getTextWidget();
                    if (widget !is null && !widget.isDisposed() && (widget.isFocusControl()))// || fTextViewer.getTextWidget() is control))
                        selectAndReveal(event.getOffset(), event.getText() is null ? 0 : event.getText().length());
                }
            }
        }

    }

    /** The internal key and mouse event listener */
    private KeyAndMouseListener fKeyAndMouseListener;
    /** The internal text input listener */
    private TextInputListener fTextInputListener;


    /** The text viewer the undo manager is connected to */
    private ITextViewer fTextViewer;

    /** The undo level */
    private int fUndoLevel;

    /** The document undo manager that is active. */
    private IDocumentUndoManager fDocumentUndoManager;

    /** The document that is active. */
    private IDocument fDocument;

    /** The document undo listener */
    private IDocumentUndoListener fDocumentUndoListener;

    /**
     * Creates a new undo manager who remembers the specified number of edit commands.
     *
     * @param undoLevel the length of this manager's history
     */
    public this(int undoLevel) {
        fUndoLevel= undoLevel;
    }

    /**
     * Returns whether this undo manager is connected to a text viewer.
     *
     * @return <code>true</code> if connected, <code>false</code> otherwise
     */
    private bool isConnected() {
        return fTextViewer !is null && fDocumentUndoManager !is null;
    }

    /*
     * @see IUndoManager#beginCompoundChange
     */
    public void beginCompoundChange() {
        if (isConnected()) {
            fDocumentUndoManager.beginCompoundChange();
        }
    }


    /*
     * @see IUndoManager#endCompoundChange
     */
    public void endCompoundChange() {
        if (isConnected()) {
            fDocumentUndoManager.endCompoundChange();
        }
    }

    /**
     * Registers all necessary listeners with the text viewer.
     */
    private void addListeners() {
        StyledText text= fTextViewer.getTextWidget();
        if (text !is null) {
            fKeyAndMouseListener= new KeyAndMouseListener();
            text.addMouseListener(fKeyAndMouseListener);
            text.addKeyListener(fKeyAndMouseListener);
            fTextInputListener= new TextInputListener();
            fTextViewer.addTextInputListener(fTextInputListener);
        }
    }

    /**
     * Unregister all previously installed listeners from the text viewer.
     */
    private void removeListeners() {
        StyledText text= fTextViewer.getTextWidget();
        if (text !is null) {
            if (fKeyAndMouseListener !is null) {
                text.removeMouseListener(fKeyAndMouseListener);
                text.removeKeyListener(fKeyAndMouseListener);
                fKeyAndMouseListener= null;
            }
            if (fTextInputListener !is null) {
                fTextViewer.removeTextInputListener(fTextInputListener);
                fTextInputListener= null;
            }
        }
    }

    /**
     * Shows the given exception in an error dialog.
     *
     * @param title the dialog title
     * @param ex the exception
     */
    private void openErrorDialog(String title, Exception ex) {
        Shell shell= null;
        if (isConnected()) {
            StyledText st= fTextViewer.getTextWidget();
            if (st !is null && !st.isDisposed())
                shell= st.getShell();
        }
        if (Display.getCurrent() !is null)
            MessageDialog.openError(shell, title, ex.msg/+getLocalizedMessage()+/);
        else {
            Display display;
            Shell finalShell= shell;
            if (finalShell !is null)
                display= finalShell.getDisplay();
            else
                display= Display.getDefault();
            display.syncExec(dgRunnable((Shell finalShell_, String title_, Exception ex_ ) {
                MessageDialog.openError(finalShell_, title_, ex_.msg/+getLocalizedMessage()+/);
            },finalShell, title, ex ));
        }
    }

    /*
     * @see dwtx.jface.text.IUndoManager#setMaximalUndoLevel(int)
     */
    public void setMaximalUndoLevel(int undoLevel) {
        fUndoLevel= Math.max(0, undoLevel);
        if (isConnected()) {
            fDocumentUndoManager.setMaximalUndoLevel(fUndoLevel);
        }
    }

    /*
     * @see dwtx.jface.text.IUndoManager#connect(dwtx.jface.text.ITextViewer)
     */
    public void connect(ITextViewer textViewer) {
        if (fTextViewer is null && textViewer !is null) {
            fTextViewer= textViewer;
            addListeners();
        }
        IDocument doc= fTextViewer.getDocument();
        connectDocumentUndoManager(doc);
    }

    /*
     * @see dwtx.jface.text.IUndoManager#disconnect()
     */
    public void disconnect() {
        if (fTextViewer !is null) {
            removeListeners();
            fTextViewer= null;
        }
        disconnectDocumentUndoManager();
    }

    /*
     * @see dwtx.jface.text.IUndoManager#reset()
     */
    public void reset() {
        if (isConnected())
            fDocumentUndoManager.reset();

    }

    /*
     * @see dwtx.jface.text.IUndoManager#redoable()
     */
    public bool redoable() {
        if (isConnected())
            return fDocumentUndoManager.redoable();
        return false;
    }

    /*
     * @see dwtx.jface.text.IUndoManager#undoable()
     */
    public bool undoable() {
        if (isConnected())
            return fDocumentUndoManager.undoable();
        return false;
    }

    /*
     * @see dwtx.jface.text.IUndoManager#redo()
     */
    public void redo() {
        if (isConnected()) {
            try {
                fDocumentUndoManager.redo();
            } catch (ExecutionException ex) {
                openErrorDialog(JFaceTextMessages.getString("DefaultUndoManager.error.redoFailed.title"), ex); //$NON-NLS-1$
            }
        }
    }

    /*
     * @see dwtx.jface.text.IUndoManager#undo()
     */
    public void undo() {
        if (isConnected()) {
            try {
                fDocumentUndoManager.undo();
            } catch (ExecutionException ex) {
                openErrorDialog(JFaceTextMessages.getString("DefaultUndoManager.error.undoFailed.title"), ex); //$NON-NLS-1$
            }
        }
    }

    /**
     * Selects and reveals the specified range.
     *
     * @param offset the offset of the range
     * @param length the length of the range
     */
    private void selectAndReveal(int offset, int length) {
        if ( cast(ITextViewerExtension5)fTextViewer ) {
            ITextViewerExtension5 extension= cast(ITextViewerExtension5) fTextViewer;
            extension.exposeModelRange(new Region(offset, length));
        } else if (!fTextViewer.overlapsWithVisibleRegion(offset, length))
            fTextViewer.resetVisibleRegion();

        fTextViewer.setSelectedRange(offset, length);
        fTextViewer.revealRange(offset, length);
    }

    /*
     * @see dwtx.jface.text.IUndoManagerExtension#getUndoContext()
     */
    public IUndoContext getUndoContext() {
        if (isConnected()) {
            return fDocumentUndoManager.getUndoContext();
        }
        return null;
    }

    private void connectDocumentUndoManager(IDocument document) {
        disconnectDocumentUndoManager();
        if (document !is null) {
            fDocument= document;
            DocumentUndoManagerRegistry.connect(fDocument);
            fDocumentUndoManager= DocumentUndoManagerRegistry.getDocumentUndoManager(fDocument);
            fDocumentUndoManager.connect(this);
            setMaximalUndoLevel(fUndoLevel);
            fDocumentUndoListener= new DocumentUndoListener();
            fDocumentUndoManager.addDocumentUndoListener(fDocumentUndoListener);
        }
    }

    private void disconnectDocumentUndoManager() {
        if (fDocumentUndoManager !is null) {
            fDocumentUndoManager.disconnect(this);
            DocumentUndoManagerRegistry.disconnect(fDocument);
            fDocumentUndoManager.removeDocumentUndoListener(fDocumentUndoListener);
            fDocumentUndoListener= null;
            fDocumentUndoManager= null;
        }
    }
}
