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
module dwtx.jface.text.DefaultInformationControl;

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
import dwt.events.DisposeEvent;
import dwt.events.DisposeListener;
import dwt.graphics.Color;
import dwt.graphics.Drawable;
import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwt.layout.FillLayout;
import dwt.widgets.Composite;
import dwt.widgets.Display;
import dwt.widgets.Shell;
import dwtx.jface.action.ToolBarManager;
import dwtx.jface.internal.text.html.HTMLTextPresenter;
import dwtx.jface.resource.JFaceResources;
import dwtx.jface.util.Geometry;

    /**
     * An information presenter determines the style presentation
     * of information displayed in the default information control.
     * The interface can be implemented by clients.
     */
    public interface IInformationPresenter {

        /**
         * Updates the given presentation of the given information and
         * thereby may manipulate the information to be displayed. The manipulation
         * could be the extraction of textual encoded style information etc. Returns the
         * manipulated information.
         * <p>
         * <strong>Note:</strong> The given display must only be used for measuring.</p>
         *
         * @param display the display of the information control
         * @param hoverInfo the information to be presented
         * @param presentation the presentation to be updated
         * @param maxWidth the maximal width in pixels
         * @param maxHeight the maximal height in pixels
         *
         * @return the manipulated information
         * @deprecated As of 3.2, replaced by {@link DefaultInformationControl.IInformationPresenterExtension#updatePresentation(Drawable, String, TextPresentation, int, int)}
         */
        String updatePresentation(Display display, String hoverInfo, TextPresentation presentation, int maxWidth, int maxHeight);
    }
    alias IInformationPresenter DefaultInformationControl_IInformationPresenter;

    /**
     * An information presenter determines the style presentation
     * of information displayed in the default information control.
     * The interface can be implemented by clients.
     *
     * @since 3.2
     */
    public interface IInformationPresenterExtension {

        /**
         * Updates the given presentation of the given information and
         * thereby may manipulate the information to be displayed. The manipulation
         * could be the extraction of textual encoded style information etc. Returns the
         * manipulated information.
         * <p>
         * Replaces {@link DefaultInformationControl.IInformationPresenter#updatePresentation(Display, String, TextPresentation, int, int)}
         * Implementations should use the font of the given <code>drawable</code> to calculate
         * the size of the text to be presented.
         * </p>
         *
         * @param drawable the drawable of the information control
         * @param hoverInfo the information to be presented
         * @param presentation the presentation to be updated
         * @param maxWidth the maximal width in pixels
         * @param maxHeight the maximal height in pixels
         *
         * @return the manipulated information
         */
        String updatePresentation(Drawable drawable, String hoverInfo, TextPresentation presentation, int maxWidth, int maxHeight);
    }
    alias IInformationPresenterExtension DefaultInformationControl_IInformationPresenterExtension;


/**
 * Default implementation of {@link dwtx.jface.text.IInformationControl}.
 * <p>
 * Displays textual information in a {@link dwt.custom.StyledText}
 * widget. Before displaying, the information set to this information control is
 * processed by an <code>IInformationPresenter</code>.
 *
 * @since 2.0
 */
public class DefaultInformationControl : AbstractInformationControl , DisposeListener {

    /**
     * Inner border thickness in pixels.
     * @since 3.1
     */
    private static const int INNER_BORDER= 1;

    /** The control's text widget */
    private StyledText fText;
    /** The information presenter, or <code>null</code> if none. */
    private const IInformationPresenter fPresenter;
    /** A cached text presentation */
    private const TextPresentation fPresentation;

    /**
     * Additional styles to use for the text control.
     * @since 3.4, previously called <code>fTextStyle</code>
     */
    private const int fAdditionalTextStyles;

    /**
     * Creates a default information control with the given shell as parent. An information
     * presenter that can handle simple HTML is used to process the information to be displayed.
     *
     * @param parent the parent shell
     * @param isResizeable <code>true</code> if the control should be resizable
     * @since 3.4
     */
    public this(Shell parent, bool isResizeable) {
        fPresentation= new TextPresentation();
        super(parent, isResizeable);
        fAdditionalTextStyles= isResizeable ? DWT.V_SCROLL | DWT.H_SCROLL : DWT.NONE;
        fPresenter= new HTMLTextPresenter(!isResizeable);
        create();
    }

    /**
     * Creates a default information control with the given shell as parent. An information
     * presenter that can handle simple HTML is used to process the information to be displayed.
     *
     * @param parent the parent shell
     * @param statusFieldText the text to be used in the status field or <code>null</code> to hide the status field
     * @since 3.4
     */
    public this(Shell parent, String statusFieldText) {
        this(parent, statusFieldText, new HTMLTextPresenter(true));
    }

    /**
     * Creates a default information control with the given shell as parent. The
     * given information presenter is used to process the information to be
     * displayed.
     *
     * @param parent the parent shell
     * @param statusFieldText the text to be used in the status field or <code>null</code> to hide the status field
     * @param presenter the presenter to be used, or <code>null</code> if no presenter should be used
     * @since 3.4
     */
    public this(Shell parent, String statusFieldText, IInformationPresenter presenter) {
        fPresentation= new TextPresentation();
        super(parent, statusFieldText);
        fAdditionalTextStyles= DWT.NONE;
        fPresenter= presenter;
        create();
    }

    /**
     * Creates a resizable default information control with the given shell as parent. An
     * information presenter that can handle simple HTML is used to process the information to be
     * displayed.
     *
     * @param parent the parent shell
     * @param toolBarManager the manager or <code>null</code> if toolbar is not desired
     * @since 3.4
     */
    public this(Shell parent, ToolBarManager toolBarManager) {
        this(parent, toolBarManager, new HTMLTextPresenter(false));
    }

    /**
     * Creates a resizable default information control with the given shell as
     * parent. The given information presenter is used to process the
     * information to be displayed.
     *
     * @param parent the parent shell
     * @param toolBarManager the manager or <code>null</code> if toolbar is not desired
     * @param presenter the presenter to be used, or <code>null</code> if no presenter should be used
     * @since 3.4
     */
    public this(Shell parent, ToolBarManager toolBarManager, IInformationPresenter presenter) {
        fPresentation= new TextPresentation();
        super(parent, toolBarManager);
        fAdditionalTextStyles= DWT.V_SCROLL | DWT.H_SCROLL;
        fPresenter= presenter;
        create();
    }

    /**
     * Creates a default information control with the given shell as parent.
     * No information presenter is used to process the information
     * to be displayed.
     *
     * @param parent the parent shell
     */
    public this(Shell parent) {
        this(parent, cast(String)null, null);
    }

    /**
     * Creates a default information control with the given shell as parent. The given
     * information presenter is used to process the information to be displayed.
     *
     * @param parent the parent shell
     * @param presenter the presenter to be used
     */
    public this(Shell parent, IInformationPresenter presenter) {
        this(parent, cast(String)null, presenter);
    }

    /**
     * Creates a default information control with the given shell as parent. The
     * given information presenter is used to process the information to be
     * displayed. The given styles are applied to the created styled text
     * widget.
     *
     * @param parent the parent shell
     * @param shellStyle the additional styles for the shell
     * @param style the additional styles for the styled text widget
     * @param presenter the presenter to be used
     * @deprecated As of 3.4, replaced by simpler constructors
     */
    public this(Shell parent, int shellStyle, int style, IInformationPresenter presenter) {
        this(parent, shellStyle, style, presenter, null);
    }

    /**
     * Creates a default information control with the given shell as parent. The
     * given information presenter is used to process the information to be
     * displayed. The given styles are applied to the created styled text
     * widget.
     *
     * @param parentShell the parent shell
     * @param shellStyle the additional styles for the shell
     * @param style the additional styles for the styled text widget
     * @param presenter the presenter to be used
     * @param statusFieldText the text to be used in the status field or <code>null</code> to hide the status field
     * @since 3.0
     * @deprecated As of 3.4, replaced by simpler constructors
     */
    public this(Shell parentShell, int shellStyle, int style, IInformationPresenter presenter, String statusFieldText) {
        fPresentation= new TextPresentation();
        super(parentShell, DWT.NO_FOCUS | DWT.ON_TOP | shellStyle, statusFieldText, null);
        fAdditionalTextStyles= style;
        fPresenter= presenter;
        create();
    }

    /**
     * Creates a default information control with the given shell as parent. The
     * given information presenter is used to process the information to be
     * displayed.
     *
     * @param parent the parent shell
     * @param textStyles the additional styles for the styled text widget
     * @param presenter the presenter to be used
     * @deprecated As of 3.4, replaced by {@link #DefaultInformationControl(Shell, DefaultInformationControl.IInformationPresenter)}
     */
    public this(Shell parent, int textStyles, IInformationPresenter presenter) {
        this(parent, textStyles, presenter, null);
    }

    /**
     * Creates a default information control with the given shell as parent. The
     * given information presenter is used to process the information to be
     * displayed.
     *
     * @param parent the parent shell
     * @param textStyles the additional styles for the styled text widget
     * @param presenter the presenter to be used
     * @param statusFieldText the text to be used in the status field or <code>null</code> to hide the status field
     * @since 3.0
     * @deprecated As of 3.4, replaced by {@link #DefaultInformationControl(Shell, String, DefaultInformationControl.IInformationPresenter)}
     */
    public this(Shell parent, int textStyles, IInformationPresenter presenter, String statusFieldText) {
        fPresentation= new TextPresentation();
        super(parent, statusFieldText);
        fAdditionalTextStyles= textStyles;
        fPresenter= presenter;
        create();
    }

    /*
     * @see dwtx.jface.text.AbstractInformationControl#createContent(dwt.widgets.Composite)
     */
    protected void createContent(Composite parent) {
        fText= new StyledText(parent, DWT.MULTI | DWT.READ_ONLY | fAdditionalTextStyles);
        fText.setForeground(parent.getForeground());
        fText.setBackground(parent.getBackground());
        fText.setFont(JFaceResources.getDialogFont());
        FillLayout layout= cast(FillLayout)parent.getLayout();
        if (fText.getWordWrap()) {
            // indent does not work for wrapping StyledText, see https://bugs.eclipse.org/bugs/show_bug.cgi?id=56342 and https://bugs.eclipse.org/bugs/show_bug.cgi?id=115432
            layout.marginHeight= INNER_BORDER;
            layout.marginWidth= INNER_BORDER;
        } else {
            fText.setIndent(INNER_BORDER);
        }
    }

    /*
     * @see IInformationControl#setInformation(String)
     */
    public void setInformation(String content) {
        if (fPresenter is null) {
            fText.setText(content);
        } else {
            fPresentation.clear();

            int maxWidth= -1;
            int maxHeight= -1;
            Point constraints= getSizeConstraints();
            if (constraints !is null) {
                maxWidth= constraints.x;
                maxHeight= constraints.y;
                if (fText.getWordWrap()) {
                    maxWidth-= INNER_BORDER * 2;
                    maxHeight-= INNER_BORDER * 2;
                } else {
                    maxWidth-= INNER_BORDER; // indent
                }
                Rectangle trim= computeTrim();
                maxWidth-= trim.width;
                maxHeight-= trim.height;
                maxWidth-= fText.getCaret().getSize().x; // StyledText adds a border at the end of the line for the caret.
            }
            if (isResizable())
                maxHeight= Integer.MAX_VALUE;

            if ( cast(IInformationPresenterExtension)fPresenter )
                content= (cast(IInformationPresenterExtension)fPresenter).updatePresentation(fText, content, fPresentation, maxWidth, maxHeight);
            else
                content= fPresenter.updatePresentation(getShell().getDisplay(), content, fPresentation, maxWidth, maxHeight);

            if (content !is null) {
                fText.setText(content);
                TextPresentation.applyTextPresentation(fPresentation, fText);
            } else {
                fText.setText(""); //$NON-NLS-1$
            }
        }
    }

    /*
     * @see IInformationControl#setVisible(bool)
     */
    public void setVisible(bool visible) {
        if (visible) {
            if (fText.getWordWrap()) {
                Point currentSize= getShell().getSize();
                getShell().pack(true);
                Point newSize= getShell().getSize();
                if (newSize.x > currentSize.x || newSize.y > currentSize.y)
                    setSize(currentSize.x, currentSize.y); // restore previous size
            }
        }

        super.setVisible(visible);
    }

    /*
     * @see IInformationControl#computeSizeHint()
     */
    public Point computeSizeHint() {
        // see: https://bugs.eclipse.org/bugs/show_bug.cgi?id=117602
        int widthHint= DWT.DEFAULT;
        Point constraints= getSizeConstraints();
        if (constraints !is null && fText.getWordWrap())
            widthHint= constraints.x;

        return getShell().computeSize(widthHint, DWT.DEFAULT, true);
    }

    /*
     * @see dwtx.jface.text.AbstractInformationControl#computeTrim()
     */
    public Rectangle computeTrim() {
        return Geometry.add(super.computeTrim(), fText.computeTrim(0, 0, 0, 0));
    }

    /*
     * @see IInformationControl#setForegroundColor(Color)
     */
    public void setForegroundColor(Color foreground) {
        super.setForegroundColor(foreground);
        fText.setForeground(foreground);
    }

    /*
     * @see IInformationControl#setBackgroundColor(Color)
     */
    public void setBackgroundColor(Color background) {
        super.setBackgroundColor(background);
        fText.setBackground(background);
    }

    /*
     * @see IInformationControlExtension#hasContents()
     */
    public bool hasContents() {
        return fText.getCharCount() > 0;
    }

    /**
     * @see dwt.events.DisposeListener#widgetDisposed(dwt.events.DisposeEvent)
     * @since 3.0
     * @deprecated As of 3.2, no longer used and called
     */
    public void widgetDisposed(DisposeEvent event) {
    }

    /*
     * @see dwtx.jface.text.IInformationControlExtension5#getInformationPresenterControlCreator()
     * @since 3.4
     */
    public IInformationControlCreator getInformationPresenterControlCreator() {
        return new class()  IInformationControlCreator {
            /*
             * @see dwtx.jface.text.IInformationControlCreator#createInformationControl(dwt.widgets.Shell)
             */
            public IInformationControl createInformationControl(Shell parent) {
                return new DefaultInformationControl(parent, cast(ToolBarManager) null, fPresenter);
            }
        };
    }

}
