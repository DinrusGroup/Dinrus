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
module dwtx.jface.text.hyperlink.MultipleHyperlinkPresenter;

import dwtx.jface.text.hyperlink.IHyperlinkPresenterExtension; // packageimport
import dwtx.jface.text.hyperlink.HyperlinkManager; // packageimport
import dwtx.jface.text.hyperlink.URLHyperlink; // packageimport
import dwtx.jface.text.hyperlink.IHyperlinkDetectorExtension2; // packageimport
import dwtx.jface.text.hyperlink.IHyperlinkDetector; // packageimport
import dwtx.jface.text.hyperlink.IHyperlinkPresenter; // packageimport
import dwtx.jface.text.hyperlink.URLHyperlinkDetector; // packageimport
import dwtx.jface.text.hyperlink.DefaultHyperlinkPresenter; // packageimport
import dwtx.jface.text.hyperlink.AbstractHyperlinkDetector; // packageimport
import dwtx.jface.text.hyperlink.IHyperlinkDetectorExtension; // packageimport
import dwtx.jface.text.hyperlink.HyperlinkMessages; // packageimport
import dwtx.jface.text.hyperlink.IHyperlink; // packageimport

import dwt.dwthelper.utils;

import dwt.DWT;
import dwt.events.KeyAdapter;
import dwt.events.KeyEvent;
import dwt.events.KeyListener;
import dwt.events.MouseAdapter;
import dwt.events.MouseEvent;
import dwt.events.MouseMoveListener;
import dwt.events.SelectionAdapter;
import dwt.events.SelectionEvent;
import dwt.events.ShellAdapter;
import dwt.events.ShellEvent;
import dwt.graphics.Color;
import dwt.graphics.Point;
import dwt.graphics.RGB;
import dwt.graphics.Rectangle;
import dwt.layout.GridLayout;
import dwt.widgets.Composite;
import dwt.widgets.Control;
import dwt.widgets.Display;
import dwt.widgets.Event;
import dwt.widgets.Listener;
import dwt.widgets.Shell;
import dwt.widgets.Table;
import dwt.widgets.TableItem;
import dwtx.jface.preference.IPreferenceStore;
import dwtx.jface.text.AbstractInformationControl;
import dwtx.jface.text.AbstractInformationControlManager;
import dwtx.jface.text.IInformationControl;
import dwtx.jface.text.IInformationControlCreator;
import dwtx.jface.text.IInformationControlExtension2;
import dwtx.jface.text.IInformationControlExtension3;
import dwtx.jface.text.IRegion;
import dwtx.jface.text.ITextHover;
import dwtx.jface.text.ITextHoverExtension;
import dwtx.jface.text.ITextViewer;
import dwtx.jface.text.IWidgetTokenKeeper;
import dwtx.jface.text.IWidgetTokenKeeperExtension;
import dwtx.jface.text.IWidgetTokenOwner;
import dwtx.jface.text.IWidgetTokenOwnerExtension;
import dwtx.jface.text.JFaceTextUtil;
import dwtx.jface.text.Region;
import dwtx.jface.util.Geometry;
import dwtx.jface.viewers.ColumnLabelProvider;
import dwtx.jface.viewers.IStructuredContentProvider;
import dwtx.jface.viewers.TableViewer;
import dwtx.jface.viewers.Viewer;


/**
 * A hyperlink presenter capable of showing multiple hyperlinks in a hover.
 *
 * @since 3.4
 */
public class MultipleHyperlinkPresenter : DefaultHyperlinkPresenter {

    /**
     * An information control capable of showing a list of hyperlinks. The hyperlinks can be opened.
     */
    private static class LinkListInformationControl : AbstractInformationControl , IInformationControlExtension2 {

        private static final class LinkContentProvider : IStructuredContentProvider {

            /*
             * @see dwtx.jface.viewers.IStructuredContentProvider#getElements(java.lang.Object)
             */
            public Object[] getElements(Object inputElement) {
                return arrayFromObject!(Object)( inputElement);
            }

            /*
             * @see dwtx.jface.viewers.IContentProvider#dispose()
             */
            public void dispose() {
            }

            /*
             * @see dwtx.jface.viewers.IContentProvider#inputChanged(dwtx.jface.viewers.Viewer, java.lang.Object, java.lang.Object)
             */
            public void inputChanged(Viewer viewer, Object oldInput, Object newInput) {
            }
        }

        private static final class LinkLabelProvider : ColumnLabelProvider {
            /*
             * @see dwtx.jface.viewers.ColumnLabelProvider#getText(java.lang.Object)
             */
            public String getText(Object element) {
                IHyperlink link= cast(IHyperlink)element;
                String text= link.getHyperlinkText();
                if (text !is null)
                    return text;
                return HyperlinkMessages.getString("LinkListInformationControl.unknownLink"); //$NON-NLS-1$
            }
        }

        private const MultipleHyperlinkHoverManager fManager;

        private IHyperlink[] fInput;
        private Composite fParent;
        private Table fTable;

        private Color fForegroundColor;
        private Color fBackgroundColor;


        /**
         * Creates a link list information control with the given shell as parent.
         *
         * @param parentShell the parent shell
         * @param manager the hover manager
         * @param foregroundColor the foreground color, must not be disposed
         * @param backgroundColor the background color, must not be disposed
         */
        public this(Shell parentShell, MultipleHyperlinkHoverManager manager, Color foregroundColor, Color backgroundColor) {
            super(parentShell, false);
            fManager= manager;
            fForegroundColor= foregroundColor;
            fBackgroundColor= backgroundColor;
            create();
        }

        /*
         * @see dwtx.jface.text.IInformationControl#setInformation(java.lang.String)
         */
        public void setInformation(String information) {
            //replaced by IInformationControlExtension2#setInput(java.lang.Object)
        }

        /*
         * @see dwtx.jface.text.IInformationControlExtension2#setInput(java.lang.Object)
         */
        public void setInput(Object input) {
            fInput= arrayFromObject!(IHyperlink)( input);
            deferredCreateContent(fParent);
        }

        /*
         * @see dwtx.jface.text.AbstractInformationControl#createContent(dwt.widgets.Composite)
         */
        protected void createContent(Composite parent) {
            fParent= parent;
            if ("win32".equals(DWT.getPlatform())) { //$NON-NLS-1$
                GridLayout layout= new GridLayout();
                layout.marginWidth= 0;
                layout.marginRight= 4;
                fParent.setLayout(layout);
            }
            fParent.setForeground(fForegroundColor);
            fParent.setBackground(fBackgroundColor);
        }

        /*
         * @see dwtx.jface.text.AbstractInformationControl#computeSizeHint()
         */
        public Point computeSizeHint() {
            Point preferedSize= getShell().computeSize(DWT.DEFAULT, DWT.DEFAULT, true);

            Point constraints= getSizeConstraints();
            if (constraints is null)
                return preferedSize;

            if (fTable.getVerticalBar() is null || fTable.getHorizontalBar() is null)
                return Geometry.min(constraints, preferedSize);

            int scrollBarWidth= fTable.getVerticalBar().getSize().x;
            int scrollBarHeight= fTable.getHorizontalBar().getSize().y;

            int width;
            if (preferedSize.y - scrollBarHeight <= constraints.y) {
                width= preferedSize.x - scrollBarWidth;
                fTable.getVerticalBar().setVisible(false);
            } else {
                width= Math.min(preferedSize.x, constraints.x);
            }

            int height;
            if (preferedSize.x - scrollBarWidth <= constraints.x) {
                height= preferedSize.y - scrollBarHeight;
                fTable.getHorizontalBar().setVisible(false);
            } else {
                height= Math.min(preferedSize.y, constraints.y);
            }

            return new Point(width, height);
        }

        private void deferredCreateContent(Composite parent) {
            fTable= new Table(parent, DWT.SINGLE | DWT.FULL_SELECTION);
            fTable.setLinesVisible(false);
            fTable.setHeaderVisible(false);
            fTable.setForeground(fForegroundColor);
            fTable.setBackground(fBackgroundColor);

            final TableViewer viewer= new TableViewer(fTable);
            viewer.setContentProvider(new LinkContentProvider());
            viewer.setLabelProvider(new LinkLabelProvider());
            viewer.setInput(new ArrayWrapperObject( arraycast!(Object)(fInput)));
            fTable.setSelection(0);

            registerTableListeners();

            getShell().addShellListener(new class()  ShellAdapter {

                /*
                 * @see dwt.events.ShellAdapter#shellActivated(dwt.events.ShellEvent)
                 */
                public void shellActivated(ShellEvent e) {
                    if (viewer.getTable().getSelectionCount() is 0) {
                        viewer.getTable().setSelection(0);
                    }

                    viewer.getTable().setFocus();
                }
            });
        }

        private void registerTableListeners() {

            fTable.addMouseMoveListener(new class()  MouseMoveListener {
                TableItem fLastItem= null;

                public void mouseMove(MouseEvent e) {
                    if (fTable.opEquals(e.getSource())) {
                        Object o= fTable.getItem(new Point(e.x, e.y));
                        if ( cast(TableItem)o ) {
                            TableItem item= cast(TableItem) o;
                            if (!o.opEquals(fLastItem)) {
                                fLastItem= cast(TableItem) o;
                                fTable.setSelection([ fLastItem ]);
                            } else if (e.y < fTable.getItemHeight() / 4) {
                                // Scroll up
                                int index= fTable.indexOf(item);
                                if (index > 0) {
                                    fLastItem= fTable.getItem(index - 1);
                                    fTable.setSelection([ fLastItem ]);
                                }
                            } else if (e.y > fTable.getBounds().height - fTable.getItemHeight() / 4) {
                                // Scroll down
                                int index= fTable.indexOf(item);
                                if (index < fTable.getItemCount() - 1) {
                                    fLastItem= fTable.getItem(index + 1);
                                    fTable.setSelection([ fLastItem ]);
                                }
                            }
                        }
                    }
                }
            });

            fTable.addSelectionListener(new class()  SelectionAdapter {
                public void widgetSelected(SelectionEvent e) {
                    openSelectedLink();
                }
            });

            fTable.addMouseListener(new class()  MouseAdapter {
                public void mouseUp(MouseEvent e) {
                    if (fTable.getSelectionCount() < 1)
                        return;

                    if (e.button !is 1)
                        return;

                    if (fTable.opEquals(e.getSource())) {
                        Object o= fTable.getItem(new Point(e.x, e.y));
                        TableItem selection= fTable.getSelection()[0];
                        if (selection.opEquals(o))
                            openSelectedLink();
                    }
                }
            });

            fTable.addKeyListener(new class()  KeyAdapter {
                public void keyPressed(KeyEvent e) {
                    if (e.keyCode is 0x0D) // return
                        openSelectedLink();
                }
            });
        }

        /*
         * @see dwtx.jface.text.IInformationControlExtension#hasContents()
         */
        public bool hasContents() {
            return true;
        }

        /**
         * Opens the currently selected link.
         */
        private void openSelectedLink() {
            TableItem selection= fTable.getSelection()[0];
            IHyperlink link= cast(IHyperlink)selection.getData();
            fManager.hideInformationControl();
            link.open();
        }
    }

    private class MultipleHyperlinkHover : ITextHover, ITextHoverExtension {

        /**
         * @see dwtx.jface.text.ITextHover#getHoverInfo(dwtx.jface.text.ITextViewer, dwtx.jface.text.IRegion)
         * @deprecated
         */
        public String getHoverInfo(ITextViewer textViewer, IRegion hoverRegion) {
            return null;
        }

        /*
         * @see dwtx.jface.text.ITextHover#getHoverRegion(dwtx.jface.text.ITextViewer, int)
         */
        public IRegion getHoverRegion(ITextViewer textViewer, int offset) {
            return fSubjectRegion;
        }

        /*
         * @see dwtx.jface.text.ITextHoverExtension2#getHoverInfo2(dwtx.jface.text.ITextViewer, dwtx.jface.text.IRegion)
         */
        public Object getHoverInfo2(ITextViewer textViewer, IRegion hoverRegion) {
            return new ArrayWrapperObject( arraycast!(Object)(fHyperlinks));
        }

        /*
         * @see dwtx.jface.text.ITextHoverExtension#getHoverControlCreator()
         */
        public IInformationControlCreator getHoverControlCreator() {
            return new class()  IInformationControlCreator {
                public IInformationControl createInformationControl(Shell parent) {
                    Color foregroundColor= fTextViewer.getTextWidget().getForeground();
                    Color backgroundColor= fTextViewer.getTextWidget().getBackground();
                    return new LinkListInformationControl(parent, fManager, foregroundColor, backgroundColor);
                }
            };
        }
    }

    private static class MultipleHyperlinkHoverManager : AbstractInformationControlManager , IWidgetTokenKeeper, IWidgetTokenKeeperExtension {

        private class Closer : IInformationControlCloser, Listener, KeyListener {

            private Control fSubjectControl;
            private Display fDisplay;
            private IInformationControl fControl;
            private Rectangle fSubjectArea;

            /*
             * @see dwtx.jface.text.AbstractInformationControlManager.IInformationControlCloser#setInformationControl(dwtx.jface.text.IInformationControl)
             */
            public void setInformationControl(IInformationControl control) {
                fControl= control;
            }

            /*
             * @see dwtx.jface.text.AbstractInformationControlManager.IInformationControlCloser#setSubjectControl(dwt.widgets.Control)
             */
            public void setSubjectControl(Control subject) {
                fSubjectControl= subject;
            }

            /*
             * @see dwtx.jface.text.AbstractInformationControlManager.IInformationControlCloser#start(dwt.graphics.Rectangle)
             */
            public void start(Rectangle subjectArea) {
                fSubjectArea= subjectArea;

                fDisplay= fSubjectControl.getDisplay();
                if (!fDisplay.isDisposed()) {
                    fDisplay.addFilter(DWT.FocusOut, this);
                    fDisplay.addFilter(DWT.MouseMove, this);
                    fTextViewer.getTextWidget().addKeyListener(this);
                }
            }

            /*
             * @see dwtx.jface.text.AbstractInformationControlManager.IInformationControlCloser#stop()
             */
            public void stop() {
                if (fDisplay !is null && !fDisplay.isDisposed()) {
                    fDisplay.removeFilter(DWT.FocusOut, this);
                    fDisplay.removeFilter(DWT.MouseMove, this);
                    fTextViewer.getTextWidget().removeKeyListener(this);
                }

                fSubjectArea= null;
            }

            /*
             * @see dwt.widgets.Listener#handleEvent(dwt.widgets.Event)
             */
            public void handleEvent(Event event) {
                switch (event.type) {
                    case DWT.FocusOut:
                        if (!fControl.isFocusControl())
                            disposeInformationControl();
                        break;
                    case DWT.MouseMove:
                        handleMouseMove(event);
                        break;
                    default:
                }
            }

            /**
             * Handle mouse movement events.
             *
             * @param event the event
             */
            private void handleMouseMove(Event event) {
                if (!(cast(Control)event.widget ))
                    return;

                if (fControl.isFocusControl())
                    return;

                Control eventControl= cast(Control) event.widget;

                //transform coordinates to subject control:
                Point mouseLoc= event.display.map(eventControl, fSubjectControl, event.x, event.y);

                if (fSubjectArea.contains(mouseLoc))
                    return;

                if (inKeepUpZone(mouseLoc.x, mouseLoc.y, (cast(IInformationControlExtension3) fControl).getBounds()))
                    return;

                hideInformationControl();
            }

            /**
             * Tests whether a given mouse location is within the keep-up zone.
             * The hover should not be hidden as long as the mouse stays inside this zone.
             *
             * @param x the x coordinate, relative to the <em>subject control</em>
             * @param y the y coordinate, relative to the <em>subject control</em>
             * @param controlBounds the bounds of the current control
             *
             * @return <code>true</code> iff the mouse event occurred in the keep-up zone
             */
            private bool inKeepUpZone(int x, int y, Rectangle controlBounds) {
                //  +-----------+
                //  |subjectArea|
                //  +-----------+
                //  |also keepUp|
                // ++-----------+-------+
                // | totalBounds        |
                // +--------------------+
                if (fSubjectArea.contains(x, y))
                    return true;

                Rectangle iControlBounds= fSubjectControl.getDisplay().map(null, fSubjectControl, controlBounds);
                Rectangle totalBounds= Geometry.copy(iControlBounds);
                if (totalBounds.contains(x, y))
                    return true;

                int keepUpY= fSubjectArea.y + fSubjectArea.height;
                Rectangle alsoKeepUp= new Rectangle(fSubjectArea.x, keepUpY, fSubjectArea.width, totalBounds.y - keepUpY);
                return alsoKeepUp.contains(x, y);
            }

            /*
             * @see dwt.events.KeyListener#keyPressed(dwt.events.KeyEvent)
             */
            public void keyPressed(KeyEvent e) {
            }

            /*
             * @see dwt.events.KeyListener#keyReleased(dwt.events.KeyEvent)
             */
            public void keyReleased(KeyEvent e) {
                hideInformationControl();
            }

        }

        /**
         * Priority of the hover managed by this manager.
         * Default value: One higher then for the hovers
         * managed by TextViewerHoverManager.
         */
        private static const int WIDGET_TOKEN_PRIORITY= 1;

        private const MultipleHyperlinkHover fHover;
        private const ITextViewer fTextViewer;
        private const MultipleHyperlinkPresenter fHyperlinkPresenter;
        private Closer fCloser;
        private bool fIsControlVisible;


        /**
         * Create a new MultipleHyperlinkHoverManager. The MHHM can show and hide
         * the given MultipleHyperlinkHover inside the given ITextViewer.
         *
         * @param hover the hover to manage
         * @param viewer the viewer to show the hover in
         * @param hyperlinkPresenter the hyperlink presenter using this manager to present hyperlinks
         */
        public this(MultipleHyperlinkHover hover, ITextViewer viewer, MultipleHyperlinkPresenter hyperlinkPresenter) {
            super(hover.getHoverControlCreator());

            fHover= hover;
            fTextViewer= viewer;
            fHyperlinkPresenter= hyperlinkPresenter;

            fCloser= new Closer();
            setCloser(fCloser);
            fIsControlVisible= false;
        }

        /*
         * @see dwtx.jface.text.AbstractInformationControlManager#computeInformation()
         */
        protected void computeInformation() {
            IRegion region= fHover.getHoverRegion(fTextViewer, -1);
            if (region is null) {
                setInformation(cast(Object)null, cast(Rectangle)null);
                return;
            }

            Rectangle area= JFaceTextUtil.computeArea(region, fTextViewer);
            if (area is null || area.isEmpty()) {
                setInformation(cast(Object)null, cast(Rectangle)null);
                return;
            }

            Object information= fHover.getHoverInfo2(fTextViewer, region);
            setCustomInformationControlCreator(fHover.getHoverControlCreator());
            setInformation(information, area);
        }

        /*
         * @see dwtx.jface.text.AbstractInformationControlManager#computeInformationControlLocation(dwt.graphics.Rectangle, dwt.graphics.Point)
         */
        protected Point computeInformationControlLocation(Rectangle subjectArea, Point controlSize) {
            Point result= super.computeInformationControlLocation(subjectArea, controlSize);

            Point cursorLocation= fTextViewer.getTextWidget().getDisplay().getCursorLocation();
            if (cursorLocation.x <= result.x + controlSize.x)
                return result;

            result.x= cursorLocation.x + 20 - controlSize.x;
            return result;
        }

        /*
         * @see dwtx.jface.text.AbstractInformationControlManager#showInformationControl(dwt.graphics.Rectangle)
         */
        protected void showInformationControl(Rectangle subjectArea) {
            if ( cast(IWidgetTokenOwnerExtension)fTextViewer ) {
                if ((cast(IWidgetTokenOwnerExtension) fTextViewer).requestWidgetToken(this, WIDGET_TOKEN_PRIORITY))
                    super.showInformationControl(subjectArea);
            } else if ( cast(IWidgetTokenOwner)fTextViewer ) {
                if ((cast(IWidgetTokenOwner) fTextViewer).requestWidgetToken(this))
                    super.showInformationControl(subjectArea);
            } else {
                super.showInformationControl(subjectArea);
            }

            fIsControlVisible= true;
        }

        /*
         * @see dwtx.jface.text.AbstractInformationControlManager#hideInformationControl()
         */
        protected void hideInformationControl() {
            super.hideInformationControl();

            if ( cast(IWidgetTokenOwner)fTextViewer ) {
                (cast(IWidgetTokenOwner) fTextViewer).releaseWidgetToken(this);
            }

            fIsControlVisible= false;
            fHyperlinkPresenter.hideHyperlinks();
        }

        /*
         * @see dwtx.jface.text.AbstractInformationControlManager#disposeInformationControl()
         */
        public void disposeInformationControl() {
            super.disposeInformationControl();

            if ( cast(IWidgetTokenOwner)fTextViewer ) {
                (cast(IWidgetTokenOwner) fTextViewer).releaseWidgetToken(this);
            }

            fIsControlVisible= false;
            fHyperlinkPresenter.hideHyperlinks();
        }

        /*
         * @see dwtx.jface.text.IWidgetTokenKeeper#requestWidgetToken(dwtx.jface.text.IWidgetTokenOwner)
         */
        public bool requestWidgetToken(IWidgetTokenOwner owner) {
            hideInformationControl();
            return true;
        }

        /*
         * @see dwtx.jface.text.IWidgetTokenKeeperExtension#requestWidgetToken(dwtx.jface.text.IWidgetTokenOwner, int)
         */
        public bool requestWidgetToken(IWidgetTokenOwner owner, int priority) {
            if (priority < WIDGET_TOKEN_PRIORITY)
                return false;

            hideInformationControl();
            return true;
        }

        /*
         * @see dwtx.jface.text.IWidgetTokenKeeperExtension#setFocus(dwtx.jface.text.IWidgetTokenOwner)
         */
        public bool setFocus(IWidgetTokenOwner owner) {
            return false;
        }

        /**
         * Returns <code>true</code> if the information control managed by
         * this manager is visible, <code>false</code> otherwise.
         *
         * @return <code>true</code> if information control is visible
         */
        public bool isInformationControlVisible() {
            return fIsControlVisible;
        }
    }

    private ITextViewer fTextViewer;

    private IHyperlink[] fHyperlinks;
    private Region fSubjectRegion;
    private MultipleHyperlinkHoverManager fManager;

    /**
     * Creates a new multiple hyperlink presenter which uses
     * {@link #HYPERLINK_COLOR} to read the color from the given preference store.
     *
     * @param store the preference store
     */
    public this(IPreferenceStore store) {
        super(store);
    }

    /**
     * Creates a new multiple hyperlink presenter.
     *
     * @param color the hyperlink color, to be disposed by the caller
     */
    public this(RGB color) {
        super(color);
    }

    /*
     * @see dwtx.jface.text.hyperlink.DefaultHyperlinkPresenter#install(dwtx.jface.text.ITextViewer)
     */
    public void install(ITextViewer viewer) {
        super.install(viewer);
        fTextViewer= viewer;

        fManager= new MultipleHyperlinkHoverManager(new MultipleHyperlinkHover(), fTextViewer, this);
        fManager.install(viewer.getTextWidget());
        fManager.setSizeConstraints(100, 12, false, true);
    }

    /*
     * @see dwtx.jface.text.hyperlink.DefaultHyperlinkPresenter#uninstall()
     */
    public void uninstall() {
        super.uninstall();

        if (fTextViewer !is null) {
            fManager.dispose();

            fTextViewer= null;
        }
    }

    /*
     * @see dwtx.jface.text.hyperlink.DefaultHyperlinkPresenter#canShowMultipleHyperlinks()
     */
    public bool canShowMultipleHyperlinks() {
        return true;
    }

    /*
     * @see dwtx.jface.text.hyperlink.DefaultHyperlinkPresenter#canHideHyperlinks()
     */
    public bool canHideHyperlinks() {
        return !fManager.isInformationControlVisible();
    }

    /*
     * @see dwtx.jface.text.hyperlink.DefaultHyperlinkPresenter#hideHyperlinks()
     */
    public void hideHyperlinks() {
        super.hideHyperlinks();

        fHyperlinks= null;
    }

    /*
     * @see dwtx.jface.text.hyperlink.DefaultHyperlinkPresenter#showHyperlinks(dwtx.jface.text.hyperlink.IHyperlink[])
     */
    public void showHyperlinks(IHyperlink[] hyperlinks) {
        super.showHyperlinks([ hyperlinks[0] ]);

        fSubjectRegion= null;
        fHyperlinks= hyperlinks;

        if (hyperlinks.length is 1)
            return;

        int start= hyperlinks[0].getHyperlinkRegion().getOffset();
        int end= start + hyperlinks[0].getHyperlinkRegion().getLength();

        for (int i= 1; i < hyperlinks.length; i++) {
            int hstart= hyperlinks[i].getHyperlinkRegion().getOffset();
            int hend= hstart + hyperlinks[i].getHyperlinkRegion().getLength();

            start= Math.min(start, hstart);
            end= Math.max(end, hend);
        }

        fSubjectRegion= new Region(start, end - start);

        fManager.showInformation();
    }
}
