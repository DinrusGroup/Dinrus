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
module dwtx.jface.text.source.projection.SourceViewerInformationControl;

import dwtx.jface.text.source.projection.ProjectionViewer; // packageimport
import dwtx.jface.text.source.projection.ProjectionSupport; // packageimport
import dwtx.jface.text.source.projection.IProjectionPosition; // packageimport
import dwtx.jface.text.source.projection.AnnotationBag; // packageimport
import dwtx.jface.text.source.projection.ProjectionSummary; // packageimport
import dwtx.jface.text.source.projection.ProjectionAnnotationHover; // packageimport
import dwtx.jface.text.source.projection.ProjectionRulerColumn; // packageimport
import dwtx.jface.text.source.projection.ProjectionAnnotationModel; // packageimport
import dwtx.jface.text.source.projection.IProjectionListener; // packageimport
import dwtx.jface.text.source.projection.ProjectionAnnotation; // packageimport


import dwt.dwthelper.utils;




import dwt.DWT;
import dwt.custom.StyledText;
import dwt.events.DisposeEvent;
import dwt.events.DisposeListener;
import dwt.events.FocusListener;
import dwt.events.KeyEvent;
import dwt.events.KeyListener;
import dwt.graphics.Color;
import dwt.graphics.Font;
import dwt.graphics.FontData;
import dwt.graphics.GC;
import dwt.graphics.Point;
import dwt.graphics.Rectangle;
import dwt.layout.GridData;
import dwt.layout.GridLayout;
import dwt.widgets.Composite;
import dwt.widgets.Control;
import dwt.widgets.Display;
import dwt.widgets.Label;
import dwt.widgets.Shell;
import dwtx.jface.resource.JFaceResources;
import dwtx.jface.text.Document;
import dwtx.jface.text.IDocument;
import dwtx.jface.text.IInformationControl;
import dwtx.jface.text.IInformationControlCreator;
import dwtx.jface.text.IInformationControlExtension;
import dwtx.jface.text.IInformationControlExtension3;
import dwtx.jface.text.IInformationControlExtension5;
import dwtx.jface.text.source.SourceViewer;
import dwtx.jface.text.source.SourceViewerConfiguration;

/**
 * Source viewer based implementation of {@link dwtx.jface.text.IInformationControl}.
 * Displays information in a source viewer.
 *
 * @since 3.0
 */
class SourceViewerInformationControl : IInformationControl, IInformationControlExtension, IInformationControlExtension3, IInformationControlExtension5, DisposeListener {

    /** The control's shell */
    private Shell fShell;
    /** The control's text widget */
    private StyledText fText;
    /** The symbolic font name of the text font */
    private const String fSymbolicFontName;
    /** The text font (do not dispose!) */
    private Font fTextFont;
    /** The control's source viewer */
    private SourceViewer fViewer;
    /** The optional status field. */
    private Label fStatusField;
    /** The separator for the optional status field. */
    private Label fSeparator;
    /** The font of the optional status text label.*/
    private Font fStatusTextFont;
    /** The maximal widget width. */
    private int fMaxWidth;
    /** The maximal widget height. */
    private int fMaxHeight;


    /**
     * Creates a source viewer information control with the given shell as parent. The given shell
     * styles are applied to the created shell. The given styles are applied to the created styled
     * text widget. The text widget will be initialized with the given font. The status field will
     * contain the given text or be hidden.
     *
     * @param parent the parent shell
     * @param isResizable <code>true</code> if resizable
     * @param symbolicFontName the symbolic font name
     * @param statusFieldText the text to be used in the optional status field or <code>null</code>
     *            if the status field should be hidden
     */
    public this(Shell parent, bool isResizable, String symbolicFontName, String statusFieldText) {
        GridLayout layout;
        GridData gd;

        int shellStyle= DWT.TOOL | DWT.ON_TOP | (isResizable ? DWT.RESIZE : 0);
        int textStyle= isResizable ? DWT.V_SCROLL | DWT.H_SCROLL : DWT.NONE;

        fShell= new Shell(parent, DWT.NO_FOCUS | DWT.ON_TOP | shellStyle);
        Display display= fShell.getDisplay();

        Composite composite= fShell;
        layout= new GridLayout(1, false);
        layout.marginHeight= 0;
        layout.marginWidth= 0;
        composite.setLayout(layout);
        gd= new GridData(GridData.FILL_HORIZONTAL);
        composite.setLayoutData(gd);

        if (statusFieldText !is null) {
            composite= new Composite(composite, DWT.NONE);
            layout= new GridLayout(1, false);
            layout.marginHeight= 0;
            layout.marginWidth= 0;
            composite.setLayout(layout);
            gd= new GridData(GridData.FILL_BOTH);
            composite.setLayoutData(gd);
            composite.setForeground(display.getSystemColor(DWT.COLOR_INFO_FOREGROUND));
            composite.setBackground(display.getSystemColor(DWT.COLOR_INFO_BACKGROUND));
        }

        // Source viewer
        fViewer= new SourceViewer(composite, null, textStyle);
        fViewer.configure(new SourceViewerConfiguration());
        fViewer.setEditable(false);

        fText= fViewer.getTextWidget();
        gd= new GridData(GridData.BEGINNING | GridData.FILL_BOTH);
        fText.setLayoutData(gd);
        fText.setForeground(parent.getDisplay().getSystemColor(DWT.COLOR_INFO_FOREGROUND));
        fText.setBackground(parent.getDisplay().getSystemColor(DWT.COLOR_INFO_BACKGROUND));
        fSymbolicFontName= symbolicFontName;
        fTextFont= JFaceResources.getFont(symbolicFontName);
        fText.setFont(fTextFont);

        fText.addKeyListener(new class()  KeyListener {

            public void keyPressed(KeyEvent e)  {
                if (e.character is 0x1B) // ESC
                    fShell.dispose();
            }

            public void keyReleased(KeyEvent e) {}
        });

        // Status field
        if (statusFieldText !is null) {

            // Horizontal separator line
            fSeparator= new Label(composite, DWT.SEPARATOR | DWT.HORIZONTAL | DWT.LINE_DOT);
            fSeparator.setLayoutData(new GridData(GridData.FILL_HORIZONTAL));

            // Status field label
            fStatusField= new Label(composite, DWT.RIGHT);
            fStatusField.setText(statusFieldText);
            Font font= fStatusField.getFont();
            FontData[] fontDatas= font.getFontData();
            for (int i= 0; i < fontDatas.length; i++)
                fontDatas[i].setHeight(fontDatas[i].getHeight() * 9 / 10);
            fStatusTextFont= new Font(fStatusField.getDisplay(), fontDatas);
            fStatusField.setFont(fStatusTextFont);
            GridData gd2= new GridData(GridData.FILL_VERTICAL | GridData.FILL_HORIZONTAL | GridData.HORIZONTAL_ALIGN_BEGINNING | GridData.VERTICAL_ALIGN_BEGINNING);
            fStatusField.setLayoutData(gd2);

            // Regarding the color see bug 41128
            fStatusField.setForeground(display.getSystemColor(DWT.COLOR_WIDGET_DARK_SHADOW));

            fStatusField.setBackground(display.getSystemColor(DWT.COLOR_INFO_BACKGROUND));
        }

        addDisposeListener(this);
    }

    /**
     * @see dwtx.jface.text.IInformationControlExtension2#setInput(java.lang.Object)
     * @param input the input object
     */
    public void setInput(Object input) {
        if ( cast(ArrayWrapperString)input )
            setInformation(stringcast(input));
        else
            setInformation(null);
    }

    /*
     * @see IInformationControl#setInformation(String)
     */
    public void setInformation(String content) {
        if (content is null) {
            fViewer.setInput(null);
            return;
        }

        IDocument doc= new Document(content);
        fViewer.setInput(cast(Object)doc);
    }

    /*
     * @see IInformationControl#setVisible(bool)
     */
    public void setVisible(bool visible) {
            fShell.setVisible(visible);
    }

    /*
     * @see dwt.events.DisposeListener#widgetDisposed(dwt.events.DisposeEvent)
     */
    public void widgetDisposed(DisposeEvent event) {
        if (fStatusTextFont !is null && !fStatusTextFont.isDisposed())
            fStatusTextFont.dispose();

        fStatusTextFont= null;
        fTextFont= null;
        fShell= null;
        fText= null;
    }

    /*
     * @see dwtx.jface.text.IInformationControl#dispose()
     */
    public final void dispose() {
        if (fShell !is null && !fShell.isDisposed())
            fShell.dispose();
        else
            widgetDisposed(null);
    }

    /*
     * @see IInformationControl#setSize(int, int)
     */
    public void setSize(int width, int height) {

        if (fStatusField !is null) {
            GridData gd= cast(GridData)fViewer.getTextWidget().getLayoutData();
            Point statusSize= fStatusField.computeSize(DWT.DEFAULT, DWT.DEFAULT, true);
            Point separatorSize= fSeparator.computeSize(DWT.DEFAULT, DWT.DEFAULT, true);
            gd.heightHint= height - statusSize.y - separatorSize.y;
        }
        fShell.setSize(width, height);

        if (fStatusField !is null)
            fShell.pack(true);
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
        fMaxWidth= maxWidth;
        fMaxHeight= maxHeight;
    }

    /*
     * @see IInformationControl#computeSizeHint()
     */
    public Point computeSizeHint() {
        // compute the preferred size
        int x= DWT.DEFAULT;
        int y= DWT.DEFAULT;
        Point size= fShell.computeSize(x, y);
        if (size.x > fMaxWidth)
            x= fMaxWidth;
        if (size.y > fMaxHeight)
            y= fMaxHeight;

        // recompute using the constraints if the preferred size is larger than the constraints
        if (x !is DWT.DEFAULT || y !is DWT.DEFAULT)
            size= fShell.computeSize(x, y, false);

        return size;
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
        fText.setForeground(foreground);
    }

    /*
     * @see IInformationControl#setBackgroundColor(Color)
     */
    public void setBackgroundColor(Color background) {
        fText.setBackground(background);
    }

    /*
     * @see IInformationControl#isFocusControl()
     */
    public bool isFocusControl() {
        return fShell.getDisplay().getActiveShell() is fShell;
    }

    /*
     * @see IInformationControl#setFocus()
     */
    public void setFocus() {
        fShell.forceFocus();
        fText.setFocus();
    }

    /*
     * @see IInformationControl#addFocusListener(FocusListener)
     */
    public void addFocusListener(FocusListener listener) {
        fText.addFocusListener(listener);
    }

    /*
     * @see IInformationControl#removeFocusListener(FocusListener)
     */
    public void removeFocusListener(FocusListener listener) {
        fText.removeFocusListener(listener);
    }

    /*
     * @see IInformationControlExtension#hasContents()
     */
    public bool hasContents() {
        return fText.getCharCount() > 0;
    }

    /*
     * @see dwtx.jface.text.IInformationControlExtension3#computeTrim()
     * @since 3.4
     */
    public Rectangle computeTrim() {
        Rectangle trim= fShell.computeTrim(0, 0, 0, 0);
        addInternalTrim(trim);
        return trim;
    }

    /**
     * Adds the internal trimmings to the given trim of the shell.
     *
     * @param trim the shell's trim, will be updated
     * @since 3.4
     */
    private void addInternalTrim(Rectangle trim) {
        if (fStatusField !is null) {
            trim.height+= fSeparator.computeSize(DWT.DEFAULT, DWT.DEFAULT).y;
            trim.height+= fStatusField.computeSize(DWT.DEFAULT, DWT.DEFAULT).y;
        }
    }

    /*
     * @see dwtx.jface.text.IInformationControlExtension3#getBounds()
     * @since 3.4
     */
    public Rectangle getBounds() {
        return fShell.getBounds();
    }

    /*
     * @see dwtx.jface.text.IInformationControlExtension3#restoresLocation()
     * @since 3.4
     */
    public bool restoresLocation() {
        return false;
    }

    /*
     * @see dwtx.jface.text.IInformationControlExtension3#restoresSize()
     * @since 3.4
     */
    public bool restoresSize() {
        return false;
    }

    /*
     * @see dwtx.jface.text.IInformationControlExtension5#getInformationPresenterControlCreator()
     * @since 3.4
     */
    public IInformationControlCreator getInformationPresenterControlCreator() {
        return new class()  IInformationControlCreator {
            public IInformationControl createInformationControl(Shell parent) {
                return new SourceViewerInformationControl(parent, true, fSymbolicFontName, null);
            }
        };
    }

    /*
     * @see dwtx.jface.text.IInformationControlExtension5#containsControl(dwt.widgets.Control)
     * @since 3.4
     */
    public bool containsControl(Control control) {
        do {
            if (control is fShell)
                return true;
            if ( cast(Shell)control )
                return false;
            control= control.getParent();
        } while (control !is null);
        return false;
    }

    /*
     * @see dwtx.jface.text.IInformationControlExtension5#isVisible()
     * @since 3.4
     */
    public bool isVisible() {
        return fShell !is null && !fShell.isDisposed() && fShell.isVisible();
    }

    /*
     * @see dwtx.jface.text.IInformationControlExtension5#computeSizeConstraints(int, int)
     */
    public Point computeSizeConstraints(int widthInChars, int heightInChars) {
        GC gc= new GC(fText);
        gc.setFont(fTextFont);
        int width= gc.getFontMetrics().getAverageCharWidth();
        int height = gc.getFontMetrics().getHeight();
        gc.dispose();

        return new Point (widthInChars * width, heightInChars * height);
    }
}
