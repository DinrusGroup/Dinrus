/*******************************************************************************
 * Copyright (c) 2008 IBM Corporation and others.
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
module dwtx.jface.text.AbstractInformationControl;

import dwtx.jface.text.IDocumentPartitioningListener; // packageimport
import dwtx.jface.text.DefaultTextHover; // packageimport
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
// import dwtx.jface.text.Assert; // packageimport
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
import dwt.events.DisposeListener;
import dwt.events.FocusEvent;
import dwt.events.FocusListener;
import dwt.events.MouseAdapter;
import dwt.events.MouseEvent;
import dwt.events.MouseMoveListener;
import dwt.events.PaintEvent;
import dwt.events.PaintListener;
import dwt.graphics.Color;
import dwt.graphics.Cursor;
import dwt.graphics.Font;
import dwt.graphics.FontData;
import dwt.graphics.GC;
import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwt.layout.FillLayout;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.widgets.Canvas;
import dwt.widgets.Composite;
import dwt.widgets.Control;
import dwt.widgets.Display;
import dwt.widgets.Event;
import dwt.widgets.Label;
import dwt.widgets.Listener;
import dwt.widgets.Shell;
import dwt.widgets.Slider;
import dwt.widgets.ToolBar;
import dwtx.core.runtime.Assert;
import dwtx.core.runtime.ListenerList;
import dwtx.jface.action.ToolBarManager;
import dwtx.jface.resource.JFaceResources;
import dwtx.jface.util.Geometry;


/**
 * An abstract information control that can show content inside a shell.
 * The information control can be created in two styles:
 * <ul>
 *  <li>non-resizable tooltip with optional status</li>
 *  <li>resizable tooltip with optional tool bar</li>
 * </ul>
 * Additionally it can present either a status line containing a status text or
 * a toolbar containing toolbar buttons.
 * <p>
 * Subclasses must either override {@link IInformationControl#setInformation(String)}
 * or implement {@link IInformationControlExtension2}.
 * They should also extend {@link #computeTrim()} if they create a content area
 * with additional trim (e.g. scrollbars) and override {@link #getInformationPresenterControlCreator()}.
 * </p>
 *
 * @since 3.4
 */
public abstract class AbstractInformationControl : IInformationControl, IInformationControlExtension, IInformationControlExtension3, IInformationControlExtension4, IInformationControlExtension5 {

    /** The information control's shell. */
    private const Shell fShell;
    /** Composite containing the content created by subclasses. */
    private const Composite fContentComposite;
    /** Whether the information control is resizable. */
    private const bool fResizable;

    /** Composite containing the status line content or <code>null</code> if none. */
    private Composite fStatusComposite;
    /** Separator between content and status line or <code>null</code> if none. */
    private Label fSeparator;
    /** Label in the status line or <code>null</code> if none. */
    private Label fStatusLabel;
    /** The toolbar manager used by the toolbar or <code>null</code> if none. */
    private const ToolBarManager fToolBarManager;
    /** Status line toolbar or <code>null</code> if none. */
    private ToolBar fToolBar;

    /** Listener for shell activation and deactivation. */
    private Listener fShellListener;
    /** All focus listeners registered to this information control. */
    private ListenerList fFocusListeners;

    /** Size constraints, x is the maxWidth and y is the maxHeight, or <code>null</code> if not set. */
    private Point fSizeConstraints;
    /** The size of the resize handle if already set, -1 otherwise */
    private int fResizeHandleSize;

    /**
     * Creates an abstract information control with the given shell as parent.
     * The control will not be resizable and optionally show a status line with
     * the given status field text.
     * <p>
     * <em>Important: Subclasses are required to call {@link #create()} at the end of their constructor.</em>
     * </p>
     *
     * @param parentShell the parent of this control's shell
     * @param statusFieldText the text to be used in the status field or <code>null</code> to hide the status field
     */
    public this(Shell parentShell, String statusFieldText) {
        this(parentShell, DWT.TOOL | DWT.ON_TOP, statusFieldText, null);
    }

    /**
     * Creates an abstract information control with the given shell as parent.
     * The control will be resizable and optionally show a tool bar managed by
     * the given tool bar manager.
     * <p>
     * <em>Important: Subclasses are required to call {@link #create()} at the end of their constructor.</em>
     * </p>
     *
     * @param parentShell the parent of this control's shell
     * @param toolBarManager the manager or <code>null</code> if toolbar is not desired
     */
    public this(Shell parentShell, ToolBarManager toolBarManager) {
        this(parentShell, DWT.TOOL | DWT.ON_TOP | DWT.RESIZE, null, toolBarManager);
    }

    /**
     * Creates an abstract information control with the given shell as parent.
     * <p>
     * <em>Important: Subclasses are required to call {@link #create()} at the end of their constructor.</em>
     * </p>
     *
     * @param parentShell the parent of this control's shell
     * @param isResizable <code>true</code> if the control should be resizable
     */
    public this(Shell parentShell, bool isResizable) {
        this(parentShell, DWT.TOOL | DWT.ON_TOP | (isResizable ? DWT.RESIZE : 0), null, null);
    }

    /**
     * Creates an abstract information control with the given shell as parent.
     * The given shell style is used for the shell (NO_TRIM will be removed to make sure there's a border).
     * <p>
     * The control will optionally show either a status line or a tool bar.
     * At most one of <code>toolBarManager</code> or <code>statusFieldText</code> can be non-null.
     * </p>
     * <p>
     * <strong>Important:</strong>: Subclasses are required to call {@link #create()} at the end of their constructor.
     * </p>
     *
     * @param parentShell the parent of this control's shell
     * @param shellStyle style of this control's shell
     * @param statusFieldText the text to be used in the status field or <code>null</code> to hide the status field
     * @param toolBarManager the manager or <code>null</code> if toolbar is not desired
     *
     * @deprecated clients should use one of the public constructors
     */
    this(Shell parentShell, int shellStyle, String statusFieldText, ToolBarManager toolBarManager) {

        fFocusListeners= new ListenerList(ListenerList.IDENTITY);

        Assert.isTrue(statusFieldText is null || toolBarManager is null);
        fResizeHandleSize= -1;
        fToolBarManager= toolBarManager;

        if ((shellStyle & DWT.NO_TRIM) !is 0)
            shellStyle&= ~(DWT.NO_TRIM | DWT.SHELL_TRIM); // make sure we get the OS border but no other trims

        fResizable= (shellStyle & DWT.RESIZE) !is 0; // on GTK, Shell removes DWT.RESIZE if DWT.ON_TOP is set
        fShell= new Shell(parentShell, shellStyle);
        Display display= fShell.getDisplay();
        Color foreground= display.getSystemColor(DWT.COLOR_INFO_FOREGROUND);
        Color background= display.getSystemColor(DWT.COLOR_INFO_BACKGROUND);
        setColor(fShell, foreground, background);

        GridLayout layout= new GridLayout(1, false);
        layout.marginHeight= 0;
        layout.marginWidth= 0;
        layout.verticalSpacing= 0;
        fShell.setLayout(layout);

        fContentComposite= new Composite(fShell, DWT.NONE);
        fContentComposite.setLayoutData(new GridData(DWT.FILL, DWT.FILL, true, true));
        fContentComposite.setLayout(new FillLayout());
        setColor(fContentComposite, foreground, background);

        createStatusComposite(statusFieldText, toolBarManager, foreground, background);
    }

    private void createStatusComposite(String statusFieldText, ToolBarManager toolBarManager, Color foreground, Color background) {
        if (toolBarManager is null && statusFieldText is null)
            return;

        fStatusComposite= new Composite(fShell, DWT.NONE);
        GridData gridData= new GridData(DWT.FILL, DWT.BOTTOM, true, false);
        fStatusComposite.setLayoutData(gridData);
        GridLayout statusLayout= new GridLayout(1, false);
        statusLayout.marginHeight= 0;
        statusLayout.marginWidth= 0;
        statusLayout.verticalSpacing= 1;
        fStatusComposite.setLayout(statusLayout);

        fSeparator= new Label(fStatusComposite, DWT.SEPARATOR | DWT.HORIZONTAL);
        fSeparator.setLayoutData(new GridData(GridData.FILL_HORIZONTAL));

        if (statusFieldText !is null) {
            createStatusLabel(statusFieldText, foreground, background);
        } else {
            createToolBar(toolBarManager);
        }
    }

    private void createStatusLabel(String statusFieldText, Color foreground, Color background) {
        fStatusLabel= new Label(fStatusComposite, DWT.RIGHT);
        fStatusLabel.setLayoutData(new GridData(DWT.FILL, DWT.CENTER, true, false));
        fStatusLabel.setText(statusFieldText);

        FontData[] fontDatas= JFaceResources.getDialogFont().getFontData();
        for (int i= 0; i < fontDatas.length; i++) {
            fontDatas[i].setHeight(fontDatas[i].getHeight() * 9 / 10);
        }
        fStatusLabel.setFont(new Font(fStatusLabel.getDisplay(), fontDatas));

        fStatusLabel.setForeground(fStatusLabel.getDisplay().getSystemColor(DWT.COLOR_WIDGET_DARK_SHADOW));
        fStatusLabel.setBackground(background);
        setColor(fStatusComposite, foreground, background);
    }

    private void createToolBar(ToolBarManager toolBarManager) {
        Composite bars= new Composite(fStatusComposite, DWT.NONE);
        bars.setLayoutData(new GridData(DWT.FILL, DWT.FILL, false, false));

        GridLayout layout= new GridLayout(3, false);
        layout.marginHeight= 0;
        layout.marginWidth= 0;
        layout.horizontalSpacing= 0;
        layout.verticalSpacing= 0;
        bars.setLayout(layout);

        fToolBar= toolBarManager.createControl(bars);
        GridData gd= new GridData(DWT.BEGINNING, DWT.BEGINNING, false, false);
        fToolBar.setLayoutData(gd);

        Composite spacer= new Composite(bars, DWT.NONE);
        gd= new GridData(DWT.FILL, DWT.FILL, true, true);
        gd.widthHint= 0;
        gd.heightHint= 0;
        spacer.setLayoutData(gd);

        addMoveSupport(spacer);
        addResizeSupportIfNecessary(bars);
    }

    private void addResizeSupportIfNecessary(Composite bars) {
        // XXX: workarounds for
        // - https://bugs.eclipse.org/bugs/show_bug.cgi?id=219139 : API to add resize grip / grow box in lower right corner of shell
        // - https://bugs.eclipse.org/bugs/show_bug.cgi?id=23980 : platform specific shell resize behavior
        String platform= DWT.getPlatform();
        bool isWin= platform.equals("win32"); //$NON-NLS-1$
        if (!isWin && !platform.equals("gtk")) //$NON-NLS-1$
            return;

        Canvas resizer= new Canvas(bars, DWT.NONE);

        int size= getResizeHandleSize(bars);

        GridData data= new GridData(DWT.END, DWT.END, false, true);
        data.widthHint= size;
        data.heightHint= size;
        resizer.setLayoutData(data);
        resizer.addPaintListener(new class(isWin,resizer)  PaintListener {
            bool isWin_;
            Canvas resizer_;
            this(bool a, Canvas b ){
                isWin_=a;
                resizer_=b;
            }
            public void paintControl(PaintEvent e) {
                Point s= resizer_.getSize();
                int x= s.x - 2;
                int y= s.y - 2;
                int min= Math.min(x, y);
                if (isWin_) {
                    // draw dots
                    e.gc.setBackground(resizer_.getDisplay().getSystemColor(DWT.COLOR_WIDGET_HIGHLIGHT_SHADOW));
                    int end= min - 1;
                    for (int i= 0; i <= 2; i++)
                        for (int j= 0; j <= 2 - i; j++)
                            e.gc.fillRectangle(end - 4 * i, end - 4 * j, 2, 2);
                    end--;
                    e.gc.setBackground(resizer_.getDisplay().getSystemColor(DWT.COLOR_WIDGET_NORMAL_SHADOW));
                    for (int i= 0; i <= 2; i++)
                        for (int j= 0; j <= 2 - i; j++)
                            e.gc.fillRectangle(end - 4 * i, end - 4 * j, 2, 2);

                } else {
                    // draw diagonal lines
                    e.gc.setForeground(resizer_.getDisplay().getSystemColor(DWT.COLOR_WIDGET_NORMAL_SHADOW));
                    for (int i= 1; i < min; i+= 4) {
                        e.gc.drawLine(i, y, x, i);
                    }
                    e.gc.setForeground(resizer_.getDisplay().getSystemColor(DWT.COLOR_WIDGET_HIGHLIGHT_SHADOW));
                    for (int i= 2; i < min; i+= 4) {
                        e.gc.drawLine(i, y, x, i);
                    }
                }
            }
        });

        resizer.setCursor(new Cursor(resizer.getDisplay(), DWT.CURSOR_SIZESE));
        MouseAdapter resizeSupport= new class(resizer)  MouseAdapter {
            Canvas resizer_;
            this(Canvas a){
                resizer_=a;
            }
            private MouseMoveListener fResizeListener;

            public void mouseDown(MouseEvent e) {
                Point shellSize= fShell.getSize();
                int shellX= shellSize.x;
                int shellY= shellSize.y;
                Point mouseLoc= resizer_.toDisplay(e.x, e.y);
                int mouseX= mouseLoc.x;
                int mouseY= mouseLoc.y;
                fResizeListener= new class(shellX,shellY,mouseX,mouseY)  MouseMoveListener {
                    int shellX_;
                    int shellY_;
                    int mouseX_;
                    int mouseY_;
                    this(int a, int b, int c, int d ){
                        shellX_=a;
                        shellY_=b;
                        mouseX_=c;
                        mouseY_=d;
                    }
                    public void mouseMove(MouseEvent e2) {
                        Point mouseLoc2= resizer_.toDisplay(e2.x, e2.y);
                        int dx= mouseLoc2.x - mouseX_;
                        int dy= mouseLoc2.y - mouseY_;
                        setSize(shellX_ + dx, shellY_ + dy);
                    }
                };
                resizer_.addMouseMoveListener(fResizeListener);
            }

            public void mouseUp(MouseEvent e) {
                resizer_.removeMouseMoveListener(fResizeListener);
                fResizeListener= null;
            }
        };
        resizer.addMouseListener(resizeSupport);
    }

    private int getResizeHandleSize(Composite parent) {
        if (fResizeHandleSize is -1) {
            Slider sliderV= new Slider(parent, DWT.VERTICAL);
            Slider sliderH= new Slider(parent, DWT.HORIZONTAL);
            int width= sliderV.computeSize(DWT.DEFAULT, DWT.DEFAULT).x;
            int height= sliderH.computeSize(DWT.DEFAULT, DWT.DEFAULT).y;
            sliderV.dispose();
            sliderH.dispose();
            fResizeHandleSize= Math.min(width, height);
        }

        return fResizeHandleSize;
    }

    /**
     * Adds support to move the shell by dragging the given control.
     *
     * @param control the control that can be used to move the shell
     */
    private void addMoveSupport(Control control) {
        MouseAdapter moveSupport= new class(control)  MouseAdapter {
            private MouseMoveListener fMoveListener;
            Control control_;
            this(Control a){
                control_=a;
            }
            public void mouseDown(MouseEvent e) {
                Point shellLoc= fShell.getLocation();
                final int shellX= shellLoc.x;
                final int shellY= shellLoc.y;
                Point mouseLoc= control_.toDisplay(e.x, e.y);
                final int mouseX= mouseLoc.x;
                final int mouseY= mouseLoc.y;
                fMoveListener= new class()  MouseMoveListener {
                    public void mouseMove(MouseEvent e2) {
                        Point mouseLoc2= control_.toDisplay(e2.x, e2.y);
                        int dx= mouseLoc2.x - mouseX;
                        int dy= mouseLoc2.y - mouseY;
                        fShell.setLocation(shellX + dx, shellY + dy);
                    }
                };
                control_.addMouseMoveListener(fMoveListener);
            }

            public void mouseUp(MouseEvent e) {
                control_.removeMouseMoveListener(fMoveListener);
                fMoveListener= null;
            }
        };
        control.addMouseListener(moveSupport);
    }

    /**
     * Utility to set the foreground and the background color of the given
     * control
     *
     * @param control the control to modify
     * @param foreground the color to use for the foreground
     * @param background the color to use for the background
     */
    private static void setColor(Control control, Color foreground, Color background) {
        control.setForeground(foreground);
        control.setBackground(background);
    }

    /**
     * The shell of the popup window.
     *
     * @return the shell used for the popup window
     */
    protected final Shell getShell() {
        return fShell;
    }

    /**
     * The toolbar manager used to manage the toolbar, or <code>null</code> if
     * no toolbar is shown.
     *
     * @return the tool bar manager or <code>null</code>
     */
    protected final ToolBarManager getToolBarManager() {
        return fToolBarManager;
    }

    /**
     * Creates the content of this information control. Subclasses must call
     * this method at the end of their constructor(s).
     */
    protected final void create() {
        createContent(fContentComposite);
    }

    /**
     * Creates the content of the popup window.
     * <p>
     * Implementors will usually take over {@link Composite#getBackground()} and
     * {@link Composite#getForeground()} from <code>parent</code>.
     * </p>
     * <p>
     * Implementors are expected to consider {@link #isResizable()}: If
     * <code>true</code>, they should show scrollbars if their content may
     * exceed the size of the information control. If <code>false</code>,
     * they should never show scrollbars.
     * </p>
     * <p>
     * The given <code>parent</code> comes with a {@link FillLayout}.
     * Subclasses may set a different layout.
     * </p>
     *
     * @param parent the container of the content
     */
    protected abstract void createContent(Composite parent);

    /**
     * Sets the information to be presented by this information control.
     * <p>
     * The default implementation does nothing. Subclasses must either override this method
     * or implement {@link IInformationControlExtension2}.
     *
     * @param information the information to be presented
     *
     * @see dwtx.jface.text.IInformationControl#setInformation(java.lang.String)
     */
    public void setInformation(String information) {

    }

    /**
     * Returns whether the information control is resizable.
     *
     * @return <code>true</code> if the information control is resizable,
     *         <code>false</code> if it is not resizable.
     */
    public bool isResizable() {
        return fResizable;
    }

    /*
     * @see IInformationControl#setVisible(bool)
     */
    public void setVisible(bool visible) {
        if (fShell.isVisible() is visible)
            return;

        fShell.setVisible(visible);
    }

    /*
     * @see IInformationControl#dispose()
     */
    public void dispose() {
        if (fShell !is null && !fShell.isDisposed())
            fShell.dispose();
    }

    /*
     * @see IInformationControl#setSize(int, int)
     */
    public void setSize(int width, int height) {
        fShell.setSize(width, height);
    }

    /*
     * @see IInformationControl#setLocation(Point)
     */
    public void setLocation(Point location) {
        fShell.setLocation(location);
    }

    /*
     * @see IInformationControl#setSizeConstraints(int, int)
     */
    public void setSizeConstraints(int maxWidth, int maxHeight) {
        fSizeConstraints= new Point(maxWidth, maxHeight);
    }

    /**
     * Returns the size constraints.
     *
     * @return the size constraints or <code>null</code> if not set
     * @see #setSizeConstraints(int, int)
     */
    protected final Point getSizeConstraints() {
        return fSizeConstraints !is null ? Geometry.copy(fSizeConstraints) : null;
    }

    /*
     * @see IInformationControl#computeSizeHint()
     */
    public Point computeSizeHint() {
        // XXX: Verify whether this is a good default implementation. If yes, document it.
        Point constrains= getSizeConstraints();
        if (constrains is null)
            return fShell.computeSize(DWT.DEFAULT, DWT.DEFAULT, true);

        return fShell.computeSize(constrains.x, constrains.y, true);
    }

    /**
     * Computes the trim (status text and tool bar are considered as trim).
     * Subclasses can extend this method to add additional trim (e.g. scroll
     * bars for resizable information controls).
     *
     * @see dwtx.jface.text.IInformationControlExtension3#computeTrim()
     */
    public Rectangle computeTrim() {
        Rectangle trim= fShell.computeTrim(0, 0, 0, 0);

        if (fStatusComposite !is null)
            trim.height+= fStatusComposite.computeSize(DWT.DEFAULT, DWT.DEFAULT).y;

        return trim;
    }

    /*
     * @see dwtx.jface.text.IInformationControlExtension3#getBounds()
     */
    public Rectangle getBounds() {
        return fShell.getBounds();
    }

    /**
     * {@inheritDoc}
     * <p>
     * The default implementation always returns <code>false</code>.
     * </p>
     * @see dwtx.jface.text.IInformationControlExtension3#restoresLocation()
     */
    public bool restoresLocation() {
        return false;
    }

    /**
     * {@inheritDoc}
     * <p>
     * The default implementation always returns <code>false</code>.
     * </p>
     * @see dwtx.jface.text.IInformationControlExtension3#restoresSize()
     */
    public bool restoresSize() {
        return false;
    }

    /*
     * @see IInformationControl#addDisposeListener(DisposeListener)
     */
    public void addDisposeListener(DisposeListener listener) {
        fShell.addDisposeListener(listener);
    }

    /*
     * @see IInformationControl#removeDisposeListener(DisposeListener)
     */
    public void removeDisposeListener(DisposeListener listener) {
        fShell.removeDisposeListener(listener);
    }

    /*
     * @see IInformationControl#setForegroundColor(Color)
     */
    public void setForegroundColor(Color foreground) {
        fContentComposite.setForeground(foreground);
    }

    /*
     * @see IInformationControl#setBackgroundColor(Color)
     */
    public void setBackgroundColor(Color background) {
        fContentComposite.setBackground(background);
    }

    /**
     * {@inheritDoc}
     * This method is not intended to be overridden by subclasses.
     */
    public bool isFocusControl() {
        return fShell.getDisplay().getActiveShell() is fShell;
    }

    /**
     * This default implementation sets the focus on the popup shell.
     * Subclasses can override or extend.
     *
     * @see IInformationControl#setFocus()
     */
    public void setFocus() {
        bool focusTaken= fShell.setFocus();
        if (!focusTaken)
            fShell.forceFocus();
    }

    /**
     * {@inheritDoc}
     * This method is not intended to be overridden by subclasses.
     */
    public void addFocusListener(FocusListener listener) {
        if (fFocusListeners.isEmpty()) {
            fShellListener= new class()  Listener {

                public void handleEvent(Event event) {
                    Object[] listeners= fFocusListeners.getListeners();
                    for (int i= 0; i < listeners.length; i++) {
                        FocusListener focusListener= cast(FocusListener)listeners[i];
                        if (event.type is DWT.Activate) {
                            focusListener.focusGained(new FocusEvent(event));
                        } else {
                            focusListener.focusLost(new FocusEvent(event));
                        }
                    }
                }
            };
            fShell.addListener(DWT.Deactivate, fShellListener);
            fShell.addListener(DWT.Activate, fShellListener);
        }
        fFocusListeners.add(cast(Object)listener);
    }

    /**
     * {@inheritDoc}
     * This method is not intended to be overridden by subclasses.
     */
    public void removeFocusListener(FocusListener listener) {
        fFocusListeners.remove(cast(Object)listener);
        if (fFocusListeners.isEmpty()) {
            fShell.removeListener(DWT.Activate, fShellListener);
            fShell.removeListener(DWT.Deactivate, fShellListener);
            fShellListener= null;
        }
    }

    /**
     * Sets the text of the status field.
     * <p>
     * The default implementation currently only updates the status field when
     * the popup shell is not visible. The status field can currently only be
     * shown if the information control has been created with a non-null status
     * field text.
     * </p>
     *
     * @param statusFieldText the text to be used in the optional status field
     *        or <code>null</code> if the status field should be hidden
     *
     * @see dwtx.jface.text.IInformationControlExtension4#setStatusText(java.lang.String)
     */
    public void setStatusText(String statusFieldText) {
        if (fStatusLabel !is null && ! getShell().isVisible()) {
            if (statusFieldText is null ) {
                fStatusComposite.setVisible(false);
            } else {
                fStatusLabel.setText(statusFieldText);
                fStatusComposite.setVisible(true);
            }
        }
    }

    /*
     * @see dwtx.jface.text.IInformationControlExtension5#containsControl(dwt.widgets.Control)
     */
    public bool containsControl(Control control) {
        do {
            if (control is fShell)
                return true;
            if (cast(Shell)control )
                return false;
            control= control.getParent();
        } while (control !is null);
        return false;
    }

    /*
     * @see dwtx.jface.text.IInformationControlExtension5#isVisible()
     */
    public bool isVisible() {
        return fShell !is null && !fShell.isDisposed() && fShell.isVisible();
    }

    /**
     * {@inheritDoc}
     * This default implementation returns <code>null</code>. Subclasses may override.
     */
    public IInformationControlCreator getInformationPresenterControlCreator() {
        return null;
    }

    /**
     * Computes the size constraints based on the
     * {@link JFaceResources#getDialogFont() dialog font}. Subclasses can
     * override or extend.
     *
     * @see dwtx.jface.text.IInformationControlExtension5#computeSizeConstraints(int, int)
     */
    public Point computeSizeConstraints(int widthInChars, int heightInChars) {
        GC gc= new GC(fContentComposite);
        gc.setFont(JFaceResources.getDialogFont());
        int width= gc.getFontMetrics().getAverageCharWidth();
        int height= gc.getFontMetrics().getHeight();
        gc.dispose();

        return new Point(widthInChars * width, heightInChars * height);
    }

}
